import 'dart:io';
import 'package:xmltool/domain/entities/xml_envelope.dart';
import 'package:xmltool/domain/repositories/xml_file_repository.dart';

/// Application service orchestrating XML file parsing.
class XmlParseService {
  final XmlFileRepository repository;

  XmlParseService(this.repository);

  Future<XmlEnvelope> parseFile(File file) => repository.parseFile(file);

  Future<XmlEnvelope> parseString(String content, {String? filePath}) =>
      repository.parseString(content, filePath: filePath);
}
