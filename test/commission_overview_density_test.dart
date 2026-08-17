import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_insurance/features/profile/presentation/models/commission_mock_data.dart';
import 'package:life_insurance/features/profile/presentation/models/commission_overview_layout.dart';
import 'package:life_insurance/features/profile/presentation/pages/commission_history_page.dart';
import 'package:life_insurance/features/profile/presentation/widgets/commission_overview_chart.dart';

List<CommissionLineStat> _stats(List<double> amounts) {
  return [
    for (var i = 0; i < amounts.length; i++)
      CommissionLineStat(
        line: CommissionLine.values[i % CommissionLine.values.length],
        amount: amounts[i],
        count: i + 1,
      ),
  ];
}

void main() {
  test('modeFor follows 85 thresholds', () {
    expect(CommissionOverviewLayout.modeFor(0), CommissionOverviewMode.empty);
    expect(CommissionOverviewLayout.modeFor(1), CommissionOverviewMode.single);
    expect(CommissionOverviewLayout.modeFor(2), CommissionOverviewMode.few);
    expect(CommissionOverviewLayout.modeFor(4), CommissionOverviewMode.few);
    expect(CommissionOverviewLayout.modeFor(5), CommissionOverviewMode.scroll);
    expect(CommissionOverviewLayout.modeFor(7), CommissionOverviewMode.scroll);
    expect(CommissionOverviewLayout.modeFor(8), CommissionOverviewMode.list);
  });

  test('live All period stays PNG four-up', () {
    final plan = CommissionOverviewLayout.plan(
      CommissionMockData.reportLines(CommissionPeriodFilter.all),
    );
    expect(plan.mode, CommissionOverviewMode.few);
    expect(plan.slices.map((s) => s.label).toList(), [
      'Health',
      'Travel',
      'Protection',
      'Saving',
    ]);
    expect(plan.slices.first.amount, 236500);
  });

  test('n=1 is a single row, not a lonely bar', () {
    final plan = CommissionOverviewLayout.plan(_stats([99000]));
    expect(plan.mode, CommissionOverviewMode.single);
    expect(plan.slices, hasLength(1));
  });

  test('few catalog keeps zero columns; crowded drops zeros', () {
    final four = [
      CommissionLineStat(line: CommissionLine.health, amount: 10, count: 1),
      CommissionLineStat(line: CommissionLine.travel, amount: 0, count: 0),
      CommissionLineStat(line: CommissionLine.protection, amount: 8, count: 1),
      CommissionLineStat(line: CommissionLine.saving, amount: 0, count: 0),
    ];
    final padded = CommissionOverviewLayout.plan(four);
    expect(padded.mode, CommissionOverviewMode.few);
    expect(padded.slices, hasLength(4));
    expect(padded.slices.where((s) => s.amount <= 0), hasLength(2));

    final crowded = [
      ...four,
      CommissionLineStat(line: CommissionLine.health, amount: 0, count: 0),
    ];
    final dropped = CommissionOverviewLayout.plan(crowded);
    expect(dropped.mode, CommissionOverviewMode.few);
    expect(dropped.slices, hasLength(2));
    expect(dropped.slices.every((s) => s.amount > 0), isTrue);
  });

  test('8+ ranks as a list; 11 buckets Others', () {
    final eight = CommissionOverviewLayout.plan(
      _stats([80, 70, 60, 50, 40, 30, 20, 10]),
    );
    expect(eight.mode, CommissionOverviewMode.list);
    expect(eight.slices, hasLength(8));
    expect(eight.slices.any((s) => s.isOthers), isFalse);

    final eleven = CommissionOverviewLayout.plan(
      _stats([11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1]),
    );
    expect(eleven.mode, CommissionOverviewMode.list);
    expect(eleven.slices, hasLength(11));
    expect(eleven.slices.last.isOthers, isTrue);
    expect(eleven.slices.last.othersCategoryCount, 1);
    expect(eleven.slices.last.amount, 1);
    expect(eleven.slices.last.count, 11);
  });

  testWidgets('Report All uses equal-width bars', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: CommissionHistoryPage()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Report').first);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('commission-overview-few')), findsOneWidget);
    expect(find.byKey(const Key('commission-overview-scroll')), findsNothing);
    expect(find.byKey(const Key('commission-overview-list')), findsNothing);
  });

  testWidgets('5 categories scroll instead of shrinking', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final plan = CommissionOverviewLayout.plan(
      _stats([50, 40, 30, 20, 10]),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: CommissionOverviewChart(plan: plan)),
      ),
    );

    expect(plan.mode, CommissionOverviewMode.scroll);
    expect(find.byKey(const Key('commission-overview-scroll')), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key('commission-overview-scroll')),
        matching: find.byType(SingleChildScrollView),
      ),
      findsOneWidget,
    );
  });

  testWidgets('8 categories render ranked list with Others at 11', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final plan = CommissionOverviewLayout.plan(
      _stats([11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1]),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: CommissionOverviewChart(plan: plan),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('commission-overview-list')), findsOneWidget);
    expect(find.text('Others'), findsOneWidget);
    expect(find.textContaining('1 more categories'), findsOneWidget);
  });
}
