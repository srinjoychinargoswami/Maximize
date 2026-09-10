/// Simple data classes for model conversions
/// These replace the deleted Drift database definitions

class TaskData {
  final String id;
  final String title;
  final String? description;
  final DateTime dueDate;
  final bool completed;
  final String? category;
  final String priority;
  final String? customCategory;
  final String? pageId;
  final String? day;
  final bool isRecurring;
  final String? recurrenceRule;
  final int? recurrenceInterval;
  final String? daysOfWeek;
  final DateTime? recurrenceEndDate;
  final String? parentTaskId;
  final int? maxOccurrences;
  final bool skipWeekends;
  final int? dayOfMonth;
  final int? weekOfMonth;
  final DateTime? completedAt;
  final bool? reminderEnabled;
  final DateTime? reminderTime;
  final String? reminderPreset;

  TaskData({
    required this.id,
    required this.title,
    this.description,
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
    this.reminderEnabled,
    this.reminderTime,
    this.reminderPreset,
  });
}

class EventData {
  final String id;
  final String title;
  final String? description;
  final String? comments;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String? location;
  final String? color;
  final bool? isAllDay;
  final bool? isRecurring;
  final String? recurrenceRule;
  final DateTime? recurrenceEndDate;
  final String? parentEventId;
  final bool? completed;
  final DateTime? completedAt;
  final String? customCategory;
  final String? recurrenceExceptionDates;
  final int? recurrenceCount;
  final bool? reminderEnabled;
  final DateTime? reminderTime;
  final String? reminderPreset;
  final DateTime createdAt;
  final DateTime updatedAt;

  EventData({
    required this.id,
    required this.title,
    this.description,
    this.comments,
    required this.startDateTime,
    required this.endDateTime,
    this.location,
    this.color,
    this.isAllDay,
    this.isRecurring,
    this.recurrenceRule,
    this.recurrenceEndDate,
    this.parentEventId,
    this.completed,
    this.completedAt,
    this.customCategory,
    this.recurrenceExceptionDates,
    this.recurrenceCount,
    this.reminderEnabled,
    this.reminderTime,
    this.reminderPreset,
    required this.createdAt,
    required this.updatedAt,
  });
}

class ReminderData {
  final String id;
  final String? taskId;
  final String? eventId;
  final String title;
  final String body;
  final String? description;
  final DateTime scheduledTime;
  final String notificationId;
  final bool? completed;
  final DateTime? completedAt;
  final String? recurrenceRule;
  final int? recurrenceInterval;
  final DateTime? recurrenceEndDate;
  final String? parentReminderId;
  final bool? isRecurring;
  final int? recurrenceCount;
  final List<DateTime>? recurrenceExceptionDates;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReminderData({
    required this.id,
    this.taskId,
    this.eventId,
    required this.title,
    required this.body,
    this.description,
    required this.scheduledTime,
    required this.notificationId,
    this.completed,
    this.completedAt,
    this.recurrenceRule,
    this.recurrenceInterval,
    this.recurrenceEndDate,
    this.parentReminderId,
    this.isRecurring,
    this.recurrenceCount,
    this.recurrenceExceptionDates,
    required this.createdAt,
    required this.updatedAt,
  });
}

class NoteData {
  final String id;
  final String title;
  final String content;
  final bool isPinned;
  final String? category;
  final DateTime createdAt;
  final DateTime updatedAt;

  NoteData({
    required this.id,
    required this.title,
    required this.content,
    this.isPinned = false,
    this.category,
    required this.createdAt,
    required this.updatedAt,
  });
}

class EnergyEntryData {
  final String id;
  final int level;
  final String? note;
  final DateTime timestamp;
  final DateTime createdAt;
  final DateTime updatedAt;

  EnergyEntryData({
    required this.id,
    required this.level,
    this.note,
    required this.timestamp,
    required this.createdAt,
    required this.updatedAt,
  });
}

class CompletionLogData {
  final String id;
  final String taskId;
  final String? taskTitle;
  final String? description;
  final String? category;
  final String? priority;
  final bool isSubtask;
  final String? subtaskId;
  final String? parentTaskTitle;
  final DateTime completedAt;
  final String? notes;
  final int? energyLevel;
  final String? moodTags;
  final String? privacyContext;
  final String? location;
  final DateTime createdAt;
  final DateTime updatedAt;

  CompletionLogData({
    required this.id,
    required this.taskId,
    this.taskTitle,
    this.description,
    this.category,
    this.priority,
    this.isSubtask = false,
    this.subtaskId,
    this.parentTaskTitle,
    required this.completedAt,
    this.notes,
    this.energyLevel,
    this.moodTags,
    this.privacyContext,
    this.location,
    required this.createdAt,
    required this.updatedAt,
  });
}
