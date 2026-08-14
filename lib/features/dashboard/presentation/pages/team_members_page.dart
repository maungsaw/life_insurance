import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors, AppRoute;
import 'package:life_insurance/features/dashboard/presentation/models/team_mock_data.dart';
import 'package:life_insurance/features/dashboard/presentation/widgets/team_member_tile.dart';
import 'package:life_insurance/features/dashboard/presentation/widgets/team_visuals.dart';

/// Direct reports / line FA list (docs/72 · mockup 3).
class TeamMembersPage extends StatelessWidget {
  const TeamMembersPage({super.key, this.args = const TeamLineArgs()});

  final TeamLineArgs args;

  @override
  Widget build(BuildContext context) {
    final snap = TeamMockData.current;
    final line = args.lineId == null ? null : TeamMockData.lineById(args.lineId!);
    final members = TeamMockData.membersForLine(args.lineId);
    final title = args.title ?? line?.name ?? 'Direct reports (FAs)';
    final ring = line?.barValue ?? snap.overallPct;
    final faCount = line?.faCount ?? members.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color(0xFFF8FAFC),
        foregroundColor: AppColors.lightTextPrimary,
      ),
      body: members.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'Team view appears when you have a downline.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.lightTextSecondary),
                ),
              ),
            )
          : Column(
              children: [
                if (args.breadcrumb != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        args.breadcrumb!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        TeamRing(value: ring, size: 72),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$faCount FAs',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              if (line != null)
                                Text(
                                  '${line.actual} / ${line.target}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.lightTextSecondary,
                                  ),
                                ),
                              const Text(
                                'Sorted by achievement',
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
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 88),
                    itemCount: members.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final m = members[i];
                      return TeamMemberTile(
                        member: m,
                        onTap: () => context.push(AppRoute.teamFa, extra: m.id),
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: members.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: SizedBox(
                  height: 48,
                  child: FilledButton(
                    onPressed: () =>
                        context.push(AppRoute.teamFa, extra: members.first.id),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.lightPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('View FA Performance Trend'),
                  ),
                ),
              ),
            ),
    );
  }
}
