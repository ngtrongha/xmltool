import 'package:drift/drift.dart';

/// Drift table storing reconciliation audit logs.
class AuditLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get oldFileName => text().withDefault(const Constant(''))();
  TextColumn get newFileName => text().withDefault(const Constant(''))();
  TextColumn get oldFileHash => text().withDefault(const Constant(''))();
  TextColumn get newFileHash => text().withDefault(const Constant(''))();
  TextColumn get outputFileName => text().nullable()();
  TextColumn get outputFileHash => text().nullable()();
  TextColumn get standardVersion => text().withDefault(const Constant('QĐ 3176'))();
  IntColumn get totalClaims => integer().withDefault(const Constant(0))();
  IntColumn get totalChanges => integer().withDefault(const Constant(0))();
  IntColumn get totalMau09Rows => integer().withDefault(const Constant(0))();
  TextColumn get note => text().nullable()();
}
