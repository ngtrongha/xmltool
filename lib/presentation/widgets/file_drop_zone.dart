import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:xmltool/config/theme/app_colors.dart';
import 'package:xmltool/domain/entities/validation_result.dart';
import 'package:xmltool/domain/entities/xml_envelope.dart';

/// Reusable drop / selection card for XML files.
class FileDropZone extends StatelessWidget {
  final String title;
  final String subtitle;
  final XmlEnvelope? envelope;
  final ValidationResult? validation;
  final ValueChanged<File> onFileSelected;
  final Color accentColor;

  const FileDropZone({
    super.key,
    required this.title,
    required this.subtitle,
    this.envelope,
    this.validation,
    required this.onFileSelected,
    this.accentColor = AppColors.primary,
  });

  Future<void> _pickFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xml'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      onFileSelected(file);
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasFile = envelope != null;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: hasFile ? accentColor : theme.colorScheme.outline.withValues(alpha: 0.3),
          width: hasFile ? 1.5 : 1.0,
        ),
      ),
      child: InkWell(
        onTap: () => _pickFile(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      hasFile ? Icons.check_circle_outline : Icons.file_upload_outlined,
                      color: accentColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _pickFile(context),
                    icon: const Icon(Icons.folder_open, size: 18),
                    label: Text(hasFile ? 'Đổi tệp' : 'Chọn tệp'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              if (hasFile) ...[
                const Divider(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            envelope!.filePath?.split(Platform.pathSeparator).last ?? 'Tệp XML',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Kích thước: ${_formatBytes(envelope!.fileSizeBytes)} • '
                            'Mã CSKCB: ${envelope!.maCskcb} • '
                            'Số HS: ${envelope!.danhSachHoSo.length} • '
                            'Tổng bản ghi: ${envelope!.totalRecords}',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (validation != null && !validation!.isValid)
                      const Tooltip(
                        message: 'Có cảnh báo cấu trúc',
                        child: Icon(Icons.warning_amber_rounded, color: AppColors.warning),
                      )
                    else
                      const Tooltip(
                        message: 'Cấu trúc XML hợp lệ',
                        child: Icon(Icons.verified, color: AppColors.success),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
