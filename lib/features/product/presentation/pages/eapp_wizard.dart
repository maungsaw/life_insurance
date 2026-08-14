import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart'
    show AppColors, AppRoute, PrototypeConfig;
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/product/presentation/models/product_mock_data.dart';
import 'package:life_insurance/features/product/presentation/widgets/product_pickers.dart';
import 'package:life_insurance/features/product/presentation/widgets/product_widgets.dart';

class ProductEappPage extends StatefulWidget {
  const ProductEappPage({super.key, required this.draft});

  final EappDraft draft;

  @override
  State<ProductEappPage> createState() => _ProductEappPageState();
}

class _ProductEappPageState extends State<ProductEappPage> {
  static const _titles = [
    'Policyholder',
    'Life Assured',
    'Life Assured Scanner',
    'Beneficiary',
    'Health Declaration',
    'Premium Information',
    'Confirm & Submit',
  ];

  late final PersonDraft _ph;
  late final PersonDraft _la;
  bool _busy = false;
  bool _clientSign = false;
  bool _agentSign = false;
  String? _error;

  late final TextEditingController _phName;
  late final TextEditingController _phMobile;
  late final TextEditingController _phAlt;
  late final TextEditingController _phId;
  late final TextEditingController _phEmail;
  late final TextEditingController _phFather;
  late final TextEditingController _phDob;
  late final TextEditingController _phAge;
  late final TextEditingController _phHeight;
  late final TextEditingController _phWeight;
  late final TextEditingController _phJob;
  late final TextEditingController _phTown;
  late final TextEditingController _phTownship;
  late final TextEditingController _phState;
  late final TextEditingController _phAddress;
  late final TextEditingController _remark;

  @override
  void initState() {
    super.initState();
    _ph = widget.draft.policyholder;
    _la = widget.draft.lifeAssured;
    _phName = TextEditingController(text: _ph.name);
    _phMobile = TextEditingController(text: _ph.mobile);
    _phAlt = TextEditingController(text: _ph.altMobile);
    _phId = TextEditingController(text: _ph.identification);
    _phEmail = TextEditingController(text: _ph.email);
    _phFather = TextEditingController(text: _ph.fatherName);
    _phDob = TextEditingController(text: ProductFormat.dob(_ph.dob));
    _phAge = TextEditingController(text: '${ProductFormat.ageOn(_ph.dob)}');
    _phHeight = TextEditingController(text: _ph.height);
    _phWeight = TextEditingController(text: _ph.weight);
    _phJob = TextEditingController(text: _ph.occupation);
    _phTown = TextEditingController(text: _ph.town);
    _phTownship = TextEditingController(text: _ph.township);
    _phState = TextEditingController(text: _ph.state);
    _phAddress = TextEditingController(text: _ph.address);
    _remark = TextEditingController(text: widget.draft.healthRemark);
  }

  @override
  void dispose() {
    _phName.dispose();
    _phMobile.dispose();
    _phAlt.dispose();
    _phId.dispose();
    _phEmail.dispose();
    _phFather.dispose();
    _phDob.dispose();
    _phAge.dispose();
    _phHeight.dispose();
    _phWeight.dispose();
    _phJob.dispose();
    _phTown.dispose();
    _phTownship.dispose();
    _phState.dispose();
    _phAddress.dispose();
    _remark.dispose();
    super.dispose();
  }

  EappDraft get d => widget.draft;
  int get step => d.step;

  void _flushPerson() {
    _ph
      ..name = _phName.text.trim()
      ..mobile = _phMobile.text.trim()
      ..altMobile = _phAlt.text.trim()
      ..identification = _phId.text.trim()
      ..email = _phEmail.text.trim()
      ..fatherName = _phFather.text.trim()
      ..height = _phHeight.text.trim()
      ..weight = _phWeight.text.trim()
      ..occupation = _phJob.text.trim()
      ..town = _phTown.text.trim()
      ..township = _phTownship.text.trim()
      ..state = _phState.text.trim()
      ..address = _phAddress.text.trim();
    d.healthRemark = _remark.text.trim();
    if (d.sameAsLifeAssured) {
      d.lifeAssured
        ..name = _ph.name
        ..mobile = _ph.mobile
        ..altMobile = _ph.altMobile
        ..idType = _ph.idType
        ..identification = _ph.identification
        ..gender = _ph.gender
        ..email = _ph.email
        ..fatherName = _ph.fatherName
        ..dob = _ph.dob
        ..height = _ph.height
        ..weight = _ph.weight
        ..occupation = _ph.occupation
        ..town = _ph.town
        ..township = _ph.township
        ..state = _ph.state
        ..address = _ph.address;
    }
  }

