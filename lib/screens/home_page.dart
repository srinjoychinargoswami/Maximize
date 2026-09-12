import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kinetic/screens/calendar_page.dart';
import 'package:kinetic/screens/about_page.dart';
import 'package:kinetic/screens/task_list_screen.dart';
import 'package:kinetic/screens/search_page.dart';
import 'package:kinetic/screens/reminder_page.dart';
import 'package:kinetic/screens/notes_page.dart';
import 'package:kinetic/screens/energy_page.dart';
import 'package:kinetic/screens/energy_insights_page.dart';
import 'package:kinetic/screens/settings_page.dart';
import 'package:kinetic/services/calendar_service.dart';
import 'package:kinetic/services/task_service.dart';
import 'package:kinetic/services/reminder_service.dart';
import 'package:kinetic/services/note_service.dart';
import 'package:kinetic/services/energy_service.dart';
import 'package:kinetic/services/completion_log_service.dart';
import 'package:kinetic/services/metrics_service.dart';
import 'package:kinetic/database/app_database.dart' as db;
import 'package:kinetic/models/task_model.dart';
import 'package:kinetic/models/subtask_model.dart';
import 'package:kinetic/models/event_model.dart' as event_model;
import 'package:kinetic/models/reminder_model.dart';
import 'package:kinetic/models/energy_model.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';

/* HOME PAGE – Drawer, Bottom Nav, and IndexedStack */

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  // ADDED: Keys to access refresh methods in child pages
  final GlobalKey<_OverviewPageState> _overviewKey = GlobalKey<_OverviewPageState>();
  final GlobalKey<TaskListScreenState> _tasksKey = GlobalKey<TaskListScreenState>();
  final GlobalKey<CalendarPageState> _calendarKey = GlobalKey<CalendarPageState>();
  final GlobalKey<NotesPageState> _notesKey = GlobalKey<NotesPageState>();
  final GlobalKey<ReminderPageState> _remindersKey = GlobalKey<ReminderPageState>();

  void _navigateToSearch() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const SearchPage(),
    ),
  ).then((result) {
    if (result == null || result is! Map<String, dynamic>) return;

    final type = result['type'] as String;
    final id = result['id'] as String;
    final title = result['title'] as String;

    switch (type) {
      case 'task':
        _jumpTo(1);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Showing task: $title')),
        );
        Future.delayed(const Duration(milliseconds: 300), () {
          _tasksKey.currentState?.scrollToItem(id);
        });
        break;

      case 'event':
        _jumpTo(2);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Showing event: $title')),
        );
        Future.delayed(const Duration(milliseconds: 300), () {
          _calendarKey.currentState?.scrollToItem(id);
        });
        break;

      case 'note':
        _jumpTo(3);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Showing note: $title')),
        );
        Future.delayed(const Duration(milliseconds: 300), () {
          _notesKey.currentState?.scrollToItem(id);
        });
        break;

      case 'reminder':
        _jumpTo(4);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Showing reminder: $title')),
        );
        Future.delayed(const Duration(milliseconds: 300), () {
          _remindersKey.currentState?.scrollToItem(id);
        });
        break;
    }
  });
}

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Initialize screens with keys - services are provided via Provider
    final database = context.read<db.AppDatabase>();
    final calendarService = context.read<CalendarService>();
    final noteService = context.read<NoteService>();
    _screens = [
      OverviewPage(key: _overviewKey),
      TaskListScreen(key: _tasksKey, database: database),
      CalendarPage(key: _calendarKey, calendarService: calendarService),
      NotesPage(key: _notesKey, noteService: noteService),
      ReminderPage(key: _remindersKey, database: database),
      EnergyInsightsPage(database: database),
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
        case 5: // Energy
          // Energy page refresh is handled internally
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
        title: const Text('Kinetic'),
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
              child: Text('Kinetic', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            _drawerTile(title: 'Home', icon: Icons.home, index: 0),
            _drawerTile(title: 'Tasks', icon: Icons.list, index: 1),
            _drawerTile(title: 'Calendar', icon: Icons.calendar_today, index: 2),
            _drawerTile(title: 'Notes', icon: Icons.note, index: 3),
            _drawerTile(title: 'Reminders', icon: Icons.notifications, index: 4),
            _drawerTile(title: 'Energy', icon: Icons.energy_savings_leaf, index: 5),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
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
          BottomNavigationBarItem(icon: Icon(Icons.energy_savings_leaf), label: 'Energy'),
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
        } else if (index == 6) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AboutPage()),
          );
        }
      },
    );
  }
}

