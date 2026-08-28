import 'package:xmltool/domain/entities/mau09_document.dart';
import 'package:xmltool/domain/entities/validation_result.dart';
import 'package:xmltool/domain/entities/xml_envelope.dart';

/// Level 2 Validator: Checks schema conformity, required fields, and structural tags.
class SchemaValidator {
  /// Validate claim envelope structure
  ValidationResult validateEnvelope(XmlEnvelope envelope) {
    final issues = <ValidationIssue>[];

    if (envelope.maCskcb.isEmpty) {
      issues.add(const ValidationIssue(
        level: 2,
        severity: ValidationSeverity.error,
        message: 'Mã cơ sở KCB (MACSKCB) không được để trống',
        field: 'MACSKCB',
      ));
    }

    if (envelope.ngayLap.isEmpty) {
      issues.add(const ValidationIssue(
        level: 2,
        severity: ValidationSeverity.error,
        message: 'Ngày lập hồ sơ (NGAYLAP) không được để trống',
        field: 'NGAYLAP',
      ));
    }

    if (envelope.danhSachHoSo.isEmpty) {
      issues.add(const ValidationIssue(
        level: 2,
        severity: ValidationSeverity.error,
        message: 'Danh sách hồ sơ rỗng (<DANHSACHHOSO> không có <HOSO>)',
        field: 'DANHSACHHOSO',
      ));
    }

    for (var i = 0; i < envelope.danhSachHoSo.length; i++) {
      final hs = envelope.danhSachHoSo[i];
      if (hs.maLk.isEmpty) {
        issues.add(ValidationIssue(
          level: 2,
          severity: ValidationSeverity.error,
          message: 'Hồ sơ thứ ${i + 1} thiếu mã liên kết (MA_LK)',
          path: 'HOSO[$i]',
          field: 'MA_LK',
        ));
      }
    }

    return ValidationResult(issues: issues);
  }

  /// Validate generated Mẫu 09 document structure
  ValidationResult validateMau09Document(Mau09Document document) {
    final issues = <ValidationIssue>[];

    if (document.maCskcb.isEmpty) {
      issues.add(const ValidationIssue(
        level: 2,
        severity: ValidationSeverity.error,
        message: 'Mã cơ sở KCB (MACSKCB) không được để trống trong Mẫu 09',
        field: 'MACSKCB',
      ));
    }

    for (var i = 0; i < document.allRows.length; i++) {
      final row = document.allRows[i];
      if (row.maLk.isEmpty) {
        issues.add(ValidationIssue(
          level: 2,
          severity: ValidationSeverity.error,
          message: 'Dòng Mẫu 09 #${row.stt} thiếu MA_LK',
          field: 'MA_LK',
        ));
      }
      if (row.truongTtGoc.isEmpty && row.truongTtDc.isEmpty) {
        issues.add(ValidationIssue(
          level: 2,
          severity: ValidationSeverity.error,
          message: 'Dòng Mẫu 09 #${row.stt} thiếu tên trường điều chỉnh',
          field: 'TRUONG_TT_DC',
        ));
      }
    }

    return ValidationResult(issues: issues);
  }
}
