import 'package:flutter_test/flutter_test.dart';
import 'package:xmltool/config/standards/xml_definitions.dart';
import 'package:xmltool/domain/entities/file_ho_so.dart';
import 'package:xmltool/domain/entities/ho_so.dart';
import 'package:xmltool/domain/entities/xml_envelope.dart';
import 'package:xmltool/domain/entities/xml_record.dart';
import 'package:xmltool/domain/value_objects/record_key.dart';
import 'package:xmltool/infrastructure/validation/validation_engine.dart';

void main() {
  group('ValidationEngine Tests (3 Levels)', () {
    late ValidationEngine engine;

    setUp(() {
      engine = ValidationEngine();
    });

    test('Level 1: Rejects malformed XML string', () {
      const brokenXml = '<GIAMDINHHS><THONGTINDONVI></GIAMDINHHS>';
      final result = engine.validateLevel1(brokenXml);

      expect(result.isValid, isFalse);
      expect(result.errors.first.level, equals(1));
    });

    test('Level 1: Accepts well-formed XML string', () {
      const validXml = '<GIAMDINHHS><THONGTINDONVI><MACSKCB>56001</MACSKCB></THONGTINDONVI></GIAMDINHHS>';
      final result = engine.validateLevel1(validXml);

      expect(result.isValid, isTrue);
    });

    test('Level 2: Detects missing required envelope fields', () {
      final envelope = XmlEnvelope(
        maCskcb: '', // missing MACSKCB
        ngayLap: '20260810',
        soLuongHoSo: 0,
        danhSachHoSo: [],
      );

      final result = engine.validateLevel2(envelope);
      expect(result.isValid, isFalse);
      expect(result.errors.any((e) => e.level == 2), isTrue);
    });

    test('Level 3: Detects invalid/negative amounts in detail records', () {
      final envelope = XmlEnvelope(
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
                    fields: {
                      'MA_LK': '257991',
                      'STT': '1',
                      'MA_THUOC': 'T01',
                      'SO_LUONG': '-5', // Negative quantity
                      'DON_GIA': '70000',
                      'THANH_TIEN': '-350000', // Negative amount
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      );

      final result = engine.validateLevel3(envelope);
      expect(result.isValid, isFalse);
      expect(result.errors.any((e) => e.level == 3), isTrue);
    });
  });
}
