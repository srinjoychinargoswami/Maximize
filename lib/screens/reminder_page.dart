import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
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
  List<ReminderModel> _expandedReminders = []; // For displaying recurring instances

  late final NotificationService _notificationService;
  late final ReminderService _reminderService; // ADDED: ReminderService for unified completion handling
  bool _isNotificationServiceReady = false;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _notificationService = NotificationService.instance;
    _reminderService = ReminderService(widget.database); // ADDED: Initialize ReminderService
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

  // ENHANCED: Load reminders using ReminderService with completion status
  Future<void> _loadRemindersFromDatabase() async {
    try {
      _reminders = await _reminderService.getReminders(); // ENHANCED: Use service method
      setState(() {
        _expandedReminders = _expandRecurringReminders(_reminders);
      });
    } catch (e) {
      print('[ReminderPage] Error loading reminders: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading reminders: $e')),
      );
    }
  }

  // ADDED: Toggle reminder completion using ReminderService (unified checkbox system)
  Future<void> _toggleReminderCompletion(ReminderModel reminder, bool? isCompleted) async {
    try {
      if (isCompleted == true) {
        await _reminderService.markReminderCompleted(reminder.id);
      } else {
        await _reminderService.markReminderIncomplete(reminder.id);
      }
      
      // Reload reminders to get updated data from database
      await _loadRemindersFromDatabase();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update reminder: $error')),
      );
    }
  }

  // Expand recurring reminders to show individual instances
  List<ReminderModel> _expandRecurringReminders(List<ReminderModel> reminders) {
    List<ReminderModel> expandedReminders = [];
    final now = DateTime.now();
    final futureLimit = now.add(Duration(days: 90)); // Show next 3 months

    for (ReminderModel reminder in reminders) {
      if (reminder.isRecurring && reminder.recurrenceRule != null) {
        // Generate recurring instances
        List<DateTime> occurrences = _generateRecurrenceOccurrences(
          reminder.scheduledTime,
          reminder.recurrenceRule!,
          now.subtract(Duration(days: 1)), // Show today's past reminders
          futureLimit,
          reminder.recurrenceExceptionDates,
        );

        for (DateTime occurrence in occurrences) {
          if (reminder.recurrenceCount != null && 
              occurrences.indexOf(occurrence) >= reminder.recurrenceCount!) {
            break;
          }
          
          if (reminder.recurrenceEndDate != null && 
              occurrence.isAfter(reminder.recurrenceEndDate!)) {
            break;
          }

          // Create instance for this occurrence
          ReminderModel instance = reminder.copyWith(
            id: '${reminder.id}_${occurrence.millisecondsSinceEpoch}',
            scheduledTime: occurrence,
            parentReminderId: reminder.id,
          );
          expandedReminders.add(instance);
        }
      } else {
        // Non-recurring reminder
        expandedReminders.add(reminder);
      }
    }

    // Sort by scheduled time
    expandedReminders.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
    return expandedReminders;
  }

  // Generate recurrence occurrences based on RRULE
  List<DateTime> _generateRecurrenceOccurrences(
    DateTime startDate,
    String rrule,
    DateTime rangeStart,
    DateTime rangeEnd,
    List<DateTime>? exceptions,
  ) {
    List<DateTime> occurrences = [];
    Map<String, String> rules = _parseRRule(rrule);
    
    String? frequency = rules['FREQ'];
    int interval = int.parse(rules['INTERVAL'] ?? '1');
    int? count = rules['COUNT'] != null ? int.parse(rules['COUNT']!) : null;
    
    DateTime current = startDate;
    int occurrenceCount = 0;
    
    while (current.isBefore(rangeEnd) && (count == null || occurrenceCount < count)) {
      if (current.isAfter(rangeStart) || current.isAtSameMomentAs(rangeStart)) {
        bool isException = exceptions?.any((ex) => _isSameDay(ex, current)) ?? false;
        if (!isException) {
          occurrences.add(current);
          occurrenceCount++;
        }
      }
      
      current = _getNextOccurrence(current, frequency!, interval);
      
      // Safety check to prevent infinite loops
      if (occurrenceCount > 100) break;
    }
    
    return occurrences;
  }

  Map<String, String> _parseRRule(String rrule) {
    Map<String, String> rules = {};
    List<String> parts = rrule.split(';');
    
    for (String part in parts) {
      List<String> keyValue = part.split('=');
      if (keyValue.length == 2) {
        rules[keyValue[0]] = keyValue[1];
      }
    }
    
    return rules;
  }

  DateTime _getNextOccurrence(DateTime current, String frequency, int interval) {
    switch (frequency.toUpperCase()) {
      case 'HOURLY':
        return current.add(Duration(hours: interval));
      case 'DAILY':
        return current.add(Duration(days: interval));
      case 'WEEKLY':
        return current.add(Duration(days: 7 * interval));
      case 'MONTHLY':
        return DateTime(current.year, current.month + interval, current.day, 
                       current.hour, current.minute);
      case 'YEARLY':
        return DateTime(current.year + interval, current.month, current.day, 
                       current.hour, current.minute);
      default:
        return current.add(Duration(days: interval));
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _showAddReminderDialog() {
    final TextEditingController titleController = TextEditingController();
    DateTime? selectedDateTime;
    
    // Recurrence settings
    bool isRecurring = false;
    ReminderRecurrenceFrequency selectedFrequency = ReminderRecurrenceFrequency.daily;
    int interval = 1;
    int? recurrenceCount;
    DateTime? recurrenceEndDate;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Reminder'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Reminder Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Date and time selection
                    Row(
                      children: [
                        Expanded(
                          child: Text(selectedDateTime == null
                              ? 'No time selected'
                              : 'At: ${selectedDateTime!.toLocal().toString().substring(0, 16)}'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
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

                            setDialogState(() {
                              selectedDateTime = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time.hour,
                                time.minute,
                              );
                            });
                          },
                          child: const Text('Pick Date & Time'),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    _buildRecurrenceSelector(
                      isRecurring, selectedFrequency, interval, 
                      recurrenceCount, recurrenceEndDate, setDialogState,
                      (recurring) => isRecurring = recurring,
                      (freq) => selectedFrequency = freq,
                      (intv) => interval = intv,
                      (count) => recurrenceCount = count,
                      (endDate) => recurrenceEndDate = endDate,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (titleController.text.isNotEmpty && selectedDateTime != null) {
                      await _saveNewReminder(
                        titleController, selectedDateTime!,
                        isRecurring, selectedFrequency, interval, 
                        recurrenceCount, recurrenceEndDate,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildRecurrenceSelector(
    bool isRecurring, ReminderRecurrenceFrequency frequency, int interval,
    int? count, DateTime? endDate, StateSetter setDialogState,
    Function(bool) onRecurringChanged,
    Function(ReminderRecurrenceFrequency) onFrequencyChanged,
    Function(int) onIntervalChanged,
    Function(int?) onCountChanged,
    Function(DateTime?) onEndDateChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: isRecurring,
              onChanged: (value) {
                setDialogState(() {
                  onRecurringChanged(value ?? false);
                });
              },
            ),
            const Text('Recurring Reminder'),
          ],
        ),
        if (isRecurring) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Repeat every '),
              SizedBox(
                width: 60,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: interval.toString(),
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  onChanged: (value) {
                    int? newInterval = int.tryParse(value);
                    if (newInterval != null && newInterval > 0) {
                      onIntervalChanged(newInterval);
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<ReminderRecurrenceFrequency>(
                value: frequency,
                items: ReminderRecurrenceFrequency.values.map((freq) {
                  String label = freq.name;
                  if (interval > 1) {
                    switch (freq) {
                      case ReminderRecurrenceFrequency.hourly:
                        label = 'hours';
                        break;
                      case ReminderRecurrenceFrequency.daily:
                        label = 'days';
                        break;
                      case ReminderRecurrenceFrequency.weekly:
                        label = 'weeks';
                        break;
                      case ReminderRecurrenceFrequency.monthly:
                        label = 'months';
                        break;
                      case ReminderRecurrenceFrequency.yearly:
                        label = 'years';
                        break;
                      default:
                        break;
                    }
                  }
                  return DropdownMenuItem(
                    value: freq,
                    child: Text(label),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setDialogState(() {
                      onFrequencyChanged(value);
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text('End recurrence:'),
          Row(
            children: [
              Radio<String>(
                value: 'never',
                groupValue: count != null ? 'count' : (endDate != null ? 'date' : 'never'),
                onChanged: (value) {
                  setDialogState(() {
                    onCountChanged(null);
                    onEndDateChanged(null);
                  });
                },
              ),
              const Text('Never'),
            ],
          ),
          Row(
            children: [
              Radio<String>(
                value: 'count',
                groupValue: count != null ? 'count' : (endDate != null ? 'date' : 'never'),
                onChanged: (value) {
                  setDialogState(() {
                    onCountChanged(10);
                    onEndDateChanged(null);
                  });
                },
              ),
              const Text('After '),
              SizedBox(
                width: 60,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: count?.toString() ?? '10',
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  onChanged: (value) {
                    int? newCount = int.tryParse(value);
                    if (newCount != null && newCount > 0) {
                      onCountChanged(newCount);
                    }
                  },
                ),
              ),
              const Text(' times'),
            ],
          ),
          Row(
            children: [
              Radio<String>(
                value: 'date',
                groupValue: count != null ? 'count' : (endDate != null ? 'date' : 'never'),
                onChanged: (value) {
                  setDialogState(() {
                    onCountChanged(null);
                    onEndDateChanged(DateTime.now().add(const Duration(days: 30)));
                  });
                },
              ),
              const Text('On '),
              TextButton(
                onPressed: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: endDate ?? DateTime.now().add(const Duration(days: 30)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    setDialogState(() {
                      onEndDateChanged(selectedDate);
                      onCountChanged(null);
                    });
                  }
                },
                child: Text(endDate != null 
                  ? '${endDate.toLocal().toString().substring(0, 10)}'
                  : 'Select Date'),
              ),
            ],
          ),
        ],
      ],
    );
  }

  // ENHANCED: Save new reminder using ReminderService
  Future<void> _saveNewReminder(
    TextEditingController titleController,
    DateTime selectedDateTime,
    bool isRecurring, ReminderRecurrenceFrequency frequency, int interval,
    int? recurrenceCount, DateTime? recurrenceEndDate,
  ) async {
    try {
      final reminder = ReminderModel(
        title: titleController.text.trim(),
        body: "It's time for: ${titleController.text.trim()}",
        scheduledTime: selectedDateTime,
        completed: false, // ADDED: Initialize with completion status
        completedAt: null, // ADDED: Initialize completion timestamp
        isRecurring: isRecurring,
        recurrencePattern: isRecurring ? ReminderRecurrencePattern(
          frequency: frequency,
          interval: interval,
        ) : null,
        recurrenceCount: recurrenceCount,
        recurrenceEndDate: recurrenceEndDate,
      );

      if (isRecurring) {
        reminder.recurrenceRule = reminder.generateRRule();
      }

      // ENHANCED: Use ReminderService instead of direct database access
      await _reminderService.addReminder(reminder);

      // Schedule recurring notifications if needed
      if (isRecurring) {
        await _scheduleRecurringNotifications(reminder);
      }

      // Reload reminders from database
      await _loadRemindersFromDatabase();

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

  Future<void> _scheduleRecurringNotifications(ReminderModel reminder) async {
    // For recurring reminders, schedule the next few occurrences
    final now = DateTime.now();
    final nextMonth = now.add(const Duration(days: 30));
    
    final occurrences = _generateRecurrenceOccurrences(
      reminder.scheduledTime,
      reminder.recurrenceRule!,
      now,
      nextMonth,
      null,
    );

    // Schedule up to 10 upcoming notifications
    for (int i = 0; i < occurrences.length && i < 10; i++) {
      final occurrence = occurrences[i];
      final instanceReminder = reminder.copyWith(
        id: '${reminder.id}_$i',
        scheduledTime: occurrence,
        notificationId: '${reminder.notificationId}_$i',
      );
      
      await _notificationService.scheduleNotification(instanceReminder);
    }
  }

  // ENHANCED: Add simple reminder using ReminderService
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
        completed: false, // ADDED: Initialize with completion status
        completedAt: null, // ADDED: Initialize completion timestamp
      );

      // ENHANCED: Use ReminderService instead of direct database access
      await _reminderService.addReminder(reminder);

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
    // Check if this is a recurring reminder instance
    bool isRecurringInstance = reminder.parentReminderId != null;
    
    if (isRecurringInstance) {
      _showRecurrenceEditDialog(reminder);
    } else {
      _showEditReminderDialog(reminder);
    }
  }

  void _showRecurrenceEditDialog(ReminderModel reminder) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Recurring Reminder'),
          content: const Text('This is part of a recurring series. What would you like to edit?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _editSingleOccurrence(reminder);
              },
              child: const Text('This Reminder Only'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _editEntireSeries(reminder);
              },
              child: const Text('Entire Series'),
            ),
          ],
        );
      },
    );
  }

  void _editSingleOccurrence(ReminderModel reminder) {
    // Create an exception for this occurrence
    _showEditReminderDialog(reminder, isSingleOccurrence: true);
  }

  void _editEntireSeries(ReminderModel reminder) {
    // Find the parent reminder and edit it
    ReminderModel? parentReminder = _reminders.firstWhere(
      (r) => r.id == reminder.parentReminderId,
      orElse: () => reminder,
    );
    _showEditReminderDialog(parentReminder);
  }

  void _showEditReminderDialog(ReminderModel reminder, {bool isSingleOccurrence = false}) {
    final TextEditingController editTitleController = 
        TextEditingController(text: reminder.title);
    DateTime? editSelectedDateTime = reminder.scheduledTime;
    
    // Recurrence settings
    bool isRecurring = reminder.isRecurring && !isSingleOccurrence;
    ReminderRecurrenceFrequency selectedFrequency = ReminderRecurrenceFrequency.daily;
    int interval = 1;
    int? recurrenceCount = reminder.recurrenceCount;
    DateTime? recurrenceEndDate = reminder.recurrenceEndDate;

    if (reminder.recurrencePattern != null) {
      selectedFrequency = reminder.recurrencePattern!.frequency;
      interval = reminder.recurrencePattern!.interval;
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isSingleOccurrence ? 'Edit Single Occurrence' : 'Edit Reminder'),
              content: SingleChildScrollView(
                child: Column(
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
                    
                    if (!isSingleOccurrence) ...[
                      const SizedBox(height: 16),
                      _buildRecurrenceSelector(
                        isRecurring, selectedFrequency, interval, 
                        recurrenceCount, recurrenceEndDate, setDialogState,
                        (recurring) => isRecurring = recurring,
                        (freq) => selectedFrequency = freq,
                        (intv) => interval = intv,
                        (count) => recurrenceCount = count,
                        (endDate) => recurrenceEndDate = endDate,
                      ),
                    ],
                  ],
                ),
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
                      await _saveEditedReminder(
                        reminder, editTitleController, editSelectedDateTime!,
                        isRecurring, selectedFrequency, interval, 
                        recurrenceCount, recurrenceEndDate, isSingleOccurrence,
                      );
                      Navigator.of(context).pop();
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

  // ENHANCED: Save edited reminder using ReminderService
  Future<void> _saveEditedReminder(
    ReminderModel originalReminder,
    TextEditingController titleController,
    DateTime selectedDateTime,
    bool isRecurring, ReminderRecurrenceFrequency frequency, int interval,
    int? recurrenceCount, DateTime? recurrenceEndDate,
    bool isSingleOccurrence,
  ) async {
    if (isSingleOccurrence) {
      // Create a new single reminder and add exception to parent
      final newSingleReminder = ReminderModel(
        title: titleController.text.trim(),
        body: "It's time for: ${titleController.text.trim()}",
        scheduledTime: selectedDateTime,
        completed: false, // ADDED: Initialize with completion status
        completedAt: null, // ADDED: Initialize completion timestamp
        isRecurring: false,
      );

      // ENHANCED: Use ReminderService instead of direct database access
      await _reminderService.addReminder(newSingleReminder);

      // Add exception to parent reminder
      ReminderModel? parentReminder = _reminders.firstWhere(
        (r) => r.id == originalReminder.parentReminderId,
        orElse: () => originalReminder,
      );
      
      List<DateTime> exceptions = List.from(parentReminder.recurrenceExceptionDates ?? []);
      exceptions.add(originalReminder.scheduledTime);
      
      ReminderModel updatedParent = parentReminder.copyWith(
        recurrenceExceptionDates: exceptions,
      );
      
      await _reminderService.updateReminder(updatedParent);
    } else {
      // Cancel old notification
      await _notificationService.cancelNotification(originalReminder.notificationId);

      // Update reminder
      final updatedReminder = originalReminder.copyWith(
        title: titleController.text.trim(),
        body: "It's time for: ${titleController.text.trim()}",
        scheduledTime: selectedDateTime,
        isRecurring: isRecurring,
        recurrencePattern: isRecurring ? ReminderRecurrencePattern(
          frequency: frequency,
          interval: interval,
        ) : null,
        recurrenceCount: recurrenceCount,
        recurrenceEndDate: recurrenceEndDate,
      );

      if (isRecurring) {
        updatedReminder.recurrenceRule = updatedReminder.generateRRule();
      }

      // ENHANCED: Use ReminderService instead of direct database access
      await _reminderService.updateReminder(updatedReminder);

      // Schedule new notification(s)
      if (isRecurring) {
        await _scheduleRecurringNotifications(updatedReminder);
      }
    }
    
    await _loadRemindersFromDatabase();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reminder updated successfully!')),
    );
  }

  Future<void> _deleteReminder(ReminderModel reminder) async {
    bool isRecurringInstance = reminder.parentReminderId != null;
    
    if (isRecurringInstance) {
      _showRecurrenceDeleteDialog(reminder);
    } else {
      _showDeleteConfirmationDialog(reminder);
    }
  }

  void _showRecurrenceDeleteDialog(ReminderModel reminder) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Recurring Reminder'),
          content: const Text('This is part of a recurring series. What would you like to delete?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteSingleOccurrence(reminder);
              },
              child: const Text('This Reminder Only'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteEntireSeries(reminder);
              },
              child: const Text('Entire Series'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(ReminderModel reminder) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Reminder'),
          content: Text('Are you sure you want to delete "${reminder.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteSingleReminder(reminder);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // ENHANCED: Delete methods using ReminderService
  Future<void> _deleteSingleOccurrence(ReminderModel reminder) async {
    // Add this occurrence to the parent's exception list
    ReminderModel? parentReminder = _reminders.firstWhere(
      (r) => r.id == reminder.parentReminderId,
      orElse: () => reminder,
    );
    
    List<DateTime> exceptions = List.from(parentReminder.recurrenceExceptionDates ?? []);
    exceptions.add(reminder.scheduledTime);
    
    ReminderModel updatedParent = parentReminder.copyWith(
      recurrenceExceptionDates: exceptions,
    );
    
    await _reminderService.updateReminder(updatedParent);
    await _loadRemindersFromDatabase();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reminder occurrence deleted successfully!')),
    );
  }

  Future<void> _deleteEntireSeries(ReminderModel reminder) async {
    String parentId = reminder.parentReminderId ?? reminder.id;
    await _reminderService.deleteReminder(parentId); // ENHANCED: Use ReminderService
    await _loadRemindersFromDatabase();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reminder series deleted successfully!')),
    );
  }

  Future<void> _deleteSingleReminder(ReminderModel reminder) async {
    if (!_isNotificationServiceReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification service is not ready')),
      );
      return;
    }

    try {
      // ENHANCED: Use ReminderService which handles both notification cancellation and database deletion
      await _reminderService.deleteReminder(reminder.id);

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
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isNotificationServiceReady ? _addReminder : null,
                    child: Text(_isNotificationServiceReady 
                        ? 'Add Simple Reminder' 
                        : 'Initializing...'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isNotificationServiceReady ? _showAddReminderDialog : null,
                    child: const Text('Add Advanced Reminder'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _expandedReminders.length,
                itemBuilder: (context, index) {
                  final reminder = _expandedReminders[index];
                  bool isRecurringInstance = reminder.parentReminderId != null;
                  
                  return Card(
                    // ENHANCED: Visual feedback for completion
                    color: reminder.completed ? Colors.grey[700] : Colors.grey[800],
                    child: ListTile(
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isRecurringInstance ? Icons.repeat : Icons.alarm, 
                            color: isRecurringInstance ? Colors.blue : Colors.orange,
                          ),
                          if (isRecurringInstance) const SizedBox(width: 4),
                        ],
                      ),
                      title: Text(
                        reminder.title,
                        style: TextStyle(
                          color: Colors.white,
                          decoration: reminder.completed ? TextDecoration.lineThrough : null, // ENHANCED: Visual feedback
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Scheduled: ${reminder.scheduledTime.toLocal().toString().substring(0, 16)}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          if (reminder.body.isNotEmpty)
                            Text(
                              reminder.body,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          if (reminder.isRecurring && !isRecurringInstance)
                            Text(
                              reminder.recurrenceDescription,
                              style: TextStyle(
                                color: Colors.blue[600],
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          if (isRecurringInstance)
                            Text(
                              'Part of recurring series',
                              style: TextStyle(
                                color: Colors.blue[600],
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          // ADDED: Show completion status
                          if (reminder.completed && reminder.completedAt != null)
                            Text(
                              'Completed: ${reminder.completedAt!.toLocal().toString().substring(0, 16)}',
                              style: TextStyle(
                                color: Colors.green[600],
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ADDED: Database-backed checkbox for completion/dismissal
                          Checkbox(
                            value: reminder.completed, // ENHANCED: Use database completion status
                            onChanged: (value) => _toggleReminderCompletion(reminder, value), // ENHANCED: Use unified system
                            activeColor: Colors.green,
                          ),
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
