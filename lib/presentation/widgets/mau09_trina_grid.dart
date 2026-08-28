import 'package:flutter/material.dart';
import 'package:trina_grid/trina_grid.dart';
import 'package:xmltool/config/theme/app_colors.dart';
import 'package:xmltool/domain/entities/mau09_row.dart';
import 'package:xmltool/presentation/widgets/reason_dropdown.dart';

/// Desktop-grade high-performance DataGrid for Mẫu 09 using trina_grid.
class Mau09TrinaGrid extends StatefulWidget {
  final List<Mau09Row> rows;
  final void Function(int stt, String newReason) onReasonChanged;

  const Mau09TrinaGrid({
    super.key,
    required this.rows,
    required this.onReasonChanged,
  });

  @override
  State<Mau09TrinaGrid> createState() => _Mau09TrinaGridState();
}

class _Mau09TrinaGridState extends State<Mau09TrinaGrid> {
  TrinaGridStateManager? _stateManager;

  List<TrinaColumn> _buildColumns(bool isDark) {
    return [
      TrinaColumn(
        title: 'STT',
        field: 'stt',
        type: TrinaColumnType.number(),
        width: 70,
        frozen: TrinaColumnFrozen.start,
        enableEditingMode: false,
      ),
      TrinaColumn(
        title: 'Họ và tên',
        field: 'hoTen',
        type: TrinaColumnType.text(),
        width: 160,
        frozen: TrinaColumnFrozen.start,
        enableEditingMode: false,
      ),
      TrinaColumn(
        title: 'Mã LK',
        field: 'maLk',
        type: TrinaColumnType.text(),
        width: 140,
        enableEditingMode: false,
      ),
      TrinaColumn(
        title: 'Mã thẻ BHYT',
        field: 'maTheBhyt',
        type: TrinaColumnType.text(),
        width: 160,
        enableEditingMode: false,
      ),
      TrinaColumn(
        title: 'Ngày y lệnh',
        field: 'ngayYl',
        type: TrinaColumnType.text(),
        width: 130,
        enableEditingMode: false,
      ),
      TrinaColumn(
        title: 'Trường gốc (N)',
        field: 'truongTtGoc',
        type: TrinaColumnType.text(),
        width: 160,
        enableEditingMode: false,
        renderer: (rendererContext) {
          final val = rendererContext.cell.value.toString();
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF451A1A) : const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                val,
                style: TextStyle(
                  color: isDark ? const Color(0xFFFCA5A5) : const Color(0xFFDC2626),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          );
        },
      ),
      TrinaColumn(
        title: 'Giá trị gốc (O)',
        field: 'giaTriGoc',
        type: TrinaColumnType.text(),
        width: 150,
        enableEditingMode: false,
      ),
      TrinaColumn(
        title: 'Trường ĐC (R)',
        field: 'truongTtDc',
        type: TrinaColumnType.text(),
        width: 160,
        enableEditingMode: false,
        renderer: (rendererContext) {
          final val = rendererContext.cell.value.toString();
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF143823) : const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                val,
                style: TextStyle(
                  color: isDark ? const Color(0xFF86EFAC) : const Color(0xFF16A34A),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          );
        },
      ),
      TrinaColumn(
        title: 'Giá trị ĐC (S)',
        field: 'giaTriDc',
        type: TrinaColumnType.text(),
        width: 150,
        enableEditingMode: false,
      ),
      TrinaColumn(
        title: 'Lý do điều chỉnh (T)',
        field: 'lyDoDc',
        type: TrinaColumnType.text(),
        width: 320,
        enableEditingMode: false,
        renderer: (rendererContext) {
          final stt = rendererContext.row.cells['stt']?.value as int? ?? 1;
          final currentReason = rendererContext.cell.value.toString();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: ReasonDropdown(
              initialReason: currentReason,
              onReasonChanged: (newReason) {
                rendererContext.stateManager.changeCellValue(
                  rendererContext.cell,
                  newReason,
                  force: true,
                );
                widget.onReasonChanged(stt, newReason);
              },
            ),
          );
        },
      ),
    ];
  }

  List<TrinaRow> _buildRows() {
    return widget.rows.map((row) {
      return TrinaRow(
        cells: {
          'stt': TrinaCell(value: row.stt),
          'hoTen': TrinaCell(value: row.hoTen),
          'maLk': TrinaCell(value: row.maLk),
          'maTheBhyt': TrinaCell(value: row.maTheBhyt),
          'ngayYl': TrinaCell(value: row.ngayYl),
          'truongTtGoc': TrinaCell(value: row.truongTtGoc),
          'giaTriGoc': TrinaCell(value: row.giaTriGoc),
          'truongTtDc': TrinaCell(value: row.truongTtDc),
          'giaTriDc': TrinaCell(value: row.giaTriDc),
          'lyDoDc': TrinaCell(value: row.lyDoDc),
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final columns = _buildColumns(isDark);
    final rows = _buildRows();

    final config = isDark
        ? TrinaGridConfiguration.dark(
            style: TrinaGridStyleConfig.dark(
              gridBackgroundColor: AppColors.surfaceDark,
              rowColor: AppColors.surfaceDark,
              gridBorderColor: AppColors.cardBorderDark,
              borderColor: AppColors.cardBorderDark,
              activatedBorderColor: AppColors.primaryDark,
              activatedColor: AppColors.primaryDark.withValues(alpha: 0.15),
              inactivatedBorderColor: AppColors.cardBorderDark,
            ),
          )
        : TrinaGridConfiguration(
            style: TrinaGridStyleConfig(
              gridBackgroundColor: AppColors.surfaceLight,
              rowColor: AppColors.surfaceLight,
              gridBorderColor: AppColors.cardBorderLight,
              borderColor: AppColors.cardBorderLight,
              activatedBorderColor: AppColors.primary,
              activatedColor: AppColors.primary.withValues(alpha: 0.1),
              inactivatedBorderColor: AppColors.cardBorderLight,
            ),
          );

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: TrinaGrid(
        columns: columns,
        rows: rows,
        onLoaded: (TrinaGridOnLoadedEvent event) {
          _stateManager = event.stateManager;
          _stateManager?.setShowColumnFilter(true);
        },
        configuration: config,
      ),
    );
  }
}
