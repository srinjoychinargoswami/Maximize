import 'package:flutter/material.dart';
import 'package:maximize/services/task_service.dart';
import 'package:maximize/models/task_model.dart';
import 'package:maximize/widgets/task_widget.dart';
import 'package:maximize/models/database.dart'; // Import your Drift database file

class MiniTaskList extends StatefulWidget {
  final AppDatabase database; // Add a field to hold the database

  const MiniTaskList({super.key, required this.database}); // Modify the constructor

  @override
  _MiniTaskListState createState() => _MiniTaskListState();
}

class _MiniTaskListState extends State<MiniTaskList> {
  List<TaskModel> _tasks = [];
  late final TaskService _taskService; // Declare TaskService

  @override
  void initState() {
    super.initState();
    _taskService = TaskService(widget.database); // Initialize TaskService with the database
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _taskService.getTasks();
    setState(() {
      _tasks = tasks.take(5).toList(); // Take the first 5 tasks
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Recent Tasks'),
        const SizedBox(height: 10),
        ..._tasks.map((task) => MiniTaskWidget(task: task)).toList(),
      ],
    );
  }
}