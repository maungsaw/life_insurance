import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors, AppDate, PrototypeConfig;
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/customer/presentation/models/customer_mock_data.dart';
import 'package:life_insurance/features/customer/presentation/widgets/app_crm_status_pill.dart';

/// Edit customer contact — separate from agent Profile Details (docs/51).
class CustomerProfileDetailsPage extends StatefulWidget {
  const CustomerProfileDetailsPage({super.key, required this.customer});

  final CustomerMock customer;

  @override
  State<CustomerProfileDetailsPage> createState() =>
      _CustomerProfileDetailsPageState();
}

class _CustomerProfileDetailsPageState
    extends State<CustomerProfileDetailsPage> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _mobileCtrl;
  late final TextEditingController _dobCtrl;
  late final TextEditingController _idCtrl;
  late final TextEditingController _emailCtrl;

  String? _nameError;
  String? _mobileError;
  String? _dobError;
  String? _idError;
  String? _emailError;
  late String _gender;
  late DateTime _dob;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final c = widget.customer;
    _nameCtrl = TextEditingController(text: c.name);
    _mobileCtrl = TextEditingController(text: c.phone);
    _dob = c.dob;
    _dobCtrl = TextEditingController(text: c.dobLabel);
    _idCtrl = TextEditingController(text: c.identification);
    _emailCtrl = TextEditingController(text: c.email);
    _gender = c.gender;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _mobileCtrl.dispose();
    _dobCtrl.dispose();
    _idCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    setState(() {
      _dob = picked;
      _dobCtrl.text = AppDate.dMy(picked);
      _dobError = null;
    });
  }

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    final mobile = _mobileCtrl.text.trim();
    final id = _idCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final emailOk =
        email.isEmpty || RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);

    setState(() {
      _nameError = name.isEmpty ? 'Name is required' : null;
      _mobileError = mobile.isEmpty
          ? 'Mobile number is required'
          : (!PrototypeConfig.isCoreMobileOk(mobile)
                ? 'Enter a valid mobile number'
                : null);
      _dobError =
          _dobCtrl.text.trim().isEmpty ? 'Date of birth is required' : null;
      _idError = id.isEmpty ? 'Identification is required' : null;
      _emailError = emailOk ? null : 'Enter a valid email';
    });
    if (_nameError != null ||
        _mobileError != null ||
        _dobError != null ||
        _idError != null ||
        _emailError != null) {
      return;
    }

    setState(() => _submitting = true);
    await Future<void>.delayed(PrototypeConfig.mediumDelay);
    if (!mounted) return;

    widget.customer
      ..name = name
      ..phone = mobile
      ..identification = id
      ..email = email
      ..gender = _gender
      ..dob = _dob;

    setState(() => _submitting = false);

    await AppStatusDialog.show(
      context,
      type: AppStatusType.success,
      title: 'Profile updated',
      message: 'Customer details have been saved.',
      actionLabel: 'OK',
    );
    if (!mounted) return;
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface(context),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Profile Details',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.surface(context),
        foregroundColor: AppColors.onSurface(context),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Center(
            child: Stack(
              children: [
                AppInitialAvatar(
                  initials: widget.customer.initials,
                  radius: 48,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Material(
                    color: AppColors.surface(context),
                    shape: const CircleBorder(),
                    elevation: 1,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => AppStatusDialog.show(
                        context,
                        type: AppStatusType.info,
                        title: 'Photo',
                        message:
                            'Camera / gallery picker later — prototype stub.',
                        actionLabel: 'OK',
                      ),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border(context)),
                        ),
                        child: const Icon(
                          Icons.photo_camera_outlined,
                          size: 16,
                          color: AppColors.lightPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          AppTextField(
            label: 'Name',
            isRequired: true,
            controller: _nameCtrl,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            errorText: _nameError,
            onChanged: (_) {
              if (_nameError != null) setState(() => _nameError = null);
            },
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Mobile Number',
            isRequired: true,
            controller: _mobileCtrl,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            errorText: _mobileError,
            onChanged: (_) {
              if (_mobileError != null) setState(() => _mobileError = null);
            },
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Date of Birth',
            isRequired: true,
            controller: _dobCtrl,
            readOnly: true,
            onTap: _pickDob,
            errorText: _dobError,
            suffix: IconButton(
              onPressed: _pickDob,
              icon: Icon(
                Icons.calendar_today_outlined,
                size: 18,
                color: AppColors.onSurfaceSecondary(context),
              ),
            ),
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Identification',
            isRequired: true,
            controller: _idCtrl,
            textInputAction: TextInputAction.next,
            errorText: _idError,
            onChanged: (_) {
              if (_idError != null) setState(() => _idError = null);
            },
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Email',
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            errorText: _emailError,
            onChanged: (_) {
              if (_emailError != null) setState(() => _emailError = null);
            },
          ),
          const SizedBox(height: 18),
          Text(
            'Gender',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface(context),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _GenderChip(
                  label: 'Male',
                  selected: _gender == 'Male',
                  onTap: () => setState(() => _gender = 'Male'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _GenderChip(
                  label: 'Female',
                  selected: _gender == 'Female',
                  onTap: () => setState(() => _gender = 'Female'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          AppButton(
            label: 'UPDATE',
            isLoading: _submitting,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

class _GenderChip extends StatelessWidget {
  const _GenderChip({
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
      color: AppColors.surface(context),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? AppColors.lightPrimary : AppColors.border(context),
              width: selected ? 1.6 : 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: selected
                  ? AppColors.lightPrimary
                  : AppColors.onSurfaceSecondary(context),
            ),
          ),
        ),
      ),
    );
  }
}
