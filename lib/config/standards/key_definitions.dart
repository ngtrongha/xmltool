import 'package:xmltool/config/standards/xml_definitions.dart';

/// Defines key fields for matching records in a given XML type.
class KeyStrategy {
  final List<String> primaryKeyFields;
  final List<String>? fallbackKeyFields;
  final List<String>? fallbackAltKeyFields;

  const KeyStrategy({
    required this.primaryKeyFields,
    this.fallbackKeyFields,
    this.fallbackAltKeyFields,
  });
}

/// Key strategies registry per XML type.
class KeyDefinitions {
  static const Map<XmlType, KeyStrategy> strategies = {
    XmlType.xml1: KeyStrategy(
      primaryKeyFields: ['MA_LK'],
    ),
    XmlType.xml2: KeyStrategy(
      primaryKeyFields: ['MA_LK', 'STT'],
      fallbackKeyFields: ['MA_LK', 'MA_THUOC', 'NGAY_YL'],
    ),
    XmlType.xml3: KeyStrategy(
      primaryKeyFields: ['MA_LK', 'STT'],
      fallbackKeyFields: ['MA_LK', 'MA_DICH_VU', 'NGAY_YL'],
      fallbackAltKeyFields: ['MA_LK', 'MA_VAT_TU', 'NGAY_YL'],
    ),
    XmlType.xml4: KeyStrategy(
      primaryKeyFields: ['MA_LK', 'STT'],
      fallbackKeyFields: ['MA_LK', 'MA_DICH_VU', 'MA_CHI_SO'],
    ),
    XmlType.xml5: KeyStrategy(
      primaryKeyFields: ['MA_LK', 'STT'],
      fallbackKeyFields: ['MA_LK', 'THOI_DIEM_DBLS'],
    ),
    XmlType.xml7: KeyStrategy(
      primaryKeyFields: ['MA_LK'],
    ),
    XmlType.xml8: KeyStrategy(
      primaryKeyFields: ['MA_LK'],
    ),
  };

  /// Returns key strategy for the given XML type.
  static KeyStrategy getStrategy(XmlType type) {
    return strategies[type] ??
        const KeyStrategy(primaryKeyFields: ['MA_LK', 'STT']);
  }
}
