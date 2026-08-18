import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppDate;

/// FR-07 task mock (docs/68). In-memory session — no API.

enum TaskStatus { pending, inProgress, completed }

enum TaskPriority { high, medium, low }

enum TaskType {
  meeting,
  call,
  onboarding,
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
    TaskType.onboarding => 'On-Boarding',
    TaskType.leaveAppointment => 'Leave appointment',
    TaskType.servicing => 'Servicing',
    TaskType.eApp => 'e-App',
    TaskType.other => 'Other',
  };
}

abstract final class OnboardingCatalog {
  static const trainings = [
    'Licensing Training',
    'Mock Test',
    'PD Training (UL)',
    'PD Training (Non-Unit)',
    'Sales Process Training',
    'Ethics and compliance training',
    'Underwriting Training',
    'Claim Training',
    'Customer Care Training',
    'Financial Planning Training',
    'Concept Selling Training',
    'Product Refresher Training',
  ];

  static const exams = [
    'Exam Result (1st Round)',
    'Exam Result (2nd Round)',
    'Exam Result (3rd Round)',
  ];

  static const trainingOptions = [
    'Not started',
    'In progress',
    'Completed',
    'N/A',
  ];
  static const examOptions = ['Not taken', 'Pass', 'Fail'];
  static const hoOptions = ['Unassigned', 'HO Yangon', 'HO Mandalay'];
  static const leadSources = [
    'Referral',
    'Walk-in',
    'Campaign',
    'Digital',
    'Other',
  ];
  static const regions = ['Yangon', 'Mandalay', 'Naypyitaw', 'Other'];
  static const contracts = ['Agency', 'Broker', 'Other'];
  static const otherInsurer = ['None', 'Yes'];
  static const licenseApp = [
    'Not started',
    'In progress',
    'Submitted',
    'Issued',
    'N/A',
  ];
}

class OnboardingMock {
  OnboardingMock({
    this.interviewScore = '',
    this.agentName = '',
    this.idType = 'NRC',
    this.identification = '',
    this.phone = '',
    this.stateRegion = 'Yangon',
    this.address = '',
    DateTime? joinDate,
    this.hoAssignment = 'Unassigned',
    this.leadSourceType = 'Referral',
    this.leadSourceDetail = '',
    Map<String, String>? training,
    this.contractType = 'Agency',
    this.otherInsurer = 'None',
    this.licenseApplication = 'Not started',
    this.licenseNo = '',
    this.agentCode = '',
  }) : joinDate = joinDate ?? DateTime(2026, 8, 14),
       training = {
         for (final k in OnboardingCatalog.trainings) k: 'Not started',
         for (final k in OnboardingCatalog.exams) k: 'Not taken',
         ...?training,
       };

  String interviewScore;
  String agentName;
  String idType;
  String identification;
  String phone;
  String stateRegion;
  String address;
  DateTime joinDate;
  String hoAssignment;
  String leadSourceType;
  String leadSourceDetail;
  Map<String, String> training;
  String contractType;
  String otherInsurer;
  String licenseApplication;
  String licenseNo;
  String agentCode;

  OnboardingMock copy() => OnboardingMock(
    interviewScore: interviewScore,
    agentName: agentName,
    idType: idType,
    identification: identification,
    phone: phone,
    stateRegion: stateRegion,
    address: address,
    joinDate: joinDate,
    hoAssignment: hoAssignment,
    leadSourceType: leadSourceType,
    leadSourceDetail: leadSourceDetail,
    training: Map<String, String>.from(training),
    contractType: contractType,
    otherInsurer: otherInsurer,
    licenseApplication: licenseApplication,
    licenseNo: licenseNo,
    agentCode: agentCode,
  );
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
    this.onboarding,
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
  OnboardingMock? onboarding;

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
    onboarding: onboarding?.copy(),
  );
}

abstract final class TaskFormat {
  static const _monthsShort = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  static String dob(DateTime d) => AppDate.dMy(d);

  static String dayHero(DateTime d) {
    final wd = _weekdays[(d.weekday - 1) % 7];
    return '$wd, ${d.day} ${_monthsShort[d.month - 1]} ${d.year}';
  }

  static String timeOf(DateTime d) => AppDate.h12(d);

  static DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static String weekdayShort(DateTime d) => _weekdays[(d.weekday - 1) % 7];

  static String monthShort(DateTime d) => _monthsShort[d.month - 1];

  /// `Fri, 14 Aug` — agenda group heading.
  static String dayHeading(DateTime d) =>
      '${weekdayShort(d)}, ${d.day} ${monthShort(d)}';

  /// `Aug-2026` — Month scope title (`95`).
  static String monthTitle(DateTime d) => AppDate.monthYear(d);

  /// `10–16-Aug-2026`, or `28-Aug – 03-Sep-2026` across months.
  static String weekRangeTitle(DateTime start) => AppDate.weekRange(start);
}