/* OVERVIEW PAGE */

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});
  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  late final TaskService _taskService;
  late final CalendarService _calendarService;
  late final ReminderService _reminderService;
  late final EnergyService _energyService;

  @override
  void initState() {
    super.initState();
    _taskService = context.read<TaskService>();
    _calendarService = context.read<CalendarService>();
    _reminderService = context.read<ReminderService>();
    _energyService = context.read<EnergyService>();
  }

  // UPDATED: Made public so parent can call it
  Future<void> _refreshData() async {
    setState(() {}); // This triggers all FutureBuilders to rebuild with fresh futures
    // Add a small delay to ensure database is updated
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() {});
    }
  }

  Widget _statsSection() {
    final metricsService = context.read<MetricsService>();

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          // Top row: Total Done, This Week, Streak
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: FutureBuilder<int>(
                    future: metricsService.getTotalDone(),
                    builder: (context, snapshot) {
                      return _metricCard('Total Done', snapshot.data?.toString() ?? '0', Icons.check_circle, Colors.green);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FutureBuilder<int>(
                    future: metricsService.getThisWeekDone(),
                    builder: (context, snapshot) {
                      return _metricCard('This Week', snapshot.data?.toString() ?? '0', Icons.calendar_today, Colors.blue);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FutureBuilder<int>(
                    future: metricsService.getStreak(),
                    builder: (context, snapshot) {
                      return _metricCard('Streak', snapshot.data?.toString() ?? '0', Icons.local_fire_department, Colors.orange);
                    },
                  ),
                ),
              ],
            ),
          ),

          // Task Status Breakdown Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: FutureBuilder<int>(
              future: metricsService.getTotalTasks(),
              builder: (context, snapshot1) {
                int total = snapshot1.data ?? 0;

                return FutureBuilder<int>(
                  future: metricsService.getCompletedTasks(),
                  builder: (context, snapshot2) {
                    int completed = snapshot2.data ?? 0;
                    int uncompleted = total - completed;
                    double completedPercent = total == 0 ? 0 : (completed / total) * 100;
                    double uncompletedPercent = total == 0 ? 0 : (uncompleted / total) * 100;

                    return Card(
                      color: Colors.grey[800],
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Task Status", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text("$completed/$total", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                                    Text("${completedPercent.toStringAsFixed(1)}%", style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                                    Text("Completed", style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text("$uncompleted/$total", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
                                    Text("${uncompletedPercent.toStringAsFixed(1)}%", style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                                    Text("Uncompleted", style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Peak Completion Hint Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: FutureBuilder<String>(
              future: metricsService.getPeakCompletionWindow(),
              builder: (context, snapshot) {
                final peakWindow = snapshot.data;
                if (peakWindow == null || peakWindow.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Card(
                  color: Colors.amber.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const Icon(Icons.lightbulb, color: Colors.amber),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "💡 Peak completions: $peakWindow",
                            style: const TextStyle(fontSize: 14, color: Colors.white),
                          ),
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
    );
  }

  Widget _metricCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
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
              _statsSection(),
              _EnergyStatusWidget(
                energyService: _energyService,
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
      child: FutureBuilder<List<event_model.Event>>(
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
      // Refresh the entire page to update tasks and metrics
      await _refreshData();
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
        final subtask = await _taskService.getSubtaskById(subtaskId);
        if (subtask == null) return;
        final updatedSubtask = subtask.copyWith(completed: false, completedAt: null);
        await _taskService.updateSubtask(updatedSubtask);
      }
      // Refresh the entire page to update tasks and metrics
      await _refreshData();
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

/* ENERGY STATUS WIDGET */

class _EnergyStatusWidget extends StatefulWidget {
  final EnergyService energyService;

  const _EnergyStatusWidget({
    required this.energyService,
  });

  @override
  State<_EnergyStatusWidget> createState() => _EnergyStatusWidgetState();
}

class _EnergyStatusWidgetState extends State<_EnergyStatusWidget> {
  EnergyEntryModel? _todaysEntry;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTodaysEntry();
  }

  Future<void> _loadTodaysEntry() async {
    try {
      final entry = await widget.energyService.getTodaysEntry();
      if (mounted) {
        setState(() {
          _todaysEntry = entry;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _openEnergyPage() async {
    final database = context.read<db.AppDatabase>();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EnergyPage(database: database),
      ),
    );

    // Refresh on return
    if (result == true || mounted) {
      await _loadTodaysEntry();
    }
  }

  String _getEnergyEmoji(int level) {
    if (level <= 3) return '🔴';
    if (level <= 6) return '🟡';
    return '🟢';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Card(
        color: Colors.grey[800],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Energy Status',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _openEnergyPage,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(_todaysEntry != null ? 'Update' : 'Log'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      backgroundColor: Colors.blue[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_isLoading)
                const SizedBox(
                  height: 60,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_todaysEntry != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Energy Level Display
                    Row(
                      children: [
                        Text(
                          _getEnergyEmoji(_todaysEntry!.energyLevel),
                          style: const TextStyle(fontSize: 28),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Energy: ${_todaysEntry!.energyLevel}/10',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Logged at ${DateFormat('h:mm a').format(_todaysEntry!.timestamp)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Quick Stats
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          _statRow('Mood', _todaysEntry!.moodTags.first),
                          const SizedBox(height: 8),
                          _statRow('Location', _todaysEntry!.location),
                          const SizedBox(height: 8),
                          _statRow('Context', _todaysEntry!.privacyContext),
                        ],
                      ),
                    ),

                    // Notes if present
                    if (_todaysEntry!.notes != null &&
                        _todaysEntry!.notes!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[900]?.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.blue[700]!.withOpacity(0.5),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Notes',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[400],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _todaysEntry!.notes!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[300],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Not logged yet today',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the button above to log your energy level',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[400],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

// CustomScrollBehavior to fix RefreshIndicator on Windows desktop
class CustomScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}