import 'package:maximize/models/reminder_model.dart';
import '../models/isar_models.dart';

class ReminderConverter {
  static IsarReminder fromReminderModel(ReminderModel model) {
    return IsarReminder()
      ..reminderId = model.id
      ..title = model.title
      ..body = model.body
      ..scheduledTime = model.scheduledTime
      ..notificationId = model.notificationId
      ..completed = model.completed
      ..completedAt = model.completedAt
      ..isRecurring = model.isRecurring
      ..recurrenceRule = model.recurrenceRule
      ..parentReminderId = model.parentReminderId
      ..recurrenceExceptionDates = model.recurrenceExceptionDates?.map((d) => d.toIso8601String()).join(',')
      ..recurrenceEndDate = model.recurrenceEndDate
      ..recurrenceCount = model.recurrenceCount
      ..createdAt = model.createdAt
      ..updatedAt = model.updatedAt;
  }

  static ReminderModel toReminderModel(IsarReminder isar) {
    return ReminderModel(
      id: isar.reminderId,
      title: isar.title,
      body: isar.body,
      scheduledTime: isar.scheduledTime ?? DateTime.now(),
      notificationId: isar.notificationId,
      completed: isar.completed,
      completedAt: isar.completedAt,
      isRecurring: isar.isRecurring,
      recurrenceRule: isar.recurrenceRule,
      parentReminderId: isar.parentReminderId,
      recurrenceExceptionDates: isar.recurrenceExceptionDates?.split(',').map((d) => DateTime.parse(d)).toList(),
      recurrenceEndDate: isar.recurrenceEndDate,
      recurrenceCount: isar.recurrenceCount,
      createdAt: isar.createdAt,
      updatedAt: isar.updatedAt,
    );
  }

  static IsarReminder fromJson(Map<String, dynamic> json) {
    return IsarReminder()
      ..reminderId = json['id'] ?? ''
      ..title = json['title'] ?? ''
      ..body = json['body'] ?? ''
      ..scheduledTime = json['scheduledTime'] != null ? DateTime.parse(json['scheduledTime']) : null
      ..notificationId = json['notificationId'] ?? ''
      ..completed = json['completed'] ?? false
      ..completedAt = json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null
      ..isRecurring = json['isRecurring'] ?? false
      ..recurrenceRule = json['recurrenceRule']
      ..parentReminderId = json['parentReminderId']
      ..recurrenceExceptionDates = json['recurrenceExceptionDates']
      ..recurrenceEndDate = json['recurrenceEndDate'] != null ? DateTime.parse(json['recurrenceEndDate']) : null
      ..recurrenceCount = json['recurrenceCount']
      ..createdAt = json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now()
      ..updatedAt = json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now();
  }

  static Map<String, dynamic> toJson(IsarReminder reminder) {
    return {
      'id': reminder.reminderId,
      'title': reminder.title,
      'body': reminder.body,
      'scheduledTime': reminder.scheduledTime?.toIso8601String(),
      'notificationId': reminder.notificationId,
      'completed': reminder.completed,
      'completedAt': reminder.completedAt?.toIso8601String(),
      'isRecurring': reminder.isRecurring,
      'recurrenceRule': reminder.recurrenceRule,
      'parentReminderId': reminder.parentReminderId,
      'recurrenceExceptionDates': reminder.recurrenceExceptionDates,
      'recurrenceEndDate': reminder.recurrenceEndDate?.toIso8601String(),
      'recurrenceCount': reminder.recurrenceCount,
      'createdAt': reminder.createdAt.toIso8601String(),
      'updatedAt': reminder.updatedAt.toIso8601String(),
    };
  }
}
