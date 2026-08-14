import 'package:flutter/material.dart';

/// FR-07 task mock (docs/68). In-memory session — no API.

enum TaskStatus { pending, inProgress, completed }

enum TaskPriority { high, medium, low }

enum TaskType {
  meeting,
  call,
  leaveAppointment,
  servicing,
  eApp,
  other,
}

extension TaskStatusX on TaskStatus {
  String get label => switch (this) {
        TaskStatus.pending => 'Pending',
        TaskStatus.inProgress => 'In Progress',
        TaskStatus.completed => 'Completed',
      };
}

extension TaskPriorityX on TaskPriority {
  String get label => switch (this) {
        TaskPriority.high => 'High',
        TaskPriority.medium => 'Medium',
        TaskPriority.low => 'Low',
      };

  Color get color => switch (this) {
        TaskPriority.high => const Color(0xFFE11D48),
        TaskPriority.medium => const Color(0xFFF59E0B),
        TaskPriority.low => const Color(0xFF64748B),
      };
}

extension TaskTypeX on TaskType {
  String get label => switch (this) {
        TaskType.meeting => 'Meeting',
        TaskType.call => 'Call',
        TaskType.leaveAppointment => 'Leave appointment',
        TaskType.servicing => 'Servicing',
        TaskType.eApp => 'e-App',
        TaskType.other => 'Other',
      };
}

class TaskMock {
  TaskMock({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.priority,
    required this.status,
    required this.startAt,
    required this.endAt,
    this.linkLabel = '',
    this.attachmentCount = 0,
    this.assignedBy = '',
    this.isNewAssignment = false,
  });

  final String id;
  String title;
  String description;
  TaskType type;
  TaskPriority priority;
  TaskStatus status;
  DateTime startAt;
  DateTime endAt;
  String linkLabel;
  int attachmentCount;
  String assignedBy;
  bool isNewAssignment;

  bool get isOverdue {
    if (status == TaskStatus.completed) return false;
    final today = DateTime(2026, 8, 14);
    final end = DateTime(endAt.year, endAt.month, endAt.day);
    return end.isBefore(today);
  }

  bool isOnDay(DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    final s = DateTime(startAt.year, startAt.month, startAt.day);
    final e = DateTime(endAt.year, endAt.month, endAt.day);
    return !d.isBefore(s) && !d.isAfter(e);
  }

  TaskMock copy() => TaskMock(
        id: id,
        title: title,
        description: description,
        type: type,
        priority: priority,
        status: status,
        startAt: startAt,
        endAt: endAt,
        linkLabel: linkLabel,
        attachmentCount: attachmentCount,
        assignedBy: assignedBy,
        isNewAssignment: isNewAssignment,
      );
}

abstract final class TaskFormat {
  static const _months = [
    'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
  ];
  static const _monthsShort = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  static const _weekdays = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
  ];

  static String dob(DateTime d) {
    final day = d.day.toString().padLeft(2, '0');
    return '$day-${_months[d.month - 1]}-${d.year}';
  }

  static String dayHero(DateTime d) {
    final wd = _weekdays[(d.weekday - 1) % 7];
    return '$wd, ${d.day} ${_monthsShort[d.month - 1]} ${d.year}';
  }

  static String timeOf(DateTime d) {
    final h = d.hour.toString().padLeft(2, '0');
    final m = d.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  static DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}

abstract final class TaskSession {
  static int _n = 5;

  static final List<TaskMock> tasks = [
    TaskMock(
      id: 'T-001',
      title: 'Meeting appointment',
      description: 'Discuss Universal Life quote with May Chan Myae.',
      type: TaskType.meeting,
      priority: TaskPriority.high,
      status: TaskStatus.pending,
      startAt: DateTime(2026, 8, 14, 10, 0),
      endAt: DateTime(2026, 8, 14, 11, 0),
      linkLabel: 'Client · May Chan Myae',
      attachmentCount: 2,
      assignedBy: 'AM',
      isNewAssignment: true,
    ),
    TaskMock(
      id: 'T-002',
      title: 'Follow-up call — life quote',
      description: 'Call lead about pending Get A Quote.',
      type: TaskType.call,
      priority: TaskPriority.high,
      status: TaskStatus.inProgress,
      startAt: DateTime(2026, 8, 14, 14, 30),
      endAt: DateTime(2026, 8, 14, 15, 0),
      linkLabel: 'Lead · Chan Myae',
    ),
    TaskMock(
      id: 'T-003',
      title: 'Send policy renewal documents',
      description: 'Email renewal pack for Personal Accident.',
      type: TaskType.servicing,
      priority: TaskPriority.medium,
      status: TaskStatus.pending,
      startAt: DateTime(2026, 8, 13, 9, 0),
      endAt: DateTime(2026, 8, 13, 17, 0),
      linkLabel: 'Policy · 23487532096712',
      isNewAssignment: false,
    ),
    TaskMock(
      id: 'T-004',
      title: 'e-App signature follow-up',
      description: 'Collect client signature for draft e-App.',
      type: TaskType.eApp,
      priority: TaskPriority.medium,
      status: TaskStatus.pending,
      startAt: DateTime(2026, 8, 15, 11, 0),
      endAt: DateTime(2026, 8, 15, 12, 0),
      linkLabel: 'e-App · EA-2026-0001',
    ),
    TaskMock(
      id: 'T-005',
      title: 'Leave appointment — AM',
      description: 'Field leave / appointment block.',
      type: TaskType.leaveAppointment,
      priority: TaskPriority.low,
      status: TaskStatus.completed,
      startAt: DateTime(2026, 8, 12, 9, 0),
      endAt: DateTime(2026, 8, 12, 12, 0),
      assignedBy: 'AM',
    ),
  ];

  static int get pendingCount =>
      tasks.where((t) => t.status == TaskStatus.pending).length;

  static int get inProgressCount =>
      tasks.where((t) => t.status == TaskStatus.inProgress).length;

  static int get completedCount =>
      tasks.where((t) => t.status == TaskStatus.completed).length;

  static int get overdueCount => tasks.where((t) => t.isOverdue).length;

  static List<TaskMock> forDay(DateTime day) {
    final list = tasks.where((t) => t.isOnDay(day)).toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));
    return list;
  }

  static List<TaskMock> filtered({
    required DateTime day,
    TaskStatus? status,
    TaskType? type,
  }) {
    return forDay(day).where((t) {
      final statusOk = status == null || t.status == status;
      final typeOk = type == null || t.type == type;
      return statusOk && typeOk;
    }).toList();
  }

  static TaskMock? byId(String id) {
    for (final t in tasks) {
      if (t.id == id) return t;
    }
    return null;
  }

  static TaskMock create({
    required String title,
    required String description,
    required TaskType type,
    required TaskPriority priority,
    required TaskStatus status,
    required DateTime startAt,
    required DateTime endAt,
    String linkLabel = '',
    int attachmentCount = 0,
  }) {
    _n += 1;
    final task = TaskMock(
      id: 'T-${_n.toString().padLeft(3, '0')}',
      title: title,
      description: description,
      type: type,
      priority: priority,
      status: status,
      startAt: startAt,
      endAt: endAt,
      linkLabel: linkLabel,
      attachmentCount: attachmentCount,
    );
    tasks.insert(0, task);
    return task;
  }

  static void upsert(TaskMock task) {
    final i = tasks.indexWhere((t) => t.id == task.id);
    if (i >= 0) {
      tasks[i] = task;
    } else {
      tasks.insert(0, task);
    }
  }

  static void markCompleted(TaskMock task) {
    task.status = TaskStatus.completed;
    task.isNewAssignment = false;
  }
}
