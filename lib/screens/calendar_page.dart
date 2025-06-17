import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:maximize/models/event_model.dart';
import 'package:maximize/services/calendar_service.dart';
import 'package:uuid/uuid.dart'; // Import the UUID package
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // Import color picker package

class CalendarPage extends StatefulWidget {
  final CalendarService calendarService;

  const CalendarPage({super.key, required this.calendarService});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late EventController _eventController;
  DateTime _selectedDay = DateTime.now();
  List<Event> _events = [];
  String _currentView = 'month'; // Track the current view
  Map<String, bool> _eventCheckedStates = {}; // Checkbox states for events
  SharedPreferences? _prefs;
  Color _selectedColor = Colors.blue; // Default color for new events

  @override
  void initState() {
    super.initState();
    _eventController = EventController();
    _loadEvents();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadCheckedStates();
  }

  void _loadCheckedStates() {
    for (var event in _events) {
      bool isChecked = _prefs?.getBool(event.id) ?? false; // Default to false
      _eventCheckedStates[event.id] = isChecked;
    }
  }

  void _saveCheckedStates() {
    _eventCheckedStates.forEach((eventId, isChecked) {
      _prefs?.setBool(eventId, isChecked); // Save each checkbox state
    });
  }

  Future<void> _loadEvents() async {
    List<Event> events = await widget.calendarService.getEvents();
    setState(() {
      _events = events;
      _eventCheckedStates = {}; // Reset the checkbox states
      // Add events to the controller
      for (var event in events) {
        _eventController.add(CalendarEventData(
          date: event.startDateTime,
          title: event.title, // Ensure you pass the title here
          color: Color(int.parse(event.color.replaceFirst('#', '0xff'))), // Pass the color
        ));
        // Initialize checkbox states
        _eventCheckedStates[event.id] = false; // Default to unchecked
      }
    });
  }

