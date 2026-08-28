import 'package:xmltool/domain/entities/mau09_document.dart';
import 'package:xmltool/domain/entities/validation_result.dart';
import 'package:xmltool/domain/entities/xml_envelope.dart';
import 'package:xmltool/infrastructure/validation/validation_engine.dart';

/// Application service running validation checks.
class ValidationService {
  final ValidationEngine engine;

  ValidationService({ValidationEngine? engine}) : engine = engine ?? ValidationEngine();

  ValidationResult validateEnvelope(XmlEnvelope envelope) =>
      engine.validateEnvelope(envelope);

  ValidationResult validateMau09(Mau09Document document) =>
      engine.validateMau09(document);

  ValidationResult validateXmlSyntax(String content) =>
      engine.validateXmlSyntax(content);
}
