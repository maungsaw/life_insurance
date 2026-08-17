import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors, AppRoute;
import 'package:life_insurance/features/components/components.dart'
    show AppBottomNavBar;
import 'package:life_insurance/features/task/presentation/models/task_mock_data.dart';
import 'package:life_insurance/features/task/presentation/widgets/task_calendar.dart';
import 'package:life_insurance/features/task/presentation/widgets/task_filter_sheet.dart';

const _kBorder = Color(0xFFE5E7EB);
const _kRed = Color(0xFFE11D48);

/// My work — one shell, three calendar bodies (docs/77 P0 · BRD FR-07).
class TaskBoardPage extends StatefulWidget {
  const TaskBoardPage({super.key});

  @override
  State<TaskBoardPage> createState() => _TaskBoardPageState();
}

enum _Scope { day, week, month }

extension _ScopeX on _Scope {
  String get label => switch (this) {
    _Scope.day => 'Day',
    _Scope.week => 'Week',
    _Scope.month => 'Month',
  };
}

class _TaskBoardPageState extends State<TaskBoardPage> {
  DateTime _selected = TaskSession.today;
  _Scope _scope = _Scope.day;
  TaskFilter _filter = const TaskFilter();

  DateTime get _weekStart => TaskSession.startOfWeek(_selected);
  DateTime get _weekEnd => DateTime(
    _weekStart.year,
    _weekStart.month,
    _weekStart.day + 6,
  );
  DateTime get _monthFirst => DateTime(_selected.year, _selected.month, 1);
  DateTime get _monthLast => DateTime(_selected.year, _selected.month + 1, 0);

  List<TaskMock> _tasksFor(TaskFilter filter) => switch (_scope) {
    _Scope.day => TaskSession.forDayFiltered(_selected, filter: filter),
    _Scope.week => TaskSession.forRange(_weekStart, _weekEnd, filter: filter),
    _Scope.month => TaskSession.forRange(
      _monthFirst,
      _monthLast,
      filter: filter,
    ),
  };

  List<TaskMock> get _scopeTasks => _tasksFor(_filter);

  String get _title => switch (_scope) {
    _Scope.day => TaskFormat.dayHero(_selected),
    _Scope.week => TaskFormat.weekRangeTitle(_weekStart),
    _Scope.month => TaskFormat.monthTitle(_selected),
  };

  bool get _showsToday => switch (_scope) {
    _Scope.day => isSameDay(_selected, TaskSession.today),
    _Scope.week =>
      !TaskSession.today.isBefore(_weekStart) &&
          !TaskSession.today.isAfter(_weekEnd),
    _Scope.month =>
      _selected.year == TaskSession.today.year &&
          _selected.month == TaskSession.today.month,
  };

  /// Day ±1 day · Week ±7 days · Month ±1 month (docs/77 §3).
  void _shift(int dir) {
    setState(() {
      switch (_scope) {
        case _Scope.day:
          _selected = DateTime(
            _selected.year,
            _selected.month,
            _selected.day + dir,
          );
        case _Scope.week:
          _selected = DateTime(
            _selected.year,
            _selected.month,
            _selected.day + 7 * dir,
          );
        case _Scope.month:
          final month = _selected.month + dir;
          final lastDay = DateTime(_selected.year, month + 1, 0).day;
          _selected = DateTime(
            _selected.year,
            month,
            _selected.day > lastDay ? lastDay : _selected.day,
          );
      }
    });
  }

  Future<void> _openForm({String? taskId}) async {
    if (taskId != null) {
      // Opening the assignment acknowledges it (docs/77 §8).
      TaskSession.byId(taskId)?.isNewAssignment = false;
    }
    await context.push<bool>(
      AppRoute.taskForm,
      extra: TaskFormArgs(taskId: taskId, initialDay: _selected),
    );
    // Scope, date and filters are intentionally preserved (docs/77 §11).
    if (mounted) setState(() {});
  }

  Future<void> _openFilters() async {
    final next = await showTaskFilterSheet(
      context,
      initial: _filter,
      count: (draft) => _tasksFor(draft).length,
    );
    if (next != null && mounted) setState(() => _filter = next);
  }

