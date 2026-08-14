import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors;
import 'package:life_insurance/features/components/components.dart'
    show AppStatusDialog, AppStatusType;
import 'package:life_insurance/features/dashboard/presentation/models/team_mock_data.dart';
import 'package:life_insurance/features/dashboard/presentation/widgets/team_visuals.dart';

/// One FA — read-only performance (docs/72 · mockup 5).
class TeamFaPage extends StatelessWidget {
  const TeamFaPage({super.key, required this.memberId});

  final String memberId;

  @override
  Widget build(BuildContext context) {
    final member = TeamMockData.memberById(memberId);
    final ringColor = member != null && member.ringValue >= 0.9
        ? AppColors.successGreen
        : AppColors.lightPrimary;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          member?.name ?? 'FA Performance Detail',
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
                          const SizedBox(height: 6),
                          TeamMdrtBadge(member: member),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Individual performance · not their login',
                  style: TextStyle(fontSize: 11, color: AppColors.lightTextHint),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      TeamRing(
                        value: member.ringValue,
                        color: ringColor,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Achievement',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.lightTextSecondary,
                              ),
                            ),
                            Text(
                              member.actualCompact.isEmpty
                                  ? member.ape
                                  : '${member.actualCompact} / ${member.targetCompact}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'MoM ${member.momDelta}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Performance breakdown',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                TeamKpiBar(
                  label: 'APE',
                  actual: member.ape,
                  target: member.apeTarget.isEmpty ? '—' : member.apeTarget,
                  pct: member.achievementLabel,
                  pctValue: member.ringValue,
                ),
                const SizedBox(height: 8),
                TeamKpiBar(
                  label: 'FYP',
                  actual: member.fyp,
                  target: member.fypTarget.isEmpty ? '—' : member.fypTarget,
                  pct: member.achievementLabel,
                  pctValue: member.ringValue,
                ),
                const SizedBox(height: 8),
                TeamKpiBar(
                  label: 'Subsequent FYP',
                  actual: member.sfyp,
                  target: member.sfypTarget.isEmpty ? '—' : member.sfypTarget,
                  pct: member.achievementLabel,
                  pctValue: member.ringValue,
                ),
                const SizedBox(height: 8),
                TeamKpiBar(
                  label: 'Weighted Freelance FYP',
                  actual: member.wtdFyp,
                  target: member.wtdTarget.isEmpty ? '—' : member.wtdTarget,
                  pct: member.achievementLabel,
                  pctValue: member.ringValue,
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: member.qualified
                        ? const Color(0xFFFFF7ED)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.qualified ? 'MDRT Qualified' : 'Road to MDRT',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: member.qualified
                              ? const Color(0xFFB45309)
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        member.mdrtOfTarget.isEmpty
                            ? '${(member.mdrtPct * 100).round()}% of target'
                            : 'Achieved ${member.mdrtOfTarget} of target',
                        style: const TextStyle(fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: member.mdrtPct.clamp(0.0, 1.0),
                          minHeight: 8,
                          color: member.qualified
                              ? AppColors.gold
                              : AppColors.lightPrimary,
                          backgroundColor:
                              AppColors.lightPrimary.withValues(alpha: 0.12),
                        ),
                      ),
                    ],
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
}
