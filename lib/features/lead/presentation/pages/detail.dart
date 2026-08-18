import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;
import 'package:life_insurance/features/lead/domain/domain.dart'
    show LeadEntity;
import 'package:life_insurance/features/components/components.dart'
    show AppButton, AppButtonVariant;
import 'package:life_insurance/features/product/presentation/widgets/eapp_launch.dart';

/// Field CRM card — stage + convert live on web (`101`).
class LeadDetailPage extends StatelessWidget {
  const LeadDetailPage({super.key, required this.lead});

  final LeadEntity lead;

  Color _statusBg(BuildContext context) {
    switch (lead.status) {
      case 'New':
        return const Color(0xFFE3F2FD);
      case 'Contacted':
        return const Color(0xFFFFF8E1);
      case 'Quoted':
        return const Color(0xFFF3E8FF);
      case 'Applied':
        return const Color(0xE8E8F5E9);
      default:
        return AppColors.mutedFill(context);
    }
  }

  Color _statusFg() {
    switch (lead.status) {
      case 'New':
        return const Color(0xFF1976D2);
      case 'Contacted':
        return const Color(0xFFF57F17);
      case 'Quoted':
        return const Color(0xFF7C3AED);
      case 'Applied':
        return const Color(0xFF388E3C);
      default:
        return AppColors.lightPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: AppColors.surface(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.onSurface(context),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Lead Details',
          style: TextStyle(
            color: AppColors.onSurface(context),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit_outlined,
              color: AppColors.onSurface(context),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: AppColors.surface(context),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: lead.avatarColor,
                    child: Text(
                      lead.initials,
                      style: TextStyle(
                        color: AppColors.onPrimary,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    lead.name,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lead.email,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.onSurfaceSecondary(context),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _statusBg(context),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      lead.status,
                      style: TextStyle(
                        color: _statusFg(),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(context, Icons.phone_outlined, 'Call'),
                      _buildActionButton(context, Icons.email_outlined, 'Email'),
                      _buildActionButton(
                        context,
                        Icons.chat_bubble_outline,
                        'Message',
                      ),
                      _buildActionButton(
                        context,
                        Icons.calendar_today_outlined,
                        'Schedule',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Get a quote',
                      variant: AppButtonVariant.secondary,
                      fontSize: 14,
                      onPressed: () => EappLaunch.startQuoteForParty(
                        context,
                        EappLaunch.partyFromLead(lead),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppButton(
                      label: 'Start e-App',
                      fontSize: 14,
                      onPressed: () => EappLaunch.startEappForParty(
                        context,
                        EappLaunch.partyFromLead(lead),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border(context)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Lead Information',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      context,
                      Icons.source,
                      'Lead Source',
                      'Website Form',
                    ),
                    _buildInfoRow(
                      context,
                      Icons.access_time,
                      'Added',
                      lead.timeAgo,
                    ),
                    _buildInfoRow(
                      context,
                      Icons.monetization_on_outlined,
                      'Estimated Value',
                      '\$2,500',
                    ),
                    _buildInfoRow(
                      context,
                      Icons.person_outline,
                      'Assigned Agent',
                      'You',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notes & Timeline',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface(context),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border(context)),
                    ),
                    child: Text(
                      'Interested in comprehensive auto insurance plans. Requested a call back around 3 PM.',
                      style: TextStyle(
                        color: AppColors.onSurface(context),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
  ) {
    return Column(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.primarySoftTint(context),
          child: Icon(icon, color: AppColors.lightPrimary, size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.onSurfaceSecondary(context)),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.onSurfaceSecondary(context),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 2,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
