// Customer CRM + agent Policy List mock (docs/51 · 66). Session-mutable contact fields.

import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppDate;

enum CrmStatus { active, pending, expired }

enum ProductCategory { protection, saving, travel }

class PolicyPartyInfo {
  const PolicyPartyInfo({required this.rows});

  final Map<String, String> rows;
}

class PolicyMock {
  const PolicyMock({
    required this.id,
    required this.productName,
    required this.category,
    required this.status,
    required this.sumInsured,
    required this.term,
    required this.frequency,
    required this.premium,
    required this.insured,
    required this.policyholder,
    required this.beneficiary,
    required this.clientId,
    required this.clientName,
    required this.effectiveDate,
    required this.expiryDate,
    required this.ageAtIssue,
    this.nextDueDate,
    this.hasSignature = false,
  });

  final String id;
  final String productName;
  final ProductCategory category;
  final CrmStatus status;
  final String sumInsured;
  final String term;
  final String frequency;
  final String premium;
  final PolicyPartyInfo insured;
  final PolicyPartyInfo policyholder;
  final PolicyPartyInfo beneficiary;
  final String clientId;
  final String clientName;
  final DateTime effectiveDate;
  final DateTime expiryDate;
  final DateTime? nextDueDate;
  final int ageAtIssue;
  final bool hasSignature;

  String get statusLabel => switch (status) {
        CrmStatus.active => 'Active',
        CrmStatus.pending => 'Pending',
        CrmStatus.expired => 'Expired',
      };

  String get categoryLabel => switch (category) {
        ProductCategory.protection => 'Protection',
        ProductCategory.saving => 'Saving',
        ProductCategory.travel => 'Travel',
      };

  IconData get productIcon => switch (category) {
        ProductCategory.protection => Icons.health_and_safety_outlined,
        ProductCategory.saving => Icons.public_outlined,
        ProductCategory.travel => Icons.flight_outlined,
      };

  /// Prefer education/health-specific icons when name hints.
  IconData get listIcon {
    final n = productName.toLowerCase();
    if (n.contains('education')) return Icons.menu_book_outlined;
    if (n.contains('health')) return Icons.favorite_outline;
    if (n.contains('travel')) return Icons.work_outline;
    if (n.contains('universal') || n.contains('life')) {
      return Icons.public_outlined;
    }
    if (n.contains('accident')) return Icons.shield_outlined;
    return productIcon;
  }

  String get nextDueLabel {
    final d = nextDueDate;
    if (d == null) return '—';
    return PolicyFormat.dob(d);
  }

  String get effectiveLabel => PolicyFormat.dob(effectiveDate);

  String get expiryLabel => PolicyFormat.dob(expiryDate);

  /// FR-08 / `81`: Renew when Expired or within the Web-configurable window.
  bool get isRenewalEligible {
    if (status == CrmStatus.pending) return false;
    if (status == CrmStatus.expired) return true;
    final opensOn = DateTime(
      expiryDate.year,
      expiryDate.month,
      expiryDate.day,
    ).subtract(Duration(days: PolicyRenewalRules.windowDays));
    return !PolicyRenewalRules.today.isBefore(opensOn);
  }
}

/// Mock of the Web Portal renewal-window setting (`81`). Default 30 days.
abstract final class PolicyRenewalRules {
  static const windowDays = 30;
  static DateTime get today => DateTime(2026, 8, 17);
}

abstract final class PolicyFormat {
  static String dob(DateTime d) => AppDate.dMy(d);

  static String range(DateTime? from, DateTime? to) => AppDate.range(from, to);
}

class PolicyChartMonth {
  const PolicyChartMonth({
    required this.label,
    required this.active,
    required this.pending,
    required this.expired,
  });

  final String label;
  final int active;
  final int pending;
  final int expired;
}

class CustomerMock {
  CustomerMock({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.dob,
    required this.identification,
    required this.gender,
    required this.policies,
  });

  final String id;
  String name;
  String phone;
  String email;
  DateTime dob;
  String identification;
  String gender; // Male | Female
  final List<PolicyMock> policies;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'C';
    return parts.first[0].toUpperCase();
  }

  /// List badge: Active if any active policy, else Expired if any expired, else Pending.
  CrmStatus get status {
    if (policies.any((p) => p.status == CrmStatus.active)) {
      return CrmStatus.active;
    }
    if (policies.any((p) => p.status == CrmStatus.expired)) {
      return CrmStatus.expired;
    }
    return CrmStatus.pending;
  }

  String get statusLabel => switch (status) {
        CrmStatus.active => 'Active',
        CrmStatus.pending => 'Pending',
        CrmStatus.expired => 'Expired',
      };

  int get policyCount => policies.length;

  String get dobLabel => AppDate.dMy(dob);

  bool matchesProduct(ProductCategory? category) {
    if (category == null) return true;
    return policies.any((p) => p.category == category);
  }

  bool matchesStatus(CrmStatus? statusFilter) {
    if (statusFilter == null) return true;
    return status == statusFilter;
  }
}

