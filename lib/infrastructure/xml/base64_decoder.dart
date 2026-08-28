import 'dart:convert';

/// Helper to detect and decode Base64 encoded XML files.
class XmlBase64Helper {
  static final RegExp _base64Pattern = RegExp(r'^[A-Za-z0-9+/=\r\n]+$');

  /// Detects whether string appears to be a Base64 encoded string
  static bool isBase64(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return false;
    // Plain XML starts with '<'
    if (trimmed.startsWith('<')) return false;

    // Check basic character set and length
    if (trimmed.length % 4 != 0 && !trimmed.contains('\n')) return false;
    return _base64Pattern.hasMatch(trimmed);
  }

  /// Attempts to decode Base64 UTF-8 string; returns original if decoding fails.
  static String decodeIfNeeded(String input) {
    final trimmed = input.trim();
    if (!isBase64(trimmed)) return input;

    try {
      final sanitized = trimmed.replaceAll(RegExp(r'\s+'), '');
      final bytes = base64.decode(sanitized);
      return utf8.decode(bytes);
    } catch (_) {
      return input;
    }
  }
}
