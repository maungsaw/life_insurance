import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;
import 'package:life_insurance/features/components/components.dart';

/// Height · Weight · Identification bottom sheets (docs/59 · docs/62 · docs/93).

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

  /// Stored on Policyholder / Confirm — decimal pounds, not ounces.
  String get label => '$whole.$tenth';

  String get sheetPreview => '$label lb';
}

class IdPick {
  const IdPick({
    required this.type,
    this.state,
    this.township,
    this.nrcType,
    this.number,
  });

  /// NRC · Old NRC · Passport · No ID
  final String type;
  final String? state;
  final String? township;
  final String? nrcType;
  final String? number;

  bool get isNrcFamily => type == 'NRC' || type == 'Old NRC';

  String get display {
    if (isNrcFamily) {
      final s = state ?? '12';
      final t = township ?? 'KaMaNa';
      final n = nrcType ?? 'N';
      final num = number ?? '';
      return '$s/$t($n)$num';
    }
    if (type == 'Passport') return number ?? '';
    return 'No ID';
  }

  /// Parse `12/KaMaNa(N)127487` · passport · No ID back into parts.
  static IdPick parse({required String idType, required String raw}) {
    final t = raw.trim();
    if (idType == 'No ID' || t == 'No ID' || t.isEmpty && idType == 'No ID') {
      return const IdPick(type: 'No ID');
    }
    if (idType == 'Passport') {
      return IdPick(type: 'Passport', number: t);
    }
    final type = idType == 'Old NRC' ? 'Old NRC' : 'NRC';
    final re = RegExp(
      r'^(\d+)\s*/\s*([A-Za-z]+)\s*\(\s*([A-Za-z])\s*\)\s*(\d*)$',
    );
    final m = re.firstMatch(t.replaceAll(' ', ''));
    if (m != null) {
      return IdPick(
        type: type,
        state: m.group(1),
        township: m.group(2),
        nrcType: m.group(3)?.toUpperCase(),
        number: m.group(4),
      );
    }
    // Fallback: treat whole string as serial if already on NRC type.
    return IdPick(
      type: type,
      state: '12',
      township: 'KaMaNa',
      nrcType: 'N',
      number: t,
    );
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
    backgroundColor: AppColors.surface(context),
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
    backgroundColor: AppColors.surface(context),
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
    backgroundColor: AppColors.surface(context),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _IdSheet(initial: initial),
  );
}

class _MeasureSheetChrome extends StatelessWidget {
  const _MeasureSheetChrome({
    required this.title,
    required this.preview,
    required this.leftHeader,
    required this.rightHeader,
    required this.leftWheel,
    required this.rightWheel,
    required this.onDone,
  });