class CustomerFilterSelection {
  const CustomerFilterSelection({
    this.status,
    this.product,
  });

  /// null = All
  final CrmStatus? status;
  /// null = All
  final ProductCategory? product;

  static const all = CustomerFilterSelection();

  CustomerFilterSelection copyWith({
    CrmStatus? Function()? status,
    ProductCategory? Function()? product,
  }) {
    return CustomerFilterSelection(
      status: status != null ? status() : this.status,
      product: product != null ? product() : this.product,
    );
  }
}

/// Agent-wide Policy List filter (docs/66) — includes optional date range.
class PolicyListFilterSelection {
  const PolicyListFilterSelection({
    this.status,
    this.product,
    this.dateFrom,
    this.dateTo,
  });

  final CrmStatus? status;
  final ProductCategory? product;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  static const all = PolicyListFilterSelection();

  bool get hasDate => dateFrom != null || dateTo != null;
}

abstract final class CustomerMockData {
  static final List<CustomerMock> customers = [
    CustomerMock(
      id: 'c1',
      name: 'May Chan Myae',
      phone: '09 750337968',
      email: 'may@gmail.com',
      dob: DateTime(1999, 6, 4),
      identification: '12/KaMaNa(N)127645',
      gender: 'Female',
      policies: [
        PolicyMock(
          id: '23487532096712',
          productName: 'Personal Accident',
          category: ProductCategory.protection,
          status: CrmStatus.active,
          sumInsured: '500,000 MMK',
          term: '1 Year',
          frequency: 'Annual',
          premium: '3,600 MMK',
          clientId: 'c1',
          clientName: 'May Chan Myae',
          effectiveDate: DateTime(2025, 3, 1),
          expiryDate: DateTime(2026, 3, 1),
          nextDueDate: DateTime(2026, 9, 1),
          ageAtIssue: 26,
          hasSignature: true,
          insured: const PolicyPartyInfo(rows: {
            'Name': 'May Chan Myae',
            'Date of Birth': '04-Jun-1999',
            'Identification': '12/KaMaNa(N)127645',
            'Gender': 'Female',
            'Relationship': 'Self',
          }),
          policyholder: const PolicyPartyInfo(rows: {
            'Name': 'May Chan Myae',
            'Mobile': '09 750337968',
            'Email': 'may@gmail.com',
            'Address': 'Yangon',
          }),
          beneficiary: const PolicyPartyInfo(rows: {
            'Name': 'Aung Aung',
            'Relationship': 'Spouse',
            'Share': '100%',
          }),
        ),
        PolicyMock(
          id: '187498273098',
          productName: 'Health Insurance',
          category: ProductCategory.protection,
          status: CrmStatus.active,
          sumInsured: '1 Unit',
          term: '1 Year',
          frequency: 'Semi-Annual',
          premium: '5,600 MMK',
          clientId: 'c1',
          clientName: 'May Chan Myae',
          effectiveDate: DateTime(2025, 6, 4),
          expiryDate: DateTime(2026, 6, 4),
          nextDueDate: DateTime(2026, 12, 4),
          ageAtIssue: 26,
          hasSignature: true,
          insured: const PolicyPartyInfo(rows: {
            'Name': 'May Chan Myae',
            'Date of Birth': '04-Jun-1999',
            'Identification': '12/KaMaNa(N)127645',
            'Gender': 'Female',
            'Relationship': 'Self',
          }),
          policyholder: const PolicyPartyInfo(rows: {
            'Name': 'May Chan Myae',
            'Mobile': '09 750337968',
            'Email': 'may@gmail.com',
            'Address': 'Yangon',
          }),
          beneficiary: const PolicyPartyInfo(rows: {
            'Name': 'Aung Aung',
            'Relationship': 'Spouse',
            'Share': '100%',
          }),
        ),
        PolicyMock(
          id: '187498273099',
          productName: 'Universal Life',
          category: ProductCategory.saving,
          status: CrmStatus.pending,
          sumInsured: '15,000,000 MMK',
          term: '20 Years',
          frequency: 'Monthly',
          premium: '50,000 MMK',
          clientId: 'c1',
          clientName: 'May Chan Myae',
          effectiveDate: DateTime(2026, 7, 1),
          expiryDate: DateTime(2046, 7, 1),
          nextDueDate: DateTime(2026, 8, 1),
          ageAtIssue: 27,
          hasSignature: false,
          insured: const PolicyPartyInfo(rows: {
            'Name': 'May Chan Myae',
            'Date of Birth': '04-Jun-1999',
            'Identification': '12/KaMaNa(N)127645',
            'Gender': 'Female',
            'Relationship': 'Self',
          }),
          policyholder: const PolicyPartyInfo(rows: {
            'Name': 'May Chan Myae',
            'Mobile': '09 750337968',
            'Email': 'may@gmail.com',
            'Address': 'Yangon',
          }),
          beneficiary: const PolicyPartyInfo(rows: {
            'Name': 'Aung Aung',
            'Relationship': 'Spouse',
            'Share': '100%',
          }),
        ),
      ],
    ),
    CustomerMock(
      id: 'c2',
      name: 'Chan Myae',
      phone: '09 750337968',
      email: 'chan@gmail.com',
      dob: DateTime(1995, 3, 12),
      identification: '12/PaZaTa(N)998877',
      gender: 'Male',
      policies: [
        PolicyMock(
          id: '298765432101',
          productName: 'Education Life',
          category: ProductCategory.saving,
          status: CrmStatus.active,
          sumInsured: '2 Units',
          term: '10 Years',
          frequency: 'Annual',
          premium: '12,000 MMK',
          clientId: 'c2',
          clientName: 'Chan Myae',
          effectiveDate: DateTime(2024, 1, 15),
          expiryDate: DateTime(2034, 1, 15),
          nextDueDate: DateTime(2027, 1, 15),
          ageAtIssue: 28,
          hasSignature: true,
          insured: const PolicyPartyInfo(rows: {
            'Name': 'Su Su',
            'Date of Birth': '01-Jan-2015',
            'Identification': '12/PaZaTa(N)112233',
            'Gender': 'Female',
            'Relationship': 'Child',
          }),
          policyholder: const PolicyPartyInfo(rows: {
            'Name': 'Chan Myae',
            'Mobile': '09 750337968',
            'Email': 'chan@gmail.com',
            'Address': 'Mandalay',
          }),
          beneficiary: const PolicyPartyInfo(rows: {
            'Name': 'Su Su',
            'Relationship': 'Child',
            'Share': '100%',
          }),
        ),
        PolicyMock(
          id: '298765432188',
          productName: 'Health Insurance',
          category: ProductCategory.protection,
          status: CrmStatus.pending,
          sumInsured: '500,000 MMK',
          term: '1 Year',
          frequency: 'Lumpsum',
          premium: '8,400 MMK',
          clientId: 'c2',
          clientName: 'Chan Myae',
          effectiveDate: DateTime(2026, 6, 20),
          expiryDate: DateTime(2027, 6, 20),
          nextDueDate: DateTime(2026, 12, 20),
          ageAtIssue: 31,
          hasSignature: false,
          insured: const PolicyPartyInfo(rows: {
            'Name': 'Chan Myae',
            'Date of Birth': '12-Mar-1995',
            'Identification': '12/PaZaTa(N)998877',
            'Gender': 'Male',
            'Relationship': 'Self',
          }),
          policyholder: const PolicyPartyInfo(rows: {
            'Name': 'Chan Myae',
            'Mobile': '09 750337968',
            'Email': 'chan@gmail.com',
            'Address': 'Mandalay',
          }),
          beneficiary: const PolicyPartyInfo(rows: {
            'Name': 'Su Su',
            'Relationship': 'Child',
            'Share': '100%',
          }),
        ),
      ],
    ),
    CustomerMock(
      id: 'c3',
      name: 'Thiri Aung',
      phone: '09 880088340',
      email: 'thiri@gmail.com',
      dob: DateTime(1988, 11, 20),
      identification: '9/MaNaMa(N)445566',
      gender: 'Female',
      policies: [
        PolicyMock(
          id: '334455667788',
          productName: 'Travel Cover',
          category: ProductCategory.travel,
          status: CrmStatus.expired,
          sumInsured: '1,000,000 MMK',
          term: '15 Days',
          frequency: 'Single',
          premium: '3,200 MMK',
          clientId: 'c3',
          clientName: 'Thiri Aung',
          effectiveDate: DateTime(2025, 1, 10),
          expiryDate: DateTime(2025, 1, 25),
          nextDueDate: null,
          ageAtIssue: 36,
          hasSignature: true,
          insured: const PolicyPartyInfo(rows: {
            'Name': 'Thiri Aung',
            'Date of Birth': '20-Nov-1988',
            'Identification': '9/MaNaMa(N)445566',
            'Gender': 'Female',
            'Relationship': 'Self',
          }),
          policyholder: const PolicyPartyInfo(rows: {
            'Name': 'Thiri Aung',
            'Mobile': '09 880088340',
            'Email': 'thiri@gmail.com',
            'Address': 'Nay Pyi Taw',
          }),
          beneficiary: const PolicyPartyInfo(rows: {
            'Name': 'Ko Ko',
            'Relationship': 'Brother',
            'Share': '100%',
          }),
        ),
        PolicyMock(
          id: '334455667799',
          productName: 'Travel Cover',
          category: ProductCategory.travel,
          status: CrmStatus.expired,
          sumInsured: '1,000,000 MMK',
          term: '3 Days',
          frequency: 'Lumpsum',
          premium: '150 MMK',
          clientId: 'c3',
          clientName: 'Thiri Aung',
          effectiveDate: DateTime(2024, 11, 1),
          expiryDate: DateTime(2024, 11, 4),
          nextDueDate: null,
          ageAtIssue: 35,
          hasSignature: false,
          insured: const PolicyPartyInfo(rows: {
            'Name': 'Thiri Aung',
            'Date of Birth': '20-Nov-1988',
            'Identification': '9/MaNaMa(N)445566',
            'Gender': 'Female',
            'Relationship': 'Self',
          }),
          policyholder: const PolicyPartyInfo(rows: {
            'Name': 'Thiri Aung',
            'Mobile': '09 880088340',
            'Email': 'thiri@gmail.com',
            'Address': 'Nay Pyi Taw',
          }),
          beneficiary: const PolicyPartyInfo(rows: {
            'Name': 'Ko Ko',
            'Relationship': 'Brother',
            'Share': '100%',
          }),
        ),
      ],
    ),
  ];

