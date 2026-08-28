import 'package:xmltool/application/services/mau09_mapping_service.dart';
import 'package:xmltool/application/services/validation_service.dart';
import 'package:xmltool/domain/entities/compare_result.dart';
import 'package:xmltool/domain/entities/mau09_document.dart';
import 'package:xmltool/domain/entities/validation_result.dart';
import 'package:xmltool/domain/entities/xml_envelope.dart';
import 'package:xmltool/domain/repositories/mau09_repository.dart';

class GenerateMau09Result {
  final Mau09Document document;
  final ValidationResult validationResult;

  const GenerateMau09Result({
    required this.document,
    required this.validationResult,
  });
}

/// UseCase: Generate Mẫu 09 adjustment document and validate it.
class GenerateMau09UseCase {
  final Mau09MappingService mappingService;
  final ValidationService validationService;
  final Mau09Repository? repository;

  GenerateMau09UseCase({
    required this.mappingService,
    required this.validationService,
    this.repository,
  });

  Future<GenerateMau09Result> execute({
    required CompareResult compareResult,
    required XmlEnvelope newEnvelope,
    XmlEnvelope? oldEnvelope,
    String defaultReason = 'Điều chỉnh thông tin/chi phí theo hồ sơ bệnh án',
  }) async {
    final doc = mappingService.generateMau09(
      compareResult: compareResult,
      newEnvelope: newEnvelope,
      oldEnvelope: oldEnvelope,
      defaultReason: defaultReason,
    );

    final validation = validationService.validateMau09(doc);

    if (repository != null) {
      await repository!.saveDocument(doc);
    }

    return GenerateMau09Result(
      document: doc,
      validationResult: validation,
    );
  }
}
