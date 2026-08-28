import 'dart:io';
import 'package:xmltool/domain/entities/compare_result.dart';
import 'package:xmltool/domain/entities/mau09_document.dart';

/// Contract for exporting generated Mẫu 09 XML and Excel reconciliation reports.
abstract class ExportRepository {
  /// Export Mẫu 09 to standard XML file.
  Future<File> exportMau09Xml(Mau09Document document, String targetPath);

  /// Export comparison and adjustment report to Excel file.
  Future<File> exportExcelReport(
    CompareResult compareResult,
    Mau09Document? mau09Document,
    String targetPath,
  );
}
