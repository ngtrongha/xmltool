import 'dart:io';
import 'package:xmltool/domain/entities/compare_result.dart';
import 'package:xmltool/domain/entities/mau09_document.dart';
import 'package:xmltool/domain/repositories/export_repository.dart';

/// UseCase: Export Mẫu 09 XML and Excel reports.
class ExportUseCase {
  final ExportRepository repository;

  ExportUseCase(this.repository);

  Future<File> exportXml(Mau09Document document, String targetPath) =>
      repository.exportMau09Xml(document, targetPath);

  Future<File> exportExcel({
    required CompareResult compareResult,
    Mau09Document? mau09Document,
    required String targetPath,
  }) =>
      repository.exportExcelReport(compareResult, mau09Document, targetPath);
}
