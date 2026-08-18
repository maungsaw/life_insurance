import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_insurance/core/themes/app_theme.dart';
import 'package:life_insurance/features/product/presentation/widgets/product_pickers.dart';

void main() {
  test('weight sheet preview is decimal lb, stored label stays bare', () {
    const pick = WeightPick(whole: 105, tenth: 0);
    expect(pick.label, '105.0');
    expect(pick.sheetPreview, '105.0 lb');
  });

  testWidgets('height sheet shows preview and column headers, not ft-in', (
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
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () {
                    showHeightPickerSheet(
                      context,
                      initial: const HeightPick(feet: 5, inches: 3),
                    );
                  },
                  child: const Text('open'),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Select Your Height'), findsOneWidget);
    expect(find.text("5' 3\""), findsOneWidget);
    expect(find.text('ft'), findsOneWidget);
    expect(find.text('in'), findsOneWidget);
    expect(find.text('ft-in'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('weight sheet preview is lb, not lb-oz; Done keeps 105.0', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    WeightPick? result;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () async {
                    result = await showWeightPickerSheet(
                      context,
                      initial: const WeightPick(whole: 105, tenth: 0),
                    );
                  },
                  child: const Text('open'),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Select Your Weight'), findsOneWidget);
    expect(find.text('105.0 lb'), findsOneWidget);
    expect(find.text('lb'), findsOneWidget);
    expect(find.text('lb-oz'), findsNothing);

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(result?.label, '105.0');
    expect(tester.takeException(), isNull);
  });
}
