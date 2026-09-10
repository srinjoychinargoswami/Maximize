import 'package:maximize/database/isar_database_service.dart';
import 'package:maximize/database/daos/task_dao.dart';
import 'package:maximize/database/daos/subtask_dao.dart';
import 'package:maximize/database/daos/event_dao.dart';
import 'package:maximize/database/daos/reminder_dao.dart';
import 'package:maximize/database/daos/note_dao.dart';
import 'package:maximize/database/daos/energy_entry_dao.dart';
import 'package:maximize/database/daos/completion_log_dao.dart';
import 'package:maximize/database/converters/task_converter.dart';
import 'package:maximize/database/converters/subtask_converter.dart';
import 'package:maximize/database/converters/event_converter.dart';
import 'package:maximize/database/converters/reminder_converter.dart';
import 'package:maximize/database/converters/note_converter.dart';
import 'package:maximize/database/models/isar_models.dart';
import 'package:maximize/models/task_model.dart';
import 'package:maximize/models/subtask_model.dart';
import 'package:maximize/models/event_model.dart' as event_model;
import 'package:maximize/models/reminder_model.dart';
import 'package:maximize/models/note_model.dart';

/// Adapter class for backward compatibility during Isar migration
/// Provides familiar interface to Isar database from old Drift code
class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();

  static final TaskDAO _taskDao = TaskDAO();
  static final SubtaskDAO _subtaskDao = SubtaskDAO();
  static final EventDAO _eventDao = EventDAO();
  static final ReminderDAO _reminderDao = ReminderDAO();
  static final NoteDAO _noteDao = NoteDAO();
  static final EnergyEntryDAO _energyDao = EnergyEntryDAO();
  static final CompletionLogDAO _logDao = CompletionLogDAO();

  factory AppDatabase() {
    return _instance;
  }

  AppDatabase._internal();

  static AppDatabase get instance => _instance;

  // Task methods
  Future<List<TaskModel>> getAllTasks() async {
    final isarTasks = await _taskDao.getAllTasks();
    return isarTasks.map((t) => TaskConverter.fromIsar(t)).toList();
  }

  Future<TaskModel?> getTaskById(String taskId) async {
    final isarTask = await _taskDao.getTaskById(taskId);
    return isarTask != null ? TaskConverter.fromIsar(isarTask) : null;
  }

  Future<void> insertTask(TaskModel task) async {
    final isarTask = TaskConverter.toIsar(task);
    await _taskDao.insertTask(isarTask);
  }

  Future<void> updateTask(TaskModel task) async {
    final isarTask = TaskConverter.toIsar(task);
    await _taskDao.updateTask(isarTask);
  }

  Future<void> deleteTask(String taskId) async {
    await _taskDao.deleteTask(taskId);
  }

  // Event methods
  Future<List<event_model.Event>> getAllEvents() async {
    final isarEvents = await _eventDao.getAllEvents();
    return isarEvents.map((e) => EventConverter.toEventModel(e)).toList();
  }

  // Reminder methods
  Future<List<ReminderModel>> getAllReminders() async {
    final isarReminders = await _reminderDao.getAllReminders();
    return isarReminders.map((r) => ReminderConverter.toReminderModel(r)).toList();
  }

  // Note methods
  Future<List<NoteModel>> getAllNotes() async {
    final isarNotes = await _noteDao.getAllNotes();
    return isarNotes.map((n) => NoteConverter.toNoteModel(n)).toList();
  }

  // Subtask methods
  Future<List<SubtaskModel>> getAllSubtasks(String taskId) async {
    final isarSubtasks = await _subtaskDao.getSubtasksByTaskId(taskId);
    return isarSubtasks.map((s) => SubtaskConverter.fromIsar(s)).toList();
  }

  Future<SubtaskModel?> getSubtaskById(String subtaskId) async {
    final isarSubtask = await _subtaskDao.getSubtaskById(subtaskId);
    return isarSubtask != null ? SubtaskConverter.fromIsar(isarSubtask) : null;
  }

  Future<void> insertSubtask(SubtaskModel subtask) async {
    final isarSubtask = SubtaskConverter.toIsar(subtask);
    await _subtaskDao.insertSubtask(isarSubtask);
  }

  Future<void> updateSubtask(SubtaskModel subtask) async {
    final isarSubtask = SubtaskConverter.toIsar(subtask);
    await _subtaskDao.updateSubtask(isarSubtask);
  }

  Future<void> deleteSubtask(String subtaskId) async {
    await _subtaskDao.deleteSubtask(subtaskId);
  }

  // Event methods (continued)
  Future<event_model.Event?> getEventById(String eventId) async {
    final isarEvent = await _eventDao.getEventById(eventId);
    return isarEvent != null ? EventConverter.toEventModel(isarEvent) : null;
  }

  Future<void> insertEvent(event_model.Event event) async {
    final isarEvent = EventConverter.fromEventModel(event);
    await _eventDao.insertEvent(isarEvent);
  }

  Future<void> updateEvent(event_model.Event event) async {
    final isarEvent = EventConverter.fromEventModel(event);
    await _eventDao.updateEvent(isarEvent);
  }

  Future<void> deleteEvent(String eventId) async {
    await _eventDao.deleteEvent(eventId);
  }

  // Reminder methods (continued)
  Future<ReminderModel?> getReminderById(String reminderId) async {
    final isarReminder = await _reminderDao.getReminderById(reminderId);
    return isarReminder != null ? ReminderConverter.toReminderModel(isarReminder) : null;
  }

  Future<void> insertReminder(ReminderModel reminder) async {
    final isarReminder = ReminderConverter.fromReminderModel(reminder);
    await _reminderDao.insertReminder(isarReminder);
  }

  Future<void> updateReminder(ReminderModel reminder) async {
    final isarReminder = ReminderConverter.fromReminderModel(reminder);
    await _reminderDao.updateReminder(isarReminder);
  }

  Future<void> deleteReminder(String reminderId) async {
    await _reminderDao.deleteReminder(reminderId);
  }

  // Note methods (continued)
  Future<NoteModel?> getNoteById(String noteId) async {
    final isarNote = await _noteDao.getNoteById(noteId);
    return isarNote != null ? NoteConverter.toNoteModel(isarNote) : null;
  }

  Future<void> insertNote(NoteModel note) async {
    final isarNote = NoteConverter.toIsar(note);
    await _noteDao.insertNote(isarNote);
  }

  Future<void> updateNote(NoteModel note) async {
    final isarNote = NoteConverter.toIsar(note);
    await _noteDao.updateNote(isarNote);
  }

  Future<void> deleteNote(String noteId) async {
    await _noteDao.deleteNote(noteId);
  }

  // Sync methods
  Future<Map<String, dynamic>> getAllDataAsJson() async {
    final tasks = await getAllTasks();
    final subtasks = await getAllSubtasks('');
    final events = await getAllEvents();
    final reminders = await getAllReminders();
    final notes = await getAllNotes();

    return {
      'tasks': tasks.map((t) => _taskToJson(t)).toList(),
      'subtasks': subtasks.map((s) => _subtaskToJson(s)).toList(),
      'events': events.map((e) => _eventToJson(e)).toList(),
      'reminders': reminders.map((r) => _reminderToJson(r)).toList(),
      'notes': notes.map((n) => _noteToJson(n)).toList(),
    };
  }

  Future<void> insertAllFromJson(Map<String, dynamic> data) async {
    if (data['tasks'] is List) {
      for (final taskJson in data['tasks']) {
        final task = _taskFromJson(taskJson);
        if (task != null) await insertTask(task);
      }
    }
    if (data['subtasks'] is List) {
      for (final subtaskJson in data['subtasks']) {
        final subtask = _subtaskFromJson(subtaskJson);
        if (subtask != null) await insertSubtask(subtask);
      }
    }
    if (data['events'] is List) {
      for (final eventJson in data['events']) {
        final event = _eventFromJson(eventJson);
        if (event != null) await insertEvent(event);
      }
    }
    if (data['reminders'] is List) {
      for (final reminderJson in data['reminders']) {
        final reminder = _reminderFromJson(reminderJson);
        if (reminder != null) await insertReminder(reminder);
      }
    }
    if (data['notes'] is List) {
      for (final noteJson in data['notes']) {
        final note = _noteFromJson(noteJson);
        if (note != null) await insertNote(note);
      }
    }
  }

  // JSON conversion helpers
  Map<String, dynamic> _taskToJson(TaskModel task) => {
    'id': task.id,
    'title': task.title,
    'description': task.description,
    'dueDate': task.dueDate.toIso8601String(),
    'completed': task.completed,
    'category': task.category,
    'priority': task.priority,
    'customCategory': task.customCategory,
    'pageId': task.pageId,
    'day': task.day,
    'isRecurring': task.isRecurring,
    'recurrenceRule': task.recurrenceRule,
    'recurrenceInterval': task.recurrenceInterval,
    'daysOfWeek': task.daysOfWeek?.join(','),
    'recurrenceEndDate': task.recurrenceEndDate?.toIso8601String(),
    'parentTaskId': task.parentTaskId,
    'maxOccurrences': task.maxOccurrences,
    'skipWeekends': task.skipWeekends,
    'dayOfMonth': task.dayOfMonth,
    'weekOfMonth': task.weekOfMonth,
    'completedAt': task.completedAt?.toIso8601String(),
    'reminderEnabled': task.reminderEnabled,
    'reminderTime': task.reminderTime?.toIso8601String(),
    'reminderPreset': task.reminderPreset,
  };

  TaskModel? _taskFromJson(dynamic json) {
    if (json is! Map<String, dynamic>) return null;
    try {
      return TaskModel(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        description: json['description'],
        dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : DateTime.now(),
        completed: json['completed'] ?? false,
        category: json['category'],
        priority: json['priority'] ?? 'Low',
        customCategory: json['customCategory'],
        pageId: json['pageId'],
        day: json['day'],
        isRecurring: json['isRecurring'] ?? false,
        recurrenceRule: json['recurrenceRule'],
        recurrenceInterval: json['recurrenceInterval'],
        daysOfWeek: (json['daysOfWeek'] as String?)?.split(',').map(int.parse).toList(),
        recurrenceEndDate: json['recurrenceEndDate'] != null ? DateTime.parse(json['recurrenceEndDate']) : null,
        parentTaskId: json['parentTaskId'],
        maxOccurrences: json['maxOccurrences'],
        skipWeekends: json['skipWeekends'] ?? false,
        dayOfMonth: json['dayOfMonth'],
        weekOfMonth: json['weekOfMonth'],
        completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
        reminderEnabled: json['reminderEnabled'],
        reminderTime: json['reminderTime'] != null ? DateTime.parse(json['reminderTime']) : null,
        reminderPreset: json['reminderPreset'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> _subtaskToJson(SubtaskModel subtask) => {
    'id': subtask.id,
    'taskId': subtask.taskId,
    'title': subtask.title,
    'completed': subtask.completed,
    'completedAt': subtask.completedAt?.toIso8601String(),
  };

  SubtaskModel? _subtaskFromJson(dynamic json) {
    if (json is! Map<String, dynamic>) return null;
    try {
      return SubtaskModel(
        id: json['id'] ?? '',
        taskId: json['taskId'] ?? '',
        title: json['title'] ?? '',
        completed: json['completed'] ?? false,
        completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> _eventToJson(event_model.Event event) => {
    'id': event.id,
    'title': event.title,
    'description': event.description,
    'startDateTime': event.startDateTime.toIso8601String(),
    'endDateTime': event.endDateTime.toIso8601String(),
    'completed': event.completed,
  };

  event_model.Event? _eventFromJson(dynamic json) {
    if (json is! Map<String, dynamic>) return null;
    try {
      final startDateTime = json['startDateTime'] != null ? DateTime.parse(json['startDateTime']) : DateTime.now();
      return event_model.Event(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        description: json['description'],
        startDateTime: startDateTime,
        endDateTime: json['endDateTime'] != null ? DateTime.parse(json['endDateTime']) : startDateTime.add(const Duration(hours: 1)),
        date: startDateTime,
        color: json['color'] ?? '#FFFFFF',
        completed: json['completed'] ?? false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> _reminderToJson(ReminderModel reminder) => {
    'id': reminder.id,
    'title': reminder.title,
    'body': reminder.body,
    'scheduledTime': reminder.scheduledTime.toIso8601String(),
    'completed': reminder.completed,
  };

  ReminderModel? _reminderFromJson(dynamic json) {
    if (json is! Map<String, dynamic>) return null;
    try {
      return ReminderModel(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        body: json['body'] ?? '',
        scheduledTime: json['scheduledTime'] != null ? DateTime.parse(json['scheduledTime']) : DateTime.now(),
        completed: json['completed'] ?? false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> _noteToJson(NoteModel note) => {
    'id': note.id,
    'title': note.title,
    'content': note.content,
    'category': note.category,
    'isPinned': note.isPinned,
  };

  NoteModel? _noteFromJson(dynamic json) {
    if (json is! Map<String, dynamic>) return null;
    try {
      return NoteModel(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        content: json['content'] ?? '',
        category: json['category'],
        isPinned: json['isPinned'] ?? false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      return null;
    }
  }

  // Collection accessors for backward compatibility
  TaskDAO get tasksTable => _taskDao;
  SubtaskDAO get subtasksTable => _subtaskDao;
  EventDAO get eventsTable => _eventDao;
  ReminderDAO get remindersTable => _reminderDao;
  NoteDAO get notesTable => _noteDao;
  EnergyEntryDAO get energyEntriesTable => _energyDao;
  CompletionLogDAO get completionLogsTable => _logDao;

  // Isar service access
  static IsarDatabaseService get service => IsarDatabaseService();
}
