library database;

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:uuid/uuid.dart';

// Import your models
import 'package:maximize/models/task_model.dart';
import 'package:maximize/models/event_model.dart';
import 'package:maximize/models/reminder_model.dart';

part 'database.g.dart'; // This is where the generated code will be placed

// Custom Exception Types
class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);
  @override
  String toString() => "DatabaseException: $message";
}

// Task Table - Updated with recurring fields
@DataClassName('TaskData')
class Tasks extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v1())();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().nullable()();
  DateTimeColumn get dueDate => dateTime()();
  BoolColumn get completed => boolean().withDefault(Constant(false))();
  TextColumn get category => text().nullable()();
  TextColumn get priority => text().withLength(min: 1, max: 10)();
  TextColumn get customCategory => text().nullable()();
  TextColumn get pageId => text().nullable()();
  TextColumn get day => text().nullable()();
  
  // Recurring task fields
  BoolColumn get isRecurring => boolean().withDefault(Constant(false))();
  TextColumn get recurrenceRule => text().nullable()(); // daily, weekly, monthly, yearly
  IntColumn get recurrenceInterval => integer().nullable()(); // every X days/weeks/months
  TextColumn get daysOfWeek => text().nullable()(); // comma-separated list of weekdays (1-7)
  DateTimeColumn get recurrenceEndDate => dateTime().nullable()(); // end date for recurrence
  TextColumn get parentTaskId => text().nullable()(); // ID of parent recurring task
  IntColumn get maxOccurrences => integer().nullable()(); // maximum number of occurrences
  BoolColumn get skipWeekends => boolean().withDefault(Constant(false))(); // skip weekends for daily
  IntColumn get dayOfMonth => integer().nullable()(); // specific day of month for monthly
  IntColumn get weekOfMonth => integer().nullable()(); // week of month for monthly
  
  @override
  Set<Column> get primaryKey => {id};
}

// Subtask Table
@DataClassName('SubtaskData')
class Subtasks extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v1())();
  TextColumn get taskId => text().customConstraint('REFERENCES tasks(id) NOT NULL')(); // Foreign key to tasks, now NOT NULL
  TextColumn get title => text().withLength(min: 1, max: 100)();
  BoolColumn get completed => boolean().withDefault(Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// Event Table - Updated with recurring fields
@DataClassName('EventData')
class Events extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v1())();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().nullable()();
  TextColumn get comments => text().nullable()();
  DateTimeColumn get startDateTime => dateTime()(); // Store as DateTime
  DateTimeColumn get endDateTime => dateTime()(); // Store as DateTime
  TextColumn get customCategory => text().nullable()(); // New column for custom category
  TextColumn get color => text().nullable()(); // New column for event color
  
  // Recurring event fields
  BoolColumn get isRecurring => boolean().withDefault(Constant(false))();
  TextColumn get recurrenceRule => text().nullable()(); // RRULE format
  TextColumn get parentEventId => text().nullable()(); // For linking recurring instances
  TextColumn get recurrenceExceptionDates => text().nullable()(); // Comma-separated exception dates
  DateTimeColumn get recurrenceEndDate => dateTime().nullable()(); // When recurrence stops
  IntColumn get recurrenceCount => integer().nullable()(); // Number of occurrences
  
  @override
  Set<Column> get primaryKey => {id};
}

// Class Table
@DataClassName('ClassData')
class Classes extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v1())();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  DateTimeColumn get startTime => dateTime()(); // Store as DateTime
  DateTimeColumn get endTime => dateTime()(); // Store as DateTime
  TextColumn get day => text().withLength(min: 1, max: 10)();
  
  @override
  Set<Column> get primaryKey => {id};
}

// Reminder Table - Updated with recurring fields
@DataClassName('ReminderData')
class Reminders extends Table { 
  TextColumn get id => text().clientDefault(() => const Uuid().v4())(); // Use v4 for consistency
  TextColumn get title => text().withLength(min: 1, max: 200)(); // Add length constraints
  TextColumn get body => text().withLength(min: 1, max: 500)(); // Add length constraints
  DateTimeColumn get scheduledTime => dateTime()(); 
  TextColumn get notificationId => text()(); // Changed to TextColumn to match ReminderModel
  
