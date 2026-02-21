import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import 'package:maximize/models/database.dart';
import 'package:maximize/screens/calendar_page.dart';
import 'package:maximize/screens/task_list_screen.dart';
import 'package:maximize/screens/search_page.dart';
import 'package:maximize/screens/reminder_page.dart';
import 'package:maximize/screens/notes_page.dart'; 
import 'package:maximize/services/api_service.dart';
import 'package:maximize/services/calendar_service.dart';
import 'package:maximize/services/task_service.dart';
import 'package:maximize/services/reminder_service.dart';
import 'package:maximize/services/note_service.dart'; 
import 'package:maximize/models/task_model.dart';
import 'package:maximize/models/event_model.dart';
import 'package:maximize/models/reminder_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;

// CustomScrollBehavior to fix RefreshIndicator on Windows desktop
class CustomScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone for notifications
  tz_data.initializeTimeZones();

  // Initialize your NotificationService (singleton)
  await NotificationService.instance.initialize();

  // Request POST_NOTIFICATIONS permission for Android 13+
  if (Platform.isAndroid) {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
  }

  // Initialize Drift database
  final database = AppDatabase.instance;
  final apiService = ApiService(db: database);

  // Start the app
  runApp(MyApp(database: database, apiService: apiService));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;
  final ApiService apiService;
  const MyApp({super.key, required this.database, required this.apiService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maximize',
      scrollBehavior: CustomScrollBehavior(),
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
      home: MyHomePage(database: database, apiService: apiService),
    );
  }
}

/* HOME PAGE – Drawer, Bottom Nav, and IndexedStack */

class MyHomePage extends StatefulWidget {
  final AppDatabase database;
  final ApiService apiService;
  const MyHomePage({super.key, required this.database, required this.apiService});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  
  // ADDED: Keys to access refresh methods in child pages
  final GlobalKey<_OverviewPageState> _overviewKey = GlobalKey<_OverviewPageState>();
  final GlobalKey<State> _tasksKey = GlobalKey<State>();
  final GlobalKey<State> _calendarKey = GlobalKey<State>();
  final GlobalKey<State> _notesKey = GlobalKey<State>(); 
  final GlobalKey<State> _remindersKey = GlobalKey<State>();



  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Initialize screens with keys
    _screens = [
      OverviewPage(key: _overviewKey, database: widget.database),
      TaskListScreen(key: _tasksKey, database: widget.database),
      CalendarPage(key: _calendarKey, calendarService: CalendarService(widget.database)),
      NotesPage(key: _notesKey, noteService: NoteService(widget.database)), 
      ReminderPage(key: _remindersKey, database: widget.database),
      SettingsPage(api: widget.apiService),
    ];
  }

  void _jumpTo(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // ADDED: Refresh method that calls appropriate page refresh
  Future<void> _refreshCurrentPage() async {
    try {
      switch (_currentIndex) {
        case 0: // Overview
          await _overviewKey.currentState?._refreshData();
          break;
        case 1: // Tasks
          (_tasksKey.currentState as dynamic)?.refreshTasks();
          break;
        case 2: // Calendar
          (_calendarKey.currentState as dynamic)?._loadEvents();
          break;
        case 3: // Notes
          (_notesKey.currentState as dynamic)?._loadNotes(); 
          break;
        case 4: // Reminders
          (_remindersKey.currentState as dynamic)?._loadReminders();
          break;
        case 5: // Settings
          // No refresh needed for settings
          break;
      }
    } catch (e) {
      print('Error refreshing page: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Refresh complete!')),
      );
    }
  }

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
        // ADDED: Refresh button
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshCurrentPage,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _navigateToSearch(),
            tooltip: 'Search',
          )
        ],
      ),



      /*  DRAWER  */
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Maximize', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            _drawerTile(title: 'Home', icon: Icons.home, index: 0),
            _drawerTile(title: 'Tasks', icon: Icons.list, index: 1),
            _drawerTile(title: 'Calendar', icon: Icons.calendar_today, index: 2),
            _drawerTile(title: 'Notes', icon: Icons.note, index: 3),
            _drawerTile(title: 'Reminders', icon: Icons.notifications, index: 4),
            _drawerTile(title: 'Syncing', icon: Icons.sync, index: 5),
            _drawerTile(title: 'About', icon: Icons.info, index: 6),
          ],
        ),
      ),



      /*  MAIN CONTENT  */
      body: IndexedStack(index: _currentIndex, children: _screens),



      /*  BOTTOM NAVIGATION */
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _jumpTo,
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
          BottomNavigationBarItem(icon: Icon(Icons.sync), label: 'Syncing'),
        ],
      ),
    );
  }



  ListTile _drawerTile({required String title, required IconData icon, required int index}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: _currentIndex == index,
      onTap: () {
        Navigator.pop(context);
        if (index < _screens.length) {
          _jumpTo(index);
        }
      },
    );
  }
}



