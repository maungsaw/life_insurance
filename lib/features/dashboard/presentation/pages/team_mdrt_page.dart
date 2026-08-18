import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors, AppRoute;
import 'package:life_insurance/features/components/components.dart'
    show AppSelectChip;
import 'package:life_insurance/features/dashboard/presentation/models/team_mock_data.dart';
import 'package:life_insurance/features/dashboard/presentation/widgets/team_member_tile.dart';
import 'package:life_insurance/features/dashboard/presentation/widgets/team_visuals.dart';

class TeamMdrtPage extends StatefulWidget {
  const TeamMdrtPage({super.key});

  @override
  State<TeamMdrtPage> createState() => _TeamMdrtPageState();
}

class _TeamMdrtPageState extends State<TeamMdrtPage> {
  MdrtLane _lane = MdrtLane.all;

  @override
  Widget build(BuildContext context) {
    final all = TeamMockData.current.members;
    final rows = TeamMockData.mdrtLane(_lane);
    final qualified = all.where((m) => m.qualified).length;
    final inProgress =
        all.where((m) => m.badgeKind == TeamBadgeKind.inProgress).length;
    final notYet = all.where((m) => m.isNotYet).length;
    final ring = all.isEmpty ? 0.0 : qualified / all.length;

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'MDRT Tracker',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.background(context),
        foregroundColor: AppColors.onSurface(context),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface(context),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  TeamRing(value: ring, size: 128),
                  const SizedBox(height: 8),
                  Text(
                    '$qualified / ${all.length} FAs Qualified',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.onSurfaceSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _chip('All', MdrtLane.all),
                const SizedBox(width: 8),
                _chip('Qualified', MdrtLane.qualified),
                const SizedBox(width: 8),
                _chip('In Progress', MdrtLane.inProgress),
                const SizedBox(width: 8),
                _chip('Not Yet', MdrtLane.notYet),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: TeamCountChip(
                    value: '$qualified',
                    label: 'Qualified',
                    icon: Icons.emoji_events_outlined,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TeamCountChip(
                    value: '$inProgress',
                    label: 'In Progress',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TeamCountChip(
                    value: '$notYet',
                    label: 'Not Yet',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              itemCount: rows.length + 1,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                if (i == rows.length) {
                  return Material(
                    color: AppColors.lightPrimary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      onTap: () =>
                          setState(() => _lane = MdrtLane.inProgress),
                      borderRadius: BorderRadius.circular(14),
                      child: const Padding(
                        padding: EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Icon(
                              Icons.emoji_events_outlined,
                              color: AppColors.lightPrimary,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Drive More MDRT! Help your team reach qualification.',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.lightPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                final m = rows[i];
                return TeamMemberTile(
                  member: m,
                  onTap: () => context.push(AppRoute.teamFa, extra: m.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, MdrtLane lane) {
    return AppSelectChip(
      label: label,
      selected: _lane == lane,
      onTap: () => setState(() => _lane = lane),
      outlinedWhenIdle: true,
    );
  }
}
