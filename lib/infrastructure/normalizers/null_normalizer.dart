import 'package:xmltool/config/standards/field_definitions.dart';
import 'package:xmltool/infrastructure/normalizers/normalizer.dart';

/// Normalizer to treat empty strings, whitespace-only, and "null" literals as null.
class NullNormalizer implements Normalizer {
  @override
  String? normalize(String? value, [FieldDataType? dataType]) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty || trimmed == 'null' || trimmed == '<![CDATA[]]>') {
      return null;
    }
    return value;
  }
}
