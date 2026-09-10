import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maximize/database/app_database_adapter.dart';
import 'package:maximize/models/subtask_model.dart';
import 'package:maximize/utils/task_utils.dart';
import 'package:uuid/uuid.dart';
import 'package:maximize/models/task_model.dart';
import 'package:maximize/services/task_service.dart';

class AddTaskPage extends StatefulWidget {
  final TaskModel? task;
  final TaskService? taskService;
  const AddTaskPage({super.key, this.task, this.taskService});

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
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

  // Reminder fields
  bool _reminderEnabled = false;
  DateTime? _reminderTime;
  String _reminderPreset = 'at_time';
  final List<Map<String, String>> _reminderPresets = [
    {'value': 'at_time', 'label': 'At time of task'},
    {'value': '15min', 'label': '15 minutes before'},
    {'value': '30min', 'label': '30 minutes before'},
    {'value': '1hour', 'label': '1 hour before'},
    {'value': '1day', 'label': '1 day before'},
    {'value': 'custom', 'label': 'Custom time'},
  ];

  // Subtask management
  List<SubtaskModel> _subtasks = [];
  final TextEditingController _subtaskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    if (widget.task != null) {
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
      _selectedDaysOfWeek = widget.task!.daysOfWeek ?? [];
      _recurrenceEndDate = widget.task!.recurrenceEndDate;
      _maxOccurrences = widget.task!.maxOccurrences;
      _skipWeekends = widget.task!.skipWeekends ?? false;
      _dayOfMonth = widget.task!.dayOfMonth;
      _weekOfMonth = widget.task!.weekOfMonth;
      
      //  Initialize reminder fields
      _reminderEnabled = widget.task!.reminderEnabled ?? false;
      _reminderTime = widget.task!.reminderTime;
      _reminderPreset = widget.task!.reminderPreset ?? 'at_time';
      
      // Load existing subtasks for edit mode
      _loadExistingSubtasks();
    }
  }

  Future<void> _loadExistingSubtasks() async {
    try {
      final database = AppDatabase.instance;
      final existingSubtasks = await database.getAllSubtasks(widget.task!.id);
      
      final subtaskModels = existingSubtasks.map((subtaskData) {
        return SubtaskModel(
          id: subtaskData.id,
          taskId: subtaskData.taskId,
          title: subtaskData.title,
          completed: subtaskData.completed,
          completedAt: subtaskData.completedAt,
        );
      }).toList();
      
      if (mounted) {
        setState(() {
          _subtasks = subtaskModels;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading subtasks: $e')),
        );
      }
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
                _buildReminderSection(), //NEW: Reminder section
                const SizedBox(height: 16),
                _buildSubtaskField(),
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
                  if (_newCategory.isNotEmpty && !_categories.contains(_newCategory)) {
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
              // ADDED: Update reminder time when due date changes
              if (_reminderEnabled && _reminderPreset != 'custom') {
                _updateReminderTime();
              }
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

  // Reminder Section
  Widget _buildReminderSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Reminder', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              subtitle: const Text('Get notified about this task'),
              value: _reminderEnabled,
              onChanged: (value) {
                setState(() {
                  _reminderEnabled = value;
                  if (value && _reminderTime == null) {
                    // Set default reminder time to task due date
                    _reminderTime = _dueDate;
                  }
                });
              },
            ),
            if (_reminderEnabled) ...[
              const Divider(),
              const SizedBox(height: 8),
              const Text('Remind me:', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              ..._reminderPresets.map((preset) {
                return RadioListTile<String>(
                  title: Text(preset['label']!),
                  value: preset['value']!,
                  groupValue: _reminderPreset,
                  onChanged: (value) {
                    setState(() {
                      _reminderPreset = value!;
                      _updateReminderTime();
                    });
                  },
                );
              }).toList(),
              if (_reminderPreset == 'custom') ...[
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Custom Reminder Time',
                    suffixIcon: Icon(Icons.access_time),
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: _pickCustomReminderTime,
                  controller: TextEditingController(
                    text: _reminderTime != null 
                        ? DateFormat('MMM dd, yyyy - hh:mm a').format(_reminderTime!)
                        : 'Tap to set time',
                  ),
                ),
              ],
              const SizedBox(height: 8),
              if (_reminderTime != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.notifications_active, color: Colors.blue, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Reminder set for ${DateFormat('MMM dd, yyyy - hh:mm a').format(_reminderTime!)}',
                          style: const TextStyle(fontSize: 13, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  //  Update reminder time based on preset
  void _updateReminderTime() {
    switch (_reminderPreset) {
      case 'at_time':
        _reminderTime = _dueDate;
        break;
      case '15min':
        _reminderTime = _dueDate.subtract(const Duration(minutes: 15));
        break;
      case '30min':
        _reminderTime = _dueDate.subtract(const Duration(minutes: 30));
        break;
      case '1hour':
        _reminderTime = _dueDate.subtract(const Duration(hours: 1));
        break;
      case '1day':
        _reminderTime = _dueDate.subtract(const Duration(days: 1));
        break;
      case 'custom':
        // Keep existing custom time or set to due date
        _reminderTime ??= _dueDate;
        break;
    }
  }

  // Pick custom reminder time
  Future<void> _pickCustomReminderTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _reminderTime ?? _dueDate,
      firstDate: DateTime.now(),
      lastDate: _dueDate,
    );
    
    if (pickedDate != null && mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_reminderTime ?? _dueDate),
      );
      
      if (pickedTime != null && mounted) {
        setState(() {
          _reminderTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
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
                _selectedDaysOfWeek.clear();
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
            final dayIndex = index + 1;
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

  Widget _buildSubtaskField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Subtasks:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        
        // Display existing subtasks
        if (_subtasks.isNotEmpty) ...[
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: _subtasks.map((subtask) {
              return Chip(
                avatar: subtask.completed 
                    ? Icon(Icons.check_circle, size: 18, color: Colors.green[600])
                    : Icon(Icons.radio_button_unchecked, size: 18, color: Colors.grey[600]),
                label: Text(
                  subtask.title,
                  style: TextStyle(
                    decoration: subtask.completed ? TextDecoration.lineThrough : null,
                    color: subtask.completed ? Colors.grey[600] : null,
                  ),
                ),
                onDeleted: () {
                  setState(() {
                    _subtasks.remove(subtask);
                  });
                },
                backgroundColor: subtask.completed ? Colors.green[50] : null,
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
        ],
        
        // Add new subtask
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _subtaskController,
                decoration: const InputDecoration(hintText: 'Enter new subtask'),
                onSubmitted: (_) => _addNewSubtask(),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _addNewSubtask,
              child: const Text('Add Subtask'),
            ),
          ],
        ),
      ],
    );
  }

  void _addNewSubtask() {
    final title = _subtaskController.text.trim();
    if (title.isNotEmpty) {
      setState(() {
        _subtasks.add(SubtaskModel(
          id: const Uuid().v1(),
          taskId: widget.task?.id ?? '',
          title: title,
          completed: false,
        ));
        _subtaskController.clear();
      });
    }
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
            
            // Validate reminder settings
            if (_reminderEnabled && _reminderTime == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please set a reminder time')),
              );
              return;
            }
            
            try {
              final taskModel = TaskModel(
                id: widget.task?.id ?? const Uuid().v1(),
                title: _taskTitle,
                description: _taskDescription,
                dueDate: _dueDate,
                completed: _completed,
                category: _categories.join(', '),
                priority: _selectedPriority,
                customCategory: null,
                pageId: null,
                day: null,
                isRecurring: _isRecurring,
                recurrenceRule: _isRecurring ? _recurrenceRule : null,
                recurrenceInterval: _isRecurring ? _recurrenceInterval : null,
                daysOfWeek: _isRecurring && _selectedDaysOfWeek.isNotEmpty ? _selectedDaysOfWeek : null,
                recurrenceEndDate: _isRecurring ? _recurrenceEndDate : null,
                parentTaskId: null,
                maxOccurrences: _isRecurring ? _maxOccurrences : null,
                skipWeekends: _isRecurring ? _skipWeekends : false,
                dayOfMonth: _isRecurring && _recurrenceRule == 'monthly' ? _dayOfMonth : null,
                weekOfMonth: _weekOfMonth,
                reminderEnabled: _reminderEnabled,
                reminderTime: _reminderEnabled ? _reminderTime : null,
                reminderPreset: _reminderEnabled ? _reminderPreset : null,
              );

              if (widget.task != null) {
                // Update existing task with proper notification handling
                if (widget.taskService != null) {
                  // Use TaskService (handles notifications automatically)
                  await widget.taskService!.updateTask(taskModel);
                } else {
                  // Fallback to direct database call
                  await AppDatabase.instance.updateTask(taskModel);
                }
                
                // Delete existing subtasks before inserting new ones
                final existingSubtasks = await AppDatabase.instance.getAllSubtasks(taskModel.id);
                for (var existingSubtask in existingSubtasks) {
                  await AppDatabase.instance.deleteSubtask(existingSubtask.id);
                }
              } else {
                // Create new task with proper notification handling
                if (widget.taskService != null) {
                  // Use TaskService (handles notifications automatically)
                  await widget.taskService!.addTask(
                    title: taskModel.title,
                    description: taskModel.description ?? '',
                    dueDate: taskModel.dueDate,
                    completed: taskModel.completed,
                    category: taskModel.category ?? '',
                    priority: taskModel.priority,
                    pageId: taskModel.pageId != null ? int.tryParse(taskModel.pageId!) : null,
                    completedAt: taskModel.completedAt,
                    subtasks: taskModel.subtasks,
                    isRecurring: taskModel.isRecurring ?? false,
                    recurrenceRule: taskModel.recurrenceRule,
                    recurrenceInterval: taskModel.recurrenceInterval,
                    daysOfWeek: taskModel.daysOfWeek,
                    recurrenceEndDate: taskModel.recurrenceEndDate,
                    parentTaskId: taskModel.parentTaskId,
                    maxOccurrences: taskModel.maxOccurrences,
                    skipWeekends: taskModel.skipWeekends ?? false,
                    dayOfMonth: taskModel.dayOfMonth,
                    weekOfMonth: taskModel.weekOfMonth,
                    reminderEnabled: taskModel.reminderEnabled ?? false,
                    reminderTime: taskModel.reminderTime,
                    reminderPreset: taskModel.reminderPreset,
                  );
                } else {
                  // Fallback to direct database call
                  await AppDatabase.instance.insertTask(taskModel);
                }
              }

              // Save all subtasks
              for (var subtask in _subtasks) {
                final updatedSubtask = subtask.copyWith(taskId: taskModel.id);
                await AppDatabase.instance.insertSubtask(updatedSubtask);
              }

              if (mounted) {
                Navigator.pop(context, taskModel);
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error saving task: $e')),
                );
              }
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