  /// Flattened agent book (deduped by policy id).
  static List<PolicyMock> get allPolicies {
    final seen = <String>{};
    final out = <PolicyMock>[];
    for (final c in customers) {
      for (final p in c.policies) {
        if (seen.add(p.id)) out.add(p);
      }
    }
    return out;
  }

  static PolicyMock? policyById(String id) {
    for (final p in allPolicies) {
      if (p.id == id) return p;
    }
    return null;
  }

  static PolicyMock? get firstRenewalPolicy {
    for (final p in allPolicies) {
      if (p.isRenewalEligible) return p;
    }
    return allPolicies.isEmpty ? null : allPolicies.first;
  }

  /// Illustrative trend for Policy List chart (docs/66) — not live Core.
  static const chartSeries = <PolicyChartMonth>[
    PolicyChartMonth(label: 'Mar', active: 12, pending: 4, expired: 2),
    PolicyChartMonth(label: 'Apr', active: 18, pending: 8, expired: 3),
    PolicyChartMonth(label: 'May', active: 22, pending: 6, expired: 5),
    PolicyChartMonth(label: 'Jun', active: 28, pending: 12, expired: 4),
    PolicyChartMonth(label: 'Jul', active: 24, pending: 10, expired: 7),
    PolicyChartMonth(label: 'Aug', active: 32, pending: 9, expired: 6),
  ];

