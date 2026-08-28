import 'package:equatable/equatable.dart';
import 'package:xmltool/config/standards/xml_definitions.dart';
import 'package:xmltool/domain/entities/record_change.dart';
import 'package:xmltool/domain/value_objects/change_type.dart';

/// Complete comparison outcome across all XML types and records.
class CompareResult extends Equatable {
  final String oldFilePath;
  final String newFilePath;
  final String oldFileHash;
  final String newFileHash;
  final DateTime comparedAt;
  final Map<XmlType, List<RecordChange>> changesByXmlType;

  const CompareResult({
    required this.oldFilePath,
    required this.newFilePath,
    required this.oldFileHash,
    required this.newFileHash,
    required this.comparedAt,
    required this.changesByXmlType,
  });

  /// All record changes flattened
  List<RecordChange> get allChanges =>
      changesByXmlType.values.expand((list) => list).toList();

  /// Total count of all records compared
  int get totalRecords => allChanges.length;

  /// Unchanged records count
  int get unchangedCount =>
      allChanges.where((c) => c.changeType == ChangeType.unchanged).length;

  /// Changed records count
  int get changedCount =>
      allChanges.where((c) => c.changeType == ChangeType.changed).length;

  /// Added records count
  int get addedCount =>
      allChanges.where((c) => c.changeType == ChangeType.added).length;

  /// Removed records count
  int get removedCount =>
      allChanges.where((c) => c.changeType == ChangeType.removed).length;

  /// Total adjustable changes for Mẫu 09
  int get mau09EligibleCount {
    var count = 0;
    for (final change in allChanges) {
      count += change.fieldChanges
          .where((fc) => fc.isAdjustable || fc.isConditional)
          .length;
    }
    return count;
  }

  /// Get changes for specific XML type
  List<RecordChange> getChanges(XmlType type) => changesByXmlType[type] ?? [];

  @override
  List<Object?> get props => [
        oldFilePath,
        newFilePath,
        oldFileHash,
        newFileHash,
        comparedAt,
        changesByXmlType,
      ];
}
