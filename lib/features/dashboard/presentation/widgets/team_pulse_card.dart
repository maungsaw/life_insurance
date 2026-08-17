import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors, PrototypeRole;
import 'package:life_insurance/features/dashboard/presentation/models/team_mock_data.dart';

/// Home overlay for coach+ roles (docs/71 · FR-02.3).
class TeamPulseCard extends StatefulWidget {
  const TeamPulseCard({super.key, required this.onOpenTeam});

  final VoidCallback onOpenTeam;

  @override
  State<TeamPulseCard> createState() => _TeamPulseCardState();
}

class _TeamPulseCardState extends State<TeamPulseCard> {
  @override
  Widget build(BuildContext context) {
    final snap = TeamMockData.current;
    final scope = TeamMockData.scope;
    final showTotal = PrototypeRole.hasIndirect;

    return Material(
      color: AppColors.surface(context),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: widget.onOpenTeam,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.lightPrimary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.groups_outlined,
                      color: AppColors.lightPrimary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Team performance',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.onSurface(context),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          snap.pulseSubtitle(scope),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.onSurfaceSecondary(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'See team >',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.lightPrimary,
                    ),
                  ),
                ],
              ),
              if (showTotal) ...[
                const SizedBox(height: 10),
                _ScopeChips(
                  scope: scope,
                  onChanged: (next) {
                    setState(() => TeamMockData.scope = next);
                  },
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _MiniKpi(label: 'APE', pct: snap.apePct),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MiniKpi(label: 'FYP', pct: snap.fypPct),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MiniKpi(label: 'SFYP', pct: snap.sfypPct),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MiniKpi(label: 'Wtd FYP', pct: snap.wtdPct),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Actual vs target · display only',
                style: TextStyle(fontSize: 11, color: AppColors.hint(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScopeChips extends StatelessWidget {
  const _ScopeChips({required this.scope, required this.onChanged});

  final TeamScope scope;
  final ValueChanged<TeamScope> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _chip(context, 'Personal Team', scope == TeamScope.personal, () {
          onChanged(TeamScope.personal);
        }),
        const SizedBox(width: 8),
        _chip(context, 'Total Group', scope == TeamScope.total, () {
          onChanged(TeamScope.total);
        }),
      ],
    );
  }

  Widget _chip(BuildContext context, String label, bool on, VoidCallback tap) {
    return ChoiceChip(
      label: Text(label),
      selected: on,
      onSelected: (_) => tap(),
      selectedColor: AppColors.lightPrimary.withValues(alpha: 0.18),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: on ? AppColors.lightPrimary : AppColors.onSurfaceSecondary(context),
      ),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class _MiniKpi extends StatelessWidget {
  const _MiniKpi({required this.label, required this.pct});

  final String label;
  final String pct;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.background(context),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            pct,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.lightPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: AppColors.onSurfaceSecondary(context),
            ),
          ),
        ],
      ),
    );
  }
}
