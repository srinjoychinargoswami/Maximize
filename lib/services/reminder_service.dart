import 'package:kinetic/database/app_database.dart';
import 'package:kinetic/models/reminder_model.dart';
import 'package:kinetic/utils/web_persistence_helper.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart';

class ReminderService {
  final AppDatabase _database;

  ReminderService(this._database);

  Future<List<ReminderModel>> getReminders() async {
    try {
      final rows = await _database.select(_database.reminders).get();
      return rows.map(_rowToModel).toList();
    } catch (e) {
      debugPrint('Error fetching reminders: $e');
      return [];
    }
  }

  Future<List<ReminderModel>> getRemindersFiltered({
    bool? completed,
    bool? isToday,
    bool? isUpcoming,
  }) async {
    try {
      final allReminders = await getReminders();
      return allReminders.where((reminder) {
        if (completed != null && reminder.completed != completed) return false;
        if (isToday == true && !reminder.isToday) return false;
        if (isUpcoming == true && !reminder.isUpcoming) return false;
        return true;
      }).toList();
    } catch (e) {
      debugPrint('Error fetching filtered reminders: $e');
      return [];
    }
  }

  Future<List<ReminderModel>> getTodaysReminders() async {
    try {
      return await getRemindersFiltered(isToday: true);
    } catch (e) {
      debugPrint('Error fetching today\'s reminders: $e');
      return [];
    }
  }

  Future<List<ReminderModel>> getCompletedReminders({DateTime? date}) async {
    try {
      final reminders = await getReminders();
      return reminders.where((reminder) {
        if (!reminder.completed) return false;
        if (date != null && reminder.completedAt != null) {
          return _isSameDay(reminder.completedAt!, date);
        }
        return reminder.completed;
      }).toList();
    } catch (e) {
      debugPrint('Error fetching completed reminders: $e');
      return [];
    }
  }

  Future<List<ReminderModel>> getOverdueReminders() async {
    try {
      final reminders = await getReminders();
      final now = DateTime.now();
      return reminders.where((reminder) {
        return !reminder.completed && reminder.scheduledTime.isBefore(now);
      }).toList();
    } catch (e) {
      debugPrint('Error fetching overdue reminders: $e');
      return [];
    }
  }

  Future<void> addReminder(ReminderModel reminder) async {
    try {
      await _database.transaction(() async {
        await _database.into(_database.reminders).insert(
          RemindersCompanion(
            id: Value(reminder.id),
            reminderId: Value(reminder.id),
            title: Value(reminder.title),
            description: Value(reminder.body),
            reminderTime: Value(reminder.scheduledTime),
            isRecurring: Value(reminder.isRecurring),
            recurrenceRule: Value(reminder.recurrenceRule),
            recurrenceInterval: Value(reminder.recurrenceInterval ?? 1),
            daysOfWeek: Value(reminder.daysOfWeek?.join(',')),
            recurrenceEndDate: Value(reminder.recurrenceEndDate),
            maxOccurrences: Value(reminder.maxOccurrences),
            createdAt: Value(DateTime.now()),
            updatedAt: Value(DateTime.now()),
          ),
        );
      });
      await WebPersistenceHelper.flush();
      WebPersistenceHelper.logPersistence('[ReminderService] Reminder added: ${reminder.id}');
    } catch (e) {
      debugPrint('Error adding reminder: $e');
    }
  }

  Future<void> insertReminder(ReminderModel reminder) async {
    try {
      await addReminder(reminder);
      debugPrint('[ReminderService] Reminder restored: ${reminder.title}');
    } catch (e) {
      debugPrint('Error inserting reminder: $e');
      rethrow;
    }
  }

  Future<void> updateReminder(ReminderModel reminder) async {
    try {
      await _database.transaction(() async {
        await (_database.update(_database.reminders)
              ..where((r) => r.reminderId.equals(reminder.id)))
            .write(RemindersCompanion(
              title: Value(reminder.title),
              description: Value(reminder.body),
              reminderTime: Value(reminder.scheduledTime),
              updatedAt: Value(DateTime.now()),
            ));
      });
      await WebPersistenceHelper.flush();
      WebPersistenceHelper.logPersistence('[ReminderService] Reminder updated: ${reminder.id}');
    } catch (e) {
      debugPrint('Error updating reminder: $e');
    }
  }

  Future<void> toggleReminderCompletion(String reminderId) async {
    try {
      final reminder = await getReminderById(reminderId);
      if (reminder != null) {
        final updatedReminder = reminder.toggleCompletion();
        await updateReminder(updatedReminder);
      }
    } catch (e) {
      debugPrint('Error toggling reminder completion: $e');
    }
  }

  Future<void> markReminderCompleted(String reminderId) async {
    try {
      final reminder = await getReminderById(reminderId);
      if (reminder != null && !reminder.completed) {
        final updatedReminder = reminder.copyWith(
          completed: true,
          completedAt: DateTime.now(),
        );
        await updateReminder(updatedReminder);
      }
    } catch (e) {
      debugPrint('Error marking reminder as completed: $e');
    }
  }

  Future<void> markReminderIncomplete(String reminderId) async {
    try {
      final reminder = await getReminderById(reminderId);
      if (reminder != null && reminder.completed) {
        final updatedReminder = reminder.copyWith(
          completed: false,
          completedAt: null,
        );
        await updateReminder(updatedReminder);
      }
    } catch (e) {
      debugPrint('Error marking reminder as incomplete: $e');
    }
  }

  Future<ReminderModel?> getReminderById(String id) async {
    try {
      final row = await (_database.select(_database.reminders)
            ..where((r) => r.reminderId.equals(id)))
          .getSingleOrNull();
      return row != null ? _rowToModel(row) : null;
    } catch (e) {
      debugPrint('Error fetching reminder by ID: $e');
      return null;
    }
  }

  Future<void> deleteReminder(String reminderId) async {
    try {
      await _database.transaction(() async {
        await (_database.delete(_database.reminders)
              ..where((r) => r.reminderId.equals(reminderId)))
            .go();
      });
      await WebPersistenceHelper.flush();
      WebPersistenceHelper.logPersistence('[ReminderService] Reminder deleted: $reminderId');
    } catch (e) {
      debugPrint('Error deleting reminder: $e');
    }
  }

  Future<Map<String, int>> getReminderStats() async {
    try {
      final reminders = await getReminders();
      final completed = reminders.where((reminder) => reminder.completed).length;
      final pending = reminders.where((reminder) => !reminder.completed).length;
      final overdue = reminders.where((reminder) =>
        !reminder.completed && reminder.scheduledTime.isBefore(DateTime.now())).length;

      return {
        'total': reminders.length,
        'completed': completed,
        'pending': pending,
        'overdue': overdue,
      };
    } catch (e) {
      debugPrint('Error getting reminder stats: $e');
      return {'total': 0, 'completed': 0, 'pending': 0, 'overdue': 0};
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  ReminderModel _rowToModel(Reminder row) {
    return ReminderModel(
      id: row.reminderId,
      title: row.title,
      body: row.description ?? '',
      scheduledTime: row.reminderTime ?? DateTime.now(),
      notificationId: row.reminderId.hashCode.toString(),
      completed: false,
    );
  }
}
