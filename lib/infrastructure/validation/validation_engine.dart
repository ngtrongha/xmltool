import 'package:xmltool/domain/entities/mau09_document.dart';
import 'package:xmltool/domain/entities/validation_result.dart';
import 'package:xmltool/domain/entities/xml_envelope.dart';
import 'package:xmltool/infrastructure/validation/business_validator.dart';
import 'package:xmltool/infrastructure/validation/schema_validator.dart';
import 'package:xmltool/infrastructure/validation/xml_wellformed_validator.dart';

/// Central Validation Engine executing Level 1, Level 2, and Level 3 checks.
class ValidationEngine {
  final XmlWellformedValidator wellformedValidator;
  final SchemaValidator schemaValidator;
  final BusinessValidator businessValidator;

  ValidationEngine({
    XmlWellformedValidator? wellformedValidator,
    SchemaValidator? schemaValidator,
    BusinessValidator? businessValidator,
  })  : wellformedValidator = wellformedValidator ?? XmlWellformedValidator(),
        schemaValidator = schemaValidator ?? SchemaValidator(),
        businessValidator = businessValidator ?? BusinessValidator();

  /// Validate raw XML string (Level 1)
  ValidationResult validateXmlSyntax(String xmlContent) {
    return wellformedValidator.validate(xmlContent);
  }

  /// Validate parsed XmlEnvelope (Level 2 + Level 3)
  ValidationResult validateEnvelope(XmlEnvelope envelope) {
    final schemaRes = schemaValidator.validateEnvelope(envelope);
    final businessRes = businessValidator.validateEnvelope(envelope);
    return ValidationResult(
      issues: [...schemaRes.issues, ...businessRes.issues],
    );
  }

  /// Validate generated Mẫu 09 Document (Level 2 + Level 3)
  ValidationResult validateMau09(Mau09Document document) {
    final schemaRes = schemaValidator.validateMau09Document(document);
    final businessRes = businessValidator.validateMau09(document);
    return ValidationResult(
      issues: [...schemaRes.issues, ...businessRes.issues],
    );
  }

  /// Level 1: XML Well-formed syntax check
  ValidationResult validateLevel1(String xmlContent) => validateXmlSyntax(xmlContent);

  /// Level 2: Schema tag requirements check
  ValidationResult validateLevel2(XmlEnvelope envelope) => schemaValidator.validateEnvelope(envelope);

  /// Level 3: Business rules check
  ValidationResult validateLevel3(XmlEnvelope envelope) => businessValidator.validateEnvelope(envelope);
}
