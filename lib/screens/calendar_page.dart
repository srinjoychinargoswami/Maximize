import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:maximize/models/event_model.dart';
import 'package:maximize/services/calendar_service.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// ADDED: CustomScrollBehavior to fix RefreshIndicator on Windows desktop
class CustomScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}

class CalendarPage extends StatefulWidget {
  final CalendarService calendarService;
  const CalendarPage({super.key, required this.calendarService});

  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<Event> _events = [];
  List<Event> _expandedEvents = []; // For displaying recurring instances
  CalendarFormat _calendarFormat = CalendarFormat.month;
  String _currentView = 'calendar';
  Color _selectedColor = Colors.blue;
  bool _isRefreshing = false;
  // New Reminder fields
  bool _reminderEnabled = false;
  DateTime? _reminderTime;
  String _reminderPreset = 'at_time'; 
  final List<Map<String, String>> _reminderPresets = [
  {'value': 'at_time', 'label': 'At time of event'},
  {'value': '15min', 'label': '15 minutes before'},
  {'value': '30min', 'label': '30 minutes before'},
  {'value': '1hour', 'label': '1 hour before'},
  {'value': '1day', 'label': '1 day before'},
  {'value': 'custom', 'label': 'Custom time'},
];

String _searchQuery = ''; 
final TextEditingController _searchController = TextEditingController();
final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }




  // ENHANCED: Load events with completion status from database
  Future<void> _loadEvents() async {
    try {
      List<Event> events = await widget.calendarService.getEvents();
      print('Loaded ${events.length} events from calendar service');
      
      setState(() {
        _expandedEvents = events; // Use events directly from service (already expanded with completion status)
      });
    } catch (e) {
      print('Error loading events: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading events: $e')),
      );
    }
  }

  // ENHANCED: Refresh events method for RefreshIndicator
  Future<void> _refreshEvents() async {
    await _loadEvents();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Calendar refreshed!')),
    );
  }

  // Public refresh method with loading indicator (called from refresh button)
  Future<void> _refreshEventsWithIndicator() async {
    if (_isRefreshing) return; // Prevents multiple simultaneous refreshes

    setState(() => _isRefreshing = true);
    await _loadEvents();
    setState(() => _isRefreshing = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Calendar refreshed!'),
          duration: Duration(seconds: 1),
       ),
      );
    }
  }