/* OVERVIEW PAGE */



class OverviewPage extends StatefulWidget {
  final AppDatabase database;
  const OverviewPage({super.key, required this.database});
  @override
  State<OverviewPage> createState() => _OverviewPageState();
}



class _OverviewPageState extends State<OverviewPage> {
  late final TaskService _taskService;
  late final CalendarService _calendarService;
  late final ReminderService _reminderService;



  @override
  void initState() {
    super.initState();
    _taskService = TaskService(widget.database);
    _calendarService = CalendarService(widget.database);
    _reminderService = ReminderService(widget.database);
  }



  // UPDATED: Made public so parent can call it
  Future<void> _refreshData() async {
    setState(() {}); // This triggers all FutureBuilders to rebuild
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Overview refreshed!'),
        duration: Duration(seconds: 1),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();



    return ScrollConfiguration(
      behavior: CustomScrollBehavior(),
      child: RefreshIndicator(
        onRefresh: _refreshData,
        color: Colors.blue,
        backgroundColor: Colors.white,
        strokeWidth: 2.0,
        displacement: 40.0,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ADDED: Dashboard Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade700, Colors.blue.shade500],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dashboard',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('EEEE, MMMM dd, yyyy').format(today),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              
              _sectionHeader('Today\'s Tasks'),
              _taskSection(today),
              _sectionHeader('Today\'s Events'),
              _eventSection(today),
              _sectionHeader('Today\'s Reminders'),
              _reminderSection(today),
            ],
          ),
        ),
      ),
    );
  }



  Padding _sectionHeader(String text) => Padding(
    padding: const EdgeInsets.all(16),
    child: Text(text, style: Theme.of(context).textTheme.titleMedium?.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    )),
  );



  SizedBox _taskSection(DateTime today) {
    return SizedBox(
      height: 250,
      child: FutureBuilder<List<TaskModel>>(
        future: _taskService.getTodaysTasks(),
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
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: tasks.length,
            itemBuilder: (_, i) {
              final task = tasks[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                color: task.completed ? Colors.grey[700] : Colors.grey[800],
                child: Column(
                  children: [
                    ListTile(
                      leading: Checkbox(
                        value: task.completed,
                        onChanged: (value) => _toggleTaskCompletion(task.id, value),
                        activeColor: Colors.green,
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          color: Colors.white,
                          decoration: task.completed ? TextDecoration.lineThrough : null,
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
                      trailing: _buildPriorityIndicator(task.priority),
                    ),
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
                                  value: subtask.completed,
                                  onChanged: (value) => _toggleSubtaskCompletion(subtask.id, value),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                              title: Text(
                                subtask.title,
                                style: TextStyle(
                                  color: Colors.grey[300],
                                  fontSize: 14,
                                  decoration: subtask.completed ? TextDecoration.lineThrough : null,
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



  SizedBox _eventSection(DateTime today) {
    return SizedBox(
      height: 200,
      child: FutureBuilder<List<Event>>(
        future: _calendarService.getTodaysEvents(),
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
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: events.length,
            itemBuilder: (_, i) {
              final event = events[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                color: event.completed ? Colors.grey[700] : Colors.grey[800],
                child: ListTile(
                  leading: Checkbox(
                    value: event.completed,
                    onChanged: (value) => _toggleEventCompletion(event.id, value),
                    activeColor: Colors.green,
                  ),
                  title: Text(
                    event.title,
                    style: TextStyle(
                      color: Colors.white,
                      decoration: event.completed ? TextDecoration.lineThrough : null,
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



  SizedBox _reminderSection(DateTime today) {
    return SizedBox(
      height: 200,
      child: FutureBuilder<List<ReminderModel>>(
        future: _reminderService.getTodaysReminders(),
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
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: reminders.length,
            itemBuilder: (_, i) {
              final reminder = reminders[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                color: reminder.completed ? Colors.grey[700] : Colors.grey[800],
                child: ListTile(
                  leading: Checkbox(
                    value: reminder.completed,
                    onChanged: (value) => _toggleReminderCompletion(reminder.id, value),
                    activeColor: Colors.green,
                  ),
                  title: Text(
                    reminder.title,
                    style: TextStyle(
                      color: Colors.white,
                      decoration: reminder.completed ? TextDecoration.lineThrough : null,
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



  Future<void> _toggleTaskCompletion(String taskId, bool? isCompleted) async {
    try {
      if (isCompleted == true) {
        await _taskService.markTaskCompleted(taskId);
      } else {
        await _taskService.markTaskIncomplete(taskId);
      }
      setState(() {});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update task: $error')),
      );
    }
  }



  Future<void> _toggleSubtaskCompletion(String subtaskId, bool? isCompleted) async {
    try {
      if (isCompleted == true) {
        await _taskService.markSubtaskCompleted(subtaskId);
      } else {
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
      setState(() {});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update subtask: $error')),
      );
    }
  }



  Future<void> _toggleEventCompletion(String eventId, bool? isCompleted) async {
    try {
      if (isCompleted == true) {
        await _calendarService.markEventCompleted(eventId);
      } else {
        await _calendarService.markEventIncomplete(eventId);
      }
      setState(() {});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update event: $error')),
      );
    }
  }



  Future<void> _toggleReminderCompletion(String reminderId, bool? isCompleted) async {
    try {
      if (isCompleted == true) {
        await _reminderService.markReminderCompleted(reminderId);
      } else {
        await _reminderService.markReminderIncomplete(reminderId);
      }
      setState(() {});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update reminder: $error')),
      );
    }
  }
}



// Settings page
class SettingsPage extends StatefulWidget {
  final ApiService api;



  const SettingsPage({super.key, required this.api});



  @override
  State<SettingsPage> createState() => _SettingsPageState();
}



class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _repoController = TextEditingController();



  bool _tokenSaved = false;
  bool _usernameSaved = false;
  bool _repoSaved = false;
  bool _obscureText = true;



  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }



  Future<void> _loadSavedData() async {
    final storedToken = await widget.api.getStoredToken();
    final storedUsername = await widget.api.getGitHubUsername();
    final storedRepo = await widget.api.getGitHubRepo();



    if (storedToken != null) {
      _tokenController.text = storedToken;
      _tokenSaved = true;
    }



    if (storedUsername.isNotEmpty) {
      _usernameController.text = storedUsername;
      _usernameSaved = true;
    }



    if (storedRepo.isNotEmpty) {
      _repoController.text = storedRepo;
      _repoSaved = true;
    }



    setState(() {});
  }



  @override
  void dispose() {
    _tokenController.dispose();
    _usernameController.dispose();
    _repoController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syncing', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Cloud Sync',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
            ),
          ),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.cloud_upload),
                    label: const Text("Sync to Cloud"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      try {
                        await widget.api.syncToGitHub();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sync to Cloud complete!')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Sync to Cloud failed: $e')),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.cloud_download),
                    label: const Text("Sync from Cloud"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      try {
                        await widget.api.syncFromGitHub();
                        
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        await Future.delayed(const Duration(milliseconds: 100));
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sync from Cloud complete! Data refreshed.')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Sync from Cloud failed: $e')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),



          const SizedBox(height: 32),



          Text(
            'GitHub Username',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter your GitHub username',
            ),
          ),



          const SizedBox(height: 24),



          Text(
            'GitHub Repository Name',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _repoController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter your GitHub repo name',
            ),
          ),



          const SizedBox(height: 24),



          Text(
            'GitHub Token',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _tokenController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Enter your GitHub Personal Access Token',
              hintText: 'github_XXXXXXXXXXXXXXXXXXXX',
              suffixIcon: IconButton(
                icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
            obscureText: _obscureText,
            enableSuggestions: false,
            autocorrect: false,
          ),



          const SizedBox(height: 12),



          ElevatedButton(
            onPressed: () async {
              final token = _tokenController.text.trim();
              final username = _usernameController.text.trim();
              final repo = _repoController.text.trim();



              if (token.isEmpty || username.isEmpty || repo.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill in all fields before saving.')),
                );
                return;
              }



              await widget.api.saveGitHubToken(token);
              await widget.api.saveGitHubUsername(username);
              await widget.api.saveGitHubRepo(repo);



              setState(() {
                _tokenSaved = true;
                _usernameSaved = true;
                _repoSaved = true;
              });



              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sync Information saved successfully!')),
              );
            },
            child: Text(_tokenSaved && _usernameSaved && _repoSaved ? 'Update Sync Information' : 'Save Sync Information'),
          ),



          const SizedBox(height: 8),



          if (_tokenSaved || _usernameSaved || _repoSaved)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () async {
                await widget.api.deleteGitHubToken();
                await widget.api.deleteGitHubUsername();
                await widget.api.deleteGitHubRepo();



                _tokenController.clear();
                _usernameController.clear();
                _repoController.clear();



                setState(() {
                  _tokenSaved = false;
                  _usernameSaved = false;
                  _repoSaved = false;
                });



                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All GitHub Sync Information Deleted Successfully.')),
                );
              },
              child: const Text('Delete All Sync Information'),
            ),
        ],
      ),
    );
  }
}
