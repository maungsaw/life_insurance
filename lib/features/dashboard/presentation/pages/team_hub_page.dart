import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart'
    show AppColors, AppRoute, PrototypeRole;
import 'package:life_insurance/features/components/components.dart'
    show AppSelectChip;
import 'package:life_insurance/features/dashboard/presentation/models/home_mock_data.dart';
import 'package:life_insurance/features/dashboard/presentation/models/team_mock_data.dart';
import 'package:life_insurance/features/dashboard/presentation/widgets/team_visuals.dart';

/// Team Sales Performance hub (docs/72 · mockup 1).
class TeamHubPage extends StatefulWidget {
  const TeamHubPage({super.key});

  @override
  State<TeamHubPage> createState() => _TeamHubPageState();
}

class _TeamHubPageState extends State<TeamHubPage> {
  void _setScope(TeamScope next) {
    setState(() => TeamMockData.scope = next);
  }

  void _openMyPerformance() {
    final snap = TeamMockData.current;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.background(context),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              8,
              20,
              20 + MediaQuery.viewInsetsOf(ctx).bottom,
            ),
            child: SizedBox(
              height: MediaQuery.sizeOf(ctx).height * 0.88,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'My performance',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your personal figures — not the team roll-up.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.onSurfaceSecondary(context),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: [
                        TeamOwnPerformanceBody(snap: snap),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final snap = TeamMockData.current;
    final scope = TeamMockData.scope;
    final showTotal = PrototypeRole.hasIndirect;
    final effective = (!showTotal) ? TeamScope.personal : scope;
    final momUp = snap.momDelta.startsWith('+');

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Team Sales Performance',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.background(context),
        foregroundColor: AppColors.onSurface(context),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.lightPrimary.withValues(alpha: 0.15),
                child: Text(
                  HomeMockData.agentName.isEmpty
                      ? 'A'
                      : HomeMockData.agentName[0],
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.lightPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      HomeMockData.agentName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      PrototypeRole.teamRoleLine,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.onSurfaceSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surface(context),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  snap.periodLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: _openMyPerformance,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.lightPrimary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'My performance',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.lightPrimary,
                      ),
                    ),
                  ),
                  Text(
                    '${(snap.ownOverallPct * 100).round()}% · FYP ${snap.ownFyp}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.onSurfaceSecondary(context),
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, size: 18),
                ],
              ),
            ),
          ),
          if (showTotal) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: AppSelectChip(
                    label: 'Personal Team',
                    selected: effective == TeamScope.personal,
                    onTap: () => _setScope(TeamScope.personal),
                    expand: true,
                    outlinedWhenIdle: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppSelectChip(
                    label: 'Total Group',
                    selected: effective == TeamScope.total,
                    onTap: () => _setScope(TeamScope.total),
                    expand: true,
                    outlinedWhenIdle: true,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface(context),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                TeamRing(value: snap.overallPct, label: '${(snap.overallPct * 100).round()}%'),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overall',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.onSurfaceSecondary(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Actual  ${snap.overallActual}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Target  ${snap.overallTarget}',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.onSurfaceSecondary(context),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${snap.momDelta} vs last month',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: momUp
                              ? AppColors.successGreen
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
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Team hierarchy',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (showTotal) {
                    context.push(AppRoute.teamGroup);
                  } else {
                    context.push(AppRoute.teamMembers);
                  }
                },
                child: const Text('View org chart'),
              ),
            ],
          ),
          Row(
            children: [
              if (snap.showSam)
                Expanded(
                  child: TeamCountChip(
                    value: '${snap.samCount}',
                    label: 'SAMs',
                    caption: 'Direct',
                  ),
                ),
              if (snap.showSam) const SizedBox(width: 8),
              if (snap.showAm)
                Expanded(
                  child: TeamCountChip(
                    value: '${snap.amCount}',
                    label: 'AMs',
                    caption: snap.showSam ? 'Direct + indirect' : 'Direct',
                  ),
                ),
              if (snap.showAm) const SizedBox(width: 8),
              Expanded(
                child: TeamCountChip(
                  value: '${snap.faCount}',
                  label: 'FAs',
                  caption: showTotal && effective == TeamScope.total
                      ? 'Direct + indirect'
                      : 'Direct',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TeamCountChip(
                  value: '${snap.mdrtQualified}',
                  label: 'MDRT',
                  caption: 'Qualified',
                  icon: Icons.emoji_events_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Key performance',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TeamKpiBar(
                  label: 'APE',
                  actual: snap.apeActual,
                  target: snap.apeTarget,
                  pct: snap.apePct,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TeamKpiBar(
                  label: 'FYP',
                  actual: snap.fypActual,
                  target: snap.fypTarget,
                  pct: snap.fypPct,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TeamKpiBar(
                  label: 'Subsequent FYP',
                  actual: snap.sfypActual,
                  target: snap.sfypTarget,
                  pct: snap.sfypPct,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TeamKpiBar(
                  label: 'Weighted FYP',
                  actual: snap.wtdActual,
                  target: snap.wtdTarget,
                  pct: snap.wtdPct,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Weighting is applied by Core. This app displays the result.',
            style: TextStyle(fontSize: 11, color: AppColors.hint(context)),
          ),
          const SizedBox(height: 16),
          _Shortcut(
            icon: Icons.groups_outlined,
            title: effective == TeamScope.total && showTotal
                ? 'Total Group'
                : 'Direct reports (FAs)',
            subtitle: effective == TeamScope.total && showTotal
                ? 'SAM / AM lines · drill down'
                : 'Sorted by achievement',
            onTap: () {
              if (effective == TeamScope.total && showTotal) {
                context.push(AppRoute.teamGroup);
              } else {
                context.push(AppRoute.teamMembers);
              }
            },
          ),
          const SizedBox(height: 10),
          _Shortcut(
            icon: Icons.emoji_events_outlined,
            title: 'MDRT Tracker',
            subtitle: 'All · Qualified · In Progress · Not Yet',
            onTap: () => context.push(AppRoute.teamMdrt),
          ),
        ],
      ),
    );
  }
}

class _Shortcut extends StatelessWidget {
  const _Shortcut({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface(context),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.lightPrimary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.lightPrimary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.onSurfaceSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.hint(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
