import 'dart:io';
import 'package:xmltool/application/services/validation_service.dart';
import 'package:xmltool/application/services/xml_parse_service.dart';
import 'package:xmltool/domain/entities/validation_result.dart';
import 'package:xmltool/domain/entities/xml_envelope.dart';

class ImportXmlResult {
  final XmlEnvelope envelope;
  final ValidationResult validationResult;

  const ImportXmlResult({
    required this.envelope,
    required this.validationResult,
  });
}

/// UseCase: Import and validate an XML claim file.
class ImportXmlUseCase {
  final XmlParseService parseService;
  final ValidationService validationService;

  ImportXmlUseCase({
    required this.parseService,
    required this.validationService,
  });

  Future<ImportXmlResult> execute(File file) async {
    final envelope = await parseService.parseFile(file);
    final validation = validationService.validateEnvelope(envelope);
    return ImportXmlResult(
      envelope: envelope,
      validationResult: validation,
    );
  }
}
