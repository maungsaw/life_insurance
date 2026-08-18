import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_insurance/core/themes/app_colors.dart';
import 'package:life_insurance/core/themes/app_theme.dart';
import 'package:life_insurance/features/components/bottom_nav.dart';
import 'package:life_insurance/features/product/presentation/models/product_mock_data.dart';
import 'package:life_insurance/features/product/presentation/pages/compare.dart';
import 'package:life_insurance/features/product/presentation/widgets/product_widgets.dart';

void main() {
  test('dark cards sit above the page, not below it', () {
    expect(
      AppColors.darkSurface.computeLuminance(),
      greaterThan(AppColors.darkBackground.computeLuminance()),
    );
    expect(AppColors.darkPrimary, AppColors.lightPrimary);
  });

  testWidgets('dark mode page paint is charcoal, not white', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: Builder(
          builder: (context) {
            return Scaffold(
              backgroundColor: AppColors.background(context),
              appBar: AppBar(
                backgroundColor: AppColors.surface(context),
                title: Text(
                  'Theme',
                  style: TextStyle(color: AppColors.onSurface(context)),
                ),
              ),
              body: Text(
                'Body',
                style: TextStyle(color: AppColors.onSurface(context)),
              ),
            );
          },
        ),
      ),
    );

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, AppColors.darkBackground);
    expect(scaffold.backgroundColor, isNot(Colors.white));

    final body = tester.widget<Text>(find.text('Body'));
    expect(body.style?.color, AppColors.darkTextPrimary);
    expect(body.style?.color, isNot(AppColors.lightTextPrimary));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Quote type chips stay charcoal in dark, not white slabs', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: Scaffold(
          body: Wrap(
            children: [
              QuoteTypeChip(label: 'Saving', selected: true, onTap: () {}),
              QuoteTypeChip(label: 'Travel', selected: false, onTap: () {}),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Saving'), findsOneWidget);
    expect(find.text('Travel'), findsOneWidget);

    Material materialOf(String label) {
      return tester.widget<Material>(
        find
            .descendant(
              of: find.widgetWithText(QuoteTypeChip, label),
              matching: find.byType(Material),
            )
            .first,
      );
    }

    expect(materialOf('Saving').color, const Color(0xFF2A2A2A));
    expect(materialOf('Travel').color, const Color(0xFF2A2A2A));
    expect(materialOf('Travel').color, isNot(const Color(0xFFF1F5F9)));
    expect(materialOf('Saving').color, isNot(Colors.white));
    expect(tester.takeException(), isNull);
  });

  testWidgets('dark bottom nav inactive tabs are not near-black', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: Scaffold(
          backgroundColor: AppColors.darkBackground,
          bottomNavigationBar: AppBottomNavBar(
            selectedIndex: 0,
            onTap: (_) {},
            onFabPressed: () {},
          ),
        ),
      ),
    );

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Customer'), findsOneWidget);

    final home = tester.widget<Text>(find.text('Home'));
    final customer = tester.widget<Text>(find.text('Customer'));
    expect(home.style?.color, AppColors.lightPrimary);
    expect(customer.style?.color, const Color(0xFFC8C8C8));
    expect(customer.style?.color, isNot(const Color(0xFF2D2D2D)));
    expect(tester.takeException(), isNull);
  });

  testWidgets('dark pill nav paints without a stacked halo exception', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: Scaffold(
          backgroundColor: AppColors.darkBackground,
          bottomNavigationBar: AppBottomNavBar(
            selectedIndex: 1,
            onTap: (_) {},
            onFabPressed: () {},
          ),
        ),
      ),
    );

    expect(find.byType(CustomPaint), findsWidgets);
    expect(find.text('Customer'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Compare table body text is not white-on-white in dark', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final products = ProductMockData.products;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: ProductComparePage(left: products[0], right: products[1]),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Compare Details'), findsOneWidget);
    expect(find.text('Policy Term'), findsOneWidget);
    expect(find.text('Line'), findsOneWidget);

    final feature = tester.widget<Text>(find.text('Policy Term'));
    expect(feature.style?.color, AppColors.darkTextPrimary);
    expect(tester.takeException(), isNull);
  });
}
