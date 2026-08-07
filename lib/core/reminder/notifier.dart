import 'package:flutter/foundation.dart';
import 'service.dart';
import 'entity.dart' show ReminderEntity;

class ReminderNotifier extends ChangeNotifier {
  final List<ReminderEntity> _reminders = [];

  List<ReminderEntity> get reminders => List.unmodifiable(_reminders);

  void addReminder(String title, DateTime dateTime) {
    final newReminder = ReminderEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      dateTime: dateTime,
    );

    _reminders.add(newReminder);
    notifyListeners();

    // Schedule the alert for the specific date & time selected
    ReminderNotiService.scheduleNotification(
      id: newReminder.id.hashCode,
      title: 'Reminder Alert',
      body: title,
      scheduledDate: dateTime,
    );
  }

  void toggleReminder(String id) {
    final index = _reminders.indexWhere((r) => r.id == id);
    if (index != -1) {
      _reminders[index].isCompleted = !_reminders[index].isCompleted;
      notifyListeners();
    }
  }

  void removeReminder(String id) {
    final index = _reminders.indexWhere((r) => r.id == id);
    if (index != -1) {
      final reminderId = _reminders[index].id.hashCode;
      ReminderNotiService.cancelNotification(reminderId);
      _reminders.removeAt(index);
      notifyListeners();
    }
  }
}
