import 'dart:io';
import 'package:xmltool/domain/entities/xml_envelope.dart';

/// Contract for parsing and loading XML claim files.
abstract class XmlFileRepository {
  /// Parse an XML file from path (supporting both Plain XML and Base64 encapsulated files).
  Future<XmlEnvelope> parseFile(File file);

  /// Parse XML from raw string content.
  Future<XmlEnvelope> parseString(String content, {String? filePath});
}
