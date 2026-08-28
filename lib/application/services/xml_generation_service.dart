import 'package:xmltool/domain/entities/mau09_document.dart';
import 'package:xmltool/infrastructure/mau09/mau09_xml_generator.dart';

/// Application service generating XML strings and documents.
class XmlGenerationService {
  final Mau09XmlGenerator generator;

  XmlGenerationService({Mau09XmlGenerator? generator})
      : generator = generator ?? Mau09XmlGenerator();

  String generateMau09XmlString(Mau09Document document) {
    return generator.generateXmlString(document);
  }
}
