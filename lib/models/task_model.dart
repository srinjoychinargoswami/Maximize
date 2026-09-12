import 'package:kinetic/models/database.dart'; // Import your database file
import 'package:kinetic/models/subtask_model.dart'; // Import SubtaskModel from separate file
import 'package:json_annotation/json_annotation.dart';

part 'task_model.g.dart'; 

@JsonSerializable()
class TaskModel {
  final String id; // Non-optional ID for the task
  final String title; // Title of the task
  final String? description; // Description of the task (optional)
  final DateTime dueDate; // Due date of the task
  bool completed; // Completion status of the task (made non-final) - ALREADY PERFECT FOR CHECKBOXES
  final String? category; // Category of the task (optional)
  final String priority; // Priority of the task
  final String? customCategory; // Custom category (optional)
  final String? pageId; // Optional page ID for associating with pages
  final String? day; // Day of the task (optional)
  
  // Recurring task fields
  final bool isRecurring; // Whether this task is recurring
  final String? recurrenceRule; // Recurrence pattern (daily, weekly, monthly, yearly)
  final int? recurrenceInterval; // Interval for recurrence (every X days/weeks/months)
  final List<int>? daysOfWeek; // Days of week for weekly recurrence (1=Monday, 7=Sunday)
  final DateTime? recurrenceEndDate; // End date for recurrence
  final String? parentTaskId; // ID of the parent recurring task (for instances)
  final int? maxOccurrences; // Maximum number of occurrences
  final bool skipWeekends; // Whether to skip weekends for daily recurrence
  final int? dayOfMonth; // Specific day of month for monthly recurrence
  final int? weekOfMonth; // Week of month for monthly recurrence (1-4, or -1 for last)

  // ADDED: Completion tracking fields for better functionality
  final DateTime? completedAt; // When the task was completed (NEW)
  final List<SubtaskModel>? subtasks; // List of subtasks (ADDED for better integration)

  // ADDED: Timestamp tracking
  late DateTime createdAt; // When the task was created
  late DateTime updatedAt; // When the task was last updated