/// Assignment lens on My work (docs/77).
enum TaskAssignment { all, assignedToMe, newOnly }

extension TaskAssignmentX on TaskAssignment {
  String get label => switch (this) {
    TaskAssignment.all => 'All',
    TaskAssignment.assignedToMe => 'Assigned to me',
    TaskAssignment.newOnly => 'New',
  };
}

/// One filter set for the My work calendar (docs/77 — replaces chip rows).
class TaskFilter {
  const TaskFilter({
    this.status,
    this.type,
    this.assignment = TaskAssignment.all,
  });

  final TaskStatus? status;
  final TaskType? type;
  final TaskAssignment assignment;

  bool get isActive =>
      status != null || type != null || assignment != TaskAssignment.all;

  int get activeCount =>
      (status == null ? 0 : 1) +
      (type == null ? 0 : 1) +
      (assignment == TaskAssignment.all ? 0 : 1);

  TaskFilter copyWith({
    TaskStatus? status,
    TaskType? type,
    TaskAssignment? assignment,
    bool clearStatus = false,
    bool clearType = false,
  }) {
    return TaskFilter(
      status: clearStatus ? null : (status ?? this.status),
      type: clearType ? null : (type ?? this.type),
      assignment: assignment ?? this.assignment,
    );
  }
}

abstract final class TaskSession {
  static int _n = 6;

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
    TaskMock(
      id: 'T-006',
      title: 'Agent',
      description: '',
      type: TaskType.onboarding,
      priority: TaskPriority.high,
      status: TaskStatus.inProgress,
      startAt: DateTime(2026, 8, 14, 9, 0),
      endAt: DateTime(2026, 8, 14, 17, 0),
      assignedBy: 'AM',
      isNewAssignment: true,
      onboarding: OnboardingMock(
        interviewScore: '78',
        agentName: 'May Thu',
        idType: 'NRC',
        identification: '12/PaZaTa(N)094875',
        phone: '09 779405886',
        stateRegion: 'Yangon',
        address: 'Universal',
        joinDate: DateTime(2026, 6, 4),
        hoAssignment: 'HO Yangon',
        leadSourceType: 'Referral',
        leadSourceDetail: 'AM intro',
        training: const {
          'Licensing Training': 'In progress',
          'Mock Test': 'Not started',
        },
        licenseNo: '',
        agentCode: '',
      ),
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

  /// Prototype "now" — mock data is anchored to this date.
  static DateTime get today => DateTime(2026, 8, 14);

  static DateTime startOfWeek(DateTime d) {
    final date = TaskFormat.dateOnly(d);
    return date.subtract(Duration(days: date.weekday - 1));
  }

  static bool matches(TaskMock t, TaskFilter filter) {
    if (filter.status != null && t.status != filter.status) return false;
    if (filter.type != null && t.type != filter.type) return false;
    switch (filter.assignment) {
      case TaskAssignment.all:
        return true;
      case TaskAssignment.assignedToMe:
        return t.assignedBy.isNotEmpty;
      case TaskAssignment.newOnly:
        return t.isNewAssignment;
    }
  }

  /// Tasks touching any day between [start] and [end] inclusive.
  static List<TaskMock> forRange(
    DateTime start,
    DateTime end, {
    TaskFilter filter = const TaskFilter(),
  }) {
    final from = TaskFormat.dateOnly(start);
    final to = TaskFormat.dateOnly(end);
    final out = tasks.where((t) {
      final s = TaskFormat.dateOnly(t.startAt);
      final e = TaskFormat.dateOnly(t.endAt);
      final overlaps = !e.isBefore(from) && !s.isAfter(to);
      return overlaps && matches(t, filter);
    }).toList()..sort((a, b) => a.startAt.compareTo(b.startAt));
    return out;
  }

  static List<TaskMock> forDayFiltered(
    DateTime day, {
    TaskFilter filter = const TaskFilter(),
  }) {
    return forDay(day).where((t) => matches(t, filter)).toList();
  }

  static int countForDay(DateTime day, {TaskFilter filter = const TaskFilter()}) {
    return forDayFiltered(day, filter: filter).length;
  }

  /// Weeks of the month grid, Monday-first, always full 7-day rows.
  static List<List<DateTime>> monthMatrix(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final last = DateTime(month.year, month.month + 1, 0);
    final gridStart = startOfWeek(first);
    final rows = <List<DateTime>>[];
    var cursor = gridStart;
    while (!cursor.isAfter(last)) {
      rows.add([
        for (var i = 0; i < 7; i++)
          DateTime(cursor.year, cursor.month, cursor.day + i),
      ]);
      cursor = DateTime(cursor.year, cursor.month, cursor.day + 7);
    }
    return rows;
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
    OnboardingMock? onboarding,
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
      onboarding: onboarding,
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
