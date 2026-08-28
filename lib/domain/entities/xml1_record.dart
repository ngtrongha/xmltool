import 'package:xmltool/config/standards/xml_definitions.dart';
import 'package:xmltool/domain/entities/xml_record.dart';
import 'package:xmltool/domain/value_objects/record_key.dart';

/// Strongly-typed wrapper for XML1 (Tổng hợp KCB).
class Xml1Record extends XmlRecord {
  const Xml1Record({
    required super.key,
    required super.fields,
    super.index,
  }) : super(xmlType: XmlType.xml1);

  factory Xml1Record.fromFields(Map<String, String?> fields, {int? index}) {
    final maLk = fields['MA_LK'] ?? '';
    return Xml1Record(
      key: RecordKey.fromString(maLk),
      fields: fields,
      index: index,
    );
  }

  String get maBn => getValue('MA_BN');
  String get hoTen => getValue('HO_TEN');
  String get soCccd => getValue('SO_CCCD');
  String get ngaySinh => getValue('NGAY_SINH');
  String get gioiTinh => getValue('GIOI_TINH');
  String get maTheBhyt => getValue('MA_THE_BHYT');
  String get ngayVao => getValue('NGAY_VAO');
  String get ngayRa => getValue('NGAY_RA');
  String get maBenhChinh => getValue('MA_BENH_CHINH');
  String get maBenhKt => getValue('MA_BENH_KT');
  String get maLoaiKcb => getValue('MA_LOAI_KCB');
  String get maCskcb => getValue('MA_CSKCB');
  String get maKhoa => getValue('MA_KHOA');

  double get tTongChiBv => double.tryParse(getValue('T_TONGCHI_BV').replaceAll(',', '.')) ?? 0.0;
  double get tTongChiBh => double.tryParse(getValue('T_TONGCHI_BH').replaceAll(',', '.')) ?? 0.0;
  double get tBhtt => double.tryParse(getValue('T_BHTT').replaceAll(',', '.')) ?? 0.0;
  double get tBncct => double.tryParse(getValue('T_BNCCT').replaceAll(',', '.')) ?? 0.0;
  double get tBntt => double.tryParse(getValue('T_BNTT').replaceAll(',', '.')) ?? 0.0;
  double get tThuoc => double.tryParse(getValue('T_THUOC').replaceAll(',', '.')) ?? 0.0;
  double get tVtyt => double.tryParse(getValue('T_VTYT').replaceAll(',', '.')) ?? 0.0;
}
