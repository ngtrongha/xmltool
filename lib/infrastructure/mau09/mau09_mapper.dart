import 'package:xmltool/config/standards/mau09_mappings.dart';
import 'package:xmltool/domain/entities/compare_result.dart';
import 'package:xmltool/domain/entities/field_change.dart';
import 'package:xmltool/domain/entities/mau09_document.dart';
import 'package:xmltool/domain/entities/mau09_row.dart';
import 'package:xmltool/domain/entities/record_change.dart';
import 'package:xmltool/domain/entities/xml1_record.dart';
import 'package:xmltool/domain/entities/xml_envelope.dart';
import 'package:xmltool/domain/value_objects/change_type.dart';

/// Maps comparison results and field differences into Mẫu 09/BH adjustment documents.
/// Follows Phụ lục I, Thông tư 12/2026/TT-BTC (Per-field adjustment structure).
class Mau09Mapper {
  /// Transforms a CompareResult into a compliant Mau09Document.
  Mau09Document mapToMau09Document({
    required CompareResult compareResult,
    required XmlEnvelope newEnvelope,
    XmlEnvelope? oldEnvelope,
    String defaultReason = 'Điều chỉnh số lượng/đơn giá thuốc đúng theo hồ sơ bệnh án và hóa đơn thầu',
  }) {
    final hoSoList = <Mau09HoSo>[];

    // Group changes by MA_LK
    final changesByMaLk = <String, List<RecordChange>>{};
    for (final change in compareResult.allChanges) {
      final maLk = change.maLk;
      if (maLk.isNotEmpty) {
        changesByMaLk.putIfAbsent(maLk, () => []).add(change);
      }
    }

    var globalStt = 1;

    for (final hs in newEnvelope.danhSachHoSo) {
      final maLk = hs.maLk;
      final xml1 = hs.xml1Record;
      final changes = changesByMaLk[maLk] ?? [];

      final rowsForHoSo = <Mau09Row>[];

      for (final recordChange in changes) {
        if (recordChange.changeType == ChangeType.changed) {
          // Process field-level changes
          for (final fc in recordChange.fieldChanges) {
            if (fc.eligibility == ChangeEligibility.adjustable ||
                fc.eligibility == ChangeEligibility.conditional) {
              final row = _createRowFromFieldChange(
                stt: globalStt++,
                xml1: xml1,
                maLk: maLk,
                recordChange: recordChange,
                fieldChange: fc,
                defaultReason: defaultReason,
              );
              rowsForHoSo.add(row);
            }
          }
        } else if (recordChange.changeType == ChangeType.added) {
          // Added record (e.g. supplemental cost)
          final row = _createRowForAddedRecord(
            stt: globalStt++,
            xml1: xml1,
            maLk: maLk,
            recordChange: recordChange,
            defaultReason: defaultReason,
          );
          rowsForHoSo.add(row);
        } else if (recordChange.changeType == ChangeType.removed) {
          // Removed record (e.g. revoked cost)
          final row = _createRowForRemovedRecord(
            stt: globalStt++,
            xml1: xml1,
            maLk: maLk,
            recordChange: recordChange,
            defaultReason: defaultReason,
          );
          rowsForHoSo.add(row);
        }
      }

      if (rowsForHoSo.isNotEmpty) {
        hoSoList.add(Mau09HoSo(
          maLk: maLk,
          rows: rowsForHoSo,
        ));
      }
    }

    final dateNow = DateTime.now();
    final ngayLap = '${dateNow.year}${dateNow.month.toString().padLeft(2, '0')}${dateNow.day.toString().padLeft(2, '0')}';

    return Mau09Document(
      maCskcb: newEnvelope.maCskcb,
      ngayLap: ngayLap,
      hoSoList: hoSoList,
    );
  }

