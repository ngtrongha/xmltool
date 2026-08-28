import 'package:xmltool/config/standards/field_definitions.dart';

/// Base interface for field value normalization.
abstract class Normalizer {
  /// Normalize raw string value for comparison.
  String? normalize(String? value, [FieldDataType? dataType]);
}
