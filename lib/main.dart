import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maximize/models/database.dart';
import 'package:maximize/screens/calendar_page.dart';
import 'package:maximize/screens/task_list_screen.dart';
import 'package:maximize/screens/reminder_page.dart';
import 'package:maximize/services/calendar_service.dart';
import 'package:maximize/services/task_service.dart'; // ADDED: Import TaskService
import 'package:maximize/services/reminder_service.dart'; // ADDED: Import ReminderService
import 'package:maximize/models/task_model.dart';
import 'package:maximize/models/event_model.dart';
import 'package:maximize/models/reminder_model.dart'; // ADDED: Import ReminderModel
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// REMOVED: SharedPreferences import - no longer needed for checkboxes
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize timezone for notifications
  tz.initializeTimeZones();

  // ✅ Initialize your NotificationService (singleton)
  await NotificationService.instance.initialize();

  // ✅ Request POST_NOTIFICATIONS permission for Android 13+
  if (Platform.isAndroid) {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission(); // <--- important!
  }

  // ✅ Initialize Drift database
  final database = AppDatabase.instance;

  // ✅ Start the app
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
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
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

/* ────────────────────────────────────────────────────────────────────────── */
/* HOME PAGE – Drawer, Bottom Nav, and IndexedStack                         */
/* ────────────────────────────────────────────────────────────────────────── */

class MyHomePage extends StatefulWidget {
  final AppDatabase database;
  const MyHomePage({super.key, required this.database});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  /* Every screen used by the bottom-nav / drawer */
  late final List<Widget> _screens = [
    OverviewPage(database: widget.database),                         // 0
    TaskListScreen(database: widget.database),                       // 1
    CalendarPage(calendarService: CalendarService(widget.database)), // 2
    NotesPage(database: widget.database),                            // 3
    ReminderPage(database: widget.database),                         // 4
    SettingsPage(database: widget.database),                         // 5
  ];

  /* Helper for changing the visible page */
  void _jumpTo(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Maximize'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),

      /* ────────────── DRAWER ────────────── */
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Maximize', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            _drawerTile(title: 'Home',      icon: Icons.home,          index: 0),
            _drawerTile(title: 'Tasks',     icon: Icons.list,          index: 1),
            _drawerTile(title: 'Calendar',  icon: Icons.calendar_today,index: 2),
            _drawerTile(title: 'Notes',     icon: Icons.note,          index: 3), // <- NOTES
            _drawerTile(title: 'Reminders', icon: Icons.notifications, index: 4),
            _drawerTile(title: 'Settings',  icon: Icons.settings,      index: 5),
            _drawerTile(title: 'About',     icon: Icons.info,          index: 6), // Placeholder
          ],
        ),
      ),

      /* ─────────── MAIN CONTENT ─────────── */
      body: IndexedStack(index: _currentIndex, children: _screens), 

      /* ───────── BOTTOM NAVIGATION ──────── */
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _jumpTo,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey[850],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home),            label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list),            label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today),  label: 'Calendar'),
          BottomNavigationBarItem(icon: Icon(Icons.note),            label: 'Notes'),  // <- NOTES
          BottomNavigationBarItem(icon: Icon(Icons.notifications),   label: 'Reminders'),
          BottomNavigationBarItem(icon: Icon(Icons.settings),        label: 'Settings'),
        ],
      ),
    );
  }

  /* Drawer helper */
  ListTile _drawerTile({required String title, required IconData icon, required int index}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: _currentIndex == index,
      onTap: () {
        Navigator.pop(context);     // close drawer
        if (index < _screens.length) {
          _jumpTo(index);
        }
      },
    );
  }
}

/* ────────────────────────────────────────────────────────────────────────── */
/* OVERVIEW PAGE – UPDATED with unified checkbox system                      */
/* ────────────────────────────────────────────────────────────────────────── */

class OverviewPage extends StatefulWidget {
  final AppDatabase database;
  const OverviewPage({super.key, required this.database});
  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  // ADDED: Service instances for unified completion handling
  late final TaskService _taskService;
  late final CalendarService _calendarService;
  late final ReminderService _reminderService;

  // REMOVED: SharedPreferences variables - no longer needed

  @override
  void initState() {
    super.initState();
    // ADDED: Initialize service instances
    _taskService = TaskService(widget.database);
    _calendarService = CalendarService(widget.database);
    _reminderService = ReminderService(widget.database);
  }

