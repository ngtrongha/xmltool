import 'package:talker_flutter/talker_flutter.dart';

/// Global Talker instance for logging, debugging and diagnostics.
final Talker appTalker = TalkerFlutter.init(
  settings: TalkerSettings(
    maxHistoryItems: 1000,
    useConsoleLogs: true,
  ),
);
