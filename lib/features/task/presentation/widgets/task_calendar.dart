import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors, AppDate;
import 'package:life_insurance/features/task/presentation/models/task_mock_data.dart';

const _kAmber = Color(0xFFF59E0B);
const _kRed = Color(0xFFE11D48);

Color taskStatusColor(TaskStatus status) => switch (status) {
  TaskStatus.pending => _kAmber,
  TaskStatus.inProgress => AppColors.lightPrimary,
  TaskStatus.completed => AppColors.successGreen,
};

/// Side marker: red only when overdue, amber for High, otherwise quiet (docs/77 §9).
Color taskMarkerColor(TaskMock task) {
  if (task.isOverdue) return _kRed;
  return switch (task.priority) {
    TaskPriority.high => _kAmber,
    TaskPriority.medium => const Color(0xFF94A3B8),
    TaskPriority.low => const Color(0xFFCBD5E1),
  };
}

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

bool isMultiDay(TaskMock t) =>
    !isSameDay(TaskFormat.dateOnly(t.startAt), TaskFormat.dateOnly(t.endAt));

class TaskStatusPill extends StatelessWidget {
  const TaskStatusPill({super.key, required this.status});

  final TaskStatus status;

  @override
  Widget build(BuildContext context) {
    final color = taskStatusColor(status);
    return _Pill(label: status.label, color: color);
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

/// Shared agenda card for Day timeline, Week agenda and Month agenda (docs/77 §9).
class TaskAgendaCard extends StatelessWidget {
  const TaskAgendaCard({
    super.key,
    required this.task,
    required this.onTap,
    this.showTime = true,
  });

  final TaskMock task;
  final VoidCallback onTap;

  /// Day timeline puts the time in the gutter, so the card hides it.
  final bool showTime;

  @override
  Widget build(BuildContext context) {
    final done = task.status == TaskStatus.completed;
    final meta = [
      task.type.label,
      if (!showTime)
        '${TaskFormat.timeOf(task.startAt)} – ${TaskFormat.timeOf(task.endAt)}',
      if (task.linkLabel.isNotEmpty) task.linkLabel,
    ].join(' · ');

    return Material(
      color: done ? AppColors.background(context) : AppColors.surface(context),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border(context)),
          ),
          clipBehavior: Clip.antiAlias,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 3, color: taskMarkerColor(task)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 8, 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showTime)
                          SizedBox(
                            width: 72,
                            child: Text(
                              TaskFormat.timeOf(task.startAt),
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                                color: AppColors.onSurfaceSecondary(context),
                              ),
                            ),
                          ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      task.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                        color: done
                                            ? AppColors.onSurfaceSecondary(context)
                                            : AppColors.onSurface(context),
                                      ),
                                    ),
                                  ),
                                  if (task.isNewAssignment) ...[
                                    const SizedBox(width: 6),
                                    const _Pill(
                                      label: 'NEW',
                                      color: AppColors.lightPrimary,
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                meta,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.onSurfaceSecondary(context),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  TaskStatusPill(status: task.status),
                                  if (task.isOverdue) ...[
                                    const SizedBox(width: 6),
                                    const _Pill(label: 'Overdue', color: _kRed),
                                  ],
                                  const Spacer(),
                                  if (task.priority == TaskPriority.high)
                                    const Text(
                                      'High',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: _kAmber,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 20,
                          color: AppColors.hint(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Up to 3 status dots plus `+n`, with an overdue accent (docs/77 §6).
class TaskDayDots extends StatelessWidget {
  const TaskDayDots({super.key, required this.tasks});

  final List<TaskMock> tasks;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) return const SizedBox(height: 8);
    final shown = tasks.take(3).toList();
    final extra = tasks.length - shown.length;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final t in shown)
          Container(
            width: 5,
            height: 5,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: t.isOverdue ? _kRed : taskStatusColor(t.status),
              shape: BoxShape.circle,
            ),
          ),
        if (extra > 0)
          Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Text(
              '+$extra',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: AppColors.hint(context),
              ),
            ),
          ),
      ],
    );
  }
}

