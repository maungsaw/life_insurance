import 'package:flutter/material.dart';
import 'package:life_insurance/design_mockups/phone_frame.dart';

class SignalScreens {
  static Widget guest() =>
      PhoneFrame(theme: signalTheme, statusOnDark: true, child: const _Guest());
  static Widget login() =>
      PhoneFrame(theme: signalTheme, statusOnDark: true, child: const _Login());
  static Widget otp() =>
      PhoneFrame(theme: signalTheme, statusOnDark: true, child: const _Otp());
  static Widget home() =>
      PhoneFrame(theme: signalTheme, statusOnDark: true, child: const _Home());
  static Widget customer() =>
      PhoneFrame(theme: signalTheme, statusOnDark: true, child: const _Customer());
  static Widget customerDetail() =>
      PhoneFrame(theme: signalTheme, statusOnDark: true, child: const _Detail());
  static Widget tasks() =>
      PhoneFrame(theme: signalTheme, statusOnDark: true, child: const _Tasks());
}

class _Rail extends StatelessWidget {
  const _Rail({required this.active, required this.child});
  final int active;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    const icons = [
      Icons.home_outlined,
      Icons.person_outline,
      Icons.diamond_outlined,
      Icons.check_box_outlined,
      Icons.settings_outlined,
    ];
    return Row(
      children: [
        Container(
          width: 52,
          color: signalTheme.surface,
          padding: const EdgeInsets.only(top: 48),
          child: Column(
            children: [
              for (var i = 0; i < icons.length; i++)
                Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: i == active ? const Color(0xFF21262D) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: i == active ? Border.all(color: signalTheme.line) : null,
                  ),
                  child: Icon(
                    icons[i],
                    size: 20,
                    color: i == active ? signalTheme.primary : signalTheme.muted,
                  ),
                ),
            ],
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.child, this.pad = const EdgeInsets.all(12)});
  final Widget child;
  final EdgeInsets pad;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: pad,
      decoration: BoxDecoration(
        color: signalTheme.surface,
        border: Border.all(color: signalTheme.line),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}

class _Guest extends StatelessWidget {
  const _Guest();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 52, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
          Row(
            children: [
              const Text('KBZ LIFE', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF21262D),
                  border: Border.all(color: signalTheme.line),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('⌘ Search', style: TextStyle(fontSize: 11, color: signalTheme.muted)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Tile(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CALCULATOR · LIVE', style: TextStyle(fontSize: 10, letterSpacing: 0.6, color: signalTheme.muted)),
                const SizedBox(height: 6),
                const Text('Try premium estimate', style: TextStyle(fontWeight: FontWeight.w700)),
                Text('Guest mode · save needs login', style: TextStyle(fontSize: 11, color: signalTheme.muted)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              _Tile(
                child: Text('Commission · CRM · Tasks', style: TextStyle(color: signalTheme.muted)),
              ),
              Positioned.fill(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xB00D1117),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('🔒  Login to unlock', style: TextStyle(color: signalTheme.primary, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              _Tile(child: Text('Proposal · e-App', style: TextStyle(color: signalTheme.muted))),
              Positioned.fill(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xB00D1117),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('🔒  Partner tools', style: TextStyle(color: signalTheme.primary, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(color: signalTheme.primary, borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.center,
            child: Text('Agent login', style: TextStyle(color: signalTheme.onPrimary, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}

class _Login extends StatelessWidget {
  const _Login();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 64, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Agent access', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          Text('Step 1 · Identity', style: TextStyle(color: signalTheme.muted, fontSize: 12)),
          const SizedBox(height: 24),
          Text('AGENT ID', style: TextStyle(fontSize: 11, color: signalTheme.muted)),
          const SizedBox(height: 8),
          _Tile(child: const Text('FA-2841')),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(color: signalTheme.primary, borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.center,
            child: Text('Continue →', style: TextStyle(color: signalTheme.onPrimary, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}

class _Otp extends StatelessWidget {
  const _Otp();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text('← Back', style: TextStyle(color: signalTheme.primary, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 16),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Enter PIN', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('SMS OTP · 09••••42', style: TextStyle(color: signalTheme.muted, fontSize: 12)),
          ),
          const SizedBox(height: 20),
          const Text('••••', style: TextStyle(fontSize: 28, letterSpacing: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              for (final n in ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', '✓'])
                Container(
                  width: 64,
                  height: 64,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: n.isEmpty ? Colors.transparent : signalTheme.surface,
                    border: n.isEmpty ? null : Border.all(color: signalTheme.line),
                  ),
                  child: Text(
                    n,
                    style: TextStyle(
                      fontSize: n == '✓' ? 18 : 20,
                      fontWeight: FontWeight.w700,
                      color: n == '✓' ? signalTheme.primary : signalTheme.ink,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Home extends StatelessWidget {
  const _Home();

  @override
  Widget build(BuildContext context) {
    return _Rail(
      active: 0,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 52, 12, 24),
        children: [
          Row(
            children: [
              const Text('Portfolio', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              const Spacer(),
              Text('⌘K', style: TextStyle(fontSize: 11, color: signalTheme.muted)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _kpi('FYP', '82%', '↑ vs target')),
              const SizedBox(width: 8),
              Expanded(child: _kpi('MDRT', '64%', 'On track')),
            ],
          ),
          const SizedBox(height: 8),
          _Tile(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PROPOSAL PULSE', style: TextStyle(fontSize: 10, color: signalTheme.muted)),
                const SizedBox(height: 8),
                const SizedBox(
                  height: 32,
                  width: double.infinity,
                  child: CustomPaint(painter: _SparkPainter()),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _alert('3 FA below target', const Color(0xFFF85149))),
              const SizedBox(width: 8),
              Expanded(child: _alert('5 premiums due', signalTheme.accent)),
            ],
          ),
          const SizedBox(height: 8),
          _Tile(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('COMMISSION', style: TextStyle(fontSize: 10, color: signalTheme.muted)),
                const Text('726,080', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                Text('MMK · display only', style: TextStyle(fontSize: 11, color: signalTheme.muted)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text('QUICK', style: TextStyle(fontSize: 10, color: signalTheme.muted)),
          const SizedBox(height: 8),
          Row(
            children: [
              for (final x in [('Quote', Icons.add), ('Lead', Icons.circle_outlined), ('Call', Icons.call_outlined), ('Export', Icons.download_outlined)])
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: _Tile(
                      pad: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        children: [
                          Icon(x.$2, size: 18, color: signalTheme.primary),
                          const SizedBox(height: 4),
                          Text(x.$1, style: TextStyle(fontSize: 9, color: signalTheme.muted, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _kpi(String l, String v, String d) {
    return _Tile(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l, style: TextStyle(fontSize: 10, color: signalTheme.muted)),
          Text(v, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          Text(d, style: TextStyle(fontSize: 11, color: signalTheme.primary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _alert(String t, Color c) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: c),
        borderRadius: BorderRadius.circular(10),
        color: signalTheme.surface,
      ),
      child: Text(t, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: c)),
    );
  }
}

class _SparkPainter extends CustomPainter {
  const _SparkPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xFF2DD4BF)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(0, size.height * 0.75)
      ..lineTo(size.width * 0.16, size.height * 0.55)
      ..lineTo(size.width * 0.33, size.height * 0.68)
      ..lineTo(size.width * 0.5, size.height * 0.25)
      ..lineTo(size.width * 0.66, size.height * 0.42)
      ..lineTo(size.width * 0.83, size.height * 0.18)
      ..lineTo(size.width, size.height * 0.35);
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Customer extends StatelessWidget {
  const _Customer();

  @override
  Widget build(BuildContext context) {
    return _Rail(
      active: 1,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 52, 12, 24),
        children: [
          const Text('CRM', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          const SizedBox(height: 12),
          Row(
            children: [
              _pill('Leads', true),
              const SizedBox(width: 6),
              _pill('Clients', false),
              const SizedBox(width: 6),
              _pill('Hot', false),
            ],
          ),
          const SizedBox(height: 12),
          _row('U Aung Min', 'Warm · Quote saved', '→'),
          _row('Daw Khin Aye', 'Client · Due 3d', '!'),
          _row('Ma Thiri', 'Cold · 5d idle', '—'),
        ],
      ),
    );
  }

  Widget _pill(String t, bool on) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: on ? signalTheme.primary : signalTheme.line),
        borderRadius: BorderRadius.circular(99),
        color: signalTheme.surface,
      ),
      child: Text(t, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: on ? signalTheme.primary : signalTheme.muted)),
    );
  }

  Widget _row(String n, String s, String t) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: _Tile(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(n, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  Text(s, style: TextStyle(fontSize: 11, color: signalTheme.muted)),
                ],
              ),
            ),
            Text(t, style: TextStyle(color: signalTheme.primary, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail();

  @override
  Widget build(BuildContext context) {
    return _Rail(
      active: 1,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 52, 12, 24),
        children: [
          Text('← CRM', style: TextStyle(color: signalTheme.primary, fontWeight: FontWeight.w700, fontSize: 12)),
          const SizedBox(height: 8),
          const Text('U Aung Min', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _mini('Profile', true),
              _mini('Activity', false),
              _mini('Policies', false),
            ],
          ),
          const SizedBox(height: 10),
          _Tile(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('STAGE', style: TextStyle(fontSize: 10, color: signalTheme.muted)),
                const Text('Warm lead', style: TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _Tile(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('LAST QUOTE', style: TextStyle(fontSize: 10, color: signalTheme.muted)),
                const Text('Whole Life 20 · 18 Aug', style: TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _Tile(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SIGNAL', style: TextStyle(fontSize: 10, color: signalTheme.muted)),
                Text('Follow up within 48h', style: TextStyle(fontWeight: FontWeight.w700, color: signalTheme.primary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mini(String t, bool on) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: on ? signalTheme.primary : signalTheme.line),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(t, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: on ? signalTheme.primary : signalTheme.muted)),
    );
  }
}

class _Tasks extends StatelessWidget {
  const _Tasks();

  @override
  Widget build(BuildContext context) {
    return _Rail(
      active: 3,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 52, 12, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tasks', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 12),
            SizedBox(
              height: 280,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _lane('TODAY · 3', ['Submit e-App docs', 'Call Daw Khin', 'Team huddle 09:00']),
                  _lane('THIS WEEK · 5', ['Recruitment review', 'MDRT check-in']),
                  _lane('DONE', ['Quote sent · U Aung']),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lane(String h, List<String> cards) {
    return SizedBox(
      width: 140,
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(h, style: TextStyle(fontSize: 10, color: signalTheme.muted, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            for (final c in cards)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF21262D),
                    border: Border.all(color: signalTheme.line),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(c, style: const TextStyle(fontSize: 11)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
