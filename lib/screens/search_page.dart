import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/database.dart'; // Your Drift DB
import 'package:maximize/models/task_model.dart';
import 'package:maximize/models/event_model.dart';
import 'package:maximize/models/note_model.dart';
import 'package:maximize/models/reminder_model.dart';



class SearchPage extends StatefulWidget {
  final AppDatabase database;
  const SearchPage({Key? key, required this.database}) : super(key: key);

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  String query = '';
  bool isSearching = false;
  List<TaskData> matchedTasks = [];
  List<EventData> matchedEvents = [];
  List<NoteModel> matchedNotes = []; // Adjust if no notes yet
  List<ReminderData> matchedReminders = [];
  

  Future<void> _performSearch(String q) async {
  if (q.length < 2) {
    setState(() {
      matchedTasks.clear();
      matchedEvents.clear();
      matchedNotes.clear();
      matchedReminders.clear();  // FIXED: Clear all
    });
    return;
  }

    setState(() => isSearching = true);

    try {
      // Query ALL databases simultaneously
      final futures = await Future.wait([
        widget.database.getAllTasks(),
        widget.database.getAllEvents(),
        widget.database.getAllReminders(),

        // widget.database.getAllNotes(), // Uncomment when ready
      ]);

      final tasks = futures[0] as List<TaskData>;
      final events = futures[1] as List<EventData>;
      final reminders = futures[2] as List<ReminderData>;
      // final notes = futures[2] as List<NoteData>;

      final lowerQuery = q.toLowerCase();

      setState(() {
        matchedTasks = tasks.where((task) =>
            task.title.toLowerCase().contains(lowerQuery) ||
            (task.description?.toLowerCase().contains(lowerQuery) ?? false)
        ).toList();

        matchedEvents = events.where((event) =>
            event.title.toLowerCase().contains(lowerQuery) ||
            (event.description?.toLowerCase().contains(lowerQuery) ?? false)
        ).toList();

        // In setState filtering (after matchedEvents):
matchedReminders = reminders.where((reminder) =>
  reminder.title.toLowerCase().contains(lowerQuery) ||
  (reminder.body?.toLowerCase().contains(lowerQuery) ?? false)  // Adjust 'body' if your field is different
).toList();  // ADD THIS

        // matchedNotes = notes.where((note) =>
        //     note.title.toLowerCase().contains(lowerQuery) ||
        //     note.content.toLowerCase().contains(lowerQuery)
        // ).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Search error: $e')),
      );
    } finally {
      setState(() => isSearching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search tasks, events, notes...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
            suffixIcon: query.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        query = '';
                        matchedTasks.clear();
                        matchedEvents.clear();
                        matchedNotes.clear();
                      });
                    },
                  )
                : null,
          ),
          onChanged: (value) {
            query = value;
            _performSearch(value);
          },
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: isSearching
          ? Center(child: CircularProgressIndicator())
          : query.isEmpty
              ? _emptyState()
              : _buildResults(),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text('Search tasks, events, and notes', 
               style: TextStyle(fontSize: 18, color: Colors.grey)),
          Text('Type 2+ characters to start', 
               style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildResults() {
    return ListView(
      children: [
        if (matchedTasks.isNotEmpty) ...[
          _sectionHeader('Tasks (${matchedTasks.length})'),
          ...matchedTasks.map((task) => _buildTaskTile(task)).toList(),
        ],
        if (matchedEvents.isNotEmpty) ...[
          _sectionHeader('Events (${matchedEvents.length})'),
          ...matchedEvents.map((event) => _buildEventTile(event)).toList(),
        ],

        if (matchedReminders.isNotEmpty) ...[  // ADD THIS WHOLE BLOCK
  _sectionHeader('Reminders (${matchedReminders.length})'),
  ...matchedReminders.map((reminder) => _buildReminderTile(reminder)).toList(),
],

        // if (matchedNotes.isNotEmpty) ...[
        //   _sectionHeader('Notes (${matchedNotes.length})'),
        //   ...matchedNotes.map((note) => _buildNoteTile(note)).toList(),
        // ],
        if (query.isNotEmpty && 
            matchedTasks.isEmpty && 
            matchedEvents.isEmpty &&
            matchedReminders.isEmpty /*&& matchedNotes.isEmpty*/)
          _noResults(),
      ],
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(title, style: TextStyle(
        fontWeight: FontWeight.bold, 
        fontSize: 16, 
        color: Theme.of(context).primaryColor
      )),
    );
  }

  Widget _buildTaskTile(TaskData task) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Icon(Icons.task, color: Colors.white),
      ),
      title: Text(task.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (task.description?.isNotEmpty ?? false)
            Text(task.description!, maxLines: 1, overflow: TextOverflow.ellipsis),
          Text('Due: ${DateFormat('MMM dd').format(task.dueDate)}'),
        ],
      ),
      onTap: () {
        // Navigate to task detail/edit
        Navigator.pop(context);
        // Your task navigation logic
      },
    );
  }

  Widget _buildEventTile(EventData event) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.green,
        child: Icon(Icons.event, color: Colors.white),
      ),
      title: Text(event.title),
      subtitle: Text('${DateFormat('MMM dd').format(event.startDateTime)} • '
                     '${DateFormat('h:mm a').format(event.startDateTime)}'),
      onTap: () {
        // Navigate to event detail/edit
        Navigator.pop(context);
      },
    );
  }


Widget _buildReminderTile(ReminderData reminder) {  // ADD THIS
  return ListTile(
    leading: CircleAvatar(
      backgroundColor: Colors.orange,
      child: Icon(Icons.alarm, color: Colors.white),
    ),
    title: Text(reminder.title),
    subtitle: Text('Time: ${DateFormat('MMM dd, h:mm a').format(reminder.scheduledTime ?? DateTime.now())}'),
    onTap: () => Navigator.pop(context),  // TODO: Navigate to Reminders page
  );
}

  Widget _noResults() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No results for "$query"'),
            Text('Try different keywords'),
          ],
        ),
      ),
    );
  }
}