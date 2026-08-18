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
    final isDark = AppColors.isDark(context);
    final ringColor = member != null && member.ringValue >= 0.9
        ? AppColors.successGreen
        : AppColors.lightPrimary;

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          member?.name ?? 'FA Performance Detail',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.background(context),
        foregroundColor: AppColors.onSurface(context),
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
                        style: TextStyle(
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
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            '${member.roleLabel} · ${member.code}',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.onSurfaceSecondary(context),
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
                Text(
                  'Individual performance · not their login',
                  style: TextStyle(fontSize: 11, color: AppColors.hint(context)),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface(context),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.border(context).withValues(
                        alpha: isDark ? 0.55 : 0.85,
                      ),
                    ),
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
                            Text(
                              'Achievement',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.onSurfaceSecondary(context),
                              ),
                            ),
                            Text(
                              member.actualCompact.isEmpty
                                  ? member.ape
                                  : '${member.actualCompact} / ${member.targetCompact}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'MoM ${member.momDelta}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: member.momDelta.startsWith('+')
                                    ? AppColors.success(context)
                                    : const Color(0xFFE11D48),
                              ),
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
                        ? const Color(0xFFFFF7ED).withValues(
                            alpha: isDark ? 0.18 : 1,
                          )
                        : AppColors.surface(context),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.border(context).withValues(
                        alpha: isDark ? 0.55 : 0.85,
                      ),
                    ),
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
                              : AppColors.onSurface(context),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        member.mdrtOfTarget.isEmpty
                            ? '${(member.mdrtPct * 100).round()}% of target'
                            : 'Achieved ${member.mdrtOfTarget} of target',
                        style: TextStyle(fontSize: 13),
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
                      side: BorderSide(color: AppColors.lightPrimary),
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
