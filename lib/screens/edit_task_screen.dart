import 'package:flutter/material.dart';
import 'package:maximize/models/task_model.dart';
import 'package:maximize/services/task_service.dart'; // Import the task_service.dart file
import 'package:maximize/models/database.dart'; // Import your Drift database file
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

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

  // Recurring task fields
  late bool _isRecurring;
  late String _recurrenceRule;
  late int _recurrenceInterval;
  late List<int> _selectedDaysOfWeek;
  DateTime? _recurrenceEndDate;
  int? _maxOccurrences;
  late bool _skipWeekends;
  int? _dayOfMonth;
  int? _weekOfMonth;

  final List<String> _recurrenceOptions = ['daily', 'weekly', 'monthly', 'yearly'];
  final List<String> _weekDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

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

    // Initialize recurring fields
    _isRecurring = widget.task.isRecurring;
    _recurrenceRule = widget.task.recurrenceRule ?? 'daily';
    _recurrenceInterval = widget.task.recurrenceInterval ?? 1;
    _selectedDaysOfWeek = widget.task.daysOfWeek ?? [];
    _recurrenceEndDate = widget.task.recurrenceEndDate;
    _maxOccurrences = widget.task.maxOccurrences;
    _skipWeekends = widget.task.skipWeekends;
    _dayOfMonth = widget.task.dayOfMonth;
    _weekOfMonth = widget.task.weekOfMonth;

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

  Future<void> _selectRecurrenceEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _recurrenceEndDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: _dueDate,
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      setState(() {
        _recurrenceEndDate = picked;
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
          child: SingleChildScrollView(
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
                  onSaved: (value) => _priority = value!,
                ),
                const SizedBox(height: 16),
                
                // Recurring Task Section
                _buildRecurringSection(),
                
                const SizedBox(height: 16),
                // Subtask management section
                const Text('Subtasks:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
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
                const SizedBox(height: 24),
                SizedBox(
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
                          // Recurring fields
                          isRecurring: _isRecurring,
                          recurrenceRule: _isRecurring ? _recurrenceRule : null,
                          recurrenceInterval: _isRecurring ? _recurrenceInterval : null,
                          daysOfWeek: _isRecurring && _selectedDaysOfWeek.isNotEmpty ? _selectedDaysOfWeek : null,
                          recurrenceEndDate: _isRecurring ? _recurrenceEndDate : null,
                          parentTaskId: widget.task.parentTaskId, // Keep existing parent ID
                          maxOccurrences: _isRecurring ? _maxOccurrences : null,
                          skipWeekends: _isRecurring ? _skipWeekends : false,
                          dayOfMonth: _isRecurring && _recurrenceRule == 'monthly' ? _dayOfMonth : null,
                          weekOfMonth: _weekOfMonth,
                        );

                        // Call updateTask with the updated TaskModel
                        await _taskService.updateTask(updatedTask);
                        
                        // Update subtasks in the database
                        for (var subtask in _subtasks) {
                          await _taskService.updateSubtask(subtask);
                        }

                        // Navigate back with the updated task data
                        Navigator.pop(context, updatedTask);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Save Changes', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
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
              child: GestureDetector(
                onTap: () => _selectRecurrenceEndDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _recurrenceEndDate != null 
                        ? 'End Date: ${DateFormat('yyyy-MM-dd').format(_recurrenceEndDate!)}'
                        : 'Select End Date (Optional)',
                    style: TextStyle(
                      color: _recurrenceEndDate != null ? Colors.black : Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
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
}
