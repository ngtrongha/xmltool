import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:xml/xml.dart';
import 'package:xmltool/config/standards/xml_definitions.dart';
import 'package:xmltool/core/errors/failures.dart';
import 'package:xmltool/core/logging/app_talker.dart';
import 'package:xmltool/domain/entities/file_ho_so.dart';
import 'package:xmltool/domain/entities/ho_so.dart';
import 'package:xmltool/domain/entities/xml_envelope.dart';
import 'package:xmltool/domain/entities/xml_record.dart';
import 'package:xmltool/domain/repositories/xml_file_repository.dart';
import 'package:xmltool/infrastructure/xml/base64_decoder.dart';
import 'package:xmltool/infrastructure/xml/xml_record_parser.dart';
import 'package:xmltool/infrastructure/xml/xml_type_detector.dart';

/// Robust XML Parser supporting QĐ 3176/4750/130 standards in both Plain XML and Base64 formats.
class BHYTXmlParser implements XmlFileRepository {
  @override
  Future<XmlEnvelope> parseFile(File file) async {
    if (!await file.exists()) {
      throw XmlParseFailure('Tệp không tồn tại: ${file.path}');
    }

    try {
      final bytes = await file.readAsBytes();
      final content = utf8.decode(bytes);
      final hash = sha256.convert(bytes).toString();

      return _parseXmlContent(
        content,
        filePath: file.path,
        fileHash: hash,
        fileSizeBytes: bytes.length,
      );
    } catch (e, st) {
      appTalker.handle(e, st, 'Error parsing XML file: ${file.path}');
      if (e is XmlParseFailure) rethrow;
      throw XmlParseFailure('Lỗi đọc tệp XML: $e', e);
    }
  }

  @override
  Future<XmlEnvelope> parseString(String content, {String? filePath}) async {
    try {
      final bytes = utf8.encode(content);
      final hash = sha256.convert(bytes).toString();

      return _parseXmlContent(
        content,
        filePath: filePath,
        fileHash: hash,
        fileSizeBytes: bytes.length,
      );
    } catch (e, st) {
      appTalker.handle(e, st, 'Error parsing XML string');
      if (e is XmlParseFailure) rethrow;
      throw XmlParseFailure('Lỗi phân tích XML: $e', e);
    }
  }

  XmlEnvelope _parseXmlContent(
    String content, {
    String? filePath,
    String? fileHash,
    int fileSizeBytes = 0,
  }) {
    final XmlDocument doc;
    try {
      doc = XmlDocument.parse(content);
    } catch (e) {
      throw XmlParseFailure('Cú pháp XML không hợp lệ: $e');
    }

    final root = doc.rootElement;
    final rootName = root.name.local.toUpperCase();

    if (rootName != 'GIAMDINHHS') {
      throw XmlParseFailure(
        'Thẻ gốc không đúng chuẩn: mong đợi <GIAMDINHHS>, nhận được <$rootName>',
      );
    }

    // 1. THONGTINDONVI
    final thongTinDonVi = root.findElements('THONGTINDONVI').firstOrNull;
    final maCskcb = thongTinDonVi?.findElements('MACSKCB').firstOrNull?.innerText.trim() ?? '';

    // 2. THONGTINHOSO
    final thongTinHoSo = root.findElements('THONGTINHOSO').firstOrNull;
    final ngayLap = thongTinHoSo?.findElements('NGAYLAP').firstOrNull?.innerText.trim() ?? '';
    final soLuongHoSoStr = thongTinHoSo?.findElements('SOLUONGHOSO').firstOrNull?.innerText.trim() ?? '1';
    final soLuongHoSo = int.tryParse(soLuongHoSoStr) ?? 1;

    // 3. DANHSACHHOSO
    final danhSachHoSoElem = thongTinHoSo?.findElements('DANHSACHHOSO').firstOrNull;
    final hoSoElements = danhSachHoSoElem?.findElements('HOSO') ?? const <XmlElement>[];

    final hoSoList = <HoSo>[];

    for (final hoSoElem in hoSoElements) {
      final hoSo = _parseHoSo(hoSoElem);
      hoSoList.add(hoSo);
    }

    return XmlEnvelope(
      maCskcb: maCskcb,
      ngayLap: ngayLap,
      soLuongHoSo: soLuongHoSo,
      danhSachHoSo: hoSoList,
      filePath: filePath,
      fileHash: fileHash,
      fileSizeBytes: fileSizeBytes,
    );
  }

