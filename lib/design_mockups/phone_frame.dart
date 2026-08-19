import 'package:flutter/material.dart';

/// iPhone 14 logical size — matches stakeholder phone frames.
const Size kMockupPhoneSize = Size(390, 844);

class MockupTheme {
  const MockupTheme({
    required this.brightness,
    required this.bg,
    required this.surface,
    required this.ink,
    required this.muted,
    required this.line,
    required this.primary,
    required this.accent,
    required this.onPrimary,
  });

  final Brightness brightness;
  final Color bg;
  final Color surface;
  final Color ink;
  final Color muted;
  final Color line;
  final Color primary;
  final Color accent;
  final Color onPrimary;

  ThemeData get data => ThemeData(
    useMaterial3: true,
    brightness: brightness,
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: bg,
    colorScheme: ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      secondary: accent,
      onSecondary: onPrimary,
      error: const Color(0xFFE11D48),
      onError: Colors.white,
      surface: surface,
      onSurface: ink,
    ),
    textTheme: (brightness == Brightness.dark
            ? Typography.whiteMountainView
            : Typography.blackMountainView)
        .apply(fontFamily: 'Roboto', bodyColor: ink, displayColor: ink),
  );
}

const atelierTheme = MockupTheme(
  brightness: Brightness.light,
  bg: Color(0xFFF4F0EA),
  surface: Color(0xFFFCF9F4),
  ink: Color(0xFF1B4332),
  muted: Color(0xFF6B7B6E),
  line: Color(0xFFD8D0C4),
  primary: Color(0xFF1B4332),
  accent: Color(0xFFE07A5F),
  onPrimary: Colors.white,
);

const signalTheme = MockupTheme(
  brightness: Brightness.dark,
  bg: Color(0xFF0D1117),
  surface: Color(0xFF161B22),
  ink: Color(0xFFE6EDF3),
  muted: Color(0xFF8B949E),
  line: Color(0xFF30363D),
  primary: Color(0xFF2DD4BF),
  accent: Color(0xFFFBBF24),
  onPrimary: Color(0xFF0D1117),
);

const groveTheme = MockupTheme(
  brightness: Brightness.light,
  bg: Color(0xFFE8E4F3),
  surface: Color(0xFFFFFEFF),
  ink: Color(0xFF4A3267),
  muted: Color(0xFF7A6B8F),
  line: Color(0xFFD4CCE8),
  primary: Color(0xFF4A3267),
  accent: Color(0xFFC9A227),
  onPrimary: Colors.white,
);

/// Status bar + home indicator so PNGs read like device wireframes.
class PhoneFrame extends StatelessWidget {
  const PhoneFrame({
    super.key,
    required this.theme,
    required this.child,
    this.statusOnDark = false,
  });

  final MockupTheme theme;
  final Widget child;
  final bool statusOnDark;

  @override
  Widget build(BuildContext context) {
    final onBar = statusOnDark ? Colors.white : theme.ink;
    return SizedBox(
      width: kMockupPhoneSize.width,
      height: kMockupPhoneSize.height,
      child: Theme(
        data: theme.data,
        child: DefaultTextStyle(
          style: TextStyle(
            fontFamily: 'Roboto',
            color: theme.ink,
            fontSize: 14,
            decoration: TextDecoration.none,
          ),
          child: ColoredBox(
          color: theme.bg,
          child: Stack(
            children: [
              Positioned.fill(child: child),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 44,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
                  child: Row(
                    children: [
                      Text(
                        '9:41',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: onBar,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.signal_cellular_alt, size: 14, color: onBar),
                      const SizedBox(width: 6),
                      Icon(Icons.wifi, size: 15, color: onBar),
                      const SizedBox(width: 6),
                      Icon(Icons.battery_full, size: 16, color: onBar),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 140,
                right: 140,
                bottom: 8,
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: onBar.withValues(alpha: 0.28),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}

/// Wireframe1-style board: labeled phones in a row.
class MockupSheet extends StatelessWidget {
  const MockupSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.phones,
  });

  final String title;
  final String subtitle;
  final List<(String, Widget)> phones;

  static Size sizeFor(int count) {
    const pad = 48.0;
    const gap = 28.0;
    const label = 36.0;
    return Size(
      pad * 2 + count * kMockupPhoneSize.width + (count - 1) * gap,
      pad * 2 + 72 + kMockupPhoneSize.height + label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFE8EEF2),
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 28),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < phones.length; i++) ...[
                  if (i > 0) const SizedBox(width: 28),
                  Column(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x33000000),
                              blurRadius: 24,
                              offset: Offset(0, 12),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: phones[i].$2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        phones[i].$1,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
