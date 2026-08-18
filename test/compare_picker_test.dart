import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_insurance/core/themes/app_theme.dart';
import 'package:life_insurance/features/product/presentation/models/product_mock_data.dart';
import 'package:life_insurance/features/product/presentation/pages/compare.dart';

CatalogProduct _p(String id) =>
    ProductMockData.products.firstWhere((p) => p.id == id);

Widget _app(Widget home) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    home: home,
  );
}

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  test('default peer prefers the same product line', () {
    expect(defaultComparePeer(_p('ste')).id, 'ul');
    expect(defaultComparePeer(_p('ul')).id, 'ste');
    expect(defaultComparePeer(_p('pa')).id, 'cl');
  });

  testWidgets('Change replaces the tapped column with another On product', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _app(ProductComparePage(left: _p('ste'), right: _p('ul'))),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('compare-head-right')));
    await tester.pumpAndSettle();

    expect(find.text('Replace Universal Life'), findsOneWidget);
    await tester.tap(find.text('Personal Accident'));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byKey(const Key('compare-head-left')),
        matching: find.text('Short Term Endowment'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('compare-head-right')),
        matching: find.text('Personal Accident'),
      ),
      findsOneWidget,
    );
    expect(find.text('Use Personal'), findsOneWidget);
    expect(find.text('PA'), findsOneWidget);
  });

  testWidgets('picking the other column swaps and keeps pin on the same SKU', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _app(ProductComparePage(left: _p('ste'), right: _p('ul'))),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pinned'), findsOneWidget);
    expect(find.text('Pin'), findsOneWidget);

    await tester.tap(find.byKey(const Key('compare-head-left')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Universal Life'));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byKey(const Key('compare-head-left')),
        matching: find.text('Universal Life'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('compare-head-right')),
        matching: find.text('Short Term Endowment'),
      ),
      findsOneWidget,
    );
    expect(find.text('Use Universal'), findsOneWidget);
    expect(find.text('Use Short'), findsOneWidget);
  });

  testWidgets('sheet search filters by name and code', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _app(ProductComparePage(left: _p('ste'), right: _p('ul'))),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('compare-head-right')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'health');
    await tester.pumpAndSettle();

    expect(find.text('Family Health'), findsOneWidget);
    expect(find.text('Credit Life'), findsNothing);
  });
}
