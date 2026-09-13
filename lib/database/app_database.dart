import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';

part 'app_database.g.dart';

// TABLE DEFINITIONS
class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get priority => text().withDefault(const Constant('Low'))();
  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();
  TextColumn get recurrenceRule => text().nullable()();
  IntColumn get recurrenceInterval => integer().withDefault(const Constant(1))();
  TextColumn get daysOfWeek => text().nullable()();
  DateTimeColumn get recurrenceEndDate => dateTime().nullable()();
  TextColumn get parentTaskId => text().nullable()();
  IntColumn get maxOccurrences => integer().nullable()();
  BoolColumn get skipWeekends => boolean().withDefault(const Constant(false))();
  IntColumn get dayOfMonth => integer().nullable()();
  IntColumn get weekOfMonth => integer().nullable()();
  BoolColumn get reminderEnabled => boolean().withDefault(const Constant(false))();
  DateTimeColumn get reminderTime => dateTime().nullable()();
  TextColumn get reminderPreset => text().nullable()();
  IntColumn get energyRequired => integer().withDefault(const Constant(5))();
  TextColumn get pageId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {taskId};
}

class Subtasks extends Table {
  TextColumn get id => text()();
  TextColumn get subtaskId => text()();
  TextColumn get taskId => text()();
  TextColumn get title => text()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {subtaskId};
}

class Events extends Table {
  TextColumn get id => text()();
  TextColumn get eventId => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get startDateTime => dateTime()();
  DateTimeColumn get endDateTime => dateTime()();
  DateTimeColumn get date => dateTime()();
  TextColumn get customCategory => text().nullable()();
  TextColumn get color => text().nullable()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();
  TextColumn get recurrencePattern => text().nullable()();
  TextColumn get recurrenceRule => text().nullable()();
  IntColumn get recurrenceCount => integer().nullable()();
  DateTimeColumn get recurrenceEndDate => dateTime().nullable()();
  TextColumn get recurrenceExceptionDates => text().nullable()();
  TextColumn get parentEventId => text().nullable()();
  BoolColumn get reminderEnabled => boolean().withDefault(const Constant(false))();
  DateTimeColumn get reminderTime => dateTime().nullable()();
  TextColumn get reminderPreset => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {eventId};
}

class Reminders extends Table {
  TextColumn get id => text()();
  TextColumn get reminderId => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get reminderTime => dateTime().nullable()();
  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();
  TextColumn get recurrenceRule => text().nullable()();
  IntColumn get recurrenceInterval => integer().withDefault(const Constant(1))();
  TextColumn get daysOfWeek => text().nullable()();
  DateTimeColumn get recurrenceEndDate => dateTime().nullable()();
  TextColumn get parentReminderId => text().nullable()();
  IntColumn get maxOccurrences => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {reminderId};
}

class Notes extends Table {
  TextColumn get id => text()();
  TextColumn get noteId => text()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {noteId};
}

class EnergyEntries extends Table {
  TextColumn get id => text()();
  TextColumn get entryId => text()();
  DateTimeColumn get timestamp => dateTime()();
  IntColumn get energyLevel => integer()();
  TextColumn get moodTags => text().nullable()();
  TextColumn get privacyContext => text().nullable()();
  TextColumn get location => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {entryId};
}

class CompletionLogs extends Table {
  TextColumn get id => text()();
  TextColumn get logId => text()();
  TextColumn get taskId => text().nullable()();
  TextColumn get taskTitle => text()();
  TextColumn get description => text().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get priority => text().nullable()();
  DateTimeColumn get completedAt => dateTime()();
  BoolColumn get isSubtask => boolean().withDefault(const Constant(false))();
  TextColumn get parentTaskTitle => text().nullable()();
  IntColumn get energyLevel => integer().nullable()();
  TextColumn get moodTags => text().nullable()();
  TextColumn get privacyContext => text().nullable()();
  TextColumn get location => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {logId};
}

@DriftDatabase(tables: [
  Tasks,
  Subtasks,
  Events,
  Reminders,
  Notes,
  EnergyEntries,
  CompletionLogs,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (m, from, to) async {
        debugPrint('[Database] Upgrading schema from $from to $to - preserving existing data');
        // Don't delete tables - preserve existing data on web
        // Only create new tables if they don't exist
      },
      onCreate: (m) async {
        debugPrint('[Database] Creating new database');
        await m.createAll();
      },
    );
  }

  /// Platform-specific database connection
  /// - Web: IndexedDB (bigger storage, ~500MB-1GB quota) via SQLite WASM
  /// - Native: SQLite (fast, native filesystem)
  static QueryExecutor _openConnection() {
    if (kIsWeb) {
      // WEB: Use IndexedDB backend (default for drift_flutter on web)
      // SQLite compiled to WASM runs in IndexedDB for persistent storage
      return driftDatabase(
        name: 'maximize_db',
        web: DriftWebOptions(
          sqlite3Wasm: Uri.parse('sqlite3.wasm'),
          driftWorker: Uri.parse('drift_worker.js'),
        ),
      );
    } else {
      // NATIVE: Use SQLite with native file system
      return driftDatabase(
        name: 'maximize_db',
      );
    }
  }
}
