import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:xmltool/app.dart';
import 'package:xmltool/core/di/injection.dart';
import 'package:xmltool/core/logging/app_talker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Dependency Injection
  await configureDependencies();

  // 2. Attach Talker Bloc Observer
  Bloc.observer = TalkerBlocObserver(
    talker: appTalker,
    settings: const TalkerBlocLoggerSettings(
      printEventFullData: false,
      printStateFullData: false,
    ),
  );

  appTalker.info('Starting BHYT XML Adjustment Tool...');

  // 3. Run Application
  runApp(const BHYTApp());
}
