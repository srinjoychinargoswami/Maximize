import 'package:maximize/database/daos/task_dao.dart';
import 'package:maximize/database/converters/task_converter.dart';
import 'package:maximize/services/completion_log_service.dart';

class MetricsService {
  static final MetricsService _instance = MetricsService._();
  factory MetricsService() => _instance;
  MetricsService._();

  final _taskDao = TaskDAO();
  final completionLog = CompletionLogService();

  Future<int> getTotalDone() async {
    try {
      final logs = await completionLog.getAllCompletions();
      return logs.length;
    } catch (e) {
      print('Error fetching total done: $e');
      return 0;
    }
  }

  Future<int> getThisWeekDone() async {
    try {
      final logs = await completionLog.getThisWeekCompletions();
      return logs.length;
    } catch (e) {
      print('Error fetching this week done: $e');
      return 0;
    }
  }

  Future<int> getStreak() async {
    try {
      final logs = await completionLog.getAllCompletions();
      if (logs.isEmpty) return 0;

      logs.sort((a, b) => b.completedAt.compareTo(a.completedAt));

      int streak = 0;
      DateTime? lastDate;

      for (final log in logs) {
        final logDate = DateTime(log.completedAt.year, log.completedAt.month, log.completedAt.day);

        if (lastDate == null) {
          lastDate = logDate;
          streak = 1;
        } else if (logDate.add(Duration(days: streak)) == lastDate) {
          streak++;
        } else {
          break;
        }
      }

      return streak;
    } catch (e) {
      print('Error fetching streak: $e');
      return 0;
    }
  }

  Future<int> getTotalTasks() async {
    try {
      final tasks = await _taskDao.getAllTasks();
      return tasks.length;
    } catch (e) {
      print('Error fetching total tasks: $e');
      return 0;
    }
  }

  Future<int> getCompletedTasks() async {
    try {
      final tasks = await _taskDao.getAllTasks();
      return tasks.where((t) => t.completed).length;
    } catch (e) {
      print('Error fetching completed tasks: $e');
      return 0;
    }
  }

  Future<int> getUncompletedTasks() async {
    try {
      final tasks = await _taskDao.getAllTasks();
      return tasks.where((t) => !t.completed).length;
    } catch (e) {
      print('Error fetching uncompleted tasks: $e');
      return 0;
    }
  }

  Future<String> getPeakCompletionWindow() async {
    try {
      final hourCounts = await completionLog.getCompletionsByHour();

      int maxCount = 0;
      int peakHour = 0;

      for (int i = 0; i < 24; i++) {
        if ((hourCounts[i] ?? 0) > maxCount) {
          maxCount = hourCounts[i] ?? 0;
          peakHour = i;
        }
      }

      if (maxCount == 0) return "";
      return _formatHourRange(peakHour);
    } catch (e) {
      print('Error fetching peak completion window: $e');
      return "";
    }
  }

  Future<double> getAverageEnergyAtCompletion() async {
    try {
      final logs = await completionLog.getAllCompletions();
      final withEnergy = logs.where((l) => l.energyLevel != null).toList();

      if (withEnergy.isEmpty) return 0;
      return withEnergy.fold(0, (sum, log) => sum + (log.energyLevel ?? 0)) / withEnergy.length;
    } catch (e) {
      print('Error fetching average energy: $e');
      return 0;
    }
  }

  String _formatHourRange(int hour) {
    String formatHour(int h) {
      if (h == 0) return "12am";
      if (h < 12) return "${h}am";
      if (h == 12) return "12pm";
      return "${h - 12}pm";
    }

    return "${formatHour(hour)}-${formatHour(hour + 1)}";
  }
}
