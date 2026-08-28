import 'package:xml/xml.dart';
import 'package:xmltool/domain/entities/validation_result.dart';

/// Level 1 Validator: Checks whether raw XML string is well-formed.
class XmlWellformedValidator {
  ValidationResult validate(String xmlContent) {
    final issues = <ValidationIssue>[];
    try {
      XmlDocument.parse(xmlContent);
    } catch (e) {
      issues.add(ValidationIssue(
        level: 1,
        severity: ValidationSeverity.error,
        message: 'Lỗi cú pháp XML không hợp lệ (Well-formed check failed): $e',
      ));
    }
    return ValidationResult(issues: issues);
  }
}
