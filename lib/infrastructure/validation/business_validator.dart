import 'package:xmltool/domain/entities/mau09_document.dart';
import 'package:xmltool/domain/entities/validation_result.dart';
import 'package:xmltool/domain/entities/xml_envelope.dart';

/// Level 3 Validator: Business logic rules, financial consistency, and validity constraints.
class BusinessValidator {
  /// Validate claim business rules
  ValidationResult validateEnvelope(XmlEnvelope envelope) {
    final issues = <ValidationIssue>[];

    for (final hs in envelope.danhSachHoSo) {
      for (final file in hs.fileList) {
        final keySet = <String>{};
        for (final rec in file.records) {
          if (keySet.contains(rec.key.value)) {
            issues.add(ValidationIssue(
              level: 3,
              severity: ValidationSeverity.error,
              message: 'Trùng lặp khóa bản ghi trong bảng ${file.xmlType.code}: ${rec.key.value}',
              field: 'KEY',
            ));
          }
          keySet.add(rec.key.value);

          // Check negative amounts
          final donGia = double.tryParse(rec.getValue('DON_GIA').replaceAll(',', '.'));
          if (donGia != null && donGia < 0) {
            issues.add(ValidationIssue(
              level: 3,
              severity: ValidationSeverity.error,
              message: 'Đơn giá không được âm (< 0) tại bản ghi ${rec.key.value}',
              field: 'DON_GIA',
            ));
          }

          final soLuong = double.tryParse(rec.getValue('SO_LUONG').replaceAll(',', '.'));
          if (soLuong != null && soLuong < 0) {
            issues.add(ValidationIssue(
              level: 3,
              severity: ValidationSeverity.error,
              message: 'Số lượng không được âm (< 0) tại bản ghi ${rec.key.value}',
              field: 'SO_LUONG',
            ));
          }
        }
      }
    }

    return ValidationResult(issues: issues);
  }

  /// Validate generated Mẫu 09 document business rules
  ValidationResult validateMau09(Mau09Document document) {
    final issues = <ValidationIssue>[];

    for (final row in document.allRows) {
      if (row.lyDoDc.trim().isEmpty) {
        issues.add(ValidationIssue(
          level: 3,
          severity: ValidationSeverity.warning,
          message: 'Dòng Mẫu 09 #${row.stt} (${row.truongTtDc}) chưa có lý do điều chỉnh',
          field: 'LY_DO_DC',
        ));
      }

      if (row.maTheBhyt.isNotEmpty && row.maTheBhyt.length != 10 && row.maTheBhyt.length != 15) {
        issues.add(ValidationIssue(
          level: 3,
          severity: ValidationSeverity.warning,
          message: 'Mã thẻ BHYT "${row.maTheBhyt}" không đúng độ dài 10 hoặc 15 ký tự',
          field: 'MA_THE_BHYT',
        ));
      }
    }

    return ValidationResult(issues: issues);
  }
}
