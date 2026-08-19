import 'package:flutter/material.dart';
import 'package:life_insurance/design_mockups/phone_frame.dart';

class AtelierScreens {
  static Widget guest() => PhoneFrame(theme: atelierTheme, child: const _Guest());
  static Widget login() => PhoneFrame(theme: atelierTheme, child: const _Login());
  static Widget otp() => PhoneFrame(theme: atelierTheme, child: const _Otp());
  static Widget home() => PhoneFrame(theme: atelierTheme, child: const _Home());
  static Widget customer() =>
      PhoneFrame(theme: atelierTheme, child: const _Customer());
  static Widget customerDetail() =>
      PhoneFrame(theme: atelierTheme, child: const _Detail());
  static Widget tasks() => PhoneFrame(theme: atelierTheme, child: const _Tasks());
}

class _Guest extends StatelessWidget {
  const _Guest();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 56, 24, 28),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2D6A4F), Color(0xFF1B4332)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'KBZ LIFE Agency',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Grow with purpose.\nPartner with us.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Login or Register',
                  style: TextStyle(
                    color: Color(0xFF1B4332),
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            children: [
              Text(
                'EXPLORE AS GUEST',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w700,
                  color: atelierTheme.muted,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 96,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    _Chip('New Proposal', Icons.note_add_outlined),
                    _Chip('Product', Icons.grid_view_outlined),
                    _Chip('Calculator', Icons.calculate_outlined),
                    _Chip('CRM', Icons.groups_outlined),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.label, this.icon);
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 108,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: atelierTheme.surface,
        border: Border.all(color: atelierTheme.line),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: atelierTheme.primary),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
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
      padding: const EdgeInsets.fromLTRB(22, 64, 22, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome back', style: TextStyle(color: atelierTheme.muted)),
          const Text(
            'Sign in',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Agent tools need your verified login.',
            style: TextStyle(color: atelierTheme.muted, fontSize: 13),
          ),
          const SizedBox(height: 28),
          const _Field('Agent ID / Email', 'FA-2841'),
          const SizedBox(height: 14),
          const _Field('Password', '••••••••'),
          const SizedBox(height: 22),
          _PrimaryBar(label: 'Continue', color: atelierTheme.primary),
          const SizedBox(height: 14),
          Text(
            'Forgot password?',
            style: TextStyle(
              color: atelierTheme.accent,
              fontWeight: FontWeight.w700,
            ),
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
      padding: const EdgeInsets.fromLTRB(22, 56, 22, 24),
      child: SingleChildScrollView(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('← Back', style: TextStyle(fontWeight: FontWeight.w700, color: atelierTheme.primary)),
          const SizedBox(height: 18),
          Text("Verify it's you", style: TextStyle(color: atelierTheme.muted)),
          const Text(
            'Enter OTP',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text('Code sent to 09••••••42', style: TextStyle(color: atelierTheme.muted)),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final d in ['4', '8', '2', '·'])
                Container(
                  width: 58,
                  height: 58,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: d == '·' ? atelierTheme.surface : const Color(0xFFFCEEE9),
                    border: Border.all(
                      color: d == '·' ? atelierTheme.line : atelierTheme.primary,
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    d,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 28),
          _PrimaryBar(label: 'Verify & enter', color: atelierTheme.primary),
          const SizedBox(height: 14),
          Text('Resend code · 0:42', style: TextStyle(color: atelierTheme.accent, fontWeight: FontWeight.w600)),
        ],
        ),
      ),
    );
  }
}

