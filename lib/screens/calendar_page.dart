import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:maximize/models/event_model.dart';
import 'package:maximize/services/calendar_service.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// Define the state class that manages the mutable state for CalendarPage
class CalendarPage extends StatefulWidget {
    // Declare a final field to hold the calendar service dependency
  final CalendarService calendarService;
  // Constructor that requires a CalendarService and accepts an optional key
  const CalendarPage({super.key, required this.calendarService});
// Override the createState method to return the state object for this widget
  @override
  _CalendarPageState createState() => _CalendarPageState();
}
class _CalendarPageState extends State<CalendarPage> { // Define the state class that manages the mutable state for CalendarPage
  DateTime _selectedDay = DateTime.now(); // Store the currently selected day, initialized to today's date
  DateTime _focusedDay = DateTime.now();   // Store the day that the calendar is currently focused on, initialized to today
  List<Event> _events = []; // List to hold all events loaded from the calendar service
  CalendarFormat _calendarFormat = CalendarFormat.month;   // Current format of the calendar display (month, week, etc.)
  String _currentView = 'calendar'; // Track the current view (calendar, list, or day)
  Map<String, bool> _eventCheckedStates = {};   // Map to store the checked/unchecked state of each event by event ID
  SharedPreferences? _prefs;   // SharedPreferences instance for persisting data locally (nullable)
  Color _selectedColor = Colors.blue;   // Currently selected color for new events, defaulted to blue

  @override
  void initState() {
    super.initState();
    _loadEvents();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadCheckedStates();
  }

  void _loadCheckedStates() {
    for (var event in _events) {
      bool isChecked = _prefs?.getBool(event.id) ?? false;
      _eventCheckedStates[event.id] = isChecked;
    }
  }

  void _saveCheckedStates() {
    _eventCheckedStates.forEach((eventId, isChecked) {
      _prefs?.setBool(eventId, isChecked);
    });
  }

  Future<void> _loadEvents() async {
    List<Event> events = await widget.calendarService.getEvents();
    setState(() {
      _events = events;
      _eventCheckedStates = {};
      for (var event in events) {
        _eventCheckedStates[event.id] = _prefs?.getBool(event.id) ?? false;
      }
    });
  }

  // Get events for a specific day
  List<Event> _getEventsForDay(DateTime day) {
    return _events.where((event) {
      return isSameDay(event.date, day);
    }).toList();
  }

