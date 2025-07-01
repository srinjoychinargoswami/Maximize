import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:maximize/models/event_model.dart';
import 'package:maximize/services/calendar_service.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CalendarPage extends StatefulWidget {
  final CalendarService calendarService;

  const CalendarPage({super.key, required this.calendarService});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<Event> _events = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  String _currentView = 'calendar'; // Track the current view (calendar or list)
  Map<String, bool> _eventCheckedStates = {};
  SharedPreferences? _prefs;
  Color _selectedColor = Colors.blue;

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
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: _showAddEventDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // View Toggle Buttons
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentView = 'calendar';
                      _calendarFormat = CalendarFormat.month;
                    });
                  },
                  child: Text('Month'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentView == 'calendar' && _calendarFormat == CalendarFormat.month
                        ? Colors.blue
                        : Colors.grey[700],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentView = 'calendar';
                      _calendarFormat = CalendarFormat.twoWeeks;
                    });
                  },
                  child: Text('2 Weeks'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentView == 'calendar' && _calendarFormat == CalendarFormat.twoWeeks
                        ? Colors.blue
                        : Colors.grey[700],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentView = 'calendar';
                      _calendarFormat = CalendarFormat.week;
                    });
                  },
                  child: Text('Week'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentView == 'calendar' && _calendarFormat == CalendarFormat.week
                        ? Colors.blue
                        : Colors.grey[700],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentView = 'list';
                    });
                  },
                  child: Text('List'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentView == 'list'
                        ? Colors.blue
                        : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          
          // Calendar or List View
          Expanded(
            child: _currentView == 'list'
                ? _buildAllEventsList()
                : Column(
                    children: [
                      // TableCalendar
                      TableCalendar<Event>(
                        firstDay: DateTime.utc(2010, 10, 16),
                        lastDay: DateTime.utc(2030, 3, 14),
                        focusedDay: _focusedDay,
                        calendarFormat: _calendarFormat,
                        eventLoader: _getEventsForDay,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        calendarStyle: CalendarStyle(
                          outsideDaysVisible: false,
                          weekendTextStyle: TextStyle(color: Colors.red[300]),
                          defaultTextStyle: TextStyle(color: Colors.white),
                          todayTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          selectedTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          todayDecoration: BoxDecoration(
                            color: Colors.blue[600],
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: Colors.blue[800],
                            shape: BoxShape.circle,
                          ),
                          markerDecoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                        headerStyle: HeaderStyle(
                          formatButtonVisible: true,
                          titleCentered: true,
                          formatButtonShowsNext: false,
                          formatButtonDecoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          formatButtonTextStyle: TextStyle(
                            color: Colors.white,
                          ),
                          titleTextStyle: TextStyle(color: Colors.white, fontSize: 16),
                          leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                          rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: TextStyle(color: Colors.white70),
                          weekendStyle: TextStyle(color: Colors.red[300]),
                        ),
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          if (!isSameDay(_selectedDay, selectedDay)) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          }
                        },
                        onFormatChanged: (format) {
                          if (_calendarFormat != format) {
                            setState(() {
                              _calendarFormat = format;
                            });
                          }
                        },
                        onPageChanged: (focusedDay) {
                          _focusedDay = focusedDay;
                        },
                      ),
                      
                      // Events for selected day
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
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
                                  children: [
                                    Icon(Icons.event, color: Colors.white70, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Events for ${DateFormat.yMMMd().format(_selectedDay)}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: _buildEventList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}