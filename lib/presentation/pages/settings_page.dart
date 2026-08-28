import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:xmltool/config/standards/standard_version.dart';
import 'package:xmltool/core/logging/app_talker.dart';

/// Screen 5: Settings & Standard Version Configuration.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  StandardVersion _selectedVersion = StandardVersion.defaultVersion;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Section: Standard Versions
        Text(
          'Phiên bản chuẩn dữ liệu đầu ra',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          child: RadioGroup<StandardVersion>(
            groupValue: _selectedVersion,
            onChanged: (val) {
              if (val != null) {
                setState(() => _selectedVersion = val);
              }
            },
            child: Column(
              children: [
                for (final version in StandardVersion.values)
                  RadioListTile<StandardVersion>(
                    value: version,
                    title: Text(
                      version.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      '${version.description} • Hiệu lực: ${version.effectiveDate}',
                      style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Section: Monitoring & Diagnostics
        Text(
          'Chẩn đoán & Nhật ký hệ thống',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.monitor_heart_outlined, color: Colors.teal),
            title: const Text('Mở màn hình Talker Monitor'),
            subtitle: const Text('Xem toàn bộ logs, bloc transitions và lỗi runtime'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TalkerScreen(talker: appTalker),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),

        // Section: About
        Text(
          'Thông tin phần mềm',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    'assets/images/app_logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.healing_rounded,
                      color: Colors.teal,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'BHYT XML Adjustment & Reconciliation Tool v1.0',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tuân thủ: Quyết định 3176/QĐ-BYT, Quyết định 4750/QĐ-BYT, Thông tư 12/2026/TT-BTC',
                        style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
