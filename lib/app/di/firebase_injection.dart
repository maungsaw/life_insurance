import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:life_insurance/core/core.dart'
    show FirebaseOptions, NotificationService, NotificationActions;

abstract class FirebaseInjection {
  static Future<void> initFirebaseServices() async {
    try {
      final options = FirebaseOptions(
        apiKey: "AIzaSyDqdwGdHUkghv8Iaydq0uG4IcGF0cYuWw",
        appId: "1:432071418438:android:588d784d19c971b92a204",
        messagingSenderId: "432071418438",
        projectId: "paypass-97314",
      );

      final instance = NotificationService.instance;

      await instance
          .initialize(
            options: options,
            onNavigate: NotificationActions.handleNotificationNavigation,
            onPermissionResult: (status) => debugPrint('Permission: $status'),
            backgroundMsgCallback: (data) async =>
                debugPrint('Background msg: ${data.messageId}'),
          )
          .timeout(const Duration(seconds: 6));

      try {
        final fcmToken = await instance
            .getToken()
            .timeout(const Duration(seconds: 4));
        if (fcmToken != null && fcmToken.isNotEmpty) {
          debugPrint('FCM Token: $fcmToken');
        } else {
          debugPrint('FCM Token empty — Pushy may be used for Chinese phones');
        }
      } catch (e) {
        debugPrint(
          'FCM token unavailable. Pushy will be used if available: $e',
        );
      }

      try {
        await instance
            .subscribeTopic(topic: 'maintainance')
            .timeout(const Duration(seconds: 3));
      } catch (e) {
        debugPrint('Topic subscribe skipped: $e');
      }
    } catch (e, stackTrace) {
      debugPrint('Firebase services init skipped: $e');
      debugPrint('$stackTrace');
    }
  }
}
