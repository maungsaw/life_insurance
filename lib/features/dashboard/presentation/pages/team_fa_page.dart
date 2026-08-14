import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors;
import 'package:life_insurance/features/components/components.dart'
    show AppStatusDialog, AppStatusType;
import 'package:life_insurance/features/dashboard/presentation/models/team_mock_data.dart';

/// One FA — read-only performance, not their login (docs/71).
class TeamFaPage extends StatelessWidget {
  const TeamFaPage({super.key, required this.memberId});

  final String memberId;

  @override
  Widget build(BuildContext context) {
    final member = TeamMockData.memberById(memberId);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          member?.name ?? 'Agent',
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color(0xFFF8FAFC),
        foregroundColor: AppColors.lightTextPrimary,
      ),
      body: member == null
          ? const Center(child: Text('Agent not found'))
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor:
                          AppColors.lightPrimary.withValues(alpha: 0.15),
                      child: Text(
                        member.initials,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.lightPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            '${member.roleLabel} · ${member.code}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Individual performance · not their login',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.lightTextHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (member.belowTarget) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Below monthly FYP target',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFB45309),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                _row('APE', member.ape),
                _row('FYP', member.fyp),
                _row('Subsequent FYP', member.sfyp),
                _row('Weighted Freelance FYP', member.wtdFyp),
                _row('MoM', member.momDelta),
                const SizedBox(height: 18),
                const Text(
                  'Road to MDRT',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: member.mdrtPct.clamp(0.0, 1.0),
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.lightPrimary,
                  backgroundColor: AppColors.lightPrimary.withValues(alpha: 0.12),
                ),
                const SizedBox(height: 6),
                Text(
                  '${(member.mdrtPct * 100).round()}% · ${member.mdrtLabel}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () => AppStatusDialog.show(
                      context,
                      type: AppStatusType.info,
                      title: 'Assign task',
                      message: 'Coaching task stub — prototype, no API.',
                      actionLabel: 'OK',
                    ),
                    icon: const Icon(Icons.task_alt_outlined),
                    label: const Text('Assign task'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.lightPrimary,
                      side: const BorderSide(color: AppColors.lightPrimary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _row(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.lightTextSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
