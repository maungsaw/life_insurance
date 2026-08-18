import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;
import 'package:life_insurance/features/components/components.dart'
    show AppSelectChip;

const leadStages = ['New', 'Contacted', 'Quoted', 'Applied'];

Future<String?> showLeadFilterSheet(
  BuildContext context, {
  required String? initial,
}) {
  return showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      var selected = initial;
      return StatefulBuilder(
        builder: (context, setSheetState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter leads',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface(context),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Stage',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurfaceSecondary(context),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _StageChoice(
                      label: 'All',
                      selected: selected == null,
                      onTap: () => setSheetState(() => selected = null),
                    ),
                    for (final stage in leadStages)
                      _StageChoice(
                        label: stage,
                        selected: selected == stage,
                        onTap: () => setSheetState(() => selected = stage),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () =>
                        Navigator.of(context).pop<String>(selected ?? ''),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.lightPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Apply',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _StageChoice extends StatelessWidget {
  const _StageChoice({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppSelectChip(
      label: label,
      selected: selected,
      onTap: onTap,
      outlinedWhenIdle: true,
      fontSize: 12,
    );
  }
}
