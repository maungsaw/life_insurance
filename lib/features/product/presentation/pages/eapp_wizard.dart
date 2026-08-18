import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart'
    show AppColors, AppRoute, PrototypeConfig;
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/customer/presentation/models/customer_hub_session.dart';
import 'package:life_insurance/features/product/presentation/models/product_mock_data.dart';
import 'package:life_insurance/features/product/presentation/widgets/eapp_launch.dart';
import 'package:life_insurance/features/product/presentation/widgets/product_pickers.dart';
import 'package:life_insurance/features/product/presentation/widgets/product_widgets.dart';

class ProductEappPage extends StatefulWidget {
  const ProductEappPage({super.key, required this.draft});

  final EappDraft draft;

  @override
  State<ProductEappPage> createState() => _ProductEappPageState();
}

class _ProductEappPageState extends State<ProductEappPage> {
  static const _fieldGap = SizedBox(height: 16);

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
  int _agentPadEpoch = 0;
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
      if (d.quote.party.kind == QuotePartyKind.lead) {
        CustomerHubSession.markLeadApplied(d.quote.party.id);
      }
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

  void _jumpToStep(int target) {
    _flushPerson();
    setState(() {
      _error = null;
      d.step = target;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface(context),
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
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (d.isRenewal) const EappRenewalPill(),
                  Text(
                    d.isRenewal
                        ? 'Renewal · ${d.sourcePolicyId} · ${d.quote.party.name}'
                        : '${d.quote.party.name} · ${d.quote.productName} · ${d.quote.monthlyPremium} MMK',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.onSurfaceSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Text(
                _error!,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
              child: step == 6
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppButton(
                          label: 'SUBMIT APPLICATION',
                          isLoading: _busy,
                          onPressed: _next,
                        ),
                        const SizedBox(height: 8),
                        AppButton(
                          label: 'Back',
                          variant: AppButtonVariant.secondary,
                          onPressed: _back,
                        ),
                      ],
                    )
                  : Row(
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
                            label: step == 2 ? 'Save' : 'NEXT',
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
      _fieldGap,
      AppTextField(
        label: 'Mobile Number',
        isRequired: true,
        controller: _phMobile,
        keyboardType: TextInputType.phone,
      ),
      _fieldGap,
      AppTextField(
        label: 'Alternative Mobile Number',
        controller: _phAlt,
        keyboardType: TextInputType.phone,
      ),
      _fieldGap,
      const Text(
        'Gender *',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
      ),
      const SizedBox(height: 10),
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
      _fieldGap,
      // Identification type lives only in the Identification sheet (docs/62).
      AppTextField(
        label: 'Identification',
        isRequired: true,
        controller: _phId,
        readOnly: true,
        onTap: _pickId,
        suffix: const Icon(Icons.unfold_more, size: 18),
      ),
      _fieldGap,
      AppTextField(
        label: 'Email',
        controller: _phEmail,
        keyboardType: TextInputType.emailAddress,
      ),
      _fieldGap,
      AppTextField(
        label: 'Father Name',
        isRequired: true,
        controller: _phFather,
      ),
      _fieldGap,
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
      _fieldGap,
      AppTextField(
        label: 'Age',
        isRequired: true,
        controller: _phAge,
        enabled: false,
      ),
      _fieldGap,
      AppTextField(
        label: 'Height',
        isRequired: true,
        controller: _phHeight,
        readOnly: true,
        onTap: _pickHeight,
        suffix: const Icon(Icons.unfold_more, size: 18),
      ),
      _fieldGap,
      AppTextField(
        label: 'Weight',
        isRequired: true,
        controller: _phWeight,
        readOnly: true,
        onTap: _pickWeight,
        suffix: const Icon(Icons.unfold_more, size: 18),
      ),
      _fieldGap,
      AppTextField(label: 'Occupation', isRequired: true, controller: _phJob),
      _fieldGap,
      AppTextField(label: 'Town', isRequired: true, controller: _phTown),
      _fieldGap,
      AppTextField(
        label: 'Township',
        isRequired: true,
        controller: _phTownship,
      ),
      _fieldGap,
      AppTextField(
        label: 'State/Region',
        isRequired: true,
        controller: _phState,
      ),
      _fieldGap,
      AppTextField(label: 'Address', isRequired: true, controller: _phAddress),
      const SizedBox(height: 12),
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
      Text(
        'Life Assured is different from the policyholder. Confirm details on the next scanner step, or go back and tick Same As Life Assured.',
        style: TextStyle(height: 1.4, color: AppColors.onSurfaceSecondary(context)),
      ),
      const SizedBox(height: 12),
      Text(
        _la.name,
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
      ),
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
        child: Column(
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
                color: AppColors.onSurfaceSecondary(context),
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
            child: Icon(
              Icons.photo_camera_outlined,
              size: 48,
              color: AppColors.lightPrimary,
            ),
          ),
        ),
      ),
      const SizedBox(height: 16),
      Center(
        child: Text(
          _ph.idType == 'Passport'
              ? 'Scan the Passport Photo'
              : 'Scan the Front NRC Photo',
          style: TextStyle(color: AppColors.onSurfaceSecondary(context)),
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
            side: BorderSide(color: AppColors.border(context)),
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
                        style: TextStyle(color: AppColors.surface(context)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${d.beneficiaries[i].name}\n${d.beneficiaries[i].relationship}',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(
                      '${d.beneficiaries[i].percent}%',
                      style: TextStyle(fontWeight: FontWeight.w800),
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
                      onPressed: () =>
                          setState(() => d.beneficiaries.removeAt(i)),
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 16,
                        color: Colors.redAccent,
                      ),
                      label: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.redAccent),
                      ),
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
      Text(
        'Do You Work in High Risk Industry?',
        style: TextStyle(color: AppColors.onSurfaceSecondary(context)),
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
      Text(
        q.productName,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
      ),
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
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.lightPrimary,
          ),
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
      Text(
        'Locked from the saved quote. Change product or premium on Get A Quote.',
        style: TextStyle(fontSize: 12, color: AppColors.hint(context)),
      ),
    ];
  }

