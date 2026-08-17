import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;
import 'package:life_insurance/features/lead/domain/domain.dart'
    show LeadEntity;
import 'package:life_insurance/features/components/components.dart'
    show AppStatusDialog, AppStatusType;
import 'package:life_insurance/features/customer/presentation/models/customer_hub_session.dart';
import 'package:life_insurance/features/product/presentation/widgets/eapp_launch.dart';

class LeadDetailPage extends StatefulWidget {
  final LeadEntity lead;

  const LeadDetailPage({super.key, required this.lead});

  @override
  State<LeadDetailPage> createState() => _LeadDetailPageState();
}

class _LeadDetailPageState extends State<LeadDetailPage> {
  late String _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.lead.status;
  }

  // Color helper based on status badge from design
  Color _getStatusBgColor(String status) {
    switch (status) {
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

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'New':
        return const Color(0xFF1976D2);
      case 'Contacted':
        return const Color(0xFFF57F17);
      case 'Quoted':
        return const Color(0xFF7C3AED);
      case 'Applied':
        return const Color(0xFF388E3C);
      default:
        return AppColors.onSurface(context);
    }
  }

  Future<void> _submitCondition() async {
    final confirmed = await AppStatusDialog.show(
      context,
      type: AppStatusType.warning,
      title: 'Submit condition?',
      message:
          'This creates a Pending policy and moves ${widget.lead.name} from Leads to Clients.',
      actionLabel: 'SUBMIT',
      secondaryLabel: 'CANCEL',
    );
    if (confirmed != true || !mounted) return;
    CustomerHubSession.convertLead(widget.lead);
    Navigator.pop(context, true);
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
            // --- Header Profile Section ---
            Container(
              color: AppColors.surface(context),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: widget.lead.avatarColor,
                    child: Text(
                      widget.lead.initials,
                      style: TextStyle(
                        color: AppColors.onPrimary,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.lead.name,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.lead.email,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.onSurfaceSecondary(context),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Dynamic Status Tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusBgColor(_currentStatus),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _currentStatus,
                      style: TextStyle(
                        color: _getStatusTextColor(_currentStatus),
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
                      _buildActionButton(Icons.phone_outlined, 'Call'),
                      _buildActionButton(Icons.email_outlined, 'Email'),
                      _buildActionButton(Icons.chat_bubble_outline, 'Message'),
                      _buildActionButton(
                        Icons.calendar_today_outlined,
                        'Schedule',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // --- Status Changer / Pipeline Stepper ---
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
                      'Update Stage',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: ['New', 'Contacted', 'Quoted', 'Applied'].map((
                        status,
                      ) {
                        final isSelected = _currentStatus == status;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _currentStatus = status;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? _getStatusTextColor(status)
                                    : AppColors.border(context),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                status,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.onSurfaceSecondary(context),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => EappLaunch.startQuoteForParty(
                        context,
                        EappLaunch.partyFromLead(widget.lead),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.lightPrimary,
                        side: BorderSide(color: AppColors.lightPrimary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Get a quote',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => EappLaunch.startEappForParty(
                        context,
                        EappLaunch.partyFromLead(widget.lead),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.lightPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Start e-App',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submitCondition,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF00A6C8),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Submit condition · Move to Clients',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // --- Details Card ---
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
                    _buildInfoRow(Icons.source, 'Lead Source', 'Website Form'),
                    _buildInfoRow(
                      Icons.access_time,
                      'Added',
                      widget.lead.timeAgo,
                    ),
                    _buildInfoRow(
                      Icons.monetization_on_outlined,
                      'Estimated Value',
                      '\$2,500',
                    ),
                    _buildInfoRow(
                      Icons.person_outline,
                      'Assigned Agent',
                      'You',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // --- Lead Notes / Log ---
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

  // Helper Widget for Quick Action Circle Buttons
  Widget _buildActionButton(IconData icon, String label) {
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
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  // Helper Widget for Info Key-Value Rows
  Widget _buildInfoRow(IconData icon, String title, String value) {
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
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
