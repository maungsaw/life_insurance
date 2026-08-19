import 'package:flutter/material.dart';
import 'package:life_insurance/design_mockups/phone_frame.dart';

class GroveScreens {
  static Widget guest() => PhoneFrame(theme: groveTheme, child: const _Guest());
  static Widget login() => PhoneFrame(theme: groveTheme, child: const _Login());
  static Widget otp() => PhoneFrame(theme: groveTheme, child: const _Otp());
  static Widget home() => PhoneFrame(theme: groveTheme, child: const _Home());
  static Widget customer() => PhoneFrame(theme: groveTheme, child: const _Customer());
  static Widget customerDetail() => PhoneFrame(theme: groveTheme, child: const _Detail());
  static Widget tasks() => PhoneFrame(theme: groveTheme, child: const _Tasks());
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.active});
  final String active;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: groveTheme.surface,
          border: Border.all(color: groveTheme.line),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            for (final t in ['Home', 'Work', 'Account'])
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: t == active ? const Color(0xFFF5EFD8) : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    t,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: t == active ? groveTheme.primary : groveTheme.muted,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Guest extends StatelessWidget {
  const _Guest();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 72, 24, 28),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: groveTheme.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [BoxShadow(color: Color(0x144A3267), blurRadius: 24, offset: Offset(0, 8))],
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🌱', style: TextStyle(fontSize: 48)),
                  SizedBox(height: 12),
                  Text('Sell with confidence', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  SizedBox(height: 8),
                  Text(
                    'Quotes, clients, and tasks — built for KBZ LIFE agents in the field.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, height: 1.45),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 20, height: 8, decoration: BoxDecoration(color: groveTheme.primary, borderRadius: BorderRadius.circular(99))),
              const SizedBox(width: 6),
              Container(width: 8, height: 8, decoration: BoxDecoration(color: groveTheme.line, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Container(width: 8, height: 8, decoration: BoxDecoration(color: groveTheme.line, shape: BoxShape.circle)),
            ],
          ),
          const SizedBox(height: 16),
          _Fill('Login or Register', groveTheme.primary),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: groveTheme.line),
              borderRadius: BorderRadius.circular(18),
            ),
            alignment: Alignment.center,
            child: Text('Explore as guest →', style: TextStyle(color: groveTheme.primary, fontWeight: FontWeight.w700)),
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
      padding: const EdgeInsets.fromLTRB(22, 56, 22, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Container(height: 4, decoration: BoxDecoration(color: groveTheme.primary, borderRadius: BorderRadius.circular(99)))),
              const SizedBox(width: 6),
              Expanded(child: Container(height: 4, decoration: BoxDecoration(color: groveTheme.line, borderRadius: BorderRadius.circular(99)))),
              const SizedBox(width: 6),
              Expanded(child: Container(height: 4, decoration: BoxDecoration(color: groveTheme.line, borderRadius: BorderRadius.circular(99)))),
            ],
          ),
          const SizedBox(height: 20),
          Text('Step 1 of 3', style: TextStyle(color: groveTheme.muted, fontSize: 13)),
          const Text('Your agent ID', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: 22),
          const Text('Agent ID / Email', style: TextStyle(fontWeight: FontWeight.w700)),
          Text('We use this to match your hierarchy and commission display.', style: TextStyle(fontSize: 11, color: groveTheme.muted)),
          const SizedBox(height: 8),
          _box('FA-2841'),
          const SizedBox(height: 16),
          const Text('Password', style: TextStyle(fontWeight: FontWeight.w700)),
          Text('Never share your password. KBZ LIFE staff will never ask for it.', style: TextStyle(fontSize: 11, color: groveTheme.muted)),
          const SizedBox(height: 8),
          _box('••••••••'),
          const SizedBox(height: 22),
          _Fill('Continue', groveTheme.primary),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Container(height: 4, decoration: BoxDecoration(color: groveTheme.accent, borderRadius: BorderRadius.circular(99)))),
              const SizedBox(width: 6),
              Expanded(child: Container(height: 4, decoration: BoxDecoration(color: groveTheme.primary, borderRadius: BorderRadius.circular(99)))),
              const SizedBox(width: 6),
              Expanded(child: Container(height: 4, decoration: BoxDecoration(color: groveTheme.line, borderRadius: BorderRadius.circular(99)))),
            ],
          ),
          const SizedBox(height: 16),
          Text('← Back', style: TextStyle(color: groveTheme.primary, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Text('Step 2 of 3', style: TextStyle(color: groveTheme.muted)),
          const Text('Verify your phone', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('Code sent to 09••••••42', style: TextStyle(color: groveTheme.muted, fontSize: 13)),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final d in ['4', '8', '2', '·', '·', '·'])
                Container(
                  width: 44,
                  height: 52,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: d == '·' ? groveTheme.surface : const Color(0xFFF5EFD8),
                    border: Border.all(color: d == '·' ? groveTheme.line : groveTheme.primary, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(d, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                ),
            ],
          ),
          const SizedBox(height: 24),
          _Fill('Verify & continue', groveTheme.primary),
        ],
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
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 52, 20, 12),
            children: [
              Text('Wednesday, 19 Aug', style: TextStyle(color: groveTheme.muted, fontSize: 13)),
              const Text('Hello, Mg Htet', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF4A3267), Color(0xFF6B4F8A)]),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('NEXT BEST STEP', style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 11)),
                    const SizedBox(height: 6),
                    const Text(
                      'Finish e-Application for U Aung — Step 3 of 7',
                      style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800, height: 1.3),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                      child: Text('Continue application', style: TextStyle(color: groveTheme.primary, fontWeight: FontWeight.w800, fontSize: 13)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text('OUR SERVICES', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: groveTheme.muted)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _svc('📝', 'New Proposal', 'Start a quote in 2 min')),
                  const SizedBox(width: 10),
                  Expanded(child: _svc('👥', 'CRM', 'Leads & clients')),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _svc('🧮', 'Calculator', 'Compare premiums')),
                  const SizedBox(width: 10),
                  Expanded(child: _svc('📅', 'My Work', 'Tasks & calendar')),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _stat('20', 'Active', true),
                  _stat('10', 'Pending', false),
                  _stat('5', 'Expired', false),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: groveTheme.surface,
                  border: Border.all(color: groveTheme.line),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Commission (display)', style: TextStyle(fontSize: 11)),
                    Text('726,080 MMK', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: groveTheme.accent,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text('Help me sell', style: TextStyle(color: groveTheme.primary, fontWeight: FontWeight.w800, fontSize: 12)),
            ),
          ),
        ),
        const _Tabs(active: 'Home'),
      ],
    );
  }

  Widget _svc(String ico, String t, String s) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: groveTheme.surface,
        border: Border.all(color: groveTheme.line),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(ico, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 8),
          Text(t, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
          Text(s, style: TextStyle(fontSize: 11, color: groveTheme.muted)),
        ],
      ),
    );
  }

  Widget _stat(String n, String l, bool on) {
    return Column(
      children: [
        Text(n, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: on ? groveTheme.accent : groveTheme.ink)),
        Text(l, style: TextStyle(fontSize: 10, color: groveTheme.muted)),
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
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 52, 20, 12),
            children: [
              const Text('People', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: groveTheme.surface,
                  border: Border.all(color: groveTheme.line),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(color: groveTheme.primary, borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.center,
                        child: const Text('Leads', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
                      ),
                    ),
                    Expanded(
                      child: Text('Clients', textAlign: TextAlign.center, style: TextStyle(color: groveTheme.muted, fontWeight: FontWeight.w700, fontSize: 12)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _person('U Aung Min', 'Warm lead · Quote saved 18 Aug'),
              _person('Daw Khin Aye', 'Client · Premium due in 3 days'),
              _person('Ma Thiri', 'New lead · Needs first contact'),
            ],
          ),
        ),
        const _Tabs(active: 'Work'),
      ],
    );
  }

  Widget _person(String n, String s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: groveTheme.surface,
        border: Border.all(color: groveTheme.line),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(n, style: const TextStyle(fontWeight: FontWeight.w800)),
          Text(s, style: TextStyle(fontSize: 12, color: groveTheme.muted)),
        ],
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 52, 20, 12),
            children: [
              Text('← People', style: TextStyle(color: groveTheme.primary, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text('U Aung Min', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              Text('Lead · Warm', style: TextStyle(color: groveTheme.muted)),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: groveTheme.surface,
                  border: Border.all(color: groveTheme.line),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('QUALIFY CHECKLIST', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: groveTheme.muted)),
                    const SizedBox(height: 10),
                    _ck('Contact details confirmed', true),
                    _ck('Needs assessment done', true),
                    _ck('Quote presented', false),
                    _ck('Objections addressed', false),
                    _ck('Ready to convert', false),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: groveTheme.surface,
                  border: Border.all(color: groveTheme.line),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Suggested next step', style: TextStyle(fontSize: 12, color: groveTheme.muted)),
                    const SizedBox(height: 6),
                    const Text('Schedule follow-up to review Whole Life 20 quote', style: TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const _Tabs(active: 'Work'),
      ],
    );
  }

  Widget _ck(String t, bool done) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(done ? Icons.check_circle : Icons.circle_outlined, size: 18, color: done ? const Color(0xFF3D7A5F) : groveTheme.accent),
          const SizedBox(width: 8),
          Expanded(child: Text(t, style: const TextStyle(fontSize: 13))),
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
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 52, 20, 12),
            children: [
              const Text('My work', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 7,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (final h in ['S', 'M', 'T', 'W', 'T', 'F', 'S'])
                    Center(child: Text(h, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: groveTheme.muted))),
                  for (final d in ['17', '18', '19', '20', '21', '22', '23'])
                    Center(
                      child: Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: d == '19' ? groveTheme.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          d,
                          style: TextStyle(fontWeight: FontWeight.w700, color: d == '19' ? Colors.white : groveTheme.ink),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text('TUESDAY 19 AUG', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: groveTheme.muted)),
              const SizedBox(height: 8),
              _item('09:00 · Team huddle', 'Assigned by AM · 30 min'),
              _item('11:30 · Client visit', 'Daw Khin · Premium collection'),
              _item('15:00 · Submit documents', 'e-App #118 · Due today'),
            ],
          ),
        ),
        const _Tabs(active: 'Work'),
      ],
    );
  }

  Widget _item(String t, String s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: groveTheme.surface,
        border: Border.all(color: groveTheme.line),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t, style: const TextStyle(fontWeight: FontWeight.w800)),
          Text(s, style: TextStyle(fontSize: 12, color: groveTheme.muted)),
        ],
      ),
    );
  }
}

class _Fill extends StatelessWidget {
  const _Fill(this.label, this.color);
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(18)),
      alignment: Alignment.center,
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
    );
  }
}

Widget _box(String v) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    decoration: BoxDecoration(
      color: groveTheme.surface,
      border: Border.all(color: groveTheme.line),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Text(v, style: const TextStyle(fontSize: 15)),
  );
}
