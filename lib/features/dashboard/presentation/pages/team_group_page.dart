import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart'
    show AppColors, AppRoute, PrototypeRole;
import 'package:life_insurance/features/dashboard/presentation/models/home_mock_data.dart';
import 'package:life_insurance/features/dashboard/presentation/models/team_mock_data.dart';
import 'package:life_insurance/features/dashboard/presentation/widgets/team_visuals.dart';

class TeamGroupPage extends StatelessWidget {
  const TeamGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final snap = TeamMockData.current;
    final lines = snap.groupLines;
    final crumb = '${PrototypeRole.chipLabel} ${HomeMockData.agentName}';

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Total Group',
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
          Text(
            crumb,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.onSurfaceSecondary(context),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface(context),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                TeamRing(value: snap.overallPct, size: 72),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${snap.overallActual} / ${snap.overallTarget}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${(snap.overallPct * 100).round()}% · ${snap.pulseSubtitle(TeamScope.total)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.onSurfaceSecondary(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          for (final line in lines) ...[
            _LineTile(
              line: line,
              onTap: () => context.push(
                AppRoute.teamMembers,
                extra: TeamLineArgs(
                  lineId: line.id,
                  title: '${line.roleLabel} · ${line.region}'.trim(),
                  breadcrumb: '$crumb · ${line.name}',
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface(context),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Team Trend',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
                SizedBox(height: 6),
                Text(
                  'Feb–Aug · chart in a later pass. Figures follow the period chip on the hub.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: AppColors.onSurfaceSecondary(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LineTile extends StatelessWidget {
  const _LineTile({required this.line, required this.onTap});

  final TeamLine line;
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
          padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          line.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          [
                            line.roleLabel,
                            if (line.region.isNotEmpty) line.region,
                            '${line.faCount} FAs',
                          ].join(' · '),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.onSurfaceSecondary(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    line.fypPct,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.lightPrimary,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.hint(context),
                  ),
                ],
              ),
              if (line.actual.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  '${line.actual} / ${line.target}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.onSurfaceSecondary(context),
                  ),
                ),
              ],
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: line.barValue.clamp(0.0, 1.0),
                  minHeight: 6,
                  color: AppColors.lightPrimary,
                  backgroundColor:
                      AppColors.lightPrimary.withValues(alpha: 0.12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
