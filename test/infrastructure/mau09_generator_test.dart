import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';
import 'package:xmltool/domain/entities/mau09_document.dart';
import 'package:xmltool/domain/entities/mau09_row.dart';
import 'package:xmltool/infrastructure/mau09/mau09_xml_generator.dart';

void main() {
  group('Mau09XmlGenerator Tests (Thông tư 12/2026/TT-BTC)', () {
    late Mau09XmlGenerator generator;

    setUp(() {
      generator = Mau09XmlGenerator();
    });

    test('Generates valid XML envelope with GIAMDINHHS and LOAIHOSO=MAU_09', () {
      const row = Mau09Row(
        stt: 1,
        hoTen: 'Trần Thị Điệp',
        maTheBhyt: 'GD4565760327464',
        ngayVao: '202608060714',
        ngayRa: '202608131700',
        maLk: '257991',
        maBn: '257991',
        ngayYl: '202608071523',
        truongTtGoc: 'SO_LUONG',
        giaTriGoc: '1.000',
        truongTtDc: 'SO_LUONG',
        giaTriDc: '2.000',
        lyDoDc: 'Điều chỉnh số lượng thuốc theo bệnh án',
      );

      const doc = Mau09Document(
        maCskcb: '56001',
        ngayLap: '20260828',
        hoSoList: [
          Mau09HoSo(
            maLk: '257991',
            rows: [row],
          ),
        ],
      );

      final xmlString = generator.generateXmlString(doc);
      expect(xmlString, contains('<GIAMDINHHS'));
      expect(xmlString, contains('<LOAIHOSO>MAU_09</LOAIHOSO>'));
      expect(xmlString, contains('<MACSKCB>56001</MACSKCB>'));
      expect(xmlString, contains('<MAU_09>'));
      expect(xmlString, contains('<HO_TEN>Trần Thị Điệp</HO_TEN>'));
      expect(xmlString, contains('<TRUONG_TT_GOC>SO_LUONG</TRUONG_TT_GOC>'));
      expect(xmlString, contains('<GIATRI_GOC>1.000</GIATRI_GOC>'));
      expect(xmlString, contains('<TRUONG_TT_DC>SO_LUONG</TRUONG_TT_DC>'));
      expect(xmlString, contains('<GIATRI_DC>2.000</GIATRI_DC>'));
      expect(xmlString, contains('<LY_DO_DC>Điều chỉnh số lượng thuốc theo bệnh án</LY_DO_DC>'));

      // Validate parsed XML syntax
      final parsed = XmlDocument.parse(xmlString);
      expect(parsed.rootElement.name.local, equals('GIAMDINHHS'));
      expect(parsed.findAllElements('MAU_09').length, equals(1));
    });
  });
}
