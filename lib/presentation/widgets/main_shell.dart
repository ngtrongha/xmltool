import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xmltool/config/theme/app_colors.dart';
import 'package:xmltool/presentation/blocs/import/import_bloc.dart';
import 'package:xmltool/presentation/widgets/desktop_sidebar.dart';

/// Desktop Master Shell Layout containing the fixed Left Sidebar and Top Header Bar.
class MainShell extends StatelessWidget {
  final Widget child;
  final GoRouterState state;

  const MainShell({
    super.key,
    required this.child,
    required this.state,
  });

  String _getPageTitle(String path) {
    switch (path) {
      case '/':
        return 'Nhập Tệp & Đối Soát XML';
      case '/overview':
        return 'Tổng Quan Kết Quả Đối Soát';
      case '/detail':
        return 'Chi Tiết So Sánh Từng Bản Ghi (Diff)';
      case '/export':
        return 'Xem Trước & Xuất Mẫu 09/BH';
      case '/audit':
        return 'Lịch Sử & Nhật Ký Kiểm Toán (Audit)';
      case '/settings':
        return 'Cài Đặt & Quy Định Chuẩn BHYT';
      default:
        return 'BHYT XML Tool';
    }
  }

  String _getPageSubtitle(String path) {
    switch (path) {
      case '/':
        return 'Chọn tệp XML KCB gốc và tệp điều chỉnh để bắt đầu phân tích';
      case '/overview':
        return 'Thống kê tổng hợp số lượng bản ghi và bảng dữ liệu phát sinh chênh lệch';
      case '/detail':
        return 'So sánh đối chiếu chi tiết giá trị cũ vs mới theo từng khóa liên kết (MA_LK)';
      case '/export':
        return 'Lọc danh mục điều chỉnh hợp lệ theo Thông tư 12/2026/TT-BTC và xuất file';
      case '/audit':
        return 'Lưu vết lịch sử các phiên đối soát cục bộ trong cơ sở dữ liệu SQLite';
      case '/settings':
        return 'Cấu hình phiên bản danh mục kỹ thuật và công cụ chẩn đoán hệ thống';
      default:
        return 'Quyết định 3176/QĐ-BYT • Quyết định 4750/QĐ-BYT • Thông tư 12/2026/TT-BTC';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentPath = state.uri.path;

    final headerBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Scaffold(
      body: Row(
        children: [
          // 1. Left Fixed Navigation Sidebar (250px)
          DesktopSidebar(currentRoute: currentPath),

          // 2. Right Workspace & Content Area
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Header Bar
                Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: headerBg,
                    border: Border(
                      bottom: BorderSide(color: borderColor, width: 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Breadcrumb & Page Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _getPageTitle(currentPath),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _getPageSubtitle(currentPath),
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // Active File Status Indicators
                      BlocBuilder<ImportBloc, ImportState>(
                        builder: (context, importState) {
                          final hasOld = importState.oldEnvelope != null;
                          final hasNew = importState.newEnvelope != null;

                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildFilePill(
                                label: 'XML CŨ',
                                isLoaded: hasOld,
                                name: importState.oldEnvelope?.maCskcb,
                                isDark: isDark,
                              ),
                              const SizedBox(width: 8),
                              _buildFilePill(
                                label: 'XML MỚI',
                                isLoaded: hasNew,
                                name: importState.newEnvelope?.maCskcb,
                                isDark: isDark,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Main Page Body
                Expanded(
                  child: child,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilePill({
    required String label,
    required bool isLoaded,
    required String? name,
    required bool isDark,
  }) {
    final activeColor = isLoaded ? AppColors.primary : Colors.grey;
    final bg = isLoaded
        ? (isDark ? const Color(0xFF134E4A) : const Color(0xFFCCFBF1))
        : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: activeColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isLoaded ? const Color(0xFF10B981) : Colors.grey.shade400,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$label: ${isLoaded ? (name ?? 'Đã nạp') : 'Chưa chọn'}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isLoaded
                  ? (isDark ? const Color(0xFF5EEAD4) : const Color(0xFF0F766E))
                  : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
