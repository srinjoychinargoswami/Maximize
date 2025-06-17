import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maximize/models/database.dart'; // Import your Drift database file
import 'package:maximize/screens/calendar_page.dart'; // Import the calendar_page.dart file
import 'package:maximize/services/calendar_service.dart';
import 'package:maximize/screens/task_list_screen.dart';
import 'package:maximize/models/event_model.dart'; // Adjust the path as necessary
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:maximize/models/task_model.dart';

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
            ListTile(
              title: const Text('About'),
              onTap: () {
                // Add code to navigate to about page
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

          // Calendar // Calendar page
          CalendarPage(calendarService: CalendarService(widget.database)),

          // Notes page
          NotesPage(database: widget.database),

          // Reminders page
          RemindersPage(database: widget.database),

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
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
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
  }

  void loadCompletedTasks() {
    completedTaskIds = _prefs?.getStringList('completedTasks') ?? [];
  }

  void loadCompletedEvents() {
    completedEventIds = _prefs?.getStringList('completedEvents') ?? [];
  }

  void saveCompletedTasks() {
    _prefs?.setStringList('completedTasks', completedTaskIds);
  }

  void saveCompletedEvents() {
    _prefs?.setStringList('completedEvents', completedEventIds);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header for Tasks
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Tasks',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Expanded(
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
                  final isChecked = completedTaskIds.contains(task.id); // Assuming TaskData has an id property
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
                                  completedTaskIds.add(task.id); // Mark task as completed
                                } else {
                                  completedTaskIds.remove(task.id); // Uncheck the task
                                }
                                saveCompletedTasks(); // Save state to shared preferences
                              });
                            },
                          ),
                        ),
                        // Display subtasks
                        FutureBuilder<List<SubtaskModel>>(
                          future: widget.database.getAllSubtasks(task.id), // Fetch subtasks for the task
                          builder: (context, subtaskSnapshot) {
                            if (subtaskSnapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (subtaskSnapshot.hasError) {
                              return Center(child: Text('Error: ${subtaskSnapshot.error}'));
                            } else if (!subtaskSnapshot.hasData || subtaskSnapshot.data!.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('No subtasks available.'),
                              );
                            }

                            final subtasks = subtaskSnapshot.data!;
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: subtasks.length,
                              itemBuilder: (context, subtaskIndex) {
                                final subtask = subtasks[subtaskIndex];
                                final isSubtaskChecked = completedTaskIds.contains(subtask.id); // Assuming SubtaskModel has an id property
                                return ListTile(
                                  title: Text(subtask.title),
                                  trailing: Checkbox(
                                    value: isSubtaskChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == true) {
                                          completedTaskIds.add(subtask.id); // Mark subtask as completed
                                        } else {
                                          completedTaskIds.remove(subtask.id); // Uncheck the subtask
                                        }
                                        saveCompletedTasks(); // Save state to shared preferences
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
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Calendar Events',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Event>>(
            future: CalendarService(widget.database).getEvents(), // Fetch all events
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
                return DateFormat('MM/dd/yyyy').format(event.startDateTime) == formattedToday; // Assuming event.startDateTime is a DateTime
              }).toList();

              return ListView.builder(
                itemCount: todayEvents.length,
                itemBuilder: (context, index) {
                  final event = todayEvents[index];
                  final isChecked = completedEventIds.contains(event.id); // Assuming Event has an id property
                  return Card(
                    child: ListTile(
                      title: Text(event.title), // Assuming event has a title property
                      subtitle: Text(
                        '${DateFormat('MM/dd/yyyy').format(event.startDateTime)} at ${DateFormat('hh:mm a').format(event.startDateTime)} to ${DateFormat('hh:mm a').format(event.endDateTime)}', // Display the event date
                      ),
                      trailing: Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              completedEventIds.add(event.id); // Mark event as completed
                            } else {
                              completedEventIds.remove(event.id); // Uncheck the event
                            }
                            saveCompletedEvents(); // Save state to shared preferences
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

class RemindersPage extends StatelessWidget {
  final AppDatabase database;

  const RemindersPage({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Reminders page'));
  }
}