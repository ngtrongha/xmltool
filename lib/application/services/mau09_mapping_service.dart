import 'package:xmltool/domain/entities/compare_result.dart';
import 'package:xmltool/domain/entities/mau09_document.dart';
import 'package:xmltool/domain/entities/xml_envelope.dart';
import 'package:xmltool/infrastructure/mau09/mau09_mapper.dart';

/// Application service for transforming comparison diffs to Mẫu 09 adjustment documents.
class Mau09MappingService {
  final Mau09Mapper mapper;

  Mau09MappingService({Mau09Mapper? mapper}) : mapper = mapper ?? Mau09Mapper();

  Mau09Document generateMau09({
    required CompareResult compareResult,
    required XmlEnvelope newEnvelope,
    XmlEnvelope? oldEnvelope,
    String defaultReason = 'Điều chỉnh thông tin/chi phí theo hồ sơ bệnh án',
  }) {
    return mapper.mapToMau09Document(
      compareResult: compareResult,
      newEnvelope: newEnvelope,
      oldEnvelope: oldEnvelope,
      defaultReason: defaultReason,
    );
  }
}
