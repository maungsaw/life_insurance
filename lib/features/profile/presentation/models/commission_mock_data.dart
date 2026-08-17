// Commission ledger mock — display only, no payout (docs/61 · 80).
import 'package:flutter/material.dart';

enum CommissionLine { protection, saving, health, travel }

enum CommissionPeriodFilter { all, thisMonth, lastMonth, last90 }

extension CommissionLineX on CommissionLine {
  String get label => switch (this) {
    CommissionLine.protection => 'Protection',
    CommissionLine.saving => 'Saving',
    CommissionLine.health => 'Health',
    CommissionLine.travel => 'Travel',
  };

  IconData get icon => switch (this) {
    CommissionLine.protection => Icons.health_and_safety_outlined,
    CommissionLine.saving => Icons.savings_outlined,
    CommissionLine.health => Icons.favorite_outline,
    CommissionLine.travel => Icons.work_outline,
  };

  Color get color => switch (this) {
    CommissionLine.protection => const Color(0xFF00A6FB),
    CommissionLine.saving => const Color(0xFFF59E0B),
    CommissionLine.health => const Color(0xFFE11D48),
    CommissionLine.travel => const Color(0xFF7C3AED),
  };
}

class CommissionEntry {
  const CommissionEntry({
    required this.id,
    required this.productName,
    required this.at,
    required this.amount,
    required this.line,
    this.clientName,
    this.policyRef,
  });

  final String id;
  final String productName;
  final DateTime at;
  final double amount;
  final CommissionLine line;
  final String? clientName;
  final String? policyRef;

  String get title => productName;

  String get amountLabel {
    final sign = amount >= 0 ? '+' : '−';
    return '$sign${CommissionFormat.money(amount.abs())}';
  }

  String get whenLabel => CommissionFormat.dateTime(at);

  String get subtitle {
    final bits = <String>[
      whenLabel,
      ?policyRef,
    ];
    return bits.join(' · ');
  }
}

class CommissionLineStat {
  const CommissionLineStat({
    required this.line,
    required this.amount,
    required this.count,
  });

