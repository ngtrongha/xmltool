import 'package:xmltool/config/standards/field_definitions.dart';
import 'package:xmltool/infrastructure/normalizers/normalizer.dart';

/// Normalizer to extract text from CDATA tags if present.
class CdataNormalizer implements Normalizer {
  static final RegExp _cdataRegex = RegExp(r'^<!\[CDATA\[(.*)\]\]>$', dotAll: true);

  @override
  String? normalize(String? value, [FieldDataType? dataType]) {
    if (value == null) return null;
    final match = _cdataRegex.firstMatch(value.trim());
    if (match != null) {
      return match.group(1);
    }
    return value;
  }
}