  final String title;
  final String preview;
  final String leftHeader;
  final String rightHeader;
  final Widget leftWheel;
  final Widget rightWheel;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    Widget header(String text) {
      return Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13,
          color: AppColors.onSurfaceSecondary(context),
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface(context),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              preview,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.lightPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: header(leftHeader)),
                const SizedBox(width: 16),
                Expanded(child: header(rightHeader)),
              ],
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 220,
              child: Row(
                children: [
                  Expanded(child: leftWheel),
                  const SizedBox(width: 16),
                  Expanded(child: rightWheel),
                ],
              ),
            ),
            const SizedBox(height: 20),
            AppButton(label: 'Done', onPressed: onDone),
          ],
        ),
      ),
    );
  }
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
    _feetCtrl = FixedExtentScrollController(
      initialItem: (_feet - 2).clamp(0, 6),
    );
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
    final pick = HeightPick(feet: _feet, inches: _inches);
    return _MeasureSheetChrome(
      title: 'Select Your Height',
      preview: pick.label,
      leftHeader: 'ft',
      rightHeader: 'in',
      leftWheel: CupertinoStylePicker(
        controller: _feetCtrl,
        itemCount: 7,
        labelAt: (i) => "${i + 2}'",
        onSelected: (i) => setState(() => _feet = i + 2),
      ),
      rightWheel: CupertinoStylePicker(
        controller: _inchCtrl,
        itemCount: 12,
        labelAt: (i) => '$i"',
        onSelected: (i) => setState(() => _inches = i),
      ),
      onDone: () => Navigator.pop(context, pick),
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
    final pick = WeightPick(whole: _whole, tenth: _tenth);
    return _MeasureSheetChrome(
      title: 'Select Your Weight',
      preview: pick.sheetPreview,
      leftHeader: 'lb',
      rightHeader: '.0',
      leftWheel: CupertinoStylePicker(
        controller: _wholeCtrl,
        itemCount: _max - _min + 1,
        labelAt: (i) => '${_min + i}',
        onSelected: (i) => setState(() => _whole = _min + i),
      ),
      rightWheel: CupertinoStylePicker(
        controller: _tenthCtrl,
        itemCount: 10,
        labelAt: (i) => '.$i',
        onSelected: (i) => setState(() => _tenth = i),
      ),
      onDone: () => Navigator.pop(context, pick),
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
  static const _states = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
  ];
  static const _townships = [
    'KaMaNa',
    'PaZaTa',
    'LaMaNa',
    'AhGaYa',
    'SaKaNa',
    'YaKaNa',
  ];
  static const _nrcTypes = ['N', 'P', 'E'];

  @override
  void initState() {
    super.initState();
    final init = widget.initial ?? const IdPick(type: 'NRC');
    _type = init.type;
    _state = init.state ?? '12';
    _township = init.township ?? 'KaMaNa';
    _nrcType = init.nrcType ?? 'N';
    _number = TextEditingController(text: init.number ?? '');
  }

  @override
  void dispose() {
    _number.dispose();
    super.dispose();
  }

  IdPick get _draft => IdPick(
    type: _type,
    state: _isNrc ? _state : null,
    township: _isNrc ? _township : null,
    nrcType: _isNrc ? _nrcType : null,
    number: _type == 'No ID' ? null : _number.text.trim(),
  );

  bool get _isNrc => _type == 'NRC' || _type == 'Old NRC';

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface(context),
      child: SafeArea(
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 14),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2.6,
                  children: [
                    for (final t in _types)
                      _IdTypeTile(
                        label: t,
                        selected: _type == t,
                        onTap: () => setState(() => _type = t),
                      ),
                  ],
                ),
                if (_isNrc) ...[
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: _OutlinedDrop(
                          label: 'State',
                          value: _state,
                          options: _states,
                          onPick: (v) => setState(() => _state = v),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _OutlinedDrop(
                          label: 'Township',
                          value: _township,
                          options: _townships,
                          onPick: (v) => setState(() => _township = v),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _OutlinedDrop(
                          label: 'Type',
                          value: _nrcType,
                          options: _nrcTypes,
                          onPick: (v) => setState(() => _nrcType = v),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _draft.display,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.hint(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: 'NRC Number',
                    controller: _number,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                ] else if (_type == 'Passport') ...[
                  const SizedBox(height: 18),
                  AppTextField(label: 'Passport Number', controller: _number),
                ] else ...[
                  const SizedBox(height: 18),
                  Text(
                    'No identification on file for this person.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.onSurfaceSecondary(context),
                      height: 1.35,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                AppButton(
                  label: 'Done',
                  onPressed: () => Navigator.pop(context, _draft),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IdTypeTile extends StatelessWidget {
  const _IdTypeTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.surface(context)
          : AppColors.mutedFill(context),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected ? AppColors.lightPrimary : Colors.transparent,
                  width: selected ? 1.6 : 0,
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: selected
                      ? AppColors.lightPrimary
                      : AppColors.onSurface(context),
                ),
              ),
            ),
            if (selected)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    color: AppColors.lightPrimary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _OutlinedDrop extends StatelessWidget {
  const _OutlinedDrop({
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
          backgroundColor: AppColors.surface(context),
          builder: (ctx) => SafeArea(
            child: ListView(
              shrinkWrap: true,
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
      borderRadius: BorderRadius.circular(10),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: AppColors.lightPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
          contentPadding: const EdgeInsets.fromLTRB(12, 14, 4, 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.lightPrimary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.lightPrimary),
          ),
        ),
        child: Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ),
    );
  }
}

/// Dual-column wheel with an inset primary pill so neighbour columns do not fuse (docs/93).
class CupertinoStylePicker extends StatelessWidget {
  const CupertinoStylePicker({
    super.key,
    required this.controller,
    required this.itemCount,
    required this.labelAt,
    required this.onSelected,
  });

  static const itemExtent = 48.0;
  static const highlightInset = 8.0;

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
              height: itemExtent,
              margin: const EdgeInsets.symmetric(horizontal: highlightInset),
              decoration: BoxDecoration(
                color: AppColors.lightPrimary,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            ListWheelScrollView.useDelegate(
              controller: controller,
              itemExtent: itemExtent,
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
                            : AppColors.onSurfaceSecondary(context),
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

/// Isolated signature pad — clip to box · sequential lock (docs/91).
class SignaturePad extends StatefulWidget {
  const SignaturePad({
    super.key,
    required this.label,
    required this.onChanged,
    this.enabled = true,
    this.lockedHint = 'Sign the previous box first',
  });

  final String label;
  final ValueChanged<bool> onChanged;
  final bool enabled;
  final String lockedHint;

  @override
  State<SignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  static const _padHeight = 120.0;
  static const _minPoints = 8;
  static const _minPath = 40.0;

  final _points = <Offset?>[];
  bool _hasInk = false;
  Size _size = const Size(1, _padHeight);

  bool _inside(Offset p) {
    return p.dx >= 0 &&
        p.dy >= 0 &&
        p.dx <= _size.width &&
        p.dy <= _size.height;
  }

  double _pathLength() {
    var len = 0.0;
    for (var i = 0; i < _points.length - 1; i++) {
      final a = _points[i];
      final b = _points[i + 1];
      if (a != null && b != null) len += (b - a).distance;
    }
    return len;
  }

  bool _isValidInk() {
    final n = _points.whereType<Offset>().length;
    return n >= _minPoints || _pathLength() >= _minPath;
  }

  void _emitInk() {
    final next = _isValidInk();
    if (next == _hasInk) return;
    _hasInk = next;
    widget.onChanged(next);
  }

  void _clear() {
    setState(() {
      _points.clear();
      _hasInk = false;
    });
    widget.onChanged(false);
  }

  void _start(Offset p) {
    if (!widget.enabled || !_inside(p)) return;
    setState(() => _points.add(p));
  }

  void _move(Offset p) {
    if (!widget.enabled) return;
    setState(() {
      if (!_inside(p)) {
        if (_points.isNotEmpty && _points.last != null) _points.add(null);
        return;
      }
      _points.add(p);
    });
    _emitInk();
  }

  void _end() {
    if (!widget.enabled) return;
    setState(() => _points.add(null));
    _emitInk();
  }

  @override
  void didUpdateWidget(covariant SignaturePad oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled && !widget.enabled && _points.isNotEmpty) {
      _clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final locked = !widget.enabled;
    final border = locked
        ? AppColors.border(context)
        : (_hasInk ? AppColors.success(context) : AppColors.border(context));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: locked ? AppColors.hint(context) : null,
                ),
              ),
            ),
            TextButton(
              onPressed: locked ? null : _clear,
              child: const Text('Clear'),
            ),
          ],
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.hardEdge,
          child: Container(
            height: _padHeight,
            decoration: BoxDecoration(
              color: locked
                  ? AppColors.mutedFill(context)
                  : AppColors.background(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: border),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                _size = Size(constraints.maxWidth, constraints.maxHeight);
                return AbsorbPointer(
                  absorbing: locked,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanStart: (d) => _start(d.localPosition),
                    onPanUpdate: (d) => _move(d.localPosition),
                    onPanEnd: (_) => _end(),
                    child: CustomPaint(
                      painter: _SigPainter(
                        _points,
                        locked
                            ? AppColors.hint(context)
                            : AppColors.onSurface(context),
                      ),
                      size: _size,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            locked
                ? widget.lockedHint
                : (_hasInk ? 'Signed in this box' : 'Draw inside this box'),
            style: TextStyle(fontSize: 11, color: AppColors.hint(context)),
          ),
        ),
      ],
    );
  }
}

class _SigPainter extends CustomPainter {
  _SigPainter(this.points, this.color);

  final List<Offset?> points;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    final paint = Paint()
      ..color = color
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
