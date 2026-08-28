import 'package:flutter_test/flutter_test.dart';
import 'package:xmltool/config/standards/xml_definitions.dart';
import 'package:xmltool/domain/entities/xml_record.dart';
import 'package:xmltool/domain/value_objects/record_key.dart';
import 'package:xmltool/infrastructure/matching/matching_engine.dart';

void main() {
  group('MatchingEngine Tests', () {
    late MatchingEngine engine;

    setUp(() {
      engine = MatchingEngine();
    });

    test('Matches records exactly by Primary Key (MA_LK + STT)', () {
      final oldList = [
        const XmlRecord(
          xmlType: XmlType.xml2,
          key: RecordKey('123|1'),
          fields: {'MA_LK': '123', 'STT': '1', 'MA_THUOC': 'T01', 'SO_LUONG': '10'},
        ),
        const XmlRecord(
          xmlType: XmlType.xml2,
          key: RecordKey('123|2'),
          fields: {'MA_LK': '123', 'STT': '2', 'MA_THUOC': 'T02', 'SO_LUONG': '5'},
        ),
      ];

      final newList = [
        const XmlRecord(
          xmlType: XmlType.xml2,
          key: RecordKey('123|1'),
          fields: {'MA_LK': '123', 'STT': '1', 'MA_THUOC': 'T01', 'SO_LUONG': '12'},
        ),
        const XmlRecord(
          xmlType: XmlType.xml2,
          key: RecordKey('123|2'),
          fields: {'MA_LK': '123', 'STT': '2', 'MA_THUOC': 'T02', 'SO_LUONG': '5'},
        ),
      ];

      final result = engine.matchRecords(
        xmlType: XmlType.xml2,
        oldRecords: oldList,
        newRecords: newList,
      );

      expect(result.totalMatched, equals(2));
      expect(result.totalAdded, equals(0));
      expect(result.totalRemoved, equals(0));
      expect(result.matchedPairs.first.matchedByFallback, isFalse);
    });

    test('Matches records by Fallback Key (MA_THUOC + NGAY_YL) when STT is shifted or desynchronized', () {
      // Old XML has Drug T01 at STT=10
      final oldList = [
        const XmlRecord(
          xmlType: XmlType.xml2,
          key: RecordKey('123|10'),
          fields: {'MA_LK': '123', 'STT': '10', 'MA_THUOC': 'T01', 'NGAY_YL': '20260810'},
        ),
      ];

      // New XML has Drug T01 moved to STT=20 and a new Drug T_NEW at STT=30
      final newList = [
        const XmlRecord(
          xmlType: XmlType.xml2,
          key: RecordKey('123|20'),
          fields: {'MA_LK': '123', 'STT': '20', 'MA_THUOC': 'T01', 'NGAY_YL': '20260810'},
        ),
        const XmlRecord(
          xmlType: XmlType.xml2,
          key: RecordKey('123|30'),
          fields: {'MA_LK': '123', 'STT': '30', 'MA_THUOC': 'T_NEW', 'NGAY_YL': '20260810'},
        ),
      ];

      final result = engine.matchRecords(
        xmlType: XmlType.xml2,
        oldRecords: oldList,
        newRecords: newList,
      );

      // T01 should be matched via fallback key, and T_NEW is added
      expect(result.totalMatched, equals(1));
      expect(result.matchedPairs.first.matchedByFallback, isTrue);
      expect(result.totalAdded, equals(1));
      expect(result.addedRecords.first['MA_THUOC'], equals('T_NEW'));
      expect(result.totalRemoved, equals(0));
    });
  });
}
