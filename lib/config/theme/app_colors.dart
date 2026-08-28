import 'package:flutter/material.dart';

/// Centralized Design System Colors for BHYT XML Adjustment Tool.
class AppColors {
  // Primary Palette (Medical Teal #0D9488)
  static const Color primary = Color(0xFF0D9488);
  static const Color primaryDark = Color(0xFF14B8A6);
  static const Color onPrimary = Colors.white;
  static const Color primaryContainer = Color(0xFFCCFBF1);
  static const Color primaryContainerDark = Color(0xFF134E4A);
  static const Color onPrimaryContainer = Color(0xFF115E59);
  static const Color onPrimaryContainerDark = Color(0xFF99F6E4);

  // Secondary Palette (Corporate Slate Blue)
  static const Color secondary = Color(0xFF0284C7);
  static const Color secondaryDark = Color(0xFF38BDF8);
  static const Color onSecondary = Colors.white;
  static const Color secondaryContainer = Color(0xFFE0F2FE);
  static const Color secondaryContainerDark = Color(0xFF0C4A6E);

  // Background & Surface
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardBorderLight = Color(0xFFE2E8F0);

  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color surfaceContainerDark = Color(0xFF334155);
  static const Color cardBorderDark = Color(0xFF334155);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color successDark = Color(0xFF34D399);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningDark = Color(0xFFFBBF24);
  static const Color error = Color(0xFFEF4444);
  static const Color errorDark = Color(0xFFF87171);
  static const Color info = Color(0xFF3B82F6);

  // XML Type Badge Colors (Vibrant Medical Categories)
  static const Color xml1Badge = Color(0xFF2563EB); // XML1: Tổng hợp (Blue)
  static const Color xml2Badge = Color(0xFF059669); // XML2: Thuốc (Emerald)
  static const Color xml3Badge = Color(0xFF7C3AED); // XML3: DVKT (Purple)
  static const Color xml4Badge = Color(0xFFD97706); // XML4: CLS (Amber)
  static const Color xml5Badge = Color(0xFF0891B2); // XML5: DBLS (Cyan)
  static const Color xml7Badge = Color(0xFF4F46E5); // XML7: Giấy ra viện (Indigo)
  static const Color xml8Badge = Color(0xFFDB2777); // XML8: Tóm tắt HSBA (Pink)

  // Diff Background Highlights
  static const Color diffOldBackground = Color(0xFFFEE2E2);
  static const Color diffOldBackgroundDark = Color(0xFF451A1A);
  static const Color diffOldText = Color(0xFFDC2626);
  static const Color diffOldTextDark = Color(0xFFFCA5A5);

  static const Color diffNewBackground = Color(0xFFDCFCE7);
  static const Color diffNewBackgroundDark = Color(0xFF143823);
  static const Color diffNewText = Color(0xFF16A34A);
  static const Color diffNewTextDark = Color(0xFF86EFAC);
}