class _Home extends StatelessWidget {
  const _Home();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _TopChips(active: 'Today'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 88),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Wednesday · 19 Aug', style: TextStyle(fontSize: 13)),
                        Text(
                          'Good morning,\nMg Htet',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, height: 1.15),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: atelierTheme.surface,
                      border: Border.all(color: atelierTheme.line),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.notifications_outlined, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _Card(
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Commission (display)', style: TextStyle(fontSize: 11)),
                          Text('726,080 MMK', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                    Text('↑ 4.2%', style: TextStyle(color: atelierTheme.primary, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'TODAY · 3 ITEMS NEED YOU',
                style: TextStyle(fontSize: 11, letterSpacing: 0.8, fontWeight: FontWeight.w700, color: atelierTheme.muted),
              ),
              const SizedBox(height: 10),
              const _TimeRow('10:30', 'Premium due', 'Daw Khin Aye · Policy #8821'),
              const _TimeRow('14:00', 'Follow up lead', 'U Aung Min · Warm · Quote saved'),
              const _TimeRow('Task', 'Submit e-App docs', 'Application #E-2024-118'),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: atelierTheme.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Road to MDRT', style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 11)),
                    const Text('64% of target', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: const LinearProgressIndicator(
                        value: 0.64,
                        minHeight: 6,
                        color: Color(0xFFE07A5F),
                        backgroundColor: Color(0x55FFFFFF),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
          child: _PrimaryBar(label: 'Start quote', color: atelierTheme.primary),
        ),
      ],
    );
  }
}

class _Customer extends StatelessWidget {
  const _Customer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _TopChips(active: 'People'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 88),
            children: [
              const Text('People', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Color(0xFFE07A5F), width: 2)),
                      ),
                      child: const Text('Leads', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ),
                  Expanded(
                    child: Text('Clients', textAlign: TextAlign.center, style: TextStyle(color: atelierTheme.muted, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: atelierTheme.surface,
                  border: Border.all(color: atelierTheme.line),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text('Search name or phone…', style: TextStyle(color: atelierTheme.muted)),
              ),
              const SizedBox(height: 12),
              const _Person('U Aung Min', '09 812 345 67 · Added 12 Aug', 'Warm'),
              const _Person('Daw Khin Aye', '09 421 998 01 · Premium due', 'Client'),
              const _Person('Ma Thiri', '09 555 120 88 · New lead', 'Cold'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
          child: _PrimaryBar(label: 'Add lead', color: atelierTheme.primary),
        ),
      ],
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('← People', style: TextStyle(fontWeight: FontWeight.w700, color: atelierTheme.primary)),
          const SizedBox(height: 12),
          const Text('U Aung Min', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
          Text('Lead · Warm · Last touch 2d ago', style: TextStyle(color: atelierTheme.muted)),
          const SizedBox(height: 16),
          const _Block('Activity', 'Quote saved · Whole Life 20 · 18 Aug'),
          const _Block('Next step', 'Schedule follow-up call · Proposal review'),
          const _Block('Notes', 'Interested in education rider. Prefers MM.'),
          const Spacer(),
          _PrimaryBar(label: 'Convert to client', color: atelierTheme.primary),
        ],
      ),
    );
  }
}

class _Tasks extends StatelessWidget {
  const _Tasks();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _TopChips(active: 'Work'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 88),
            children: [
              const Text('My work', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              Row(
                children: [
                  for (final d in [
                    ('Mon', '18', false),
                    ('Tue', '19', true),
                    ('Wed', '20', false),
                    ('Thu', '21', false),
                    ('Fri', '22', false),
                  ])
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: d.$3 ? atelierTheme.primary : atelierTheme.surface,
                          border: Border.all(color: d.$3 ? atelierTheme.primary : atelierTheme.line),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(d.$1, style: TextStyle(fontSize: 11, color: d.$3 ? Colors.white : atelierTheme.muted)),
                            Text(d.$2, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: d.$3 ? Colors.white : atelierTheme.ink)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text('TIMELINE · TUE 19', style: TextStyle(fontSize: 11, letterSpacing: 0.8, fontWeight: FontWeight.w700, color: atelierTheme.muted)),
              const SizedBox(height: 10),
              const _TimeRow('09:00', 'Team huddle', 'Assigned · 30 min'),
              const _TimeRow('11:30', 'Client visit', 'Daw Khin · Premium collection'),
              const _TimeRow('15:00', 'Submit documents', 'e-App #118 · Due today'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
          child: _PrimaryBar(label: 'Add task', color: atelierTheme.primary),
        ),
      ],
    );
  }
}

class _TopChips extends StatelessWidget {
  const _TopChips({required this.active});
  final String active;

  @override
  Widget build(BuildContext context) {
    const labels = ['Today', 'People', 'Sell', 'Me', 'Work'];
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 48, 12, 10),
      decoration: BoxDecoration(
        color: atelierTheme.surface,
        border: Border(bottom: BorderSide(color: atelierTheme.line)),
      ),
      child: Row(
        children: [
          for (final l in labels.take(4))
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: l == active || (active == 'Work' && l == 'Me') ? atelierTheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  active == 'Work' && l == 'Me' ? 'Work' : l,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: (l == active || (active == 'Work' && l == 'Me')) ? Colors.white : atelierTheme.muted,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: atelierTheme.muted)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: atelierTheme.surface,
            border: Border.all(color: atelierTheme.line),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(value, style: const TextStyle(fontSize: 15)),
        ),
      ],
    );
  }
}

class _PrimaryBar extends StatelessWidget {
  const _PrimaryBar({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
      alignment: Alignment.center,
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: atelierTheme.surface,
        border: Border.all(color: atelierTheme.line),
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }
}

class _TimeRow extends StatelessWidget {
  const _TimeRow(this.time, this.title, this.sub);
  final String time;
  final String title;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: _Card(
        child: Row(
          children: [
            SizedBox(
              width: 48,
              child: Text(time, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: atelierTheme.accent)),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                  Text(sub, style: TextStyle(fontSize: 12, color: atelierTheme.muted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Person extends StatelessWidget {
  const _Person(this.name, this.sub, this.pill);
  final String name;
  final String sub;
  final String pill;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: _Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
            Text(sub, style: TextStyle(fontSize: 12, color: atelierTheme.muted)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFCEEE9),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(pill, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: atelierTheme.accent)),
            ),
          ],
        ),
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block(this.h, this.body);
  final String h;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: _Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(h.toUpperCase(), style: TextStyle(fontSize: 11, letterSpacing: 0.6, color: atelierTheme.muted, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(body, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
