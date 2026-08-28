import 'package:drift/drift.dart';
import 'package:xmltool/domain/entities/audit_entry.dart';
import 'package:xmltool/domain/repositories/audit_repository.dart';
import 'package:xmltool/infrastructure/database/app_database.dart';

/// SQLite / Drift implementation of AuditRepository.
class DriftAuditRepository implements AuditRepository {
  final AppDatabase _db;

  DriftAuditRepository(this._db);

  @override
  Future<void> logEntry(AuditEntry entry) async {
    await _db.into(_db.auditLogs).insert(
          AuditLogsCompanion.insert(
            timestamp: entry.timestamp,
            oldFileName: Value(entry.oldFileName),
            newFileName: Value(entry.newFileName),
            oldFileHash: Value(entry.oldFileHash),
            newFileHash: Value(entry.newFileHash),
            outputFileName: Value(entry.outputFileName),
            outputFileHash: Value(entry.outputFileHash),
            standardVersion: Value(entry.standardVersion),
            totalClaims: Value(entry.totalClaims),
            totalChanges: Value(entry.totalChanges),
            totalMau09Rows: Value(entry.totalMau09Rows),
            note: Value(entry.note),
          ),
        );
  }

  @override
  Future<List<AuditEntry>> getEntries({int limit = 100, int offset = 0}) async {
    final query = (_db.select(_db.auditLogs)
      ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
      ..limit(limit, offset: offset));

    final rows = await query.get();

    return rows
        .map((r) => AuditEntry(
              id: r.id.toString(),
              timestamp: r.timestamp,
              oldFileName: r.oldFileName,
              newFileName: r.newFileName,
              oldFileHash: r.oldFileHash,
              newFileHash: r.newFileHash,
              outputFileName: r.outputFileName,
              outputFileHash: r.outputFileHash,
              standardVersion: r.standardVersion,
              totalClaims: r.totalClaims,
              totalChanges: r.totalChanges,
              totalMau09Rows: r.totalMau09Rows,
              note: r.note,
            ))
        .toList();
  }

  @override
  Future<AuditEntry?> getEntryById(String id) async {
    final intId = int.tryParse(id);
    if (intId == null) return null;

    final query = _db.select(_db.auditLogs)..where((t) => t.id.equals(intId));
    final row = await query.getSingleOrNull();
    if (row == null) return null;

    return AuditEntry(
      id: row.id.toString(),
      timestamp: row.timestamp,
      oldFileName: row.oldFileName,
      newFileName: row.newFileName,
      oldFileHash: row.oldFileHash,
      newFileHash: row.newFileHash,
      outputFileName: row.outputFileName,
      outputFileHash: row.outputFileHash,
      standardVersion: row.standardVersion,
      totalClaims: row.totalClaims,
      totalChanges: row.totalChanges,
      totalMau09Rows: row.totalMau09Rows,
      note: row.note,
    );
  }

  @override
  Future<void> clearAll() async {
    await _db.delete(_db.auditLogs).go();
  }
}
