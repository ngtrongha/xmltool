import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';
import 'package:xmltool/application/services/compare_service.dart';
import 'package:xmltool/application/services/mau09_mapping_service.dart';
import 'package:xmltool/application/services/validation_service.dart';
import 'package:xmltool/application/usecases/generate_mau09_usecase.dart';
import 'package:xmltool/config/standards/xml_definitions.dart';
import 'package:xmltool/domain/entities/audit_entry.dart';
import 'package:xmltool/domain/value_objects/change_type.dart';
import 'package:xmltool/infrastructure/database/app_database.dart';
import 'package:xmltool/infrastructure/mau09/mau09_excel_generator.dart';
import 'package:xmltool/infrastructure/mau09/mau09_xml_generator.dart';
import 'package:xmltool/infrastructure/repositories/drift_audit_repository.dart';
import 'package:xmltool/infrastructure/repositories/in_memory_repositories.dart';
import 'package:xmltool/infrastructure/xml/xml_parser.dart';

void main() {
  group('Full Reconciliation Pipeline End-to-End Integration Tests', () {
    late BHYTXmlParser parser;
    late CompareService compareService;
    late Mau09MappingService mappingService;
    late ValidationService validationService;
    late GenerateMau09UseCase generateMau09UseCase;
    late Mau09XmlGenerator xmlGenerator;
    late Mau09ExcelGenerator excelGenerator;
    late AppDatabase db;
    late DriftAuditRepository auditRepo;

    setUp(() {
      parser = BHYTXmlParser();
      compareService = CompareService();
      mappingService = Mau09MappingService();
      validationService = ValidationService();
      generateMau09UseCase = GenerateMau09UseCase(
        mappingService: mappingService,
        validationService: validationService,
        repository: InMemoryMau09Repository(),
      );
      xmlGenerator = Mau09XmlGenerator();
      excelGenerator = Mau09ExcelGenerator();
      db = AppDatabase(NativeDatabase.memory());
      auditRepo = DriftAuditRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('Runs full lifecycle: Parse -> Validate -> Match -> Compare -> Mẫu 09 -> XML & Excel Export -> SQLite Audit', () async {
      // 1. Read real 255KB sample file
      final oldFile = File(r'c:\Work\M3Soft_DKKhanhHoa\QuyetDinh_4750_2023_HSKCB\[KhongMaHoa]_data_257991_GD4565620337464_26137558.xml');
      expect(oldFile.existsSync(), isTrue);

      final oldEnvelope = await parser.parseFile(oldFile);
      expect(oldEnvelope.totalRecords, equals(177));

      // 2. Create modified XML string for New XML
      final oldXmlText = await oldFile.readAsString();
      // Alter drug quantity: replace first SO_LUONG 1.000 with 3.000 for MA_THUOC 40.519
      final newXmlText = oldXmlText.replaceFirst('<SO_LUONG>1.000</SO_LUONG>', '<SO_LUONG>3.000</SO_LUONG>');
      final newEnvelope = await parser.parseString(newXmlText, filePath: r'c:\temp\new_257991.xml');

      // 3. Validation level check
      final oldValidation = validationService.validateEnvelope(oldEnvelope);
      final newValidation = validationService.validateEnvelope(newEnvelope);
      expect(oldValidation.isValid, isTrue);
      expect(newValidation.isValid, isTrue);

      // 4. Run reconciliation
      final compareResult = compareService.executeComparison(
        oldEnvelope: oldEnvelope,
        newEnvelope: newEnvelope,
      );

      expect(compareResult.totalRecords, equals(177));
      expect(compareResult.changedCount, equals(1));
      expect(compareResult.unchangedCount, equals(176));
      expect(compareResult.mau09EligibleCount, equals(1));

      // Check the modified XML2 drug record
      final xml2Changes = compareResult.getChanges(XmlType.xml2);
      final modifiedRecord = xml2Changes.firstWhere((c) => c.changeType == ChangeType.changed);
      expect(modifiedRecord.fieldChanges.length, equals(1));
      expect(modifiedRecord.fieldChanges.first.field, equals('SO_LUONG'));
      expect(modifiedRecord.fieldChanges.first.oldValue, equals('1'));
      expect(modifiedRecord.fieldChanges.first.newValue, equals('3'));

      // 5. Generate Mẫu 09 Document (TT 12/2026/TT-BTC)
      final generateResult = await generateMau09UseCase.execute(
        compareResult: compareResult,
        newEnvelope: newEnvelope,
        oldEnvelope: oldEnvelope,
      );

      final doc = generateResult.document;
      expect(doc.totalRows, equals(1));
      final row = doc.allRows.first;
      expect(row.maLk, equals('257991'));
      expect(row.hoTen, equals('Trần Thị Điệp'));
      expect(row.truongTtGoc, equals('SO_LUONG'));
      expect(row.giaTriGoc, equals('1'));
      expect(row.truongTtDc, equals('SO_LUONG'));
      expect(row.giaTriDc, equals('3'));

      // 6. Generate Mẫu 09 XML Envelope
      final outputXml = xmlGenerator.generateXmlString(doc);
      expect(outputXml, contains('<LOAIHOSO>MAU_09</LOAIHOSO>'));
      expect(outputXml, contains('<TRUONG_TT_GOC>SO_LUONG</TRUONG_TT_GOC>'));
      expect(outputXml, contains('<GIATRI_GOC>1</GIATRI_GOC>'));
      expect(outputXml, contains('<TRUONG_TT_DC>SO_LUONG</TRUONG_TT_DC>'));
      expect(outputXml, contains('<GIATRI_DC>3</GIATRI_DC>'));

      final parsedXmlDoc = XmlDocument.parse(outputXml);
      expect(parsedXmlDoc.findAllElements('MAU_09').length, equals(1));

      // 7. Generate Excel 3-Sheet Report
      final tempExcelFile = File(r'c:\temp\test_report.xlsx');
      final exportedFile = await excelGenerator.generateExcelReport(
        compareResult: compareResult,
        mau09Document: doc,
        targetPath: tempExcelFile.path,
      );
      expect(exportedFile.existsSync(), isTrue);
      expect(await exportedFile.length(), greaterThan(1000));
      if (exportedFile.existsSync()) {
        await exportedFile.delete();
      }

      // 8. Save Audit Entry into SQLite
      final auditEntry = AuditEntry(
        id: '1',
        timestamp: DateTime.now(),
        oldFileName: oldFile.path.split(Platform.pathSeparator).last,
        newFileName: 'new_257991.xml',
        oldFileHash: 'sha256_mock_old',
        newFileHash: 'sha256_mock_new',
        outputFileName: 'MAU_09_257991.xml',
        outputFileHash: 'sha256_mock_out',
        standardVersion: 'QĐ 3176',
        totalClaims: doc.totalClaims,
        totalChanges: compareResult.changedCount,
        totalMau09Rows: doc.totalRows,
      );

      await auditRepo.logEntry(auditEntry);
      final logs = await auditRepo.getEntries();
      expect(logs.length, equals(1));
      expect(logs.first.oldFileName, equals('[KhongMaHoa]_data_257991_GD4565620337464_26137558.xml'));
      expect(logs.first.totalMau09Rows, equals(1));
    });
  });
}