  HoSo _parseHoSo(XmlElement hoSoElem) {
    final fileHoSoElements = hoSoElem.findElements('FILEHOSO');
    final fileList = <FileHoSo>[];
    String detectedMaLk = '';

    for (final fileHoSoElem in fileHoSoElements) {
      final fileHoSo = _parseFileHoSo(fileHoSoElem);
      if (fileHoSo != null) {
        fileList.add(fileHoSo);
        if (detectedMaLk.isEmpty && fileHoSo.records.isNotEmpty) {
          detectedMaLk = fileHoSo.records.first.maLk;
        }
      }
    }

    return HoSo(
      maLk: detectedMaLk,
      fileList: fileList,
    );
  }

  FileHoSo? _parseFileHoSo(XmlElement fileHoSoElem) {
    final loaiHoSoStr = fileHoSoElem.findElements('LOAIHOSO').firstOrNull?.innerText.trim();
    final noiDungElem = fileHoSoElem.findElements('NOIDUNGFILE').firstOrNull;

    if (noiDungElem == null) return null;

    final XmlType? xmlType = XmlTypeDetector.detectFromLoaiHoSo(loaiHoSoStr);
    if (xmlType == null) {
      appTalker.warning('Unknown LOAIHOSO: $loaiHoSoStr');
      return null;
    }

    final rawText = noiDungElem.innerText;
    final records = <XmlRecord>[];
    final bool isBase64;

    if (noiDungElem.childElements.isNotEmpty) {
      isBase64 = false;
      for (final child in noiDungElem.childElements) {
        _extractRecordsFromElement(child, xmlType, records);
      }
    } else {
      isBase64 = XmlBase64Helper.isBase64(rawText);
      if (isBase64) {
        // Decode Base64 string into XML
        final decodedXml = XmlBase64Helper.decodeIfNeeded(rawText);
        try {
          final innerDoc = XmlDocument.parse(decodedXml);
          _extractRecordsFromElement(innerDoc.rootElement, xmlType, records);
        } catch (e) {
          appTalker.error('Failed to parse decoded Base64 content for $xmlType: $e');
        }
      } else {
        // Might be plain text XML inside NOIDUNGFILE
        try {
          final innerDoc = XmlDocument.parse(rawText);
          _extractRecordsFromElement(innerDoc.rootElement, xmlType, records);
        } catch (_) {}
      }
    }

    return FileHoSo(
      xmlType: xmlType,
      records: records,
      rawContent: rawText,
      isBase64Encoded: isBase64,
    );
  }

  void _extractRecordsFromElement(
    XmlElement rootContainer,
    XmlType xmlType,
    List<XmlRecord> outRecords,
  ) {
    final recordTagName = xmlType.recordElement.toUpperCase();

    // Check if the rootContainer itself is the record (e.g. XML1 <TONG_HOP>)
    if (rootContainer.name.local.toUpperCase() == recordTagName && xmlType.isSingle) {
      final rec = XmlRecordParser.parseRecord(rootContainer, xmlType, index: 1);
      outRecords.add(rec);
      return;
    }

    // Look for child elements matching record element name (e.g. <CHI_TIET_THUOC>, <CHI_TIET_DVKT>)
    final matchingChildren = rootContainer.findAllElements(xmlType.recordElement);
    var index = 1;
    for (final child in matchingChildren) {
      final rec = XmlRecordParser.parseRecord(child, xmlType, index: index++);
      outRecords.add(rec);
    }

    // Fallback: If no matching children found by exact tag name and this is a single record
    if (outRecords.isEmpty && xmlType.isSingle) {
      final rec = XmlRecordParser.parseRecord(rootContainer, xmlType, index: 1);
      outRecords.add(rec);
    }
  }
}
