import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xmltool/config/theme/app_colors.dart';
import 'package:xmltool/presentation/blocs/audit/audit_bloc.dart';
import 'package:xmltool/presentation/blocs/audit/audit_event.dart';
import 'package:xmltool/presentation/widgets/audit_log_trina_grid.dart';
import 'package:xmltool/presentation/widgets/bhyt_app_bar.dart';

/// Screen for viewing persistent reconciliation history with trina_grid and Talker diagnostics.
class AuditLogPage extends StatefulWidget {
  const AuditLogPage({super.key});

  @override
  State<AuditLogPage> createState() => _AuditLogPageState();
}

class _AuditLogPageState extends State<AuditLogPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuditBloc>().add(const AuditLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHYTAppBar(
        title: 'Lịch Sử & Nhật Ký Kiểm Toán (Audit)',
        extraActions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: 'Xóa toàn bộ lịch sử',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Xác nhận xóa lịch sử'),
                  content: const Text('Bạn có chắc chắn muốn xóa toàn bộ lịch sử đối soát trong cơ sở dữ liệu SQLite không?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Hủy'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuditBloc>().add(const AuditClearRequested());
                        Navigator.of(ctx).pop();
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                      child: const Text('Xóa tất cả', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<AuditBloc, AuditState>(
        builder: (context, state) {
          if (state.status == AuditStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.entries.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history_toggle_off, size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  const Text(
                    'Chưa có phiên đối soát nào được ghi nhận.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: AuditLogTrinaGrid(entries: state.entries),
              ),
            ),
          );
        },
      ),
    );
  }
}
