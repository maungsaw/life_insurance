// Commission ledger mock — display only, no payout (docs/61).

class CommissionEntry {
  const CommissionEntry({
    required this.id,
    required this.title,
    required this.at,
    required this.amount,
    this.productName,
    this.policyRef,
  });

  final String id;
  final String title;
  final DateTime at;
  final double amount;
  final String? productName;
  final String? policyRef;

  String get amountLabel {
    final sign = amount >= 0 ? '+' : '−';
    return '$sign${CommissionFormat.money(amount.abs())}';
  }

  String get whenLabel => CommissionFormat.dateTime(at);
}

enum CommissionPeriodFilter { all, thisMonth, lastMonth, last90 }

abstract final class CommissionFormat {
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static String money(num value) {
    final fixed = value.toStringAsFixed(2);
    final parts = fixed.split('.');
    final digits = parts[0];
    final buf = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buf.write(',');
      buf.write(digits[i]);
    }
    return '${buf.toString()}.${parts[1]}';
  }

  static String dateTime(DateTime d) {
    final day = d.day.toString().padLeft(2, '0');
    final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final hh = h.toString().padLeft(2, '0');
    final mm = d.minute.toString().padLeft(2, '0');
    final ap = d.hour >= 12 ? 'PM' : 'AM';
    return '$day-${_months[d.month - 1]}-${d.year} $hh:$mm $ap';
  }
}

abstract final class CommissionMockData {
  static const totalLabel = '726,080.00 MMK';
  static const deltaLabel = '↗ 15% up compared with last month';

  /// Align Profile chip with ledger total for prototype honesty.
  static const totalCommissionPlain = '726,080.00';

  static final entries = <CommissionEntry>[
    CommissionEntry(
      id: 'c1',
      title: 'Commission',
      at: DateTime(2024, 9, 18, 10, 11),
      amount: 23000,
      productName: 'Universal Life',
      policyRef: 'POL-2024-0918',
    ),
    CommissionEntry(
      id: 'c2',
      title: 'Commission',
      at: DateTime(2024, 9, 18, 10, 11),
      amount: 23000,
      productName: 'Personal Accident',
      policyRef: 'POL-2024-0917',
    ),
    CommissionEntry(
      id: 'c3',
      title: 'Commission',
      at: DateTime(2024, 9, 12, 14, 30),
      amount: 45000,
      productName: 'Short Term Endowment',
      policyRef: 'POL-2024-0912',
    ),
    CommissionEntry(
      id: 'c4',
      title: 'Commission',
      at: DateTime(2024, 8, 28, 9, 5),
      amount: 18500,
      productName: 'Family Health',
      policyRef: 'POL-2024-0828',
    ),
    CommissionEntry(
      id: 'c5',
      title: 'Commission',
      at: DateTime(2024, 8, 5, 16, 42),
      amount: 32000,
      productName: 'Credit Life',
      policyRef: 'POL-2024-0805',
    ),
    CommissionEntry(
      id: 'c6',
      title: 'Commission',
      at: DateTime(2024, 7, 22, 11, 20),
      amount: 27500,
      productName: 'Travel Protect',
      policyRef: 'POL-2024-0722',
    ),
  ];

  static List<CommissionEntry> filtered(CommissionPeriodFilter period) {
    if (period == CommissionPeriodFilter.all) return entries;
    // Prototype “today” for filters — matches app demo date.
    final now = DateTime(2024, 9, 20);
    return entries.where((e) {
      switch (period) {
        case CommissionPeriodFilter.all:
          return true;
        case CommissionPeriodFilter.thisMonth:
          return e.at.year == now.year && e.at.month == now.month;
        case CommissionPeriodFilter.lastMonth:
          final last = DateTime(now.year, now.month - 1);
          return e.at.year == last.year && e.at.month == last.month;
        case CommissionPeriodFilter.last90:
          return e.at.isAfter(now.subtract(const Duration(days: 90)));
      }
    }).toList();
  }
}
