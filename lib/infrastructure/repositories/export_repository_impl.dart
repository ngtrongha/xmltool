import 'dart:convert';
import 'dart:io';
import 'package:xmltool/domain/entities/compare_result.dart';
import 'package:xmltool/domain/entities/mau09_document.dart';
import 'package:xmltool/domain/repositories/export_repository.dart';
import 'package:xmltool/infrastructure/mau09/mau09_excel_generator.dart';
import 'package:xmltool/infrastructure/mau09/mau09_xml_generator.dart';

/// Implementation of ExportRepository using XML and Excel generators.
class ExportRepositoryImpl implements ExportRepository {
  final Mau09XmlGenerator xmlGenerator;
  final Mau09ExcelGenerator excelGenerator;

  ExportRepositoryImpl({
    Mau09XmlGenerator? xmlGenerator,
    Mau09ExcelGenerator? excelGenerator,
  })  : xmlGenerator = xmlGenerator ?? Mau09XmlGenerator(),
        excelGenerator = excelGenerator ?? Mau09ExcelGenerator();

  @override
  Future<File> exportMau09Xml(Mau09Document document, String targetPath) async {
    final xmlString = xmlGenerator.generateXmlString(document);
    final file = File(targetPath);
    await file.parent.create(recursive: true);
    await file.writeAsString(xmlString, encoding: utf8);
    return file;
  }

  @override
  Future<File> exportExcelReport(
    CompareResult compareResult,
    Mau09Document? mau09Document,
    String targetPath,
  ) async {
    return excelGenerator.generateExcelReport(
      compareResult: compareResult,
      mau09Document: mau09Document,
      targetPath: targetPath,
    );
  }
}
