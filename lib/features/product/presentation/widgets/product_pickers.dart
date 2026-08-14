import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/product/presentation/widgets/product_widgets.dart';

/// Height · Weight · Identification bottom sheets (docs/59 P1 · wireframe pickers).

class HeightPick {
  const HeightPick({required this.feet, required this.inches});

  final int feet;
  final int inches;

  String get label => "$feet' $inches\"";
}

class WeightPick {
  const WeightPick({required this.whole, required this.tenth});

  final int whole;
  final int tenth;

  String get label => '$whole.$tenth';
}

class IdPick {
  const IdPick({
    required this.type,
    this.state,
    this.township,
    this.nrcType,
    this.number,
  });

  final String type;
  final String? state;
  final String? township;
  final String? nrcType;
  final String? number;

  String get display {
    if (type == 'NRC' || type == 'Old NRC') {
      final s = state ?? '12';
      final t = township ?? 'KaMaNa';
      final n = nrcType ?? 'N';
      final num = number ?? '';
      return '$s/$t($n)$num';
    }
    if (type == 'Passport') return number ?? '';
    return 'No ID';
  }
}

Future<HeightPick?> showHeightPickerSheet(
  BuildContext context, {
  HeightPick? initial,
}) {
  return showModalBottomSheet<HeightPick>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _HeightSheet(initial: initial),
  );
}

Future<WeightPick?> showWeightPickerSheet(
  BuildContext context, {
  WeightPick? initial,
}) {
  return showModalBottomSheet<WeightPick>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _WeightSheet(initial: initial),
  );
}

Future<IdPick?> showIdentificationPickerSheet(
  BuildContext context, {
  IdPick? initial,
}) {
  return showModalBottomSheet<IdPick>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _IdSheet(initial: initial),
  );
}

class _HeightSheet extends StatefulWidget {
  const _HeightSheet({this.initial});

  final HeightPick? initial;

  @override
  State<_HeightSheet> createState() => _HeightSheetState();
}

class _HeightSheetState extends State<_HeightSheet> {
  late int _feet;
  late int _inches;
  late final FixedExtentScrollController _feetCtrl;
  late final FixedExtentScrollController _inchCtrl;

  @override
  void initState() {
    super.initState();
    _feet = widget.initial?.feet ?? 5;
    _inches = widget.initial?.inches ?? 7;
    _feetCtrl = FixedExtentScrollController(initialItem: (_feet - 2).clamp(0, 6));
    _inchCtrl = FixedExtentScrollController(initialItem: _inches.clamp(0, 11));
  }

