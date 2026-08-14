import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/product/presentation/widgets/product_pickers.dart';
import 'package:life_insurance/features/task/presentation/models/task_mock_data.dart';

/// On-Boarding Task Detail tabs (docs/76).
class OnboardingDetailFields extends StatefulWidget {
  const OnboardingDetailFields({
    super.key,
    required this.data,
    required this.tab,
    required this.onTab,
    required this.onChanged,
    this.uploadSlot,
  });

  final OnboardingMock data;
  final int tab;
  final ValueChanged<int> onTab;
  final VoidCallback onChanged;
  final Widget? uploadSlot;

  @override
  State<OnboardingDetailFields> createState() => OnboardingDetailFieldsState();
}

class OnboardingDetailFieldsState extends State<OnboardingDetailFields> {
  late final TextEditingController _score;
  late final TextEditingController _agentName;
  late final TextEditingController _ident;
  late final TextEditingController _phone;
  late final TextEditingController _address;
  late final TextEditingController _leadDetail;
  late final TextEditingController _licenseNo;
  late final TextEditingController _agentCode;
  late final TextEditingController _join;
  late final TextEditingController _region;
  late final TextEditingController _ho;
  late final TextEditingController _leadSource;
  late final TextEditingController _contract;
  late final TextEditingController _otherInsurer;
  late final TextEditingController _licenseApp;
  late final Map<String, TextEditingController> _trainingCtrls;

  OnboardingMock get data => widget.data;

  @override
  void initState() {
    super.initState();
    _score = TextEditingController(text: data.interviewScore);
    _agentName = TextEditingController(text: data.agentName);
    _ident = TextEditingController(text: data.identification);
    _phone = TextEditingController(text: data.phone);
    _address = TextEditingController(text: data.address);
    _leadDetail = TextEditingController(text: data.leadSourceDetail);
    _licenseNo = TextEditingController(text: data.licenseNo);
    _agentCode = TextEditingController(text: data.agentCode);
    _join = TextEditingController(text: TaskFormat.dob(data.joinDate));
    _region = TextEditingController(text: data.stateRegion);
    _ho = TextEditingController(text: data.hoAssignment);
    _leadSource = TextEditingController(text: data.leadSourceType);
    _contract = TextEditingController(text: data.contractType);
    _otherInsurer = TextEditingController(text: data.otherInsurer);
    _licenseApp = TextEditingController(text: data.licenseApplication);
    _trainingCtrls = {
      for (final k in OnboardingCatalog.trainings)
        k: TextEditingController(text: data.training[k] ?? 'Not started'),
      for (final k in OnboardingCatalog.exams)
        k: TextEditingController(text: data.training[k] ?? 'Not taken'),
    };
  }

  @override
  void dispose() {
    _score.dispose();
    _agentName.dispose();
    _ident.dispose();
    _phone.dispose();
    _address.dispose();
    _leadDetail.dispose();
    _licenseNo.dispose();
    _agentCode.dispose();
    _join.dispose();
    _region.dispose();
    _ho.dispose();
    _leadSource.dispose();
    _contract.dispose();
    _otherInsurer.dispose();
    _licenseApp.dispose();
    for (final c in _trainingCtrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  void flush() => _flushText();

  void _flushText() {
    data.interviewScore = _score.text.trim();
    data.agentName = _agentName.text.trim();
    data.phone = _phone.text.trim();
    data.address = _address.text.trim();
    data.leadSourceDetail = _leadDetail.text.trim();
    data.licenseNo = _licenseNo.text.trim();
    data.agentCode = _agentCode.text.trim();
  }

  Future<void> _pickJoin() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: data.joinDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked == null) return;
    setState(() {
      data.joinDate = picked;
      _join.text = TaskFormat.dob(picked);
    });
    widget.onChanged();
  }

  Future<void> _pickId() async {
    final picked = await showIdentificationPickerSheet(
      context,
      initial: IdPick.parse(
        idType: data.idType == 'Passport' ? 'Passport' : 'NRC',
        raw: data.identification,
      ),
    );
    if (picked == null) return;
    setState(() {
      data.idType = picked.type == 'Passport' ? 'Passport' : 'NRC';
      data.identification = picked.display;
      _ident.text = picked.display;
    });
    widget.onChanged();
  }