  static CustomerMock byId(String id) =>
      customers.firstWhere((c) => c.id == id, orElse: () => customers.first);

  static List<CustomerMock> filtered({
    required String query,
    required CustomerFilterSelection filter,
  }) {
    final q = query.trim().toLowerCase();
    return customers.where((c) {
      final textOk = q.isEmpty ||
          c.name.toLowerCase().contains(q) ||
          c.phone.replaceAll(' ', '').contains(q.replaceAll(' ', ''));
      return textOk &&
          c.matchesStatus(filter.status) &&
          c.matchesProduct(filter.product);
    }).toList();
  }

  static List<PolicyMock> filterPolicies(
    List<PolicyMock> policies,
    CustomerFilterSelection filter,
  ) {
    return policies.where((p) {
      final statusMatch =
          filter.status == null || p.status == filter.status;
      final productOk =
          filter.product == null || p.category == filter.product;
      return statusMatch && productOk;
    }).toList();
  }

  static List<PolicyMock> filterAgentPolicies({
    required String query,
    required PolicyListFilterSelection filter,
  }) {
    final q = query.trim().toLowerCase();
    final from = filter.dateFrom;
    final to = filter.dateTo;
    return allPolicies.where((p) {
      final textOk = q.isEmpty ||
          p.id.contains(q) ||
          p.productName.toLowerCase().contains(q) ||
          p.clientName.toLowerCase().contains(q);
      final statusOk = filter.status == null || p.status == filter.status;
      final productOk =
          filter.product == null || p.category == filter.product;
      var dateOk = true;
      if (from != null || to != null) {
        final start = from ?? DateTime(2000);
        final end = to ?? DateTime(2100);
        dateOk = !p.effectiveDate.isBefore(
              DateTime(start.year, start.month, start.day),
            ) &&
            !p.effectiveDate.isAfter(DateTime(end.year, end.month, end.day));
      }
      return textOk && statusOk && productOk && dateOk;
    }).toList();
  }
}
