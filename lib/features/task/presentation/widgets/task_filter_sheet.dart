import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;
import 'package:life_insurance/features/task/presentation/models/task_mock_data.dart';

const taskFilterTypes = [
  TaskType.meeting,
  TaskType.call,
  TaskType.onboarding,
  TaskType.servicing,
  TaskType.eApp,
  TaskType.leaveAppointment,
];

/// One filter sheet replacing the two chip carousels (docs/77 §7).
/// [count] previews how many tasks the draft filter would show in the scope.
Future<TaskFilter?> showTaskFilterSheet(
  BuildContext context, {
  required TaskFilter initial,
  required int Function(TaskFilter) count,
}) {
  return showModalBottomSheet<TaskFilter>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface(context),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      var draft = initial;
      return StatefulBuilder(
        builder: (context, setSheetState) {
          void update(TaskFilter next) => setSheetState(() => draft = next);
          final shown = count(draft);

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.border(context),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Filter tasks',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface(context),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _Group(
                      label: 'Status',
                      children: [
                        _Choice(
                          label: 'All',
                          selected: draft.status == null,
                          onTap: () => update(draft.copyWith(clearStatus: true)),
                        ),
                        for (final s in TaskStatus.values)
                          _Choice(
                            label: s.label,
                            selected: draft.status == s,
                            onTap: () => update(
                              draft.status == s
                                  ? draft.copyWith(clearStatus: true)
                                  : draft.copyWith(status: s),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _Group(
                      label: 'Type',
                      children: [
                        _Choice(
                          label: 'All',
                          selected: draft.type == null,
                          onTap: () => update(draft.copyWith(clearType: true)),
                        ),
                        for (final t in taskFilterTypes)
                          _Choice(
                            label: t.label,
                            selected: draft.type == t,
                            onTap: () => update(
                              draft.type == t
                                  ? draft.copyWith(clearType: true)
                                  : draft.copyWith(type: t),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _Group(
                      label: 'Assignment',
                      children: [
                        for (final a in TaskAssignment.values)
                          _Choice(
                            label: a.label,
                            selected: draft.assignment == a,
                            onTap: () => update(draft.copyWith(assignment: a)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => update(const TaskFilter()),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(color: AppColors.border(context)),
                              foregroundColor: AppColors.onSurfaceSecondary(context),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Reset',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: FilledButton(
                            onPressed: () =>
                                Navigator.of(context).pop<TaskFilter>(draft),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.lightPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Show $shown task${shown == 1 ? '' : 's'}',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

class _Group extends StatelessWidget {
  const _Group({required this.label, required this.children});

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurfaceSecondary(context),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: children),
      ],
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice({
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
      color: selected
          ? AppColors.lightPrimary.withValues(alpha: 0.12)
          : AppColors.surface(context),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.lightPrimary : AppColors.border(context),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected
                  ? AppColors.lightPrimary
                  : AppColors.onSurfaceSecondary(context),
            ),
          ),
        ),
      ),
    );
  }
}

/// Removable summary of the applied filters (docs/77 §7).
class TaskActiveFilterRow extends StatelessWidget {
  const TaskActiveFilterRow({
    super.key,
    required this.filter,
    required this.onChanged,
  });

  final TaskFilter filter;
  final ValueChanged<TaskFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    if (!filter.isActive) return const SizedBox.shrink();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (filter.status != null)
          _Removable(
            label: filter.status!.label,
            onRemove: () => onChanged(filter.copyWith(clearStatus: true)),
          ),
        if (filter.type != null)
          _Removable(
            label: filter.type!.label,
            onRemove: () => onChanged(filter.copyWith(clearType: true)),
          ),
        if (filter.assignment != TaskAssignment.all)
          _Removable(
            label: filter.assignment.label,
            onRemove: () =>
                onChanged(filter.copyWith(assignment: TaskAssignment.all)),
          ),
      ],
    );
  }
}

class _Removable extends StatelessWidget {
  const _Removable({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.lightPrimary.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onRemove,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 6, 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.lightPrimary,
                ),
              ),
              const SizedBox(width: 2),
              const Icon(
                Icons.close,
                size: 14,
                color: AppColors.lightPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
