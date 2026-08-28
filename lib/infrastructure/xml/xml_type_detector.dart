import 'package:xml/xml.dart';
import 'package:xmltool/config/standards/xml_definitions.dart';

/// Detects the XmlType from a `<LOAIHOSO>` text value or an XML element name.
class XmlTypeDetector {
  /// Detect from LOAIHOSO string
  static XmlType? detectFromLoaiHoSo(String? loaiHoSo) {
    return XmlType.fromCode(loaiHoSo);
  }

  /// Detect from XML Element tag name
  static XmlType? detectFromElement(XmlElement element) {
    final name = element.name.local.toUpperCase();
    for (final type in XmlType.values) {
      if (type.containerElement.toUpperCase() == name ||
          type.recordElement.toUpperCase() == name) {
        return type;
      }
    }
    return null;
  }
}
