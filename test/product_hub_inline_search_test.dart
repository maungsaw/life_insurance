import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_insurance/core/themes/app_theme.dart';
import 'package:life_insurance/features/home/presentation/pages/product_hub.dart';

void main() {
  testWidgets('Product tab searches inline without opening a new page', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const ProductHubPage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Product'), findsOneWidget);
    expect(find.text('Search products'), findsNothing);

    await tester.tap(find.byTooltip('Search'));
    await tester.pumpAndSettle();

    expect(find.byType(ProductHubPage), findsOneWidget);
    expect(find.text('Search products'), findsOneWidget);
    expect(find.text('Product'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Universal');
    await tester.pumpAndSettle();

    expect(find.text('Universal Life'), findsOneWidget);
    expect(find.text('Credit Life'), findsNothing);

    await tester.tap(find.byTooltip('Close search'));
    await tester.pumpAndSettle();

    expect(find.text('Product'), findsOneWidget);
    expect(find.text('Search products'), findsNothing);
    expect(find.text('All'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