  // Recurring reminder fields
  BoolColumn get isRecurring => boolean().withDefault(Constant(false))();
  TextColumn get recurrenceRule => text().nullable()(); // RRULE format
  TextColumn get parentReminderId => text().nullable()(); // For linking recurring instances
  TextColumn get recurrenceExceptionDates => text().nullable()(); // Comma-separated exception dates
  DateTimeColumn get recurrenceEndDate => dateTime().nullable()(); // When recurrence stops
  IntColumn get recurrenceCount => integer().nullable()(); // Number of occurrences

  @override
  Set<Column> get primaryKey => {id};
}

// Drift Database Class
@DriftDatabase(tables: [Tasks, Subtasks, Events, Classes, Reminders])
class AppDatabase extends _$AppDatabase {
  AppDatabase._() : super(_openConnection());
  static final AppDatabase instance = AppDatabase._();

  @override
  int get schemaVersion => 6; // Increment version for recurring task fields

  // Define migrations
 @override
MigrationStrategy get migration => MigrationStrategy(
  onUpgrade: (Migrator m, int from, int to) async {
    if (from < 3 && to >= 3) {
      // Add new columns 'customCategory' and 'color' to 'events' table when upgrading to version 3 or above
      await m.addColumn(events, events.customCategory);
      await m.addColumn(events, events.color);
    }
    if (from < 4 && to >= 4) {
      // Create the reminders table when upgrading to version 4
      await m.createTable(reminders);
    }
    if (from < 5 && to >= 5) {
      // Add recurring fields to events table - with error handling
      try {
        await m.addColumn(events, events.isRecurring);
      } catch (e) {
        if (!e.toString().contains('duplicate column')) rethrow;
      }
      
      try {
        await m.addColumn(events, events.recurrenceRule);
      } catch (e) {
        if (!e.toString().contains('duplicate column')) rethrow;
      }
      
      try {
        await m.addColumn(events, events.parentEventId);
      } catch (e) {
        if (!e.toString().contains('duplicate column')) rethrow;
      }
      
      try {
        await m.addColumn(events, events.recurrenceExceptionDates);
      } catch (e) {
        if (!e.toString().contains('duplicate column')) rethrow;
      }
      
      try {
        await m.addColumn(events, events.recurrenceEndDate);
      } catch (e) {
        if (!e.toString().contains('duplicate column')) rethrow;
      }
      
      try {
        await m.addColumn(events, events.recurrenceCount);
      } catch (e) {
        if (!e.toString().contains('duplicate column')) rethrow;
      }
      
      // Add recurring fields to reminders table - with error handling
      try {
        await m.addColumn(reminders, reminders.isRecurring);
      } catch (e) {
        if (!e.toString().contains('duplicate column')) rethrow;
      }
      
      try {
        await m.addColumn(reminders, reminders.recurrenceRule);
      } catch (e) {
        if (!e.toString().contains('duplicate column')) rethrow;
      }
      
      try {
        await m.addColumn(reminders, reminders.parentReminderId);
      } catch (e) {
        if (!e.toString().contains('duplicate column')) rethrow;
      }
      
      try {
        await m.addColumn(reminders, reminders.recurrenceExceptionDates);
      } catch (e) {
        if (!e.toString().contains('duplicate column')) rethrow;
      }
      
      try {
        await m.addColumn(reminders, reminders.recurrenceEndDate);
      } catch (e) {
        if (!e.toString().contains('duplicate column')) rethrow;
      }
      
      try {
        await m.addColumn(reminders, reminders.recurrenceCount);
      } catch (e) {
        if (!e.toString().contains('duplicate column')) rethrow;
      }
    }
    if (from < 6 && to >= 6) {
      // Add recurring fields to tasks table - with error handling
      try {
        await m.addColumn(tasks, tasks.isRecurring);
      } catch (e) {
        if (!e.toString().contains('duplicate column')) rethrow;
      }
      
      try {
        await m.addColumn(tasks, tasks.recurrenceRule);
      } catch (e) {
        if (!e.toString().contains('duplicate column')) rethrow;
      }
      
      try {
        await m.addColumn(tasks, tasks.recurrenceInterval);
      } catch (e) {
        if (!e.toString().contains('duplicate column')) rethrow;
      }
      
      try {
        await m.addColumn(tasks, tasks.daysOfWeek);
      } catch (e) {
        if (!e.toString().contains('duplicate column')) rethrow;
      }
      
      try {
        await m.addColumn(tasks, tasks.recurrenceEndDate);
      } catch (e) {
        if (!e.toString().contains('duplicate column')) rethrow;
      }
      
      try {
        await m.addColumn(tasks, tasks.parentTaskId);
      } catch (e) {
        if (!e.toString().contains('duplicate column')) rethrow;
      }
      
      try {
        await m.addColumn(tasks, tasks.maxOccurrences);
      } catch (e) {
        if (!e.toString().contains('duplicate column')) rethrow;
      }
      
      try {
        await m.addColumn(tasks, tasks.skipWeekends);
      } catch (e) {
        if (!e.toString().contains('duplicate column')) rethrow;
      }
      
      try {
        await m.addColumn(tasks, tasks.dayOfMonth);
      } catch (e) {
        if (!e.toString().contains('duplicate column')) rethrow;
      }
      
      try {
        await m.addColumn(tasks, tasks.weekOfMonth);
      } catch (e) {
        if (!e.toString().contains('duplicate column')) rethrow;
      }
    }
  },
);

