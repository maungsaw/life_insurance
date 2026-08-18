import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_insurance/features/customer/presentation/models/customer_mock_data.dart';
import 'package:life_insurance/features/customer/presentation/pages/detail.dart';
import 'package:life_insurance/features/customer/presentation/pages/policy_list_page.dart';
import 'package:life_insurance/features/customer/presentation/pages/policy_details_page.dart';
import 'package:life_insurance/features/product/presentation/models/product_mock_data.dart';

void main() {
  test('expired and in-window policies can renew; pending cannot', () {
    final expired = CustomerMockData.policyById('23487532096712');
    expect(expired, isNotNull);
    expect(expired!.status, CrmStatus.active);
    expect(expired.expiryDate.isBefore(PolicyRenewalRules.today), isTrue);
    expect(expired.isRenewalEligible, isTrue);

    final pending = CustomerMockData.policyById('187498273099');
    expect(pending, isNotNull);
    expect(pending!.status, CrmStatus.pending);
    expect(pending.isRenewalEligible, isFalse);

    final far = CustomerMockData.allPolicies.firstWhere(
      (p) => p.expiryDate.year >= 2034,
    );
    expect(far.isRenewalEligible, isFalse);
  });

  test('startEappFromPolicy clones policy into a renewal draft', () {
    final policy = CustomerMockData.firstRenewalPolicy!;
    final draft = ProductSession.startEappFromPolicy(policy);

    expect(draft.isRenewal, isTrue);
    expect(draft.intent, EappLaunchIntent.renewal);
    expect(draft.sourcePolicyId, policy.id);
    expect(draft.quote.id, startsWith('QT-REN-'));
    expect(draft.quote.party.id, policy.clientId);
    expect(draft.policyholder.name, isNotEmpty);
    expect(ProductSession.openDraftForPolicy(policy.id), draft);

    ProductSession.applications.removeWhere((a) => a.id == draft.id);
    ProductSession.quotes.removeWhere((q) => q.id == draft.quote.id);
  });

  testWidgets('Policy Details shows Renew policy when eligible', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final policy = CustomerMockData.policyById('23487532096712')!;
    expect(policy.isRenewalEligible, isTrue);

    await tester.pumpWidget(
      MaterialApp(home: PolicyDetailsPage(policy: policy)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Policy Details'), findsOneWidget);
    expect(find.text('Renew policy'), findsOneWidget);
    expect(find.text('Buy additional policy'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Customer detail policy rows show Renew and Buy additional', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final customer = CustomerMockData.byId('c1');
    await tester.pumpWidget(
      MaterialApp(home: CustomerDetailPage(customer: customer)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Renew'), findsWidgets);
    expect(find.text('Buy additional'), findsWidgets);
    expect(find.text('Pending'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Policy list rows expose repurchase action label', (tester) async {
    tester.view.physicalSize = const Size(1440, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(home: PolicyListPage()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Buy additional'), findsWidgets);
  });
}