  List<Widget> _confirm() {
    final q = d.quote;
    final insuredName = d.sameAsLifeAssured ? _ph.name : _la.name;
    final benSummary = d.beneficiaries.isEmpty
        ? 'None'
        : '${d.beneficiaries.length} · ${ProductSession.beneficiaryTotal(d)}%';

    return [
      Text(
        'Review only — expand a section for details. Edit jumps back to that step.',
        style: TextStyle(
          fontSize: 12,
          color: AppColors.hint(context),
          height: 1.35,
        ),
      ),
      const SizedBox(height: 12),
      _ConfirmProductCard(
        productName: q.productName,
        frequency: q.frequency,
        premium: q.monthlyPremium,
        age: q.age,
        sumInsured: q.sumInsured,
        topup: q.topup,
        term: q.term,
        total: q.totalAmount,
        onEdit: () => _jumpToStep(5),
      ),
      const SizedBox(height: 10),
      _ConfirmReviewTile(
        title: 'Policyholder Information',
        subtitle: '${_ph.name} · ${_ph.identification}',
        onEdit: () => _jumpToStep(0),
        rows: {
          'Name': _ph.name,
          'Mobile': _ph.mobile,
          'Gender': _ph.gender,
          'Identification': _ph.identification,
          'Date of Birth': ProductFormat.dob(_ph.dob),
          'Age': '${ProductFormat.ageOn(_ph.dob)}',
          'Email': _ph.email,
          'Height': _ph.height,
          'Weight': _ph.weight,
          'Occupation': _ph.occupation,
          'Town': _ph.town,
          'Township': _ph.township,
          'State': _ph.state,
          'Address': _ph.address,
        },
      ),
      const SizedBox(height: 10),
      _ConfirmReviewTile(
        title: 'Insured Information',
        subtitle: d.sameAsLifeAssured ? 'Same as policyholder' : insuredName,
        onEdit: () => _jumpToStep(d.sameAsLifeAssured ? 0 : 1),
        rows: {
          'Same as policyholder': d.sameAsLifeAssured ? 'Yes' : 'No',
          'Name': insuredName,
          if (!d.sameAsLifeAssured) 'Identification': _la.identification,
        },
      ),
      const SizedBox(height: 10),
      _ConfirmReviewTile(
        title: 'Beneficiary Information',
        subtitle: benSummary,
        onEdit: () => _jumpToStep(3),
        rows: {
          for (final b in d.beneficiaries)
            b.name: '${b.relationship} · ${b.percent}%',
        },
      ),
      const SizedBox(height: 10),
      _ConfirmReviewTile(
        title: 'Health Declaration',
        subtitle: d.highRisk ? 'High risk · Yes' : 'High risk · No',
        onEdit: () => _jumpToStep(4),
        rows: {
          'High risk': d.highRisk ? 'Yes' : 'No',
          'Remark': d.healthRemark.isEmpty ? '—' : d.healthRemark,
        },
      ),
      const SizedBox(height: 14),
      const Text(
        'Signature',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 8),
      SignaturePad(
        label: 'Client signature *',
        onChanged: (has) => setState(() {
          _clientSign = has;
          if (!has) {
            _agentSign = false;
            _agentPadEpoch++;
          }
        }),
      ),
      const SizedBox(height: 12),
      SignaturePad(
        key: ValueKey(_agentPadEpoch),
        label: 'Agent signature *',
        enabled: _clientSign,
        lockedHint: 'Sign client first',
        onChanged: (has) => setState(() => _agentSign = has),
      ),
    ];
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              k,
              style: TextStyle(color: AppColors.onSurfaceSecondary(context)),
            ),
          ),
          Flexible(
            child: Text(
              v,
              textAlign: TextAlign.right,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
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
      initial: IdPick.parse(idType: _ph.idType, raw: _ph.identification),
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
                AppTextField(
                  label: 'Relationship',
                  isRequired: true,
                  controller: rel,
                ),
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

class _ConfirmProductCard extends StatefulWidget {
  const _ConfirmProductCard({
    required this.productName,
    required this.frequency,
    required this.premium,
    required this.age,
    required this.sumInsured,
    required this.topup,
    required this.term,
    required this.total,
    required this.onEdit,
  });

  final String productName;
  final String frequency;
  final String premium;
  final int age;
  final String sumInsured;
  final String topup;
  final String term;
  final String total;
  final VoidCallback onEdit;

  @override
  State<_ConfirmProductCard> createState() => _ConfirmProductCardState();
}

class _ConfirmProductCardState extends State<_ConfirmProductCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8ECF0)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _open = !_open),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.productName,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Premium (${widget.frequency})  ${widget.premium}',
                          style: TextStyle(
                            color: AppColors.lightPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: widget.onEdit,
                    child: const Text('Edit'),
                  ),
                  Icon(
                    _open
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.onSurfaceSecondary(context),
                  ),
                ],
              ),
            ),
          ),
          if (_open) ...[
            Divider(height: 1, color: AppColors.border(context)),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Column(
                children: [
                  _confirmKv(context, 'Your Age', '${widget.age}'),
                  _confirmKv(context, 'Sum Insured', widget.sumInsured),
                  if (widget.topup != '0.00')
                    _confirmKv(context, 'Top-Up Premium', widget.topup),
                  _confirmKv(context, 'Policy Term', widget.term),
                  if (widget.total != '0.00')
                    _confirmKv(context, 'Total Amount', widget.total),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ConfirmReviewTile extends StatefulWidget {
  const _ConfirmReviewTile({
    required this.title,
    required this.subtitle,
    required this.rows,
    required this.onEdit,
  });

  final String title;
  final String subtitle;
  final Map<String, String> rows;
  final VoidCallback onEdit;

  @override
  State<_ConfirmReviewTile> createState() => _ConfirmReviewTileState();
}

class _ConfirmReviewTileState extends State<_ConfirmReviewTile> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8ECF0)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _open = !_open),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 18,
                    color: AppColors.successGreen,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.onSurfaceSecondary(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: widget.onEdit,
                    child: const Text('Edit'),
                  ),
                  Icon(
                    _open
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.onSurfaceSecondary(context),
                  ),
                ],
              ),
            ),
          ),
          if (_open && widget.rows.isNotEmpty) ...[
            Divider(height: 1, color: AppColors.border(context)),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Column(
                children: [
                  for (final e in widget.rows.entries)
                    _confirmKv(context, e.key, e.value),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

Widget _confirmKv(BuildContext context, String k, String v) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            k,
            style: TextStyle(
              color: AppColors.onSurfaceSecondary(context),
              fontSize: 13,
            ),
          ),
        ),
        Flexible(
          child: Text(
            v,
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
        ),
      ],
    ),
  );
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
