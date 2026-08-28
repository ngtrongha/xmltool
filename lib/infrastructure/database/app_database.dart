import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:xmltool/infrastructure/database/tables/audit_logs_table.dart';
import 'package:xmltool/infrastructure/database/tables/projects_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [AuditLogs, Projects])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'xmltool', 'xmltool.sqlite'));
      if (!file.parent.existsSync()) {
        file.parent.createSync(recursive: true);
      }
      return NativeDatabase.createInBackground(file);
    });
  }
}