List<Event> _filterEvents() {
    if (_searchQuery.isEmpty) return _expandedEvents;
    final q = _searchQuery.toLowerCase();
    return _expandedEvents.where((event) =>
        event.title.toLowerCase().contains(q) ||
        (event.description?.toLowerCase().contains(q) ?? false)
    ).toList();
  }

  void scrollToItem(String id) {
    final index = _expandedEvents.indexWhere((e) => e.id == id);
    if (index != -1) {
      _scrollController.animateTo(
        index * 120.0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }


  // Get events for a specific day (using expanded events)
  List<Event> _getEventsForDay(DateTime day) {
    return _expandedEvents.where((event) {
      return isSameDay(event.date, day) && 
             (event.parentEventId != null || !event.isRecurring); // Only show instances or non-recurring
    }).toList();
  }

  // ENHANCED: Get sorted events for day (chronological order)
  List<Event> _getSortedEventsForDay(DateTime day) {
    List<Event> dayEvents = _getEventsForDay(day);
    dayEvents.sort((a, b) => a.startDateTime.compareTo(b.startDateTime));
    return dayEvents;
  }

  // ENHANCED: Toggle event completion using CalendarService (unified checkbox system)
  Future<void> _toggleEventCompletion(Event event, bool? isCompleted) async {
    try {
      if (isCompleted == true) {
        await widget.calendarService.markEventCompleted(event.id);
      } else {
        await widget.calendarService.markEventIncomplete(event.id);
      }
      
      // Reload events to get updated data from database
      await _loadEvents();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update event: $error')),
      );
    }
  }

  void _editEvent(Event event) {
    // Check if this is a recurring event instance
    bool isRecurringInstance = event.parentEventId != null;
    
    if (isRecurringInstance) {
      _showRecurrenceEditDialog(event);
    } else {
      _showEditEventDialog(event);
    }
  }

  void _showRecurrenceEditDialog(Event event) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Recurring Event'),
          content: Text('This is part of a recurring series. What would you like to edit?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _editSingleOccurrence(event);
              },
              child: Text('This Event Only'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _editEntireSeries(event);
              },
              child: Text('Entire Series'),
            ),
          ],
        );
      },
    );
  }

  void _editSingleOccurrence(Event event) {
    _showEditEventDialog(event, isSingleOccurrence: true);
  }

  void _editEntireSeries(Event event) async {
    try {
      // Get base events to find the parent
      final baseEvents = await widget.calendarService.getBaseEvents();
      Event? parentEvent = baseEvents.firstWhere(
        (e) => e.id == event.parentEventId,
        orElse: () => event,
      );
      _showEditEventDialog(parentEvent);
    } catch (e) {
      print('Error finding parent event: $e');
      _showEditEventDialog(event);
    }
  }

  void _showEditEventDialog(Event event, {bool isSingleOccurrence = false}) {
    final TextEditingController titleController = TextEditingController(text: event.title);
    final TextEditingController descriptionController = TextEditingController(text: event.description);
    final TextEditingController categoryController = TextEditingController(text: event.customCategory ?? '');
    DateTime startDate = event.startDateTime;
    DateTime endDate = event.endDateTime;
    TimeOfDay? startTime = TimeOfDay.fromDateTime(event.startDateTime);
    TimeOfDay? endTime = TimeOfDay.fromDateTime(event.endDateTime);
    Color selectedColor = Color(int.parse(event.color.replaceFirst('#', '0xff')));
    
    // Recurrence settings
    bool isRecurring = event.isRecurring && !isSingleOccurrence;
    RecurrenceFrequency selectedFrequency = RecurrenceFrequency.daily;
    int interval = 1;
    int? recurrenceCount;
    DateTime? recurrenceEndDate;
    
    if (event.recurrencePattern != null) {
      selectedFrequency = event.recurrencePattern!.frequency;
      interval = event.recurrencePattern!.interval;
    }
    if (event.recurrenceCount != null) recurrenceCount = event.recurrenceCount;
    if (event.recurrenceEndDate != null) recurrenceEndDate = event.recurrenceEndDate;
    bool reminderEnabled = event.reminderEnabled ?? false;
    DateTime? reminderTime = event.reminderTime;
    String reminderPreset = event.reminderPreset ?? 'at_time';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isSingleOccurrence ? 'Edit Single Occurrence' : 'Edit Event'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(hintText: 'Enter event title'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(hintText: 'Enter event description'),
                    ),
                    SizedBox(height: 8),
                    
                    // Date and time selection
                    _buildDateTimeSelectors(
                      startDate, endDate, startTime, endTime, setDialogState,
                      (newStartDate) => startDate = newStartDate,
                      (newEndDate) => endDate = newEndDate,
                      (newStartTime) => startTime = newStartTime,
                      (newEndTime) => endTime = newEndTime,
                    ),
                    
                    SizedBox(height: 8),
                    _buildColorSelector(selectedColor, setDialogState, 
                      (newColor) => selectedColor = newColor),
                    
                    SizedBox(height: 8),
                    TextField(
                      controller: categoryController,
                      decoration: InputDecoration(hintText: 'Enter custom category'),
                    ),
                    
                    if (!isSingleOccurrence) ...[
                      SizedBox(height: 16),
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
                    SizedBox(height: 16),
                    _buildReminderSection(
                     reminderEnabled, reminderTime, reminderPreset, setDialogState,
                     (enabled) => reminderEnabled = enabled,
                     (time) => reminderTime = time,
                     (preset) => reminderPreset = preset,
                     startDate,
                     ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (titleController.text.isNotEmpty && startTime != null && endTime != null) {
                      await _saveEditedEvent(
                        event, titleController, descriptionController, categoryController,
                        startDate, endDate, startTime!, endTime!, selectedColor,
                        isRecurring, selectedFrequency, interval, 
                        recurrenceCount, recurrenceEndDate, isSingleOccurrence,
                        reminderEnabled, reminderTime, reminderPreset
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddEventDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();
    DateTime startDate = _selectedDay;
    DateTime endDate = _selectedDay;
    TimeOfDay? startTime;
    TimeOfDay? endTime;
    
    // Recurrence settings
    bool isRecurring = false;
    RecurrenceFrequency selectedFrequency = RecurrenceFrequency.daily;
    int interval = 1;
    int? recurrenceCount;
    DateTime? recurrenceEndDate;

    bool reminderEnabled = false; 
    DateTime? reminderTime; 
    String reminderPreset = 'at_time';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Add Event'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(hintText: 'Enter event title'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(hintText: 'Enter event description'),
                    ),
                    SizedBox(height: 8),
                    
                    // Date and time selection
                    _buildDateTimeSelectors(
                      startDate, endDate, startTime, endTime, setDialogState,
                      (newStartDate) => startDate = newStartDate,
                      (newEndDate) => endDate = newEndDate,
                      (newStartTime) => startTime = newStartTime,
                      (newEndTime) => endTime = newEndTime,
                    ),
                    
                    SizedBox(height: 8),
                    _buildColorSelector(_selectedColor, setDialogState, 
                      (newColor) => _selectedColor = newColor),
                    
                    SizedBox(height: 8),
                    TextField(
                      controller: categoryController,
                      decoration: InputDecoration(hintText: 'Enter custom category'),
                    ),
                    
                    SizedBox(height: 16),
                    _buildRecurrenceSelector(
                      isRecurring, selectedFrequency, interval, 
                      recurrenceCount, recurrenceEndDate, setDialogState,
                      (recurring) => isRecurring = recurring,
                      (freq) => selectedFrequency = freq,
                      (intv) => interval = intv,
                      (count) => recurrenceCount = count,
                      (endDate) => recurrenceEndDate = endDate,
                    ),
                    SizedBox(height: 16), 
                    _buildReminderSection(
                      reminderEnabled, reminderTime, reminderPreset, setDialogState, 
                      (enabled) =>reminderEnabled = enabled, 
                      (time) => reminderTime = time, 
                      (preset) => reminderPreset = preset,
                      startDate,
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (titleController.text.isNotEmpty && startTime != null && endTime != null) {
                      await _saveNewEvent(
                        titleController, descriptionController, categoryController,
                        startDate, endDate, startTime!, endTime!,
                        isRecurring, selectedFrequency, interval, 
                        recurrenceCount, recurrenceEndDate,
                        reminderEnabled, reminderTime, reminderPreset, // 3 new parameters
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildRecurrenceSelector(
    bool isRecurring, RecurrenceFrequency frequency, int interval,
    int? count, DateTime? endDate, StateSetter setDialogState,
    Function(bool) onRecurringChanged,
    Function(RecurrenceFrequency) onFrequencyChanged,
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
            Text('Recurring Event'),
          ],
        ),
        if (isRecurring) ...[
          SizedBox(height: 8),
          Row(
            children: [
              Text('Repeat every '),
              SizedBox(
                width: 60,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: interval.toString(),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  onChanged: (value) {
                    int? newInterval = int.tryParse(value);
                    if (newInterval != null && newInterval > 0) {
                      onIntervalChanged(newInterval);
                    }
                  },
                ),
              ),
              SizedBox(width: 8),
              DropdownButton<RecurrenceFrequency>(
                value: frequency,
                items: RecurrenceFrequency.values.map((freq) {
                  String label = freq.name;
                  if (interval > 1) {
                    switch (freq) {
                      case RecurrenceFrequency.daily:
                        label = 'days';
                        break;
                      case RecurrenceFrequency.weekly:
                        label = 'weeks';
                        break;
                      case RecurrenceFrequency.monthly:
                        label = 'months';
                        break;
                      case RecurrenceFrequency.yearly:
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
          SizedBox(height: 8),
          Text('End recurrence:'),
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
              Text('Never'),
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
              Text('After '),
              SizedBox(
                width: 60,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: count?.toString() ?? '10',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  onChanged: (value) {
                    int? newCount = int.tryParse(value);
                    if (newCount != null && newCount > 0) {
                      onCountChanged(newCount);
                    }
                  },
                ),
              ),
              Text(' occurrences'),
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
                    onEndDateChanged(DateTime.now().add(Duration(days: 30)));
                  });
                },
              ),
              Text('On '),
              TextButton(
                onPressed: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: endDate ?? DateTime.now().add(Duration(days: 30)),
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
                  ? DateFormat.yMMMd().format(endDate) 
                  : 'Select Date'),
              ),
            ],
          ),
        ],
      ],
    );
  }


// NEW: Reminder section builder
Widget _buildReminderSection(
  bool reminderEnabled, DateTime? reminderTime, String reminderPreset, 
  StateSetter setDialogState,
  Function(bool) onReminderEnabledChanged,
  Function(DateTime?) onReminderTimeChanged,
  Function(String) onReminderPresetChanged,
  DateTime eventStartDate,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Checkbox(
            value: reminderEnabled,
            onChanged: (value) {
              setDialogState(() {
                onReminderEnabledChanged(value ?? false);
                if (value == true && reminderTime == null) {
                  onReminderTimeChanged(eventStartDate);
                }
              });
            },
          ),
          Text('Reminder'),
        ],
      ),
      if (reminderEnabled) ...[
        SizedBox(height: 8),
        Text('Remind me:'),
        ..._reminderPresets.map((preset) {
          return RadioListTile<String>(
            title: Text(preset['label']!, style: TextStyle(fontSize: 13)),
            value: preset['value']!,
            groupValue: reminderPreset,
            dense: true,
            contentPadding: EdgeInsets.zero,
            onChanged: (value) {
              setDialogState(() {
                onReminderPresetChanged(value!);
                _updateEventReminderTime(eventStartDate, value, onReminderTimeChanged);
              });
            },
          );
        }).toList(),
        if (reminderPreset == 'custom') ...[
          SizedBox(height: 8),
          TextButton(
            onPressed: () async {
              await _pickCustomEventReminderTime(
                context, eventStartDate, reminderTime, setDialogState, onReminderTimeChanged
              );
            },
            child: Text(
              reminderTime != null 
                  ? 'Reminder: ${DateFormat('MMM dd, yyyy - hh:mm a').format(reminderTime!)}'
                  : 'Tap to set custom time',
            ),
          ),
        ],
        if (reminderTime != null)
          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(Icons.notifications_active, color: Colors.blue, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Reminder set for ${DateFormat('MMM dd, hh:mm a').format(reminderTime!)}',
                    style: TextStyle(fontSize: 11, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
      ],
    ],
  );
}

