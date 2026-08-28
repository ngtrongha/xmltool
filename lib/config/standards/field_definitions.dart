/// Data types of XML fields in BHYT standard.
enum FieldDataType {
  string,
  integer,
  decimal,
  date8,       // YYYYMMDD
  datetime12,  // YYYYMMDDHHmm
  cdataString,
}

/// Metadata definition of an XML field.
class FieldDefinition {
  final String name;
  final String label;
  final FieldDataType dataType;
  final bool isCdata;
  final bool isNullable;

  const FieldDefinition({
    required this.name,
    required this.label,
    required this.dataType,
    this.isCdata = false,
    this.isNullable = true,
  });
}
