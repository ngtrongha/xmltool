import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xmltool/config/theme/app_colors.dart';
import 'package:xmltool/presentation/blocs/compare/compare_bloc.dart';
import 'package:xmltool/presentation/blocs/import/import_bloc.dart';
import 'package:xmltool/presentation/blocs/mau09/mau09_bloc.dart';
import 'package:xmltool/presentation/widgets/change_summary_card.dart';
import 'package:xmltool/presentation/widgets/overview_breakdown_trina_grid.dart';

/// Screen 2: Overview Dashboard of reconciliation results with trina_grid.
class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<CompareBloc, CompareState>(
      builder: (BuildContext context, CompareState state) {
        if (state.status == CompareStatus.loading) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Đang đối soát và phân tích dữ liệu...'),
              ],
            ),
          );
        }

        if (state.status == CompareStatus.failure) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                const SizedBox(height: 16),
                Text(
                  state.errorMessage ?? 'Có lỗi xảy ra trong quá trình đối soát',
                  style: const TextStyle(color: AppColors.error),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go('/'),
                  child: const Text('Quay lại nhập tệp'),
                ),
              ],
            ),
          );
        }

        if (state.result == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.difference_outlined, size: 48, color: Colors.grey.shade400),
                const SizedBox(height: 12),
                const Text('Chưa có kết quả đối soát. Vui lòng nạp 2 tệp XML để bắt đầu.'),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => context.go('/'),
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Đến màn hình nhập tệp'),
                ),
              ],
            ),
          );
        }

        final result = state.result!;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 6 Metrics Cards
              ChangeSummaryCard(
                totalRecords: result.totalRecords,
                unchangedCount: result.unchangedCount,
                changedCount: result.changedCount,
                addedCount: result.addedCount,
                removedCount: result.removedCount,
                mau09Count: result.mau09EligibleCount,
              ),
              const SizedBox(height: 20),

              // Breakdown Section with trina_grid
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Chi Tiết Từng Bảng Dữ Liệu (XML1 — XML8)',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'DataGrid (trina_grid)',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 380,
                        child: OverviewBreakdownTrinaGrid(result: result),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Bottom Action Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => context.go('/detail'),
                    icon: const Icon(Icons.list_alt_rounded),
                    label: const Text('Xem Chi Tiết Từng Bản Ghi'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      final importState = context.read<ImportBloc>().state;
                      context.read<Mau09Bloc>().add(Mau09GenerateRequested(
                            compareResult: result,
                            newEnvelope: importState.newEnvelope!,
                            oldEnvelope: importState.oldEnvelope,
                          ));
                      context.go('/export');
                    },
                    icon: const Icon(Icons.assignment_turned_in, size: 20),
                    label: const Text(
                      'Sinh Dữ Liệu Mẫu 09/BH',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
