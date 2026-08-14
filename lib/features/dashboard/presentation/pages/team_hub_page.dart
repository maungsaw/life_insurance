import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors, AppRoute, PrototypeRole;
import 'package:life_insurance/features/dashboard/presentation/models/team_mock_data.dart';

/// Freelance Management hub — Personal Team / Total Group (docs/71 · FR-02.3).
class TeamHubPage extends StatefulWidget {
  const TeamHubPage({super.key});

  @override
  State<TeamHubPage> createState() => _TeamHubPageState();
}

class _TeamHubPageState extends State<TeamHubPage> {
  void _setScope(TeamScope next) {
    setState(() => TeamMockData.scope = next);
  }

  @override
  Widget build(BuildContext context) {
    final snap = TeamMockData.current;
    final scope = TeamMockData.scope;
    final showTotal = PrototypeRole.hasIndirect;
    final effective = (!showTotal) ? TeamScope.personal : scope;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Team performance',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color(0xFFF8FAFC),
        foregroundColor: AppColors.lightTextPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Text(
            snap.pulseSubtitle(effective),
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.lightTextSecondary,
            ),
          ),
          if (showTotal) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _Seg(
                    label: 'Personal Team',
                    selected: effective == TeamScope.personal,
                    onTap: () => _setScope(TeamScope.personal),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _Seg(
                    label: 'Total Group',
                    selected: effective == TeamScope.total,
                    onTap: () => _setScope(TeamScope.total),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          const Text(
            'Actual vs target',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 10),
          _MetricTile(
            label: 'APE',
            actual: snap.apeActual,
            target: snap.apeTarget,
            pct: snap.apePct,
          ),
          _MetricTile(
            label: 'FYP',
            actual: snap.fypActual,
            target: snap.fypTarget,
            pct: snap.fypPct,
          ),
          _MetricTile(
            label: 'Subsequent FYP',
            actual: snap.sfypActual,
            target: snap.sfypTarget,
            pct: snap.sfypPct,
          ),
          _MetricTile(
            label: 'Weighted Freelance FYP',
            actual: snap.wtdActual,
            target: snap.wtdTarget,
            pct: snap.wtdPct,
          ),
          const SizedBox(height: 6),
          const Text(
            'Weighting is applied by Core. This app displays the result.',
            style: TextStyle(fontSize: 11, color: AppColors.lightTextHint),
          ),
          const SizedBox(height: 20),
          _Shortcut(
            icon: Icons.people_outline_rounded,
            title: effective == TeamScope.total && showTotal
                ? 'Group hierarchy'
                : 'Team members',
            subtitle: effective == TeamScope.total && showTotal
                ? 'SAM / AM lines + counts'
                : 'Direct reports · open an FA',
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
            title: 'Road to MDRT',
            subtitle: 'All · Qualified · In progress',
            onTap: () => context.push(AppRoute.teamMdrt),
          ),
        ],
      ),
    );
  }
}

class _Seg extends StatelessWidget {
  const _Seg({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.lightPrimary : Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : AppColors.lightTextPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.actual,
    required this.target,
    required this.pct,
  });

  final String label;
  final String actual;
  final String target;
  final String pct;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$actual MMK',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
                Text(
                  'Target $target',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.lightTextHint,
                  ),
                ),
              ],
            ),
          ),
          Text(
            pct,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.lightPrimary,
            ),
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
      color: Colors.white,
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
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.lightTextHint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
