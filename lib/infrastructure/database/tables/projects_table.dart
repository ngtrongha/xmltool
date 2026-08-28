import 'package:drift/drift.dart';

/// Drift table storing saved projects/configurations.
class Projects extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get standardVersion => text()();
  TextColumn get description => text().nullable()();
}