  void _editEvent(Event event) {
    final TextEditingController titleController = TextEditingController(text: event.title);
    final TextEditingController descriptionController = TextEditingController(text: event.description);
    DateTime startDate = event.startDateTime;
    DateTime endDate = event.endDateTime;
    TimeOfDay? startTime = TimeOfDay.fromDateTime(event.startDateTime);
    TimeOfDay? endTime = TimeOfDay.fromDateTime(event.endDateTime);
    Color selectedColor = Color(int.parse(event.color.replaceFirst('#', '0xff'))); // Convert color string to Color
    String customCategory = event.customCategory ?? ''; // Get custom category

    showDialog(
      context: context,
      builder: (context) {
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
                          setState(() {
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
                          setState(() {
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
                          firstDate: startDate, // Ensure end date is after start date
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          setState(() {
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
                          setState(() {
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
                                setState(() {
                                  selectedColor = color;
                                });
                                Navigator.of(context).pop(); // Close the color picker dialog
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
                  controller: TextEditingController(text: customCategory),
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
              onPressed: () {
                if (titleController.text.isNotEmpty && startDate != null && endDate != null) {
                  final updatedEvent = Event(
                    id: event.id, // Keep the same ID for the event
                    title: titleController.text,
                    description: descriptionController.text, // Add description
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
                    date: startDate, // Use start date for the date field
                    customCategory: customCategory, // Update custom category
                    color: '#${selectedColor.value.toRadixString(16).substring(2)}', // Convert color to hex string
                  );

                  setState(() {
                    int index = _events.indexWhere((e) => e.id == event.id);
                    if (index != -1) {
                      _events[index] = updatedEvent; // Update the event in the list
                      _eventController.remove(CalendarEventData(
                        date: event.startDateTime,
                        title: event.title,
                      ));
                      _eventController.add(CalendarEventData(
                        date: updatedEvent.startDateTime,
                        title: updatedEvent.title,
                        color: Color(int.parse(updatedEvent.color.replaceFirst('#', '0xff'))), // Pass the updated color
                      ));
                    }
                  });

                  Navigator.of(context).pop();
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showAddEventDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    DateTime startDate = DateTime.now(); // Default start date
    DateTime endDate = DateTime.now().add(Duration(days: 1)); // Default end date to one day later
    TimeOfDay? startTime; // Declare startTime
    TimeOfDay? endTime; // Declare endTime

    showDialog(
      context: context,
      builder: (context) {
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
                          setState(() {
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
                          setState(() {
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
                          firstDate: startDate, // Ensure end date is after start date
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          setState(() {
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
                          setState(() {
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
                                setState(() {
                                  _selectedColor = color;
                                });
                                Navigator.of(context).pop(); // Close the color picker dialog
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
                  decoration: InputDecoration(hintText: 'Enter custom category'),
                  onChanged: (value) {
                    // Store the custom category value
                  },
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
                if (titleController.text.isNotEmpty && startDate != null && endDate != null) {
                  final newEvent = Event(
                    id: Uuid().v4(),
                    title: titleController.text,
                    description: descriptionController.text,
                    startDateTime: DateTime(
                      startDate.year,
                      startDate.month,
                      startDate.day,
                      startTime?.hour ?? 0,
                      startTime?.minute ?? 0,
                    ),
                    endDateTime: DateTime(
                      endDate.year,
                      endDate.month,
                      endDate.day,
                      endTime?.hour ?? 0,
                      endTime?.minute ?? 0,
                    ),
                    date: startDate, // Use start date for the date field
                    customCategory: '', // Default category (can be updated)
                    color: '#${_selectedColor.value.toRadixString(16).substring(2)}', // Convert color to hex string
                  );
                  // Save the new event to the database
                  await widget.calendarService.addEvent(newEvent);
                  
                  setState(() {
                    _events.add(newEvent);
                    _eventCheckedStates[newEvent.id] = false; // Initialize checkbox state
                    _eventController.add(CalendarEventData(
                      date: newEvent.startDateTime,
                      title: newEvent.title,
                      color: Color(int.parse(newEvent.color.replaceFirst('#', '0xff'))), // Pass the color
                    ));
                  });

                  _saveCheckedStates(); // Save the new checkbox state
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
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
          content: Text('Are you sure you want to delete "${event.title }"?'),
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
                  // Call the delete method from CalendarService
                  await widget.calendarService.deleteEvent(event.id);
                  
                  setState(() {
                    _events.remove(event);
                    _eventController.remove(CalendarEventData(
                      date: event.startDateTime,
                      title: event.title,
                    ));
                    _eventCheckedStates.remove(event.id); // Remove checkbox state
                    _saveCheckedStates(); // Save updated checkbox states
                  });
                  Navigator.of(context).pop();
                } catch (e) {
                  // Handle any errors that occur during deletion
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

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: _eventController,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Calendar'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: _showAddEventDialog,
            ),
          ],
        ),
        body: Container(
          color: Colors.grey[850],
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(80, 30),
                        padding: EdgeInsets.all(5),
                      ),
                      onPressed: () {
                        setState(() {
                          _currentView = 'month';
                        });
                      },
                      child: Text('Month View', style: TextStyle(fontSize: 16)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(80, 30),
                        padding: EdgeInsets.all(5),
                      ),
                      onPressed: () {
                        setState(() {
                          _currentView = 'week';
                        });
                      },
                      child: Text('Week View', style: TextStyle(fontSize: 16)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(80, 30),
                        padding: EdgeInsets.all(5),
                      ),
                      onPressed: () {
                        setState(() {
                          _currentView = 'day';
                        });
                      },
                      child: Text('Day View', style: TextStyle(fontSize: 16)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(80, 30),
                        padding: EdgeInsets.all(5),
                      ),
                      onPressed: () {
                        setState(() {
                          _currentView = 'list';
                        });
                      },
                      child: Text('List View', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  color: Colors.grey[850],
                  child: _currentView == 'month'
                      ? MonthView(
                          controller: _eventController,
                          onCellTap: (events, date) {
                            setState(() {
                              _selectedDay = date;
                              _loadEvents();
                            });
                          },
                        )
                      : _currentView == 'week'
                          ? WeekView(
                              controller: _eventController,
                              onDateLongPress: (date) {
                                setState(() {
                                  _selectedDay = date;
                                  _loadEvents();
                                });
                              },
                            )
                          : _currentView == 'day'
                              ? DayView(
                                  controller: _eventController,
                                  onDateLongPress: (date) {
                                    setState(() {
                                      _selectedDay = date;
                                      _loadEvents();
                                    });
                                  },
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _events.length,
                                  itemBuilder: (context, index) {
                                    Event event = _events[index];
                                    return ListTile(
                                      title: Text(event.title, style: TextStyle(color: Colors.white)),
                                      subtitle: Text(
                                        '${DateFormat.yMMMd().format(event.date)} - ${DateFormat.jm().format(event.startDateTime)} to ${DateFormat.jm().format(event.endDateTime)} - ${event.description} - Category: ${event.customCategory} - Color: ${event.color}',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Checkbox(
                                            value: _eventCheckedStates[event.id] ?? false,
                                            onChanged: (value) {
                                              setState(() {
                                                _eventCheckedStates[event.id] = value!;
                                                _saveCheckedStates(); // Save checkbox state
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
                                    );
                                  },
                                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}