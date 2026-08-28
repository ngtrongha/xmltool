import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:xmltool/application/services/compare_service.dart';
import 'package:xmltool/application/services/mau09_mapping_service.dart';
import 'package:xmltool/application/services/validation_service.dart';
import 'package:xmltool/application/usecases/generate_mau09_usecase.dart';
import 'package:xmltool/config/standards/xml_definitions.dart';
import 'package:xmltool/infrastructure/repositories/in_memory_repositories.dart';
import 'package:xmltool/infrastructure/xml/xml_parser.dart';

void main() {
  group('Multi-HOSO & Base64 XML Tests', () {
    late BHYTXmlParser parser;
    late CompareService compareService;
    late GenerateMau09UseCase generateMau09UseCase;

    setUp(() {
      parser = BHYTXmlParser();
      compareService = CompareService();
      generateMau09UseCase = GenerateMau09UseCase(
        mappingService: Mau09MappingService(),
        validationService: ValidationService(),
        repository: InMemoryMau09Repository(),
      );
    });

    test('Parses and reconciles Multi-HOSO envelopes (2 claims)', () async {
      const multiHosoXmlOld = '''<?xml version="1.0" encoding="utf-8"?>
<GIAMDINHHS>
  <THONGTINDONVI><MACSKCB>56001</MACSKCB></THONGTINDONVI>
  <THONGTINHOSO>
    <SOLUONGHOSO>2</SOLUONGHOSO>
    <DANHSACHHOSO>
      <HOSO>
        <FILEHOSO>
          <LOAIHOSO>XML1</LOAIHOSO>
          <NOIDUNGFILE><TONG_HOP><MA_LK>HS01</MA_LK><HO_TEN>Nguyễn Văn A</HO_TEN><MA_THE_BHYT>DN456001</MA_THE_BHYT><T_TONGCHI_BV>100000</T_TONGCHI_BV></TONG_HOP></NOIDUNGFILE>
        </FILEHOSO>
        <FILEHOSO>
          <LOAIHOSO>XML2</LOAIHOSO>
          <NOIDUNGFILE><DSACH_CHI_TIET_THUOC><CHI_TIET_THUOC><MA_LK>HS01</MA_LK><STT>1</STT><MA_THUOC>T01</MA_THUOC><SO_LUONG>2</SO_LUONG><DON_GIA>50000</DON_GIA><THANH_TIEN>100000</THANH_TIEN></CHI_TIET_THUOC></DSACH_CHI_TIET_THUOC></NOIDUNGFILE>
        </FILEHOSO>
      </HOSO>
      <HOSO>
        <FILEHOSO>
          <LOAIHOSO>XML1</LOAIHOSO>
          <NOIDUNGFILE><TONG_HOP><MA_LK>HS02</MA_LK><HO_TEN>Trần Thị B</HO_TEN><MA_THE_BHYT>GD456002</MA_THE_BHYT><T_TONGCHI_BV>200000</T_TONGCHI_BV></TONG_HOP></NOIDUNGFILE>
        </FILEHOSO>
        <FILEHOSO>
          <LOAIHOSO>XML2</LOAIHOSO>
          <NOIDUNGFILE><DSACH_CHI_TIET_THUOC><CHI_TIET_THUOC><MA_LK>HS02</MA_LK><STT>1</STT><MA_THUOC>T02</MA_THUOC><SO_LUONG>4</SO_LUONG><DON_GIA>50000</DON_GIA><THANH_TIEN>200000</THANH_TIEN></CHI_TIET_THUOC></DSACH_CHI_TIET_THUOC></NOIDUNGFILE>
        </FILEHOSO>
      </HOSO>
    </DANHSACHHOSO>
  </THONGTINHOSO>
</GIAMDINHHS>''';

      const multiHosoXmlNew = '''<?xml version="1.0" encoding="utf-8"?>
<GIAMDINHHS>
  <THONGTINDONVI><MACSKCB>56001</MACSKCB></THONGTINDONVI>
  <THONGTINHOSO>
    <SOLUONGHOSO>2</SOLUONGHOSO>
    <DANHSACHHOSO>
      <HOSO>
        <FILEHOSO>
          <LOAIHOSO>XML1</LOAIHOSO>
          <NOIDUNGFILE><TONG_HOP><MA_LK>HS01</MA_LK><HO_TEN>Nguyễn Văn A</HO_TEN><MA_THE_BHYT>DN456001</MA_THE_BHYT><T_TONGCHI_BV>100000</T_TONGCHI_BV></TONG_HOP></NOIDUNGFILE>
        </FILEHOSO>
        <FILEHOSO>
          <LOAIHOSO>XML2</LOAIHOSO>
          <NOIDUNGFILE><DSACH_CHI_TIET_THUOC><CHI_TIET_THUOC><MA_LK>HS01</MA_LK><STT>1</STT><MA_THUOC>T01</MA_THUOC><SO_LUONG>5</SO_LUONG><DON_GIA>50000</DON_GIA><THANH_TIEN>250000</THANH_TIEN></CHI_TIET_THUOC></DSACH_CHI_TIET_THUOC></NOIDUNGFILE>
        </FILEHOSO>
      </HOSO>
      <HOSO>
        <FILEHOSO>
          <LOAIHOSO>XML1</LOAIHOSO>
          <NOIDUNGFILE><TONG_HOP><MA_LK>HS02</MA_LK><HO_TEN>Trần Thị B</HO_TEN><MA_THE_BHYT>GD456002</MA_THE_BHYT><T_TONGCHI_BV>300000</T_TONGCHI_BV></TONG_HOP></NOIDUNGFILE>
        </FILEHOSO>
        <FILEHOSO>
          <LOAIHOSO>XML2</LOAIHOSO>
          <NOIDUNGFILE><DSACH_CHI_TIET_THUOC><CHI_TIET_THUOC><MA_LK>HS02</MA_LK><STT>1</STT><MA_THUOC>T02</MA_THUOC><SO_LUONG>6</SO_LUONG><DON_GIA>50000</DON_GIA><THANH_TIEN>300000</THANH_TIEN></CHI_TIET_THUOC></DSACH_CHI_TIET_THUOC></NOIDUNGFILE>
        </FILEHOSO>
      </HOSO>
    </DANHSACHHOSO>
  </THONGTINHOSO>
</GIAMDINHHS>''';

      final oldEnvelope = await parser.parseString(multiHosoXmlOld);
      final newEnvelope = await parser.parseString(multiHosoXmlNew);

      expect(oldEnvelope.soLuongHoSo, equals(2));
      expect(newEnvelope.soLuongHoSo, equals(2));
      expect(oldEnvelope.totalRecords, equals(4)); // 2 in HS01, 2 in HS02

      final compareResult = compareService.executeComparison(
        oldEnvelope: oldEnvelope,
        newEnvelope: newEnvelope,
      );

      // Both HS01 (T01 quantity 2 -> 5) and HS02 (T02 quantity 4 -> 6, T_TONGCHI_BV 200k -> 300k) changed
      expect(compareResult.totalRecords, equals(4));
      expect(compareResult.changedCount, equals(3)); // 1 in XML1 (HS02), 2 in XML2 (HS01 + HS02)

      final genResult = await generateMau09UseCase.execute(
        compareResult: compareResult,
        newEnvelope: newEnvelope,
        oldEnvelope: oldEnvelope,
      );

      expect(genResult.document.totalClaims, equals(2));
      expect(genResult.document.totalRows, greaterThanOrEqualTo(2));
    });

    test('Parses Base64-encoded NOIDUNGFILE seamlessly', () async {
      final xml1Content = '<TONG_HOP><MA_LK>HS99</MA_LK><HO_TEN>Lê Văn C</HO_TEN><MA_THE_BHYT>HT456003</MA_THE_BHYT><T_TONGCHI_BV>500000</T_TONGCHI_BV></TONG_HOP>';
      final base64Xml1 = base64Encode(utf8.encode(xml1Content));

      final base64EnvelopeXml = '''<?xml version="1.0" encoding="utf-8"?>
<GIAMDINHHS>
  <THONGTINDONVI><MACSKCB>56001</MACSKCB></THONGTINDONVI>
  <THONGTINHOSO>
    <SOLUONGHOSO>1</SOLUONGHOSO>
    <DANHSACHHOSO>
      <HOSO>
        <FILEHOSO>
          <LOAIHOSO>XML1</LOAIHOSO>
          <NOIDUNGFILE>$base64Xml1</NOIDUNGFILE>
        </FILEHOSO>
      </HOSO>
    </DANHSACHHOSO>
  </THONGTINHOSO>
</GIAMDINHHS>''';

      final envelope = await parser.parseString(base64EnvelopeXml);
      expect(envelope.soLuongHoSo, equals(1));
      final hoSo = envelope.danhSachHoSo.first;
      final xml1 = hoSo.getFile(XmlType.xml1);
      expect(xml1, isNotNull);
      expect(xml1!.records.first.fields['HO_TEN'], equals('Lê Văn C'));
      expect(xml1.records.first.fields['MA_LK'], equals('HS99'));
    });
  });
}
