import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:xmltool/config/theme/app_colors.dart';
import 'package:xmltool/config/theme/app_theme.dart';
import 'package:xmltool/core/logging/app_talker.dart';

/// Standardized enterprise medical Top Bar across all screens.
class BHYTAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? extraActions;

  const BHYTAppBar({
    super.key,
    required this.title,
    this.extraActions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: isDark ? 0.25 : 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.healing_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        ...?extraActions,

        // Dark / Light Mode Toggle Button
        IconButton(
          icon: Icon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            color: isDark ? Colors.amber : const Color(0xFF475569),
          ),
          tooltip: isDark ? 'Chuyển sang Giao diện Sáng' : 'Chuyển sang Giao diện Tối',
          onPressed: () => AppTheme.toggleTheme(),
        ),

        // Audit Log History Button
        IconButton(
          icon: const Icon(Icons.history_edu_outlined),
          tooltip: 'Lịch sử đối soát & Kiểm toán',
          onPressed: () => context.push('/audit'),
        ),

        // Talker Diagnostics Monitor Button
        IconButton(
          icon: const Icon(Icons.monitor_heart_outlined, color: Colors.teal),
          tooltip: 'Mở Talker Monitor',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TalkerScreen(talker: appTalker),
              ),
            );
          },
        ),

        // Settings Button
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          tooltip: 'Cài đặt chuẩn quy định',
          onPressed: () => context.push('/settings'),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
