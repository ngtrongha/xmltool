import 'package:xmltool/domain/entities/audit_entry.dart';
import 'package:xmltool/domain/entities/compare_result.dart';
import 'package:xmltool/domain/entities/mau09_document.dart';
import 'package:xmltool/domain/repositories/audit_repository.dart';
import 'package:xmltool/domain/repositories/comparison_repository.dart';
import 'package:xmltool/domain/repositories/mau09_repository.dart';

/// In-memory repository for comparison results.
class InMemoryComparisonRepository implements ComparisonRepository {
  final List<CompareResult> _results = [];

  @override
  Future<void> saveResult(CompareResult result) async {
    _results.insert(0, result);
  }

  @override
  Future<CompareResult?> getLatestResult() async {
    return _results.isEmpty ? null : _results.first;
  }

  @override
  Future<List<CompareResult>> getAllResults() async {
    return List.unmodifiable(_results);
  }

  @override
  Future<void> clearResults() async {
    _results.clear();
  }
}

/// In-memory repository for Mẫu 09 documents.
class InMemoryMau09Repository implements Mau09Repository {
  Mau09Document? _document;

  @override
  Future<void> saveDocument(Mau09Document document) async {
    _document = document;
  }

  @override
  Future<Mau09Document?> getLatestDocument() async {
    return _document;
  }
}

/// In-memory repository for audit entries.
class InMemoryAuditRepository implements AuditRepository {
  final List<AuditEntry> _entries = [];

  @override
  Future<void> logEntry(AuditEntry entry) async {
    _entries.insert(0, entry);
  }

  @override
  Future<List<AuditEntry>> getEntries({int limit = 100, int offset = 0}) async {
    if (offset >= _entries.length) return [];
    final end = (offset + limit) > _entries.length ? _entries.length : (offset + limit);
    return _entries.sublist(offset, end);
  }

  @override
  Future<AuditEntry?> getEntryById(String id) async {
    for (final e in _entries) {
      if (e.id == id) return e;
    }
    return null;
  }

  @override
  Future<void> clearAll() async {
    _entries.clear();
  }
}
