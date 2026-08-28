import 'package:xmltool/config/standards/field_definitions.dart';
import 'package:xmltool/infrastructure/normalizers/cdata_normalizer.dart';
import 'package:xmltool/infrastructure/normalizers/date_normalizer.dart';
import 'package:xmltool/infrastructure/normalizers/decimal_normalizer.dart';
import 'package:xmltool/infrastructure/normalizers/normalizer.dart';
import 'package:xmltool/infrastructure/normalizers/null_normalizer.dart';
import 'package:xmltool/infrastructure/normalizers/whitespace_normalizer.dart';

/// Chains all normalizers in the optimal pipeline sequence.
class CompositeNormalizer implements Normalizer {
  final List<Normalizer> _pipeline;

  CompositeNormalizer({List<Normalizer>? pipeline})
      : _pipeline = pipeline ??
            [
              CdataNormalizer(),
              WhitespaceNormalizer(),
              NullNormalizer(),
              DecimalNormalizer(),
              DateNormalizer(),
            ];

  @override
  String? normalize(String? value, [FieldDataType? dataType]) {
    String? current = value;
    for (final normalizer in _pipeline) {
      current = normalizer.normalize(current, dataType);
      if (current == null) break;
    }
    return current;
  }
}
