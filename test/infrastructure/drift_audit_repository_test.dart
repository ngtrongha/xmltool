import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xmltool/domain/entities/audit_entry.dart';
import 'package:xmltool/infrastructure/database/app_database.dart';
import 'package:xmltool/infrastructure/repositories/drift_audit_repository.dart';

void main() {
  group('DriftAuditRepository & SQLite Database Tests', () {
    late AppDatabase db;
    late DriftAuditRepository repo;

    setUp(() {
      // In-memory database for testing
      db = AppDatabase(NativeDatabase.memory());
      repo = DriftAuditRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('Saves and retrieves audit logs in reverse chronological order', () async {
      final entry1 = AuditEntry(
        id: '1',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        oldFileName: 'old_data.xml',
        newFileName: 'new_data.xml',
        oldFileHash: 'hash_old_123',
        newFileHash: 'hash_new_456',
        standardVersion: 'QĐ 3176',
        totalClaims: 1,
        totalChanges: 12,
        totalMau09Rows: 8,
      );

      final entry2 = AuditEntry(
        id: '2',
        timestamp: DateTime.now(),
        oldFileName: 'old_data.xml',
        newFileName: 'new_data.xml',
        oldFileHash: 'hash_old_123',
        newFileHash: 'hash_new_456',
        outputFileName: 'MAU_09.xml',
        outputFileHash: 'hash_out_789',
        standardVersion: 'QĐ 3176',
        totalClaims: 1,
        totalChanges: 12,
        totalMau09Rows: 8,
      );

      await repo.logEntry(entry1);
      await repo.logEntry(entry2);

      final entries = await repo.getEntries();
      expect(entries.length, equals(2));
      // entry2 is newer, so it should be first
      expect(entries.first.outputFileName, equals('MAU_09.xml'));
      expect(entries.last.outputFileName, isNull);
    });

    test('Clears all audit logs', () async {
      final entry = AuditEntry(
        id: '1',
        timestamp: DateTime.now(),
        oldFileName: 'old.xml',
        newFileName: 'new.xml',
        oldFileHash: 'hash1',
        newFileHash: 'hash2',
        standardVersion: 'QĐ 3176',
        totalClaims: 1,
        totalChanges: 0,
        totalMau09Rows: 0,
      );

      await repo.logEntry(entry);
      var entries = await repo.getEntries();
      expect(entries.length, equals(1));

      await repo.clearAll();
      entries = await repo.getEntries();
      expect(entries, isEmpty);
    });
  });
}
