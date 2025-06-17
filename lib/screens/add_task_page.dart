import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maximize/models/database.dart'; // Import your Drift database file
import 'package:maximize/utils/task_utils.dart';
import 'package:uuid/uuid.dart';
import 'package:maximize/models/task_model.dart';

class AddTaskPage extends StatefulWidget {
  final TaskData? task; // Use the Drift Task class
  const AddTaskPage({super.key, this.task});

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  String _taskName = '';
  String _taskTitle = '';
  String _taskDescription = '';
  DateTime _dueDate = DateTime.now();
  bool _completed = false;
  List<String> _categories = [];
  String _selectedPriority = 'Low';
  final List<String> _priorities = ['Low', 'Medium', 'High'];
  String _newCategory = '';

  // Subtask management
  final List<SubtaskModel> _subtasks = []; // List to hold subtasks
  final TextEditingController _subtaskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _taskName = widget.task!.name;
      _taskTitle = widget.task!.title;
      _taskDescription = widget.task!.description ?? '';
      _dueDate = widget.task!.dueDate;
      _completed = widget.task!.completed;
      _selectedPriority = widget.task!.priority;
      _categories = widget.task!.category?.split(', ') ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task != null ? 'Edit Task' : 'Add Task'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildTextField(
                label: 'Task Name',
                onSaved: (value) => _taskName = value!,
                initialValue: _taskName,
                validator: (value) => value == null || value.isEmpty ? 'Please enter a task name' : null,
              ),
              _buildTextField(
                label: 'Task Title',
                onSaved: (value) => _taskTitle = value!,
                initialValue: _taskTitle,
                validator: (value) => value == null || value.isEmpty ? 'Please enter a task title' : null,
              ),
              _buildTextField(
                label: 'Task Description',
                onSaved: (value) => _taskDescription = value!,
                initialValue: _taskDescription,
                validator: (value) => value == null || value.isEmpty ? 'Please enter a task description' : null,
              ),
              _buildCategoriesField(),
              _buildPriorityDropdown(),
              _buildDueDateField(),
              _buildSubtaskField(), // New method to add subtasks
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required FormFieldSetter<String> onSaved,
    required String initialValue,
    required FormFieldValidator<String> validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      validator: validator,
      onSaved: onSaved,
      initialValue: initialValue,
    );
  }

  Widget _buildCategoriesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Categories:'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          children: _categories.map((category) {
            return Chip(
              label: Text(category),
              onDeleted: () {
                setState(() {
                  _categories.remove(category);
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) {
                  _newCategory = value;
                },
                decoration: const InputDecoration(hintText: 'Enter new category'),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                if (_newCategory.isNotEmpty) {
                  setState(() {
                    _categories.add(_newCategory);
                    _newCategory = '';
                  });
                }
              },
              child: const Text('Add Category'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriorityDropdown() {
    return Row(
      children: [
        const Text('Priority:'),
        const SizedBox(width: 16),
        Expanded(
          child: DropdownButton<String>(
            value: _selectedPriority,
            onChanged: (String? newValue) {
              setState(() {
                _selectedPriority = newValue ?? 'Low';
              });
            },
            items: _priorities.map((String priority) {
              return DropdownMenuItem<String>(
                value: priority,
                child: Text(priority),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDueDateField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Due Date'),
      readOnly: true,
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: _dueDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2050),
        );
        if (pickedDate != null) {
          setState(() {
            _dueDate = pickedDate;
          });
        }
      },
      initialValue: DateFormat('yyyy-MM-dd').format(_dueDate),
    );
  }

  // New method to build the subtask input field
  Widget _buildSubtaskField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Subtasks:'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          children: _subtasks.map((subtask) {
            return Chip(
              label: Text(subtask.title),
              onDeleted: () {
                setState(() {
                  _subtasks.remove(subtask);
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _subtaskController,
                decoration: const InputDecoration(hintText: 'Enter new subtask'),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                if (_subtaskController.text.isNotEmpty) {
                  setState(() {
                    _subtasks.add(SubtaskModel(
                      id: const Uuid().v1(),
                      taskId: '', // This will be set when the task is saved
                      title: _subtaskController.text,
                      completed: false,
                    ));
                    _subtaskController.clear(); // Clear the input field
                  });
                }
              },
              child: const Text('Add Subtask'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          try {
            final task = TaskData(
              id: widget.task?.id ?? const Uuid().v1(), // Keep the existing ID if editing
              name: _taskName,
              title: _taskTitle,
              description: _taskDescription,
              dueDate: _dueDate,
              completed: _completed,
              category: _categories.join(', '),
              priority: _selectedPriority,
              customCategory: null,
              pageId: null,
              day: null,
            );

            final taskModel = convertTaskDataToModel(task);

            if (widget.task != null) {
              // Update existing task
              await AppDatabase.instance.updateTask(taskModel);
            } else {
              // Create new task
              await AppDatabase.instance.insertTask(taskModel);
            }

            // Save subtasks
            for (var subtask in _subtasks) {
              subtask.taskId = task.id; // Set the taskId for each subtask
              await AppDatabase.instance.insertSubtask(subtask);
            }

            Navigator.pop(context, task);
          } catch (e) {
            print('Error saving task: $e');
            // Optionally show a dialog or snackbar to inform the user
          }
        }
      },
      child: Text(widget.task != null ? 'Update Task' : 'Save Task'),
    );
  }
}