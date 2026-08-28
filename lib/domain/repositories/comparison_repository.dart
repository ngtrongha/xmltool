import 'package:xmltool/domain/entities/compare_result.dart';

/// Contract for persisting and retrieving comparison results.
abstract class ComparisonRepository {
  Future<void> saveResult(CompareResult result);
  Future<CompareResult?> getLatestResult();
  Future<List<CompareResult>> getAllResults();
  Future<void> clearResults();
}