//Update event reminder time based on preset
void _updateEventReminderTime(
  DateTime eventStart, String preset, Function(DateTime?) onReminderTimeChanged
) {
  DateTime? newTime;
  switch (preset) {
    case 'at_time':
      newTime = eventStart;
      break;
    case '15min':
      newTime = eventStart.subtract(Duration(minutes: 15));
      break;
    case '30min':
      newTime = eventStart.subtract(Duration(minutes: 30));
      break;
    case '1hour':
      newTime = eventStart.subtract(Duration(hours: 1));
      break;
    case '1day':
      newTime = eventStart.subtract(Duration(days: 1));
      break;
    case 'custom':
      newTime = eventStart; // Keep existing or set to event start
      break;
  }
  onReminderTimeChanged(newTime);
}

//Pick custom reminder time for events
Future<void> _pickCustomEventReminderTime(
  BuildContext context, DateTime eventStart, DateTime? currentTime,
  StateSetter setDialogState, Function(DateTime?) onReminderTimeChanged
) async {
  final pickedDate = await showDatePicker(
    context: context,
    initialDate: currentTime ?? eventStart,
    firstDate: DateTime.now(),
    lastDate: eventStart,
  );
  
  if (pickedDate != null) {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentTime ?? eventStart),
    );
    
    if (pickedTime != null) {
      setDialogState(() {
        onReminderTimeChanged(DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        ));
      });
    }
  }
}


  Widget _buildDateTimeSelectors(
    DateTime startDate, DateTime endDate, TimeOfDay? startTime, TimeOfDay? endTime,
    StateSetter setDialogState,
    Function(DateTime) onStartDateChanged,
    Function(DateTime) onEndDateChanged,
    Function(TimeOfDay) onStartTimeChanged,
    Function(TimeOfDay) onEndTimeChanged,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Start Date: ${DateFormat.yMMMd().format(startDate)}'),
            TextButton(
              onPressed: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: startDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  setDialogState(() {
                    onStartDateChanged(date);
                  });
                }
              },
              child: Text('Select'),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Start Time: ${startTime?.format(context) ?? 'Select'}'),
            TextButton(
              onPressed: () async {
                TimeOfDay? time = await showTimePicker(
                  context: context,
                  initialTime: startTime ?? TimeOfDay.now(),
                );
                if (time != null) {
                  setDialogState(() {
                    onStartTimeChanged(time);
                  });
                }
              },
              child: Text('Select'),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('End Date: ${DateFormat.yMMMd().format(endDate)}'),
            TextButton(
              onPressed: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: endDate,
                  firstDate: startDate,
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  setDialogState(() {
                    onEndDateChanged(date);
                  });
                }
              },
              child: Text('Select'),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('End Time: ${endTime?.format(context) ?? 'Select'}'),
            TextButton(
              onPressed: () async {
                TimeOfDay? time = await showTimePicker(
                  context: context,
                  initialTime: endTime ?? TimeOfDay.now(),
                );
                if (time != null) {
                  setDialogState(() {
                    onEndTimeChanged(time);
                  });
                }
              },
              child: Text('Select'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildColorSelector(Color selectedColor, StateSetter setDialogState, Function(Color) onColorChanged) {
    return Column(
      children: [
        Text('Select Color:'),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Pick a Color'),
                  content: SingleChildScrollView(
                    child: BlockPicker(
                      pickerColor: selectedColor,
                      onColorChanged: (color) {
                        setDialogState(() {
                          onColorChanged(color);
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                );
              },
            );
          },
          child: Container(
            width: 100,
            height: 50,
            color: selectedColor,
            child: Center(child: Text('Color')),
          ),
        ),
      ],
    );
  }


  Future<void> _saveNewEvent(
    TextEditingController titleController,
    TextEditingController descriptionController,
    TextEditingController categoryController,
    DateTime startDate, DateTime endDate,
    TimeOfDay startTime, TimeOfDay endTime,
    bool isRecurring, RecurrenceFrequency frequency, int interval,
    int? recurrenceCount, DateTime? recurrenceEndDate,
    bool reminderEnabled, DateTime? reminderTime, String reminderPreset,
  ) async {
    try {
      final newEvent = Event(
        id: Uuid().v4(),
        title: titleController.text,
        description: descriptionController.text,
        startDateTime: DateTime(
          startDate.year, startDate.month, startDate.day,
          startTime.hour, startTime.minute,
        ),
        endDateTime: DateTime(
          endDate.year, endDate.month, endDate.day,
          endTime.hour, endTime.minute,
        ),
        date: startDate,
        customCategory: categoryController.text,
        color: '#${_selectedColor.value.toRadixString(16).substring(2)}',
        completed: false, // Initialize with completion status
        completedAt: null, // Initialize completion timestamp
        isRecurring: isRecurring,
        recurrencePattern: isRecurring ? RecurrencePattern(
          frequency: frequency,
          interval: interval,
        ) : null,
        recurrenceCount: recurrenceCount,
        recurrenceEndDate: recurrenceEndDate,
        reminderEnabled: reminderEnabled,
        reminderTime: reminderEnabled ? reminderTime : null, 
        reminderPreset: reminderEnabled ? reminderPreset : null,
      );

      if (isRecurring) {
        newEvent.recurrenceRule = newEvent.generateRRule();
      }

      await widget.calendarService.addEvent(newEvent);
      await _loadEvents();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event added successfully!')),
      );
    } catch (e) {
      print('Error adding event: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding event: $e')),
      );
    }
  }

  Future<void> _saveEditedEvent(
    Event originalEvent,
    TextEditingController titleController,
    TextEditingController descriptionController,
    TextEditingController categoryController,
    DateTime startDate, DateTime endDate,
    TimeOfDay startTime, TimeOfDay endTime,
    Color selectedColor,
    bool isRecurring, RecurrenceFrequency frequency, int interval,
    int? recurrenceCount, DateTime? recurrenceEndDate,
    bool isSingleOccurrence,
    bool reminderEnabled, DateTime? reminderTime, String reminderPreset,
  ) async {
    try {
      if (isSingleOccurrence) {
        // Create a new single event and add exception to parent
        final newSingleEvent = Event(
          title: titleController.text,
          description: descriptionController.text,
          startDateTime: DateTime(
            startDate.year, startDate.month, startDate.day,
            startTime.hour, startTime.minute,
          ),
          endDateTime: DateTime(
            endDate.year, endDate.month, endDate.day,
            endTime.hour, endTime.minute,
          ),
          date: startDate,
          customCategory: categoryController.text,
          color: '#${selectedColor.value.toRadixString(16).substring(2)}',
          completed: false, // Initialize with completion status
          completedAt: null, // Initialize completion timestamp
          isRecurring: false,
          reminderEnabled: reminderEnabled,
          reminderTime: reminderEnabled ? reminderTime : null, 
          reminderPreset: reminderEnabled ? reminderPreset : null, 
        );

        await widget.calendarService.createModifiedOccurrence(originalEvent, newSingleEvent);
      } else {
        final updatedEvent = originalEvent.copyWith(
          title: titleController.text,
          description: descriptionController.text,
          startDateTime: DateTime(
            startDate.year, startDate.month, startDate.day,
            startTime.hour, startTime.minute,
          ),
          endDateTime: DateTime(
            endDate.year, endDate.month, endDate.day,
            endTime.hour, endTime.minute,
          ),
          date: startDate,
          customCategory: categoryController.text,
          color: '#${selectedColor.value.toRadixString(16).substring(2)}',
          isRecurring: isRecurring,
          recurrencePattern: isRecurring ? RecurrencePattern(
            frequency: frequency,
            interval: interval,
          ) : null,
          recurrenceCount: recurrenceCount,
          recurrenceEndDate: recurrenceEndDate,
          reminderEnabled: reminderEnabled,
          reminderTime: reminderEnabled ? reminderTime : null, 
          reminderPreset: reminderEnabled ? reminderPreset : null,
        );

        if (isRecurring) {
          updatedEvent.recurrenceRule = updatedEvent.generateRRule();
        }

        await widget.calendarService.updateEvent(updatedEvent);
      }
      
      await _loadEvents();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event updated successfully!')),
      );
    } catch (e) {
      print('Error updating event: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating event: $e')),
      );
    }
  }

  void _showDeleteConfirmationDialog(Event event) {
    bool isRecurringInstance = event.parentEventId != null;
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Event'),
          content: Text(isRecurringInstance 
            ? 'This is part of a recurring series. What would you like to delete?'
            : 'Are you sure you want to delete "${event.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            if (isRecurringInstance) ...[
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _deleteSingleOccurrence(event);
                },
                child: Text('This Event Only'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _deleteEntireSeries(event);
                },
                child: Text('Entire Series'),
              ),
            ] else ...[
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _deleteSingleEvent(event);
                },
                child: Text('Delete'),
              ),
            ],
          ],
        );
      },
    );
  }

  Future<void> _deleteSingleOccurrence(Event event) async {
    try {
      if (event.parentEventId != null) {
        await widget.calendarService.addRecurrenceException(
          event.parentEventId!, 
          event.startDateTime
        );
      } else {
        await widget.calendarService.deleteEvent(event.id);
      }
      
      await _loadEvents();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event occurrence deleted successfully!')),
      );
    } catch (e) {
      print('Error deleting single occurrence: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting event: $e')),
      );
    }
  }

  Future<void> _deleteEntireSeries(Event event) async {
    try {
      String parentId = event.parentEventId ?? event.id;
      await widget.calendarService.deleteEvent(parentId, deleteSeries: true);
      await _loadEvents();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event series deleted successfully!')),
      );
    } catch (e) {
      print('Error deleting entire series: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting event series: $e')),
      );
    }
  }

  Future<void> _deleteSingleEvent(Event event) async {
    try {
      await widget.calendarService.deleteEvent(event.id);
      await _loadEvents();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event deleted successfully!')),
      );
    } catch (e) {
      print('Error deleting event: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting event: $e')),
      );
    }
  }

  // ENHANCED: Improved month view event markers (positioned below date, 3 max + counter)
  Widget _buildMonthEventMarkers(DateTime day) {
    List<Event> dayEvents = _getSortedEventsForDay(day);
    
    if (dayEvents.isEmpty) {
      return SizedBox.shrink();
    }

    // Show maximum 3 events as bars, then show "+X more"
    const int maxVisible = 3;
    List<Event> visibleEvents = dayEvents.take(maxVisible).toList();
    int remainingCount = dayEvents.length - maxVisible;

    return Positioned(
      bottom: 2, // ENHANCED: Position at bottom of cell to avoid covering date
      left: 2,
      right: 2,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 50, // ENHANCED: Reduced height to fit better
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...visibleEvents.map((event) => GestureDetector(
              onTap: () => _showEventActionsDialog(event),
              child: Container(
                height: 12, // ENHANCED: Smaller height for better fit
                margin: EdgeInsets.symmetric(vertical: 0.5, horizontal: 1),
                padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                decoration: BoxDecoration(
                  color: Color(int.parse(event.color.replaceFirst('#', '0xff'))).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (event.parentEventId != null) ...[
                      Icon(Icons.repeat, size: 6, color: Colors.white),
                      SizedBox(width: 1),
                    ],
                    Flexible(
                      child: Text(
                        event.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8, // ENHANCED: Smaller font
                          fontWeight: FontWeight.w500,
                          decoration: event.completed ? TextDecoration.lineThrough : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (event.completed) ...[
                      SizedBox(width: 1),
                      Icon(Icons.check_circle, size: 6, color: Colors.white),
                    ],
                  ],
                ),
              ),
            )).toList(),
            
            if (remainingCount > 0)
              GestureDetector(
                onTap: () => _showAllDayEventsDialog(day),
                child: Container(
                  height: 10, // ENHANCED: Smaller height for counter
                  margin: EdgeInsets.symmetric(vertical: 0.5, horizontal: 1),
                  child: Text(
                    '+$remainingCount more',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 7, // ENHANCED: Very small font for counter
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // NEW: Show event actions dialog for month view
  void _showEventActionsDialog(Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            if (event.parentEventId != null) ...[
              Icon(Icons.repeat, size: 16, color: Colors.grey[600]),
              SizedBox(width: 8),
            ],
            Expanded(child: Text(event.title)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${DateFormat.jm().format(event.startDateTime)} - ${DateFormat.jm().format(event.endDateTime)}'),
            if (event.description != null && event.description!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(event.description!),
              ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(event.completed ? Icons.check_box : Icons.check_box_outline_blank),
                SizedBox(width: 8),
                Text(event.completed ? 'Completed' : 'Mark as complete'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _toggleEventCompletion(event, !event.completed);
            },
            child: Text(event.completed ? 'Mark Incomplete' : 'Mark Complete'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _editEvent(event);
            },
            child: Text('Edit'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showDeleteConfirmationDialog(event);
            },
            child: Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  // NEW: Show all events dialog for "+X more"
  void _showAllDayEventsDialog(DateTime day) {
    List<Event> dayEvents = _getSortedEventsForDay(day);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Events for ${DateFormat.yMMMd().format(day)}'),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: dayEvents.length,
            itemBuilder: (context, index) {
              Event event = dayEvents[index];
              return ListTile(
                leading: Container(
                  width: 4,
                  height: 40,
                  color: Color(int.parse(event.color.replaceFirst('#', '0xff'))),
                ),
                title: Row(
                  children: [
                    if (event.parentEventId != null) ...[
                      Icon(Icons.repeat, size: 14, color: Colors.grey[600]),
                      SizedBox(width: 4),
                    ],
                    Expanded(
                      child: Text(
                        event.title,
                        style: TextStyle(
                          decoration: event.completed ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Text('${DateFormat.jm().format(event.startDateTime)} - ${DateFormat.jm().format(event.endDateTime)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(event.completed ? Icons.check_box : Icons.check_box_outline_blank),
                      onPressed: () async {
                        await _toggleEventCompletion(event, !event.completed);
                        Navigator.of(context).pop();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _editEvent(event);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showDeleteConfirmationDialog(event);
                      },
                    ),
                  ],
                ),
                onTap: () => _showEventActionsDialog(event),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

 // ENHANCED: Event list with database-backed checkboxes
Widget _buildEventList(List<Event> visibleEvents) { // ✅ Added parameter
  // ✅ Filter visibleEvents (already search-filtered) to selected day, then sort
  List<Event> selectedDayEvents = visibleEvents
      .where((e) => isSameDay(e.date, _selectedDay))
      .toList()
    ..sort((a, b) => a.startDateTime.compareTo(b.startDateTime));

  if (selectedDayEvents.isEmpty) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Text(
        _searchQuery.isNotEmpty
            ? 'No matching events for ${DateFormat.yMMMd().format(_selectedDay)}' // ✅ Search-aware message
            : 'No events for ${DateFormat.yMMMd().format(_selectedDay)}',
        style: TextStyle(color: Colors.white70, fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  return ListView.builder(
    controller: _scrollController, // ✅ Added
    shrinkWrap: true,
    physics: AlwaysScrollableScrollPhysics(),
    itemCount: selectedDayEvents.length,
    itemBuilder: (context, index) {
      Event event = selectedDayEvents[index];
      bool isRecurringInstance = event.parentEventId != null;

      return Card(
        color: event.completed ? Colors.grey[700] : Colors.grey[800],
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          leading: Container(
            width: 4,
            height: double.infinity,
            color: Color(int.parse(event.color.replaceFirst('#', '0xff'))),
          ),
          title: Row(
            children: [
              if (isRecurringInstance)
                Icon(Icons.repeat, size: 16, color: Colors.grey[400]),
              if (isRecurringInstance) SizedBox(width: 4),
              Expanded(
                child: Text(
                  event.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    decoration: event.completed
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${DateFormat.jm().format(event.startDateTime)} - ${DateFormat.jm().format(event.endDateTime)}',
                style: TextStyle(color: Colors.grey[300]),
              ),
              if (event.description != null && event.description!.isNotEmpty)
                Text(
                  event.description!,
                  style: TextStyle(color: Colors.grey[400]),
                ),
              if (event.customCategory != null &&
                  event.customCategory!.isNotEmpty)
                Text(
                  'Category: ${event.customCategory}',
                  style: TextStyle(color: Colors.grey[400]),
                ),
              if (isRecurringInstance)
                Text(
                  'Recurring event',
                  style: TextStyle(color: Colors.blue[300], fontSize: 12),
                ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: event.completed,
                onChanged: (value) => _toggleEventCompletion(event, value),
                activeColor: Colors.green,
              ),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _editEvent(event),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showDeleteConfirmationDialog(event),
              ),
            ],
          ),
        ),
      );
    },
  );
}

 // ENHANCED: All events list with database-backed checkboxes
Widget _buildAllEventsList(List<Event> visibleEvents) { // ✅ Added parameter
  if (visibleEvents.isEmpty) { // ✅ was _expandedEvents
    return Container(
      padding: EdgeInsets.all(20),
      child: Text(
        'No events found',
        style: TextStyle(color: Colors.white70, fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  return ListView.builder(
    controller: _scrollController, // ✅ Added
    physics: AlwaysScrollableScrollPhysics(),
    itemCount: visibleEvents.length, // ✅ was _expandedEvents.length
    itemBuilder: (context, index) {
      Event event = visibleEvents[index]; // ✅ was _expandedEvents[index]
      bool isRecurringInstance = event.parentEventId != null;

      return Card(
        color: event.completed ? Colors.grey[700] : Colors.grey[800],
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          leading: Container(
            width: 4,
            height: double.infinity,
            color: Color(int.parse(event.color.replaceFirst('#', '0xff'))),
          ),
          title: Row(
            children: [
              if (isRecurringInstance)
                Icon(Icons.repeat, size: 16, color: Colors.grey[400]),
              if (isRecurringInstance) SizedBox(width: 4),
              Expanded(
                child: Text(
                  event.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    decoration: event.completed
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${DateFormat.yMMMd().format(event.date)} - ${DateFormat.jm().format(event.startDateTime)} to ${DateFormat.jm().format(event.endDateTime)}',
                style: TextStyle(color: Colors.grey[300]),
              ),
              if (event.description != null && event.description!.isNotEmpty)
                Text(
                  event.description!,
                  style: TextStyle(color: Colors.grey[400]),
                ),
              if (event.customCategory != null &&
                  event.customCategory!.isNotEmpty)
                Text(
                  'Category: ${event.customCategory}',
                  style: TextStyle(color: Colors.grey[400]),
                ),
              if (isRecurringInstance)
                Text(
                  'Recurring event',
                  style: TextStyle(color: Colors.blue[300], fontSize: 12),
                ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: event.completed,
                onChanged: (value) => _toggleEventCompletion(event, value),
                activeColor: Colors.green,
              ),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _editEvent(event),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showDeleteConfirmationDialog(event),
              ),
            ],
          ),
        ),
      );
    },
  );
}


  // ENHANCED: Day view with database-backed checkboxes
  Widget _buildDayView() {
    List<Event> dayEvents = _getSortedEventsForDay(_selectedDay);
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          // Day header
          Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.today, color: Colors.white70, size: 20),
                    SizedBox(width: 8),
                    Text(
                      DateFormat.yMMMEd().format(_selectedDay),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_left, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _selectedDay = _selectedDay.subtract(Duration(days: 1));
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.chevron_right, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _selectedDay = _selectedDay.add(Duration(days: 1));
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 24-hour timeline
          Expanded(
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: 24, // 24 hours
              itemBuilder: (context, hourIndex) {
                final hour = hourIndex;
                final timeString = DateFormat.j().format(DateTime(2023, 1, 1, hour));
                
                // Get events for this hour
                List<Event> hourEvents = dayEvents.where((event) {
                  final eventHour = event.startDateTime.hour;
                  final eventEndHour = event.endDateTime.hour;
                  final eventEndMinute = event.endDateTime.minute;
                  
                  // Check if event starts in this hour or spans through this hour
                  return (eventHour <= hour && 
                         (eventEndHour > hour || (eventEndHour == hour && eventEndMinute > 0)));
                }).toList();

                return Container(
                  height: 80, // Fixed height for each hour slot
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[600]!, width: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Time label
                      Container(
                        width: 70,
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Text(
                          timeString,
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      // Divider line
                      Container(
                        width: 1,
                        height: double.infinity,
                        color: Colors.grey[600],
                      ),
                      // Events area
                      Expanded(
                        child: hourEvents.isEmpty
                            ? Container()
                            : Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                child: Column(
                                  children: hourEvents.map((event) {
                                    final eventStartHour = event.startDateTime.hour;
                                    bool isEventStart = eventStartHour == hour;
                                    bool isRecurringInstance = event.parentEventId != null;
                                    
                                    String timeDisplay = '';
                                    if (isEventStart) {
                                      timeDisplay = '${DateFormat.jm().format(event.startDateTime)} - ${DateFormat.jm().format(event.endDateTime)}';
                                    }
                                    
                                    return Expanded(
                                      child: Container(
                                        margin: EdgeInsets.symmetric(vertical: 1),
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: event.completed 
                                              ? Colors.grey[600]!.withOpacity(0.8)
                                              : Color(int.parse(event.color.replaceFirst('#', '0xff'))).withOpacity(0.8),
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(
                                            color: event.completed 
                                                ? Colors.grey[500]!
                                                : Color(int.parse(event.color.replaceFirst('#', '0xff'))),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            if (isRecurringInstance && isEventStart)
                                              Icon(Icons.repeat, size: 12, color: Colors.white70),
                                            if (isRecurringInstance && isEventStart)
                                              SizedBox(width: 2),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  if (isEventStart) ...[
                                                    Text(
                                                      event.title,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12,
                                                        decoration: event.completed ? TextDecoration.lineThrough : null,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    if (timeDisplay.isNotEmpty)
                                                      Text(
                                                        timeDisplay,
                                                        style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 10,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                  ] else ...[
                                                    // Show continuation indicator
                                                    Text(
                                                      '↳ ${event.title}',
                                                      style: TextStyle(
                                                        color: Colors.white70,
                                                        fontSize: 11,
                                                        fontStyle: FontStyle.italic,
                                                        decoration: event.completed ? TextDecoration.lineThrough : null,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                            if (isEventStart) ...[
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () => _toggleEventCompletion(event, !event.completed),
                                                    child: Container(
                                                      width: 16,
                                                      height: 16,
                                                      decoration: BoxDecoration(
                                                        color: event.completed 
                                                            ? Colors.green 
                                                            : Colors.transparent,
                                                        border: Border.all(color: Colors.white, width: 1),
                                                        borderRadius: BorderRadius.circular(2),
                                                      ),
                                                      child: event.completed 
                                                          ? Icon(Icons.check, color: Colors.white, size: 12)
                                                          : null,
                                                    ),
                                                  ),
                                                  SizedBox(width: 4),
                                                  GestureDetector(
                                                    onTap: () => _editEvent(event),
                                                    child: Icon(Icons.edit, color: Colors.white70, size: 14),
                                                  ),
                                                  SizedBox(width: 4),
                                                  GestureDetector(
                                                    onTap: () => _showDeleteConfirmationDialog(event),
                                                    child: Icon(Icons.delete, color: Colors.red[300], size: 14),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ENHANCED: Week view with chronological sorting and full editing capabilities
  Widget _buildWeekView() {
    // Find the first day of the current week (Monday)
    DateTime weekStart = _focusedDay.subtract(Duration(days: _focusedDay.weekday - 1));
    List<DateTime> weekDays = List.generate(7, (i) => weekStart.add(Duration(days: i)));

    return Column(
      children: [
        // Weekday headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: weekDays.map((date) =>
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                color: isSameDay(date, _selectedDay) ? Colors.blue[700] : Colors.transparent,
                child: Column(
                  children: [
                    Text(
                      DateFormat.E().format(date), // Mon, Tue, etc.
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      DateFormat.d().format(date), // Day number
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ).toList(),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: weekDays.map((date) {
              // ENHANCED: Use chronologically sorted events
              List<Event> dayEvents = _getSortedEventsForDay(date);
              return Expanded(
                child: Container(
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: dayEvents.length,
                    itemBuilder: (context, idx) {
                      final event = dayEvents[idx];
                      bool isRecurringInstance = event.parentEventId != null;
                      
                      return Card(
                        color: event.completed 
                            ? Colors.grey[600]
                            : Color(int.parse(event.color.replaceFirst('#', '0xff'))),
                        margin: EdgeInsets.symmetric(vertical: 2, horizontal: 0),
                        child: ListTile(
                          title: Row(
                            children: [
                              if (isRecurringInstance) 
                                Icon(Icons.repeat, size: 10, color: Colors.white70),
                              if (isRecurringInstance) SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                  event.title,
                                  style: TextStyle(
                                    color: Colors.white, 
                                    fontSize: 12,
                                    decoration: event.completed ? TextDecoration.lineThrough : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            '${DateFormat.jm().format(event.startDateTime)} - ${DateFormat.jm().format(event.endDateTime)}',
                            style: TextStyle(color: Colors.white70, fontSize: 10),
                          ),
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          onTap: () => _editEvent(event),
                          // ENHANCED: Add PopupMenuButton with check off, edit, and delete
                          trailing: PopupMenuButton<String>(
                            icon: Icon(Icons.more_vert, color: Colors.white70, size: 16),
                            onSelected: (value) {
                              if (value == 'edit') {
                                _editEvent(event);
                              } else if (value == 'delete') {
                                _showDeleteConfirmationDialog(event);
                              } else if (value == 'toggle') {
                                _toggleEventCompletion(event, !event.completed);
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'toggle',
                                child: Row(
                                  children: [
                                    Icon(
                                      event.completed ? Icons.check_box_outline_blank : Icons.check_box,
                                      size: 16,
                                      color: Colors.green,
                                    ),
                                    SizedBox(width: 8),
                                    Text(event.completed ? 'Mark Incomplete' : 'Mark Complete'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, size: 16, color: Colors.blue),
                                    SizedBox(width: 8),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, size: 16, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Delete'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

 Widget _buildBodyContent() {
  final visibleEvents = _filterEvents(); // ✅ Compute filtered list here

  if (_currentView == 'calendar') {
    return Column(
      children: [
        TableCalendar<Event>(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          calendarFormat: _calendarFormat,
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          eventLoader: _getEventsForDay,
          rowHeight: 90,
          daysOfWeekHeight: 40,
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
            rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
          ),
          calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            markerDecoration: BoxDecoration(
              color: Colors.transparent,
            ),
            cellPadding: EdgeInsets.all(4),
          ),
          calendarBuilders: CalendarBuilders<Event>(
            markerBuilder: (context, day, events) {
              return _buildMonthEventMarkers(day);
            },
          ),
        ),
        Container(
          height: 350,
          child: _buildEventList(visibleEvents), // ✅ Pass visibleEvents
        ),
      ],
    );
  } else if (_currentView == 'week') {
    return Container(
      height: 600,
      child: _buildWeekView(),
    );
  } else if (_currentView == 'day') {
    return Container(
      height: 600,
      child: _buildDayView(),
    );
  } else {
    return Container(
      height: 600,
      child: _buildAllEventsList(visibleEvents), // ✅ Pass visibleEvents
    );
  }
}


  @override
Widget build(BuildContext context) {
  final visibleEvents = _filterEvents(); // Added

  return Scaffold(
    backgroundColor: Colors.grey[850],
    appBar: AppBar(
      backgroundColor: Colors.grey[900],
      title: Text('Calendar', style: TextStyle(color: Colors.white)),
      actions: [
        IconButton(
          icon: _isRefreshing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Icon(Icons.refresh),
          onPressed: _isRefreshing ? null : _refreshEventsWithIndicator,
          tooltip: 'Refresh',
        ),
        IconButton(
          icon: Icon(Icons.list, color: Colors.white),
          onPressed: () {
            setState(() {
              _currentView = 'list';
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.calendar_today, color: Colors.white),
          onPressed: () {
            setState(() {
              _currentView = 'calendar';
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.view_week, color: Colors.white),
          onPressed: () {
            setState(() {
              _currentView = 'week';
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.access_time, color: Colors.white),
          onPressed: () {
            setState(() {
              _currentView = 'day';
            });
          },
        ),
      ],
    ),
    // Search bar + body wrapped in Column
    body: ScrollConfiguration(
      behavior: CustomScrollBehavior(),
      child: RefreshIndicator(
        onRefresh: _refreshEvents,
        color: Colors.blue,
        backgroundColor: Colors.white,
        strokeWidth: 2.0,
        displacement: 40.0,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search events...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey[800],
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey[400]),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
              ),
              // Existing body content
              _buildBodyContent(),
            ],
          ),
        ),
      ),
    ),
    floatingActionButton: FloatingActionButton(
      heroTag: "calendar_fab",
      onPressed: _showAddEventDialog,
      child: Icon(Icons.add),
      backgroundColor: Colors.blue,
    ),
  );
}
}