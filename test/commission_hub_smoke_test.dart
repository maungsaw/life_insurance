import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_insurance/features/profile/presentation/models/commission_mock_data.dart';
import 'package:life_insurance/features/profile/presentation/pages/commission_history_page.dart';

void main() {
  test('ledger total matches Home / History / Report source', () {
    expect(CommissionMockData.total, 726080);
    expect(CommissionMockData.totalLabel, '726,080.00 MMK');
    final lines = CommissionMockData.reportLines(CommissionPeriodFilter.all);
    final sum = lines.fold<double>(0, (s, e) => s + e.amount);
    expect(sum, CommissionMockData.total);
  });

  testWidgets('Commission hub shows History and Report', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: CommissionHistoryPage()));
    await tester.pumpAndSettle();

    expect(find.text('History'), findsWidgets);
    expect(find.text('Report'), findsOneWidget);
    expect(find.text('Universal Life · May Chan Myae'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);

    await tester.tap(find.text('Report').first);
    await tester.pumpAndSettle();

    expect(find.text('Commission Report'), findsOneWidget);
    expect(find.text('Top performing category'), findsOneWidget);
    expect(find.text('Commission Overview'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
