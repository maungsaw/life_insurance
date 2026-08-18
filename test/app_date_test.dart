import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:life_insurance/core/format/app_date.dart';
import 'package:life_insurance/features/customer/presentation/models/customer_mock_data.dart';
import 'package:life_insurance/features/product/presentation/models/product_mock_data.dart';
import 'package:life_insurance/features/profile/presentation/models/profile_mock_data.dart';
import 'package:life_insurance/features/task/presentation/models/task_mock_data.dart';

void main() {
  test('canonical day is 04-Jun-1999', () {
    final d = DateTime(1999, 6, 4);
    expect(AppDate.dMy(d), '04-Jun-1999');
    expect(ProductFormat.dob(d), '04-Jun-1999');
    expect(PolicyFormat.dob(d), '04-Jun-1999');
    expect(TaskFormat.dob(d), '04-Jun-1999');
    expect(ProfileMockData.dobLabel, '04-Jun-1999');
  });

  test('Myanmar locale does not change the English month', () {
    final previous = Intl.defaultLocale;
    addTearDown(() => Intl.defaultLocale = previous);
    Intl.defaultLocale = 'my';
    expect(AppDate.dMy(DateTime(1999, 6, 4)), '04-Jun-1999');
  });

  test('range uses the same day pattern', () {
    expect(
      AppDate.range(DateTime(2025, 3, 1), DateTime(2026, 3, 1)),
      '01-Mar-2025 - 01-Mar-2026',
    );
  });

  test('date-time keeps the day pattern', () {
    final label = AppDate.dMyHm(DateTime(2026, 8, 14, 10, 11));
    expect(label.startsWith('14-Aug-2026'), isTrue);
    expect(label.contains('10:11'), isTrue);
    expect(label.contains('AM'), isTrue);
  });

  test('12-hour clock pads 01–12 with AM/PM', () {
    expect(AppDate.h12Hour(0), '12:00 AM');
    expect(AppDate.h12Hour(9), '09:00 AM');
    expect(AppDate.h12Hour(12), '12:00 PM');
    expect(AppDate.h12Hour(13), '01:00 PM');
    expect(AppDate.h12Hour(17), '05:00 PM');
  });
}
