import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_insurance/features/components/app_button.dart';
import 'package:life_insurance/features/customer/presentation/models/customer_hub_session.dart';
import 'package:life_insurance/features/customer/presentation/models/customer_mock_data.dart';
import 'package:life_insurance/features/customer/presentation/pages/index.dart';
import 'package:life_insurance/features/lead/data/repository/repository.dart';
import 'package:life_insurance/features/lead/domain/entities/lead.dart';
import 'package:life_insurance/features/lead/presentation/pages/detail.dart';

void main() {
  test('condition submit moves a Lead to Clients with a Pending policy', () {
    const lead = LeadEntity(
      id: 'conversion-test',
      name: 'Conversion Test',
      email: 'conversion@test.com',
      phone: '09 700 000 000',
      status: 'Applied',
      timeAgo: 'now',
      avatarColor: Colors.blue,
    );
    leadsData.add(lead);

    final client = CustomerHubSession.convertLead(lead);

    expect(leadsData.any((item) => item.id == lead.id), isFalse);
    expect(client.policies.single.status, CrmStatus.pending);
    expect(CustomerHubSession.selectedTab.value, 1);

    CustomerMockData.customers.removeWhere(
      (customer) => customer.id == client.id,
    );
  });

  testWidgets('Customer hub separates Leads and Clients', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    CustomerHubSession.openClients();

    await tester.pumpWidget(const MaterialApp(home: CustomersPage()));
    await tester.pumpAndSettle();

    expect(find.textContaining('Leads ·'), findsOneWidget);
    expect(find.textContaining('Clients ·'), findsOneWidget);
    expect(find.text('Search clients..'), findsOneWidget);
    expect(find.text('Active'), findsWidgets);

    await tester.tap(find.textContaining('Leads ·'));
    await tester.pumpAndSettle();

    expect(find.text('Search leads..'), findsOneWidget);
    expect(find.text('New'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Lead detail sells quote/e-App and does not convert or set stage', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(home: LeadDetailPage(lead: leadsData.first)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Michael Clark'), findsOneWidget);
    expect(find.text('New'), findsOneWidget);
    expect(find.text('Update Stage'), findsNothing);
    expect(find.text('Contacted'), findsNothing);
    expect(find.text('Quoted'), findsNothing);
    expect(find.text('Applied'), findsNothing);
    expect(find.text('Submit condition · Move to Clients'), findsNothing);
    expect(find.text('Get a quote'), findsOneWidget);
    expect(find.text('Start e-App'), findsOneWidget);
    expect(find.text('Call'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Schedule'), findsOneWidget);
    expect(find.text('Message'), findsNothing);

    final quoteBox = tester.getRect(find.widgetWithText(AppButton, 'Get a quote'));
    final eappBox = tester.getRect(find.widgetWithText(AppButton, 'Start e-App'));
    expect(quoteBox.width, eappBox.width);
    expect(tester.takeException(), isNull);
  });
}
