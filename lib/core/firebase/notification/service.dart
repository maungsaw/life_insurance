import 'dart:io' show Platform;
import 'package:firebase_messaging/firebase_messaging.dart'
    show RemoteMessage, FirebaseMessaging, NotificationSettings;
import 'package:flutter/rendering.dart' show debugPrint;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    show
        FlutterLocalNotificationsPlugin,
        AndroidNotificationChannel,
        InitializationSettings,
        NotificationResponse,
        AndroidFlutterLocalNotificationsPlugin,
        NotificationDetails,
        Importance,
        AndroidInitializationSettings,
        DarwinInitializationSettings,
        Priority,
        AndroidNotificationDetails,
        DarwinNotificationDetails,
        AndroidScheduleMode,
        DateTimeComponents;
import 'package:life_insurance/core/firebase/remote_wipe/remote_wipe.dart'
    show VerifyWideDataResponse;
import 'package:timezone/timezone.dart' as tz;
import 'notification.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('--- BACKGROUND MESSAGE RECEIVED ---');
  debugPrint('Payload Data: ${message.data}');
  if (message.data['action'] != null) {
    await NotificationActions.checkWipePermission(
      message.data['action'],
      VerifyWideDataResponse.fromJson(message.data),
    );
  }
}

enum RepeatType { none, daily, weekly }

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  // Changed to late to prevent [core/no-app] error
  late FirebaseMessaging _fcm;
  late FlutterLocalNotificationsPlugin _local;

  late NotificationNavigationCallback _onNavigate;
  late PermissionCallback _onPermissionResult;
  late BackgroundMsgCallback _backgroundMsgCallback;

  Future<void> initialize({
    required FirebaseOptions options,
    required NotificationNavigationCallback onNavigate,
    required PermissionCallback onPermissionResult,
    required BackgroundMsgCallback backgroundMsgCallback,
  }) async {
    // 1. Initialize Firebase FIRST before accessing any Firebase instances
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: options);
    } else {
      Firebase.app();
    }

    // 2. Now it is safe to assign the instances
    _fcm = FirebaseMessaging.instance;
    _local = FlutterLocalNotificationsPlugin();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    _onNavigate = onNavigate;
    _onPermissionResult = onPermissionResult;
    _backgroundMsgCallback = backgroundMsgCallback;

    // 4. Request Firebase Permissions
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    _onPermissionResult(settings.authorizationStatus);

    // 5. Set foreground presentation options
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 6. Setup Android Notification Channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    // 7. Initialize Local Notifications
    const InitializationSettings initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    // FIX: Removed 'settings:' label as it is a positional argument
    await _local.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _backgroundMsgCallback(
          RemoteMessage(
            data: {'screen': response.data},
            messageId: response.payload ?? '',
          ),
        );
        if (response.payload != null) {
          _onNavigate({'screen': response.payload});
        }
      },
    );

    if (Platform.isAndroid) {
      final androidPlugin = _local
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await androidPlugin?.createNotificationChannel(channel);

      /// await androidPlugin?.requestFullScreenIntentPermission();
    }

    // 8. Setup Listeners
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((msg) => _onNavigate(msg.data));

    // 9. Handle Terminated State Notification
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _onNavigate(initialMessage.data);
    }
  }

  void _onForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    _local.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'Main channel for app notifications',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: message.data['screen'] ?? '',
    );
    if (message.data['action'] != null) {
      await NotificationActions.checkWipePermission(
        message.data['action'],
        VerifyWideDataResponse.fromJson(message.data),
      );
    }
  }

  Future<void> subscribeTopic({required String topic}) async {
    try {
      await _fcm.subscribeToTopic(topic);
      debugPrint('Successfully subscribed to the $topic  topic!');
    } catch (e) {
      debugPrint('Failed to subscribe to topic: $e');
    }
  }

  Future<void> unsubscribeTopic({required String topic}) async {
    try {
      await _fcm.unsubscribeFromTopic(topic);
      debugPrint('Successfully unsubscribed from the $topic topic!');
    } catch (e) {
      debugPrint('Failed to unsubscribe from topic: $e');
    }
  }

  Future<void> addReminder({
    required String title,
    required String notes,
    required DateTime scheduledTime,
    required RepeatType repeat,
  }) async {
    final notificationId = DateTime.now().millisecondsSinceEpoch.remainder(
      100000,
    );

    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'reminder_channel',
        'Reminders',
        channelDescription: 'Main channel for scheduled app reminders',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    final tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

    if (repeat == RepeatType.none) {
      await _local.zonedSchedule(
        id: notificationId,
        title: title,
        body: notes,
        scheduledDate: tzScheduledTime,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } else {
      final matchComponents = repeat == RepeatType.daily
          ? DateTimeComponents.time
          : DateTimeComponents.dayOfWeekAndTime;

      await _local.zonedSchedule(
        id: notificationId,
        title: title,
        body: notes,
        scheduledDate: tzScheduledTime,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: matchComponents,
      );
    }
  }

  Future<void> removeReminder(int id) async {
    await _local.cancel(id: id);
  }

  /// Clear all reminders
  Future<void> clearAll() async {
    await _local.cancelAll();
  }

  Future<String?> getToken() => _fcm.getToken();
}
