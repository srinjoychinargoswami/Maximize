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

  // Recurring task fields
  bool _isRecurring = false;
  String _recurrenceRule = 'daily';
  int _recurrenceInterval = 1;
  List<int> _selectedDaysOfWeek = [];
  DateTime? _recurrenceEndDate;
  int? _maxOccurrences;
  bool _skipWeekends = false;
  int? _dayOfMonth;
  int? _weekOfMonth;

  final List<String> _recurrenceOptions = ['daily', 'weekly', 'monthly', 'yearly'];
  final List<String> _weekDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

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
      
      // Initialize recurring fields
      _isRecurring = widget.task!.isRecurring ?? false;
      _recurrenceRule = widget.task!.recurrenceRule ?? 'daily';
      _recurrenceInterval = widget.task!.recurrenceInterval ?? 1;
      _selectedDaysOfWeek = widget.task!.daysOfWeek?.split(',').map((e) => int.tryParse(e.trim())).where((e) => e != null).cast<int>().toList() ?? [];
      _recurrenceEndDate = widget.task!.recurrenceEndDate;
      _maxOccurrences = widget.task!.maxOccurrences;
      _skipWeekends = widget.task!.skipWeekends ?? false;
      _dayOfMonth = widget.task!.dayOfMonth;
      _weekOfMonth = widget.task!.weekOfMonth;
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
          child: SingleChildScrollView(
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
                const SizedBox(height: 16),
                _buildRecurringSection(),
                const SizedBox(height: 16),
                _buildSubtaskField(), // New method to add subtasks
                const SizedBox(height: 24),
                _buildSubmitButton(),
              ],
            ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: label),
        validator: validator,
        onSaved: onSaved,
        initialValue: initialValue,
      ),
    );
  }

  Widget _buildCategoriesField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Categories:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
      ),
    );
  }

  Widget _buildPriorityDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          const Text('Priority:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
      ),
    );
  }

  Widget _buildDueDateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: const InputDecoration(
          labelText: 'Due Date',
          suffixIcon: Icon(Icons.calendar_today),
        ),
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
        controller: TextEditingController(text: DateFormat('yyyy-MM-dd').format(_dueDate)),
      ),
    );
  }

  Widget _buildRecurringSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Recurring Task', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              subtitle: const Text('Make this task repeat automatically'),
              value: _isRecurring,
              onChanged: (value) {
                setState(() {
                  _isRecurring = value;
                });
              },
            ),
            if (_isRecurring) ...[
              const Divider(),
              _buildRecurrenceRuleDropdown(),
              const SizedBox(height: 16),
              _buildRecurrenceIntervalField(),
              const SizedBox(height: 16),
              if (_recurrenceRule == 'weekly') _buildWeeklyOptions(),
              if (_recurrenceRule == 'monthly') _buildMonthlyOptions(),
              if (_recurrenceRule == 'daily') _buildDailyOptions(),
              const SizedBox(height: 16),
              _buildRecurrenceEndOptions(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRecurrenceRuleDropdown() {
    return Row(
      children: [
        const Text('Repeat:', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(width: 16),
        Expanded(
          child: DropdownButton<String>(
            value: _recurrenceRule,
            onChanged: (String? newValue) {
              setState(() {
                _recurrenceRule = newValue ?? 'daily';
                _selectedDaysOfWeek.clear(); // Clear previous selections
              });
            },
            items: _recurrenceOptions.map((String rule) {
              return DropdownMenuItem<String>(
                value: rule,
                child: Text(rule.toUpperCase()),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRecurrenceIntervalField() {
    return Row(
      children: [
        const Text('Every:', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(width: 16),
        SizedBox(
          width: 80,
          child: TextFormField(
            initialValue: _recurrenceInterval.toString(),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
            onChanged: (value) {
              _recurrenceInterval = int.tryParse(value) ?? 1;
            },
          ),
        ),
        const SizedBox(width: 8),
        Text(_getIntervalLabel()),
      ],
    );
  }

  String _getIntervalLabel() {
    switch (_recurrenceRule) {
      case 'daily':
        return _recurrenceInterval == 1 ? 'day' : 'days';
      case 'weekly':
        return _recurrenceInterval == 1 ? 'week' : 'weeks';
      case 'monthly':
        return _recurrenceInterval == 1 ? 'month' : 'months';
      case 'yearly':
        return _recurrenceInterval == 1 ? 'year' : 'years';
      default:
        return 'period';
    }
  }

  Widget _buildWeeklyOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('On these days:', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          children: List.generate(7, (index) {
            final dayIndex = index + 1; // 1 = Monday, 7 = Sunday
            final isSelected = _selectedDaysOfWeek.contains(dayIndex);
            return FilterChip(
              label: Text(_weekDays[index]),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedDaysOfWeek.add(dayIndex);
                  } else {
                    _selectedDaysOfWeek.remove(dayIndex);
                  }
                });
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildMonthlyOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Monthly Options:', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('On day:'),
            const SizedBox(width: 16),
            SizedBox(
              width: 80,
              child: TextFormField(
                initialValue: _dayOfMonth?.toString() ?? _dueDate.day.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
                onChanged: (value) {
                  _dayOfMonth = int.tryParse(value);
                },
              ),
            ),
            const SizedBox(width: 8),
            const Text('of each month'),
          ],
        ),
      ],
    );
  }

  Widget _buildDailyOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: const Text('Skip Weekends'),
          subtitle: const Text('Don\'t create tasks on Saturday and Sunday'),
          value: _skipWeekends,
          onChanged: (value) {
            setState(() {
              _skipWeekends = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildRecurrenceEndOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('End Recurrence:', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'End Date (Optional)',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _recurrenceEndDate ?? DateTime.now().add(const Duration(days: 30)),
                    firstDate: _dueDate,
                    lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _recurrenceEndDate = pickedDate;
                    });
                  }
                },
                controller: TextEditingController(
                  text: _recurrenceEndDate != null 
                      ? DateFormat('yyyy-MM-dd').format(_recurrenceEndDate!)
                      : '',
                ),
              ),
            ),
            const SizedBox(width: 16),
            if (_recurrenceEndDate != null)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _recurrenceEndDate = null;
                  });
                },
              ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('Or limit to:'),
            const SizedBox(width: 16),
            SizedBox(
              width: 80,
              child: TextFormField(
                initialValue: _maxOccurrences?.toString() ?? '',
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  hintText: 'Max',
                ),
                onChanged: (value) {
                  _maxOccurrences = int.tryParse(value);
                },
              ),
            ),
            const SizedBox(width: 8),
            const Text('occurrences'),
          ],
        ),
      ],
    );
  }

  // New method to build the subtask input field
  Widget _buildSubtaskField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Subtasks:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            
            // Validate recurring task settings
            if (_isRecurring) {
              if (_recurrenceRule == 'weekly' && _selectedDaysOfWeek.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select at least one day for weekly recurrence')),
                );
                return;
              }
            }
            
            try {
              final taskModel = TaskModel(
                id: widget.task?.id ?? const Uuid().v1(),
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
                // Recurring fields
                isRecurring: _isRecurring,
                recurrenceRule: _isRecurring ? _recurrenceRule : null,
                recurrenceInterval: _isRecurring ? _recurrenceInterval : null,
                daysOfWeek: _isRecurring && _selectedDaysOfWeek.isNotEmpty ? _selectedDaysOfWeek : null,
                recurrenceEndDate: _isRecurring ? _recurrenceEndDate : null,
                parentTaskId: null, // This will be set for recurring instances
                maxOccurrences: _isRecurring ? _maxOccurrences : null,
                skipWeekends: _isRecurring ? _skipWeekends : false,
                dayOfMonth: _isRecurring && _recurrenceRule == 'monthly' ? _dayOfMonth : null,
                weekOfMonth: _weekOfMonth,
              );

              if (widget.task != null) {
                // Update existing task
                await AppDatabase.instance.updateTask(taskModel);
              } else {
                // Create new task
                await AppDatabase.instance.insertTask(taskModel);
              }

              // Save subtasks
              for (var subtask in _subtasks) {
                subtask.taskId = taskModel.id; // Set the taskId for each subtask
                await AppDatabase.instance.insertSubtask(subtask);
              }

              Navigator.pop(context, taskModel);
            } catch (e) {
              print('Error saving task: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error saving task: $e')),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          widget.task != null ? 'Update Task' : 'Save Task',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
