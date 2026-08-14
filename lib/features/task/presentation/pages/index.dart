import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors, AppRoute;
import 'package:life_insurance/features/components/components.dart'
    show AppBottomNavBar;
import 'package:life_insurance/features/task/presentation/models/task_mock_data.dart';

/// My work — calendar-centric Day agenda (docs/08 · 68). P0: Day primary.
class TaskBoardPage extends StatefulWidget {
  const TaskBoardPage({super.key});

  @override
  State<TaskBoardPage> createState() => _TaskBoardPageState();
}

enum _Scope { day, week, month }

class _TaskBoardPageState extends State<TaskBoardPage> {
  DateTime _day = DateTime(2026, 8, 14);
  _Scope _scope = _Scope.day;
  TaskStatus? _statusFilter;
  TaskType? _typeFilter;

  Future<void> _openForm({String? taskId}) async {
    final changed = await context.push<bool>(
      AppRoute.taskForm,
      extra: TaskFormArgs(taskId: taskId, initialDay: _day),
    );
    if (changed == true && mounted) setState(() {});
  }

  void _shiftDay(int delta) {
    setState(() => _day = _day.add(Duration(days: delta)));
  }

  List<TaskMock> get _rows {
    if (_scope == _Scope.week) {
      final start = _day.subtract(Duration(days: _day.weekday - 1));
      final out = <TaskMock>[];
      final seen = <String>{};
      for (var i = 0; i < 7; i++) {
        final d = start.add(Duration(days: i));
        for (final t in TaskSession.filtered(
          day: d,
          status: _statusFilter,
          type: _typeFilter,
        )) {
          if (seen.add(t.id)) out.add(t);
        }
      }
      out.sort((a, b) => a.startAt.compareTo(b.startAt));
      return out;
    }
    if (_scope == _Scope.month) {
      // Month: show all tasks that fall in the month of _day.
      final out = TaskSession.tasks.where((t) {
        final inMonth =
            (t.startAt.year == _day.year && t.startAt.month == _day.month) ||
                (t.endAt.year == _day.year && t.endAt.month == _day.month);
        final statusOk = _statusFilter == null || t.status == _statusFilter;
        final typeOk = _typeFilter == null || t.type == _typeFilter;
        return inMonth && statusOk && typeOk;
      }).toList()
        ..sort((a, b) => a.startAt.compareTo(b.startAt));
      return out;
    }
    return TaskSession.filtered(
      day: _day,
      status: _statusFilter,
      type: _typeFilter,
    );
  }

  @override
  Widget build(BuildContext context) {
    final rows = _rows;
    final newCount = TaskSession.tasks.where((t) => t.isNewAssignment).length;
    // Nested Scaffold FAB sits under the shell pill — dock in a Stack instead.
    final fabBottom = AppBottomNavBar.overlayHeight(context) + 8;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverAppBar(
                backgroundColor: const Color(0xFFF8FAFC),
                elevation: 0,
                floating: true,
                snap: true,
                pinned: false,
                centerTitle: false,
                title: Text(
                  'My work · ${TaskSession.tasks.length}',
                  style: const TextStyle(
                    color: AppColors.lightTextPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                actions: [
                  IconButton(
                    tooltip: 'Create task',
                    onPressed: () => _openForm(),
                    icon: const Icon(Icons.add_circle_outline),
                    color: AppColors.lightPrimary,
                  ),
                ],
              ),
              SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _shiftDay(-1),
                        icon: const Icon(Icons.chevron_left),
                      ),
                      Expanded(
                        child: Text(
                          TaskFormat.dayHero(_day),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _shiftDay(1),
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      for (final s in _Scope.values) ...[
                        Expanded(
                          child: _ScopeChip(
                            label: switch (s) {
                              _Scope.day => 'Day',
                              _Scope.week => 'Week',
                              _Scope.month => 'Month',
                            },
                            selected: _scope == s,
                            onTap: () => setState(() => _scope = s),
                          ),
                        ),
                        if (s != _Scope.month) const SizedBox(width: 8),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _StatChip(
                        label: 'Pending',
                        value: '${TaskSession.pendingCount}',
                        color: const Color(0xFFF59E0B),
                      ),
                      const SizedBox(width: 8),
                      _StatChip(
                        label: 'In progress',
                        value: '${TaskSession.inProgressCount}',
                        color: AppColors.lightPrimary,
                      ),
                      const SizedBox(width: 8),
                      _StatChip(
                        label: 'Overdue',
                        value: '${TaskSession.overdueCount}',
                        color: const Color(0xFFE11D48),
                      ),
                    ],
                  ),
                  if (newCount > 0) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightPrimary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'New from AM · $newCount assignment${newCount == 1 ? '' : 's'}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.lightPrimary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(
                          label: 'All status',
                          selected: _statusFilter == null,
                          onTap: () => setState(() => _statusFilter = null),
                        ),
                        for (final s in TaskStatus.values)
                          _FilterChip(
                            label: s.label,
                            selected: _statusFilter == s,
                            onTap: () => setState(() => _statusFilter = s),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(
                          label: 'All types',
                          selected: _typeFilter == null,
                          onTap: () => setState(() => _typeFilter = null),
                        ),
                        for (final t in [
                          TaskType.meeting,
                          TaskType.call,
                          TaskType.servicing,
                          TaskType.eApp,
                          TaskType.leaveAppointment,
                        ])
                          _FilterChip(
                            label: t.label,
                            selected: _typeFilter == t,
                            onTap: () => setState(() => _typeFilter = t),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (rows.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
                child: Column(
                  children: [
                    Icon(
                      Icons.event_available_outlined,
                      size: 48,
                      color: AppColors.lightPrimary.withValues(alpha: 0.45),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'No tasks for this scope',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Create a follow-up for this day, week, or month.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.lightTextHint,
                      ),
                    ),
                    const SizedBox(height: 16),
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
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final t = rows[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _TaskAgendaCard(
                        task: t,
                        onTap: () => _openForm(taskId: t.id),
                      ),
                    );
                  },
                  childCount: rows.length,
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: AppBottomNavBar.scrollClearance(context) + 56,
            ),
          ),
            ],
          ),
          Positioned(
            right: 16,
            bottom: fabBottom,
            child: FloatingActionButton(
              onPressed: () => _openForm(),
              tooltip: 'Create task',
              heroTag: 'my-work-create-fab',
              backgroundColor: AppColors.lightPrimary,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white),
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

class _ScopeChip extends StatelessWidget {
  const _ScopeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.lightPrimary : Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? AppColors.lightPrimary : const Color(0xFFE5E7EB),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: selected ? Colors.white : AppColors.lightTextPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: selected
            ? AppColors.lightPrimary.withValues(alpha: 0.12)
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected
                    ? AppColors.lightPrimary
                    : const Color(0xFFE5E7EB),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected
                    ? AppColors.lightPrimary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskAgendaCard extends StatelessWidget {
  const _TaskAgendaCard({required this.task, required this.onTap});

  final TaskMock task;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border(
              left: BorderSide(color: task.priority.color, width: 4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 44,
                child: Text(
                  TaskFormat.timeOf(task.startAt),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      [
                        task.type.label,
                        if (task.linkLabel.isNotEmpty) task.linkLabel,
                      ].join(' · '),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _StatusPill(status: task.status),
                        if (task.isOverdue) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE11D48)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Overdue',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFE11D48),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.lightTextHint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final TaskStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      TaskStatus.pending => const Color(0xFFF59E0B),
      TaskStatus.inProgress => AppColors.lightPrimary,
      TaskStatus.completed => AppColors.successGreen,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
