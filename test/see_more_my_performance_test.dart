import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_insurance/core/prototype/prototype_role.dart';
import 'package:life_insurance/core/themes/app_theme.dart';
import 'package:life_insurance/features/dashboard/presentation/pages/team_hub_page.dart';
import 'package:life_insurance/features/dashboard/presentation/widgets/team_pulse_card.dart';
import 'package:life_insurance/features/dashboard/presentation/widgets/team_visuals.dart';

void main() {
  testWidgets('Team pulse says See more, not See team', (tester) async {
    PrototypeRole.set(PrototypeRoleId.teamLead);
    addTearDown(PrototypeRole.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: TeamPulseCard(onOpenTeam: () {}),
        ),
      ),
    );

    expect(find.text('See more'), findsOneWidget);
    expect(find.text('See team >'), findsNothing);
    expect(find.text('Team performance'), findsOneWidget);
  });

  testWidgets('My performance sheet uses the FA-detail breakdown', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    PrototypeRole.set(PrototypeRoleId.teamLead);
    addTearDown(PrototypeRole.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const TeamHubPage(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('My performance'));
    await tester.pumpAndSettle();

    expect(find.text('Your personal figures — not the team roll-up.'), findsOneWidget);
    expect(find.text('Performance breakdown'), findsOneWidget);
    expect(find.text('Achievement'), findsOneWidget);
    expect(find.text('8.4M / 11.8M'), findsOneWidget);
    expect(find.text('Weighted Freelance FYP'), findsOneWidget);
    expect(find.text('Road to MDRT'), findsWidgets);
    expect(find.byType(TeamRing), findsWidgets);
    expect(find.byType(TeamKpiBar), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
