import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;

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
                const Text(
                  'Filter leads',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Stage',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.lightTextSecondary,
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
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: AppColors.lightPrimary.withValues(alpha: 0.12),
      side: BorderSide(
        color: selected ? AppColors.lightPrimary : AppColors.lightBorder,
      ),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: selected
            ? AppColors.lightPrimary
            : AppColors.lightTextSecondary,
      ),
    );
  }
}
