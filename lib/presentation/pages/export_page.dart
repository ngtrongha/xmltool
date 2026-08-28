import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xmltool/config/theme/app_colors.dart';
import 'package:xmltool/presentation/blocs/compare/compare_bloc.dart';
import 'package:xmltool/presentation/blocs/mau09/mau09_bloc.dart';
import 'package:xmltool/presentation/blocs/mau09/mau09_event.dart';
import 'package:xmltool/presentation/widgets/bhyt_app_bar.dart';
import 'package:xmltool/presentation/widgets/mau09_trina_grid.dart';
import 'package:xmltool/presentation/widgets/reason_dropdown.dart';

/// Screen 4: Preview Mẫu 09/BH, Validate and Export.
class ExportPage extends StatelessWidget {
  const ExportPage({super.key});

  Future<void> _exportXml(BuildContext context) async {
    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Lưu tệp XML Mẫu 09/BH',
      fileName: 'MAU_09_DIEU_CHINH_${DateTime.now().millisecondsSinceEpoch}.xml',
      type: FileType.custom,
      allowedExtensions: ['xml'],
    );

    if (path != null && context.mounted) {
      context.read<Mau09Bloc>().add(Mau09ExportXmlRequested(path));
    }
  }

  Future<void> _exportExcel(BuildContext context) async {
    final compareState = context.read<CompareBloc>().state;
    if (compareState.result == null) return;

    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Lưu báo cáo đối soát Excel',
      fileName: 'BAO_CAO_DOI_SOAT_${DateTime.now().millisecondsSinceEpoch}.xlsx',
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (path != null && context.mounted) {
      context.read<Mau09Bloc>().add(Mau09ExportExcelRequested(
            compareResult: compareState.result!,
            targetPath: path,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const BHYTAppBar(
        title: 'Xem Trước & Xuất Mẫu 09/BH',
      ),
      body: BlocConsumer<Mau09Bloc, Mau09State>(
        listener: (context, state) {
          if (state.status == Mau09Status.exportSuccess && state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message!),
                backgroundColor: AppColors.success,
              ),
            );
          }
          if (state.status == Mau09Status.failure && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == Mau09Status.loading) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Đang tạo cấu trúc Mẫu 09/BH theo TT 12/2026...'),
                ],
              ),
            );
          }

          if (state.document == null) {
            return const Center(child: Text('Chưa có dữ liệu Mẫu 09'));
          }

          final doc = state.document!;
          final validation = state.validationResult;

          return Column(
            children: [
              // Header Summary Card
              Card(
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.assignment, color: AppColors.primary, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bảng Kê Chi Tiết Điều Chỉnh Mẫu 09/BH (TT 12/2026/TT-BTC)',
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'CSKCB: ${doc.maCskcb} • Ngày lập: ${doc.ngayLap} • '
                              'Số đợt KCB: ${doc.totalClaims} • Tổng số dòng điều chỉnh: ${doc.totalRows}',
                              style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      if (validation != null) ...[
                        if (validation.isValid)
                          const Chip(
                            avatar: Icon(Icons.check_circle, color: AppColors.success, size: 16),
                            label: Text('Hợp lệ (3 cấp độ)', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
                          )
                        else
                          Chip(
                            avatar: const Icon(Icons.error, color: AppColors.error, size: 16),
                            label: Text('${validation.errors.length} lỗi', style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ],
                  ),
                ),
              ),

              // Bulk Reason Toolbar
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_fix_high, size: 20, color: AppColors.primary),
                      const SizedBox(width: 10),
                      const Text(
                        'Áp dụng lý do hàng loạt:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: ReasonDropdown(
                          onReasonChanged: (reason) {
                            context.read<Mau09Bloc>().add(Mau09BulkReasonUpdated(reason));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Preview DataGrid with trina_grid
              Expanded(
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: doc.allRows.isEmpty
                      ? const Center(child: Text('Không có khoản mục nào cần điều chỉnh qua Mẫu 09.'))
                      : Mau09TrinaGrid(
                          rows: doc.allRows,
                          onReasonChanged: (stt, newReason) {
                            context.read<Mau09Bloc>().add(
                                  Mau09RowReasonUpdated(
                                    stt: stt,
                                    newReason: newReason,
                                  ),
                                );
                          },
                        ),
                ),
              ),

              // Export Action Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => _exportExcel(context),
                      icon: const Icon(Icons.table_view_outlined, color: Colors.green),
                      label: const Text('Xuất Báo Cáo Excel'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: doc.allRows.isEmpty ? null : () => _exportXml(context),
                      icon: const Icon(Icons.download, size: 20),
                      label: const Text(
                        'Xuất File XML Mẫu 09/BH',
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
              ),
            ],
          );
        },
      ),
    );
  }
}
