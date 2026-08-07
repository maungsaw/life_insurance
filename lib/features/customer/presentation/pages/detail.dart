import 'package:flutter/material.dart'
    show
        ListTile,
        BorderRadius,
        StatelessWidget,
        Widget,
        BuildContext,
        Color,
        Icon,
        Text,
        EdgeInsets,
        SizedBox,
        TextStyle,
        IconData,
        Colors,
        Icons,
        Navigator,
        IconButton,
        FontWeight,
        AppBar,
        NetworkImage,
        CircleAvatar,
        BoxDecoration,
        Container,
        MainAxisAlignment,
        Row,
        Column,
        Padding,
        CrossAxisAlignment,
        SingleChildScrollView,
        Scaffold,
        Border,
        Expanded,
        Theme;
import 'package:life_insurance/features/customer/domain/domain.dart';

class CustomerDetailPage extends StatelessWidget {
  final CustomerEntity customer;

  const CustomerDetailPage({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    // Theme colors extracted from your list screen
    final primaryBlue = Theme.of(context).primaryColor;
    final badgeBgColor = Theme.of(context).primaryColorLight;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Customer Details',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Profile Card
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: NetworkImage(customer.avatarUrl),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    customer.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    customer.email,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  Text(
                    customer.phone,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 12),
                  // Policy Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: badgeBgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${customer.policyCount} ${customer.policyCount > 1 ? "policies" : "policy"}',
                      style: TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Quick Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        Icons.phone_outlined,
                        'Call',
                        primaryBlue,
                      ),
                      _buildActionButton(
                        Icons.email_outlined,
                        'Email',
                        primaryBlue,
                      ),
                      _buildActionButton(
                        Icons.chat_bubble_outline,
                        'Message',
                        primaryBlue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Key Metrics Summary
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _buildStatCard(
                    'Active Policies',
                    '${customer.policyCount}',
                    Colors.blue,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard('Total Premium', '\$4,250/yr', Colors.green),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Detailed Sections List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Active Policies',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildPolicyTile(
                    title: 'Auto Insurance - Health & Shield',
                    policyNumber: 'POL-992031',
                    status: 'Active',
                    renewalDate: 'Oct 24, 2026',
                  ),
                  _buildPolicyTile(
                    title: 'Home & Property Insurance',
                    policyNumber: 'POL-441029',
                    status: 'Active',
                    renewalDate: 'Jan 15, 2027',
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'Recent Activity',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildActivityTile(
                    icon: Icons.support_agent,
                    title: 'Policy Renewal Reminder Sent',
                    subtitle: 'Yesterday at 4:30 PM',
                  ),
                  _buildActivityTile(
                    icon: Icons.payment,
                    title: 'Premium Payment Received (\$350)',
                    subtitle: 'Aug 01, 2026',
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Components ---

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color accentColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyTile({
    required String title,
    required String policyNumber,
    required String status,
    required String renewalDate,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            'ID: $policyNumber • Renews: $renewalDate',
            style: const TextStyle(fontSize: 12),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            status,
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey[700], size: 22),
        title: Text(
          title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11)),
        dense: true,
      ),
    );
  }
}
