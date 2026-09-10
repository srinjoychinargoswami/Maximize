import 'package:isar/isar.dart';

part 'isar_models.g.dart';

/// Collection 1: Tasks
@collection
class IsarTask {
  Id? id;
  @Index()
  late String taskId; // UUID v1
  late String title;
  String? description;
  DateTime? dueDate;
  @Index()
  late bool completed;
  DateTime? completedAt;
  String? category;
  late String priority;
  String? customCategory;
  String? pageId;
  String? day;

  // Recurring task fields
  @Index()
  late bool isRecurring;
  String? recurrenceRule;
  int? recurrenceInterval;
  String? daysOfWeek; // comma-separated list of weekdays (1-7)
  DateTime? recurrenceEndDate;
  @Index()
  String? parentTaskId; // ID of parent recurring task
  int? maxOccurrences;
  late bool skipWeekends;
  int? dayOfMonth;
  int? weekOfMonth;

  // Reminder fields for tasks
  late bool reminderEnabled;
  DateTime? reminderTime;
  String? reminderPreset;

  late DateTime createdAt;
  late DateTime updatedAt;
}

/// Collection 2: Subtasks
@collection
class IsarSubtask {
  Id? id;
  @Index()
  late String subtaskId; // UUID v1
  @Index()
  late String taskId; // Foreign key to tasks
  late String title;
  @Index()
  late bool completed;
  DateTime? completedAt;

  late DateTime createdAt;
  late DateTime updatedAt;
}

/// Collection 3: Events
@collection
class IsarEvent {
  Id? id;
  @Index()
  late String eventId; // UUID v1
  late String title;
  String? description;
  String? comments;
  DateTime? startDateTime;
  DateTime? endDateTime;
  String? customCategory;
  String? color;
  @Index()
  late bool completed;
  DateTime? completedAt;

  // Recurring event fields
  @Index()
  late bool isRecurring;
  String? recurrenceRule;
  @Index()
  String? parentEventId;
  String? recurrenceExceptionDates; // comma-separated ISO dates
  DateTime? recurrenceEndDate;
  int? recurrenceCount;

  // Reminder fields for events
  late bool reminderEnabled;
  DateTime? reminderTime;
  String? reminderPreset;

  late DateTime createdAt;
  late DateTime updatedAt;
}

/// Collection 4: Reminders
@collection
class IsarReminder {
  Id? id;
  @Index()
  late String reminderId; // UUID v4
  late String title;
  late String body;
  DateTime? scheduledTime;
  late String notificationId;
  @Index()
  late bool completed;
  DateTime? completedAt;

  // Recurring reminder fields
  @Index()
  late bool isRecurring;
  String? recurrenceRule;
  @Index()
  String? parentReminderId;
  String? recurrenceExceptionDates; // comma-separated ISO dates
  DateTime? recurrenceEndDate;
  int? recurrenceCount;

  late DateTime createdAt;
  late DateTime updatedAt;
}

/// Collection 5: Notes
@collection
class IsarNote {
  Id? id;
  @Index()
  late String noteId; // UUID v4
  late String title;
  late String content;
  String? category;
  late String color;
  late DateTime createdAt;
  late DateTime updatedAt;
  @Index()
  late bool isPinned;
}

/// Collection 6: Energy Entries
@collection
class IsarEnergyEntry {
  Id? id;
  @Index()
  late String entryId; // UUID v4
  @Index()
  late DateTime timestamp;
  late int energyLevel; // 1-10 scale
  String? moodTags;
  String? privacyContext;
  String? location;
  String? notes;
  String? userId; // For Firebase sync

  late DateTime createdAt;
  late DateTime updatedAt;
}

/// Collection 7: Completion Logs
@collection
class IsarCompletionLog {
  Id? id;
  @Index()
  late String logId; // UUID v1
  String? taskId;
  late String taskTitle;
  String? description;
  String? category;
  String? priority;
  @Index()
  late DateTime completedAt;
  @Index()
  late bool isSubtask;
  String? parentTaskTitle;

  int? energyLevel;
  String? moodTags;
  String? privacyContext;
  String? location;

  late DateTime createdAt;
  late DateTime updatedAt;
}
