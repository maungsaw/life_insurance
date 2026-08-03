import 'package:flutter/material.dart';

class LeadsScreen extends StatefulWidget {
  const LeadsScreen({super.key});

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['All', 'New', 'Contacted', 'Qualified'];

  // Sample lead data
  final List<Map<String, dynamic>> _leads = const [
    {
      'initials': 'MC',
      'name': 'Michael Clark',
      'email': 'michael@gmail.com',
      'status': 'New',
      'time': '2m ago',
      'avatarBg': Color(0xFF7C3AED),
    },
    {
      'initials': 'SP',
      'name': 'Sarah Parker',
      'email': 'sarahparker@gmail.com',
      'status': 'Contacted',
      'time': '1h ago',
      'avatarBg': Color(0xFF0EA5E9),
    },
    {
      'initials': 'DW',
      'name': 'David Wilson',
      'email': 'davidwilson@gmail.com',
      'status': 'New',
      'time': '3h ago',
      'avatarBg': Color(0xFFD97706),
    },
    {
      'initials': 'JL',
      'name': 'Jessica Lee',
      'email': 'jessicalee@gmail.com',
      'status': 'Qualified',
      'time': '5h ago',
      'avatarBg': Color(0xFF16A34A),
    },
    {
      'initials': 'RP',
      'name': 'Richard Price',
      'email': 'richardprice@gmail.com',
      'status': 'Contacted',
      'time': '1d ago',
      'avatarBg': Color(0xFFDC2626),
    },
    {
      'initials': 'AN',
      'name': 'Amara Nwosu',
      'email': 'amara.nwosu@gmail.com',
      'status': 'New',
      'time': '1d ago',
      'avatarBg': Color(0xFF1E3A8A),
    },
    {
      'initials': 'KP',
      'name': 'Kenji Patel',
      'email': 'kenji.patel@gmail.com',
      'status': 'Qualified',
      'time': '2d ago',
      'avatarBg': Color(0xFF0D9488),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F6FB),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Leads',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF1E293B), size: 24),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.filter_list,
              color: Color(0xFF1E293B),
              size: 24,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // 1. Top Tabs Row
          _TopTabBar(
            tabs: _tabs,
            selectedIndex: _selectedTabIndex,
            onTabSelected: (index) => setState(() => _selectedTabIndex = index),
          ),

          // 2. Leads List
          Expanded(
            child: ListView.separated(
              itemCount: _leads.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
              itemBuilder: (context, index) {
                final lead = _leads[index];
                return _LeadListTile(lead: lead);
              },
            ),
          ),
        ],
      ),

      // 3. Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF1E3A8A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}

// ==========================================
// 1. Top Tab Bar
// ==========================================
class _TopTabBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const _TopTabBar({
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(tabs.length, (index) {
          final isSelected = selectedIndex == index;
          return InkWell(
            onTap: () => onTabSelected(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected
                        ? const Color(0xFF1E3A8A)
                        : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
              child: Text(
                tabs[index],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? const Color(0xFF1E3A8A)
                      : Colors.grey.shade600,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ==========================================
// 2. Individual Lead Item Tile
// ==========================================
class _LeadListTile extends StatelessWidget {
  final Map<String, dynamic> lead;

  const _LeadListTile({required this.lead});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        color: const Color(0xFFF4F6FB),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            // Avatar Circle
            CircleAvatar(
              radius: 24,
              backgroundColor: lead['avatarBg'] as Color,
              child: Text(
                lead['initials'] as String,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Lead Info (Name, Email, Status Pill)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lead['name'] as String,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lead['email'] as String,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  _StatusBadge(status: lead['status'] as String),
                ],
              ),
            ),

            // Time & Arrow Icon
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  lead['time'] as String,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 12),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// Helper Widget: Dynamic Status Badge
// ==========================================
class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color bgColor;
    Color borderColor;

    switch (status) {
      case 'New':
        textColor = const Color(0xFF1E3A8A);
        bgColor = const Color(0xFFDBEAFE);
        borderColor = const Color(0xFFBFDBFE);
        break;
      case 'Contacted':
        textColor = const Color(0xFFD97706);
        bgColor = const Color(0xFFFEF3C7);
        borderColor = const Color(0xFFFDE68A);
        break;
      case 'Qualified':
        textColor = const Color(0xFF16A34A);
        bgColor = const Color(0xFFDCFCE7);
        borderColor = const Color(0xFFBBF7D0);
        break;
      default:
        textColor = Colors.grey;
        bgColor = Colors.grey.shade100;
        borderColor = Colors.grey.shade300;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
