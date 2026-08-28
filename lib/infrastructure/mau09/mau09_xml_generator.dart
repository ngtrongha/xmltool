import 'package:xml/xml.dart';
import 'package:xmltool/domain/entities/mau09_document.dart';
import 'package:xmltool/domain/entities/mau09_row.dart';

/// Generates valid, well-formed Mẫu 09/BH XML documents according to Thông tư 12/2026/TT-BTC.
class Mau09XmlGenerator {
  /// Converts a [Mau09Document] into a formatted XML string.
  String generateXmlString(Mau09Document document) {
    final doc = generateXmlDocument(document);
    return doc.toXmlString(pretty: true, indent: '  ');
  }

  /// Converts a [Mau09Document] into an [XmlDocument].
  XmlDocument generateXmlDocument(Mau09Document document) {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="utf-8"');

    builder.element('GIAMDINHHS', nest: () {
      builder.attribute('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
      builder.attribute('xmlns:xsd', 'http://www.w3.org/2001/XMLSchema');

      // 1. THONGTINDONVI
      builder.element('THONGTINDONVI', nest: () {
        builder.element('MACSKCB', nest: document.maCskcb);
        if (document.maTinh != null && document.maTinh!.isNotEmpty) {
          builder.element('MATINH', nest: document.maTinh!);
        }
        if (document.tenTinh != null && document.tenTinh!.isNotEmpty) {
          builder.element('TENTINH', nest: document.tenTinh!);
        }
      });

      // 2. THONGTINHOSO
      builder.element('THONGTINHOSO', nest: () {
        builder.element('NGAYLAP', nest: document.ngayLap);
        builder.element('LOAIHOSO', nest: 'MAU_09');
        builder.element('SOLUONGHOSO', nest: '${document.hoSoList.length}');

        builder.element('DANHSACHHOSO', nest: () {
          for (final hoSo in document.hoSoList) {
            builder.element('HOSO', nest: () {
              for (final row in hoSo.rows) {
                _buildMau09Element(builder, row);
              }
            });
          }
        });
      });

      // 3. CHUKYSO
      final sig = document.chuKySo;
      if (sig != null && sig.trim().startsWith('<')) {
        builder.element('CHUKYSO', nest: () {
          builder.xml(sig);
        });
      } else {
        builder.element('CHUKYSO', nest: sig ?? '');
      }
    });

    return builder.buildDocument();
  }

  void _buildMau09Element(XmlBuilder builder, Mau09Row row) {
    builder.element('MAU_09', nest: () {
      builder.element('STT', nest: '${row.stt}');
      builder.element('HO_TEN', nest: row.hoTen);
      builder.element('MA_THE_BHYT', nest: row.maTheBhyt);
      builder.element('NGAY_VAO', nest: row.ngayVao);
      builder.element('NGAY_RA', nest: row.ngayRa);
      builder.element('MA_LK', nest: row.maLk);
      builder.element('MA_BN', nest: row.maBn);

      if (row.maTheRef != null && row.maTheRef!.isNotEmpty) {
        builder.element('MA_THE_REF', nest: row.maTheRef!);
      }
      if (row.ngayVaoRef != null && row.ngayVaoRef!.isNotEmpty) {
        builder.element('NGAY_VAO_REF', nest: row.ngayVaoRef!);
      }
      if (row.ngayRaRef != null && row.ngayRaRef!.isNotEmpty) {
        builder.element('NGAY_RA_REF', nest: row.ngayRaRef!);
      }

      builder.element('NGAY_YL', nest: row.ngayYl);
      builder.element('TRUONG_TT_GOC', nest: row.truongTtGoc);
      builder.element('GIATRI_GOC', nest: row.giaTriGoc);
      builder.element('LY_DO_TU_CHOI', nest: row.lyDoTuChoi);
      builder.element('SO_TU_CHOI', nest: '${row.soTuChoi}');
      builder.element('TRUONG_TT_DC', nest: row.truongTtDc);
      builder.element('GIATRI_DC', nest: row.giaTriDc);
      builder.element('LY_DO_DC', nest: row.lyDoDc);

      if (row.ghiChu.isNotEmpty) {
        builder.element('GHI_CHU', nest: row.ghiChu);
      }
    });
  }
}
