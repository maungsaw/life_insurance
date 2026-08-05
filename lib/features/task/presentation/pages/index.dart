import 'package:flutter/material.dart'
    show
        StatefulWidget,
        State,
        BuildContext,
        Container,
        Color,
        CustomScrollView,
        BouncingScrollPhysics,
        AlwaysScrollableScrollPhysics,
        SliverAppBar,
        Text,
        IconButton,
        Icon,
        SliverToBoxAdapter,
        Padding,
        EdgeInsets,
        SliverPadding,
        SliverList,
        TextStyle,
        Widget,
        SizedBox,
        FontWeight,
        Icons,
        SliverChildBuilderDelegate;
import '../../domain/domain.dart' show TaskEntities;

import '../widgets/widgets.dart' show FilterView, SummaryView;
import 'item.dart';

class TaskBoardPage extends StatefulWidget {
  const TaskBoardPage({super.key});

  @override
  State<TaskBoardPage> createState() => _TaskBoardViewState();
}

class _TaskBoardViewState extends State<TaskBoardPage> {
  int _selectedStatusFilter = 0; // 0: All, 1: Pending, 2: Completed
  int _selectedTypeFilter = 0; // 0: All, 1: Call, 2: Meeting, etc.

  final List<TaskEntities> _tasks = const [
    TaskEntities(
      title: 'Send policy renewal documents via email',
      clientName: 'Customer · Priya Mehta',
      isCustomer: true,
      tagType: 'Email',
      dateText: 'Yesterday',
      isOverdue: true,
      isHighPriorityBorder: true,
    ),
    TaskEntities(
      title: 'Follow-up call regarding life insurance quote',
      clientName: 'Lead · Rajesh Sharma',
      isCustomer: false,
      tagType: 'Call',
      dateText: 'Today',
      isOverdue: true,
      isHighPriorityBorder: true,
    ),
    TaskEntities(
      title: 'Onboarding meeting for new business policy',
      clientName: 'Lead · Neha Kapoor',
      isCustomer: false,
      tagType: 'Meeting',
      dateText: 'Jul 26',
      isOverdue: false,
    ),
    TaskEntities(
      title: 'Schedule annual review meeting for portfolio',
      clientName: 'Customer · Arjun Patel',
      isCustomer: true,
      tagType: 'Meeting',
      dateText: 'Tomorrow',
      isOverdue: false,
    ),
    TaskEntities(
      title: 'Discuss health insurance upgrade options',
      clientName: 'Lead · Sunita Verma',
      isCustomer: false,
      tagType: 'Call',
      dateText: 'Jul 25',
      isOverdue: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8FAFC),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // 1. Floating & Snapping SliverAppBar for smooth hide/show behavior
          SliverAppBar(
            backgroundColor: const Color(0xFFF4F6FB),
            elevation: 0,
            floating: true,
            snap: true,
            pinned: false,
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

          // 2. Summary Cards Header Adapter
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0),
              child: SummaryView(),
            ),
          ),

          // 3. Filter Pills Section Adapter
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: FilterView(
                selectedStatus: _selectedStatusFilter,
                selectedType: _selectedTypeFilter,
                onStatusChanged: (index) =>
                    setState(() => _selectedStatusFilter = index),
                onTypeChanged: (index) =>
                    setState(() => _selectedTypeFilter = index),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((
                BuildContext context,
                int index,
              ) {
                return TaskItemView(task: _tasks[index]);
              }, childCount: _tasks.length),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
