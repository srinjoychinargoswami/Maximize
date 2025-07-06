import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:maximize/models/reminder_model.dart';
import 'package:maximize/services/reminder_service.dart'; // Adjust path if needed

class ReminderPage extends StatefulWidget {
  const ReminderPage({Key? key}) : super(key: key);

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  final TextEditingController _titleController = TextEditingController();
  DateTime? _selectedDateTime;

  final List<ReminderModel> _reminders = [];

  late final NotificationService _notificationService;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _notificationService = NotificationService(); // Initialize service
  }

  void _addReminder() {
    if (_titleController.text.isEmpty || _selectedDateTime == null) return;

    final reminder = ReminderModel(
      title: _titleController.text.trim(),
      body: "It's time for: ${_titleController.text.trim()}",
      scheduledTime: _selectedDateTime!,
    );

    setState(() {
      _reminders.add(reminder);
    });

    _notificationService.scheduleNotification(reminder);

    _titleController.clear();
    _selectedDateTime = null;
    FocusScope.of(context).unfocus();
  }

  void _deleteReminder(ReminderModel reminder) {
    _notificationService.cancelNotification(reminder.id);
    setState(() {
      _reminders.removeWhere((r) => r.id == reminder.id);
    });
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(minutes: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final time = await showTimePicker(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reminders')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Reminder Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(_selectedDateTime == null
                      ? 'No time selected'
                      : 'At: ${_selectedDateTime!.toLocal().toString().substring(0, 16)}'),
                ),
                ElevatedButton(
                  onPressed: _pickDateTime,
                  child: const Text('Pick Date & Time'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _addReminder,
              child: const Text('Add Reminder'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _reminders.length,
                itemBuilder: (context, index) {
                  final reminder = _reminders[index];
                  return ListTile(
                    leading: const Icon(Icons.alarm),
                    title: Text(reminder.title),
                    subtitle: Text(reminder.scheduledTime
                        .toLocal()
                        .toString()
                        .substring(0, 16)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteReminder(reminder),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