  @override
  void dispose() {
    _feetCtrl.dispose();
    _inchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Your Height',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoStylePicker(
                      controller: _feetCtrl,
                      itemCount: 7,
                      labelAt: (i) => "${i + 2}'",
                      onSelected: (i) => setState(() => _feet = i + 2),
                    ),
                  ),
                  Expanded(
                    child: CupertinoStylePicker(
                      controller: _inchCtrl,
                      itemCount: 12,
                      labelAt: (i) => '$i"',
                      onSelected: (i) => setState(() => _inches = i),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      'ft-in',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Done',
              onPressed: () => Navigator.pop(
                context,
                HeightPick(feet: _feet, inches: _inches),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeightSheet extends StatefulWidget {
  const _WeightSheet({this.initial});

  final WeightPick? initial;

  @override
  State<_WeightSheet> createState() => _WeightSheetState();
}

class _WeightSheetState extends State<_WeightSheet> {
  late int _whole;
  late int _tenth;
  late final FixedExtentScrollController _wholeCtrl;
  late final FixedExtentScrollController _tenthCtrl;

  static const _min = 70;
  static const _max = 250;

  @override
  void initState() {
    super.initState();
    _whole = (widget.initial?.whole ?? 105).clamp(_min, _max);
    _tenth = widget.initial?.tenth ?? 0;
    _wholeCtrl = FixedExtentScrollController(initialItem: _whole - _min);
    _tenthCtrl = FixedExtentScrollController(initialItem: _tenth.clamp(0, 9));
  }

  @override
  void dispose() {
    _wholeCtrl.dispose();
    _tenthCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Your Weight',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoStylePicker(
                      controller: _wholeCtrl,
                      itemCount: _max - _min + 1,
                      labelAt: (i) => '${_min + i}',
                      onSelected: (i) => setState(() => _whole = _min + i),
                    ),
                  ),
                  Expanded(
                    child: CupertinoStylePicker(
                      controller: _tenthCtrl,
                      itemCount: 10,
                      labelAt: (i) => '.$i',
                      onSelected: (i) => setState(() => _tenth = i),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      'lb-oz',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Done',
              onPressed: () => Navigator.pop(
                context,
                WeightPick(whole: _whole, tenth: _tenth),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IdSheet extends StatefulWidget {
  const _IdSheet({this.initial});

  final IdPick? initial;

  @override
  State<_IdSheet> createState() => _IdSheetState();
}

class _IdSheetState extends State<_IdSheet> {
  late String _type;
  late String _state;
  late String _township;
  late String _nrcType;
  late final TextEditingController _number;

  static const _types = ['NRC', 'Old NRC', 'Passport', 'No ID'];
  static const _states = ['12', '9', '5', '7', '1'];
  static const _townships = ['KaMaNa', 'PaZaTa', 'LaMaNa', 'AhGaYa'];
  static const _nrcTypes = ['N', 'P', 'E'];

  @override
  void initState() {
    super.initState();
    _type = widget.initial?.type ?? 'NRC';
    _state = widget.initial?.state ?? '12';
    _township = widget.initial?.township ?? 'KaMaNa';
    _nrcType = widget.initial?.nrcType ?? 'N';
    _number = TextEditingController(text: widget.initial?.number ?? '127487');
  }

  @override
  void dispose() {
    _number.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showNrc = _type == 'NRC' || _type == 'Old NRC';
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          16 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Identification',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final t in _types)
                    SizedBox(
                      width: (MediaQuery.sizeOf(context).width - 56) / 2,
                      child: ProductSelectChip(
                        label: t,
                        selected: _type == t,
                        onTap: () => setState(() => _type = t),
                      ),
                    ),
                ],
              ),
              if (showNrc) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _MiniDrop(
                        label: 'State',
                        value: _state,
                        options: _states,
                        onPick: (v) => setState(() => _state = v),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _MiniDrop(
                        label: 'Township',
                        value: _township,
                        options: _townships,
                        onPick: (v) => setState(() => _township = v),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _MiniDrop(
                        label: 'Type',
                        value: _nrcType,
                        options: _nrcTypes,
                        onPick: (v) => setState(() => _nrcType = v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'NRC Number',
                  controller: _number,
                  keyboardType: TextInputType.number,
                ),
              ] else if (_type == 'Passport') ...[
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Passport Number',
                  controller: _number,
                ),
              ],
              const SizedBox(height: 16),
              AppButton(
                label: 'Done',
                onPressed: () => Navigator.pop(
                  context,
                  IdPick(
                    type: _type,
                    state: showNrc ? _state : null,
                    township: showNrc ? _township : null,
                    nrcType: showNrc ? _nrcType : null,
                    number: _type == 'No ID' ? null : _number.text.trim(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniDrop extends StatelessWidget {
  const _MiniDrop({
    required this.label,
    required this.value,
    required this.options,
    required this.onPick,
  });

  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showModalBottomSheet<String>(
          context: context,
          showDragHandle: true,
          builder: (ctx) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final o in options)
                  ListTile(
                    title: Text(o),
                    trailing: o == value
                        ? const Icon(Icons.check, color: AppColors.lightPrimary)
                        : null,
                    onTap: () => Navigator.pop(ctx, o),
                  ),
              ],
            ),
          ),
        );
        if (picked != null) onPick(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ),
        child: Text(value, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}

/// Dual-column wheel with primary highlight band (wireframe picker look).
class CupertinoStylePicker extends StatelessWidget {
  const CupertinoStylePicker({
    super.key,
    required this.controller,
    required this.itemCount,
    required this.labelAt,
    required this.onSelected,
  });

  final FixedExtentScrollController controller;
  final int itemCount;
  final String Function(int index) labelAt;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final selected = controller.hasClients
            ? controller.selectedItem
            : controller.initialItem;
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.lightPrimary,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            ListWheelScrollView.useDelegate(
              controller: controller,
              itemExtent: 40,
              perspective: 0.002,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: onSelected,
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: itemCount,
                builder: (context, index) {
                  final on = index == selected;
                  return Center(
                    child: Text(
                      labelAt(index),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: on
                            ? Colors.white
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Simple signature pad — finger draw on white canvas.
class SignaturePad extends StatefulWidget {
  const SignaturePad({
    super.key,
    required this.label,
    required this.onChanged,
  });

  final String label;
  final ValueChanged<bool> onChanged;

  @override
  State<SignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  final _points = <Offset?>[];
  bool _hasInk = false;

  void _clear() {
    setState(() {
      _points.clear();
      _hasInk = false;
    });
    widget.onChanged(false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.label,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            TextButton(onPressed: _clear, child: const Text('Clear')),
          ],
        ),
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.lightBorder),
          ),
          child: GestureDetector(
            onPanStart: (d) {
              setState(() {
                _points.add(d.localPosition);
                _hasInk = true;
              });
              widget.onChanged(true);
            },
            onPanUpdate: (d) => setState(() => _points.add(d.localPosition)),
            onPanEnd: (_) => setState(() => _points.add(null)),
            child: CustomPaint(
              painter: _SigPainter(_points),
              size: Size.infinite,
            ),
          ),
        ),
        if (!_hasInk)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              'Draw signature above',
              style: TextStyle(fontSize: 11, color: AppColors.lightTextHint),
            ),
          ),
      ],
    );
  }
}

class _SigPainter extends CustomPainter {
  _SigPainter(this.points);

  final List<Offset?> points;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.lightTextPrimary
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < points.length - 1; i++) {
      final a = points[i];
      final b = points[i + 1];
      if (a != null && b != null) canvas.drawLine(a, b, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SigPainter oldDelegate) => true;
}
