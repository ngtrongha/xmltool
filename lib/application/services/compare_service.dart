import 'package:xmltool/domain/entities/compare_result.dart';
import 'package:xmltool/domain/entities/xml_envelope.dart';
import 'package:xmltool/infrastructure/compare/compare_engine.dart';

/// Application service running full comparison between two XML claim sets.
class CompareService {
  final CompareEngine engine;

  CompareService({CompareEngine? engine}) : engine = engine ?? CompareEngine();

  CompareResult executeComparison({
    required XmlEnvelope oldEnvelope,
    required XmlEnvelope newEnvelope,
  }) {
    return engine.compare(
      oldEnvelope: oldEnvelope,
      newEnvelope: newEnvelope,
    );
  }
}
