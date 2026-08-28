import 'package:equatable/equatable.dart';

/// Immutable audit log record for tracking reconciliation runs.
class AuditEntry extends Equatable {
  final String id;
  final DateTime timestamp;
  final String oldFileName;
  final String newFileName;
  final String oldFileHash;
  final String newFileHash;
  final String? outputFileName;
  final String? outputFileHash;
  final String standardVersion;
  final int totalClaims;
  final int totalChanges;
  final int totalMau09Rows;
  final String? note;

  const AuditEntry({
    required this.id,
    required this.timestamp,
    required this.oldFileName,
    required this.newFileName,
    required this.oldFileHash,
    required this.newFileHash,
    this.outputFileName,
    this.outputFileHash,
    required this.standardVersion,
    required this.totalClaims,
    required this.totalChanges,
    required this.totalMau09Rows,
    this.note,
  });

  @override
  List<Object?> get props => [
        id,
        timestamp,
        oldFileName,
        newFileName,
        oldFileHash,
        newFileHash,
        outputFileName,
        outputFileHash,
        standardVersion,
        totalClaims,
        totalChanges,
        totalMau09Rows,
        note,
      ];
}
