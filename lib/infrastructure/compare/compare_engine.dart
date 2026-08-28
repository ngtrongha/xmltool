import 'package:xmltool/config/standards/xml_definitions.dart';
import 'package:xmltool/domain/entities/compare_result.dart';
import 'package:xmltool/domain/entities/record_change.dart';
import 'package:xmltool/domain/entities/xml_envelope.dart';
import 'package:xmltool/domain/entities/xml_record.dart';
import 'package:xmltool/domain/value_objects/change_type.dart';
import 'package:xmltool/infrastructure/compare/record_comparator.dart';
import 'package:xmltool/infrastructure/matching/matching_engine.dart';

/// Full reconciliation pipeline comparing two XmlEnvelope instances.
class CompareEngine {
  final MatchingEngine matchingEngine;
  final RecordComparator recordComparator;

  CompareEngine({
    MatchingEngine? matchingEngine,
    RecordComparator? recordComparator,
  })  : matchingEngine = matchingEngine ?? MatchingEngine(),
        recordComparator = recordComparator ?? RecordComparator();

  /// Executes full comparison between old and new XML envelopes.
  CompareResult compare({
    required XmlEnvelope oldEnvelope,
    required XmlEnvelope newEnvelope,
  }) {
    final changesByXmlType = <XmlType, List<RecordChange>>{};

    // Determine all XML types present in either envelope
    final allTypes = <XmlType>{};
    for (final hs in oldEnvelope.danhSachHoSo) {
      for (final f in hs.fileList) {
        allTypes.add(f.xmlType);
      }
    }
    for (final hs in newEnvelope.danhSachHoSo) {
      for (final f in hs.fileList) {
        allTypes.add(f.xmlType);
      }
    }

    for (final xmlType in allTypes) {
      final oldRecords = _extractRecords(oldEnvelope, xmlType);
      final newRecords = _extractRecords(newEnvelope, xmlType);

      final matchResult = matchingEngine.matchRecords(
        xmlType: xmlType,
        oldRecords: oldRecords,
        newRecords: newRecords,
      );

      final recordChanges = <RecordChange>[];

      // 1. Matched Pairs (Compare fields)
      for (final pair in matchResult.matchedPairs) {
        final change = recordComparator.compareRecords(
          xmlType: xmlType,
          oldRecord: pair.oldRecord,
          newRecord: pair.newRecord,
        );
        recordChanges.add(change);
      }

      // 2. Added Records (in new, not in old)
      for (final addedRec in matchResult.addedRecords) {
        recordChanges.add(RecordChange(
          xmlType: xmlType,
          key: addedRec.key,
          changeType: ChangeType.added,
          newRecord: addedRec,
        ));
      }

      // 3. Removed Records (in old, not in new)
      for (final removedRec in matchResult.removedRecords) {
        recordChanges.add(RecordChange(
          xmlType: xmlType,
          key: removedRec.key,
          changeType: ChangeType.removed,
          oldRecord: removedRec,
        ));
      }

      // 4. Ambiguous Records
      for (final ambRec in matchResult.ambiguousRecords) {
        recordChanges.add(RecordChange(
          xmlType: xmlType,
          key: ambRec.key,
          changeType: ChangeType.ambiguous,
          oldRecord: ambRec,
        ));
      }

      changesByXmlType[xmlType] = recordChanges;
    }

    return CompareResult(
      oldFilePath: oldEnvelope.filePath ?? '',
      newFilePath: newEnvelope.filePath ?? '',
      oldFileHash: oldEnvelope.fileHash ?? '',
      newFileHash: newEnvelope.fileHash ?? '',
      comparedAt: DateTime.now(),
      changesByXmlType: changesByXmlType,
    );
  }

  List<XmlRecord> _extractRecords(XmlEnvelope envelope, XmlType xmlType) {
    final list = <XmlRecord>[];
    for (final hs in envelope.danhSachHoSo) {
      final file = hs.getFile(xmlType);
      if (file != null) {
        list.addAll(file.records);
      }
    }
    return list;
  }
}
