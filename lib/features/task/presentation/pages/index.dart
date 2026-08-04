import 'package:flutter/material.dart';

class TaskBoardPage extends StatefulWidget {
  const TaskBoardPage({super.key});

  @override
  State<TaskBoardPage> createState() => _TaskBoardPageState();
}

class _TaskBoardPageState extends State<TaskBoardPage> {
  int _selectedStatusFilter = 0; // 0: All, 1: Pending, 2: Completed
  int _selectedTypeFilter = 0; // 0: All, 1: Call, 2: Meeting, etc.

  final List<_TaskData> _tasks = const [
    _TaskData(
      title: 'Send policy renewal documents via email',
      clientName: 'Customer · Priya Mehta',
      isCustomer: true,
      tagType: 'Email',
      tagTypeColor: Color(0xFF0284C7),
      tagTypeBg: Color(0xFFE0F2FE),
      typeIcon: Icons.email_outlined,
      dateText: 'Yesterday',
      isOverdue: true,
      priorityColor: Colors.red,
      isHighPriorityBorder: true,
    ),
    _TaskData(
      title: 'Follow-up call regarding life insurance quote',
      clientName: 'Lead · Rajesh Sharma',
      isCustomer: false,
      tagType: 'Call',
      tagTypeColor: Color(0xFF7C3AED),
      tagTypeBg: Color(0xFFF3E8FF),
      typeIcon: Icons.phone_outlined,
      dateText: 'Today',
      isOverdue: true,
      priorityColor: Colors.red,
      isHighPriorityBorder: true,
    ),
    _TaskData(
      title: 'Onboarding meeting for new business policy',
      clientName: 'Lead · Neha Kapoor',
      isCustomer: false,
      tagType: 'Meeting',
      tagTypeColor: Color(0xFFD97706),
      tagTypeBg: Color(0xFFFEF3C7),
      typeIcon: Icons.people_outline,
      dateText: 'Jul 26',
      isOverdue: false,
      priorityColor: Colors.red,
    ),
    _TaskData(
      title: 'Schedule annual review meeting for portfolio',
      clientName: 'Customer · Arjun Patel',
      isCustomer: true,
      tagType: 'Meeting',
      tagTypeColor: Color(0xFFD97706),
      tagTypeBg: Color(0xFFFEF3C7),
      typeIcon: Icons.people_outline,
      dateText: 'Tomorrow',
      isOverdue: false,
      priorityColor: Colors.orange,
    ),
    _TaskData(
      title: 'Discuss health insurance upgrade options',
      clientName: 'Lead · Sunita Verma',
      isCustomer: false,
      tagType: 'Call',
      tagTypeColor: Color(0xFF7C3AED),
      tagTypeBg: Color(0xFFF3E8FF),
      typeIcon: Icons.phone_outlined,
      dateText: 'Jul 25',
      isOverdue: false,
      priorityColor: Colors.orange,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F6FB),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Task Board',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF1E3A8A), size: 28),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // 1. Top Summary Cards Header Adapter
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
              child: _SummaryCardsRow(),
            ),
          ),

          // 2. Filter Pills Section Adapter
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: _FilterSection(
                selectedStatus: _selectedStatusFilter,
                selectedType: _selectedTypeFilter,
                onStatusChanged: (index) =>
                    setState(() => _selectedStatusFilter = index),
                onTypeChanged: (index) =>
                    setState(() => _selectedTypeFilter = index),
              ),
            ),
          ),

          // 3. Task Cards SliverList
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return _TaskCardListTile(task: _tasks[index]);
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}

// Data Model Helper
class _TaskData {
  final String title;
  final String clientName;
  final bool isCustomer;
  final String tagType;
  final Color tagTypeColor;
  final Color tagTypeBg;
  final IconData typeIcon;
  final String dateText;
  final bool isOverdue;
  final Color priorityColor;
  final bool isHighPriorityBorder;

  const _TaskData({
    required this.title,
    required this.clientName,
    required this.isCustomer,
    required this.tagType,
    required this.tagTypeColor,
    required this.tagTypeBg,
    required this.typeIcon,
    required this.dateText,
    required this.isOverdue,
    required this.priorityColor,
    this.isHighPriorityBorder = false,
  });
}

