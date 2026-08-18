import 'package:intl/intl.dart';

/// Canonical agent-facing dates (`94`). Always English `04-Jun-1999`, even if UI is Myanmar.
abstract final class AppDate {
  static const pattern = 'dd-MMM-yyyy';
  static const dateTimePattern = 'dd-MMM-yyyy hh:mm a';

  static final _dMy = DateFormat(pattern, 'en_US');
  static final _dMyHm = DateFormat(dateTimePattern, 'en_US');
  static final _hm = DateFormat('HH:mm', 'en_US');
  static final _h12 = DateFormat('hh:mm a', 'en_US');
  static final _ddMmm = DateFormat('dd-MMM', 'en_US');
  static final _monthYear = DateFormat('MMM-yyyy', 'en_US');
  static final _dd = DateFormat('dd', 'en_US');

  /// `04-Jun-1999`
  static String dMy(DateTime d) => _dMy.format(d);

  /// `04-Jun-1999 10:11 AM`
  static String dMyHm(DateTime d) => _dMyHm.format(d);

  /// 24h `HH:mm` — avoid on agent-facing clocks (`95`).
  static String hm(DateTime d) => _hm.format(d);

  /// `01:00 PM` — 12-hour, zero-padded 01–12 (`95`).
  static String h12(DateTime d) => _h12.format(d);

  /// Timeline tick for a 0–23 hour.
  static String h12Hour(int hour) =>
      h12(DateTime(2026, 1, 1, hour.clamp(0, 23)));

  /// `Aug-2026`
  static String monthYear(DateTime d) => _monthYear.format(d);

  /// `10–16-Aug-2026` or `28-Aug – 03-Sep-2026`.
  static String weekRange(DateTime start, {int days = 6}) {
    final end = start.add(Duration(days: days));
    if (start.year == end.year && start.month == end.month) {
      return '${_dd.format(start)}–${dMy(end)}';
    }
    return '${_ddMmm.format(start)} – ${dMy(end)}';
  }

  static String range(DateTime? from, DateTime? to) {
    if (from == null && to == null) return '';
    if (from != null && to != null) return '${dMy(from)} - ${dMy(to)}';
    return dMy(from ?? to!);
  }
}
