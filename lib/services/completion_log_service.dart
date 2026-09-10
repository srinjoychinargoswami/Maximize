import 'package:uuid/uuid.dart';
import 'package:maximize/database/daos/completion_log_dao.dart';
import 'package:maximize/database/converters/completion_log_converter.dart';
import 'package:maximize/models/database.dart';

class CompletionLogService {
  static final CompletionLogService _instance = CompletionLogService._();
  factory CompletionLogService() => _instance;
  CompletionLogService._();

  final _dao = CompletionLogDAO();

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
    try {
      final now = DateTime.now();
      final logData = CompletionLogData(
        id: const Uuid().v1(),
        taskId: taskId,
        taskTitle: taskTitle,
        description: description,
        category: category,
        priority: priority,
        isSubtask: isSubtask,
        parentTaskTitle: parentTaskTitle,
        completedAt: now,
        energyLevel: energyLevel,
        moodTags: moodTags,
        privacyContext: privacyContext,
        location: location,
        createdAt: now,
        updatedAt: now,
      );

      final isarLog = CompletionLogConverter.fromCompletionLogData(logData);
      await _dao.insertCompletionLog(isarLog);
    } catch (e) {
      print('Error logging completion: $e');
      rethrow;
    }
  }

  Future<List<CompletionLogData>> getAllCompletions() async {
    try {
      final logs = await _dao.getAllCompletionLogs();
      return logs.map((l) => CompletionLogConverter.toCompletionLogData(l)).toList();
    } catch (e) {
      print('Error fetching all completions: $e');
      return [];
    }
  }

  Future<List<CompletionLogData>> getThisWeekCompletions() async {
    try {
      final logs = await _dao.getCompletionLogsThisWeek();
      return logs.map((l) => CompletionLogConverter.toCompletionLogData(l)).toList();
    } catch (e) {
      print('Error fetching this week completions: $e');
      return [];
    }
  }

  Future<void> clearAllCompletionLogs() async {
    try {
      await _dao.deleteAllCompletionLogs();
    } catch (e) {
      print('Error clearing completion logs: $e');
      rethrow;
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
      print('Error calculating completions by hour: $e');
      return {};
    }
  }
}
