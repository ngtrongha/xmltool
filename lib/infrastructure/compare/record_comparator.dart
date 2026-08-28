import 'package:xmltool/config/standards/compare_rules.dart';
import 'package:xmltool/config/standards/xml_definitions.dart';
import 'package:xmltool/domain/entities/field_change.dart';
import 'package:xmltool/domain/entities/record_change.dart';
import 'package:xmltool/domain/entities/xml_record.dart';
import 'package:xmltool/domain/value_objects/change_type.dart';
import 'package:xmltool/infrastructure/compare/field_comparator.dart';

/// Compares two matched records across all applicable fields defined in [CompareRules].
class RecordComparator {
  final FieldComparator fieldComparator;

  RecordComparator({FieldComparator? fieldComparator})
      : fieldComparator = fieldComparator ?? FieldComparator();

  /// Compare two matched records.
  RecordChange compareRecords({
    required XmlType xmlType,
    required XmlRecord oldRecord,
    required XmlRecord newRecord,
  }) {
    final comparableFields = CompareRules.getComparableFields(xmlType);
    final fieldChanges = <FieldChange>[];

    for (final fieldName in comparableFields) {
      final change = fieldComparator.compareField(
        xmlType: xmlType,
        key: oldRecord.key,
        fieldName: fieldName,
        rawOldValue: oldRecord.fields[fieldName],
        rawNewValue: newRecord.fields[fieldName],
      );

      if (change != null) {
        fieldChanges.add(change);
      }
    }

    final changeType = fieldChanges.isEmpty ? ChangeType.unchanged : ChangeType.changed;

    return RecordChange(
      xmlType: xmlType,
      key: oldRecord.key,
      changeType: changeType,
      oldRecord: oldRecord,
      newRecord: newRecord,
      fieldChanges: fieldChanges,
    );
  }
}
