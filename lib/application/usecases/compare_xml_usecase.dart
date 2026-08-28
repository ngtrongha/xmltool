import 'package:xmltool/application/services/compare_service.dart';
import 'package:xmltool/domain/entities/compare_result.dart';
import 'package:xmltool/domain/entities/xml_envelope.dart';
import 'package:xmltool/domain/repositories/comparison_repository.dart';

/// UseCase: Run complete reconciliation comparison between old and new envelopes.
class CompareXmlUseCase {
  final CompareService compareService;
  final ComparisonRepository? comparisonRepository;

  CompareXmlUseCase({
    required this.compareService,
    this.comparisonRepository,
  });

  Future<CompareResult> execute({
    required XmlEnvelope oldEnvelope,
    required XmlEnvelope newEnvelope,
  }) async {
    final result = compareService.executeComparison(
      oldEnvelope: oldEnvelope,
      newEnvelope: newEnvelope,
    );

    if (comparisonRepository != null) {
      await comparisonRepository!.saveResult(result);
    }

    return result;
  }
}
