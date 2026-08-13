import 'dart:async';

import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:flutter/material.dart' show WidgetsFlutterBinding, runApp;
import 'package:life_insurance/app/app.dart'
    show AppInjection, MyApp, FirebaseInjection;
import 'package:life_insurance/core/core.dart'
    show MalwareService, ForegroundJobsService, ReminderNotiService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // DI only — must finish before runApp.
  await AppInjection.initDependencies();

  // Firebase / GMS can hang forever on Huawei & devices without Play Services.
  // Never block the first frame on them (prototype + field devices).
  unawaited(
    FirebaseInjection.initFirebaseServices()
        .timeout(const Duration(seconds: 8))
        .catchError((Object e, StackTrace st) {
          debugPrint('Firebase init skipped/timeout: $e');
        }),
  );

  if (!kDebugMode) {
    unawaited(
      MalwareService.initializeSecurity().catchError((Object e) {
        debugPrint('MalwareService init skipped: $e');
      }),
    );
  }

  try {
    await ReminderNotiService.init().timeout(const Duration(seconds: 3));
  } catch (e) {
    debugPrint('ReminderNotiService init skipped: $e');
  }

  try {
    ForegroundJobsService.initTask();
  } catch (e) {
    debugPrint('ForegroundJobsService init skipped: $e');
  }

  runApp(const MyApp());
}
