import 'package:maximize/models/event_model.dart';
import '../models/isar_models.dart';

class EventConverter {
  static IsarEvent fromEventModel(Event model) {
    return IsarEvent()
      ..eventId = model.id
      ..title = model.title
      ..description = model.description
      ..comments = model.comments
      ..startDateTime = model.startDateTime
      ..endDateTime = model.endDateTime
      ..customCategory = model.customCategory
      ..color = model.color
      ..completed = model.completed
      ..completedAt = model.completedAt
      ..isRecurring = model.isRecurring
      ..recurrenceRule = model.recurrenceRule
      ..parentEventId = model.parentEventId
      ..recurrenceExceptionDates = model.recurrenceExceptionDates?.map((d) => d.toIso8601String()).join(',')
      ..recurrenceEndDate = model.recurrenceEndDate
      ..recurrenceCount = model.recurrenceCount
      ..reminderEnabled = model.reminderEnabled ?? false
      ..reminderTime = model.reminderTime
      ..reminderPreset = model.reminderPreset
      ..createdAt = model.createdAt ?? DateTime.now()
      ..updatedAt = model.updatedAt ?? DateTime.now();
  }

  static Event toEventModel(IsarEvent isar) {
    return Event(
      id: isar.eventId,
      title: isar.title,
      description: isar.description,
      comments: isar.comments,
      startDateTime: isar.startDateTime ?? DateTime.now(),
      endDateTime: isar.endDateTime ?? DateTime.now(),
      date: isar.startDateTime ?? DateTime.now(),
      customCategory: isar.customCategory,
      color: isar.color ?? '#FFFFFF',
      completed: isar.completed,
      completedAt: isar.completedAt,
      createdAt: isar.createdAt,
      updatedAt: isar.updatedAt,
      isRecurring: isar.isRecurring,
      recurrenceRule: isar.recurrenceRule,
      parentEventId: isar.parentEventId,
      recurrenceExceptionDates: isar.recurrenceExceptionDates?.split(',')
          .where((d) => d.isNotEmpty)
          .map((d) => DateTime.parse(d))
          .toList(),
      recurrenceEndDate: isar.recurrenceEndDate,
      recurrenceCount: isar.recurrenceCount,
      reminderEnabled: isar.reminderEnabled,
      reminderTime: isar.reminderTime,
      reminderPreset: isar.reminderPreset,
    );
  }

  static IsarEvent fromJson(Map<String, dynamic> json) {
    return IsarEvent()
      ..eventId = json['id'] ?? ''
      ..title = json['title'] ?? ''
      ..description = json['description']
      ..comments = json['comments']
      ..startDateTime = json['startDateTime'] != null ? DateTime.parse(json['startDateTime']) : null
      ..endDateTime = json['endDateTime'] != null ? DateTime.parse(json['endDateTime']) : null
      ..customCategory = json['customCategory']
      ..color = json['color']
      ..completed = json['completed'] ?? false
      ..completedAt = json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null
      ..isRecurring = json['isRecurring'] ?? false
      ..recurrenceRule = json['recurrenceRule']
      ..parentEventId = json['parentEventId']
      ..recurrenceExceptionDates = json['recurrenceExceptionDates']
      ..recurrenceEndDate = json['recurrenceEndDate'] != null ? DateTime.parse(json['recurrenceEndDate']) : null
      ..recurrenceCount = json['recurrenceCount']
      ..reminderEnabled = json['reminderEnabled'] ?? false
      ..reminderTime = json['reminderTime'] != null ? DateTime.parse(json['reminderTime']) : null
      ..reminderPreset = json['reminderPreset']
      ..createdAt = json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now()
      ..updatedAt = json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now();
  }

  static Map<String, dynamic> toJson(IsarEvent event) {
    return {
      'id': event.eventId,
      'title': event.title,
      'description': event.description,
      'comments': event.comments,
      'startDateTime': event.startDateTime?.toIso8601String(),
      'endDateTime': event.endDateTime?.toIso8601String(),
      'customCategory': event.customCategory,
      'color': event.color,
      'completed': event.completed,
      'completedAt': event.completedAt?.toIso8601String(),
      'isRecurring': event.isRecurring,
      'recurrenceRule': event.recurrenceRule,
      'parentEventId': event.parentEventId,
      'recurrenceExceptionDates': event.recurrenceExceptionDates,
      'recurrenceEndDate': event.recurrenceEndDate?.toIso8601String(),
      'recurrenceCount': event.recurrenceCount,
      'reminderEnabled': event.reminderEnabled,
      'reminderTime': event.reminderTime?.toIso8601String(),
      'reminderPreset': event.reminderPreset,
      'createdAt': event.createdAt.toIso8601String(),
      'updatedAt': event.updatedAt.toIso8601String(),
    };
  }
}
