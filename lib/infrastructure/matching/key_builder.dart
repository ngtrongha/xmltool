import 'package:xmltool/config/standards/key_definitions.dart';
import 'package:xmltool/domain/entities/xml_record.dart';
import 'package:xmltool/domain/value_objects/record_key.dart';

/// Builds primary and fallback matching keys from an XmlRecord.
class KeyBuilder {
  /// Builds the primary key for a record.
  static RecordKey buildPrimaryKey(XmlRecord record) {
    final strategy = KeyDefinitions.getStrategy(record.xmlType);
    final parts = <String>[];

    for (final fieldName in strategy.primaryKeyFields) {
      final val = record.fields[fieldName]?.trim() ?? '';
      if (val.isNotEmpty) {
        parts.add(val);
      } else if (fieldName == 'STT' && record.index != null) {
        parts.add('${record.index}');
      } else {
        parts.add('');
      }
    }
    return RecordKey.fromParts(parts);
  }

  /// Builds the fallback key (e.g. MA_THUOC + NGAY_YL for XML2).
  static RecordKey? buildFallbackKey(XmlRecord record) {
    final strategy = KeyDefinitions.getStrategy(record.xmlType);
    final fields = strategy.fallbackKeyFields;
    if (fields == null || fields.isEmpty) return null;

    final parts = <String>[];
    for (final fieldName in fields) {
      final val = record.fields[fieldName]?.trim() ?? '';
      if (val.isEmpty) return null; // If any fallback component is missing, cannot build
      parts.add(val);
    }
    return RecordKey.fromParts(parts);
  }

  /// Builds alternative fallback key (e.g. MA_VAT_TU + NGAY_YL for XML3).
  static RecordKey? buildFallbackAltKey(XmlRecord record) {
    final strategy = KeyDefinitions.getStrategy(record.xmlType);
    final fields = strategy.fallbackAltKeyFields;
    if (fields == null || fields.isEmpty) return null;

    final parts = <String>[];
    for (final fieldName in fields) {
      final val = record.fields[fieldName]?.trim() ?? '';
      if (val.isEmpty) return null;
      parts.add(val);
    }
    return RecordKey.fromParts(parts);
  }
}