  // NEW: Reminder fields
  final bool? reminderEnabled; // Whether reminder notification is enabled
  final DateTime? reminderTime; // When to show the reminder notification
  final String? reminderPreset; // Preset type: 'at_time', '15min', '30min', '1hour', '1day', 'custom'

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.dueDate,
    this.completed = false, // Default to false - PERFECT FOR CHECKBOXES
    this.category,
    required this.priority,
    this.customCategory,
    this.pageId,
    this.day,
    this.isRecurring = false, // Default to false
    this.recurrenceRule,
    this.recurrenceInterval,
    this.daysOfWeek,
    this.recurrenceEndDate,
    this.parentTaskId,
    this.maxOccurrences,
    this.skipWeekends = false, // Default to false
    this.dayOfMonth,
    this.weekOfMonth,
    this.completedAt, // ADDED: Track completion timestamp
    this.subtasks, // ADDED: Include subtasks in model
    DateTime? createdAt, // ADDED: Allow setting createdAt
    DateTime? updatedAt, // ADDED: Allow setting updatedAt
    this.reminderEnabled,
    this.reminderTime,
    this.reminderPreset,
  }) {
    // Initialize timestamps
    this.createdAt = createdAt ?? DateTime.now();
    this.updatedAt = updatedAt ?? DateTime.now();
  }

  factory TaskModel.fromData(TaskData data) {
    return TaskModel(
      id: data.id, // Changed to String
      title: data.title,
      description: data.description,
      dueDate: data.dueDate,
      completed: data.completed, // Ensure this is correctly mapped - ALREADY PERFECT
      category: data.category,
      priority: data.priority,
      customCategory: data.customCategory,
      pageId: data.pageId, // Changed to String?
      day: data.day,
      isRecurring: data.isRecurring ?? false,
      recurrenceRule: data.recurrenceRule,
      recurrenceInterval: data.recurrenceInterval,
      daysOfWeek: data.daysOfWeek?.split(',').map((e) => int.tryParse(e.trim())).where((e) => e != null).cast<int>().toList(),
      recurrenceEndDate: data.recurrenceEndDate,
      parentTaskId: data.parentTaskId,
      maxOccurrences: data.maxOccurrences,
      skipWeekends: data.skipWeekends ?? false,
      dayOfMonth: data.dayOfMonth,
      weekOfMonth: data.weekOfMonth,
      completedAt: data.completedAt, // ADDED: Map completion timestamp
      reminderEnabled: data.reminderEnabled, // : Map reminder enabled
      reminderTime: data.reminderTime, //  Map reminder time
      reminderPreset: data.reminderPreset, //  Map reminder preset
      // Note: subtasks will be loaded separately via service layer
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) => _$TaskModelFromJson(json);
  Map<String, dynamic> toJson() => _$TaskModelToJson(this);

  // Convert to Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'completed': completed, // ALREADY PERFECT FOR DATABASE STORAGE
      'category': category,
      'priority': priority,
      'customCategory': customCategory,
      'pageId': pageId,
      'day': day,
      'isRecurring': isRecurring,
      'recurrenceRule': recurrenceRule,
      'recurrenceInterval': recurrenceInterval,
      'daysOfWeek': daysOfWeek?.join(','),
      'recurrenceEndDate': recurrenceEndDate?.toIso8601String(),
      'parentTaskId': parentTaskId,
      'maxOccurrences': maxOccurrences,
      'skipWeekends': skipWeekends,
      'dayOfMonth': dayOfMonth,
      'weekOfMonth': weekOfMonth,
      'completedAt': completedAt?.toIso8601String(), // ADDED: Include completion timestamp
      'reminderEnabled': reminderEnabled, // Include reminder enabled
      'reminderTime': reminderTime?.toIso8601String(), //Include reminder time
      'reminderPreset': reminderPreset, // Include reminder preset
    };
  }

  // Create from Map for database operations
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      completed: map['completed'] ?? false, // ALREADY PERFECT FOR CHECKBOXES
      category: map['category'],
      priority: map['priority'] ?? 'medium',
      customCategory: map['customCategory'],
      pageId: map['pageId'],
      day: map['day'],
      isRecurring: map['isRecurring'] ?? false,
      recurrenceRule: map['recurrenceRule'],
      recurrenceInterval: map['recurrenceInterval'],
      daysOfWeek: map['daysOfWeek'] != null 
          ? map['daysOfWeek'].split(',').map<int>((e) => int.parse(e.trim())).toList()
          : null,
      recurrenceEndDate: map['recurrenceEndDate'] != null 
          ? DateTime.parse(map['recurrenceEndDate'])
          : null,
      parentTaskId: map['parentTaskId'],
      maxOccurrences: map['maxOccurrences'],
      skipWeekends: map['skipWeekends'] ?? false,
      dayOfMonth: map['dayOfMonth'],
      weekOfMonth: map['weekOfMonth'],
      completedAt: map['completedAt'] != null // ADDED: Parse completion timestamp
          ? DateTime.parse(map['completedAt'])
          : null,
      reminderEnabled: map['reminderEnabled'], // Parse reminder enabled
      reminderTime: map['reminderTime'] != null // Parse reminder time
          ? DateTime.parse(map['reminderTime'])
          : null,
      reminderPreset: map['reminderPreset'], // Parse reminder preset
    );
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? completed, // Make this optional - ALREADY PERFECT FOR CHECKBOX UPDATES
    String? category,
    String? priority,
    String? customCategory,
    String? pageId,
    String? day,
    bool? isRecurring,
    String? recurrenceRule,
    int? recurrenceInterval,
    List<int>? daysOfWeek,
    DateTime? recurrenceEndDate,
    String? parentTaskId,
    int? maxOccurrences,
    bool? skipWeekends,
    int? dayOfMonth,
    int? weekOfMonth,
    DateTime? completedAt, // ADDED: Allow updating completion timestamp
    List<SubtaskModel>? subtasks, // ADDED: Allow updating subtasks
    DateTime? createdAt, // ADDED: Allow updating creation timestamp
    DateTime? updatedAt, // ADDED: Allow updating update timestamp
    bool? reminderEnabled, // Allow updating reminder enabled
    DateTime? reminderTime, //  Allow updating reminder time
    String? reminderPreset, //Allow updating reminder preset
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      completed: completed ?? this.completed, // Ensure this is correctly updated - PERFECT
      category: category ?? this.category,
      priority: priority ?? this.priority,
      customCategory: customCategory ?? this.customCategory,
      pageId: pageId ?? this.pageId,
      day: day ?? this.day,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      recurrenceInterval: recurrenceInterval ?? this.recurrenceInterval,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      recurrenceEndDate: recurrenceEndDate ?? this.recurrenceEndDate,
      parentTaskId: parentTaskId ?? this.parentTaskId,
      maxOccurrences: maxOccurrences ?? this.maxOccurrences,
      skipWeekends: skipWeekends ?? this.skipWeekends,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      weekOfMonth: weekOfMonth ?? this.weekOfMonth,
      completedAt: completedAt ?? this.completedAt, // ADDED: Update completion timestamp
      subtasks: subtasks ?? this.subtasks, // ADDED: Update subtasks
      createdAt: createdAt ?? this.createdAt, // ADDED: Update creation timestamp
      updatedAt: updatedAt ?? this.updatedAt, // ADDED: Update update timestamp
      reminderEnabled: reminderEnabled ?? this.reminderEnabled, // Update reminder enabled
      reminderTime: reminderTime ?? this.reminderTime, // Update reminder time
      reminderPreset: reminderPreset ?? this.reminderPreset, // Update reminder preset
    );
  }

  // Helper methods for recurring tasks
  bool get isRecurringInstance => parentTaskId != null;
  bool get isRecurringParent => isRecurring && parentTaskId == null;
  
  // ADDED: Helper methods for checkbox functionality
  bool get hasSubtasks => subtasks != null && subtasks!.isNotEmpty;
  bool get allSubtasksCompleted => hasSubtasks ? subtasks!.every((subtask) => subtask.completed) : true;
  double get completionPercentage {
    if (!hasSubtasks) return completed ? 1.0 : 0.0;
    int completedCount = subtasks!.where((subtask) => subtask.completed).length;
    return completedCount / subtasks!.length;
  }
  
  // ADDED: Method to toggle completion status (for checkbox functionality)
  TaskModel toggleCompletion() {
    return copyWith(
      completed: !completed,
      completedAt: !completed ? DateTime.now() : null, // Set timestamp when completing
    );
  }
  
  // Helper method to check if reminder is set
  bool get hasReminder => reminderEnabled == true && reminderTime != null;
  
  // Check if this task should recur on a specific date
  bool shouldRecurOnDate(DateTime date) {
    if (!isRecurring) return false;
    
    switch (recurrenceRule?.toLowerCase()) {
      case 'daily':
        if (skipWeekends && (date.weekday == 6 || date.weekday == 7)) {
          return false;
        }
        return true;
      case 'weekly':
        return daysOfWeek?.contains(date.weekday) ?? false;
      case 'monthly':
        if (dayOfMonth != null) {
          return date.day == dayOfMonth;
        }
        // Add logic for week of month if needed
        return false;
      case 'yearly':
        return date.month == dueDate.month && date.day == dueDate.day;
      default:
        return false;
    }
  }
}
