import 'package:flutter/material.dart'
    show
        BuildContext,
        StatefulWidget,
        State,
        Widget,
        EdgeInsets,
        Color,
        SizedBox,
        Text,
        Colors,
        BorderRadius,
        BorderSide,
        RoundedRectangleBorder,
        Checkbox,
        BoxShape,
        BoxDecoration,
        Container,
        FontWeight,
        TextDecoration,
        TextStyle,
        Icons,
        Icon,
        Padding,
        ListTile,
        Card,
        Theme,
        TextSpan,
        WidgetSpan,
        PlaceholderAlignment;
import 'package:life_insurance/features/task/domain/entities/task.dart';

class TaskItemView extends StatefulWidget {
  final TaskEntities task;

  const TaskItemView({super.key, required this.task});

  @override
  State<TaskItemView> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItemView> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: task.isHighPriorityBorder
            ? BorderSide(color: Colors.red.shade200, width: 1.5)
            : BorderSide.none,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: isChecked,
            onChanged: (val) => setState(() => isChecked = val ?? false),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            activeColor: const Color(0xFF1E3A8A),
            side: BorderSide(color: Colors.grey.shade400, width: 1.5),
          ),
        ),
        title: Text.rich(
          TextSpan(
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.top,
                child: Container(
                  margin: const EdgeInsets.only(top: 6, right: 8),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: task.isHighPriorityBorder
                        ? Colors.red
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              TextSpan(
                text: task.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F172A),
                  decoration: isChecked
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
        // SUBTITLE: Column and child Rows replaced with Text.rich and '\n' line breaks
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text.rich(
            TextSpan(
              children: [
                // 1. Client Chip
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: task.isCustomer
                          ? const Color(0xFFE0F2FE)
                          : const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              task.isCustomer
                                  ? Icons.person_outline
                                  : Icons.people_outline,
                              size: 14,
                              color: task.isCustomer
                                  ? const Color(0xFF0284C7)
                                  : const Color(0xFF4F46E5),
                            ),
                          ),
                          const WidgetSpan(child: SizedBox(width: 4)),
                          TextSpan(
                            text: task.clientName,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: task.isCustomer
                                  ? const Color(0xFF0284C7)
                                  : const Color(0xFF4F46E5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // COLUMN REPLACEMENT 1: Newline breaks to separate sections vertically
                const TextSpan(text: '\n\n'),

                // 2. Tag Type Chip
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              task.tagType == 'Call'
                                  ? Icons.phone_outlined
                                  : Icons.people_outline,
                              size: 12,
                            ),
                          ),
                          const WidgetSpan(child: SizedBox(width: 4)),
                          TextSpan(
                            text: task.tagType,
                            style: TextStyle(
                              fontSize: 11,
                              color: task.tagType == 'Call'
                                  ? const Color(0xFF1E3A8A)
                                  : const Color(0xFF4F46E5),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const WidgetSpan(child: SizedBox(width: 8)),

                // 3. Date
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(
                    task.isOverdue
                        ? Icons.warning_amber_rounded
                        : Icons.calendar_today_outlined,
                    size: 12,
                    color: task.isOverdue
                        ? const Color(0xFFDC2626)
                        : Colors.grey.shade600,
                  ),
                ),
                const WidgetSpan(child: SizedBox(width: 4)),
                TextSpan(
                  text: task.dateText,
                  style: TextStyle(
                    fontSize: 11,
                    color: task.isOverdue
                        ? const Color(0xFFDC2626)
                        : Colors.grey.shade600,
                    fontWeight: task.isOverdue
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),

                const WidgetSpan(child: SizedBox(width: 12)),

                // 4. Pending Tag
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Pending',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFFD97706),
                        fontWeight: FontWeight.w600,
                      ),
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
