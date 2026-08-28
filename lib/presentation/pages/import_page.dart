import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xmltool/config/theme/app_colors.dart';
import 'package:xmltool/presentation/blocs/compare/compare_bloc.dart';
import 'package:xmltool/presentation/blocs/compare/compare_event.dart';
import 'package:xmltool/presentation/blocs/import/import_bloc.dart';
import 'package:xmltool/presentation/blocs/import/import_event.dart';
import 'package:xmltool/presentation/widgets/bhyt_app_bar.dart';
import 'package:xmltool/presentation/widgets/file_drop_zone.dart';

/// Screen 1: Import old and new XML files with Enterprise Medical UI.
class ImportPage extends StatelessWidget {
  const ImportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const BHYTAppBar(title: 'BHYT XML Adjustment Tool'),
      body: BlocConsumer<ImportBloc, ImportState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Banner
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF134E4A).withValues(alpha: 0.3) : const Color(0xFFCCFBF1).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.primary.withValues(alpha: isDark ? 0.4 : 0.25)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.compare_arrows_rounded, size: 36, color: AppColors.primary),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hệ Thống Đối Soát XML KCB BHYT & Sinh Mẫu 09/BH',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'So sánh tự động theo mã khóa KEY (MA_LK + STT / Thuốc / DVKT) • Chuẩn QĐ 3176 & TT 12/2026/TT-BTC',
                              style: TextStyle(
                                fontSize: 13,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // File Selectors
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: FileDropZone(
                        title: '1. Tệp XML CŨ (Gốc / Đã gửi cổng)',
                        subtitle: 'Dữ liệu trước điều chỉnh hoặc hồ sơ bị cảnh báo/từ chối',
                        envelope: state.oldEnvelope,
                        validation: state.oldValidation,
                        accentColor: isDark ? Colors.blueGrey.shade400 : Colors.blueGrey.shade700,
                        onFileSelected: (file) {
                          context.read<ImportBloc>().add(ImportOldXmlSelected(file));
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: FileDropZone(
                        title: '2. Tệp XML MỚI (Đã hiệu chỉnh)',
                        subtitle: 'Dữ liệu sau khi trích xuất hoặc sửa đổi tại HIS',
                        envelope: state.newEnvelope,
                        validation: state.newValidation,
                        accentColor: AppColors.primary,
                        onFileSelected: (file) {
                          context.read<ImportBloc>().add(ImportNewXmlSelected(file));
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 36),

                // Action Bar
                Center(
                  child: SizedBox(
                    width: 320,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: state.canCompare
                          ? () {
                              context.read<CompareBloc>().add(CompareStarted(
                                    oldEnvelope: state.oldEnvelope!,
                                    newEnvelope: state.newEnvelope!,
                                  ));
                              context.push('/overview');
                            }
                          : null,
                      icon: const Icon(Icons.play_arrow_rounded, size: 24),
                      label: const Text(
                        'BẮT ĐẦU ĐỐI SOÁT',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 0.5),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