  void _editEvent(Event event) {
    final TextEditingController titleController = TextEditingController(text: event.title);
    final TextEditingController descriptionController = TextEditingController(text: event.description);
    final TextEditingController categoryController = TextEditingController(text: event.customCategory ?? '');
    DateTime startDate = event.startDateTime;
    DateTime endDate = event.endDateTime;
    TimeOfDay? startTime = TimeOfDay.fromDateTime(event.startDateTime);
    TimeOfDay? endTime = TimeOfDay.fromDateTime(event.endDateTime);
    Color selectedColor = Color(int.parse(event.color.replaceFirst('#', '0xff')));

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Edit Event'),
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
                                startDate = date;
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
                                startTime = time;
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
                                endDate = date;
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
                                endTime = time;
                              });
                            }
                          },
                          child: Text('Select'),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
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
                                      selectedColor = color;
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
                    SizedBox(height: 8),
                    Text('Custom Category:'),
                    TextField(
                      controller: categoryController,
                      decoration: InputDecoration(hintText: 'Enter custom category'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (titleController.text.isNotEmpty && startTime != null && endTime != null) {
                      final updatedEvent = Event(
                        id: event.id,
                        title: titleController.text,
                        description: descriptionController.text,
                        startDateTime: DateTime(
                          startDate.year,
                          startDate.month,
                          startDate.day,
                          startTime!.hour,
                          startTime!.minute,
                        ),
                        endDateTime: DateTime(
                          endDate.year,
                          endDate.month,
                          endDate.day,
                          endTime!.hour,
                          endTime!.minute,
                        ),
                        date: startDate,
                        customCategory: categoryController.text,
                        color: '#${selectedColor.value.toRadixString(16).substring(2)}',
                      );

                      await widget.calendarService.updateEvent(updatedEvent);
                      await _loadEvents();
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
                                startDate = date;
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
                              initialTime: TimeOfDay.now(),
                            );
                            if (time != null) {
                              setDialogState(() {
                                startTime = time;
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
                                endDate = date;
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
                              initialTime: TimeOfDay.now(),
                            );
                            if (time != null) {
                              setDialogState(() {
                                endTime = time;
                              });
                            }
                          },
                          child: Text('Select'),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
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
                                  pickerColor: _selectedColor,
                                  onColorChanged: (color) {
                                    setDialogState(() {
                                      _selectedColor = color;
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
                        color: _selectedColor,
                        child: Center(child: Text('Color')),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Custom Category:'),
                    TextField(
                      controller: categoryController,
                      decoration: InputDecoration(hintText: 'Enter custom category'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (titleController.text.isNotEmpty && startTime != null && endTime != null) {
                      final newEvent = Event(
                        id: Uuid().v4(),
                        title: titleController.text,
                        description: descriptionController.text,
                        startDateTime: DateTime(
                          startDate.year,
                          startDate.month,
                          startDate.day,
                          startTime!.hour,
                          startTime!.minute,
                        ),
                        endDateTime: DateTime(
                          endDate.year,
                          endDate.month,
                          endDate.day,
                          endTime!.hour,
                          endTime!.minute,
                        ),
                        date: startDate,
                        customCategory: categoryController.text,
                        color: '#${_selectedColor.value.toRadixString(16).substring(2)}',
                      );

                      await widget.calendarService.addEvent(newEvent);
                      await _loadEvents();
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

  void _showDeleteConfirmationDialog(Event event) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Event'),
          content: Text('Are you sure you want to delete "${event.title}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await widget.calendarService.deleteEvent(event.id);
                  await _loadEvents();
                  Navigator.of(context).pop();
                } catch (e) {
                  print('Error deleting event: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete event.')),
                  );
                }
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDayView() {
    List<Event> dayEvents = _getEventsForDay(_selectedDay);
    
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
                                    final eventStartMinute = event.startDateTime.minute;
                                    final eventEndHour = event.endDateTime.hour;
                                    final eventEndMinute = event.endDateTime.minute;
                                    
                                    // Calculate event duration and position
                                    bool isEventStart = eventStartHour == hour;
                                    String timeDisplay = '';
                                    
                                    if (isEventStart) {
                                      timeDisplay = '${DateFormat.jm().format(event.startDateTime)} - ${DateFormat.jm().format(event.endDateTime)}';
                                    }
                                    
                                    return Expanded(
                                      child: Container(
                                        margin: EdgeInsets.symmetric(vertical: 1),
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Color(int.parse(event.color.replaceFirst('#', '0xff'))).withOpacity(0.8),
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(
                                            color: Color(int.parse(event.color.replaceFirst('#', '0xff'))),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
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
                                                    onTap: () {
                                                      setState(() {
                                                        _eventCheckedStates[event.id] = !(_eventCheckedStates[event.id] ?? false);
                                                        _saveCheckedStates();
                                                      });
                                                    },
                                                    child: Container(
                                                      width: 16,
                                                      height: 16,
                                                      decoration: BoxDecoration(
                                                        color: _eventCheckedStates[event.id] == true 
                                                            ? Colors.green 
                                                            : Colors.transparent,
                                                        border: Border.all(color: Colors.white, width: 1),
                                                        borderRadius: BorderRadius.circular(2),
                                                      ),
                                                      child: _eventCheckedStates[event.id] == true
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

  Widget _buildEventList() {
    List<Event> selectedDayEvents = _getEventsForDay(_selectedDay);
    
    if (selectedDayEvents.isEmpty) {
      return Container(
        padding: EdgeInsets.all(20),
        child: Text(
          'No events for ${DateFormat.yMMMd().format(_selectedDay)}',
          style: TextStyle(color: Colors.white70, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: selectedDayEvents.length,
      itemBuilder: (context, index) {
        Event event = selectedDayEvents[index];
        return Card(
          color: Colors.grey[800],
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: Container(
              width: 4,
              height: double.infinity,
              color: Color(int.parse(event.color.replaceFirst('#', '0xff'))),
            ),
            title: Text(
              event.title,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${DateFormat.jm().format(event.startDateTime)} - ${DateFormat.jm().format(event.endDateTime)}',
                  style: TextStyle(color: Colors.grey[300]),
                ),
                if (event.description!.isNotEmpty)
                  Text(
                    event.description ?? 'No description',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                if (event.customCategory != null && event.customCategory!.isNotEmpty)
                  Text(
                    'Category: ${event.customCategory}',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: _eventCheckedStates[event.id] ?? false,
                  onChanged: (value) {
                    setState(() {
                      _eventCheckedStates[event.id] = value!;
                      _saveCheckedStates();
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    _editEvent(event);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _showDeleteConfirmationDialog(event);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAllEventsList() {
    if (_events.isEmpty) {
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
      itemCount: _events.length,
      itemBuilder: (context, index) {
        Event event = _events[index];
        return Card(
          color: Colors.grey[800],
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: Container(
              width: 4,
              height: double.infinity,
              color: Color(int.parse(event.color.replaceFirst('#', '0xff'))),
            ),
            title: Text(
              event.title,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${DateFormat.yMMMd().format(event.date)} - ${DateFormat.jm().format(event.startDateTime)} to ${DateFormat.jm().format(event.endDateTime)}',
                  style: TextStyle(color: Colors.grey[300]),
                ),
                if (event.description!.isNotEmpty)
                  Text(
                    event.description ?? 'No description',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                if (event.customCategory != null && event.customCategory!.isNotEmpty)
                  Text(
                    'Category: ${event.customCategory}',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: _eventCheckedStates[event.id] ?? false,
                  onChanged: (value) {
                    setState(() {
                      _eventCheckedStates[event.id] = value!;
                      _saveCheckedStates();
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    _editEvent(event);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _showDeleteConfirmationDialog(event);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text('Calendar', style: TextStyle(color: Colors.white)), 
        actions: [
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
            icon: Icon(Icons.access_time, color: Colors.white),
            onPressed: () {
              setState(() {
                _currentView = 'day';
              });
            },
          ),
        ],
      ),
      body: _currentView == 'calendar'
          ? TableCalendar<Event>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay; // update `_focusedDay` here as well
                });
              },
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              eventLoader: _getEventsForDay,
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
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : _currentView == 'day'
              ? _buildDayView()
              : _buildAllEventsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
        
       