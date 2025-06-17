import 'package:flutter/material.dart';
import 'package:maximize/models/task_model.dart';
import 'package:intl/intl.dart';

class TaskWidget extends StatefulWidget {
  final TaskModel task;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final ValueChanged<bool?>? onToggleComplete; // Add this line

  const TaskWidget({
    super.key,
    required this.task,
    this.onDelete,
    this.onEdit,
    this.onToggleComplete, // Add this line
  });

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  late bool _completed;

  @override
  void initState() {
    super.initState();
    _completed = widget.task.completed;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Theme.of(context).scaffoldBackgroundColor, // Set the background color to match the rest of the screen
      child: Column(
        children: [
          ListTile(
            title: Text(widget.task.title),
            subtitle: Text(widget.task.description ?? ''), // Use null coalescing operator
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: _completed,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _completed = value;
                      });
                      // Call the onToggleComplete callback to notify the parent
                      if (widget.onToggleComplete != null) {
                        widget.onToggleComplete!(value);
                      }
                    }
                  },
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: widget.onDelete,
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: widget.onEdit,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Category: '),
                    Text(
                      widget.task.category ?? 'Unknown', // Use null coalescing operator
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Priority: '),
                    Text(
                      widget.task.priority,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Due Date: '),
                    Text(
                      DateFormat('yyyy-MM-dd').format(widget.task.dueDate),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MiniTaskWidget extends StatelessWidget {
  final TaskModel task;

  const MiniTaskWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.title),
      subtitle: Text(task.description ?? ''), // Use null coalescing operator
    );
  }
}