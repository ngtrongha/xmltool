import 'package:xmltool/domain/entities/audit_entry.dart';

/// Contract for logging and retrieving audit log entries.
abstract class AuditRepository {
  Future<void> logEntry(AuditEntry entry);
  Future<List<AuditEntry>> getEntries({int limit = 100, int offset = 0});
  Future<AuditEntry?> getEntryById(String id);
  Future<void> clearAll();
}
