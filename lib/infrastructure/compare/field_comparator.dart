import 'package:xmltool/config/standards/mau09_mappings.dart';
import 'package:xmltool/config/standards/xml_definitions.dart';
import 'package:xmltool/domain/entities/field_change.dart';
import 'package:xmltool/domain/value_objects/record_key.dart';
import 'package:xmltool/infrastructure/normalizers/composite_normalizer.dart';
import 'package:xmltool/infrastructure/normalizers/normalizer.dart';

/// Compares individual field values between old and new versions with normalization.
class FieldComparator {
  final Normalizer normalizer;

  FieldComparator({Normalizer? normalizer})
      : normalizer = normalizer ?? CompositeNormalizer();

  /// Compares old and new raw values of a field.
  /// Returns a [FieldChange] if different, or null if identical after normalization.
  FieldChange? compareField({
    required XmlType xmlType,
    required RecordKey key,
    required String fieldName,
    required String? rawOldValue,
    required String? rawNewValue,
  }) {
    final normOld = normalizer.normalize(rawOldValue);
    final normNew = normalizer.normalize(rawNewValue);

    // Both are effectively null/empty
    if (normOld == null && normNew == null) {
      return null;
    }

    if (normOld != normNew) {
      final eligibility = Mau09Mappings.getEligibility(xmlType, fieldName);
      return FieldChange(
        xmlType: xmlType,
        key: key,
        field: fieldName,
        oldValue: normOld ?? '',
        newValue: normNew ?? '',
        eligibility: eligibility,
      );
    }

    return null;
  }
}
