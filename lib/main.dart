import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maximize/models/database.dart'; // Import your Drift database file
import 'package:maximize/screens/calendar_page.dart'; // Import the calendar_page.dart file
import 'package:maximize/services/calendar_service.dart';
import 'package:maximize/screens/task_list_screen.dart';
import 'package:maximize/models/event_model.dart'; // Adjust the path as necessary
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:maximize/models/task_model.dart';
import 'package:maximize/screens/reminder_page.dart'; // Import reminder page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase.instance; // Initialize your database

  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;

  const MyApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maximize',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[850],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[800],
          titleTextStyle: const TextStyle(color: Colors.white),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.grey, fontSize: 16),
          bodyMedium: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
      home: MyHomePage(database: database),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final AppDatabase database;

  const MyHomePage({super.key, required this.database});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Maximize'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Maximize',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Tasks'),
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Calendar'),
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Notes'),
              onTap: () {
                setState(() {
                  _currentIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Reminders'),
              onTap: () {
                setState(() {
                  _currentIndex = 4;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                setState(() {
                  _currentIndex = 5;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('About'),
              onTap: () {
                setState(() {
                  _currentIndex = 6;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Overview page
          OverviewPage(database: widget.database),

          // Tasks page
          TaskListScreen(database: widget.database),

          // Calendar page
          CalendarPage(calendarService: CalendarService(widget.database)),

          // Notes page
          NotesPage(database: widget.database),

          // Reminders page - Updated to use ReminderPage
          ReminderPage(database: widget.database),

          // Settings page
          SettingsPage(database: widget.database),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey[850],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
          BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Notes'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Reminders'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class OverviewPage extends StatefulWidget {
  final AppDatabase database;

  const OverviewPage({super.key, required this.database});

  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  List<String> completedTaskIds = [];
  List<String> completedEventIds = [];
  List<String> completedReminderIds = [];
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  void initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    loadCompletedTasks();
    loadCompletedEvents();
    loadCompletedReminders();
  }

  void loadCompletedTasks() {
    completedTaskIds = _prefs?.getStringList('completedTasks') ?? [];
  }

  void loadCompletedEvents() {
    completedEventIds = _prefs?.getStringList('completedEvents') ?? [];
  }

  void loadCompletedReminders() {
    completedReminderIds = _prefs?.getStringList('completedReminders') ?? [];
  }

  void saveCompletedTasks() {
    _prefs?.setStringList('completedTasks', completedTaskIds);
  }

  void saveCompletedEvents() {
    _prefs?.setStringList('completedEvents', completedEventIds);
  }

  void saveCompletedReminders() {
    _prefs?.setStringList('completedReminders', completedReminderIds);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header for Tasks
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Tasks',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          SizedBox(
            height: 250, // Fixed height for tasks section
            child: FutureBuilder<List<TaskData>>(
              future: widget.database.getAllTasks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No tasks available.'));
                }

                final tasks = snapshot.data!;
                final today = DateTime.now();
                final formattedToday = DateFormat('MM/dd/yyyy').format(today);

                // Filter tasks to only include high priority or due today
                final filteredTasks = tasks.where((task) {
                  final isDueToday = DateFormat('MM/dd/yyyy').format(task.dueDate) == formattedToday;
                  final isHighPriority = task.priority == 'High';

                  return isDueToday || isHighPriority;
                }).toList();

                return ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    final isChecked = completedTaskIds.contains(task.id);
                    return Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(task.name),
                            subtitle: Text(DateFormat('MM/dd/yyyy').format(task.dueDate)),
                            trailing: Checkbox(
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    completedTaskIds.add(task.id);
                                  } else {
                                    completedTaskIds.remove(task.id);
                                  }
                                  saveCompletedTasks();
                                });
                              },
                            ),
                          ),
                          // Display subtasks
                          FutureBuilder<List<SubtaskModel>>(
                            future: widget.database.getAllSubtasks(task.id),
                            builder: (context, subtaskSnapshot) {
                              if (subtaskSnapshot.connectionState == ConnectionState.waiting) {
                                return const SizedBox.shrink();
                              } else if (subtaskSnapshot.hasError) {
                                return const SizedBox.shrink();
                              } else if (!subtaskSnapshot.hasData || subtaskSnapshot.data!.isEmpty) {
                                return const SizedBox.shrink();
                              }

                              final subtasks = subtaskSnapshot.data!;
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: subtasks.length,
                                itemBuilder: (context, subtaskIndex) {
                                  final subtask = subtasks[subtaskIndex];
                                  final isSubtaskChecked = completedTaskIds.contains(subtask.id);
                                  return ListTile(
                                    title: Text(subtask.title),
                                    trailing: Checkbox(
                                      value: isSubtaskChecked,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            completedTaskIds.add(subtask.id);
                                          } else {
                                            completedTaskIds.remove(subtask.id);
                                          }
                                          saveCompletedTasks();
                                        });
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          
          // Header for Calendar Events
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Calendar Events',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          SizedBox(
            height: 200, // Fixed height for events section
            child: FutureBuilder<List<Event>>(
              future: CalendarService(widget.database).getEvents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No events available.'));
                }

                final events = snapshot.data!;
                final today = DateTime.now();
                final formattedToday = DateFormat('MM/dd/yyyy').format(today);

                // Filter events to only include those due today
                final todayEvents = events.where((event) {
                  return DateFormat('MM/dd/yyyy').format(event.startDateTime) == formattedToday;
                }).toList();

                return ListView.builder(
                  itemCount: todayEvents.length,
                  itemBuilder: (context, index) {
                    final event = todayEvents[index];
                    final isChecked = completedEventIds.contains(event.id);
                    return Card(
                      child: ListTile(
                        title: Text(event.title),
                        subtitle: Text(
                          '${DateFormat('MM/dd/yyyy').format(event.startDateTime)} at ${DateFormat('hh:mm a').format(event.startDateTime)} to ${DateFormat('hh:mm a').format(event.endDateTime)}',
                        ),
                        trailing: Checkbox(
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                completedEventIds.add(event.id);
                              } else {
                                completedEventIds.remove(event.id);
                              }
                              saveCompletedEvents();
                            });
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Header for Reminders
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Today\'s Reminders',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          SizedBox(
            height: 200, // Fixed height for reminders section
            child: FutureBuilder<List<ReminderData>>(
              future: widget.database.getAllReminders(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No reminders available.'));
                }

                final reminders = snapshot.data!;
                final today = DateTime.now();
                final formattedToday = DateFormat('MM/dd/yyyy').format(today);

                // Filter reminders to only include those scheduled for today
                final todayReminders = reminders.where((reminder) {
                  return DateFormat('MM/dd/yyyy').format(reminder.scheduledTime) == formattedToday;
                }).toList();

                if (todayReminders.isEmpty) {
                  return const Center(child: Text('No reminders for today.'));
                }

                return ListView.builder(
                  itemCount: todayReminders.length,
                  itemBuilder: (context, index) {
                    final reminder = todayReminders[index];
                    final isChecked = completedReminderIds.contains(reminder.id);
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.alarm, color: Colors.orange),
                        title: Text(reminder.title),
                        subtitle: Text(
                          'Scheduled for: ${DateFormat('hh:mm a').format(reminder.scheduledTime)}',
                        ),
                        trailing: Checkbox(
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                completedReminderIds.add(reminder.id);
                              } else {
                                completedReminderIds.remove(reminder.id);
                              }
                              saveCompletedReminders();
                            });
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  final AppDatabase database;

  const SettingsPage({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Settings page'));
  }
}

class NotesPage extends StatelessWidget {
  final AppDatabase database;

  const NotesPage({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Notes page'));
  }
}

// Remove the old RemindersPage class since we're now using ReminderPage
