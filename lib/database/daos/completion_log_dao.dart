import 'package:isar/isar.dart';
import '../isar_database_service.dart';
import '../models/isar_models.dart'
    show IsarCompletionLog, IsarCompletionLogSchema;

class CompletionLogDAO {
  Future<void> insertCompletionLog(IsarCompletionLog log) async {
    await IsarDatabaseService.db.writeTxn(() async {
      await IsarDatabaseService.completionLogs.put(log);
    });
  }

  Future<List<IsarCompletionLog>> getAllCompletionLogs() async {
    final logs = await IsarDatabaseService.completionLogs.where().findAll();
    logs.sort((a, b) => b.completedAt.compareTo(a.completedAt));
    return logs;
  }

  Future<IsarCompletionLog?> getCompletionLog(String logId) async {
    final logs = await IsarDatabaseService.completionLogs.where().findAll();
    try {
      return logs.firstWhere((log) => log.logId == logId);
    } catch (e) {
      return null;
    }
  }

  Future<List<IsarCompletionLog>> getCompletionLogsThisWeek() async {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    final logs = await IsarDatabaseService.completionLogs.where().findAll();
    final filtered = logs.where((log) => log.completedAt.isAfter(sevenDaysAgo)).toList();
    filtered.sort((a, b) => b.completedAt.compareTo(a.completedAt));
    return filtered;
  }

  Future<List<IsarCompletionLog>> getCompletionLogsByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final logs = await IsarDatabaseService.completionLogs.where().findAll();
    final filtered = logs.where((log) =>
      log.completedAt.isAfter(startOfDay) &&
      log.completedAt.isBefore(endOfDay)
    ).toList();
    filtered.sort((a, b) => b.completedAt.compareTo(a.completedAt));
    return filtered;
  }

  Future<List<IsarCompletionLog>> getSubtaskCompletions() async {
    final logs = await IsarDatabaseService.completionLogs.where().findAll();
    final filtered = logs.where((log) => log.isSubtask).toList();
    filtered.sort((a, b) => b.completedAt.compareTo(a.completedAt));
    return filtered;
  }

  Future<List<IsarCompletionLog>> getTaskCompletions() async {
    final logs = await IsarDatabaseService.completionLogs.where().findAll();
    final filtered = logs.where((log) => !log.isSubtask).toList();
    filtered.sort((a, b) => b.completedAt.compareTo(a.completedAt));
    return filtered;
  }

  Future<void> updateCompletionLog(IsarCompletionLog log) async {
    await IsarDatabaseService.db.writeTxn(() async {
      await IsarDatabaseService.completionLogs.put(log);
    });
  }

  Future<void> deleteCompletionLog(String logId) async {
    final log = await getCompletionLog(logId);
    if (log != null) {
      await IsarDatabaseService.db.writeTxn(() async {
        await IsarDatabaseService.completionLogs.delete(log.id!);
      });
    }
  }

  Future<void> deleteAllCompletionLogs() async {
    await IsarDatabaseService.db.writeTxn(() async {
      await IsarDatabaseService.completionLogs.clear();
    });
  }

  Future<int> countLogs() async {
    return await IsarDatabaseService.completionLogs.count();
  }

  Future<int> countLogsThisWeek() async {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    final logs = await IsarDatabaseService.completionLogs.where().findAll();
    return logs.where((log) => log.completedAt.isAfter(sevenDaysAgo)).length;
  }
}
