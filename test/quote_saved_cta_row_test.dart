import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_insurance/core/themes/app_theme.dart';
import 'package:life_insurance/features/components/app_button.dart';
import 'package:life_insurance/features/product/presentation/models/product_mock_data.dart';
import 'package:life_insurance/features/product/presentation/pages/quote_saved.dart';

void main() {
  testWidgets('Quote saved puts Start e-App and View saved quotes on one row', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final quote = SavedQuote(
      id: 'QT-2026-0001',
      productId: 'ste',
      productName: 'Short Term Endowment',
      productCode: 'STE',
      lineLabel: 'Saving',
      variant: '5 years',
      frequency: 'Monthly',
      sumInsured: '10,000,000.00',
      monthlyPremium: '16,667.00',
      topup: '0.00',
      term: '5 years',
      dob: DateTime(1999, 6, 4),
      age: 27,
      party: const QuoteParty(
        id: 'c-1',
        name: 'May Chan Myae',
        kind: QuotePartyKind.client,
      ),
      savedAt: DateTime(2026, 8, 14),
      totalAmount: '16,967.00',
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: ProductQuoteSavedPage(quote: quote),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Quote saved'), findsOneWidget);
    expect(find.text('QT-2026-0001'), findsOneWidget);
    expect(find.text('Start e-App'), findsOneWidget);
    expect(find.text('View saved quotes'), findsOneWidget);
    expect(find.text('Back to Products'), findsNothing);

    final row = tester.widget<Row>(
      find.ancestor(
        of: find.widgetWithText(AppButton, 'Start e-App'),
        matching: find.byType(Row),
      ).first,
    );
    expect(row.children.whereType<Expanded>().length, 2);
    for (final e in row.children.whereType<Expanded>()) {
      expect(e.flex, 1);
    }
    final viewBox = tester.getRect(find.widgetWithText(AppButton, 'View saved quotes'));
    final startBox = tester.getRect(find.widgetWithText(AppButton, 'Start e-App'));
    expect(viewBox.width, startBox.width);
    expect(find.byType(AppButton), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });
}
