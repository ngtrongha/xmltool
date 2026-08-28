import 'package:xmltool/config/standards/field_definitions.dart';
import 'package:xmltool/infrastructure/normalizers/normalizer.dart';

/// Normalizer to handle dummy/default date strings (e.g. 00010101, 000101010000).
class DateNormalizer implements Normalizer {
  static const Set<String> _dummyDates = {
    '00010101',
    '000101010000',
    '0001-01-01',
    '0001-01-01T00:00:00',
    '19000101',
    '190001010000',
  };

  @override
  String? normalize(String? value, [FieldDataType? dataType]) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (_dummyDates.contains(trimmed)) {
      return null;
    }
    return value;
  }
}