  Mau09Row _createRowFromFieldChange({
    required int stt,
    required Xml1Record? xml1,
    required String maLk,
    required RecordChange recordChange,
    required FieldChange fieldChange,
    required String defaultReason,
  }) {
    final ngayYl = recordChange.newRecord?['NGAY_YL'] ??
        recordChange.oldRecord?['NGAY_YL'] ??
        xml1?.ngayVao ??
        '';

    return Mau09Row(
      stt: stt,
      hoTen: xml1?.hoTen ?? '',
      maTheBhyt: xml1?.maTheBhyt ?? '',
      ngayVao: xml1?.ngayVao ?? '',
      ngayRa: xml1?.ngayRa ?? '',
      maLk: maLk,
      maBn: xml1?.maBn ?? maLk,
      maTheRef: xml1?.maTheBhyt,
      ngayVaoRef: xml1?.ngayVao,
      ngayRaRef: xml1?.ngayRa,
      ngayYl: ngayYl,
      truongTtGoc: fieldChange.field,
      giaTriGoc: fieldChange.oldValue ?? '',
      lyDoTuChoi: '',
      soTuChoi: 0.0,
      truongTtDc: fieldChange.field,
      giaTriDc: fieldChange.newValue ?? '',
      lyDoDc: defaultReason,
      ghiChu: 'Bảng: ${fieldChange.xmlType.code}, Khóa: ${fieldChange.key.value}',
    );
  }

  Mau09Row _createRowForAddedRecord({
    required int stt,
    required Xml1Record? xml1,
    required String maLk,
    required RecordChange recordChange,
    required String defaultReason,
  }) {
    final rec = recordChange.newRecord!;
    final itemCode = rec['MA_THUOC'] ?? rec['MA_DICH_VU'] ?? rec['MA_VAT_TU'] ?? '';
    final itemName = rec['TEN_THUOC'] ?? rec['TEN_DICH_VU'] ?? rec['TEN_VAT_TU'] ?? '';
    final amount = double.tryParse(rec.getValue('T_BHTT').replaceAll(',', '.')) ?? 0.0;

    return Mau09Row(
      stt: stt,
      hoTen: xml1?.hoTen ?? '',
      maTheBhyt: xml1?.maTheBhyt ?? '',
      ngayVao: xml1?.ngayVao ?? '',
      ngayRa: xml1?.ngayRa ?? '',
      maLk: maLk,
      maBn: xml1?.maBn ?? maLk,
      ngayYl: rec['NGAY_YL'] ?? xml1?.ngayVao ?? '',
      truongTtGoc: 'MA_DICH_VU_THUOC',
      giaTriGoc: '',
      lyDoTuChoi: '',
      soTuChoi: 0.0,
      truongTtDc: 'MA_DICH_VU_THUOC',
      giaTriDc: itemCode,
      lyDoDc: 'Bổ sung chi phí bỏ sót: $itemName',
      ghiChu: 'Bổ sung bản ghi ${recordChange.xmlType.code} - Số tiền BHYT: $amount',
    );
  }

  Mau09Row _createRowForRemovedRecord({
    required int stt,
    required Xml1Record? xml1,
    required String maLk,
    required RecordChange recordChange,
    required String defaultReason,
  }) {
    final rec = recordChange.oldRecord!;
    final itemCode = rec['MA_THUOC'] ?? rec['MA_DICH_VU'] ?? rec['MA_VAT_TU'] ?? '';
    final itemName = rec['TEN_THUOC'] ?? rec['TEN_DICH_VU'] ?? rec['TEN_VAT_TU'] ?? '';
    final amount = double.tryParse(rec.getValue('T_BHTT').replaceAll(',', '.')) ?? 0.0;

    return Mau09Row(
      stt: stt,
      hoTen: xml1?.hoTen ?? '',
      maTheBhyt: xml1?.maTheBhyt ?? '',
      ngayVao: xml1?.ngayVao ?? '',
      ngayRa: xml1?.ngayRa ?? '',
      maLk: maLk,
      maBn: xml1?.maBn ?? maLk,
      ngayYl: rec['NGAY_YL'] ?? xml1?.ngayVao ?? '',
      truongTtGoc: 'MA_DICH_VU_THUOC',
      giaTriGoc: itemCode,
      lyDoTuChoi: '',
      soTuChoi: amount,
      truongTtDc: 'MA_DICH_VU_THUOC',
      giaTriDc: '',
      lyDoDc: 'Thu hồi khoản mục: $itemName',
      ghiChu: 'Thu hồi bản ghi ${recordChange.xmlType.code} - Giảm BHYT: $amount',
    );
  }
}
