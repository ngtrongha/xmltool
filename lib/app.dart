import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xmltool/config/theme/app_theme.dart';
import 'package:xmltool/core/di/injection.dart';
import 'package:xmltool/presentation/blocs/audit/audit_bloc.dart';
import 'package:xmltool/presentation/blocs/compare/compare_bloc.dart';
import 'package:xmltool/presentation/blocs/import/import_bloc.dart';
import 'package:xmltool/presentation/blocs/mau09/mau09_bloc.dart';
import 'package:xmltool/presentation/router.dart';

/// Root application widget supporting dynamic Light & Dark themes.
class BHYTApp extends StatelessWidget {
  const BHYTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ImportBloc>(create: (_) => getIt<ImportBloc>()),
        BlocProvider<CompareBloc>(create: (_) => getIt<CompareBloc>()),
        BlocProvider<Mau09Bloc>(create: (_) => getIt<Mau09Bloc>()),
        BlocProvider<AuditBloc>(create: (_) => getIt<AuditBloc>()),
      ],
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: AppTheme.themeModeNotifier,
        builder: (context, themeMode, _) {
          return MaterialApp.router(
            title: 'BHYT XML Adjustment Tool',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
