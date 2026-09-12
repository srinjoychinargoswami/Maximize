import 'package:kinetic/database/app_database.dart';
import 'package:kinetic/models/completion_log_model.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart';

class CompletionLogService {
  final AppDatabase _database;

  CompletionLogService(this._database);

  Future<void> logCompletion({
    required String taskId,
    required String taskTitle,
    String? description,
    String? category,
    String? priority,
    bool isSubtask = false,
    String? parentTaskTitle,
    int? energyLevel,
    String? moodTags,
    String? privacyContext,
    String? location,
  }) async {
    final logId = const Uuid().v4();
    final now = DateTime.now();

    try {
      await _database.into(_database.completionLogs).insert(
        CompletionLogsCompanion(
          id: Value(logId),
          logId: Value(logId),
          taskId: Value(taskId),
          taskTitle: Value(taskTitle),
          description: Value(description),
          category: Value(category),
          priority: Value(priority),
          completedAt: Value(now),
          isSubtask: Value(isSubtask),
          parentTaskTitle: Value(parentTaskTitle),
          energyLevel: Value(energyLevel),
          moodTags: Value(moodTags),
          privacyContext: Value(privacyContext),
          location: Value(location),
          createdAt: Value(now),
        ),
      );
    } catch (e) {
      debugPrint('Error logging completion: $e');
    }
  }

  Future<List<CompletionLogModel>> getAllCompletions() async {
    try {
      final rows = await _database.select(_database.completionLogs).get();
      return rows.map(_rowToModel).toList();
    } catch (e) {
      debugPrint('Error fetching all completions: $e');
      return [];
    }
  }

  Future<List<CompletionLogModel>> getThisWeekCompletions() async {
    try {
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));
      final rows = await _database.select(_database.completionLogs).get();
      return rows
          .where((r) => r.completedAt.isAfter(weekAgo) && r.completedAt.isBefore(now))
          .map(_rowToModel)
          .toList();
    } catch (e) {
      debugPrint('Error fetching this week completions: $e');
      return [];
    }
  }

  Future<void> clearAllCompletionLogs() async {
    try {
      await _database.delete(_database.completionLogs).go();
    } catch (e) {
      debugPrint('Error clearing completion logs: $e');
    }
  }

  Future<Map<int, int>> getCompletionsByHour() async {
    try {
      final logs = await getAllCompletions();
      final hourCounts = Map<int, int>.fromIterable(
        List.generate(24, (i) => i),
        value: (_) => 0,
      );

      for (final log in logs) {
        final hour = log.completedAt.hour;
        hourCounts[hour] = (hourCounts[hour] ?? 0) + 1;
      }

      return hourCounts;
    } catch (e) {
      debugPrint('Error calculating completions by hour: $e');
      return {};
    }
  }

  CompletionLogModel _rowToModel(CompletionLog row) {
    return CompletionLogModel(
      id: row.id,
      logId: row.logId,
      taskId: row.taskId,
      taskTitle: row.taskTitle,
      description: row.description,
      category: row.category,
      priority: row.priority,
      completedAt: row.completedAt,
      isSubtask: row.isSubtask,
      parentTaskTitle: row.parentTaskTitle,
      energyLevel: row.energyLevel,
      moodTags: row.moodTags,
      privacyContext: row.privacyContext,
      location: row.location,
      createdAt: row.createdAt,
    );
  }
}
