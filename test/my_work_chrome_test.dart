import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_insurance/core/themes/app_colors.dart';
import 'package:life_insurance/core/themes/app_theme.dart';
import 'package:life_insurance/features/task/presentation/pages/index.dart';

void main() {
  testWidgets('My work puts date beside the title and uses 12-hour times', (
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
        home: const TaskBoardPage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('My work'), findsOneWidget);
    expect(find.text('14-Aug-2026'), findsOneWidget);
    expect(find.text('Fri, 14 Aug 2026'), findsNothing);
    expect(find.text('Create'), findsOneWidget);
    expect(find.text('01:00 PM'), findsWidgets);
    expect(find.text('09:00 AM'), findsWidgets);
    expect(find.text('13:00'), findsNothing);

    final card = tester.widget<Material>(
      find.widgetWithText(Material, 'Meeting appointment').first,
    );
    expect(card.color, AppColors.darkSurface);
    expect(tester.takeException(), isNull);
  });
}
