import 'package:flutter/material.dart';
import 'package:trina_grid/trina_grid.dart';
import 'package:xmltool/config/standards/xml_definitions.dart';
import 'package:xmltool/config/theme/app_colors.dart';
import 'package:xmltool/domain/entities/compare_result.dart';
import 'package:xmltool/domain/value_objects/change_type.dart';

/// Overview XML table breakdown using trina_grid.
class OverviewBreakdownTrinaGrid extends StatelessWidget {
  final CompareResult result;
  final void Function(XmlType xmlType)? onXmlTypeSelected;

  const OverviewBreakdownTrinaGrid({
    super.key,
    required this.result,
    this.onXmlTypeSelected,
  });

  Color _getBadgeColor(XmlType type) {
    switch (type) {
      case XmlType.xml1:
        return AppColors.xml1Badge;
      case XmlType.xml2:
        return AppColors.xml2Badge;
      case XmlType.xml3:
        return AppColors.xml3Badge;
      case XmlType.xml4:
        return AppColors.xml4Badge;
      case XmlType.xml5:
        return AppColors.xml5Badge;
      case XmlType.xml7:
        return AppColors.xml7Badge;
      case XmlType.xml8:
        return AppColors.xml8Badge;
      default:
        return Colors.blueGrey;
    }
  }

  List<TrinaColumn> _buildColumns(bool isDark) {
    return [
      TrinaColumn(
        title: 'Loại XML',
        field: 'xmlType',
        type: TrinaColumnType.text(),
        width: 110,
        enableEditingMode: false,
        frozen: TrinaColumnFrozen.start,
        renderer: (ctx) {
          final type = ctx.cell.value as XmlType;
          final color = _getBadgeColor(type);
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: isDark ? 0.2 : 0.12),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: color),
              ),
              child: Text(
                type.code,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          );
        },
      ),
      TrinaColumn(
        title: 'Tên Bảng Dữ Liệu Nghiệp Vụ',
        field: 'title',
        type: TrinaColumnType.text(),
        width: 220,
        enableEditingMode: false,
      ),
      TrinaColumn(
        title: 'Tổng Bản Ghi',
        field: 'total',
        type: TrinaColumnType.number(),
        width: 130,
        enableEditingMode: false,
      ),
      TrinaColumn(
        title: 'Không Đổi',
        field: 'unchanged',
        type: TrinaColumnType.number(),
        width: 120,
        enableEditingMode: false,
        renderer: (ctx) {
          final count = ctx.cell.value as int;
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '$count',
              style: TextStyle(
                color: isDark ? const Color(0xFF86EFAC) : const Color(0xFF16A34A),
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ),
      TrinaColumn(
        title: 'Số Bản Ghi Sửa',
        field: 'changed',
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
                fontWeight: count > 0 ? FontWeight.bold : FontWeight.normal,
                color: count > 0 ? (isDark ? Colors.amber.shade300 : Colors.amber.shade900) : null,
              ),
            ),
          );
        },
      ),
      TrinaColumn(
        title: 'Khoản Mục Mẫu 09',
        field: 'mau09Count',
        type: TrinaColumnType.number(),
        width: 150,
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
                  fontWeight: count > 0 ? FontWeight.bold : FontWeight.normal,
                  color: count > 0 ? AppColors.primary : null,
                ),
              ),
            ),
          );
        },
      ),
      TrinaColumn(
        title: 'Trạng Thái',
        field: 'status',
        type: TrinaColumnType.text(),
        width: 150,
        enableEditingMode: false,
        renderer: (ctx) {
          final isModified = ctx.cell.value as bool;
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isModified
                    ? (isDark ? const Color(0xFF451A1A) : const Color(0xFFFEE2E2))
                    : (isDark ? const Color(0xFF143823) : const Color(0xFFDCFCE7)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                isModified ? 'Có điều chỉnh' : 'Khớp hoàn toàn',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isModified
                      ? (isDark ? const Color(0xFFFCA5A5) : const Color(0xFFDC2626))
                      : (isDark ? const Color(0xFF86EFAC) : const Color(0xFF16A34A)),
                ),
              ),
            ),
          );
        },
      ),
    ];
  }

  List<TrinaRow> _buildRows() {
    return XmlType.values.map((type) {
      final changes = result.getChanges(type);
      final total = changes.length;
      final unchanged = changes.where((c) => c.changeType == ChangeType.unchanged).length;
      final changed = changes.where((c) => c.changeType == ChangeType.changed).length;
      var mau09Count = 0;
      for (final c in changes) {
        mau09Count += c.fieldChanges.where((fc) => fc.isAdjustable || fc.isConditional).length;
      }
      final isModified = changed > 0 || mau09Count > 0;

      return TrinaRow(
        cells: {
          'xmlType': TrinaCell(value: type),
          'title': TrinaCell(value: type.title),
          'total': TrinaCell(value: total),
          'unchanged': TrinaCell(value: unchanged),
          'changed': TrinaCell(value: changed),
          'mau09Count': TrinaCell(value: mau09Count),
          'status': TrinaCell(value: isModified),
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
          event.stateManager.setShowColumnFilter(false);
        },
        configuration: config,
      ),
    );
  }
}
