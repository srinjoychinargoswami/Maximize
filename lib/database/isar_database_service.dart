import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'models/isar_models.dart';

class IsarDatabaseService {
  static final IsarDatabaseService _instance =
      IsarDatabaseService._internal();
  static late Isar _isar;

  factory IsarDatabaseService() {
    return _instance;
  }

  IsarDatabaseService._internal();

  static Future<void> initialize() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open(
        [
          IsarTaskSchema,
          IsarSubtaskSchema,
          IsarEventSchema,
          IsarReminderSchema,
          IsarNoteSchema,
          IsarEnergyEntrySchema,
          IsarCompletionLogSchema,
        ],
        directory: dir.path,
        name: 'maximize',
      );
      debugPrint('[IsarDatabase] Initialized successfully');
    } catch (e) {
      debugPrint('[IsarDatabase] Initialization error: $e');
      rethrow;
    }
  }

  static Isar get db => _isar;

  // Collection accessors
  static IsarCollection<IsarTask> get tasks => _isar.isarTasks;
  static IsarCollection<IsarSubtask> get subtasks => _isar.isarSubtasks;
  static IsarCollection<IsarEvent> get events => _isar.isarEvents;
  static IsarCollection<IsarReminder> get reminders => _isar.isarReminders;
  static IsarCollection<IsarNote> get notes => _isar.isarNotes;
  static IsarCollection<IsarEnergyEntry> get energyEntries =>
      _isar.isarEnergyEntrys;
  static IsarCollection<IsarCompletionLog> get completionLogs =>
      _isar.isarCompletionLogs;

  static Future<void> close() async {
    await _isar.close();
  }
}
