import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_insurance/core/themes/app_theme.dart';
import 'package:life_insurance/features/components/app_select_chip.dart';
import 'package:life_insurance/features/dashboard/presentation/pages/team_mdrt_page.dart';
import 'package:life_insurance/features/dashboard/presentation/widgets/team_visuals.dart';
import 'package:life_insurance/features/product/presentation/widgets/product_widgets.dart';

void main() {
  testWidgets('selected chip uses an inset corner dot, not a check', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: QuoteTypeChip(
            label: 'Saving',
            selected: true,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.byType(ChoiceChip), findsNothing);
    expect(find.byIcon(Icons.check), findsNothing);
    expect(find.text('Saving'), findsOneWidget);

    final dot = tester.widget<Positioned>(find.byType(Positioned));
    expect(dot.top, 5);
    expect(dot.right, 5);
    expect(dot.top, isNot(-4));
  });

  testWidgets('MDRT filters share AppSelectChip and the ring shows a percent', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const TeamMdrtPage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('MDRT Tracker'), findsOneWidget);
    expect(find.byType(ChoiceChip), findsNothing);
    expect(find.byType(AppSelectChip), findsWidgets);
    expect(find.text('Qualified'), findsWidgets);
    expect(find.byIcon(Icons.check), findsNothing);

    final ring = tester.widget<TeamRing>(find.byType(TeamRing));
    expect(ring.size, 128);
    expect(find.byType(CustomPaint), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('TeamRing paints a rounded percent label', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: Center(child: TeamRing(value: 2 / 6, size: 128)),
        ),
      ),
    );

    expect(find.text('33%'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('filter chips sit on one Wrap row, not a stacked list', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 360,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final label in [
                    'All',
                    'New',
                    'Contacted',
                    'Quoted',
                    'Applied',
                  ])
                    AppSelectChip(
                      label: label,
                      selected: label == 'All',
                      onTap: () {},
                      outlinedWhenIdle: true,
                      fontSize: 12,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    final chips = find.byType(AppSelectChip);
    expect(chips, findsNWidgets(5));
    final firstY = tester.getTopLeft(chips.at(0)).dy;
    expect(tester.getTopLeft(chips.at(1)).dy, firstY);
    expect(tester.getTopLeft(chips.at(2)).dy, firstY);
    expect(
      tester.getTopLeft(chips.at(4)).dy - firstY,
      lessThan(56),
    );
    expect(tester.takeException(), isNull);
  });
}