/// One tappable date cell used by the Day and Week strips.
class _DateCell extends StatelessWidget {
  const _DateCell({
    required this.day,
    required this.tasks,
    required this.selected,
    required this.isToday,
    required this.onTap,
    this.countLabel,
  });

  final DateTime day;
  final List<TaskMock> tasks;
  final bool selected;
  final bool isToday;
  final VoidCallback onTap;
  final String? countLabel;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? Colors.white : AppColors.onSurface(context);
    return Semantics(
      selected: selected,
      label:
          '${TaskFormat.dayHeading(day)}, ${tasks.length} task${tasks.length == 1 ? '' : 's'}',
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: const BoxConstraints(minHeight: 62),
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: selected ? AppColors.lightPrimary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: !selected && isToday
                  ? AppColors.lightPrimary
                  : Colors.transparent,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                TaskFormat.weekdayShort(day).substring(0, 1),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white70 : AppColors.hint(context),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${day.day}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: fg,
                ),
              ),
              const SizedBox(height: 4),
              if (countLabel != null)
                Text(
                  countLabel!,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: selected
                        ? Colors.white
                        : (tasks.isEmpty
                              ? AppColors.hint(context)
                              : AppColors.onSurfaceSecondary(context)),
                  ),
                )
              else if (selected)
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: tasks.isEmpty ? Colors.transparent : Colors.white,
                    shape: BoxShape.circle,
                  ),
                )
              else
                TaskDayDots(tasks: tasks),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalendarSurface extends StatelessWidget {
  const _CalendarSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: child,
    );
  }
}

/// Day scope header — 7-day strip around the selected day (docs/77 §4).
class TaskDayStrip extends StatelessWidget {
  const TaskDayStrip({
    super.key,
    required this.selectedDay,
    required this.filter,
    required this.onSelect,
  });

