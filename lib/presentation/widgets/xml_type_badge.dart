import 'package:flutter/material.dart';
import 'package:xmltool/config/standards/xml_definitions.dart';
import 'package:xmltool/config/theme/app_colors.dart';

/// Reusable colorful badge / chip displaying the XML type.
class XmlTypeBadge extends StatelessWidget {
  final XmlType xmlType;
  final bool isSelected;
  final VoidCallback? onTap;

  const XmlTypeBadge({
    super.key,
    required this.xmlType,
    this.isSelected = false,
    this.onTap,
  });

  Color _getBadgeColor(XmlType type) {
    switch (type) {
      case XmlType.xml1:
        return AppColors.xml1Badge;
      case XmlType.xml2:
        return AppColors.xml2Badge;
      case XmlType.xml3:
        return AppColors.xml3Badge;
      case XmlType.xml4:
        return AppColors.xml4Badge;
      case XmlType.xml5:
        return AppColors.xml5Badge;
      case XmlType.xml7:
        return AppColors.xml7Badge;
      case XmlType.xml8:
        return AppColors.xml8Badge;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getBadgeColor(xmlType);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: color,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Text(
          xmlType.code,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
