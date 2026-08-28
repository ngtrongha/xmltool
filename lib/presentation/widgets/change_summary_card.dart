import 'package:flutter/material.dart';
import 'package:xmltool/config/theme/app_colors.dart';

/// Stat item box displayed in dashboard.
class StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const StatItem({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Change summary dashboard displaying key metrics.
class ChangeSummaryCard extends StatelessWidget {
  final int totalRecords;
  final int unchangedCount;
  final int changedCount;
  final int addedCount;
  final int removedCount;
  final int mau09Count;

  const ChangeSummaryCard({
    super.key,
    required this.totalRecords,
    required this.unchangedCount,
    required this.changedCount,
    required this.addedCount,
    required this.removedCount,
    required this.mau09Count,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                StatItem(
                  label: 'Tổng bản ghi',
                  value: '$totalRecords',
                  icon: Icons.inventory_2_outlined,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),
                StatItem(
                  label: 'Không thay đổi',
                  value: '$unchangedCount',
                  icon: Icons.check_circle_outline,
                  color: AppColors.success,
                ),
                const SizedBox(width: 12),
                StatItem(
                  label: 'Có thay đổi',
                  value: '$changedCount',
                  icon: Icons.edit_note_outlined,
                  color: AppColors.warning,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                StatItem(
                  label: 'Bổ sung (Mới)',
                  value: '$addedCount',
                  icon: Icons.add_circle_outline,
                  color: Colors.blue.shade700,
                ),
                const SizedBox(width: 12),
                StatItem(
                  label: 'Bị xóa',
                  value: '$removedCount',
                  icon: Icons.remove_circle_outline,
                  color: Colors.red.shade700,
                ),
                const SizedBox(width: 12),
                StatItem(
                  label: 'Đủ chuẩn Mẫu 09',
                  value: '$mau09Count',
                  icon: Icons.assignment_turned_in_outlined,
                  color: Colors.teal.shade800,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
