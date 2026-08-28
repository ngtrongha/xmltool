/// Types of differences between old and new records/fields.
enum ChangeType {
  /// Record or field values are identical after normalization.
  unchanged('Không thay đổi', 'UNCHANGED'),

  /// Record or field value has changed.
  changed('Đã thay đổi', 'CHANGED'),

  /// New record added in the new XML.
  added('Bản ghi mới', 'ADDED'),

  /// Record removed in the new XML.
  removed('Bản ghi bị xóa', 'REMOVED'),

  /// Ambiguous match requiring user confirmation.
  ambiguous('Cần xác nhận', 'AMBIGUOUS');

  final String label;
  final String code;

  const ChangeType(this.label, this.code);
}
