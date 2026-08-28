import 'package:xmltool/config/standards/xml_definitions.dart';
import 'package:xmltool/domain/entities/xml_record.dart';
import 'package:xmltool/domain/value_objects/record_key.dart';

/// Strongly-typed wrapper for XML2 (Chi tiết Thuốc).
class Xml2Record extends XmlRecord {
  const Xml2Record({
    required super.key,
    required super.fields,
    super.index,
  }) : super(xmlType: XmlType.xml2);

  factory Xml2Record.fromFields(Map<String, String?> fields, {int? index}) {
    final maLk = fields['MA_LK'] ?? '';
    final stt = fields['STT'] ?? '$index';
    return Xml2Record(
      key: RecordKey.fromParts([maLk, stt]),
      fields: fields,
      index: index,
    );
  }

  String get maThuoc => getValue('MA_THUOC');
  String get tenThuoc => getValue('TEN_THUOC');
  String get donViTinh => getValue('DON_VI_TINH');
  String get hamLuong => getValue('HAM_LUONG');
  String get ngayYl => getValue('NGAY_YL');
  String get maKhoa => getValue('MA_KHOA');
  String get maBacSi => getValue('MA_BAC_SI');

  double get soLuong => double.tryParse(getValue('SO_LUONG').replaceAll(',', '.')) ?? 0.0;
  double get donGia => double.tryParse(getValue('DON_GIA').replaceAll(',', '.')) ?? 0.0;
  double get thanhTienBv => double.tryParse(getValue('THANH_TIEN_BV').replaceAll(',', '.')) ?? 0.0;
  double get thanhTienBh => double.tryParse(getValue('THANH_TIEN_BH').replaceAll(',', '.')) ?? 0.0;
  double get tBhtt => double.tryParse(getValue('T_BHTT').replaceAll(',', '.')) ?? 0.0;
  double get tBncct => double.tryParse(getValue('T_BNCCT').replaceAll(',', '.')) ?? 0.0;
  double get tBntt => double.tryParse(getValue('T_BNTT').replaceAll(',', '.')) ?? 0.0;
}
