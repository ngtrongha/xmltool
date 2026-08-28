import 'package:xmltool/domain/entities/mau09_document.dart';

/// Contract for persisting and retrieving Mẫu 09 adjustment documents.
abstract class Mau09Repository {
  Future<void> saveDocument(Mau09Document document);
  Future<Mau09Document?> getLatestDocument();
}