  final CommissionLine line;
  final double amount;
  final int count;
}

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

  static String compactMmK(num value) {
    if (value >= 1000000) {
      return 'MMK ${(value / 1000000).toStringAsFixed(2)}m';
    }
    return 'MMK ${money(value)}';
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
  /// Prototype "now" — aligned with the rest of the 2026 demo.
  static DateTime get now => DateTime(2026, 8, 17);

  static const deltaFallback = '↗ 15% up compared with last month';

  static final entries = <CommissionEntry>[
    CommissionEntry(
      id: 'c1',
      productName: 'Universal Life',
      at: DateTime(2026, 8, 14, 10, 11),
      amount: 23000,
      line: CommissionLine.saving,
      clientName: 'May Chan Myae',
      policyRef: 'POL-2026-0814',
    ),
    CommissionEntry(
      id: 'c2',
      productName: 'Personal Accident',
      at: DateTime(2026, 8, 12, 9, 20),
      amount: 23000,
      line: CommissionLine.protection,
      clientName: 'Chan Myae',
      policyRef: 'POL-2026-0812',
    ),
    CommissionEntry(
      id: 'c3',
      productName: 'Short Term Endowment',
      at: DateTime(2026, 8, 10, 14, 30),
      amount: 45000,
      line: CommissionLine.saving,
      clientName: 'Thura Aung',
      policyRef: 'POL-2026-0810',
    ),
    CommissionEntry(
      id: 'c4',
      productName: 'Travel Protect',
      at: DateTime(2026, 8, 8, 11, 5),
      amount: 125000,
      line: CommissionLine.travel,
      clientName: 'Aye Aye',
      policyRef: 'POL-2026-0808',
    ),
    CommissionEntry(
      id: 'c5',
      productName: 'Family Health',
      at: DateTime(2026, 8, 5, 16, 42),
      amount: 89000,
      line: CommissionLine.health,
      clientName: 'May Chan Myae',
      policyRef: 'POL-2026-0805',
    ),
    CommissionEntry(
      id: 'c6',
      productName: 'Credit Life',
      at: DateTime(2026, 7, 22, 11, 20),
      amount: 32000,
      line: CommissionLine.protection,
      clientName: 'Ko Ko',
      policyRef: 'POL-2026-0722',
    ),
    CommissionEntry(
      id: 'c7',
      productName: 'Travel Protect',
      at: DateTime(2026, 7, 18, 10, 11),
      amount: 27500,
      line: CommissionLine.travel,
      clientName: 'Su Su',
      policyRef: 'POL-2026-0718',
    ),
    CommissionEntry(
      id: 'c8',
      productName: 'Family Health',
      at: DateTime(2026, 7, 12, 13, 40),
      amount: 18500,
      line: CommissionLine.health,
      clientName: 'Chan Myae',
      policyRef: 'POL-2026-0712',
    ),
    CommissionEntry(
      id: 'c9',
      productName: 'Personal Accident',
      at: DateTime(2026, 7, 8, 9, 5),
      amount: 70000,
      line: CommissionLine.protection,
      clientName: 'Min Min',
      policyRef: 'POL-2026-0708',
    ),
    CommissionEntry(
      id: 'c10',
      productName: 'Universal Life',
      at: DateTime(2026, 7, 4, 15, 18),
      amount: 55000,
      line: CommissionLine.saving,
      clientName: 'Aye Aye',
      policyRef: 'POL-2026-0704',
    ),
    CommissionEntry(
      id: 'c11',
      productName: 'Health Insurance',
      at: DateTime(2026, 7, 2, 8, 50),
      amount: 62000,
      line: CommissionLine.health,
      clientName: 'Thura Aung',
      policyRef: 'POL-2026-0702',
    ),
    CommissionEntry(
      id: 'c12',
      productName: 'Health Insurance',
      at: DateTime(2026, 6, 20, 11, 12),
      amount: 67000,
      line: CommissionLine.health,
      clientName: 'Su Su',
      policyRef: 'POL-2026-0620',
    ),
    CommissionEntry(
      id: 'c13',
      productName: 'Travel Protect',
      at: DateTime(2026, 6, 8, 16, 0),
      amount: 58080,
      line: CommissionLine.travel,
      clientName: 'Ko Ko',
      policyRef: 'POL-2026-0608',
    ),
    CommissionEntry(
      id: 'c14',
      productName: 'Credit Life',
      at: DateTime(2026, 5, 22, 10, 30),
      amount: 31000,
      line: CommissionLine.protection,
      clientName: 'Min Min',
      policyRef: 'POL-2026-0522',
    ),
  ];

  static double get total =>
      entries.fold<double>(0, (sum, e) => sum + e.amount);

  static String get totalLabel => '${CommissionFormat.money(total)} MMK';

  static String get totalCommissionPlain => CommissionFormat.money(total);

  static String get deltaLabel {
    final thisM = sumFor(CommissionPeriodFilter.thisMonth);
    final lastM = sumFor(CommissionPeriodFilter.lastMonth);
    if (lastM <= 0) return deltaFallback;
    final pct = ((thisM - lastM) / lastM * 100).round();
    if (pct >= 0) return '↗ $pct% up compared with last month';
    return '↘ ${pct.abs()}% down compared with last month';
  }

  static List<CommissionEntry> filtered(
    CommissionPeriodFilter period, {
    CommissionLine? line,
  }) {
    return entries.where((e) {
      if (line != null && e.line != line) return false;
      return _inPeriod(e.at, period);
    }).toList();
  }

  static double sumFor(
    CommissionPeriodFilter period, {
    CommissionLine? line,
  }) {
    return filtered(period, line: line).fold<double>(0, (s, e) => s + e.amount);
  }

  static List<CommissionLineStat> reportLines(CommissionPeriodFilter period) {
    return [
      for (final line in CommissionLine.values)
        CommissionLineStat(
          line: line,
          amount: sumFor(period, line: line),
          count: filtered(period, line: line).length,
        ),
    ];
  }

  static CommissionLineStat? topLine(CommissionPeriodFilter period) {
    final lines = reportLines(period).where((s) => s.amount > 0).toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
    return lines.isEmpty ? null : lines.first;
  }

  static int policyCount(CommissionPeriodFilter period) {
    return filtered(period).map((e) => e.policyRef).whereType<String>().toSet().length;
  }

  static int categoryCount(CommissionPeriodFilter period) {
    return reportLines(period).where((s) => s.amount > 0).length;
  }

  static bool _inPeriod(DateTime at, CommissionPeriodFilter period) {
    switch (period) {
      case CommissionPeriodFilter.all:
        return true;
      case CommissionPeriodFilter.thisMonth:
        return at.year == now.year && at.month == now.month;
      case CommissionPeriodFilter.lastMonth:
        final last = DateTime(now.year, now.month - 1);
        return at.year == last.year && at.month == last.month;
      case CommissionPeriodFilter.last90:
        return at.isAfter(now.subtract(const Duration(days: 90)));
    }
  }
}

String commissionPeriodLabel(CommissionPeriodFilter p) => switch (p) {
  CommissionPeriodFilter.all => 'All',
  CommissionPeriodFilter.thisMonth => 'This month',
  CommissionPeriodFilter.lastMonth => 'Last month',
  CommissionPeriodFilter.last90 => 'Last 90 days',
};
