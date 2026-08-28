import 'package:flutter_test/flutter_test.dart';
import 'package:xmltool/domain/entities/mau09_document.dart';
import 'package:xmltool/domain/entities/mau09_row.dart';
import 'package:xmltool/infrastructure/mau09/mau09_xml_generator.dart';
import 'package:xmltool/infrastructure/security/bhyt_digital_signer.dart';

void main() {
  group('BHYTDigitalSigner Tests (XMLDSig RSA-SHA256)', () {
    late BHYTDigitalSigner signer;
    late Mau09XmlGenerator xmlGenerator;

    setUp(() {
      signer = BHYTDigitalSigner();
      xmlGenerator = Mau09XmlGenerator();
    });

    test('Generates valid test medical certificate and RSA 2048-bit keypair', () {
      final certData = signer.generateTestMedicalCertificate(
        hospitalName: 'BỆNH VIỆN ĐA KHOA HÀ NỘI',
        cskcbCode: '01001',
      );

      expect(certData.certificate.displayName, contains('BỆNH VIỆN ĐA KHOA HÀ NỘI'));
      expect(certData.certificate.isValidNow, isTrue);
      expect(certData.publicKey.modulus, isNotNull);
      expect(certData.privateKey.privateExponent, isNotNull);
    });

    test('Signs Mẫu 09 XML document and produces valid W3C XMLDSig in CHUKYSO', () {
      final doc = const Mau09Document(
        maCskcb: '01001',
        maTinh: '01',
        tenTinh: 'Hà Nội',
        ngayLap: '202608281500',
        hoSoList: [
          Mau09HoSo(
            maLk: 'LK998877',
            rows: [
              Mau09Row(
                stt: 1,
                hoTen: 'NGUYỄN VĂN A',
                maTheBhyt: 'DN4010123456789',
                ngayVao: '202608010800',
                ngayRa: '202608051600',
                maLk: 'LK998877',
                maBn: 'BN001',
                ngayYl: '202608020900',
                truongTtGoc: 'SO_LUONG',
                giaTriGoc: '1',
                lyDoTuChoi: '',
                soTuChoi: 0,
                truongTtDc: 'SO_LUONG',
                giaTriDc: '2',
                lyDoDc: 'Bổ sung theo hồ sơ bệnh án',
              ),
            ],
          ),
        ],
      );

      final unsignedXml = xmlGenerator.generateXmlString(doc);
      final certData = signer.generateTestMedicalCertificate(
        hospitalName: 'BỆNH VIỆN ĐA KHOA HÀ NỘI',
        cskcbCode: '01001',
      );

      // Sign XML
      final signedXml = signer.signXmlDocument(
        xmlContent: unsignedXml,
        privateKey: certData.privateKey,
        certificate: certData.certificate,
      );

      expect(signedXml, contains('<CHUKYSO>'));
      expect(signedXml, contains('<Signature xmlns="http://www.w3.org/2000/09/xmldsig#">'));
      expect(signedXml, contains('<SignedInfo'));
      expect(signedXml, contains('<SignatureValue>'));
      expect(signedXml, contains('<DigestValue>'));
      expect(signedXml, contains('<X509Certificate>'));

      // Verify Signature
      final verification = signer.verifySignature(xmlContent: signedXml);
      expect(verification.isSigned, isTrue);
      expect(verification.isValid, isTrue);
      expect(verification.signatureValue, isNotEmpty);
      expect(verification.digestValue, isNotEmpty);
      expect(verification.certificate?.displayName, contains('BỆNH VIỆN ĐA KHOA HÀ NỘI'));
    });

    test('Detects signature tampering when XML data is altered after signing', () {
      final doc = const Mau09Document(
        maCskcb: '01001',
        ngayLap: '202608281500',
        hoSoList: [
          Mau09HoSo(
            maLk: 'LK112233',
            rows: [
              Mau09Row(
                stt: 1,
                hoTen: 'TRẦN THỊ B',
                maTheBhyt: 'GD4010123456789',
                ngayVao: '202608010800',
                ngayRa: '202608051600',
                maLk: 'LK112233',
                maBn: 'BN002',
                ngayYl: '202608020900',
                truongTtGoc: 'DON_GIA',
                giaTriGoc: '50000',
                lyDoTuChoi: '',
                soTuChoi: 0,
                truongTtDc: 'DON_GIA',
                giaTriDc: '60000',
                lyDoDc: 'Điều chỉnh đơn giá đúng thầu',
              ),
            ],
          ),
        ],
      );

      final unsignedXml = xmlGenerator.generateXmlString(doc);
      final certData = signer.generateTestMedicalCertificate();

      final signedXml = signer.signXmlDocument(
        xmlContent: unsignedXml,
        privateKey: certData.privateKey,
        certificate: certData.certificate,
      );

      // Tamper with signed XML (change value 60000 -> 999999)
      final tamperedXml = signedXml.replaceAll('60000', '999999');

      final verification = signer.verifySignature(xmlContent: tamperedXml);
      expect(verification.isSigned, isTrue);
      expect(verification.isValid, isFalse);
      expect(verification.validationMessage, contains('KHÔNG hợp lệ'));
    });
  });
}