  @override
  Widget build(BuildContext context) {
    final rows = _scopeTasks;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xFFF8FAFC),
            elevation: 0,
            floating: true,
            snap: true,
            centerTitle: false,
            title: const Text(
              'My work',
              style: TextStyle(
                color: AppColors.lightTextPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Material(
                  color: AppColors.lightPrimary,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: IconButton(
                    tooltip: 'Create task',
                    onPressed: () => _openForm(),
                    icon: const Icon(Icons.add, color: Colors.white),
                    iconSize: 22,
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ScopeBar(
                    scope: _scope,
                    onChanged: (s) => setState(() => _scope = s),
                  ),
                  const SizedBox(height: 10),
                  _DateNav(
                    title: _title,
                    showToday: !_showsToday,
                    onPrev: () => _shift(-1),
                    onNext: () => _shift(1),
                    onToday: () =>
                        setState(() => _selected = TaskSession.today),
                  ),
                  const SizedBox(height: 8),
                  _calendarHeader(),
                  const SizedBox(height: 12),
                  _summaryRow(rows),
                  if (_filter.isActive) ...[
                    const SizedBox(height: 10),
                    TaskActiveFilterRow(
                      filter: _filter,
                      onChanged: (f) => setState(() => _filter = f),
                    ),
                  ],
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: rows.isEmpty ? _emptyState() : _body(),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: AppBottomNavBar.scrollClearance(context)),
          ),
        ],
      ),
    );
  }

  Widget _calendarHeader() {
    void select(DateTime d) => setState(() => _selected = d);
    return switch (_scope) {
      _Scope.day => TaskDayStrip(
        selectedDay: _selected,
        filter: _filter,
        onSelect: select,
      ),
      _Scope.week => TaskWeekStrip(
        weekStart: _weekStart,
        selectedDay: _selected,
        filter: _filter,
        onSelect: select,
      ),
      _Scope.month => TaskMonthGrid(
        month: _monthFirst,
        selectedDay: _selected,
        filter: _filter,
        onSelect: select,
      ),
    };
  }

  Widget _body() {
    switch (_scope) {
      case _Scope.day:
        return TaskDayTimeline(
          day: _selected,
          tasks: TaskSession.forDayFiltered(_selected, filter: _filter),
          onOpen: (t) => _openForm(taskId: t.id),
        );
      case _Scope.week:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < 7; i++)
              ..._agendaGroup(
                DateTime(_weekStart.year, _weekStart.month, _weekStart.day + i),
              ),
          ],
        );
      case _Scope.month:
        final dayTasks = TaskSession.forDayFiltered(
          _selected,
          filter: _filter,
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TaskDayHeading(day: _selected, count: dayTasks.length),
            if (dayTasks.isEmpty)
              _hint('No tasks on ${TaskFormat.dayHeading(_selected)}.')
            else
              for (final t in dayTasks)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TaskAgendaCard(
                    task: t,
                    onTap: () => _openForm(taskId: t.id),
                  ),
                ),
          ],
        );
    }
  }

  /// Week agenda group — empty days stay in the strip only (docs/77 §5).
  List<Widget> _agendaGroup(DateTime day) {
    final tasks = TaskSession.forDayFiltered(day, filter: _filter);
    if (tasks.isEmpty) return const [];
    return [
      TaskDayHeading(
        day: day,
        count: tasks.length,
        highlighted: isSameDay(day, _selected),
      ),
      for (final t in tasks)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: TaskAgendaCard(
            task: t,
            onTap: () => _openForm(taskId: t.id),
          ),
        ),
      const SizedBox(height: 6),
    ];
  }

  Widget _hint(String text) => Padding(
    padding: const EdgeInsets.only(top: 4, bottom: 8),
    child: Text(
      text,
      style: const TextStyle(fontSize: 13, color: AppColors.lightTextHint),
    ),
  );

  /// Scope-aware counts, not global totals (docs/77 §7).
  Widget _summaryRow(List<TaskMock> rows) {
    final inProgress = rows
        .where((t) => t.status == TaskStatus.inProgress)
        .length;
    final overdue = rows.where((t) => t.isOverdue).length;
    final fresh = rows.where((t) => t.isNewAssignment).length;

    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: 6,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                '${rows.length} task${rows.length == 1 ? '' : 's'}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.lightTextPrimary,
                ),
              ),
              if (inProgress > 0)
                const Text(
                  '·',
                  style: TextStyle(color: AppColors.lightTextHint),
                ),
              if (inProgress > 0)
                Text(
                  '$inProgress in progress',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
              if (overdue > 0)
                const Text(
                  '·',
                  style: TextStyle(color: AppColors.lightTextHint),
                ),
              if (overdue > 0)
                Text(
                  '$overdue overdue',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _kRed,
                  ),
                ),
              if (fresh > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightPrimary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$fresh new',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.lightPrimary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _FilterButton(
          activeCount: _filter.activeCount,
          onTap: _openFilters,
        ),
      ],
    );
  }

  Widget _emptyState() {
    final filtered = _filter.isActive;
    final copy = filtered
        ? 'No tasks match these filters'
        : switch (_scope) {
            _Scope.day => 'No tasks on ${TaskFormat.dayHeading(_selected)}',
            _Scope.week => 'No tasks this week',
            _Scope.month =>
              'No tasks in ${TaskFormat.monthTitle(_selected).split(' ').first}',
          };

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 24, 8, 16),
      child: Column(
        children: [
          Icon(
            Icons.event_available_outlined,
            size: 44,
            color: AppColors.lightPrimary.withValues(alpha: 0.45),
          ),
          const SizedBox(height: 12),
          Text(
            copy,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 14),
          if (filtered)
            TextButton.icon(
              onPressed: () => setState(() => _filter = const TaskFilter()),
              icon: const Icon(Icons.filter_alt_off_outlined),
              label: const Text('Reset filters'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.lightPrimary,
                textStyle: const TextStyle(fontWeight: FontWeight.w800),
              ),
            )
          else
            TextButton.icon(
              onPressed: () => _openForm(),
              icon: const Icon(Icons.add),
              label: const Text('Create task'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.lightPrimary,
                textStyle: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
        ],
      ),
    );
  }
}

