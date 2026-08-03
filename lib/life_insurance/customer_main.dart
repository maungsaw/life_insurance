import 'package:flutter/material.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  // Sample customer data matching the UI screenshot
  final List<Map<String, dynamic>> _customers = const [
    {
      'name': 'Jane Cooper',
      'email': 'janecooper@gmail.com',
      'phone': '+1 202-555-0145',
      'policiesCount': 3,
      'imageUrl':
          'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150',
    },
    {
      'name': 'Robert Fox',
      'email': 'robertfox@gmail.com',
      'phone': '+1 202-555-0187',
      'policiesCount': 2,
      'imageUrl':
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
    },
    {
      'name': 'Esther Howard',
      'email': 'estherhoward@gmail.com',
      'phone': '+1 202-555-0124',
      'policiesCount': 1,
      'imageUrl':
          'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=150',
    },
    {
      'name': 'Cody Fisher',
      'email': 'codyfisher@gmail.com',
      'phone': '+1 202-555-0108',
      'policiesCount': 4,
      'imageUrl':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
    },
    {
      'name': 'Brooklyn Simmons',
      'email': 'brooklyns@gmail.com',
      'phone': '+1 202-555-0173',
      'policiesCount': 2,
      'imageUrl':
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150',
    },
    {
      'name': 'Amara Okafor',
      'email': 'amara.okafor@gmail.com',
      'phone': '+1 202-555-0199',
      'policiesCount': 1,
      'imageUrl':
          'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=150',
    },
    {
      'name': 'Marcus Tanaka',
      'email': 'marcus.tanaka@gmail.com',
      'phone': '+1 202-555-0212',
      'policiesCount': 3,
      'imageUrl':
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
    },
    {
      'name': 'Priya Sharma',
      'email': 'priya.sharma@gmail.com',
      'phone': '+1 202-555-0234',
      'policiesCount': 2,
      'imageUrl':
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150',
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
          'Customers',
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
      body: ListView.separated(
        itemCount: _customers.length,
        separatorBuilder: (context, index) =>
            Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
        itemBuilder: (context, index) {
          final customer = _customers[index];
          return _CustomerListTile(customer: customer);
        },
      ),
    );
  }
}

// ==========================================
// 1. Customer List Tile Widget
// ==========================================
class _CustomerListTile extends StatelessWidget {
  final Map<String, dynamic> customer;

  const _CustomerListTile({required this.customer});

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final int count = customer['policiesCount'] as int;
    final String policyText = count == 1 ? '1 policy' : '$count policies';

    return InkWell(
      onTap: () {},
      child: Container(
        color: const Color(0xFFF4F6FB),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Avatar Image with Fallback Initials
            CircleAvatar(
              radius: 26,
              backgroundColor: const Color(0xFF1E3A8A),
              child: ClipOval(
                child: Image.network(
                  customer['imageUrl'] as String,
                  width: 52,
                  height: 52,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Text(
                        _getInitials(customer['name'] as String),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Customer Information Block
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer['name'] as String,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    customer['email'] as String,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: 13,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        customer['phone'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Policy Count Badge & Arrow
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0EAFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    policyText,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
