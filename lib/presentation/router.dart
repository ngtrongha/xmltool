import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:xmltool/core/logging/app_talker.dart';
import 'package:xmltool/presentation/pages/audit_log_page.dart';
import 'package:xmltool/presentation/pages/detail_page.dart';
import 'package:xmltool/presentation/pages/export_page.dart';
import 'package:xmltool/presentation/pages/import_page.dart';
import 'package:xmltool/presentation/pages/overview_page.dart';
import 'package:xmltool/presentation/pages/settings_page.dart';
import 'package:xmltool/presentation/widgets/main_shell.dart';

/// Application router configuration using GoRouter with ShellRoute and Talker observer.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  observers: [TalkerRouteObserver(appTalker)],
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShell(
        state: state,
        child: child,
      ),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const ImportPage(),
        ),
        GoRoute(
          path: '/overview',
          builder: (context, state) => const OverviewPage(),
        ),
        GoRoute(
          path: '/detail',
          builder: (context, state) => const DetailPage(),
        ),
        GoRoute(
          path: '/export',
          builder: (context, state) => const ExportPage(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: '/audit',
          builder: (context, state) => const AuditLogPage(),
        ),
      ],
    ),
  ],
);