  // Open the database connection
  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(path.join(dbFolder.path, 'maximize.db'));
      return NativeDatabase(file);
    });
  }

  // Task Methods - Updated with recurring support
  Future<List<TaskData>> getAllTasks() async {
    try {
      return await (select(tasks)).get();
    } catch (e) {
      print('Error fetching tasks: $e');
      throw DatabaseException('Error fetching tasks: $e');
    }
  }

  // Get only base tasks (non-recurring instances)
  Future<List<TaskData>> getBaseTasks() async {
    try {
      final tasksData = await (select(tasks)..where((tbl) => tbl.parentTaskId.isNull())).get();
      return tasksData;
    } catch (e) {
      print('Error fetching base tasks: $e');
      throw DatabaseException('Error fetching base tasks: $e');
    }
  }

  // Get recurring tasks only
  Future<List<TaskData>> getRecurringTasks() async {
    try {
      final tasksData = await (select(tasks)..where((tbl) => tbl.isRecurring.equals(true))).get();
      return tasksData;
    } catch (e) {
      print('Error fetching recurring tasks: $e');
      throw DatabaseException('Error fetching recurring tasks: $e');
    }
  }

  // Get tasks in a date range (useful for dashboard views)
  Future<List<TaskData>> getTasksInRange(DateTime start, DateTime end) async {
    try {
      final tasksData = await (select(tasks)..where((tbl) => 
        tbl.dueDate.isBetweenValues(start, end))).get();
      return tasksData;
    } catch (e) {
      print('Error fetching tasks in range: $e');
      throw DatabaseException('Error fetching tasks in range: $e');
    }
  }

  Future<int> insertTask(TaskModel task) async {
    try {
      final taskCompanion = TasksCompanion(
        id: Value(task.id),
        name: Value(task.name),
        title: Value(task.title),
        description: Value(task.description),
        dueDate: Value(task.dueDate),
        completed: Value(task.completed),
        category: Value(task.category),
        priority: Value(task.priority),
        customCategory: Value(task.customCategory),
        pageId: Value(task.pageId),
        day: Value(task.day),
        // Recurring fields
        isRecurring: Value(task.isRecurring),
        recurrenceRule: task.recurrenceRule != null ? Value(task.recurrenceRule) : const Value.absent(),
        recurrenceInterval: task.recurrenceInterval != null ? Value(task.recurrenceInterval) : const Value.absent(),
        daysOfWeek: task.daysOfWeek != null ? Value(task.daysOfWeek!.join(',')) : const Value.absent(),
        recurrenceEndDate: task.recurrenceEndDate != null ? Value(task.recurrenceEndDate) : const Value.absent(),
        parentTaskId: task.parentTaskId != null ? Value(task.parentTaskId) : const Value.absent(),
        maxOccurrences: task.maxOccurrences != null ? Value(task.maxOccurrences) : const Value.absent(),
        skipWeekends: Value(task.skipWeekends),
        dayOfMonth: task.dayOfMonth != null ? Value(task.dayOfMonth) : const Value.absent(),
        weekOfMonth: task.weekOfMonth != null ? Value(task.weekOfMonth) : const Value.absent(),
      );
      return await into(tasks).insert(taskCompanion); // Return the inserted task ID
    } catch (e) {
      print('Error inserting task: $e');
      throw DatabaseException('Error inserting task: $e');
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await (delete(tasks)..where((tbl) => tbl.id.equals(id))).go();
    } catch (e) {
      print('Error deleting task: $e');
      throw DatabaseException('Error deleting task: $e');
    }
  }

  // Delete all instances of a recurring task series
  Future<void> deleteTaskSeries(String parentTaskId) async {
    try {
      await (delete(tasks)..where((tbl) => 
        tbl.id.equals(parentTaskId) | tbl.parentTaskId.equals(parentTaskId))).go();
    } catch (e) {
      print('Error deleting task series: $e');
      throw DatabaseException('Error deleting task series: $e');
    }
  }

  Future<void> updateTask(TaskModel task) async {
    try {
      final taskCompanion = TasksCompanion(
        id: Value(task.id),
        name: Value(task.name),
        title: Value(task.title),
        description: Value(task.description),
        dueDate: Value(task.dueDate),
        completed: Value(task.completed),
        category: Value(task.category),
        priority: Value(task.priority),
        customCategory: Value(task.customCategory),
        pageId: Value(task.pageId),
        day: Value(task.day),
        // Recurring fields
        isRecurring: Value(task.isRecurring),
        recurrenceRule: task.recurrenceRule != null ? Value(task.recurrenceRule) : const Value.absent(),
        recurrenceInterval: task.recurrenceInterval != null ? Value(task.recurrenceInterval) : const Value.absent(),
        daysOfWeek: task.daysOfWeek != null ? Value(task.daysOfWeek!.join(',')) : const Value.absent(),
        recurrenceEndDate: task.recurrenceEndDate != null ? Value(task.recurrenceEndDate) : const Value.absent(),
        parentTaskId: task.parentTaskId != null ? Value(task.parentTaskId) : const Value.absent(),
        maxOccurrences: task.maxOccurrences != null ? Value(task.maxOccurrences) : const Value.absent(),
        skipWeekends: Value(task.skipWeekends),
        dayOfMonth: task.dayOfMonth != null ? Value(task.dayOfMonth) : const Value.absent(),
        weekOfMonth: task.weekOfMonth != null ? Value(task.weekOfMonth) : const Value.absent(),
      );
      await (update(tasks)..where((tbl) => tbl.id.equals(task.id))).write(taskCompanion);
    } catch (e) {
      print('Error updating task: $e');
      throw DatabaseException('Error updating task: $e');
    }
  }

  // Update all future instances of a recurring task
  Future<void> updateRecurringTaskSeries({
    required String parentTaskId,
    String? title,
    String? name,
    String? description,
    String? category,
    String? priority,
    String? customCategory,
    bool updateFutureOnly = true,
  }) async {
    try {
      final updateQuery = update(tasks)..where((tbl) => tbl.parentTaskId.equals(parentTaskId));
      
      if (updateFutureOnly) {
        updateQuery.where((tbl) => tbl.dueDate.isBiggerThanValue(DateTime.now()));
      }

      final companion = TasksCompanion(
        title: title != null ? Value(title) : const Value.absent(),
        name: name != null ? Value(name) : const Value.absent(),
        description: description != null ? Value(description) : const Value.absent(),
        category: category != null ? Value(category) : const Value.absent(),
        priority: priority != null ? Value(priority) : const Value.absent(),
        customCategory: customCategory != null ? Value(customCategory) : const Value.absent(),
      );

      await updateQuery.write(companion);
    } catch (e) {
      print('Error updating recurring task series: $e');
      throw DatabaseException('Error updating recurring task series: $e');
    }
  }

  // Subtask Methods
  Future<List<SubtaskModel>> getAllSubtasks(String taskId) async {
    try {
      final subtaskDataList = await (select(subtasks)..where((tbl) => tbl.taskId.equals(taskId))).get();
      return subtaskDataList.map((subtaskData) {
        return SubtaskModel(
          id: subtaskData.id,
          taskId: subtaskData.taskId,
          title: subtaskData.title,
          completed: subtaskData.completed,
        );
      }).toList();
    } catch (e) {
      print('Error fetching subtasks: $e');
      throw DatabaseException('Error fetching subtasks: $e');
    }
  }

  Future<int> insertSubtask(SubtaskModel subtask) async {
    try {
      final subtaskCompanion = SubtasksCompanion(
        id: Value(subtask.id),
        taskId: Value(subtask.taskId),
        title: Value(subtask.title),
        completed: Value(subtask.completed),
      );
      return await into(subtasks).insert(subtaskCompanion); // Return the inserted subtask ID
    } catch (e) {
      print('Error inserting subtask: $e');
      throw DatabaseException('Error inserting subtask: $e');
    }
  }

  Future<void> deleteSubtask(String id) async {
    try {
      await (delete(subtasks)..where((tbl) => tbl.id.equals(id))).go();
    } catch (e) {
      print('Error deleting subtask: $e');
      throw DatabaseException('Error deleting subtask: $e');
    }
  }

  Future<void> updateSubtask(SubtaskModel subtask) async {
    try {
      final subtaskCompanion = SubtasksCompanion(
        id: Value(subtask.id),
        taskId: Value(subtask.taskId),
        title: Value(subtask.title),
        completed: Value(subtask.completed),
      );
      await (update(subtasks)..where((tbl) => tbl.id.equals(subtask.id))).write(subtaskCompanion);
    } catch (e) {
      print('Error updating subtask: $e');
      throw DatabaseException('Error updating subtask: $e');
    }
  }

  // Event Methods - Updated with recurring support
  Future<int> insertEvent(Event event) async {
    try {
      final eventCompanion = EventsCompanion(
        id: Value(event.id),
        title: Value(event.title),
        description: event.description != null ? Value(event.description) : const Value.absent(),
        comments: event.comments != null ? Value(event.comments) : const Value.absent(),
        startDateTime: Value(event.startDateTime), // Store as DateTime
        endDateTime: Value(event.endDateTime), // Store as DateTime
        customCategory: Value(event.customCategory), // Store custom category
        color: Value(event.color), // Store event color
        isRecurring: Value(event.isRecurring),
        recurrenceRule: event.recurrenceRule != null ? Value(event.recurrenceRule) : const Value.absent(),
        parentEventId: event.parentEventId != null ? Value(event.parentEventId) : const Value.absent(),
        recurrenceExceptionDates: event.recurrenceExceptionDates != null 
            ? Value(event.recurrenceExceptionDates!.map((d) => d.toIso8601String()).join(','))
            : const Value.absent(),
        recurrenceEndDate: event.recurrenceEndDate != null ? Value(event.recurrenceEndDate) : const Value.absent(),
        recurrenceCount: event.recurrenceCount != null ? Value(event.recurrenceCount) : const Value.absent(),
      );
      return await into(events).insert(eventCompanion); // Return the inserted event ID
    } catch (e) {
      print('Error inserting event: $e');
      throw DatabaseException('Error inserting event: $e');
    }
  }

  Future<List<EventData>> getAllEvents() async {
    try {
      final eventsData = await (select(events)).get();
      return eventsData;
    } catch (e) {
      print('Error fetching events: $e');
      throw DatabaseException('Error fetching events: $e');
    }
  }

  // Get only base events (non-recurring instances)
  Future<List<EventData>> getBaseEvents() async {
    try {
      final eventsData = await (select(events)..where((tbl) => tbl.parentEventId.isNull())).get();
      return eventsData;
    } catch (e) {
      print('Error fetching base events: $e');
      throw DatabaseException('Error fetching base events: $e');
    }
  }

  // Get recurring events only
  Future<List<EventData>> getRecurringEvents() async {
    try {
      final eventsData = await (select(events)..where((tbl) => tbl.isRecurring.equals(true))).get();
      return eventsData;
    } catch (e) {
      print('Error fetching recurring events: $e');
      throw DatabaseException('Error fetching recurring events: $e');
    }
  }

  Future<void> deleteEvent(String id) async {
    try {
      await (delete(events)..where((tbl) => tbl.id.equals(id))).go();
    } catch (e) {
      print('Error deleting event: $e');
      throw DatabaseException('Error deleting event: $e');
    }
  }

  Future<void> updateEvent(Event event) async {
    try {
      if (event.id.isEmpty) {
        throw DatabaseException('Event ID is required');
      }

      final eventCompanion = EventsCompanion(
        id: Value(event.id),
        title: Value(event.title),
        description: event.description != null ? Value(event.description) : const Value.absent(),
        comments: event.comments != null ? Value(event.comments) : const Value.absent(),
        startDateTime: Value(event.startDateTime), // Store as DateTime
        endDateTime: Value(event.endDateTime), // Store as DateTime
        customCategory: Value(event.customCategory), // Update custom category
        color: Value(event.color), // Update event color
        isRecurring: Value(event.isRecurring),
        recurrenceRule: event.recurrenceRule != null ? Value(event.recurrenceRule) : const Value.absent(),
        parentEventId: event.parentEventId != null ? Value(event.parentEventId) : const Value.absent(),
        recurrenceExceptionDates: event.recurrenceExceptionDates != null 
            ? Value(event.recurrenceExceptionDates!.map((d) => d.toIso8601String()).join(','))
            : const Value.absent(),
        recurrenceEndDate: event.recurrenceEndDate != null ? Value(event.recurrenceEndDate) : const Value.absent(),
        recurrenceCount: event.recurrenceCount != null ? Value(event.recurrenceCount) : const Value.absent(),
      );

      await (update(events)..where((tbl) => tbl.id.equals(event.id))).write(eventCompanion);
    } catch (e) {
      print('Error updating event: $e');
      throw DatabaseException('Error updating event: $e');
    }
  }

  // Reminder Methods - Updated with recurring support
  Future<List<ReminderData>> getAllReminders() async {
    try {
      return await select(reminders).get();
    } catch (e) {
      print('Error fetching reminders: $e');
      throw DatabaseException('Error fetching reminders: $e');
    }
  }

  // Get only base reminders (non-recurring instances)
  Future<List<ReminderData>> getBaseReminders() async {
    try {
      final reminderData = await (select(reminders)..where((tbl) => tbl.parentReminderId.isNull())).get();
      return reminderData;
    } catch (e) {
      print('Error fetching base reminders: $e');
      throw DatabaseException('Error fetching base reminders: $e');
    }
  }

  // Get recurring reminders only
  Future<List<ReminderData>> getRecurringReminders() async {
    try {
      final reminderData = await (select(reminders)..where((tbl) => tbl.isRecurring.equals(true))).get();
      return reminderData;
    } catch (e) {
      print('Error fetching recurring reminders: $e');
      throw DatabaseException('Error fetching recurring reminders: $e');
    }
  }

  Future<void> insertReminder(ReminderModel reminder) async {
    try {
      final reminderCompanion = RemindersCompanion(
        id: Value(reminder.id),
        title: Value(reminder.title),
        body: Value(reminder.body),
        scheduledTime: Value(reminder.scheduledTime),
        notificationId: Value(reminder.notificationId), // Now String type
        isRecurring: Value(reminder.isRecurring),
        recurrenceRule: reminder.recurrenceRule != null ? Value(reminder.recurrenceRule) : const Value.absent(),
        parentReminderId: reminder.parentReminderId != null ? Value(reminder.parentReminderId) : const Value.absent(),
        recurrenceExceptionDates: reminder.recurrenceExceptionDates != null 
            ? Value(reminder.recurrenceExceptionDates!.map((d) => d.toIso8601String()).join(','))
            : const Value.absent(),
        recurrenceEndDate: reminder.recurrenceEndDate != null ? Value(reminder.recurrenceEndDate) : const Value.absent(),
        recurrenceCount: reminder.recurrenceCount != null ? Value(reminder.recurrenceCount) : const Value.absent(),
      );
      await into(reminders).insert(reminderCompanion);
    } catch (e) {
      print('Error inserting reminder: $e');
      throw DatabaseException('Error inserting reminder: $e');
    }
  }

  Future<void> deleteReminder(String id) async {
    try {
      await (delete(reminders)..where((tbl) => tbl.id.equals(id))).go();
    } catch (e) {
      print('Error deleting reminder: $e');
      throw DatabaseException('Error deleting reminder: $e');
    }
  }

  Future<void> updateReminder(ReminderModel reminder) async {
    try {
      final reminderCompanion = RemindersCompanion(
        id: Value(reminder.id),
        title: Value(reminder.title),
        body: Value(reminder.body),
        scheduledTime: Value(reminder.scheduledTime),
        notificationId: Value(reminder.notificationId), // Now String type
        isRecurring: Value(reminder.isRecurring),
        recurrenceRule: reminder.recurrenceRule != null ? Value(reminder.recurrenceRule) : const Value.absent(),
        parentReminderId: reminder.parentReminderId != null ? Value(reminder.parentReminderId) : const Value.absent(),
        recurrenceExceptionDates: reminder.recurrenceExceptionDates != null 
            ? Value(reminder.recurrenceExceptionDates!.map((d) => d.toIso8601String()).join(','))
            : const Value.absent(),
        recurrenceEndDate: reminder.recurrenceEndDate != null ? Value(reminder.recurrenceEndDate) : const Value.absent(),
        recurrenceCount: reminder.recurrenceCount != null ? Value(reminder.recurrenceCount) : const Value.absent(),
      );
      await (update(reminders)..where((tbl) => tbl.id.equals(reminder.id))).write(reminderCompanion);
    } catch (e) {
      print('Error updating reminder: $e');
      throw DatabaseException('Error updating reminder: $e');
    }
  }

  // Utility methods for recurring items
  
  // Delete all instances of a recurring event series
  Future<void> deleteEventSeries(String parentEventId) async {
    try {
      await (delete(events)..where((tbl) => 
        tbl.id.equals(parentEventId) | tbl.parentEventId.equals(parentEventId))).go();
    } catch (e) {
      print('Error deleting event series: $e');
      throw DatabaseException('Error deleting event series: $e');
    }
  }

  // Delete all instances of a recurring reminder series
  Future<void> deleteReminderSeries(String parentReminderId) async {
    try {
      await (delete(reminders)..where((tbl) => 
        tbl.id.equals(parentReminderId) | tbl.parentReminderId.equals(parentReminderId))).go();
    } catch (e) {
      print('Error deleting reminder series: $e');
      throw DatabaseException('Error deleting reminder series: $e');
    }
  }

  // Get events in a date range (useful for calendar views)
  Future<List<EventData>> getEventsInRange(DateTime start, DateTime end) async {
    try {
      final eventsData = await (select(events)..where((tbl) => 
        tbl.startDateTime.isBetweenValues(start, end))).get();
      return eventsData;
    } catch (e) {
      print('Error fetching events in range: $e');
      throw DatabaseException('Error fetching events in range: $e');
    }
  }

  // Get reminders in a date range
  Future<List<ReminderData>> getRemindersInRange(DateTime start, DateTime end) async {
    try {
      final reminderData = await (select(reminders)..where((tbl) => 
        tbl.scheduledTime.isBetweenValues(start, end))).get();
      return reminderData;
    } catch (e) {
      print('Error fetching reminders in range: $e');
      throw DatabaseException('Error fetching reminders in range: $e');
    }
  }
}
