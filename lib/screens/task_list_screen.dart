import 'package:flutter/material.dart';
import 'package:maximize/models/task_model.dart';
import 'package:maximize/services/task_service.dart';
import 'package:maximize/widgets/task_widget.dart'; // Import the TaskWidget
import 'package:maximize/screens/add_task_page.dart'; // Import the AddTaskPage
import 'package:maximize/utils/task_utils.dart';
import 'package:maximize/models/database.dart'; // Import your Drift database file
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class TaskListScreen extends StatefulWidget {
  final AppDatabase database; // Add this line to accept the database

  const TaskListScreen({super.key, required this.database}); // Modify the constructor

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<TaskModel> _tasks = [];
  late final TaskService _taskService; // Declare TaskService
  bool _isLoading = true;

  // Filter variables
  String _selectedCategory = 'All';
  String _selectedPriority = 'All';
  DateTime? _selectedDueDate;

  @override
  void initState() {
    super.initState();
    _taskService = TaskService(widget.database); // Initialize TaskService with the database
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    _tasks = await _taskService.getTasks();
    await _loadTaskCompletionStatus(); // Load completion status
    _updateFilterOptions();
    setState(() => _isLoading = false);
  }

  Future<void> _loadTaskCompletionStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var task in _tasks) {
      bool isCompleted = prefs.getBool(task.id) ?? false; // Default to false
      task.completed = isCompleted; // Update task's completion status
    }
  }

  List<TaskModel> _filterTasks() {
    return _tasks.where((task) {
      final matchesCategory = _selectedCategory == 'All' || task.category == _selectedCategory;
      final matchesPriority = _selectedPriority == 'All' || task.priority == _selectedPriority;
      final matchesDueDate = _selectedDueDate == null || _isSameDate(task.dueDate, _selectedDueDate);
      return matchesCategory && matchesPriority && matchesDueDate;
    }).toList();
  }

  bool _isSameDate(DateTime? date1, DateTime? date2) {
    if (date1 == null || date2 == null) return false;
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _filterTasks();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
      ),
      body: Column(
        children: [
          _buildFilterOptions(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredTasks.isEmpty
                    ? const Center(child: Text('No tasks available'))
                    : ListView.builder(
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) {
                          final task = filteredTasks[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TaskWidget(
                                task: task,
                                onDelete: () => _deleteTask(task),
                                onEdit: () => _editTask(task),
                                onToggleComplete: (isCompleted) => _toggleTaskCompletion(task, isCompleted),
                              ),
                              // Fetch and display subtasks for the current task
                              FutureBuilder<List<SubtaskModel>>(
                                future: widget.database.getAllSubtasks(task.id), // Fetch subtasks
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Padding(
                                      padding: EdgeInsets.only(left: 16.0),
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 16.0),
                                      child: Text('Error fetching subtasks: ${snapshot.error}'),
                                    );
                                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                    return const Padding(
                                      padding: EdgeInsets.only(left: 16.0),
                                      child: Text('No subtasks available.'),
                                    );
                                  }

                                  final subtasks = snapshot.data!;
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Column(
                                      children: subtasks.map((subtask) {
                                        return ListTile(
                                          title: Text(subtask.title),
                                          trailing: Checkbox(
                                            value: subtask.completed,
                                            onChanged: (value) {
                                              // Handle completion toggle
                                              _toggleSubtaskCompletion(subtask, value);
                                            },
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addTask() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskPage()),
    ).then((value) {
      if (value != null) {
        // Reload tasks after adding a new task
        _loadTasks();
      }
    });
  }

  void _deleteTask(TaskModel task) {
    // Show a confirmation dialog before deleting
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Cancel
              child: const Text('Cancel '),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _taskService.deleteTask(task.id).then((_) {
                  // Reload tasks after deletion
                  _loadTasks();
                }).catchError((error) {
                  // Handle any errors that occur during deletion
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete task: $error')),
                  );
                });
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _editTask(TaskModel task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskPage(task: convertTaskModelToData(task)),
      ),
    ).then((value) {
      if (value != null) {
        // Reload tasks after editing
        _loadTasks();
      }
    });
  }

  void _toggleTaskCompletion(TaskModel task, bool? isCompleted) async {
    final updatedTask = task.copyWith(completed: isCompleted ?? false);
    await _taskService.updateTask(updatedTask).then((_) async {
      // Save the updated completion status in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(task.id, updatedTask.completed);
      // Reload tasks after updating
      _loadTasks();
    }).catchError((error) {
      // Handle any errors that occur during update
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update task: $error')),
      );
    });
  }

  void _toggleSubtaskCompletion(SubtaskModel subtask, bool? isCompleted) async {
    final updatedSubtask = subtask.copyWith(completed: isCompleted ?? false);
    await _taskService.updateSubtask(updatedSubtask).then((_) {
      // Reload tasks after updating
      _loadTasks();
    }).catchError((error) {
      // Handle any errors that occur during update
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update subtask: $error')),
      );
    });
  }

  void _updateFilterOptions() {
    final categories = _tasks.map((task) => task.customCategory ?? task.category).toSet().toList();
    categories.sort();
    if (!categories.contains('All')) categories.insert(0, 'All');

    setState(() {
      _selectedCategory = categories.isNotEmpty ? categories.first! : 'All'; // Update _selectedCategory
    });
  }

  Widget _buildFilterOptions() {
    final categories = _tasks.map((task) => task.customCategory ?? task.category).toSet().toList();
    categories.sort();
    if (!categories.contains('All')) categories.insert(0, 'All');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DropdownButton(
            value: _selectedCategory,
            onChanged: (value) {
              if (value != null && categories.contains(value)) {
                setState(() {
                  _selectedCategory = value;
                });
              }
            },
            items: categories.map((category) => DropdownMenuItem(
              value: category,
              child: Text(category ?? ''),
            )).toList(),
          ),
          DropdownButton(
            value: _selectedPriority,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedPriority = value;
                });
              }
            },
            items: ['All', 'Low', 'Medium', 'High'].map((priority) => DropdownMenuItem(
              value: priority,
              child: Text(priority),
            )).toList(),
          ),
          ElevatedButton(
            onPressed: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2022),
                lastDate: DateTime(2030),
              );

              if (pickedDate != null) {
                setState(() {
                  _selectedDueDate = pickedDate;
                });
              }
            },
            child: Text(_selectedDueDate == null ? 'Select Due Date' : 'Due Date: ${_selectedDueDate!.day}/${_selectedDueDate!.month}/${_selectedDueDate!.year}'),
          ),
        ],
      ),
    );
  }
}