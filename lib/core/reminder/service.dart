import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    show
        FlutterLocalNotificationsPlugin,
        AndroidInitializationSettings,
        DarwinInitializationSettings,
        InitializationSettings,
        AndroidNotificationDetails,
        NotificationDetails,
        Importance,
        Priority,
        DarwinNotificationDetails,
        AndroidScheduleMode;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ReminderNotiService {
  static final ReminderNotiService _instance = ReminderNotiService._internal();
  factory ReminderNotiService() => _instance;
  ReminderNotiService._internal();

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Yangon'));

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(settings: initSettings);
  }

  // Schedule notification for a custom future DateTime
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'reminder_channel',
          'Reminders',
          channelDescription: 'Scheduled local reminder alerts',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // Cancel notification if reminder is deleted
  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id: id);
  }
}
