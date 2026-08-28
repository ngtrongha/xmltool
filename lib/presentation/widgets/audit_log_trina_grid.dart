import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trina_grid/trina_grid.dart';
import 'package:xmltool/config/theme/app_colors.dart';
import 'package:xmltool/domain/entities/audit_entry.dart';

/// Audit logs history table using trina_grid.
class AuditLogTrinaGrid extends StatelessWidget {
  final List<AuditEntry> entries;

  const AuditLogTrinaGrid({
    super.key,
    required this.entries,
  });

  List<TrinaColumn> _buildColumns(bool isDark) {
    return [
      TrinaColumn(
        title: 'Mã ID',
        field: 'id',
        type: TrinaColumnType.text(),
        width: 100,
        frozen: TrinaColumnFrozen.start,
        enableEditingMode: false,
        renderer: (ctx) {
          final id = ctx.cell.value.toString();
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              id.length > 8 ? id.substring(0, 8) : id,
              style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
      TrinaColumn(
        title: 'Thời Gian Đối Soát',
        field: 'timestamp',
        type: TrinaColumnType.text(),
        width: 170,
        frozen: TrinaColumnFrozen.start,
        enableEditingMode: false,
      ),
      TrinaColumn(
        title: 'Chuẩn Quy Định',
        field: 'standardVersion',
        type: TrinaColumnType.text(),
        width: 140,
        enableEditingMode: false,
      ),
      TrinaColumn(
        title: 'Tệp XML Cũ (Gốc)',
        field: 'oldFileName',
        type: TrinaColumnType.text(),
        width: 220,
        enableEditingMode: false,
      ),
      TrinaColumn(
        title: 'Tệp XML Mới (Điều Chỉnh)',
        field: 'newFileName',
        type: TrinaColumnType.text(),
        width: 220,
        enableEditingMode: false,
      ),
      TrinaColumn(
        title: 'Số Hồ Sơ',
        field: 'totalClaims',
        type: TrinaColumnType.number(),
        width: 110,
        enableEditingMode: false,
      ),
      TrinaColumn(
        title: 'Số Trường Sửa',
        field: 'totalChanges',
        type: TrinaColumnType.number(),
        width: 130,
        enableEditingMode: false,
        renderer: (ctx) {
          final count = ctx.cell.value as int;
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '$count',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: count > 0 ? (isDark ? Colors.amber.shade300 : Colors.amber.shade900) : null,
              ),
            ),
          );
        },
      ),
      TrinaColumn(
        title: 'Bản Ghi Mẫu 09',
        field: 'totalMau09Rows',
        type: TrinaColumnType.number(),
        width: 140,
        enableEditingMode: false,
        renderer: (ctx) {
          final count = ctx.cell.value as int;
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: count > 0
                    ? (isDark ? const Color(0xFF134E4A) : const Color(0xFFCCFBF1))
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: count > 0 ? AppColors.primary : null,
                ),
              ),
            ),
          );
        },
      ),
      TrinaColumn(
        title: 'Mã Băm SHA-256 (Cũ)',
        field: 'oldFileHash',
        type: TrinaColumnType.text(),
        width: 200,
        enableEditingMode: false,
        renderer: (ctx) {
          final hash = ctx.cell.value.toString();
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              hash.length > 16 ? '${hash.substring(0, 16)}...' : hash,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          );
        },
      ),
    ];
  }

  List<TrinaRow> _buildRows() {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
    return entries.map((entry) {
      return TrinaRow(
        cells: {
          'id': TrinaCell(value: entry.id),
          'timestamp': TrinaCell(value: dateFormat.format(entry.timestamp)),
          'standardVersion': TrinaCell(value: entry.standardVersion),
          'oldFileName': TrinaCell(value: entry.oldFileName),
          'newFileName': TrinaCell(value: entry.newFileName),
          'totalClaims': TrinaCell(value: entry.totalClaims),
          'totalChanges': TrinaCell(value: entry.totalChanges),
          'totalMau09Rows': TrinaCell(value: entry.totalMau09Rows),
          'oldFileHash': TrinaCell(value: entry.oldFileHash),
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
          event.stateManager.setShowColumnFilter(true);
        },
        configuration: config,
      ),
    );
  }
}
