import "package:provider/provider.dart";
import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import 'package:flutter/gestures.dart';
import "package:provider/provider.dart";
import 'package:maximize/models/task_model.dart';
import "package:provider/provider.dart";
import 'package:maximize/models/subtask_model.dart';
import "package:provider/provider.dart";
import 'package:maximize/services/task_service.dart';
import "package:provider/provider.dart";
import 'package:maximize/services/firebase_realtime_sync_service.dart';
import "package:provider/provider.dart";
import 'package:maximize/screens/add_task_page.dart';
import "package:provider/provider.dart";
import 'package:maximize/utils/task_utils.dart';
import "package:provider/provider.dart";
import 'package:maximize/database/app_database.dart';
import 'package:intl/intl.dart';

// CustomScrollBehavior to fix RefreshIndicator on Windows desktop
class CustomScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}

class TaskListScreen extends StatefulWidget {
  final AppDatabase database;

  const TaskListScreen({super.key, required this.database});

  @override
  TaskListScreenState createState() => TaskListScreenState();
}

class TaskListScreenState extends State<TaskListScreen> with TickerProviderStateMixin {
  List<TaskModel> _tasks = [];
  late final TaskService _taskService;
  bool _isLoading = true;
  bool _isRefreshing = false; // ADDED: Track refresh state
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Filter variables
  String _selectedCategory = 'All';
  String _selectedPriority = 'All';
  DateTime? _selectedDueDate;
  String _selectedRecurrenceFilter = 'All';
  
  // Expansion state for recurring tasks
  Map<String, bool> _expandedRecurringTasks = {};
  
  // Filter visibility
  bool _showFilters = false;

  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _taskService = context.read<TaskService>();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadTasks();

