import 'dart:io';
import 'package:excel/excel.dart';
import 'package:xmltool/domain/entities/compare_result.dart';
import 'package:xmltool/domain/entities/mau09_document.dart';
import 'package:xmltool/domain/value_objects/change_type.dart';

/// Generates detailed Excel reconciliation and audit workbooks.
class Mau09ExcelGenerator {
  /// Builds an Excel workbook and writes it to [targetPath].
  Future<File> generateExcelReport({
    required CompareResult compareResult,
    Mau09Document? mau09Document,
    required String targetPath,
  }) async {
    final excel = Excel.createExcel();

    // Remove default sheet
    final defaultSheet = excel.getDefaultSheet();

    // 1. Sheet: "Tổng quan đối soát"
    final overviewSheet = excel['Tổng quan đối soát'];
    _populateOverviewSheet(overviewSheet, compareResult, mau09Document);

    // 2. Sheet: "Bảng kê Mẫu 09"
    if (mau09Document != null && mau09Document.allRows.isNotEmpty) {
      final mau09Sheet = excel['Bảng kê Mẫu 09'];
      _populateMau09Sheet(mau09Sheet, mau09Document);
    }

    // 3. Sheet: "Chi tiết toàn bộ khác biệt"
    final detailsSheet = excel['Chi tiết thay đổi'];
    _populateDetailsSheet(detailsSheet, compareResult);

    if (defaultSheet != null && defaultSheet != 'Tổng quan đối soát') {
      excel.delete(defaultSheet);
    }

    final file = File(targetPath);
    await file.parent.create(recursive: true);
    final fileBytes = excel.save();
    if (fileBytes != null) {
      await file.writeAsBytes(fileBytes);
    }

    return file;
  }

  void _populateOverviewSheet(
    Sheet sheet,
    CompareResult result,
    Mau09Document? doc,
  ) {
    sheet.appendRow([
      TextCellValue('BÁO CÁO TỔNG HỢP ĐỐI SOÁT DỮ LIỆU KCB BHYT'),
    ]);
    sheet.appendRow([
      TextCellValue('Thời điểm đối soát:'),
      TextCellValue(result.comparedAt.toIso8601String()),
    ]);
    sheet.appendRow([
      TextCellValue('Tệp XML cũ:'),
      TextCellValue(result.oldFilePath),
    ]);
    sheet.appendRow([
      TextCellValue('Tệp XML mới:'),
      TextCellValue(result.newFilePath),
    ]);
    sheet.appendRow([TextCellValue('')]);

    sheet.appendRow([
      TextCellValue('Chỉ tiêu'),
      TextCellValue('Số lượng'),
    ]);
    sheet.appendRow([
      TextCellValue('Tổng số bản ghi đối soát'),
      TextCellValue('${result.totalRecords}'),
    ]);
    sheet.appendRow([
      TextCellValue('Bản ghi không thay đổi'),
      TextCellValue('${result.unchangedCount}'),
    ]);
    sheet.appendRow([
      TextCellValue('Bản ghi có thay đổi'),
      TextCellValue('${result.changedCount}'),
    ]);
    sheet.appendRow([
      TextCellValue('Bản ghi mới bổ sung (ADDED)'),
      TextCellValue('${result.addedCount}'),
    ]);
    sheet.appendRow([
      TextCellValue('Bản ghi bị xóa (REMOVED)'),
      TextCellValue('${result.removedCount}'),
    ]);
    sheet.appendRow([
      TextCellValue('Số trường đủ điều kiện Mẫu 09/BH'),
      TextCellValue('${doc?.totalRows ?? result.mau09EligibleCount}'),
    ]);
  }

  void _populateMau09Sheet(Sheet sheet, Mau09Document doc) {
    sheet.appendRow([
      TextCellValue('STT'),
      TextCellValue('Họ và tên'),
      TextCellValue('Mã thẻ BHYT'),
      TextCellValue('Ngày vào'),
      TextCellValue('Ngày ra'),
      TextCellValue('Mã liên kết'),
      TextCellValue('Mã bệnh nhân'),
      TextCellValue('Ngày y lệnh'),
      TextCellValue('Trường TT gốc'),
      TextCellValue('Giá trị gốc'),
      TextCellValue('Trường TT điều chỉnh'),
      TextCellValue('Giá trị điều chỉnh'),
      TextCellValue('Lý do điều chỉnh'),
      TextCellValue('Ghi chú'),
    ]);

    for (final row in doc.allRows) {
      sheet.appendRow([
        TextCellValue('${row.stt}'),
        TextCellValue(row.hoTen),
        TextCellValue(row.maTheBhyt),
        TextCellValue(row.ngayVao),
        TextCellValue(row.ngayRa),
        TextCellValue(row.maLk),
        TextCellValue(row.maBn),
        TextCellValue(row.ngayYl),
        TextCellValue(row.truongTtGoc),
        TextCellValue(row.giaTriGoc),
        TextCellValue(row.truongTtDc),
        TextCellValue(row.giaTriDc),
        TextCellValue(row.lyDoDc),
        TextCellValue(row.ghiChu),
      ]);
    }
  }

  void _populateDetailsSheet(Sheet sheet, CompareResult result) {
    sheet.appendRow([
      TextCellValue('Loại XML'),
      TextCellValue('Khóa bản ghi (KEY)'),
      TextCellValue('Trạng thái bản ghi'),
      TextCellValue('Tên trường thay đổi'),
      TextCellValue('Giá trị cũ'),
      TextCellValue('Giá trị mới'),
      TextCellValue('Phân loại Mẫu 09'),
    ]);

    for (final change in result.allChanges) {
      if (change.changeType == ChangeType.unchanged) continue;

      if (change.changeType == ChangeType.changed) {
        for (final fc in change.fieldChanges) {
          sheet.appendRow([
            TextCellValue(fc.xmlType.code),
            TextCellValue(fc.key.value),
            TextCellValue(change.changeType.label),
            TextCellValue(fc.field),
            TextCellValue(fc.oldValue ?? ''),
            TextCellValue(fc.newValue ?? ''),
            TextCellValue(fc.eligibility.name),
          ]);
        }
      } else {
        sheet.appendRow([
          TextCellValue(change.xmlType.code),
          TextCellValue(change.key.value),
          TextCellValue(change.changeType.label),
          TextCellValue('(Toàn bộ bản ghi)'),
          TextCellValue(change.oldRecord != null ? 'Có dữ liệu' : ''),
          TextCellValue(change.newRecord != null ? 'Có dữ liệu' : ''),
          TextCellValue(change.changeType.name),
        ]);
      }
    }
  }
}
