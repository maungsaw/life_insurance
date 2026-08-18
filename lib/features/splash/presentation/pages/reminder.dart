import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppDate;
import 'package:life_insurance/core/reminder/notifier.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  final ReminderNotifier _notifier = ReminderNotifier();
  final TextEditingController _titleController = TextEditingController();

  DateTime? _selectedDateTime;

  @override
  void dispose() {
    _notifier.dispose();
    _titleController.dispose();
    super.dispose();
  }

  // Picker flow for Custom Date and Time
  Future<void> _pickDateTime() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date == null) return;

    if (!mounted) return;
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _showAddReminderDialog() {
    _selectedDateTime = null;
    _titleController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('New Reminder'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'Enter reminder title...',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.calendar_today),
                        label: const Text('Pick Time'),
                        onPressed: () async {
                          await _pickDateTime();
                          setDialogState(() {}); // Refresh dialog state
                        },
                      ),
                    ],
                  ),
                  if (_selectedDateTime != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Selected: ${AppDate.dMyHm(_selectedDateTime!)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_titleController.text.isNotEmpty &&
                        _selectedDateTime != null) {
                      _notifier.addReminder(
                        _titleController.text,
                        _selectedDateTime!,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Schedule'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Timed Reminders')),
      body: ListenableBuilder(
        listenable: _notifier,
        builder: (context, child) {
          final list = _notifier.reminders;
          if (list.isEmpty) {
            return const Center(child: Text('No scheduled reminders'));
          }
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final reminder = list[index];
              return ListTile(
                title: Text(reminder.title),
                subtitle: Text(reminder.dateTime.toString()),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _notifier.removeReminder(reminder.id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddReminderDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
