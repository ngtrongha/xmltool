import 'package:xmltool/config/standards/xml_definitions.dart';
import 'package:xmltool/domain/entities/xml_record.dart';
import 'package:xmltool/domain/value_objects/record_key.dart';

/// Strongly-typed wrapper for XML3 (Chi tiết DVKT và VTYT).
class Xml3Record extends XmlRecord {
  const Xml3Record({
    required super.key,
    required super.fields,
    super.index,
  }) : super(xmlType: XmlType.xml3);

  factory Xml3Record.fromFields(Map<String, String?> fields, {int? index}) {
    final maLk = fields['MA_LK'] ?? '';
    final stt = fields['STT'] ?? '$index';
    return Xml3Record(
      key: RecordKey.fromParts([maLk, stt]),
      fields: fields,
      index: index,
    );
  }

  String get maDichVu => getValue('MA_DICH_VU');
  String get maVatTu => getValue('MA_VAT_TU');
  String get tenDichVu => getValue('TEN_DICH_VU');
  String get tenVatTu => getValue('TEN_VAT_TU');
  String get donViTinh => getValue('DON_VI_TINH');
  String get maNhom => getValue('MA_NHOM');
  String get ngayYl => getValue('NGAY_YL');
  String get maKhoa => getValue('MA_KHOA');
  String get maBacSi => getValue('MA_BAC_SI');
  String get nguoiThucHien => getValue('NGUOI_THUC_HIEN');
  String get maMay => getValue('MA_MAY');

  bool get isVatTu => maVatTu.isNotEmpty;

  double get soLuong => double.tryParse(getValue('SO_LUONG').replaceAll(',', '.')) ?? 0.0;
  double get donGiaBv => double.tryParse(getValue('DON_GIA_BV').replaceAll(',', '.')) ?? 0.0;
  double get donGiaBh => double.tryParse(getValue('DON_GIA_BH').replaceAll(',', '.')) ?? 0.0;
  double get thanhTienBv => double.tryParse(getValue('THANH_TIEN_BV').replaceAll(',', '.')) ?? 0.0;
  double get thanhTienBh => double.tryParse(getValue('THANH_TIEN_BH').replaceAll(',', '.')) ?? 0.0;
  double get tBhtt => double.tryParse(getValue('T_BHTT').replaceAll(',', '.')) ?? 0.0;
  double get tBncct => double.tryParse(getValue('T_BNCCT').replaceAll(',', '.')) ?? 0.0;
  double get tBntt => double.tryParse(getValue('T_BNTT').replaceAll(',', '.')) ?? 0.0;
}
