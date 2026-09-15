import 'package:kinetic/models/database.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_model.g.dart'; 

@JsonSerializable()
class TaskModel {
  final String id;
  final String title;
  final String? description;
  final String? content;
  final DateTime dueDate;
  bool completed;
  final String? category;
  final String priority;
  final String? customCategory;
  final String? pageId;
  final String? day;

  final bool isRecurring;
  final String? recurrenceRule;
  final int? recurrenceInterval;
  final List<int>? daysOfWeek;
  final DateTime? recurrenceEndDate;
  final String? parentTaskId;
  final int? maxOccurrences;
  final bool skipWeekends;
  final int? dayOfMonth;
  final int? weekOfMonth;

  final DateTime? completedAt;

  late DateTime createdAt;
  late DateTime updatedAt;

  final bool? reminderEnabled;
  final DateTime? reminderTime;
  final String? reminderPreset;

  final int energyRequired;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.content,
    required this.dueDate,
    this.completed = false,
    this.category,
    required this.priority,
    this.customCategory,
    this.pageId,
    this.day,
    this.isRecurring = false,
    this.recurrenceRule,
    this.recurrenceInterval,
    this.daysOfWeek,
    this.recurrenceEndDate,
    this.parentTaskId,
    this.maxOccurrences,
    this.skipWeekends = false,
    this.dayOfMonth,
    this.weekOfMonth,
    this.completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.reminderEnabled,
    this.reminderTime,
    this.reminderPreset,
    this.energyRequired = 5,
  }) {
    this.createdAt = createdAt ?? DateTime.now();
    this.updatedAt = updatedAt ?? DateTime.now();
  }

  factory TaskModel.fromData(TaskData data) {
    return TaskModel(
      id: data.id,
      title: data.title,
      description: data.description,
      content: data.content,
      dueDate: data.dueDate,
      completed: data.completed,
      category: data.category,
      priority: data.priority,
      customCategory: data.customCategory,
      pageId: data.pageId,
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
      completedAt: data.completedAt,
      reminderEnabled: data.reminderEnabled,
      reminderTime: data.reminderTime,
      reminderPreset: data.reminderPreset,
      energyRequired: 5,
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) => _$TaskModelFromJson(json);
  Map<String, dynamic> toJson() => _$TaskModelToJson(this);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
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
      'completedAt': completedAt?.toIso8601String(),
      'reminderEnabled': reminderEnabled,
      'reminderTime': reminderTime?.toIso8601String(),
      'reminderPreset': reminderPreset,
      'energyRequired': energyRequired,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
      content: map['content'],
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
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'])
          : null,
      reminderEnabled: map['reminderEnabled'],
      reminderTime: map['reminderTime'] != null
          ? DateTime.parse(map['reminderTime'])
          : null,
      reminderPreset: map['reminderPreset'],
      energyRequired: map['energyRequired'] ?? 5,
    );
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? content,
    DateTime? dueDate,
    bool? completed,
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
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? reminderEnabled,
    DateTime? reminderTime,
    String? reminderPreset,
    int? energyRequired,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      dueDate: dueDate ?? this.dueDate,
      completed: completed ?? this.completed,
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
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      reminderPreset: reminderPreset ?? this.reminderPreset,
      energyRequired: energyRequired ?? this.energyRequired,
    );
  }

  bool get isRecurringInstance => parentTaskId != null;
  bool get isRecurringParent => isRecurring && parentTaskId == null;

  TaskModel toggleCompletion() {
    return copyWith(
      completed: !completed,
      completedAt: !completed ? DateTime.now() : null,
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
