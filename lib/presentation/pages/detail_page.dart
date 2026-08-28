import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:xmltool/config/theme/app_colors.dart';
import 'package:xmltool/domain/entities/record_change.dart';
import 'package:xmltool/domain/value_objects/change_type.dart';
import 'package:xmltool/presentation/blocs/compare/compare_bloc.dart';
import 'package:xmltool/presentation/widgets/field_change_row.dart';
import 'package:xmltool/presentation/widgets/xml_type_badge.dart';

/// Screen 3: Detailed side-by-side record diff comparison.
class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<CompareBloc, CompareState>(
        builder: (context, state) {
          if (state.result == null) {
            return const Center(child: Text('Chưa có dữ liệu đối soát'));
          }

          final result = state.result!;
          var filteredList = <RecordChange>[];

          if (state.selectedXmlType != null) {
            filteredList = result.getChanges(state.selectedXmlType!);
          } else {
            filteredList = result.allChanges;
          }

          if (state.selectedChangeType != null) {
            filteredList = filteredList
                .where((c) => c.changeType == state.selectedChangeType)
                .toList();
          }

          if (state.onlyMau09Eligible) {
            filteredList = filteredList.where((c) => c.hasAdjustableChanges).toList();
          }

          if (state.searchQuery.isNotEmpty) {
            final query = state.searchQuery.toLowerCase();
            filteredList = filteredList.where((c) {
              final keyMatches = c.key.value.toLowerCase().contains(query);
              final fieldMatches = c.fieldChanges.any((fc) =>
                  fc.field.toLowerCase().contains(query) ||
                  (fc.oldValue?.toLowerCase().contains(query) ?? false) ||
                  (fc.newValue?.toLowerCase().contains(query) ?? false));
              return keyMatches || fieldMatches;
            }).toList();
          }

          return Column(
            children: [
              // Filter Toolbar Card
              Card(
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      // XML Type Selector row
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ChoiceChip(
                              label: const Text('Tất cả XML'),
                              selected: state.selectedXmlType == null,
                              onSelected: (_) {
                                context.read<CompareBloc>().add(
                                      CompareFilterChanged(selectedXmlType: null),
                                    );
                              },
                            ),
                            const SizedBox(width: 8),
                            for (final type in result.changesByXmlType.keys) ...[
                              ChoiceChip(
                                label: Text(type.code),
                                selected: state.selectedXmlType == type,
                                onSelected: (sel) {
                                  context.read<CompareBloc>().add(
                                        CompareFilterChanged(
                                          selectedXmlType: sel ? type : null,
                                        ),
                                      );
                                },
                              ),
                              const SizedBox(width: 8),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Change Type & Search row
                      Row(
                        children: [
                          // Change type filter
                          Wrap(
                            spacing: 8,
                            children: [
                              FilterChip(
                                label: const Text('Đã sửa'),
                                selected: state.selectedChangeType == ChangeType.changed,
                                onSelected: (sel) {
                                  context.read<CompareBloc>().add(
                                        CompareFilterChanged(
                                          selectedChangeType: sel ? ChangeType.changed : null,
                                        ),
                                      );
                                },
                              ),
                              FilterChip(
                                label: const Text('Bổ sung'),
                                selected: state.selectedChangeType == ChangeType.added,
                                onSelected: (sel) {
                                  context.read<CompareBloc>().add(
                                        CompareFilterChanged(
                                          selectedChangeType: sel ? ChangeType.added : null,
                                        ),
                                      );
                                },
                              ),
                              FilterChip(
                                label: const Text('Bị xóa'),
                                selected: state.selectedChangeType == ChangeType.removed,
                                onSelected: (sel) {
                                  context.read<CompareBloc>().add(
                                        CompareFilterChanged(
                                          selectedChangeType: sel ? ChangeType.removed : null,
                                        ),
                                      );
                                },
                              ),
                              FilterChip(
                                label: const Text('Chỉ Mẫu 09'),
                                avatar: const Icon(Icons.star, size: 16, color: Colors.amber),
                                selected: state.onlyMau09Eligible,
                                onSelected: (sel) {
                                  context.read<CompareBloc>().add(
                                        CompareFilterChanged(onlyMau09Eligible: sel),
                                      );
                                },
                              ),
                            ],
                          ),
                          const Spacer(),

                          // Search TypeAhead
                          SizedBox(
                            width: 260,
                            height: 38,
                            child: TypeAheadField<String>(
                              controller: _searchController,
                              builder: (context, controller, focusNode) {
                                return TextField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  decoration: InputDecoration(
                                    hintText: 'Tìm KEY / Tên trường...',
                                    prefixIcon: const Icon(Icons.search, size: 18),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                    suffixIcon: controller.text.isNotEmpty
                                        ? IconButton(
                                            icon: const Icon(Icons.clear, size: 16),
                                            onPressed: () {
                                              controller.clear();
                                              context.read<CompareBloc>().add(
                                                    const CompareFilterChanged(searchQuery: ''),
                                                  );
                                            },
                                          )
                                        : null,
                                  ),
                                  onChanged: (val) {
                                    context.read<CompareBloc>().add(
                                          CompareFilterChanged(searchQuery: val),
                                        );
                                  },
                                );
                              },
                              suggestionsCallback: (pattern) {
                                if (pattern.isEmpty) return [];
                                final matches = <String>{};
                                for (final c in result.allChanges) {
                                  if (c.key.value.toLowerCase().contains(pattern.toLowerCase())) {
                                    matches.add(c.key.value);
                                  }
                                  for (final fc in c.fieldChanges) {
                                    if (fc.field.toLowerCase().contains(pattern.toLowerCase())) {
                                      matches.add(fc.field);
                                    }
                                  }
                                }
                                return matches.take(5).toList();
                              },
                              itemBuilder: (context, suggestion) {
                                return ListTile(
                                  dense: true,
                                  title: Text(suggestion),
                                );
                              },
                              onSelected: (suggestion) {
                                _searchController.text = suggestion;
                                context.read<CompareBloc>().add(
                                      CompareFilterChanged(searchQuery: suggestion),
                                    );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Total count tag
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  children: [
                    Text(
                      'Hiển thị ${filteredList.length} / ${result.totalRecords} bản ghi',
                      style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              // Record Changes List
              Expanded(
                child: filteredList.isEmpty
                    ? const Center(child: Text('Không tìm thấy bản ghi nào khớp bộ lọc'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final recordChange = filteredList[index];
                          return _buildRecordCard(context, recordChange);
                        },
                      ),
              ),
            ],
          );
        },
      );
  }

  Widget _buildRecordCard(BuildContext context, RecordChange record) {
    final theme = Theme.of(context);
    final isUnchanged = record.changeType == ChangeType.unchanged;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isUnchanged
              ? Colors.grey.shade300
              : record.hasAdjustableChanges
                  ? AppColors.primary.withValues(alpha: 0.5)
                  : Colors.amber.shade300,
        ),
      ),
      child: ExpansionTile(
        initiallyExpanded: !isUnchanged,
        leading: XmlTypeBadge(xmlType: record.xmlType),
        title: Row(
          children: [
            Text(
              'KEY: ${record.key.value}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(width: 12),
            _buildChangeBadge(record.changeType),
          ],
        ),
        subtitle: Text(
          isUnchanged
              ? 'Bản ghi nguyên vẹn, không có thay đổi'
              : 'Có ${record.fieldChanges.length} trường thay đổi'
                  '${record.hasAdjustableChanges ? ' • Có trường Mẫu 09' : ''}',
          style: TextStyle(
            fontSize: 12,
            color: isUnchanged ? Colors.grey : theme.colorScheme.onSurfaceVariant,
          ),
        ),
        children: [
          if (record.fieldChanges.isNotEmpty) ...[
            for (final fc in record.fieldChanges)
              FieldChangeRow(change: fc),
          ] else if (record.changeType == ChangeType.added) ...[
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Bản ghi mới xuất hiện trong tệp XML Mới (chưa có trong XML Cũ). '
                'Dữ liệu: ${record.newRecord?.fields}',
                style: const TextStyle(color: Colors.blue),
              ),
            ),
          ] else if (record.changeType == ChangeType.removed) ...[
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Bản ghi đã bị xóa trong tệp XML Mới (có trong XML Cũ). '
                'Dữ liệu cũ: ${record.oldRecord?.fields}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChangeBadge(ChangeType type) {
    Color color;
    switch (type) {
      case ChangeType.unchanged:
        color = AppColors.success;
        break;
      case ChangeType.changed:
        color = AppColors.warning;
        break;
      case ChangeType.added:
        color = Colors.blue.shade700;
        break;
      case ChangeType.removed:
        color = Colors.red.shade700;
        break;
      case ChangeType.ambiguous:
        color = Colors.purple;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        type.label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