// ==========================================
// 1. Task Card Refactored with ListTile
// ==========================================
class _TaskCardListTile extends StatefulWidget {
  final _TaskData task;

  const _TaskCardListTile({required this.task});

  @override
  State<_TaskCardListTile> createState() => _TaskCardListTileState();
}

class _TaskCardListTileState extends State<_TaskCardListTile> {
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
        // Leading Checkbox
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
        // Priority Dot + Title
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 6, right: 8),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: task.priorityColor,
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F172A),
                  decoration: isChecked
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
        // Client Badge + Tag Rows
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer / Lead Chip
              Container(
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      task.isCustomer
                          ? Icons.person_outline
                          : Icons.people_outline,
                      size: 14,
                      color: task.isCustomer
                          ? const Color(0xFF0284C7)
                          : const Color(0xFF4F46E5),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      task.clientName,
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
              const SizedBox(height: 10),

              // Bottom Tags (Type, Due Date, Status)
              Row(
                children: [
                  // Type Tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: task.tagTypeBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(task.typeIcon, size: 12, color: task.tagTypeColor),
                        const SizedBox(width: 4),
                        Text(
                          task.tagType,
                          style: TextStyle(
                            fontSize: 11,
                            color: task.tagTypeColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Due Date Tag
                  Row(
                    children: [
                      Icon(
                        task.isOverdue
                            ? Icons.warning_amber_rounded
                            : Icons.calendar_today_outlined,
                        size: 12,
                        color: task.isOverdue
                            ? const Color(0xFFDC2626)
                            : Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        task.dateText,
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
                    ],
                  ),

                  const Spacer(),

                  // Pending Status Tag
                  Container(
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 2. Summary Header Cards
// ==========================================
class _SummaryCardsRow extends StatelessWidget {
  const _SummaryCardsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _SummaryCard(
            count: '8',
            label: 'Pending',
            countColor: Color(0xFFD97706),
            bgColor: Color(0xFFFEF3C7),
            icon: Icons.hourglass_bottom_rounded,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _SummaryCard(
            count: '2',
            label: 'Completed',
            countColor: Color(0xFF16A34A),
            bgColor: Color(0xFFDCFCE7),
            icon: Icons.check_circle_outline,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _SummaryCard(
            count: '2',
            label: 'Overdue',
            countColor: Color(0xFFDC2626),
            bgColor: Color(0xFFFEE2E2),
            icon: Icons.warning_amber_rounded,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String count;
  final String label;
  final Color countColor;
  final Color bgColor;
  final IconData icon;

  const _SummaryCard({
    required this.count,
    required this.label,
    required this.countColor,
    required this.bgColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bgColor, width: 1.5),
      ),
      child: Row(
        children: [
          Icon(icon, color: countColor, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                count,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: countColor,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: countColor.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 3. Filter Pills Section
// ==========================================
class _FilterSection extends StatelessWidget {
  final int selectedStatus;
  final int selectedType;
  final ValueChanged<int> onStatusChanged;
  final ValueChanged<int> onTypeChanged;

  const _FilterSection({
    required this.selectedStatus,
    required this.selectedType,
    required this.onStatusChanged,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final statusList = ['All', 'Pending', 'Completed'];
    final typeList = ['All', 'Call', 'Meeting', 'Email'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Row(
            children: List.generate(statusList.length, (index) {
              final isSelected = selectedStatus == index;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(statusList[index]),
                  selected: isSelected,
                  onSelected: (_) => onStatusChanged(index),
                  selectedColor: const Color(0xFF1E3A8A),
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFF1E3A8A)
                          : Colors.grey.shade300,
                    ),
                  ),
                  showCheckmark: false,
                ),
              );
            }),
          ),
          const SizedBox(width: 8),
          Container(height: 24, width: 1, color: Colors.grey.shade300),
          const SizedBox(width: 12),
          Row(
            children: List.generate(typeList.length, (index) {
              final isSelected = selectedType == index;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(typeList[index]),
                  selected: isSelected,
                  onSelected: (_) => onTypeChanged(index),
                  selectedColor: const Color(0xFF7C3AED),
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFF7C3AED)
                          : Colors.grey.shade300,
                    ),
                  ),
                  showCheckmark: false,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
