import 'package:xml/xml.dart';
import 'package:xmltool/config/standards/key_definitions.dart';
import 'package:xmltool/config/standards/xml_definitions.dart';
import 'package:xmltool/domain/entities/xml1_record.dart';
import 'package:xmltool/domain/entities/xml2_record.dart';
import 'package:xmltool/domain/entities/xml3_record.dart';
import 'package:xmltool/domain/entities/xml_record.dart';
import 'package:xmltool/domain/value_objects/record_key.dart';

/// Parses raw XML elements into strongly-typed XmlRecord instances.
class XmlRecordParser {
  /// Extract key/value pairs of all immediate child elements of [element].
  static Map<String, String?> extractFields(XmlElement element) {
    final fields = <String, String?>{};
    for (final child in element.childElements) {
      final name = child.name.local;
      final text = child.innerText;
      fields[name] = text;
    }
    return fields;
  }

  /// Parse a single XML record element according to its [XmlType].
  static XmlRecord parseRecord(
    XmlElement recordElement,
    XmlType xmlType, {
    int? index,
  }) {
    final fields = extractFields(recordElement);
    final key = _buildKey(xmlType, fields, index);

    switch (xmlType) {
      case XmlType.xml1:
        return Xml1Record(key: key, fields: fields, index: index);
      case XmlType.xml2:
        return Xml2Record(key: key, fields: fields, index: index);
      case XmlType.xml3:
        return Xml3Record(key: key, fields: fields, index: index);
      default:
        return XmlRecord(
          xmlType: xmlType,
          key: key,
          fields: fields,
          index: index,
        );
    }
  }

  static RecordKey _buildKey(
    XmlType xmlType,
    Map<String, String?> fields,
    int? index,
  ) {
    final strategy = KeyDefinitions.getStrategy(xmlType);
    final parts = <String>[];

    for (final fieldName in strategy.primaryKeyFields) {
      final val = fields[fieldName]?.trim() ?? '';
      if (val.isNotEmpty) {
        parts.add(val);
      } else if (fieldName == 'STT' && index != null) {
        parts.add('$index');
      } else {
        parts.add('');
      }
    }

    return RecordKey.fromParts(parts);
  }
}
