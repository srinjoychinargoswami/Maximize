import 'package:maximize/models/database.dart'; // Import your database file
import 'package:json_annotation/json_annotation.dart';

part 'task_model.g.dart'; 

@JsonSerializable()
class TaskModel {
  final String id; // Non-optional ID for the task
  final String name; // Name of the task
  final String title; // Title of the task
  final String? description; // Description of the task (optional)
  final DateTime dueDate; // Due date of the task
  bool completed; // Completion status of the task (made non-final)
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

  TaskModel({
    required this.id,
    required this.name,
    required this.title,
    this.description,
    required this.dueDate,
    this.completed = false, // Default to false
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
  });

  factory TaskModel.fromData(TaskData data) {
    return TaskModel(
      id: data.id, // Changed to String
      name: data.name,
      title: data.title,
      description: data.description,
      dueDate: data.dueDate,
      completed: data.completed, // Ensure this is correctly mapped
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
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) => _$TaskModelFromJson(json);
  Map<String, dynamic> toJson() => _$TaskModelToJson(this);

  // Convert to Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'completed': completed,
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
    };
  }

  // Create from Map for database operations
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      completed: map['completed'] ?? false,
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
    );
  }

  TaskModel copyWith({
    String? id,
    String? name,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? completed, // Make this optional
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
  }) {
    return TaskModel(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      completed: completed ?? this.completed, // Ensure this is correctly updated
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
    );
  }

  // Helper methods for recurring tasks
  bool get isRecurringInstance => parentTaskId != null;
  bool get isRecurringParent => isRecurring && parentTaskId == null;
  
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

// New Subtask Model
@JsonSerializable()
class SubtaskModel {
  final String id; // Non-optional ID for the subtask
  String taskId; // ID of the parent task
  String title; // Title of the subtask
  bool completed; // Completion status of the subtask

  SubtaskModel({
    required this.id,
    required this.taskId,
    required this.title,
    this.completed = false, // Default to false
  });

  factory SubtaskModel.fromJson(Map<String, dynamic> json) => _$SubtaskModelFromJson(json);
  Map<String, dynamic> toJson() => _$SubtaskModelToJson(this);

  // Convert to Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
      'title': title,
      'completed': completed,
    };
  }

  // Create from Map for database operations
  factory SubtaskModel.fromMap(Map<String, dynamic> map) {
    return SubtaskModel(
      id: map['id'] ?? '',
      taskId: map['taskId'] ?? '',
      title: map['title'] ?? '',
      completed: map['completed'] ?? false,
    );
  }

  SubtaskModel copyWith({
    String? id,
    String? taskId,
    String? title,
    bool? completed, // Make this optional
  }) {
    return SubtaskModel(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      completed: completed ?? this.completed, // Ensure this is correctly updated
    );
  }
}
