import 'package:flutter/foundation.dart';
import 'package:life_insurance/features/customer/presentation/models/customer_mock_data.dart';
import 'package:life_insurance/features/lead/data/repository/repository.dart';
import 'package:life_insurance/features/lead/domain/entities/lead.dart';

/// In-memory CRM hub coordination for the prototype (docs/79).
abstract final class CustomerHubSession {
  /// 0 = Leads, 1 = Clients. Clients is the default servicing view.
  static final ValueNotifier<int> selectedTab = ValueNotifier<int>(1);

  static void openLeads() => selectedTab.value = 0;
  static void openClients() => selectedTab.value = 1;

  /// Condition/application submission creates a Pending policy and therefore
  /// moves the person from Leads to Clients. A person never exists in both.
  static CustomerMock convertLead(LeadEntity lead) {
    final existing = CustomerMockData.customers.where(
      (customer) => customer.id == 'lead-${lead.id}',
    );
    if (existing.isNotEmpty) {
      leadsData.removeWhere((item) => item.id == lead.id);
      openClients();
      return existing.first;
    }

    final clientId = 'lead-${lead.id}';
    final policy = PolicyMock(
      id: 'PENDING-${lead.id.padLeft(4, '0')}',
      productName: 'Application submitted',
      category: ProductCategory.protection,
      status: CrmStatus.pending,
      sumInsured: '—',
      term: 'Pending',
      frequency: '—',
      premium: '—',
      insured: PolicyPartyInfo(
        rows: {'Name': lead.name, 'Status': 'Condition submitted'},
      ),
      policyholder: PolicyPartyInfo(
        rows: {'Name': lead.name, 'Mobile': lead.phone, 'Email': lead.email},
      ),
      beneficiary: const PolicyPartyInfo(rows: {'Status': 'To be completed'}),
      clientId: clientId,
      clientName: lead.name,
      effectiveDate: DateTime(2026, 8, 17),
      expiryDate: DateTime(2027, 8, 17),
      ageAtIssue: 0,
    );
    final client = CustomerMock(
      id: clientId,
      name: lead.name,
      phone: lead.phone,
      email: lead.email,
      dob: DateTime(2000, 1, 1),
      identification: 'Pending KYC',
      gender: '—',
      policies: [policy],
    );

    leadsData.removeWhere((item) => item.id == lead.id);
    CustomerMockData.customers.insert(0, client);
    openClients();
    return client;
  }

  /// e-App submit (FR-03 still pending Core issue) → Lead stage Applied.
  static void markLeadApplied(String partyId) {
    final id = partyId.startsWith('lead-') ? partyId.substring(5) : partyId;
    final index = leadsData.indexWhere((item) => item.id == id);
    if (index < 0) return;
    leadsData[index] = leadsData[index].copyWith(status: 'Applied');
  }

  /// Tracker Approved / Core issue → person becomes a Client.
  static CustomerMock? convertLeadFromPartyId(String partyId) {
    final id = partyId.startsWith('lead-') ? partyId.substring(5) : partyId;
    LeadEntity? lead;
    for (final item in leadsData) {
      if (item.id == id) {
        lead = item;
        break;
      }
    }
    if (lead == null) return null;
    return convertLead(lead);
  }
}