  final DateTime selectedDay;
  final TaskFilter filter;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final start = TaskSession.startOfWeek(selectedDay);
    return _CalendarSurface(
      child: Row(
        children: [
          for (var i = 0; i < 7; i++)
            Expanded(
              child: Builder(
                builder: (_) {
                  final d = DateTime(start.year, start.month, start.day + i);
                  return _DateCell(
                    day: d,
                    tasks: TaskSession.forDayFiltered(d, filter: filter),
                    selected: isSameDay(d, selectedDay),
                    isToday: isSameDay(d, TaskSession.today),
                    onTap: () => onSelect(d),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

/// Week scope header — all 7 dates with per-day counts (docs/77 §5).
class TaskWeekStrip extends StatelessWidget {
  const TaskWeekStrip({
    super.key,
    required this.weekStart,
    required this.selectedDay,
    required this.filter,
    required this.onSelect,
  });

  final DateTime weekStart;
  final DateTime selectedDay;
  final TaskFilter filter;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    return _CalendarSurface(
      child: Row(
        children: [
          for (var i = 0; i < 7; i++)
            Expanded(
              child: Builder(
                builder: (_) {
                  final d = DateTime(
                    weekStart.year,
                    weekStart.month,
                    weekStart.day + i,
                  );
                  final tasks = TaskSession.forDayFiltered(d, filter: filter);
                  return _DateCell(
                    day: d,
                    tasks: tasks,
                    selected: isSameDay(d, selectedDay),
                    isToday: isSameDay(d, TaskSession.today),
                    onTap: () => onSelect(d),
                    countLabel: '${tasks.length}',
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

/// Month scope header — 7-column grid with task dots (docs/77 §6).
class TaskMonthGrid extends StatelessWidget {
  const TaskMonthGrid({
    super.key,
    required this.month,
    required this.selectedDay,
    required this.filter,
    required this.onSelect,
  });

  final DateTime month;
  final DateTime selectedDay;
  final TaskFilter filter;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final rows = TaskSession.monthMatrix(month);
    return _CalendarSurface(
      child: Column(
        children: [
          Row(
            children: [
              for (final label in const ['M', 'T', 'W', 'T', 'F', 'S', 'S'])
                Expanded(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.hint(context),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          for (final week in rows)
            Row(
              children: [
                for (final d in week)
                  Expanded(
                    child: _MonthCell(
                      day: d,
                      tasks: TaskSession.forDayFiltered(d, filter: filter),
                      outside: d.month != month.month,
                      selected: isSameDay(d, selectedDay),
                      isToday: isSameDay(d, TaskSession.today),
                      onTap: () => onSelect(d),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _MonthCell extends StatelessWidget {
  const _MonthCell({
    required this.day,
    required this.tasks,
    required this.outside,
    required this.selected,
    required this.isToday,
    required this.onTap,
  });

  final DateTime day;
  final List<TaskMock> tasks;
  final bool outside;
  final bool selected;
  final bool isToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final overdue = tasks.where((t) => t.isOverdue).length;
    final color = selected
        ? Colors.white
        : outside
        ? AppColors.hint(context)
        : AppColors.onSurface(context);

    return Semantics(
      selected: selected,
      button: true,
      label:
          '${TaskFormat.dayHeading(day)}, ${tasks.length} task${tasks.length == 1 ? '' : 's'}'
          '${overdue > 0 ? ', $overdue overdue' : ''}',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          constraints: const BoxConstraints(minHeight: 46),
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: selected ? AppColors.lightPrimary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: !selected && isToday
                  ? AppColors.lightPrimary
                  : Colors.transparent,
            ),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${day.day}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 3),
                  if (selected)
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: tasks.isEmpty
                            ? Colors.transparent
                            : Colors.white,
                        shape: BoxShape.circle,
                      ),
                    )
                  else
                    TaskDayDots(tasks: tasks),
                ],
              ),
              if (overdue > 0 && !selected)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: _kRed,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Day body — all-day row plus working-hours timeline (docs/77 §4).
class TaskDayTimeline extends StatelessWidget {
  const TaskDayTimeline({
    super.key,
    required this.day,
    required this.tasks,
    required this.onOpen,
  });

  final DateTime day;
  final List<TaskMock> tasks;
  final ValueChanged<TaskMock> onOpen;

  @override
  Widget build(BuildContext context) {
    final allDay = tasks.where(isMultiDay).toList();
    final timed = tasks.where((t) => !isMultiDay(t)).toList();

    var from = 8;
    var to = 18;
    for (final t in timed) {
      from = t.startAt.hour < from ? t.startAt.hour : from;
      final endHour = t.endAt.minute > 0 ? t.endAt.hour + 1 : t.endAt.hour;
      to = endHour > to ? endHour : to;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (allDay.isNotEmpty) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 72,
                child: Text(
                  'All day',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.hint(context),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    for (final t in allDay)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TaskAgendaCard(
                          task: t,
                          showTime: false,
                          onTap: () => onOpen(t),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
        for (var hour = from; hour <= to; hour++)
          _HourRow(
            hour: hour,
            tasks: timed
                .where(
                  (t) =>
                      t.startAt.hour == hour ||
                      (hour == from && t.startAt.hour < from),
                )
                .toList(),
            onOpen: onOpen,
          ),
      ],
    );
  }
}

class _HourRow extends StatelessWidget {
  const _HourRow({
    required this.hour,
    required this.tasks,
    required this.onOpen,
  });

  final int hour;
  final List<TaskMock> tasks;
  final ValueChanged<TaskMock> onOpen;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 72,
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              AppDate.h12Hour(hour),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.hint(context),
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(height: 1, color: AppColors.border(context)),
              if (tasks.isEmpty)
                const SizedBox(height: 27)
              else
                Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 8),
                  child: Column(
                    children: [
                      for (final t in tasks)
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: t == tasks.last ? 0 : 8,
                          ),
                          child: TaskAgendaCard(
                            task: t,
                            showTime: false,
                            onTap: () => onOpen(t),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Agenda group heading used by Week and Month bodies.
class TaskDayHeading extends StatelessWidget {
  const TaskDayHeading({
    super.key,
    required this.day,
    required this.count,
    this.highlighted = false,
  });

  final DateTime day;
  final int count;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            TaskFormat.dayHeading(day),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: highlighted
                  ? AppColors.lightPrimary
                  : AppColors.onSurface(context),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '· $count task${count == 1 ? '' : 's'}',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.onSurfaceSecondary(context),
            ),
          ),
        ],
      ),
    );
  }
}
