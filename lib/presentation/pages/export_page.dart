import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xmltool/config/theme/app_colors.dart';
import 'package:xmltool/presentation/blocs/compare/compare_bloc.dart';
import 'package:xmltool/presentation/blocs/mau09/mau09_bloc.dart';
import 'package:xmltool/presentation/widgets/digital_signature_dialog.dart';
import 'package:xmltool/presentation/widgets/mau09_trina_grid.dart';
import 'package:xmltool/presentation/widgets/reason_dropdown.dart';

/// Screen 4: Preview Mẫu 09/BH, Digital Signing, Validate and Export.
class ExportPage extends StatelessWidget {
  const ExportPage({super.key});

  Future<void> _exportXml(BuildContext context) async {
    try {
      final selectedPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Chọn nơi lưu tệp XML Mẫu 09',
        fileName: 'MAU_09_${DateTime.now().millisecondsSinceEpoch}.xml',
        type: FileType.custom,
        allowedExtensions: ['xml'],
      );

      if (selectedPath != null && context.mounted) {
        context.read<Mau09Bloc>().add(Mau09ExportXmlRequested(selectedPath));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi chọn thư mục xuất XML: $e')),
        );
      }
    }
  }

  Future<void> _exportExcel(BuildContext context) async {
    final compareState = context.read<CompareBloc>().state;
    if (compareState.result == null) return;

    try {
      final selectedPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Chọn nơi lưu báo cáo Excel Mẫu 09',
        fileName: 'BaoCao_Mau09_${DateTime.now().millisecondsSinceEpoch}.xlsx',
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (selectedPath != null && context.mounted) {
        context.read<Mau09Bloc>().add(Mau09ExportExcelRequested(
              compareResult: compareState.result!,
              targetPath: selectedPath,
            ));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi chọn thư mục xuất Excel: $e')),
        );
      }
    }
  }

  void _openDigitalSignatureDialog(BuildContext context, String cskcbCode) {
    showDialog(
      context: context,
      builder: (ctx) => DigitalSignatureDialog(cskcbCode: cskcbCode),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocConsumer<Mau09Bloc, Mau09State>(
      listener: (context, state) {
        if (state.status == Mau09Status.exportSuccess && state.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message!),
              backgroundColor: AppColors.success,
            ),
          );
        } else if (state.status == Mau09Status.signed && state.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message!),
              backgroundColor: AppColors.primary,
            ),
          );
        } else if (state.status == Mau09Status.failure && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.status == Mau09Status.loading || state.status == Mau09Status.signing) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(state.status == Mau09Status.signing ? 'Đang thực hiện ký số điện tử XMLDSig...' : 'Đang xử lý dữ liệu Mẫu 09...'),
              ],
            ),
          );
        }

        if (state.document == null) {
          return const Center(child: Text('Chưa có dữ liệu Mẫu 09'));
        }

        final doc = state.document!;
        final validation = state.validationResult;
        final sig = state.signatureInfo;

        return Column(
          children: [
            // Header Summary Card
            Card(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 6),
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

            // Digital Signature Status Card
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      sig.isSigned ? Icons.verified_user_rounded : Icons.gpp_maybe_outlined,
                      size: 20,
                      color: sig.isSigned ? const Color(0xFF10B981) : Colors.amber.shade700,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        sig.isSigned
                            ? 'ĐÃ KÝ SỐ: ${sig.certificate?.displayName ?? 'Chứng thư số X.509'} • Chuẩn XMLDSig RSA-SHA256 (${sig.certificate?.caProvider ?? 'VNPT-CA'})'
                            : 'Trạng thái chữ ký số: Chưa ký số (Tùy chọn ký số điện tử chuẩn BHXH trước khi xuất file)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: sig.isSigned ? (isDark ? const Color(0xFF34D399) : const Color(0xFF047857)) : Colors.grey.shade700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (sig.isSigned) ...[
                      TextButton.icon(
                        onPressed: () {
                          context.read<Mau09Bloc>().add(const Mau09SignatureCleared());
                        },
                        icon: const Icon(Icons.clear, size: 16, color: Colors.grey),
                        label: const Text('Hủy ký', style: TextStyle(color: Colors.grey, fontSize: 12)),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

            // Export & Sign Action Bar
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
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () => _openDigitalSignatureDialog(context, doc.maCskcb),
                    icon: const Icon(Icons.drive_file_rename_outline_rounded, size: 18),
                    label: Text(
                      sig.isSigned ? 'Ký Lại Chữ Ký Số' : 'Ký Số Điện Tử (BHXH)',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F766E),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                    ),
                  ),
                  const SizedBox(width: 12),
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
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
