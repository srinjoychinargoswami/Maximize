import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maximize/models/database.dart';
import 'package:maximize/screens/calendar_page.dart';
import 'package:maximize/screens/task_list_screen.dart';
import 'package:maximize/screens/reminder_page.dart';
import 'package:maximize/services/calendar_service.dart';
import 'package:maximize/models/task_model.dart';
import 'package:maximize/models/event_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:maximize/services/reminder_service.dart'; // <-- where NotificationService is
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';


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
/* OVERVIEW PAGE – unchanged except imports                                  */
/* ────────────────────────────────────────────────────────────────────────── */

class OverviewPage extends StatefulWidget {
  final AppDatabase database;
  const OverviewPage({super.key, required this.database});
  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  List<String> completedTaskIds = [];
  List<String> completedEventIds = [];
  List<String> completedReminderIds = [];
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    completedTaskIds = _prefs?.getStringList('completedTasks') ?? [];
    completedEventIds = _prefs?.getStringList('completedEvents') ?? [];
    completedReminderIds = _prefs?.getStringList('completedReminders') ?? [];
    setState(() {}); // refresh UI after loading
  }

  void _toggleId(List<String> list, String id, String key) {
    setState(() {
      list.contains(id) ? list.remove(id) : list.add(id);
      _prefs?.setStringList(key, list);
    });
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('MM/dd/yyyy').format(DateTime.now());

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Tasks'),
          _taskSection(today),
          _sectionHeader('Calendar Events'),
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
    child: Text(text, style: Theme.of(context).textTheme.titleMedium),
  );

  /* ---------- TASKS ---------- */
  SizedBox _taskSection(String today) {
    return SizedBox(
      height: 250,
      child: FutureBuilder<List<TaskData>>(
        future: widget.database.getAllTasks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final tasks = snapshot.data!;
          final filtered = tasks.where((t) =>
            t.priority == 'High' || DateFormat('MM/dd/yyyy').format(t.dueDate) == today
          ).toList();

          if (filtered.isEmpty) return const Center(child: Text('No tasks.'));

          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (_, i) {
              final t = filtered[i];
              final checked = completedTaskIds.contains(t.id);
              return Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(t.name),
                      subtitle: Text(DateFormat('MM/dd/yyyy').format(t.dueDate)),
                      trailing: Checkbox(
                        value: checked,
                        onChanged: (_) => _toggleId(completedTaskIds, t.id, 'completedTasks'),
                      ),
                    ),
                    FutureBuilder<List<SubtaskModel>>(
                      future: widget.database.getAllSubtasks(t.id),
                      builder: (_, subSnap) {
                        if (!subSnap.hasData || subSnap.data!.isEmpty) return const SizedBox.shrink();
                        final subs = subSnap.data!;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: subs.length,
                          itemBuilder: (_, j) {
                            final s = subs[j];
                            final subChecked = completedTaskIds.contains(s.id);
                            return ListTile(
                              title: Text(s.title),
                              trailing: Checkbox(
                                value: subChecked,
                                onChanged: (_) => _toggleId(completedTaskIds, s.id, 'completedTasks'),
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
    );
  }

  /* ---------- EVENTS ---------- */
  SizedBox _eventSection(String today) {
    return SizedBox(
      height: 200,
      child: FutureBuilder<List<Event>>(
        future: CalendarService(widget.database).getEvents(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final events = snapshot.data!
              .where((e) => DateFormat('MM/dd/yyyy').format(e.startDateTime) == today)
              .toList();

          if (events.isEmpty) return const Center(child: Text('No events.'));

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (_, i) {
              final e = events[i];
              final checked = completedEventIds.contains(e.id);
              return Card(
                child: ListTile(
                  title: Text(e.title),
                  subtitle: Text(
                    '${DateFormat('MM/dd/yyyy').format(e.startDateTime)} '
                    '${DateFormat('hh:mm a').format(e.startDateTime)} '
                    '– ${DateFormat('hh:mm a').format(e.endDateTime)}',
                  ),
                  trailing: Checkbox(
                    value: checked,
                    onChanged: (_) => _toggleId(completedEventIds, e.id, 'completedEvents'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /* ---------- REMINDERS ---------- */
  SizedBox _reminderSection(String today) {
    return SizedBox(
      height: 200,
      child: FutureBuilder<List<ReminderData>>(
        future: widget.database.getAllReminders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final reminders = snapshot.data!
              .where((r) => DateFormat('MM/dd/yyyy').format(r.scheduledTime) == today)
              .toList();

          if (reminders.isEmpty) return const Center(child: Text('No reminders today.'));

          return ListView.builder(
            itemCount: reminders.length,
            itemBuilder: (_, i) {
              final r = reminders[i];
              final checked = completedReminderIds.contains(r.id);
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.alarm, color: Colors.orange),
                  title: Text(r.title),
                  subtitle: Text('Scheduled: ${DateFormat('hh:mm a').format(r.scheduledTime)}'),
                  trailing: Checkbox(
                    value: checked,
                    onChanged: (_) => _toggleId(completedReminderIds, r.id, 'completedReminders'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
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