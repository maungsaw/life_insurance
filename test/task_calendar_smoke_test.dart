import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_insurance/features/task/presentation/pages/index.dart';

void main() {
  testWidgets('My work renders Day, Week and Month scopes', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: TaskBoardPage()));
    await tester.pumpAndSettle();
    expect(find.text('My work'), findsOneWidget);
    expect(tester.takeException(), isNull);

    for (final scope in ['Week', 'Month', 'Day']) {
      await tester.ensureVisible(find.text(scope).first);
      await tester.tap(find.text(scope).first);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: '$scope scope');
    }

    await tester.ensureVisible(find.text('Filter'));
    await tester.tap(find.text('Filter'));
    await tester.pumpAndSettle();
    expect(find.text('Filter tasks'), findsOneWidget);
  });
}
