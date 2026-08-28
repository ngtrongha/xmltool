import 'package:equatable/equatable.dart';
import 'package:xmltool/config/standards/mau09_mappings.dart';
import 'package:xmltool/config/standards/xml_definitions.dart';
import 'package:xmltool/domain/value_objects/record_key.dart';

/// Represents a single field change between old and new records.
class FieldChange extends Equatable {
  final XmlType xmlType;
  final RecordKey key;
  final String field;
  final String? oldValue;
  final String? newValue;
  final ChangeEligibility eligibility;

  const FieldChange({
    required this.xmlType,
    required this.key,
    required this.field,
    required this.oldValue,
    required this.newValue,
    required this.eligibility,
  });

  bool get isAdjustable => eligibility == ChangeEligibility.adjustable;
  bool get isConditional => eligibility == ChangeEligibility.conditional;

  @override
  List<Object?> get props => [xmlType, key, field, oldValue, newValue, eligibility];
}
