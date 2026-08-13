import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors, PrototypeConfig;
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/profile/presentation/models/profile_mock_data.dart';
import 'package:life_insurance/features/profile/presentation/widgets/profile_sub_app_bar.dart';

/// Edit agent account — wireframe Profile Details (docs/50).
class ProfileDetailsPage extends StatefulWidget {
  const ProfileDetailsPage({super.key});

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
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
  late ProfileGender _gender;
  late DateTime _dob;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: ProfileMockData.displayName);
    _mobileCtrl = TextEditingController(text: ProfileMockData.mobile);
    _dob = ProfileMockData.dob;
    _dobCtrl = TextEditingController(text: _dobLabel(_dob));
    _idCtrl = TextEditingController(text: ProfileMockData.identification);
    _emailCtrl = TextEditingController(text: ProfileMockData.email);
    _gender = ProfileMockData.gender;
  }

  String _dobLabel(DateTime d) {
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    return '$day.$month.${d.year}';
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
      _dobCtrl.text = _dobLabel(picked);
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
      _dobError = _dobCtrl.text.trim().isEmpty ? 'Date of birth is required' : null;
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

    ProfileMockData.displayName = name;
    ProfileMockData.mobile = mobile;
    ProfileMockData.identification = id;
    ProfileMockData.email = email;
    ProfileMockData.gender = _gender;
    ProfileMockData.dob = _dob;
    setState(() => _submitting = false);

    await AppStatusDialog.show(
      context,
      type: AppStatusType.success,
      title: 'Profile updated',
      message: 'Your profile details have been saved.',
      actionLabel: 'OK',
    );
    if (!mounted) return;
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ProfileSubAppBar(title: 'Profile Details'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.lightPrimary,
                  child: Text(
                    ProfileMockData.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    elevation: 1,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => AppStatusDialog.show(
                        context,
                        type: AppStatusType.info,
                        title: 'Photo',
                        message: 'Camera / gallery picker later — prototype stub.',
                        actionLabel: 'OK',
                      ),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.lightBorder),
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
              icon: const Icon(
                Icons.calendar_today_outlined,
                size: 18,
                color: AppColors.lightTextSecondary,
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
          const Text(
            'Gender',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _GenderChip(
                  label: 'Male',
                  selected: _gender == ProfileGender.male,
                  onTap: () => setState(() => _gender = ProfileGender.male),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _GenderChip(
                  label: 'Female',
                  selected: _gender == ProfileGender.female,
                  onTap: () => setState(() => _gender = ProfileGender.female),
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
      color: Colors.white,
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
              color: selected ? AppColors.lightPrimary : AppColors.lightBorder,
              width: selected ? 1.6 : 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: selected
                  ? AppColors.lightPrimary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
