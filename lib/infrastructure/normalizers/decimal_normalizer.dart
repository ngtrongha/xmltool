import 'package:xmltool/config/standards/field_definitions.dart';
import 'package:xmltool/infrastructure/normalizers/normalizer.dart';

/// Normalizer for numbers and currency amounts:
/// Converts comma to dot (2,20 -> 2.20), parses numbers,
/// and strips insignificant trailing zeroes (70000.00 -> 70000, 1.000 -> 1).
class DecimalNormalizer implements Normalizer {
  @override
  String? normalize(String? value, [FieldDataType? dataType]) {
    if (value == null) return null;
    var str = value.trim();
    if (str.isEmpty) return null;

    // Check if it's a numeric field or looks like a number
    final isNumeric = dataType != null
        ? (dataType == FieldDataType.decimal || dataType == FieldDataType.integer)
        : _isNumericString(str);

    if (!isNumeric) return value;

    // Replace comma with dot for Vietnamese decimal format
    str = str.replaceAll(',', '.');

    final parsed = double.tryParse(str);
    if (parsed == null) return value;

    // Format integer cleanly if no decimal part
    if (parsed == parsed.roundToDouble() && !str.contains('e') && !str.contains('E')) {
      return parsed.toInt().toString();
    }

    // Otherwise format without trailing zeroes
    var formatted = parsed.toString();
    if (formatted.contains('.')) {
      formatted = formatted.replaceAll(RegExp(r'0+$'), '');
      formatted = formatted.replaceAll(RegExp(r'\.$'), '');
    }
    return formatted;
  }

  bool _isNumericString(String s) {
    final cleaned = s.replaceAll(',', '.');
    return double.tryParse(cleaned) != null;
  }
}
