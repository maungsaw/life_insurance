class TaskEntities {
  final String title;
  final String clientName;
  final bool isCustomer;
  final String tagType;
  final String dateText;
  final bool isOverdue;
  final bool isHighPriorityBorder;

  const TaskEntities({
    required this.title,
    required this.clientName,
    required this.isCustomer,
    required this.tagType,
    required this.dateText,
    required this.isOverdue,
    this.isHighPriorityBorder = false,
  });
}
