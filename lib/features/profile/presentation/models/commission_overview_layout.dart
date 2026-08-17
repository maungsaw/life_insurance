import 'package:flutter/material.dart';
import 'package:life_insurance/features/profile/presentation/models/commission_mock_data.dart';

/// Density switch for Commission Overview — few bars vs many rows (docs/85).
enum CommissionOverviewMode { empty, single, few, scroll, list }

class CommissionOverviewSlice {
  const CommissionOverviewSlice({
    required this.amount,
    required this.count,
    this.line,
    this.othersCategoryCount,
  });

  factory CommissionOverviewSlice.fromStat(CommissionLineStat stat) {
    return CommissionOverviewSlice(
      line: stat.line,
      amount: stat.amount,
      count: stat.count,
    );
  }

  factory CommissionOverviewSlice.others({
    required double amount,
    required int count,
    required int othersCategoryCount,
  }) {
    return CommissionOverviewSlice(
      amount: amount,
      count: count,
      othersCategoryCount: othersCategoryCount,
    );
  }

  final CommissionLine? line;
  final double amount;
  final int count;
  final int? othersCategoryCount;

  bool get isOthers => line == null;

  String get label => line?.label ?? 'Others';

  IconData get icon => line?.icon ?? Icons.more_horiz_rounded;

  Color get color => line?.color ?? const Color(0xFF64748B);

  String get semanticsLabel {
    final money = amount <= 0 ? 'none' : CommissionFormat.money(amount);
    final extra = othersCategoryCount == null
        ? ''
        : ', $othersCategoryCount more categories';
    return '$label, $money, $count commissions$extra';
  }
}

class CommissionOverviewPlan {
  const CommissionOverviewPlan({
    required this.mode,
    required this.slices,
    required this.maxAmount,
  });

  final CommissionOverviewMode mode;
  final List<CommissionOverviewSlice> slices;
  final double maxAmount;
}

/// Thresholds live here so widgets do not scatter magic numbers (docs/85).
abstract final class CommissionOverviewLayout {
  static const fewMax = 4;
  static const scrollMax = 7;
  static const listFrom = 8;
  static const othersAfter = 10;
  static const barMinWidth = 72.0;
  static const barPeek = 8.0;

  static CommissionOverviewMode modeFor(int positiveCount) {
    if (positiveCount <= 0) return CommissionOverviewMode.empty;
    if (positiveCount == 1) return CommissionOverviewMode.single;
    if (positiveCount <= fewMax) return CommissionOverviewMode.few;
    if (positiveCount <= scrollMax) return CommissionOverviewMode.scroll;
    return CommissionOverviewMode.list;
  }

  static CommissionOverviewPlan plan(List<CommissionLineStat> lines) {
    final sortedAll = [...lines]
      ..sort((a, b) => b.amount.compareTo(a.amount));
    final positives = sortedAll.where((s) => s.amount > 0).toList();
    final mode = modeFor(positives.length);

    final slices = switch (mode) {
      CommissionOverviewMode.empty => const <CommissionOverviewSlice>[],
      CommissionOverviewMode.single =>
        positives.map(CommissionOverviewSlice.fromStat).toList(),
      CommissionOverviewMode.few =>
        (lines.length <= fewMax ? sortedAll : positives)
            .map(CommissionOverviewSlice.fromStat)
            .toList(),
      CommissionOverviewMode.scroll =>
        positives.map(CommissionOverviewSlice.fromStat).toList(),
      CommissionOverviewMode.list => _bucketOthers(positives),
    };

    final maxAmount = slices.fold<double>(
      0,
      (m, s) => s.amount > m ? s.amount : m,
    );
    return CommissionOverviewPlan(
      mode: mode,
      slices: slices,
      maxAmount: maxAmount,
    );
  }

  static List<CommissionOverviewSlice> _bucketOthers(
    List<CommissionLineStat> positives,
  ) {
    if (positives.length <= othersAfter) {
      return positives.map(CommissionOverviewSlice.fromStat).toList();
    }
    final head = positives.take(othersAfter);
    final tail = positives.skip(othersAfter);
    return [
      ...head.map(CommissionOverviewSlice.fromStat),
      CommissionOverviewSlice.others(
        amount: tail.fold<double>(0, (s, e) => s + e.amount),
        count: tail.fold<int>(0, (s, e) => s + e.count),
        othersCategoryCount: tail.length,
      ),
    ];
  }
}
