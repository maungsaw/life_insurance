// Customer CRM mock models (docs/51). Session-mutable contact fields.

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

  String get statusLabel => switch (status) {
        CrmStatus.active => 'Active',
        CrmStatus.pending => 'Pending',
        CrmStatus.expired => 'Expired',
      };
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

  String get dobLabel {
    const months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
    ];
    final d = dob.day.toString().padLeft(2, '0');
    return '$d-${months[dob.month - 1]}-${dob.year}';
  }

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
          id: '187498273098',
          productName: 'Health Insurance',
          category: ProductCategory.protection,
          status: CrmStatus.active,
          sumInsured: '1 Unit',
          term: '1 Year',
          frequency: 'Semi-Annual',
          premium: '5,600 MMK',
          insured: const PolicyPartyInfo(rows: {
            'Name': 'May Chan Myae',
            'Date of Birth': '04-JUN-1999',
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
          productName: 'Health Insurance',
          category: ProductCategory.protection,
          status: CrmStatus.pending,
          sumInsured: '1 Unit',
          term: '1 Year',
          frequency: 'Annual',
          premium: '5,600 MMK',
          insured: const PolicyPartyInfo(rows: {
            'Name': 'May Chan Myae',
            'Date of Birth': '04-JUN-1999',
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
          insured: const PolicyPartyInfo(rows: {
            'Name': 'Su Su',
            'Date of Birth': '01-JAN-2015',
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
          sumInsured: '1 Unit',
          term: '15 Days',
          frequency: 'Single',
          premium: '3,200 MMK',
          insured: const PolicyPartyInfo(rows: {
            'Name': 'Thiri Aung',
            'Date of Birth': '20-NOV-1988',
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
}
