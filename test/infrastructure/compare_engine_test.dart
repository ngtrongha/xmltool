import 'package:flutter_test/flutter_test.dart';
import 'package:xmltool/config/standards/mau09_mappings.dart';
import 'package:xmltool/config/standards/xml_definitions.dart';
import 'package:xmltool/domain/entities/file_ho_so.dart';
import 'package:xmltool/domain/entities/ho_so.dart';
import 'package:xmltool/domain/entities/xml_envelope.dart';
import 'package:xmltool/domain/entities/xml_record.dart';
import 'package:xmltool/domain/value_objects/change_type.dart';
import 'package:xmltool/domain/value_objects/record_key.dart';
import 'package:xmltool/infrastructure/compare/compare_engine.dart';

void main() {
  group('CompareEngine & Mẫu 09 Eligibility Tests', () {
    late CompareEngine engine;

    setUp(() {
      engine = CompareEngine();
    });

    test('01. Detects completely unchanged XML', () {
      final oldEnvelope = XmlEnvelope(
        maCskcb: '56001',
        ngayLap: '20260810',
        soLuongHoSo: 1,
        danhSachHoSo: [
          const HoSo(
            maLk: '257991',
            fileList: [
              FileHoSo(
                xmlType: XmlType.xml2,
                records: [
                  XmlRecord(
                    xmlType: XmlType.xml2,
                    key: RecordKey('257991|1'),
                    fields: {'MA_LK': '257991', 'STT': '1', 'SO_LUONG': '1.000', 'DON_GIA': '70000.00'},
                  ),
                ],
              ),
            ],
          ),
        ],
      );

      final newEnvelope = XmlEnvelope(
        maCskcb: '56001',
        ngayLap: '20260810',
        soLuongHoSo: 1,
        danhSachHoSo: [
          const HoSo(
            maLk: '257991',
            fileList: [
              FileHoSo(
                xmlType: XmlType.xml2,
                records: [
                  XmlRecord(
                    xmlType: XmlType.xml2,
                    key: RecordKey('257991|1'),
                    // Different string formatting (1 vs 1.000, 70000 vs 70000.00) but equivalent
                    fields: {'MA_LK': '257991', 'STT': '1', 'SO_LUONG': '1', 'DON_GIA': '70000'},
                  ),
                ],
              ),
            ],
          ),
        ],
      );

      final result = engine.compare(oldEnvelope: oldEnvelope, newEnvelope: newEnvelope);

      expect(result.unchangedCount, equals(1));
      expect(result.changedCount, equals(0));
      expect(result.mau09EligibleCount, equals(0));
    });

    test('02. Detects single field change and classifies as Mẫu 09 adjustable', () {
      final oldEnvelope = XmlEnvelope(
        maCskcb: '56001',
        ngayLap: '20260810',
        soLuongHoSo: 1,
        danhSachHoSo: [
          const HoSo(
            maLk: '257991',
            fileList: [
              FileHoSo(
                xmlType: XmlType.xml2,
                records: [
                  XmlRecord(
                    xmlType: XmlType.xml2,
                    key: RecordKey('257991|1'),
                    fields: {'MA_LK': '257991', 'STT': '1', 'SO_LUONG': '1.000', 'DON_GIA': '70000.00'},
                  ),
                ],
              ),
            ],
          ),
        ],
      );

      final newEnvelope = XmlEnvelope(
        maCskcb: '56001',
        ngayLap: '20260810',
        soLuongHoSo: 1,
        danhSachHoSo: [
          const HoSo(
            maLk: '257991',
            fileList: [
              FileHoSo(
                xmlType: XmlType.xml2,
                records: [
                  XmlRecord(
                    xmlType: XmlType.xml2,
                    key: RecordKey('257991|1'),
                    fields: {'MA_LK': '257991', 'STT': '1', 'SO_LUONG': '2.000', 'DON_GIA': '70000.00'},
                  ),
                ],
              ),
            ],
          ),
        ],
      );

      final result = engine.compare(oldEnvelope: oldEnvelope, newEnvelope: newEnvelope);

      expect(result.changedCount, equals(1));
      final change = result.getChanges(XmlType.xml2).first;
      expect(change.changeType, equals(ChangeType.changed));
      expect(change.fieldChanges.length, equals(1));

      final fieldChange = change.fieldChanges.first;
      expect(fieldChange.field, equals('SO_LUONG'));
      expect(fieldChange.oldValue, equals('1'));
      expect(fieldChange.newValue, equals('2'));
      expect(fieldChange.eligibility, equals(ChangeEligibility.adjustable));
    });
  });
}
