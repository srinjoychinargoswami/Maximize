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
  late String _taskTitle;
  late String _taskDescription;
  late DateTime _dueDate;
  late bool _completed;
  late List<String> _categories; // Changed to List<String> for chips
  late String _priority; // Add priority
  late TaskService _taskService; // Declare TaskService
  late List<SubtaskModel> _subtasks; // List to hold subtasks
  final TextEditingController _subtaskController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController(); // Add category controller
  String _newCategory = ''; // For adding new categories

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
    _taskTitle = widget.task.title; // Initialize task title
    _taskDescription = widget.task.description ?? '';
    _dueDate = widget.task.dueDate;
    _completed = widget.task.completed;
    _categories = widget.task.category?.split(', ') ?? []; // Initialize categories as list
    _priority = widget.task.priority; // Initialize priority
    _taskService = TaskService(widget.database); // Initialize TaskService with the database
    _subtasks = [];

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

  // ENHANCED: Load subtasks with proper error handling
  Future<void> _loadSubtasks() async {
    try {
      final subtasks = await _taskService.getSubtasks(widget.task.id);
      print('Fetched Subtasks: $subtasks');
      setState(() {
        _subtasks
        ..clear()
        ..addAll(subtasks);
      });
    } catch (e) {
      print('Error loading subtasks: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load subtasks: $e')),
      );
    }
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

  Future<void> _deleteSubtask(SubtaskModel subtask) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Delete Subtask'),
          content: Text('Are you sure you want to delete "${subtask.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await _taskService.deleteSubtask(subtask.id);
                  setState(() {
                    _subtasks.remove(subtask);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Subtask deleted successfully')),
                  );
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete subtask: $error')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // ADDED: Toggle subtask completion using TaskService (unified checkbox system)
  Future<void> _toggleSubtaskCompletion(SubtaskModel subtask, bool? isCompleted) async {
    try {
      if (isCompleted == true) {
        await _taskService.markSubtaskCompleted(subtask.id);
      } else {
        // Mark as incomplete
        final updatedSubtask = subtask.copyWith(
          completed: false,
          completedAt: null,
        );
        await _taskService.updateSubtask(updatedSubtask);
      }
      
      // Reload subtasks to get updated data from database
      await _loadSubtasks();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update subtask: $error')),
      );
    }
  }

  // ENHANCED: Add new subtask with immediate database persistence
  Future<void> _addNewSubtask() async {
    if (_subtaskController.text.isNotEmpty) {
      try {
        // Add subtask to database immediately
        await _taskService.addSubtask(
          widget.task.id,
          title: _subtaskController.text,
          completed: false,
        );
        
        // Reload subtasks to get updated data from database
        await _loadSubtasks();
        
        // Clear the input field
        _subtaskController.clear();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Subtask added successfully')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add subtask: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Edit Task', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 2,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task Details Card
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.task, color: Colors.blue[600], size: 24),
                          const SizedBox(width: 12),
                          const Text(
                            'Task Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        initialValue: _taskTitle,
                        decoration: InputDecoration(
                          labelText: 'Task Title',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          prefixIcon: const Icon(Icons.edit),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter task title';
                          }
                          return null;
                        },
                        onSaved: (value) => _taskTitle = value!,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: _taskDescription,
                        decoration: InputDecoration(
                          labelText: 'Task Description',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          prefixIcon: const Icon(Icons.description),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter task description';
                          }
                          return null;
                        },
                        onSaved: (value) => _taskDescription = value!,
                      ),
                      const SizedBox(height: 16),
                      
                      // Categories Section (Updated to show chips)
                      _buildCategoriesField(),
                      
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _priority,
                        decoration: InputDecoration(
                          labelText: 'Priority',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          prefixIcon: const Icon(Icons.priority_high),
                        ),
                        items: ['Low', 'Medium', 'High'].map((priority) {
                          return DropdownMenuItem(
                            value: priority,
                            child: Text(priority),
                          );
                        }).toList(),
                        onChanged: (value) => _priority = value!,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.calendar_today),
                          title: Text('Due Date: ${DateFormat('MMM dd, yyyy').format(_dueDate)}'),
                          trailing: const Icon(Icons.edit),
                          onTap: () => _selectDueDate(context),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: _completed ? Colors.green[50] : Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _completed ? Colors.green[200]! : Colors.grey[300]!,
                          ),
                        ),
                        child: CheckboxListTile(
                          title: Text(
                            'Mark as Completed',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: _completed ? Colors.green[800] : Colors.grey[700],
                            ),
                          ),
                          value: _completed,
                          onChanged: (bool? value) {
                            setState(() {
                              _completed = value ?? false;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Recurring Task Section
              _buildRecurringSection(),
              
              const SizedBox(height: 20),
              
              // Subtasks Section
              _buildSubtasksSection(),
              
              const SizedBox(height: 30),
              
              // Save Button
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
                        title: _taskTitle, // Use title
                        description: _taskDescription,
                        dueDate: _dueDate,
                        completed: _completed,
                        category: _categories.join(', '), // Join categories back to string
                        priority: _priority, // Pass priority
                        // ENHANCED: Include completion tracking
                        completedAt: _completed ? (widget.task.completedAt ?? DateTime.now()) : null,
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

                      try {
                        // Call updateTask with the updated TaskModel
                        await _taskService.updateTask(updatedTask);
                        
                        // REMOVED: Manual subtask updates - they're already persisted to database
                        // The subtasks are now updated immediately when modified through the UI

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Task updated successfully')),
                        );

                        // Navigate back with the updated task data
                        Navigator.pop(context, updatedTask);
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to update task: $error')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Categories field with chips and delete functionality (like add_task_page.dart)
  Widget _buildCategoriesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.category, color: Colors.purple[600], size: 20),
            const SizedBox(width: 8),
            const Text(
              'Categories:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_categories.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.purple[200]!),
            ),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _categories.map((category) {
                return Chip(
                  label: Text(
                    category,
                    style: TextStyle(
                      color: Colors.purple[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  backgroundColor: Colors.purple[100],
                  deleteIconColor: Colors.purple[700],
                  onDeleted: () {
                    setState(() {
                      _categories.remove(category);
                    });
                  },
                );
              }).toList(),
            ),
          ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) {
                  _newCategory = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter new category',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.add),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () {
                if (_newCategory.isNotEmpty && !_categories.contains(_newCategory)) {
                  setState(() {
                    _categories.add(_newCategory);
                    _newCategory = '';
                  });
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ENHANCED: Subtasks section with unified checkbox system
  Widget _buildSubtasksSection() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.list_alt, color: Colors.orange[600], size: 24),
                const SizedBox(width: 12),
                Text(
                  'Subtasks (${_subtasks.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // ENHANCED: Display existing subtasks with database-backed checkboxes
            if (_subtasks.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Column(
                  children: _subtasks.map((subtask) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: subtask.completed ? Colors.grey[200] : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: subtask.completed ? Colors.grey[400]! : Colors.orange[200]!,
                        ),
                      ),
                      child: Row(
                        children: [
                          // ENHANCED: Database-backed checkbox
                          Checkbox(
                            value: subtask.completed,
                            onChanged: (value) => _toggleSubtaskCompletion(subtask, value), // ENHANCED: Use unified system
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            activeColor: Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              subtask.title,
                              style: TextStyle(
                                decoration: subtask.completed ? TextDecoration.lineThrough : null,
                                color: subtask.completed ? Colors.grey[600] : Colors.orange[800],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          // Edit button
                          IconButton(
                            icon: Icon(Icons.edit, size: 18, color: Colors.blue[600]),
                            onPressed: () => _editSubtask(subtask),
                            tooltip: 'Edit subtask',
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          ),
                          // Delete button
                          IconButton(
                            icon: Icon(Icons.delete_outline, size: 18, color: Colors.red[600]),
                            onPressed: () => _deleteSubtask(subtask),
                            tooltip: 'Delete subtask',
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Add new subtask
            Container(
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _subtaskController,
                    decoration: InputDecoration(
                      hintText: 'Enter new subtask',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      prefixIcon: const Icon(Icons.add_task),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _addNewSubtask, // ENHANCED: Use new method with database persistence
                      icon: const Icon(Icons.add),
                      label: const Text('Add Subtask'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Empty state message
            if (_subtasks.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.task_alt, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 8),
                      Text(
                        'No subtasks yet',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Add a subtask to break down this task',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ENHANCED: Edit subtask with database persistence
  void _editSubtask(SubtaskModel subtask) {
    final controller = TextEditingController(text: subtask.title);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Edit Subtask'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Subtask title',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (controller.text.isNotEmpty) {
                  try {
                    // ENHANCED: Update subtask in database immediately
                    final updatedSubtask = subtask.copyWith(title: controller.text);
                    await _taskService.updateSubtask(updatedSubtask);
                    
                    // Reload subtasks to get updated data
                    await _loadSubtasks();
                    
                    Navigator.of(context).pop();
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Subtask updated successfully')),
                    );
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to update subtask: $error')),
                    );
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRecurringSection() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.repeat, color: Colors.green[600], size: 24),
                const SizedBox(width: 12),
                const Text(
                  'Recurring Settings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: _isRecurring ? Colors.green[50] : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isRecurring ? Colors.green[200]! : Colors.grey[300]!,
                ),
              ),
              child: SwitchListTile(
                title: const Text(
                  'Recurring Task',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Make this task repeat automatically'),
                value: _isRecurring,
                onChanged: (value) {
                  setState(() {
                    _isRecurring = value;
                  });
                },
                activeColor: Colors.green,
              ),
            ),
            if (_isRecurring) ...[
              const SizedBox(height: 20),
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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Text('Repeat:', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButton<String>(
              value: _recurrenceRule,
              isExpanded: true,
              underline: const SizedBox(),
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
      ),
    );
  }

  Widget _buildRecurrenceIntervalField() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Text('Every:', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 16),
          SizedBox(
            width: 80,
            child: TextFormField(
              initialValue: _recurrenceInterval.toString(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              onChanged: (value) {
                _recurrenceInterval = int.tryParse(value) ?? 1;
              },
            ),
          ),
          const SizedBox(width: 8),
          Text(_getIntervalLabel()),
        ],
      ),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border.all(color: Colors.blue[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('On these days:', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
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
                selectedColor: Colors.blue[200],
                checkmarkColor: Colors.blue[800],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyOptions() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange[50],
        border: Border.all(color: Colors.orange[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Monthly Options:', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('On day:'),
              const SizedBox(width: 16),
              SizedBox(
                width: 80,
                child: TextFormField(
                  initialValue: _dayOfMonth?.toString() ?? _dueDate.day.toString(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
      ),
    );
  }

  Widget _buildDailyOptions() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[50],
        border: Border.all(color: Colors.green[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SwitchListTile(
        title: const Text('Skip Weekends'),
        subtitle: const Text('Don\'t create tasks on Saturday and Sunday'),
        value: _skipWeekends,
        onChanged: (value) {
          setState(() {
            _skipWeekends = value;
          });
        },
        activeColor: Colors.green,
      ),
    );
  }

  Widget _buildRecurrenceEndOptions() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.purple[50],
        border: Border.all(color: Colors.purple[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('End Recurrence:', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: ListTile(
              leading: const Icon(Icons.event),
              title: Text(
                _recurrenceEndDate != null 
                    ? 'End Date: ${DateFormat('MMM dd, yyyy').format(_recurrenceEndDate!)}'
                    : 'Select End Date (Optional)',
                style: TextStyle(
                  color: _recurrenceEndDate != null ? Colors.black : Colors.grey[600],
                ),
              ),
              trailing: _recurrenceEndDate != null 
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _recurrenceEndDate = null;
                        });
                      },
                    )
                  : const Icon(Icons.edit),
              onTap: () => _selectRecurrenceEndDate(context),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Or limit to:'),
              const SizedBox(width: 16),
              SizedBox(
                width: 100,
                child: TextFormField(
                  initialValue: _maxOccurrences?.toString() ?? '',
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    hintText: 'Max',
                    filled: true,
                    fillColor: Colors.white,
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
      ),
    );
  }
}
