import 'package:flutter/material.dart';
import 'package:xmltool/config/standards/mau09_mappings.dart';
import 'package:xmltool/config/theme/app_colors.dart';
import 'package:xmltool/domain/entities/field_change.dart';

/// Renders a single field difference in side-by-side pill view.
class FieldChangeRow extends StatelessWidget {
  final FieldChange change;

  const FieldChangeRow({
    super.key,
    required this.change,
  });

  Widget _buildEligibilityBadge(ChangeEligibility eligibility) {
    Color color;
    String label;
    IconData icon;

    switch (eligibility) {
      case ChangeEligibility.adjustable:
        color = AppColors.success;
        label = 'Mẫu 09 (Hợp lệ)';
        icon = Icons.check_circle_outline;
        break;
      case ChangeEligibility.conditional:
        color = AppColors.warning;
        label = 'Có điều kiện';
        icon = Icons.info_outline;
        break;
      case ChangeEligibility.notAdjustable:
        color = AppColors.error;
        label = 'Khóa (Không sửa)';
        icon = Icons.lock_outline;
        break;
      case ChangeEligibility.nonFinancial:
        color = Colors.grey.shade600;
        label = 'Phi tài chính';
        icon = Icons.visibility_outlined;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    final oldBg = isDark ? AppColors.diffOldBackgroundDark : AppColors.diffOldBackground;
    final oldText = isDark ? AppColors.diffOldTextDark : AppColors.diffOldText;
    final oldBorder = isDark ? Colors.red.shade900 : Colors.red.shade200;

    final newBg = isDark ? AppColors.diffNewBackgroundDark : AppColors.diffNewBackground;
    final newText = isDark ? AppColors.diffNewTextDark : AppColors.diffNewText;
    final newBorder = isDark ? Colors.green.shade900 : Colors.green.shade200;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.dividerColor.withValues(alpha: 0.5)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Field Name
          SizedBox(
            width: 170,
            child: Text(
              change.field,
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Old Value
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: oldBg,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: oldBorder),
              ),
              child: Text(
                change.oldValue?.isEmpty ?? true ? '(Trống)' : change.oldValue!,
                style: TextStyle(
                  color: oldText,
                  fontSize: 13,
                  fontFamily: 'monospace',
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(width: 8),

          const Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.grey),
          const SizedBox(width: 8),

          // New Value
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: newBg,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: newBorder),
              ),
              child: Text(
                change.newValue?.isEmpty ?? true ? '(Trống)' : change.newValue!,
                style: TextStyle(
                  color: newText,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  fontFamily: 'monospace',
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Mẫu 09 Eligibility Badge
          _buildEligibilityBadge(change.eligibility),
        ],
      ),
    );
  }
}
