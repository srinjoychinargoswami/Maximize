import 'package:isar/isar.dart';
import '../isar_database_service.dart';
import '../models/isar_models.dart';

class ReminderDAO {
  Future<void> insertReminder(IsarReminder reminder) async {
    await IsarDatabaseService.db.writeTxn(() async {
      await IsarDatabaseService.reminders.put(reminder);
    });
  }

  Future<List<IsarReminder>> getAllReminders() async {
    return await IsarDatabaseService.reminders.where().findAll();
  }

  Future<IsarReminder?> getReminderById(String reminderId) async {
    final reminders = await IsarDatabaseService.reminders.where().findAll();
    try {
      return reminders.firstWhere((reminder) => reminder.reminderId == reminderId);
    } catch (e) {
      return null;
    }
  }

  Future<List<IsarReminder>> getBaseReminders() async {
    final reminders = await IsarDatabaseService.reminders.where().findAll();
    return reminders.where((reminder) => reminder.parentReminderId == null).toList();
  }

  Future<List<IsarReminder>> getRecurringReminders() async {
    final reminders = await IsarDatabaseService.reminders.where().findAll();
    return reminders.where((reminder) => reminder.isRecurring).toList();
  }

  Future<List<IsarReminder>> getCompletedReminders() async {
    final reminders = await IsarDatabaseService.reminders.where().findAll();
    return reminders.where((reminder) => reminder.completed).toList();
  }

  Future<List<IsarReminder>> getRemindersInRange(
      DateTime start, DateTime end) async {
    final reminders = await IsarDatabaseService.reminders.where().findAll();
    return reminders.where((reminder) {
      final scheduledTime = reminder.scheduledTime;
      return scheduledTime != null &&
             scheduledTime.isAfter(start) &&
             scheduledTime.isBefore(end);
    }).toList();
  }

  Future<void> updateReminder(IsarReminder reminder) async {
    await IsarDatabaseService.db.writeTxn(() async {
      await IsarDatabaseService.reminders.put(reminder);
    });
  }

  Future<void> deleteReminder(String reminderId) async {
    final reminder = await getReminderById(reminderId);
    if (reminder != null) {
      await IsarDatabaseService.db.writeTxn(() async {
        await IsarDatabaseService.reminders.delete(reminder.id!);
      });
    }
  }

  Future<void> deleteReminderSeries(String parentReminderId) async {
    final parent = await getReminderById(parentReminderId);
    final reminders = await IsarDatabaseService.reminders.where().findAll();
    final children = reminders.where((reminder) => reminder.parentReminderId == parentReminderId).toList();

    await IsarDatabaseService.db.writeTxn(() async {
      if (parent != null) {
        await IsarDatabaseService.reminders.delete(parent.id!);
      }
      for (final child in children) {
        await IsarDatabaseService.reminders.delete(child.id!);
      }
    });
  }

  Future<int> countReminders() async {
    return await IsarDatabaseService.reminders.count();
  }

  Future<int> countCompletedReminders() async {
    final reminders = await IsarDatabaseService.reminders.where().findAll();
    return reminders.where((reminder) => reminder.completed).length;
  }
}
