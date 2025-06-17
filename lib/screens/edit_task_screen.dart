import 'package:flutter/material.dart';
import 'package:maximize/models/task_model.dart';
import 'package:maximize/services/task_service.dart'; // Import the task_service.dart file
import 'package:maximize/models/database.dart'; // Import your Drift database file
import 'package:uuid/uuid.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskModel task;
  final AppDatabase database; // Add a field to hold the database

  const EditTaskScreen({super.key, required this.task, required this.database}); // Modify the constructor

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _taskName;
  late String _taskDescription;
  late DateTime _dueDate;
  late bool _completed;
  late String _category; // Add category
  late String _priority; // Add priority
  late TaskService _taskService; // Declare TaskService
  final List<SubtaskModel> _subtasks = []; // List to hold subtasks
  final TextEditingController _subtaskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _taskName = widget.task.name; // Initialize task name
    _taskDescription = widget.task.description ?? '';
    _dueDate = widget.task.dueDate;
    _completed = widget.task.completed;
    _category = widget.task.category ?? ''; // Initialize category
    _priority = widget.task.priority; // Initialize priority
    _taskService = TaskService(widget.database); // Initialize TaskService with the database

    // Load existing subtasks
    _loadSubtasks();
  }

  Future<void> _loadSubtasks() async {
    final subtasks = await _taskService.getSubtasks(widget.task.id);
    setState(() {
      _subtasks.addAll(subtasks);
    });
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _taskName,
                decoration: const InputDecoration(
                  labelText: 'Task Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter task name';
                  }
                  return null;
                },
                onSaved: (value) => _taskName = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _taskDescription,
                decoration: const InputDecoration(
                  labelText: 'Task Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter task description';
                  }
                  return null;
                },
                onSaved: (value) => _taskDescription = value!,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Due Date: ${_dueDate.toLocal()}".split(' ')[0], // Display the date
                    style: const TextStyle(fontSize: 16),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDueDate(context),
                    child: const Text('Select Date'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _completed,
                    onChanged: (bool? value) {
                      setState(() {
                        _completed = value ?? false;
                      });
                    },
                  ),
                  const Text('Completed'),
                ],
              ),
              const SizedBox(height: 16),
              // Add fields for category and priority
              TextFormField(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => _category = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _priority,
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value ) => _priority = value!,
              ),
              const SizedBox(height: 16),
              // Subtask management section
              const Text('Subtasks:', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _subtasks.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_subtasks[index].title),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _subtasks.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              TextField(
                controller: _subtaskController,
                decoration: const InputDecoration(
                  hintText: 'Enter new subtask',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  if (_subtaskController.text.isNotEmpty) {
                    setState(() {
                      _subtasks.add(SubtaskModel(
                        id: const Uuid().v1(),
                        taskId: widget.task.id,
                        title: _subtaskController.text,
                        completed: false,
                      ));
                      _subtaskController.clear();
                    });
                  }
                },
                child: const Text('Add Subtask'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Create an updated TaskModel instance
                    final updatedTask = TaskModel(
                      id: widget.task.id, // Use the existing task ID
                      name: _taskName, // Pass name to updateTask
                      title: _taskName, // Use title instead of name
                      description: _taskDescription,
                      dueDate: _dueDate,
                      completed: _completed,
                      category: _category, // Pass category
                      priority: _priority, // Pass priority
                    );

                    // Call updateTask with the updated TaskModel
                    await _taskService.updateTask(updatedTask);
                    
                    // Update subtasks in the database
                    for (var subtask in _subtasks) {
                      await _taskService.updateSubtask(subtask);
                    }

                    // Navigate back with the updated task data
                    Navigator.pop(context, {
                      'id': widget.task.id,
                      'name': _taskName,
                      'title': _taskName,
                      'description': _taskDescription,
                      'dueDate': _dueDate,
                      'completed': _completed,
                      'category': _category,
                      'priority': _priority,
                    });
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}