import 'package:flutter/material.dart';
import 'package:maximize/services/task_service.dart';
import 'package:maximize/models/task_model.dart';
import 'package:maximize/widgets/task_widget.dart';
import 'package:provider/provider.dart';

class MiniTaskList extends StatefulWidget {
  const MiniTaskList({super.key});

  @override
  _MiniTaskListState createState() => _MiniTaskListState();
}

class _MiniTaskListState extends State<MiniTaskList> {
  List<TaskModel> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final taskService = Provider.of<TaskService>(context, listen: false);
    final tasks = await taskService.getTasks();
    if (mounted) {
      setState(() {
        _tasks = tasks.take(5).toList();
      });
    }
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
