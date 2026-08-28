import 'package:equatable/equatable.dart';

/// Base failure class for the application domain and infrastructure.
abstract class Failure extends Equatable {
  final String message;
  final dynamic details;

  const Failure(this.message, [this.details]);

  @override
  List<Object?> get props => [message, details];

  @override
  String toString() => '$runtimeType: $message ${details ?? ''}';
}

/// Parsing errors when reading XML files or invalid structures.
class XmlParseFailure extends Failure {
  const XmlParseFailure(super.message, [super.details]);
}

/// Validation failure for Level 1, Level 2, or Level 3 rules.
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, [super.details]);
}

/// Matching error when records cannot be correlated.
class MatchingFailure extends Failure {
  const MatchingFailure(super.message, [super.details]);
}

/// Comparison error during diffing.
class CompareFailure extends Failure {
  const CompareFailure(super.message, [super.details]);
}

/// Database failure.
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, [super.details]);
}

/// File system or export failure.
class FileSystemFailure extends Failure {
  const FileSystemFailure(super.message, [super.details]);
}
