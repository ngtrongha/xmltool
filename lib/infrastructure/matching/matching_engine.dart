import 'package:xmltool/config/standards/xml_definitions.dart';
import 'package:xmltool/domain/entities/match_result.dart';
import 'package:xmltool/domain/entities/xml_record.dart';
import 'package:xmltool/infrastructure/matching/key_builder.dart';

/// Robust record matching engine with primary key matching and fallback key strategy.
class MatchingEngine {
  /// Matches a list of old records against new records for a given [XmlType].
  MatchResult matchRecords({
    required XmlType xmlType,
    required List<XmlRecord> oldRecords,
    required List<XmlRecord> newRecords,
  }) {
    final matchedPairs = <MatchedPair>[];
    final remainingOld = <XmlRecord>[...oldRecords];
    final remainingNew = <XmlRecord>[...newRecords];
    final ambiguousRecords = <XmlRecord>[];

    // =========================================================================
    // PHASE 1: Direct Primary Key Matching (MA_LK + STT / MA_LK)
    // =========================================================================
    final newByPrimary = <String, XmlRecord>{};
    for (final rec in remainingNew) {
      newByPrimary[rec.key.value] = rec;
    }

    final matchedOldIndices = <int>{};
    final matchedNewKeys = <String>{};

    for (var i = 0; i < remainingOld.length; i++) {
      final oldRec = remainingOld[i];
      final newRec = newByPrimary[oldRec.key.value];

      if (newRec != null) {
        matchedPairs.add(MatchedPair(
          oldRecord: oldRec,
          newRecord: newRec,
          matchedByFallback: false,
        ));
        matchedOldIndices.add(i);
        matchedNewKeys.add(newRec.key.value);
      }
    }

    // Filter out matched in Phase 1
    final unmatchedOld = <XmlRecord>[];
    for (var i = 0; i < remainingOld.length; i++) {
      if (!matchedOldIndices.contains(i)) {
        unmatchedOld.add(remainingOld[i]);
      }
    }

    final unmatchedNew = remainingNew.where((rec) => !matchedNewKeys.contains(rec.key.value)).toList();

    // If all matched, return early
    if (unmatchedOld.isEmpty && unmatchedNew.isEmpty) {
      return MatchResult(
        xmlType: xmlType,
        matchedPairs: matchedPairs,
      );
    }

    // =========================================================================
    // PHASE 2: Fallback Key Matching (e.g. MA_THUOC + NGAY_YL, MA_DICH_VU + NGAY_YL)
    // =========================================================================
    final newByFallback = <String, List<XmlRecord>>{};
    for (final rec in unmatchedNew) {
      final fbKey = KeyBuilder.buildFallbackKey(rec) ?? KeyBuilder.buildFallbackAltKey(rec);
      if (fbKey != null) {
        newByFallback.putIfAbsent(fbKey.value, () => []).add(rec);
      }
    }

    final stillUnmatchedOld = <XmlRecord>[];
    final matchedNewInPhase2 = <XmlRecord>{};

    for (final oldRec in unmatchedOld) {
      final fbKey = KeyBuilder.buildFallbackKey(oldRec) ?? KeyBuilder.buildFallbackAltKey(oldRec);
      if (fbKey == null) {
        stillUnmatchedOld.add(oldRec);
        continue;
      }

      final candidates = newByFallback[fbKey.value];
      if (candidates != null && candidates.isNotEmpty) {
        if (candidates.length == 1) {
          final matchedNew = candidates.first;
          matchedPairs.add(MatchedPair(
            oldRecord: oldRec,
            newRecord: matchedNew,
            matchedByFallback: true,
          ));
          matchedNewInPhase2.add(matchedNew);
          candidates.removeAt(0);
        } else {
          // Ambiguous: multiple records match same fallback key
          ambiguousRecords.add(oldRec);
        }
      } else {
        stillUnmatchedOld.add(oldRec);
      }
    }

    final stillUnmatchedNew = unmatchedNew.where((rec) => !matchedNewInPhase2.contains(rec)).toList();

    return MatchResult(
      xmlType: xmlType,
      matchedPairs: matchedPairs,
      addedRecords: stillUnmatchedNew,
      removedRecords: stillUnmatchedOld,
      ambiguousRecords: ambiguousRecords,
    );
  }
}
