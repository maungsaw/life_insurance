import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors, LocalizationContext;
import '../bloc/bloc.dart' show AppearanceBloc, ChangeLocaleEvent;

/// Language picker — English / Myanmar cards (docs/50 · Agent Profile.png).
class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final current = context.watch<AppearanceBloc>().state.locale.languageCode;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          context.tr.language,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.lightTextPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _LanguageCard(
            label: 'English',
            selected: current == 'en',
            flag: const _UkFlag(),
            onTap: () => context.read<AppearanceBloc>().add(
              const ChangeLocaleEvent(Locale('en')),
            ),
          ),
          const SizedBox(height: 12),
          _LanguageCard(
            label: 'Myanmar',
            selected: current == 'my',
            flag: const _MyanmarFlag(),
            onTap: () => context.read<AppearanceBloc>().add(
              const ChangeLocaleEvent(Locale('my')),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.label,
    required this.selected,
    required this.flag,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Widget flag;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: selected ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              flag,
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
              ),
              if (selected)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.lightPrimary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UkFlag extends StatelessWidget {
  const _UkFlag();

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: 40,
        height: 40,
        child: CustomPaint(painter: _UkFlagPainter()),
      ),
    );
  }
}

class _UkFlagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..color = const Color(0xFF012169));
    final white = Paint()
      ..color = Colors.white
      ..strokeWidth = size.height * 0.22
      ..style = PaintingStyle.stroke;
    final red = Paint()
      ..color = const Color(0xFFC8102E)
      ..strokeWidth = size.height * 0.12
      ..style = PaintingStyle.stroke;
    canvas.drawLine(rect.topLeft, rect.bottomRight, white);
    canvas.drawLine(rect.topRight, rect.bottomLeft, white);
    canvas.drawLine(rect.topLeft, rect.bottomRight, red);
    canvas.drawLine(rect.topRight, rect.bottomLeft, red);
    canvas.drawRect(
      Rect.fromCenter(
        center: rect.center,
        width: size.width * 0.22,
        height: size.height,
      ),
      Paint()..color = Colors.white,
    );
    canvas.drawRect(
      Rect.fromCenter(
        center: rect.center,
        width: size.width,
        height: size.height * 0.22,
      ),
      Paint()..color = Colors.white,
    );
    canvas.drawRect(
      Rect.fromCenter(
        center: rect.center,
        width: size.width * 0.12,
        height: size.height,
      ),
      Paint()..color = const Color(0xFFC8102E),
    );
    canvas.drawRect(
      Rect.fromCenter(
        center: rect.center,
        width: size.width,
        height: size.height * 0.12,
      ),
      Paint()..color = const Color(0xFFC8102E),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MyanmarFlag extends StatelessWidget {
  const _MyanmarFlag();

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: 40,
        height: 40,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              children: const [
                Expanded(child: ColoredBox(color: Color(0xFFFECB00))),
                Expanded(child: ColoredBox(color: Color(0xFF34B233))),
                Expanded(child: ColoredBox(color: Color(0xFFEA2839))),
              ],
            ),
            const Center(
              child: Icon(Icons.star, color: Colors.white, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}