/// Args for GoRoute extra.
class TaskFormArgs {
  const TaskFormArgs({this.taskId, this.initialDay});

  final String? taskId;
  final DateTime? initialDay;
}

class _ScopeBar extends StatelessWidget {
  const _ScopeBar({required this.scope, required this.onChanged});

  final _Scope scope;
  final ValueChanged<_Scope> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kBorder),
      ),
      child: Row(
        children: [
          for (final s in _Scope.values)
            Expanded(
              child: InkWell(
                onTap: () => onChanged(s),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: scope == s
                        ? AppColors.lightPrimary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    s.label,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: scope == s
                          ? Colors.white
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DateNav extends StatelessWidget {
  const _DateNav({
    required this.title,
    required this.showToday,
    required this.onPrev,
    required this.onNext,
    required this.onToday,
  });

  final String title;
  final bool showToday;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onToday;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _NavArrow(icon: Icons.chevron_left, onTap: onPrev, tooltip: 'Previous'),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: AppColors.lightTextPrimary,
            ),
          ),
        ),
        _NavArrow(icon: Icons.chevron_right, onTap: onNext, tooltip: 'Next'),
        SizedBox(
          width: 56,
          child: showToday
              ? TextButton(
                  onPressed: onToday,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    foregroundColor: AppColors.lightPrimary,
                    minimumSize: const Size(44, 44),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                  child: const Text('Today'),
                )
              : null,
        ),
      ],
    );
  }
}

class _NavArrow extends StatelessWidget {
  const _NavArrow({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onTap,
      icon: Icon(icon, color: AppColors.lightTextPrimary),
      constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
      padding: EdgeInsets.zero,
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.activeCount, required this.onTap});

  final int activeCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final active = activeCount > 0;
    return Material(
      color: active
          ? AppColors.lightPrimary.withValues(alpha: 0.12)
          : Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          constraints: const BoxConstraints(minHeight: 36),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: active ? AppColors.lightPrimary : _kBorder,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.tune,
                size: 16,
                color: active
                    ? AppColors.lightPrimary
                    : AppColors.lightTextSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                active ? 'Filter · $activeCount' : 'Filter',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: active
                      ? AppColors.lightPrimary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