    // Listen for real-time task changes from Firebase
    if (FirebaseRealtimeSyncService.instance.isInitialized) {
      FirebaseRealtimeSyncService.instance.listenToTasks((tasks) {
        if (mounted) {
          setState(() {
            _tasks = tasks;
            _updateFilterOptions();
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Load tasks with refresh functionality
  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    try {
      _tasks = await _taskService.getTasks();
      _updateFilterOptions();
      setState(() => _isLoading = false);
      _animationController.forward();
    } catch (e) {
      print('Error loading tasks: $e');
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load tasks: $e')),
      );
    }
  }

  void scrollToItem(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _scrollController.animateTo(
        index * 120.0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  // ENHANCED: Public refresh method that can be called from parent with loading indicator
  Future<void> refreshTasks() async {
    if (_isRefreshing) return; // Prevent multiple simultaneous refreshes
    
    setState(() => _isRefreshing = true);
    await _loadTasks();
    setState(() => _isRefreshing = false);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tasks refreshed!'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  // Refresh method for pull-to-refresh functionality
  Future<void> _refreshTasks() async {
    await _loadTasks();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tasks refreshed!')),
    );
  }

  List<TaskModel> _filterTasks() {
    return _tasks.where((task) {
      final matchesCategory = _selectedCategory == 'All' || task.category == _selectedCategory;
      final matchesPriority = _selectedPriority == 'All' || task.priority == _selectedPriority;
      final matchesDueDate = _selectedDueDate == null || _isSameDate(task.dueDate, _selectedDueDate);
      final matchesRecurrence = _selectedRecurrenceFilter == 'All' || 
          (_selectedRecurrenceFilter == 'Recurring' && task.isRecurring) ||
          (_selectedRecurrenceFilter == 'One-time' && !task.isRecurring);
     final matchesSearch = _searchQuery.isEmpty ||
    task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
    (task.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);

return matchesCategory && matchesPriority && matchesDueDate && matchesRecurrence && matchesSearch;
    }).toList();
  }

  bool _isSameDate(DateTime? date1, DateTime? date2) {
    if (date1 == null || date2 == null) return false;
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  // Clear all filters
  void _clearAllFilters() {
    setState(() {
      _selectedCategory = 'All';
      _selectedPriority = 'All';
      _selectedDueDate = null;
      _selectedRecurrenceFilter = 'All';
    });
  }

  // Check if any filters are active
  bool get _hasActiveFilters {
    return _selectedCategory != 'All' || 
           _selectedPriority != 'All' || 
           _selectedDueDate != null || 
           _selectedRecurrenceFilter != 'All';
  }

  // Generate upcoming instances for recurring tasks
  List<DateTime> _generateUpcomingInstances(TaskModel task, {int maxInstances = 5}) {
    if (!task.isRecurring || task.recurrenceRule == null) return [];
    
    List<DateTime> instances = [];
    DateTime currentDate = task.dueDate;
    DateTime endDate = task.recurrenceEndDate ?? DateTime.now().add(const Duration(days: 365));
    int count = 0;
    
    while (currentDate.isBefore(endDate) && count < maxInstances && 
           (task.maxOccurrences == null || count < task.maxOccurrences!)) {
      instances.add(currentDate);
      count++;
      
      switch (task.recurrenceRule?.toLowerCase()) {
        case 'daily':
          currentDate = currentDate.add(Duration(days: task.recurrenceInterval ?? 1));
          if (task.skipWeekends) {
            while (currentDate.weekday == 6 || currentDate.weekday == 7) {
              currentDate = currentDate.add(const Duration(days: 1));
            }
          }
          break;
        case 'weekly':
          currentDate = currentDate.add(Duration(days: 7 * (task.recurrenceInterval ?? 1)));
          break;
        case 'monthly':
          currentDate = DateTime(
            currentDate.year,
            currentDate.month + (task.recurrenceInterval ?? 1),
            task.dayOfMonth ?? currentDate.day,
          );
          break;
        case 'yearly':
          currentDate = DateTime(
            currentDate.year + (task.recurrenceInterval ?? 1),
            currentDate.month,
            currentDate.day,
          );
          break;
        default:
          break;
      }
    }
    
    return instances;
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _filterTasks();

    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: const Text('Task List', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        actions: [
          // ADDED: Refresh button with loading indicator
          IconButton(
            icon: _isRefreshing 
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : refreshTasks,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: Icon(_showFilters ? Icons.filter_list_off : Icons.filter_list),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
            tooltip: _showFilters ? 'Hide Filters' : 'Show Filters',
          ),
          if (_hasActiveFilters)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: _clearAllFilters,
              tooltip: 'Clear All Filters',
            ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: CustomScrollBehavior(),
        child: RefreshIndicator(
          onRefresh: _refreshTasks,
          color: Colors.blue,
          backgroundColor: Colors.white,
          strokeWidth: 2.0,
          displacement: 40.0,
          child: Column(
            children: [
              Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search tasks...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.grey[800],
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[400]),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
        ),
        onChanged: (value) => setState(() => _searchQuery = value),
      ),
    ),
              // Filter section with animation
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _showFilters ? null : 0,
                child: _showFilters ? _buildFilterSection() : null,
              ),
              
              // Active filters indicator
              if (_hasActiveFilters) _buildActiveFiltersIndicator(),
              
              // Task list
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredTasks.isEmpty
                        ? _buildEmptyState()
                        : FadeTransition(
                            opacity: _fadeAnimation,
                            child: _buildTaskList(filteredTasks),
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "task_list_fab",
        onPressed: _addTask,
        tooltip: 'Add Task',
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
        elevation: 4,
      ),
    );
  }

  Widget _buildActiveFiltersIndicator() {
    List<String> activeFilters = [];
    if (_selectedCategory != 'All') activeFilters.add('Category: $_selectedCategory');
    if (_selectedPriority != 'All') activeFilters.add('Priority: $_selectedPriority');
    if (_selectedDueDate != null) activeFilters.add('Due: ${DateFormat('MMM dd').format(_selectedDueDate!)}');
    if (_selectedRecurrenceFilter != 'All') activeFilters.add('Type: $_selectedRecurrenceFilter');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border(bottom: BorderSide(color: Colors.blue[100]!)),
      ),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children: [
          ...activeFilters.map((filter) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              filter,
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          )),
          GestureDetector(
            onTap: _clearAllFilters,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.clear, size: 14, color: Colors.red[800]),
                  const SizedBox(width: 4),
                  Text(
                    'Clear All',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.task_alt,
                size: 80,
                color: Colors.grey[850],
              ),
              const SizedBox(height: 24),
              Text(
                _hasActiveFilters ? 'No tasks match your filters' : 'No tasks available',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[850],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _hasActiveFilters 
                    ? 'Try adjusting your filters or create a new task'
                    : 'Tap the + button to create your first task',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[850],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Pull down to refresh',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
              if (_hasActiveFilters) ...[ const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _clearAllFilters,
                  icon: const Icon(Icons.clear_all),
                  label: const Text('Clear Filters'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[100],
                    foregroundColor: Colors.blue[800],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList(List<TaskModel> filteredTasks) {
  return ListView.builder(
    controller: _scrollController, 
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsets.all(16.0),
    itemCount: filteredTasks.length,
    itemBuilder: (context, index) {
      final task = filteredTasks[index];
      return AnimatedContainer(
        duration: Duration(milliseconds: 300 + (index * 50)),
        child: _buildTaskCard(task),
      );
    },
  );
}


  Widget _buildTaskCard(TaskModel task) {
    final isExpanded = _expandedRecurringTasks[task.id] ?? false;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            // Main task
            _buildMainTaskTile(task, isExpanded),
            
            // Recurring instances (if expanded)
            if (task.isRecurring && isExpanded) _buildRecurringInstances(task),
            
            // Subtasks
            _buildSubtasksSection(task),
          ],
        ),
      ),
    );
  }

  Widget _buildMainTaskTile(TaskModel task, bool isExpanded) {
    return Container(
      decoration: BoxDecoration(
        color: task.completed ? Colors.grey[700] : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        leading: _buildTaskLeading(task),
        title: Row(
          children: [
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  decoration: task.completed ? TextDecoration.lineThrough : null,
                  color: task.completed ? Colors.white : Colors.white,
                ),
              ),
            ),
            if (task.isRecurring) _buildRecurringIndicator(task),
          ],
        ),
        subtitle: _buildTaskSubtitle(task),
        trailing: _buildTaskTrailing(task, isExpanded),
        onTap: () => _editTask(task),
      ),
    );
  }

  Widget _buildTaskLeading(TaskModel task) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: task.completed ? Colors.green : Colors.grey[400]!,
          width: 2,
        ),
      ),
      child: Checkbox(
        value: task.completed,
        onChanged: (value) => _toggleTaskCompletion(task, value),
        shape: const CircleBorder(),
        activeColor: Colors.green,
        checkColor: Colors.white,
      ),
    );
  }

  Widget _buildRecurringIndicator(TaskModel task) {
    IconData icon;
    Color color;
    String tooltip;
    
    switch (task.recurrenceRule?.toLowerCase()) {
      case 'daily':
        icon = Icons.today;
        color = Colors.blue;
        tooltip = 'Daily';
        break;
      case 'weekly':
        icon = Icons.date_range;
        color = Colors.green;
        tooltip = 'Weekly';
        break;
      case 'monthly':
        icon = Icons.calendar_month;
        color = Colors.orange;
        tooltip = 'Monthly';
        break;
      case 'yearly':
        icon = Icons.event_repeat;
        color = Colors.purple;
        tooltip = 'Yearly';
        break;
      default:
        icon = Icons.repeat;
        color = Colors.grey;
        tooltip = 'Recurring';
    }
    
    return Tooltip(
      message: tooltip,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Icon(
          icon,
          size: 18,
          color: color,
        ),
      ),
    );
  }

  Widget _buildTaskSubtitle(TaskModel task) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (task.description?.isNotEmpty == true)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                task.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.3,
                ),
              ),
            ),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: [
              _buildPriorityChip(task.priority),
              _buildDueDateChip(task.dueDate),
              if (task.category?.isNotEmpty == true) _buildCategoryChip(task.category!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityChip(String priority) {
    Color color;
    switch (priority.toLowerCase()) {
      case 'high':
        color = Colors.red;
        break;
      case 'medium':
        color = Colors.orange;
        break;
      case 'low':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        priority,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDueDateChip(DateTime dueDate) {
    final now = DateTime.now();
    final isOverdue = dueDate.isBefore(DateTime(now.year, now.month, now.day));
    final isToday = _isSameDate(dueDate, now);
    
    Color color = isOverdue ? Colors.red : (isToday ? Colors.orange : Colors.blue);
    String text = isToday ? 'Today' : DateFormat('MMM dd').format(dueDate);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.withOpacity(0.4)),
      ),
      child: Text(
        category,
        style: const TextStyle(
          color: Colors.purple,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTaskTrailing(TaskModel task, bool isExpanded) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (task.isRecurring)
          IconButton(
            icon: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              color: task.completed ? Colors.white : Colors.grey[850],
            ),
            onPressed: () {
              setState(() {
                _expandedRecurringTasks[task.id] = !isExpanded;
              });
            },
            tooltip: isExpanded ? 'Collapse instances' : 'Show upcoming instances',
          ),
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                _editTask(task);
                break;
              case 'delete':
                _deleteTask(task);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 12),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 12),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecurringInstances(TaskModel task) {
    final instances = _generateUpcomingInstances(task);
    
    if (instances.isEmpty) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule, size: 18, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                'Upcoming Instances',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...instances.map((date) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  DateFormat('EEE, MMM dd, yyyy').format(date),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSubtasksSection(TaskModel task) {
    return FutureBuilder<List<SubtaskModel>>(
      future: _taskService.getSubtasks(task.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(child: SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )),
          );
        }
        
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Error loading subtasks',
              style: TextStyle(color: Colors.red[600], fontSize: 13),
            ),
          );
        }
        
        final subtasks = snapshot.data ?? [];
        if (subtasks.isEmpty) return const SizedBox.shrink();
        
        return Container(
          margin: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: task.completed ? Colors.grey[700] : Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: task.completed ? Colors.grey[500]! : Colors.blue[100]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.subdirectory_arrow_right, size: 18, color: task.completed ? Colors.white : Colors.blue[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Subtasks (${subtasks.length})',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: task.completed ? Colors.white : Colors.blue[700],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...subtasks.map((subtask) => _buildSubtaskTile(subtask, task)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSubtaskTile(SubtaskModel subtask, TaskModel task) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            height: 24,
            width: 24,
            child: Checkbox(
              value: subtask.completed,
              onChanged: (value) => _toggleSubtaskCompletion(subtask, value),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              subtask.title,
              style: TextStyle(
                fontSize: 13,
                decoration: subtask.completed ? TextDecoration.lineThrough : null,
                color: task.completed 
                    ? Colors.white
                    : (subtask.completed ? Colors.grey[500] : Colors.grey[700]),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, size: 18, color: Colors.red[400]),
            onPressed: () => _deleteSubtask(subtask),
            tooltip: 'Delete subtask',
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tune, size: 22, color: Colors.grey[700]),
              const SizedBox(width: 12),
              Text(
                'Filter Tasks',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFilterRow1(),
          const SizedBox(height: 12),
          _buildFilterRow2(),
        ],
      ),
    );
  }

  Widget _buildFilterRow1() {
    final categories = _tasks.map((task) => task.customCategory ?? task.category).toSet().toList();
    categories.removeWhere((element) => element == null || element.isEmpty);
    categories.sort();
    if (!categories.contains('All')) categories.insert(0, 'All');

    return Row(
      children: [
        Expanded(
          child: _buildFilterDropdown(
            'Category',
            _selectedCategory,
            categories.cast<String>(),
            (value) => setState(() => _selectedCategory = value!),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildFilterDropdown(
            'Priority',
            _selectedPriority,
            ['All', 'Low', 'Medium', 'High'],
            (value) => setState(() => _selectedPriority = value!),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterRow2() {
    return Row(
      children: [
        Expanded(
          child: _buildFilterDropdown(
            'Type',
            _selectedRecurrenceFilter,
            ['All', 'Recurring', 'One-time'],
            (value) => setState(() => _selectedRecurrenceFilter = value!),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildDateFilterButton(),
        ),
      ],
    );
  }

  Widget _buildFilterDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[700],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          isExpanded: true,
          hint: Text(label, style: const TextStyle(color: Colors.white)),
          dropdownColor: Colors.grey[700],
          style: const TextStyle(color: Colors.white),
          items: items.map((item) => DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildDateFilterButton() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[700],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: _selectedDueDate ?? DateTime.now(),
              firstDate: DateTime(2022),
              lastDate: DateTime(2030),
            );

            if (pickedDate != null) {
              setState(() {
                _selectedDueDate = pickedDate;
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 18, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedDueDate == null 
                        ? 'Select Due Date' 
                        : DateFormat('MMM dd, yyyy').format(_selectedDueDate!),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (_selectedDueDate != null) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => setState(() => _selectedDueDate = null),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 12, color: Colors.grey),
                    ),
                  ),
                ],
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => setState(() => _selectedDueDate = null),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addTask() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTaskPage(),
      ),
    ).then((value) {
      if (value != null) {
        _loadTasks();
      }
    });
  }

  void _deleteTask(TaskModel task) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Deletion'),
        content: Text(
          task.isRecurring
              ? 'Are you sure you want to delete this recurring task? This will delete all instances.'
              : 'Are you sure you want to delete this task?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();

              // ✅ Cache task + subtasks before deletion
              final deletedTask = task;
              final subtasks = await _taskService.getSubtasks(task.id);

              try {
                await _taskService.deleteTask(task.id);
                await _loadTasks();

                // ✅ Undo SnackBar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      task.isRecurring
                          ? 'Recurring task deleted'
                          : 'Task deleted',
                    ),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () async {
                        try {
                          // Restore task
                          await _taskService.insertTask(deletedTask);

                          // Restore subtasks
                          for (final subtask in subtasks) {
                            await _taskService.insertSubtask(subtask);
                          }

                          await _loadTasks();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to undo: $e')),
                          );
                        }
                      },
                    ),
                  ),
                );
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete task: $error')),
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


  void _deleteSubtask(SubtaskModel subtask) {
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

              // ✅ Cache subtask before deletion
              final deletedSubtask = subtask;

              try {
                await _taskService.deleteSubtask(subtask.id);
                await _loadTasks();

                // ✅ Undo SnackBar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Subtask deleted'),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () async {
                        try {
                          await _taskService.insertSubtask(deletedSubtask);
                          await _loadTasks();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to undo: $e')),
                          );
                        }
                      },
                    ),
                  ),
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


  // Pass taskService parameter
  void _editTask(TaskModel task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskPage(
          task: task,
        ),
      ),
    ).then((value) {
      if (value != null) {
        _loadTasks();
      }
    });
  }

  void _toggleTaskCompletion(TaskModel task, bool? isCompleted) async {
    try {
      if (isCompleted == true) {
        await _taskService.markTaskCompleted(task.id);
      } else {
        await _taskService.markTaskIncomplete(task.id);
      }
      // Add small delay to ensure database update completes
      await Future.delayed(const Duration(milliseconds: 100));
      _loadTasks();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update task: $error')),
      );
    }
  }

  void _toggleSubtaskCompletion(SubtaskModel subtask, bool? isCompleted) async {
    try {
      if (isCompleted == true) {
        await _taskService.markSubtaskCompleted(subtask.id);
      } else {
        final updatedSubtask = subtask.copyWith(
          completed: false,
          completedAt: null,
        );
        await _taskService.updateSubtask(updatedSubtask);
      }
      // Add small delay to ensure database update completes
      await Future.delayed(const Duration(milliseconds: 100));
      _loadTasks();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update subtask: $error')),
      );
    }
  }

  void _updateFilterOptions() {
    final categories = _tasks.map((task) => task.customCategory ?? task.category).toSet().toList();
    categories.removeWhere((element) => element == null || element.isEmpty);
    categories.sort();
    if (!categories.contains('All')) categories.insert(0, 'All');

    setState(() {
      if (!categories.contains(_selectedCategory)) {
        _selectedCategory = 'All';
      }
    });
  }
}
