import 'package:xmltool/config/standards/field_definitions.dart';
import 'package:xmltool/infrastructure/normalizers/normalizer.dart';

/// Normalizer to trim leading/trailing whitespace and collapse internal consecutive spaces.
class WhitespaceNormalizer implements Normalizer {
  static final RegExp _multiSpaceRegex = RegExp(r'\s+');

  @override
  String? normalize(String? value, [FieldDataType? dataType]) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '';
    return trimmed.replaceAll(_multiSpaceRegex, ' ');
  }
}
