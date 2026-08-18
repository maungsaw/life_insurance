import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_insurance/core/themes/app_colors.dart';
import 'package:life_insurance/core/themes/app_theme.dart';
import 'package:life_insurance/features/product/presentation/pages/search.dart';

void main() {
  testWidgets('Search AppBar is a 64px bar with an inset pill', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const ProductSearchPage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Search products'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);

    final bar = tester.widget<AppBar>(find.byType(AppBar));
    expect(bar.toolbarHeight, 64);
    expect(bar.leadingWidth, 64);
    expect(bar.backgroundColor, AppColors.lightSurface);
    expect(bar.backgroundColor, isNot(AppColors.lightPrimary));
    expect(tester.takeException(), isNull);
  });
}
