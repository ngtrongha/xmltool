import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:xmltool/config/standards/xml_definitions.dart';
import 'package:xmltool/infrastructure/xml/xml_parser.dart';

void main() {
  group('BHYTXmlParser Tests with Real Sample Files', () {
    late BHYTXmlParser parser;

    setUp(() {
      parser = BHYTXmlParser();
    });

    test('Parses [KhongMaHoa]_data_257991_GD4565620337464_26137558.xml correctly', () async {
      final file = File(r'c:\Work\M3Soft_DKKhanhHoa\QuyetDinh_4750_2023_HSKCB\[KhongMaHoa]_data_257991_GD4565620337464_26137558.xml');
      expect(file.existsSync(), isTrue);

      final envelope = await parser.parseFile(file);
      expect(envelope.maCskcb, equals('56001'));
      expect(envelope.soLuongHoSo, equals(1));
      expect(envelope.danhSachHoSo.length, equals(1));

      final hoSo = envelope.danhSachHoSo.first;
      expect(hoSo.maLk, equals('257991'));

      // Check XML1
      final xml1 = hoSo.getFile(XmlType.xml1);
      expect(xml1, isNotNull);
      expect(xml1!.records.length, equals(1));
      expect(xml1.records.first.fields['HO_TEN'], equals('Trần Thị Điệp'));
      expect(xml1.records.first.fields['MA_THE_BHYT'], equals('GD4565760327464'));
      expect(xml1.records.first.fields['T_TONGCHI_BV'], equals('6305515.00'));

      // Check XML2 (Thuốc: 39 records)
      final xml2 = hoSo.getFile(XmlType.xml2);
      expect(xml2, isNotNull);
      expect(xml2!.records.length, equals(39));
      expect(xml2.records.first.fields['MA_THUOC'], equals('40.519'));

      // Check XML3 (DVKT: 42 records)
      final xml3 = hoSo.getFile(XmlType.xml3);
      expect(xml3, isNotNull);
      expect(xml3!.records.length, equals(42));

      // Check XML4 (CLS: 76 records)
      final xml4 = hoSo.getFile(XmlType.xml4);
      expect(xml4, isNotNull);
      expect(xml4!.records.length, equals(76));

      // Check XML5 (DBLS: 17 records)
      final xml5 = hoSo.getFile(XmlType.xml5);
      expect(xml5, isNotNull);
      expect(xml5!.records.length, equals(17));

      // Check XML7 (Giấy ra viện: 1 record)
      final xml7 = hoSo.getFile(XmlType.xml7);
      expect(xml7, isNotNull);
      expect(xml7!.records.length, equals(1));

      // Check XML8 (Tóm tắt HSBA: 1 record)
      final xml8 = hoSo.getFile(XmlType.xml8);
      expect(xml8, isNotNull);
      expect(xml8!.records.length, equals(1));

      // Total records across all 7 XMLs: 1 + 39 + 42 + 76 + 17 + 1 + 1 = 177
      expect(hoSo.totalRecords, equals(177));
    });
  });
}
