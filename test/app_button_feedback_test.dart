import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_insurance/core/themes/app_theme.dart';
import 'package:life_insurance/features/components/app_button.dart';

void main() {
  testWidgets('AppButton variants accept long-press without sticky errors', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Column(
            children: [
              AppButton(label: 'Primary', onPressed: () {}),
              AppButton(
                label: 'Secondary',
                variant: AppButtonVariant.secondary,
                onPressed: () {},
              ),
              AppButton(
                label: 'Text',
                variant: AppButtonVariant.text,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.longPress(find.text('Primary'));
    await tester.pump();
    await tester.longPress(find.text('Secondary'));
    await tester.pump();
    await tester.longPress(find.text('Text'));
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
