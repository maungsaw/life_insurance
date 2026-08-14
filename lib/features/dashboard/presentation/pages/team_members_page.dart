import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors, AppRoute;
import 'package:life_insurance/features/dashboard/presentation/models/team_mock_data.dart';
import 'package:life_insurance/features/dashboard/presentation/widgets/team_member_tile.dart';

class TeamMembersPage extends StatelessWidget {
  const TeamMembersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final members = TeamMockData.current.members;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Team members',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
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
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
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
    );
  }
}
