import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart' show WidgetsFlutterBinding, runApp;
import 'package:life_insurance/app/app.dart'
    show AppInjection, MyApp, FirebaseInjection;
import 'package:life_insurance/core/core.dart'
    show MalwareService, ForegroundScheculerService, ReminderNotiService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    if (!kDebugMode) MalwareService.initializeSecurity(),
    FirebaseInjection.initFirebaseServices(),
    AppInjection.initDependencies(),
  ]);
  ReminderNotiService.init();
  ForegroundScheculerService.initTask();

  runApp(const MyApp());
}
