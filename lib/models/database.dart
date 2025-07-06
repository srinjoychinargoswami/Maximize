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

// Task Table
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

// Event Table
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

//Reminder Table 
@DataClassName('ReminderData')
class Reminders extends Table { 
  TextColumn get id => text()(); 
  TextColumn get title => text()(); 
  TextColumn get body => text()(); 
  DateTimeColumn get scehduledTime => dateTime()(); 
  IntColumn get notificationId => integer()();

@override
Set<Column> get primaryKey => {id};

}

// Drift Database Class
@DriftDatabase(tables: [Tasks, Subtasks, Events, Classes, Reminders])
class AppDatabase extends _$AppDatabase {
  AppDatabase._() : super(_openConnection());
  static final AppDatabase instance = AppDatabase._();

  @override
  int get schemaVersion => 3; // Increment this version

  // Define migrations
 @override
MigrationStrategy get migration => MigrationStrategy(
  onUpgrade: (Migrator m, int from, int to) async {
    if (from < 3 && to >= 3) {
      // Add new columns 'customCategory' and 'color' to 'events' table when upgrading to version 3 or above
      await m.addColumn(events, events.customCategory);
      await m.addColumn(events, events.color);
    }
    // You can add more migration steps here for future versions
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

  // Task Methods
  Future<List<TaskData>> getAllTasks() async {
    try {
      return await (select(tasks)).get();
    } catch (e) {
      print('Error fetching tasks: $e');
      throw DatabaseException('Error fetching tasks: $e');
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
      );
      await (update(tasks)..where((tbl) => tbl.id.equals(task.id))).write(taskCompanion);
    } catch (e) {
      print('Error updating task: $e');
      throw DatabaseException('Error updating task: $e');
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

  // Event Methods
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
      );
      return await into(events).insert(eventCompanion); // Return the inserted event ID
    } catch ( e) {
      print('Error inserting event: $e');
      throw DatabaseException('Error inserting event: $e');
    }
  }

  Future<List<EventData>> getAllEvents() async {
    try {
      final eventsData = await (select(events)).get();
      return eventsData.map((event) {
        return EventData(
          id: event.id,
          title: event.title,
          description: event.description,
          comments: event.comments,
          startDateTime: event.startDateTime, // Directly use DateTime
          endDateTime: event.endDateTime, // Directly use DateTime
          customCategory: event.customCategory, // Include custom category
          color: event.color, // Include event color
        );
      }).toList();
    } catch (e) {
      print('Error fetching events: $e');
      throw DatabaseException('Error fetching events: $e');
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
      );

      await (update(events)..where((tbl) => tbl.id.equals(event.id))).write(eventCompanion);
    } catch (e) {
      print('Error updating event: $e');
      throw DatabaseException('Error updating event: $e');
    }
  }
  // Get All reminders
  // Reminder Methods
Future<List<ReminderData>> getAllReminders() async {
  try {
    return await select(reminders).get();
  } catch (e) {
    print('Error fetching reminders: $e');
    throw DatabaseException('Error fetching reminders: $e');
  }
}

Future<int> insertReminder(ReminderModel reminder) async {
  try {
    final reminderCompanion = RemindersCompanion(
      id: Value(reminder.id),
      title: Value(reminder.title),
      body: Value(reminder.body),
      scehduledTime: Value(reminder.scheduledTime),
      notificationId: Value(reminder.notificationId),
    );
    return await into(reminders).insert(reminderCompanion);
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
      scehduledTime: Value(reminder.scheduledTime),
      notificationId: Value(reminder.notificationId),
    );
    await (update(reminders)..where((tbl) => tbl.id.equals(reminder.id))).write(reminderCompanion);
  } catch (e) {
    print('Error updating reminder: $e');
    throw DatabaseException('Error updating reminder: $e');
  }
}

}