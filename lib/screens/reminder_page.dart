import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:maximize/models/reminder_model.dart';
import 'package:maximize/models/database.dart'; // Access Drift DB
import 'package:maximize/services/reminder_service.dart';

class ReminderPage extends StatefulWidget {
  final AppDatabase database; // Inject the database

  const ReminderPage({Key? key, required this.database}) : super(key: key);

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  final TextEditingController _titleController = TextEditingController();
  DateTime? _selectedDateTime;

  List<ReminderModel> _reminders = [];

  late final NotificationService _notificationService;
  bool _isNotificationServiceReady = false;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _notificationService = NotificationService.instance;
    _initializeNotificationService();
    _loadRemindersFromDatabase();
  }

  Future<void> _initializeNotificationService() async {
    try {
      await _notificationService.initialize();
      setState(() {
        _isNotificationServiceReady = true;
      });
      print('[ReminderPage] NotificationService initialized successfully');
    } catch (e) {
      print('[ReminderPage] Failed to initialize NotificationService: $e');
      setState(() {
        _isNotificationServiceReady = false;
      });
    }
  }

  Future<void> _loadRemindersFromDatabase() async {
    try {
      final reminderDataList = await widget.database.getAllReminders();
      setState(() {
        _reminders = reminderDataList.map((data) {
          return ReminderModel(
            id: data.id,
            title: data.title,
            body: data.body,
            scheduledTime: data.scheduledTime,
            notificationId: data.notificationId, // Already String in updated database
          );
        }).toList();
      });
    } catch (e) {
      print('[ReminderPage] Error loading reminders: $e');
    }
  }

  Future<void> _addReminder() async {
    if (_titleController.text.isEmpty || _selectedDateTime == null) return;

    // Show loading indicator while processing
    if (!_isNotificationServiceReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification service is initializing, please wait...')),
      );
      return;
    }

    try {
      final reminder = ReminderModel(
        title: _titleController.text.trim(),
        body: "It's time for: ${_titleController.text.trim()}",
        scheduledTime: _selectedDateTime!,
      );

      // Insert into database - the ReminderModel constructor will generate notificationId
      await widget.database.insertReminder(reminder);

      // Schedule notification using the generated notificationId
      await _notificationService.scheduleNotification(reminder);

      // Reload reminders from database to get the saved version
      await _loadRemindersFromDatabase();

      _titleController.clear();
      _selectedDateTime = null;
      FocusScope.of(context).unfocus();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reminder added successfully!')),
      );
    } catch (e) {
      print('[ReminderPage] Error adding reminder: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding reminder: $e')),
      );
    }
  }

  Future<void> _editReminder(ReminderModel reminder) async {
    if (!_isNotificationServiceReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification service is not ready')),
      );
      return;
    }

    final TextEditingController editTitleController = 
        TextEditingController(text: reminder.title);
    DateTime? editSelectedDateTime = reminder.scheduledTime;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Reminder'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: editTitleController,
                    decoration: const InputDecoration(
                      labelText: 'Reminder Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'At: ${editSelectedDateTime!.toLocal().toString().substring(0, 16)}',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: editSelectedDateTime!,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (date == null) return;

                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(editSelectedDateTime!),
                          );
                          if (time == null) return;

                          setDialogState(() {
                            editSelectedDateTime = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        },
                        child: const Text('Change Time'),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (editTitleController.text.isEmpty) return;

                    try {
                      // Cancel old notification using the existing notificationId
                      await _notificationService.cancelNotification(reminder.notificationId);

                      // Create updated reminder with same IDs but new content
                      final updatedReminder = reminder.copyWith(
                        title: editTitleController.text.trim(),
                        body: "It's time for: ${editTitleController.text.trim()}",
                        scheduledTime: editSelectedDateTime!,
                      );

                      // Update in database
                      await widget.database.updateReminder(updatedReminder);

                      // Schedule new notification with updated content
                      await _notificationService.scheduleNotification(updatedReminder);

                      // Reload reminders from database
                      await _loadRemindersFromDatabase();

                      Navigator.of(context).pop();

                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Reminder updated successfully!')),
                      );
                    } catch (e) {
                      print('[ReminderPage] Error updating reminder: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error updating reminder: $e')),
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteReminder(ReminderModel reminder) async {
    if (!_isNotificationServiceReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification service is not ready')),
      );
      return;
    }

    try {
      // Cancel the notification first
      await _notificationService.cancelNotification(reminder.notificationId);
      
      // Delete from database
      await widget.database.deleteReminder(reminder.id);

      // Reload reminders from database
      await _loadRemindersFromDatabase();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reminder deleted successfully!')),
      );
    } catch (e) {
      print('[ReminderPage] Error deleting reminder: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting reminder: $e')),
      );
    }
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
      appBar: AppBar(
        title: const Text('Reminders'),
        actions: [
          if (!_isNotificationServiceReady)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
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
              onPressed: _isNotificationServiceReady ? _addReminder : null,
              child: Text(_isNotificationServiceReady 
                  ? 'Add Reminder' 
                  : 'Initializing...'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _reminders.length,
                itemBuilder: (context, index) {
                  final reminder = _reminders[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.alarm, color: Colors.orange),
                      title: Text(reminder.title),
                      subtitle: Text(
                        'Scheduled: ${reminder.scheduledTime.toLocal().toString().substring(0, 16)}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: _isNotificationServiceReady 
                                ? () => _editReminder(reminder)
                                : null,
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: _isNotificationServiceReady 
                                ? () => _deleteReminder(reminder)
                                : null,
                          ),
                        ],
                      ),
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