  Future<void> _pickList({
    required String title,
    required List<String> options,
    required String current,
    required ValueChanged<String> onPick,
  }) async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            for (final o in options)
              ListTile(
                title: Text(o),
                trailing: o == current
                    ? const Icon(Icons.check, color: AppColors.lightPrimary)
                    : null,
                onTap: () => Navigator.pop(ctx, o),
              ),
          ],
        ),
      ),
    );
    if (picked == null) return;
    onPick(picked);
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Task Detail',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _OnboardTab(
                label: 'Agent Info',
                selected: widget.tab == 0,
                onTap: () {
                  _flushText();
                  widget.onTab(0);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _OnboardTab(
                label: 'Training Detail',
                selected: widget.tab == 1,
                onTap: () {
                  _flushText();
                  widget.onTab(1);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (widget.tab == 0) ..._agent() else ..._training(),
      ],
    );
  }

  List<Widget> _agent() {
    return [
      AppTextField(
        label: 'Structure Interview Score',
        controller: _score,
        keyboardType: TextInputType.number,
        onChanged: (_) => _flushText(),
      ),
      const SizedBox(height: 14),
      AppTextField(
        label: 'Agent Name',
        isRequired: true,
        controller: _agentName,
        onChanged: (_) => _flushText(),
      ),
      const SizedBox(height: 14),
      const Text(
        'Identification',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.lightTextSecondary,
        ),
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: _OnboardTab(
              label: 'NRC',
              selected: data.idType != 'Passport',
              onTap: () {
                setState(() => data.idType = 'NRC');
                widget.onChanged();
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _OnboardTab(
              label: 'Passport',
              selected: data.idType == 'Passport',
              onTap: () {
                setState(() => data.idType = 'Passport');
                widget.onChanged();
              },
            ),
          ),
        ],
      ),
      const SizedBox(height: 14),
      AppTextField(
        label: 'Identification',
        isRequired: true,
        readOnly: true,
        controller: _ident,
        hintText: data.idType == 'Passport' ? 'Passport number' : 'NRC',
        onTap: _pickId,
        suffix: const Icon(Icons.badge_outlined, size: 18),
      ),
      const SizedBox(height: 14),
      AppTextField(
        label: 'Phone No.',
        controller: _phone,
        keyboardType: TextInputType.phone,
        onChanged: (_) => _flushText(),
      ),
      const SizedBox(height: 14),
      AppTextField(
        label: 'State/Region',
        readOnly: true,
        controller: _region,
        onTap: () => _pickList(
          title: 'State/Region',
          options: OnboardingCatalog.regions,
          current: data.stateRegion,
          onPick: (v) => setState(() {
            data.stateRegion = v;
            _region.text = v;
          }),
        ),
        suffix: const Icon(Icons.expand_more, size: 18),
      ),
      const SizedBox(height: 14),
      AppTextField(
        label: 'Full Address',
        controller: _address,
        onChanged: (_) => _flushText(),
      ),
      const SizedBox(height: 14),
      AppTextField(
        label: 'Join Date',
        readOnly: true,
        controller: _join,
        onTap: _pickJoin,
        suffix: const Icon(Icons.calendar_today_outlined, size: 18),
      ),
      if (widget.uploadSlot != null) ...[
        const SizedBox(height: 18),
        widget.uploadSlot!,
      ],
    ];
  }

  List<Widget> _training() {
    Widget drop({
      required String label,
      required TextEditingController controller,
      required List<String> options,
      required ValueChanged<String> onPick,
    }) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: AppTextField(
          label: label,
          readOnly: true,
          controller: controller,
          onTap: () => _pickList(
            title: label,
            options: options,
            current: controller.text,
            onPick: (v) {
              setState(() {
                onPick(v);
                controller.text = v;
              });
            },
          ),
          suffix: const Icon(Icons.expand_more, size: 18),
        ),
      );
    }

    return [
      drop(
        label: 'HO Assignment',
        controller: _ho,
        options: OnboardingCatalog.hoOptions,
        onPick: (v) => data.hoAssignment = v,
      ),
      drop(
        label: 'Lead Source Type',
        controller: _leadSource,
        options: OnboardingCatalog.leadSources,
        onPick: (v) => data.leadSourceType = v,
      ),
      AppTextField(
        label: 'Lead Source Detail',
        controller: _leadDetail,
        onChanged: (_) => _flushText(),
      ),
      const SizedBox(height: 14),
      for (final key in OnboardingCatalog.trainings)
        drop(
          label: key,
          controller: _trainingCtrls[key]!,
          options: OnboardingCatalog.trainingOptions,
          onPick: (v) => data.training[key] = v,
        ),
      for (final key in OnboardingCatalog.exams)
        drop(
          label: key,
          controller: _trainingCtrls[key]!,
          options: OnboardingCatalog.examOptions,
          onPick: (v) => data.training[key] = v,
        ),
      drop(
        label: 'Contract Type',
        controller: _contract,
        options: OnboardingCatalog.contracts,
        onPick: (v) => data.contractType = v,
      ),
      drop(
        label: 'Other Insurer',
        controller: _otherInsurer,
        options: OnboardingCatalog.otherInsurer,
        onPick: (v) => data.otherInsurer = v,
      ),
      drop(
        label: 'License Application',
        controller: _licenseApp,
        options: OnboardingCatalog.licenseApp,
        onPick: (v) => data.licenseApplication = v,
      ),
      AppTextField(
        label: 'License No.',
        controller: _licenseNo,
        onChanged: (_) => _flushText(),
      ),
      const SizedBox(height: 14),
      AppTextField(
        label: 'Agent Code',
        controller: _agentCode,
        onChanged: (_) => _flushText(),
      ),
    ];
  }
}

class _OnboardTab extends StatelessWidget {
  const _OnboardTab({
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
          ? AppColors.lightPrimary
          : AppColors.lightPrimary.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 13,
              color: selected ? Colors.white : AppColors.lightTextPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
