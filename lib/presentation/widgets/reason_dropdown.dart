import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:xmltool/domain/value_objects/adjustment_reason.dart';

/// Dropdown selector for choosing standard Mẫu 09 adjustment reason.
class ReasonDropdown extends StatelessWidget {
  final String? initialReason;
  final ValueChanged<String> onReasonChanged;

  const ReasonDropdown({
    super.key,
    this.initialReason,
    required this.onReasonChanged,
  });

  @override
  Widget build(BuildContext context) {
    final reasons = AdjustmentReason.defaults.map((r) => r.description).toList();

    return CustomDropdown<String>.search(
      hintText: 'Chọn lý do điều chỉnh...',
      items: reasons,
      initialItem: initialReason ?? reasons.first,
      onChanged: (value) {
        if (value != null) {
          onReasonChanged(value);
        }
      },
      decoration: CustomDropdownDecoration(
        closedFillColor: Theme.of(context).colorScheme.surface,
        expandedFillColor: Theme.of(context).colorScheme.surface,
        closedBorder: Border.all(color: Colors.grey.shade300),
        expandedBorder: Border.all(color: Theme.of(context).colorScheme.primary),
        closedBorderRadius: BorderRadius.circular(8),
        expandedBorderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
