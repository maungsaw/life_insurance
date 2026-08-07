class ReminderEntity {
  final String id;
  final String title;
  final DateTime dateTime;
  bool isCompleted;

  ReminderEntity({
    required this.id,
    required this.title,
    required this.dateTime,
    this.isCompleted = false,
  });
}
