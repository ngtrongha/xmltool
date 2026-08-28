import 'package:equatable/equatable.dart';
import 'package:xmltool/config/standards/xml_definitions.dart';
import 'package:xmltool/domain/value_objects/record_key.dart';

/// Generic immutable representation of a single XML row/record.
class XmlRecord extends Equatable {
  final XmlType xmlType;
  final RecordKey key;
  final Map<String, String?> fields;
  final int? index;

  const XmlRecord({
    required this.xmlType,
    required this.key,
    required this.fields,
    this.index,
  });

  /// Access a field value by name
  String? operator [](String fieldName) => fields[fieldName];

  /// Get field value or empty string
  String getValue(String fieldName, {String defaultValue = ''}) {
    return fields[fieldName] ?? defaultValue;
  }

  /// Convenience getter for MA_LK
  String get maLk => fields['MA_LK'] ?? '';

  /// Convenience getter for STT
  String get stt => fields['STT'] ?? '';

  @override
  List<Object?> get props => [xmlType, key, fields, index];
}