  Future<void> _next() async {
    _flushPerson();
    setState(() => _error = null);
    if (step == 0 && _ph.name.isEmpty) {
      setState(() => _error = 'Name is required.');
      return;
    }
    if (step == 3 && ProductSession.beneficiaryTotal(d) != 100) {
      setState(() => _error = 'Beneficiary share must total 100%.');
      return;
    }
    if (step == 6) {
      if (!_clientSign || !_agentSign) {
        setState(() => _error = 'Client and agent signatures are required.');
        return;
      }
      setState(() => _busy = true);
      await Future<void>.delayed(PrototypeConfig.mediumDelay);
      if (!mounted) return;
      d.status = EappStatus.submitted;
      d.appRef = d.id.replaceFirst('EA', 'APP');
      setState(() => _busy = false);
      context.push(AppRoute.productEappSuccess, extra: d);
      return;
    }

    var next = step + 1;
    if (step == 0 && d.sameAsLifeAssured) next = 2;
    d.step = next;
    setState(() {});
  }

  void _back() {
    _flushPerson();
    if (step == 0) {
      Navigator.of(context).maybePop();
      return;
    }
    var prev = step - 1;
    if (step == 2 && d.sameAsLifeAssured) prev = 0;
    d.step = prev;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ProductSubAppBar(
        title: _titles[step],
        actions: [
          if (step == 3)
            TextButton(
              onPressed: _addBeneficiary,
              child: const Text('ADD MORE'),
            ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (step + 1) / _titles.length,
            color: AppColors.lightPrimary,
            backgroundColor: AppColors.lightPrimary.withValues(alpha: 0.12),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${d.quote.party.name} · ${d.quote.productName} · ${d.quote.monthlyPremium} MMK',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.lightTextSecondary,
                ),
              ),
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Text(
                _error!,
                style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
              ),
            ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              children: [
                if (step == 0) ..._policyholder(),
                if (step == 1) ..._lifeAssuredNote(),
                if (step == 2) ..._scanner(),
                if (step == 3) ..._beneficiaries(),
                if (step == 4) ..._health(),
                if (step == 5) ..._premium(),
                if (step == 6) ..._confirm(),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Row(
                children: [
                  if (step == 2)
                    Expanded(
                      child: AppButton(
                        label: 'Skip',
                        variant: AppButtonVariant.secondary,
                        onPressed: () {
                          d.nrcCaptured = false;
                          _next();
                        },
                      ),
                    )
                  else
                    Expanded(
                      child: AppButton(
                        label: 'Back',
                        variant: AppButtonVariant.secondary,
                        onPressed: _back,
                      ),
                    ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppButton(
                      label: step == 6
                          ? 'CONFIRM'
                          : step == 2
                              ? 'Save'
                              : 'NEXT',
                      isLoading: _busy,
                      onPressed: () {
                        if (step == 2) d.nrcCaptured = true;
                        _next();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _policyholder() {
    return [
      AppTextField(label: 'Name', isRequired: true, controller: _phName),
      const SizedBox(height: 12),
      AppTextField(
        label: 'Mobile Number',
        isRequired: true,
        controller: _phMobile,
        keyboardType: TextInputType.phone,
      ),
      const SizedBox(height: 12),
      AppTextField(
        label: 'Alternative Mobile Number',
        controller: _phAlt,
        keyboardType: TextInputType.phone,
      ),
      const SizedBox(height: 12),
      const Text('Gender *', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: ProductSelectChip(
              label: 'Male',
              selected: _ph.gender == 'Male',
              onTap: () => setState(() => _ph.gender = 'Male'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ProductSelectChip(
              label: 'Female',
              selected: _ph.gender == 'Female',
              onTap: () => setState(() => _ph.gender = 'Female'),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      // Identification type lives only in the Identification sheet (docs/62).
      AppTextField(
        label: 'Identification',
        isRequired: true,
        controller: _phId,
        readOnly: true,
        onTap: _pickId,
        suffix: const Icon(Icons.unfold_more, size: 18),
      ),
      const SizedBox(height: 12),
      AppTextField(label: 'Email', controller: _phEmail, keyboardType: TextInputType.emailAddress),
      const SizedBox(height: 12),
      AppTextField(label: 'Father Name', isRequired: true, controller: _phFather),
      const SizedBox(height: 12),
      AppTextField(
        label: 'Date of Birth',
        isRequired: true,
        controller: _phDob,
        readOnly: true,
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: _ph.dob,
            firstDate: DateTime(1940),
            lastDate: DateTime(2026, 8, 14),
          );
          if (picked == null) return;
          setState(() {
            _ph.dob = picked;
            _phDob.text = ProductFormat.dob(picked);
            _phAge.text = '${ProductFormat.ageOn(picked)}';
          });
        },
      ),
      const SizedBox(height: 12),
      AppTextField(
        label: 'Age',
        isRequired: true,
        controller: _phAge,
        enabled: false,
      ),
      const SizedBox(height: 12),
      AppTextField(
        label: 'Height',
        isRequired: true,
        controller: _phHeight,
        readOnly: true,
        onTap: _pickHeight,
        suffix: const Icon(Icons.unfold_more, size: 18),
      ),
      const SizedBox(height: 12),
      AppTextField(
        label: 'Weight',
        isRequired: true,
        controller: _phWeight,
        readOnly: true,
        onTap: _pickWeight,
        suffix: const Icon(Icons.unfold_more, size: 18),
      ),
      const SizedBox(height: 12),
      AppTextField(label: 'Occupation', isRequired: true, controller: _phJob),
      const SizedBox(height: 12),
      AppTextField(label: 'Town', isRequired: true, controller: _phTown),
      const SizedBox(height: 12),
      AppTextField(label: 'Township', isRequired: true, controller: _phTownship),
      const SizedBox(height: 12),
      AppTextField(label: 'State/Region', isRequired: true, controller: _phState),
      const SizedBox(height: 12),
      AppTextField(label: 'Address', isRequired: true, controller: _phAddress),
      const SizedBox(height: 8),
      CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        value: d.sameAsLifeAssured,
        onChanged: (v) => setState(() => d.sameAsLifeAssured = v ?? true),
        title: const Text('Same As Life Assured'),
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: AppColors.lightPrimary,
      ),
    ];
  }

  List<Widget> _lifeAssuredNote() {
    return [
      const Text(
        'Life Assured is different from the policyholder. Confirm details on the next scanner step, or go back and tick Same As Life Assured.',
        style: TextStyle(height: 1.4, color: AppColors.lightTextSecondary),
      ),
      const SizedBox(height: 12),
      Text(_la.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
      Text(_la.identification),
    ];
  }

  List<Widget> _scanner() {
    return [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.lightPrimary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.lightPrimary.withValues(alpha: 0.35),
          ),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'OCR optional',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.lightPrimary,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Camera capture is a prototype stub. Skip anytime and keep the typed NRC / Passport from Policyholder.',
              style: TextStyle(
                fontSize: 12,
                height: 1.35,
                color: AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: ProductSelectChip(
              label: 'NRC',
              selected: _ph.idType == 'NRC',
              onTap: () => setState(() => _ph.idType = 'NRC'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ProductSelectChip(
              label: 'Passport',
              selected: _ph.idType == 'Passport',
              onTap: () => setState(() => _ph.idType = 'Passport'),
            ),
          ),
        ],
      ),
      const SizedBox(height: 28),
      AspectRatio(
        aspectRatio: 1.1,
        child: CustomPaint(
          painter: _ScanFramePainter(),
          child: const Center(
            child: Icon(Icons.photo_camera_outlined, size: 48, color: AppColors.lightPrimary),
          ),
        ),
      ),
      const SizedBox(height: 16),
      Center(
        child: Text(
          _ph.idType == 'Passport'
              ? 'Scan the Passport Photo'
              : 'Scan the Front NRC Photo',
          style: const TextStyle(color: AppColors.lightTextSecondary),
        ),
      ),
      const SizedBox(height: 20),
      Center(
        child: InkWell(
          onTap: () {
            setState(() => d.nrcCaptured = true);
            AppStatusDialog.show(
              context,
              type: AppStatusType.success,
              title: 'Captured',
              message: 'Photo stub saved — no OCR API in prototype.',
            );
          },
          customBorder: const CircleBorder(),
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.lightPrimary, width: 4),
            ),
            padding: const EdgeInsets.all(6),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.lightPrimary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> _beneficiaries() {
    final total = ProductSession.beneficiaryTotal(d);
    return [
      Text(
        'Total share $total%',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: total == 100 ? AppColors.successGreen : Colors.redAccent,
        ),
      ),
      const SizedBox(height: 12),
      for (var i = 0; i < d.beneficiaries.length; i++)
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.lightBorder),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.lightPrimary,
                      child: Text(
                        d.beneficiaries[i].name.isEmpty
                            ? '?'
                            : d.beneficiaries[i].name[0].toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${d.beneficiaries[i].name}\n${d.beneficiaries[i].relationship}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(
                      '${d.beneficiaries[i].percent}%',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => _editBeneficiary(i),
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: const Text('Edit'),
                    ),
                    TextButton.icon(
                      onPressed: () => setState(() => d.beneficiaries.removeAt(i)),
                      icon: const Icon(Icons.delete_outline, size: 16, color: Colors.redAccent),
                      label: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
    ];
  }

  List<Widget> _health() {
    return [
      const Text(
        'Do You Work in High Risk Industry?',
        style: TextStyle(color: AppColors.lightTextSecondary),
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(
            child: ProductSelectChip(
              label: 'Yes',
              selected: d.highRisk,
              onTap: () => setState(() => d.highRisk = true),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ProductSelectChip(
              label: 'No',
              selected: !d.highRisk,
              onTap: () => setState(() => d.highRisk = false),
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      AppTextField(label: 'Remark', controller: _remark),
    ];
  }

  List<Widget> _premium() {
    final q = d.quote;
    return [
      Text(q.productName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
      const SizedBox(height: 12),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.lightPrimary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Premium (${q.frequency})  ${q.monthlyPremium}',
          style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.lightPrimary),
        ),
      ),
      const SizedBox(height: 12),
      _kv('Product Name', q.productName),
      _kv('Variant', q.variant),
      _kv('Payment Frequency', q.frequency),
      _kv('Your Age', '${q.age}'),
      _kv('Sum Insured', q.sumInsured),
      if (q.topup != '0.00') _kv('Top-Up Premium', q.topup),
      _kv('Policy Term', q.term),
      for (final e in q.extras.entries) _kv(e.key, e.value),
      _kv('Stamp Fee', q.stampFee),
      const Divider(height: 18),
      _kv('Total Amount', q.totalAmount),
      const SizedBox(height: 8),
      const Text(
        'Locked from the saved quote. Change product or premium on Get A Quote.',
        style: TextStyle(fontSize: 12, color: AppColors.lightTextHint),
      ),
    ];
  }

  List<Widget> _confirm() {
    return [
      _acc('Policyholder Information', [
        _kv('Name', _ph.name),
        _kv('Mobile', _ph.mobile),
        _kv('ID', _ph.identification),
      ]),
      _acc('Insured Information', [
        _kv('Same as policyholder', d.sameAsLifeAssured ? 'Yes' : 'No'),
        _kv('Name', d.sameAsLifeAssured ? _ph.name : _la.name),
      ]),
      _acc('Beneficiary Information', [
        for (final b in d.beneficiaries) _kv(b.name, '${b.relationship} · ${b.percent}%'),
      ]),
      _acc('Health Declaration Information', [
        _kv('High risk', d.highRisk ? 'Yes' : 'No'),
        _kv('Remark', d.healthRemark.isEmpty ? '—' : d.healthRemark),
      ]),
      _acc('Policy Information', [
        _kv('Premium', '${d.quote.monthlyPremium} · ${d.quote.frequency}'),
        _kv('Product', d.quote.productName),
        _kv('Sum Insured', d.quote.sumInsured),
      ]),
      const SizedBox(height: 8),
      SignaturePad(
        label: 'Client signature *',
        onChanged: (has) => setState(() => _clientSign = has),
      ),
      const SizedBox(height: 12),
      SignaturePad(
        label: 'Agent signature *',
        onChanged: (has) => setState(() => _agentSign = has),
      ),
    ];
  }

  Widget _acc(String title, List<Widget> children) {
    return ExpansionTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      children: children,
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(child: Text(k, style: const TextStyle(color: AppColors.lightTextSecondary))),
          Flexible(
            child: Text(v, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Future<void> _pickHeight() async {
    final parts = RegExp(r"(\d+)'\s*(\d+)").firstMatch(_phHeight.text);
    final initial = HeightPick(
      feet: int.tryParse(parts?.group(1) ?? '') ?? 5,
      inches: int.tryParse(parts?.group(2) ?? '') ?? 7,
    );
    final picked = await showHeightPickerSheet(context, initial: initial);
    if (picked == null) return;
    setState(() {
      _ph.height = picked.label;
      _phHeight.text = picked.label;
    });
  }

  Future<void> _pickWeight() async {
    final parts = RegExp(r'(\d+)(?:\.(\d))?').firstMatch(_phWeight.text);
    final initial = WeightPick(
      whole: int.tryParse(parts?.group(1) ?? '') ?? 105,
      tenth: int.tryParse(parts?.group(2) ?? '') ?? 0,
    );
    final picked = await showWeightPickerSheet(context, initial: initial);
    if (picked == null) return;
    setState(() {
      _ph.weight = picked.label;
      _phWeight.text = picked.label;
    });
  }

  Future<void> _pickId() async {
    final picked = await showIdentificationPickerSheet(
      context,
      initial: IdPick.parse(
        idType: _ph.idType,
        raw: _ph.identification,
      ),
    );
    if (picked == null) return;
    setState(() {
      _ph.idType = picked.type;
      _ph.identification = picked.display;
      _phId.text = picked.display;
    });
  }

  Future<void> _addBeneficiary() async {
    await _editBeneficiary(null);
  }

  Future<void> _editBeneficiary(int? index) async {
    final existing = index == null ? null : d.beneficiaries[index];
    final name = TextEditingController(text: existing?.name ?? '');
    final rel = TextEditingController(text: existing?.relationship ?? 'Mother');
    final father = TextEditingController(text: existing?.fatherName ?? '');
    final id = TextEditingController(text: existing?.identification ?? '');
    final mobile = TextEditingController(text: existing?.mobile ?? '');
    final pct = TextEditingController(text: '${existing?.percent ?? 50}');
    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            0,
            16,
            16 + MediaQuery.viewInsetsOf(ctx).bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(label: 'Name', isRequired: true, controller: name),
                const SizedBox(height: 10),
                AppTextField(label: 'Relationship', isRequired: true, controller: rel),
                const SizedBox(height: 10),
                AppTextField(label: 'Father Name', controller: father),
                const SizedBox(height: 10),
                AppTextField(label: 'Identification', controller: id),
                const SizedBox(height: 10),
                AppTextField(label: 'Mobile Number', controller: mobile),
                const SizedBox(height: 10),
                AppTextField(
                  label: 'Percentage',
                  isRequired: true,
                  controller: pct,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 14),
                AppButton(
                  label: 'Save',
                  onPressed: () => Navigator.pop(ctx, true),
                ),
              ],
            ),
          ),
        );
      },
    );
    final person = BeneficiaryDraft(
      name: name.text.trim(),
      relationship: rel.text.trim(),
      fatherName: father.text.trim(),
      identification: id.text.trim(),
      dob: existing?.dob ?? DateTime(1999, 6, 4),
      mobile: mobile.text.trim(),
      percent: int.tryParse(pct.text.trim()) ?? 0,
    );
    name.dispose();
    rel.dispose();
    father.dispose();
    id.dispose();
    mobile.dispose();
    pct.dispose();
    if (ok != true || !mounted) return;
    setState(() {
      if (index == null) {
        d.beneficiaries.add(person);
      } else {
        d.beneficiaries[index] = person;
      }
    });
  }
}

class _ScanFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.lightPrimary
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const l = 28.0;
    void corner(double x, double y, double dx, double dy) {
      canvas.drawLine(Offset(x, y), Offset(x + dx, y), paint);
      canvas.drawLine(Offset(x, y), Offset(x, y + dy), paint);
    }

    corner(8, 8, l, l);
    corner(size.width - 8, 8, -l, l);
    corner(8, size.height - 8, l, -l);
    corner(size.width - 8, size.height - 8, -l, -l);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
