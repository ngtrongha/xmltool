import 'package:equatable/equatable.dart';

/// Severity of a validation issue.
enum ValidationSeverity {
  error('Lỗi', 'ERROR'),
  warning('Cảnh báo', 'WARNING'),
  info('Thông tin', 'INFO');

  final String label;
  final String code;

  const ValidationSeverity(this.label, this.code);
}

/// A single validation issue.
class ValidationIssue extends Equatable {
  final int level; // 1: Wellformed, 2: Schema, 3: Business
  final ValidationSeverity severity;
  final String message;
  final String? path;
  final String? field;

  const ValidationIssue({
    required this.level,
    required this.severity,
    required this.message,
    this.path,
    this.field,
  });

  @override
  List<Object?> get props => [level, severity, message, path, field];

  @override
  String toString() => '[$severity (Level $level)] $message ${field != null ? 'at $field' : ''}';
}

/// Overall outcome of a validation run.
class ValidationResult extends Equatable {
  final List<ValidationIssue> issues;

  const ValidationResult({this.issues = const []});

  bool get isValid => !issues.any((i) => i.severity == ValidationSeverity.error);
  bool get hasWarnings => issues.any((i) => i.severity == ValidationSeverity.warning);

  List<ValidationIssue> get errors =>
      issues.where((i) => i.severity == ValidationSeverity.error).toList();

  List<ValidationIssue> get warnings =>
      issues.where((i) => i.severity == ValidationSeverity.warning).toList();

  @override
  List<Object?> get props => [issues];
}
