import 'package:equatable/equatable.dart';
import 'package:xmltool/config/standards/xml_definitions.dart';
import 'package:xmltool/domain/entities/field_change.dart';
import 'package:xmltool/domain/entities/xml_record.dart';
import 'package:xmltool/domain/value_objects/change_type.dart';
import 'package:xmltool/domain/value_objects/record_key.dart';

/// Represents all changes and state for a single matched, added, or removed record.
class RecordChange extends Equatable {
  final XmlType xmlType;
  final RecordKey key;
  final ChangeType changeType;
  final XmlRecord? oldRecord;
  final XmlRecord? newRecord;
  final List<FieldChange> fieldChanges;

  const RecordChange({
    required this.xmlType,
    required this.key,
    required this.changeType,
    this.oldRecord,
    this.newRecord,
    this.fieldChanges = const [],
  });

  /// True if there are any field changes that qualify for Mẫu 09 adjustment
  bool get hasAdjustableChanges =>
      fieldChanges.any((fc) => fc.isAdjustable || fc.isConditional);

  /// Number of changed fields
  int get changeCount => fieldChanges.length;

  /// Convenience getter for record STT
  String get stt {
    if (newRecord != null) return newRecord!.stt;
    if (oldRecord != null) return oldRecord!.stt;
    return '';
  }

  /// Convenience getter for record MA_LK
  String get maLk {
    if (newRecord != null) return newRecord!.maLk;
    if (oldRecord != null) return oldRecord!.maLk;
    return '';
  }

  @override
  List<Object?> get props => [
        xmlType,
        key,
        changeType,
        oldRecord,
        newRecord,
        fieldChanges,
      ];
}
