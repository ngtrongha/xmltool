import 'package:equatable/equatable.dart';

/// Immutable representation of a record key in an XML document.
class RecordKey extends Equatable {
  final String value;
  final List<String> parts;

  const RecordKey(this.value, [this.parts = const []]);

  /// Construct a composite key from its string parts.
  factory RecordKey.fromParts(List<String> parts) {
    final cleanParts = parts.map((p) => p.trim()).toList();
    final value = cleanParts.join('|');
    return RecordKey(value, cleanParts);
  }

  /// Construct a key from a pre-formatted string.
  factory RecordKey.fromString(String value) {
    final parts = value.split('|');
    return RecordKey(value, parts);
  }

  @override
  List<Object?> get props => [value];

  @override
  String toString() => value;
}
