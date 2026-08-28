import 'package:flutter_test/flutter_test.dart';
import 'package:xmltool/config/standards/field_definitions.dart';
import 'package:xmltool/infrastructure/normalizers/cdata_normalizer.dart';
import 'package:xmltool/infrastructure/normalizers/composite_normalizer.dart';
import 'package:xmltool/infrastructure/normalizers/date_normalizer.dart';
import 'package:xmltool/infrastructure/normalizers/decimal_normalizer.dart';
import 'package:xmltool/infrastructure/normalizers/null_normalizer.dart';
import 'package:xmltool/infrastructure/normalizers/whitespace_normalizer.dart';

void main() {
  group('Normalizer Unit Tests', () {
    test('DecimalNormalizer converts comma to dot and strips trailing zeroes', () {
      final norm = DecimalNormalizer();

      expect(norm.normalize('70000.00'), equals('70000'));
      expect(norm.normalize('70000'), equals('70000'));
      expect(norm.normalize('2,20'), equals('2.2'));
      expect(norm.normalize('5.01'), equals('5.01'));
      expect(norm.normalize('1.000'), equals('1'));
      expect(norm.normalize('0.500'), equals('0.5'));
      expect(norm.normalize('-0.00'), equals('0'));
    });

    test('WhitespaceNormalizer trims and collapses spaces', () {
      final norm = WhitespaceNormalizer();

      expect(norm.normalize('  hello world  '), equals('hello world'));
      expect(norm.normalize('PARACETAMOL   500MG'), equals('PARACETAMOL 500MG'));
      expect(norm.normalize('   '), equals(''));
    });

    test('NullNormalizer handles empty and null representations', () {
      final norm = NullNormalizer();

      expect(norm.normalize(''), isNull);
      expect(norm.normalize('   '), isNull);
      expect(norm.normalize('null'), isNull);
      expect(norm.normalize('<![CDATA[]]>'), isNull);
      expect(norm.normalize('ABC'), equals('ABC'));
    });

    test('CdataNormalizer strips CDATA wrapper correctly', () {
      final norm = CdataNormalizer();

      expect(norm.normalize('<![CDATA[Viêm họng cấp]]>'), equals('Viêm họng cấp'));
      expect(norm.normalize('Nguyễn Văn A'), equals('Nguyễn Văn A'));
    });

    test('DateNormalizer strips dummy placeholders', () {
      final norm = DateNormalizer();

      expect(norm.normalize('000101010000'), isNull);
      expect(norm.normalize('00010101'), isNull);
      expect(norm.normalize('19000101'), isNull);
      expect(norm.normalize('202608151200'), equals('202608151200'));
    });

    test('CompositeNormalizer runs all rules sequentially', () {
      final composite = CompositeNormalizer();

      // CDATA with decimal and spaces
      expect(composite.normalize(' <![CDATA[ 70000,00 ]]> ', FieldDataType.decimal), equals('70000'));
      // Dummy date in CDATA
      expect(composite.normalize('<![CDATA[000101010000]]>', FieldDataType.datetime12), isNull);
    });
  });
}