  // REMOVED: _initPrefs method - no longer needed
  // REMOVED: _toggleId method - replaced with service methods

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Today\'s Tasks'),
          _taskSection(today),
          _sectionHeader('Today\'s Events'),
          _eventSection(today),
          _sectionHeader('Today\'s Reminders'),
          _reminderSection(today),
        ],
      ),
    );
  }

  /* ---------- UI helpers ---------- */

  Padding _sectionHeader(String text) => Padding(
    padding: const EdgeInsets.all(16),
    child: Text(text, style: Theme.of(context).textTheme.titleMedium?.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    )),
  );

  /* ---------- TASKS SECTION - UPDATED with unified completion system ---------- */
  SizedBox _taskSection(DateTime today) {
    return SizedBox(
      height: 250,
      child: FutureBuilder<List<TaskModel>>(
        future: _taskService.getTodaysTasks(), // ENHANCED: Use service method for today's tasks
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error loading tasks: ${snapshot.error}'));
          }

          final tasks = snapshot.data ?? [];
          
          if (tasks.isEmpty) {
            return const Center(
              child: Text(
                'No tasks for today!',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (_, i) {
              final task = tasks[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                color: task.completed ? Colors.grey[700] : Colors.grey[800], // ENHANCED: Visual feedback for completion
                child: Column(
                  children: [
                    ListTile(
                      leading: Checkbox(
                        value: task.completed, // ENHANCED: Use database completion status
                        onChanged: (value) => _toggleTaskCompletion(task.id, value), // ENHANCED: Use service method
                        activeColor: Colors.green,
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          color: Colors.white,
                          decoration: task.completed ? TextDecoration.lineThrough : null, // ENHANCED: Visual feedback
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Due: ${DateFormat('MMM dd, yyyy').format(task.dueDate)}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          if (task.description?.isNotEmpty == true)
                            Text(
                              task.description!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.grey),
                            ),
                        ],
                      ),
                      trailing: _buildPriorityIndicator(task.priority), // ENHANCED: Priority indicator
                    ),
                    // ENHANCED: Show subtasks with unified completion
                    FutureBuilder<List<SubtaskModel>>(
                      future: _taskService.getSubtasks(task.id),
                      builder: (_, subSnap) {
                        if (!subSnap.hasData || subSnap.data!.isEmpty) return const SizedBox.shrink();
                        final subtasks = subSnap.data!;
                        return Container(
                          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                          child: Column(
                            children: subtasks.map((subtask) => ListTile(
                              dense: true,
                              leading: SizedBox(
                                height: 20,
                                width: 20,
                                child: Checkbox(
                                  value: subtask.completed, // ENHANCED: Use database completion status
                                  onChanged: (value) => _toggleSubtaskCompletion(subtask.id, value), // ENHANCED: Use service method
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                              title: Text(
                                subtask.title,
                                style: TextStyle(
                                  color: Colors.grey[300],
                                  fontSize: 14,
                                  decoration: subtask.completed ? TextDecoration.lineThrough : null, // ENHANCED: Visual feedback
                                ),
                              ),
                            )).toList(),
                          ),
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
    );
  }

  /* ---------- EVENTS SECTION - UPDATED with unified completion system ---------- */
  SizedBox _eventSection(DateTime today) {
    return SizedBox(
      height: 200,
      child: FutureBuilder<List<Event>>(
        future: _calendarService.getTodaysEvents(), // ENHANCED: Use service method for today's events
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading events: ${snapshot.error}'));
          }

          final events = snapshot.data ?? [];

          if (events.isEmpty) {
            return const Center(
              child: Text(
                'No events today!',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (_, i) {
              final event = events[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                color: event.completed ? Colors.grey[700] : Colors.grey[800], // ENHANCED: Visual feedback for completion
                child: ListTile(
                  leading: Checkbox(
                    value: event.completed, // ENHANCED: Use database completion status
                    onChanged: (value) => _toggleEventCompletion(event.id, value), // ENHANCED: Use service method
                    activeColor: Colors.green,
                  ),
                  title: Text(
                    event.title,
                    style: TextStyle(
                      color: Colors.white,
                      decoration: event.completed ? TextDecoration.lineThrough : null, // ENHANCED: Visual feedback
                    ),
                  ),
                  subtitle: Text(
                    '${DateFormat('hh:mm a').format(event.startDateTime)} – ${DateFormat('hh:mm a').format(event.endDateTime)}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Event',
                      style: TextStyle(color: Colors.blue, fontSize: 12),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /* ---------- REMINDERS SECTION - UPDATED with unified completion system ---------- */
  SizedBox _reminderSection(DateTime today) {
    return SizedBox(
      height: 200,
      child: FutureBuilder<List<ReminderModel>>(
        future: _reminderService.getTodaysReminders(), // ENHANCED: Use service method for today's reminders
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading reminders: ${snapshot.error}'));
          }

          final reminders = snapshot.data ?? [];

          if (reminders.isEmpty) {
            return const Center(
              child: Text(
                'No reminders today!',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: reminders.length,
            itemBuilder: (_, i) {
              final reminder = reminders[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                color: reminder.completed ? Colors.grey[700] : Colors.grey[800], // ENHANCED: Visual feedback for completion
                child: ListTile(
                  leading: Checkbox(
                    value: reminder.completed, // ENHANCED: Use database completion status
                    onChanged: (value) => _toggleReminderCompletion(reminder.id, value), // ENHANCED: Use service method
                    activeColor: Colors.green,
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
                        'Scheduled: ${DateFormat('hh:mm a').format(reminder.scheduledTime)}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      if (reminder.body.isNotEmpty)
                        Text(
                          reminder.body,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.grey),
                        ),
                    ],
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.alarm, color: Colors.orange, size: 16),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /* ---------- ENHANCED: Helper methods for unified completion handling ---------- */

  // ADDED: Priority indicator widget
  Widget _buildPriorityIndicator(String priority) {
    Color color;
    switch (priority.toLowerCase()) {
      case 'high':
        color = Colors.red;
        break;
      case 'medium':
        color = Colors.orange;
        break;
      case 'low':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        priority,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ADDED: Task completion toggle using TaskService
  Future<void> _toggleTaskCompletion(String taskId, bool? isCompleted) async {
    try {
      if (isCompleted == true) {
        await _taskService.markTaskCompleted(taskId);
      } else {
        await _taskService.markTaskIncomplete(taskId);
      }
      setState(() {}); // Refresh the UI
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update task: $error')),
      );
    }
  }

  // ADDED: Subtask completion toggle using TaskService
  Future<void> _toggleSubtaskCompletion(String subtaskId, bool? isCompleted) async {
    try {
      if (isCompleted == true) {
        await _taskService.markSubtaskCompleted(subtaskId);
      } else {
        // Create incomplete method or use direct update
        final subtasks = await widget.database.getAllSubtasks('');
        final subtaskData = subtasks.firstWhere((s) => s.id == subtaskId);
        final subtask = SubtaskModel(
          id: subtaskData.id,
          taskId: subtaskData.taskId,
          title: subtaskData.title,
          completed: subtaskData.completed,
          completedAt: subtaskData.completedAt,
        );
        
        final updatedSubtask = subtask.copyWith(completed: false, completedAt: null);
        await _taskService.updateSubtask(updatedSubtask);
      }
      setState(() {}); // Refresh the UI
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update subtask: $error')),
      );
    }
  }

  // ADDED: Event completion toggle using CalendarService
  Future<void> _toggleEventCompletion(String eventId, bool? isCompleted) async {
    try {
      if (isCompleted == true) {
        await _calendarService.markEventCompleted(eventId);
      } else {
        await _calendarService.markEventIncomplete(eventId);
      }
      setState(() {}); // Refresh the UI
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update event: $error')),
      );
    }
  }

  // ADDED: Reminder completion toggle using ReminderService
  Future<void> _toggleReminderCompletion(String reminderId, bool? isCompleted) async {
    try {
      if (isCompleted == true) {
        await _reminderService.markReminderCompleted(reminderId);
      } else {
        await _reminderService.markReminderIncomplete(reminderId);
      }
      setState(() {}); // Refresh the UI
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update reminder: $error')),
      );
    }
  }
}

/* ────────────────────────────────────────────────────────────────────────── */
/* PLACEHOLDER PAGES                                                         */
/* ────────────────────────────────────────────────────────────────────────── */

class SettingsPage extends StatelessWidget {
  final AppDatabase database;
  const SettingsPage({super.key, required this.database});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Settings page'));
}

class NotesPage extends StatelessWidget {
  final AppDatabase database;
  const NotesPage({super.key, required this.database});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Notes page'));
}
