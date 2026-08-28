import 'package:equatable/equatable.dart';
import 'package:xmltool/config/standards/xml_definitions.dart';
import 'package:xmltool/domain/entities/xml_record.dart';

/// Single matched pair of records.
class MatchedPair extends Equatable {
  final XmlRecord oldRecord;
  final XmlRecord newRecord;
  final bool matchedByFallback;

  const MatchedPair({
    required this.oldRecord,
    required this.newRecord,
    this.matchedByFallback = false,
  });

  @override
  List<Object?> get props => [oldRecord, newRecord, matchedByFallback];
}

/// Output of matching old records against new records for a given XML type.
class MatchResult extends Equatable {
  final XmlType xmlType;
  final List<MatchedPair> matchedPairs;
  final List<XmlRecord> addedRecords;
  final List<XmlRecord> removedRecords;
  final List<XmlRecord> ambiguousRecords;

  const MatchResult({
    required this.xmlType,
    this.matchedPairs = const [],
    this.addedRecords = const [],
    this.removedRecords = const [],
    this.ambiguousRecords = const [],
  });

  int get totalMatched => matchedPairs.length;
  int get totalAdded => addedRecords.length;
  int get totalRemoved => removedRecords.length;
  int get totalAmbiguous => ambiguousRecords.length;

  @override
  List<Object?> get props => [
        xmlType,
        matchedPairs,
        addedRecords,
        removedRecords,
        ambiguousRecords,
      ];
}
