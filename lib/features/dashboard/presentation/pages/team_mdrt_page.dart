import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors, AppRoute;
import 'package:life_insurance/features/dashboard/presentation/models/team_mock_data.dart';
import 'package:life_insurance/features/dashboard/presentation/widgets/team_member_tile.dart';

class TeamMdrtPage extends StatefulWidget {
  const TeamMdrtPage({super.key});

  @override
  State<TeamMdrtPage> createState() => _TeamMdrtPageState();
}

class _TeamMdrtPageState extends State<TeamMdrtPage> {
  MdrtLane _lane = MdrtLane.all;

  @override
  Widget build(BuildContext context) {
    final rows = TeamMockData.mdrtLane(_lane);
    final all = TeamMockData.current.members;
    final qualified = all.where((m) => m.qualified).length;
    final ring = all.isEmpty ? 0.0 : qualified / all.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Road to MDRT',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color(0xFFF8FAFC),
        foregroundColor: AppColors.lightTextPrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: 88,
                    height: 88,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: ring,
                          strokeWidth: 8,
                          color: AppColors.lightPrimary,
                          backgroundColor:
                              AppColors.lightPrimary.withValues(alpha: 0.12),
                        ),
                        Text(
                          '${(ring * 100).round()}%',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$qualified of ${all.length} qualified',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _chip('All', MdrtLane.all),
                const SizedBox(width: 8),
                _chip('Qualified', MdrtLane.qualified),
                const SizedBox(width: 8),
                _chip('In progress', MdrtLane.inProgress),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              itemCount: rows.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
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
    final on = _lane == lane;
    return ChoiceChip(
      label: Text(label),
      selected: on,
      onSelected: (_) => setState(() => _lane = lane),
      selectedColor: AppColors.lightPrimary.withValues(alpha: 0.18),
    );
  }
}
