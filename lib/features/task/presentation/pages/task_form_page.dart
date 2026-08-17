import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors, PrototypeConfig;
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/task/presentation/models/task_mock_data.dart';
import 'package:life_insurance/features/task/presentation/widgets/onboarding_detail_fields.dart';

/// Create / edit task — wireframe Task Management form (docs/68).
class TaskFormPage extends StatefulWidget {
  const TaskFormPage({super.key, this.taskId, this.initialDay});

  final String? taskId;
  final DateTime? initialDay;

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  TaskMock? _existing;
  late DateTime _start;
  late DateTime _end;
  late TaskType _type;
  late TaskPriority _priority;
  late TaskStatus _status;
  late final TextEditingController _title;
  late final TextEditingController _description;
  late final TextEditingController _startCtrl;
  late final TextEditingController _endCtrl;
  late final TextEditingController _typeCtrl;
  late final TextEditingController _priorityCtrl;
  late final TextEditingController _statusCtrl;
  late final TextEditingController _idCtrl;
  late OnboardingMock _onboard;
  final _onboardKey = GlobalKey<OnboardingDetailFieldsState>();
  int _onboardTab = 0;
  int _attachments = 0;
  bool _saving = false;
  String? _error;

  bool get _isEdit => _existing != null;

  @override
  void initState() {
    super.initState();
    _existing = widget.taskId == null ? null : TaskSession.byId(widget.taskId!);
    final day = widget.initialDay ?? DateTime(2026, 8, 14);
    if (_existing != null) {
      final t = _existing!;
      _start = t.startAt;
      _end = t.endAt;
      _type = t.type;
      _priority = t.priority;
      _status = t.status;
      _title = TextEditingController(text: t.title);
      _description = TextEditingController(text: t.description);
      _attachments = t.attachmentCount;
      _onboard = t.onboarding?.copy() ?? OnboardingMock(agentName: t.title);
    } else {
      _start = DateTime(day.year, day.month, day.day, 9, 0);
      _end = DateTime(day.year, day.month, day.day, 10, 0);
      _type = TaskType.meeting;
      _priority = TaskPriority.high;
      _status = TaskStatus.pending;
      _title = TextEditingController();
      _description = TextEditingController();
      _onboard = OnboardingMock();
    }
    _startCtrl = TextEditingController(text: TaskFormat.dob(_start));
    _endCtrl = TextEditingController(text: TaskFormat.dob(_end));
    _typeCtrl = TextEditingController(text: _type.label);
    _priorityCtrl = TextEditingController(text: _priority.label);
    _statusCtrl = TextEditingController(text: _status.label);
    _idCtrl = TextEditingController(text: _existing?.id ?? 'New');
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _startCtrl.dispose();
    _endCtrl.dispose();
    _typeCtrl.dispose();
    _priorityCtrl.dispose();
    _statusCtrl.dispose();
    _idCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool start}) async {
    final initial = start ? _start : _end;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked == null) return;
    setState(() {
      if (start) {
        _start = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _start.hour,
          _start.minute,
        );
        _startCtrl.text = TaskFormat.dob(_start);
        if (_end.isBefore(_start)) {
          _end = _start.add(const Duration(hours: 1));
          _endCtrl.text = TaskFormat.dob(_end);
        }
      } else {
        _end = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _end.hour,
          _end.minute,
        );
        if (_end.isBefore(_start)) {
          _end = _start.add(const Duration(hours: 1));
        }
        _endCtrl.text = TaskFormat.dob(_end);
      }
    });
  }

  Future<void> _pickEnum<T>({
    required String title,
    required List<T> options,
    required T current,
    required String Function(T) labelOf,
    required ValueChanged<T> onPick,
  }) async {
    final picked = await showModalBottomSheet<T>(
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
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            for (final o in options)
              ListTile(
                title: Text(labelOf(o)),
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
  }

  bool get _isOnboarding => _type == TaskType.onboarding;

  Future<void> _save({bool markCompleted = false}) async {
    _onboardKey.currentState?.flush();
    final title = _isOnboarding
        ? (_onboard.agentName.trim().isNotEmpty
              ? _onboard.agentName.trim()
              : _title.text.trim())
        : _title.text.trim();
    if (title.isEmpty) {
      setState(
        () => _error = _isOnboarding
            ? 'Agent name is required for On-Boarding.'
            : 'Task title is required.',
      );
      return;
    }
    if (_isOnboarding && _onboard.agentName.trim().isEmpty) {
      _onboard.agentName = title;
    }
    setState(() {
      _error = null;
      _saving = true;
    });
    await Future<void>.delayed(PrototypeConfig.shortDelay);
    if (!mounted) return;

    final status = markCompleted ? TaskStatus.completed : _status;
    if (_isEdit) {
      final t = _existing!;
      t
        ..title = title
        ..description = _isOnboarding ? '' : _description.text.trim()
        ..type = _type
        ..priority = _priority
        ..status = status
        ..startAt = _start
        ..endAt = _end
        ..attachmentCount = _attachments
        ..isNewAssignment = false
        ..onboarding = _isOnboarding ? _onboard.copy() : null;
      TaskSession.upsert(t);
    } else {
      TaskSession.create(
        title: title,
        description: _isOnboarding ? '' : _description.text.trim(),
        type: _type,
        priority: _priority,
        status: status,
        startAt: _start,
        endAt: _end,
        attachmentCount: _attachments,
        onboarding: _isOnboarding ? _onboard.copy() : null,
      );
    }
    setState(() => _saving = false);
    if (!mounted) return;
    context.pop(true);
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
          'Task Management',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.surface(context),
        foregroundColor: AppColors.onSurface(context),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                const Text(
                  'Task Information',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
                const SizedBox(height: 14),
                if (_error != null) ...[
                  Text(
                    _error!,
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                if (_isOnboarding)
                  ..._onboardingHeader()
                else
                  ..._dailyHeader(),
                if (_isOnboarding) ...[
                  const SizedBox(height: 22),
                  OnboardingDetailFields(
                    key: _onboardKey,
                    data: _onboard,
                    tab: _onboardTab,
                    onTab: (i) => setState(() => _onboardTab = i),
                    onChanged: () => setState(() {}),
                    uploadSlot: _onboardTab == 0 ? _uploadBlock() : null,
                  ),
                ] else ...[
                  const SizedBox(height: 18),
                  _uploadBlock(),
                ],
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Column(
                children: [
                  AppButton(
                    label: 'SAVE',
                    isLoading: _saving,
                    onPressed: () => _save(),
                  ),
                  if (_isEdit && _status != TaskStatus.completed) ...[
                    const SizedBox(height: 8),
                    AppButton(
                      label: 'MARK COMPLETED',
                      variant: AppButtonVariant.secondary,
                      onPressed: _saving
                          ? null
                          : () => _save(markCompleted: true),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onTypePicked(TaskType t) {
    _onboardKey.currentState?.flush();
    setState(() {
      _type = t;
      _typeCtrl.text = t.label;
      if (t == TaskType.onboarding &&
          _onboard.agentName.isEmpty &&
          _title.text.trim().isNotEmpty) {
        _onboard.agentName = _title.text.trim();
      }
    });
  }

  List<Widget> _onboardingHeader() {
    return [
      AppTextField(
        label: 'Task ID',
        controller: _idCtrl,
        readOnly: true,
        enabled: false,
      ),
      const SizedBox(height: 14),
      AppTextField(
        label: 'Task Name',
        isRequired: true,
        controller: _title,
        onChanged: (v) {
          if (_onboard.agentName.isEmpty || _onboard.agentName == _title.text) {
            _onboard.agentName = v;
          }
        },
      ),
      const SizedBox(height: 14),
      _typeField(),
      const SizedBox(height: 14),
      _priorityField(),
      const SizedBox(height: 14),
      _statusField(),
      const SizedBox(height: 14),
      _startField(),
      const SizedBox(height: 14),
      _endField(),
    ];
  }

  List<Widget> _dailyHeader() {
    return [
      _startField(),
      const SizedBox(height: 14),
      _endField(),
      const SizedBox(height: 14),
      AppTextField(label: 'Task Title', isRequired: true, controller: _title),
      const SizedBox(height: 14),
      _typeField(),
      const SizedBox(height: 14),
      Text(
        'Task Description *',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurfaceSecondary(context),
        ),
      ),
      const SizedBox(height: 6),
      TextField(
        controller: _description,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: 'Describe the task',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.lightPrimary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.lightPrimary.withValues(alpha: 0.55),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.lightPrimary,
              width: 1.5,
            ),
          ),
          contentPadding: const EdgeInsets.all(12),
        ),
      ),
      const SizedBox(height: 14),
      _priorityField(),
      const SizedBox(height: 14),
      _statusField(),
    ];
  }

  Widget _typeField() {
    return AppTextField(
      label: 'Task Type',
      isRequired: true,
      controller: _typeCtrl,
      readOnly: true,
      onTap: () => _pickEnum<TaskType>(
        title: 'Task Type',
        options: TaskType.values,
        current: _type,
        labelOf: (t) => t.label,
        onPick: _onTypePicked,
      ),
      suffix: const Icon(Icons.expand_more, size: 18),
    );
  }

  Widget _priorityField() {
    return AppTextField(
      label: 'Priority',
      isRequired: true,
      controller: _priorityCtrl,
      readOnly: true,
      onTap: () => _pickEnum<TaskPriority>(
        title: 'Priority',
        options: TaskPriority.values,
        current: _priority,
        labelOf: (p) => p.label,
        onPick: (p) => setState(() {
          _priority = p;
          _priorityCtrl.text = p.label;
        }),
      ),
      suffix: const Icon(Icons.expand_more, size: 18),
    );
  }

  Widget _statusField() {
    return AppTextField(
      label: 'Status',
      isRequired: true,
      controller: _statusCtrl,
      readOnly: true,
      onTap: () => _pickEnum<TaskStatus>(
        title: 'Status',
        options: TaskStatus.values,
        current: _status,
        labelOf: (s) => s.label,
        onPick: (s) => setState(() {
          _status = s;
          _statusCtrl.text = s.label;
        }),
      ),
      suffix: const Icon(Icons.expand_more, size: 18),
    );
  }

  Widget _startField() {
    return AppTextField(
      label: 'Start Date',
      isRequired: true,
      controller: _startCtrl,
      readOnly: true,
      onTap: () => _pickDate(start: true),
      suffix: IconButton(
        onPressed: () => _pickDate(start: true),
        icon: const Icon(Icons.calendar_today_outlined, size: 18),
      ),
    );
  }

  Widget _endField() {
    return AppTextField(
      label: 'End Date',
      isRequired: true,
      controller: _endCtrl,
      readOnly: true,
      onTap: () => _pickDate(start: false),
      suffix: IconButton(
        onPressed: () => _pickDate(start: false),
        icon: const Icon(Icons.calendar_today_outlined, size: 18),
      ),
    );
  }

  Widget _uploadBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload',
          style: TextStyle(
            color: AppColors.lightPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            InkWell(
              onTap: () => setState(() {
                if (_attachments < 3) _attachments += 1;
              }),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.lightPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.lightPrimary.withValues(alpha: 0.35),
                  ),
                ),
                child: const Icon(
                  Icons.create_new_folder_outlined,
                  color: AppColors.lightPrimary,
                ),
              ),
            ),
            const SizedBox(width: 10),
            for (var i = 0; i < _attachments; i++) ...[
              Container(
                width: 72,
                height: 56,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: AppColors.lightPrimary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.image_outlined,
                  color: AppColors.lightPrimary,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Attachment stub — prototype, no upload API.',
          style: TextStyle(fontSize: 11, color: AppColors.hint(context)),
        ),
      ],
    );
  }
}
