import 'dart:isolate';
import 'package:flutter/rendering.dart' show debugPrint;
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:life_insurance/app/di/app_injection.dart' show AppInjection;
import 'package:life_insurance/core/core.dart' show LocalCacheService;

// This function runs in a separate Isolate
@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(ForegroundTaskHandler());
}

@pragma('vm:entry-point')
class ForegroundTaskHandler extends TaskHandler {
  // Flag to prevent overlapping sync operations
  bool _isSyncing = false;
  final cacheService = AppInjection.sl<LocalCacheService>();
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter taskStarter) async {
    debugPrint("Service started.");
  }

  @override
  void onRepeatEvent(DateTime timestamp) async {
    if (_isSyncing) return;

    String? enabled = await cacheService.read('sync_enabled');

    if (enabled != 'true') return;

    await performApiSync();
  }

  Future<void> performApiSync() async {
    _isSyncing = true;
    try {
      debugPrint('Executing API Sync...');

      // Example: Using registered sync service
      // final syncService = getIt<SyncRepository>();
      // await syncService.syncData();

      await cacheService.write(key: 'sync_enabled', value: 'false');
      debugPrint('Sync completed successfully.');
    } catch (e) {
      debugPrint('Sync Error: $e');
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    await runSyncAndStop();
  }

  Future<void> runSyncAndStop() async {
    await performApiSync();
    debugPrint("Sync complete, stopping foreground service.");
    await FlutterForegroundTask.stopService();
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    debugPrint("Service destroyed.");
    _isSyncing = false;
  }
}
