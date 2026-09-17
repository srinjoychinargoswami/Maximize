import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:kinetic/database/app_database.dart';

class ExportService {
  final AppDatabase _database;

  ExportService(this._database);

  /// Export all data as JSON
  Future<String> exportToJSON() async {
    try {
      // Fetch all data from Drift database
      final tasks = await _database.select(_database.tasks).get();
      final events = await _database.select(_database.events).get();
      final reminders = await _database.select(_database.reminders).get();
      final notes = await _database.select(_database.notes).get();
      final energyEntries = await _database.select(_database.energyEntries).get();
      final completionLogs = await _database.select(_database.completionLogs).get();

      // Create JSON structure
      Map<String, dynamic> backup = {
        'export_date': DateTime.now().toIso8601String(),
        'app_version': '1.0.1',
        'tasks': tasks.map((t) => _taskToJson(t)).toList(),
        'events': events.map((e) => _eventToJson(e)).toList(),
        'reminders': reminders.map((r) => _reminderToJson(r)).toList(),
        'notes': notes.map((n) => _noteToJson(n)).toList(),
        'energy_entries': energyEntries.map((e) => _energyEntryToJson(e)).toList(),
        'completion_logs':
            completionLogs.map((l) => _completionLogToJson(l)).toList(),
      };

      return jsonEncode(backup);
    } catch (e) {
      debugPrint('[ExportService] Error exporting to JSON: $e');
      rethrow;
    }
  }

  /// Export all data as CSV files (returns map of filename -> csv content)
  Future<Map<String, String>> exportToCSV() async {
    try {
      Map<String, String> csvFiles = {};

      final tasks = await _database.select(_database.tasks).get();
      csvFiles['tasks.csv'] = _tasksToCSV(tasks);

      final events = await _database.select(_database.events).get();
      csvFiles['events.csv'] = _eventsToCSV(events);

      final reminders = await _database.select(_database.reminders).get();
      csvFiles['reminders.csv'] = _remindersToCSV(reminders);

      final notes = await _database.select(_database.notes).get();
      csvFiles['notes.csv'] = _notesToCSV(notes);

      final energyEntries = await _database.select(_database.energyEntries).get();
      csvFiles['energy_entries.csv'] = _energyEntriesToCSV(energyEntries);

      final completionLogs =
          await _database.select(_database.completionLogs).get();
      csvFiles['completion_logs.csv'] = _completionLogsToCSV(completionLogs);

      return csvFiles;
    } catch (e) {
      debugPrint('[ExportService] Error exporting to CSV: $e');
      rethrow;
    }
  }

  /// Export events as ICS (iCalendar) format
  Future<String> exportToICS() async {
    try {
      final events = await _database.select(_database.events).get();

      StringBuffer ics = StringBuffer();
      ics.writeln('BEGIN:VCALENDAR');
      ics.writeln('VERSION:2.0');
      ics.writeln('PRODID:-//Kinetic//Kinetic Calendar//EN');
      ics.writeln('CALSCALE:GREGORIAN');
      ics.writeln('METHOD:PUBLISH');

      for (var event in events) {
        ics.writeln('BEGIN:VEVENT');
        ics.writeln('UID:${event.eventId}@kinetic.local');
        ics.writeln('DTSTAMP:${_formatICSDateTime(DateTime.now())}');
        ics.writeln('DTSTART:${_formatICSDateTime(event.startDateTime)}');
        ics.writeln('DTEND:${_formatICSDateTime(event.endDateTime)}');
        ics.writeln('SUMMARY:${_escapeICSText(event.title)}');

        if (event.description != null && event.description!.isNotEmpty) {
          ics.writeln('DESCRIPTION:${_escapeICSText(event.description!)}');
        }

        // Add reminder if exists
        if (event.reminderEnabled &&
            event.reminderTime != null &&
            event.startDateTime.isAfter(event.reminderTime!)) {
          Duration minutesBefore =
              event.startDateTime.difference(event.reminderTime!);
          ics.writeln('BEGIN:VALARM');
          ics.writeln('ACTION:DISPLAY');
          ics.writeln('TRIGGER:-PT${minutesBefore.inMinutes}M');
          ics.writeln('DESCRIPTION:${_escapeICSText(event.title)}');
          ics.writeln('END:VALARM');
        }

        // Add recurrence rule if recurring
        if (event.isRecurring && event.recurrenceRule != null) {
          String rrule = _convertToRRULE(event.recurrenceRule!);
          ics.writeln('RRULE:$rrule');
        }

        ics.writeln('END:VEVENT');
      }

      ics.writeln('END:VCALENDAR');
      return ics.toString();
    } catch (e) {
      debugPrint('[ExportService] Error exporting to ICS: $e');
      rethrow;
    }
  }

  /// Save exported file to app documents directory
  Future<String> saveExportFile(String fileContent, String filename) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$filename');
      await file.writeAsString(fileContent);
      debugPrint('[ExportService] File saved to: ${file.path}');
      return file.path;
    } catch (e) {
      debugPrint('[ExportService] Error saving file: $e');
      rethrow;
    }
  }

  // Helper methods for JSON conversion
  Map<String, dynamic> _taskToJson(Task task) {
    return {
      'id': task.id,
      'taskId': task.taskId,
      'title': task.title,
      'description': task.description,
      'content': task.content,
      'dueDate': task.dueDate?.toIso8601String(),
      'completed': task.completed,
      'completedAt': task.completedAt?.toIso8601String(),
      'category': task.category,
      'priority': task.priority,
      'isRecurring': task.isRecurring,
      'recurrenceRule': task.recurrenceRule,
      'recurrenceInterval': task.recurrenceInterval,
      'daysOfWeek': task.daysOfWeek,
      'recurrenceEndDate': task.recurrenceEndDate?.toIso8601String(),
      'parentTaskId': task.parentTaskId,
      'maxOccurrences': task.maxOccurrences,
      'skipWeekends': task.skipWeekends,
      'dayOfMonth': task.dayOfMonth,
      'weekOfMonth': task.weekOfMonth,
      'reminderEnabled': task.reminderEnabled,
      'reminderTime': task.reminderTime?.toIso8601String(),
      'reminderPreset': task.reminderPreset,
      'energyRequired': task.energyRequired,
      'pageId': task.pageId,
      'createdAt': task.createdAt.toIso8601String(),
      'updatedAt': task.updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _eventToJson(Event event) {
    return {
      'id': event.id,
      'eventId': event.eventId,
      'title': event.title,
      'description': event.description,
      'startDateTime': event.startDateTime.toIso8601String(),
      'endDateTime': event.endDateTime.toIso8601String(),
      'scheduledDate': event.scheduledDate.toIso8601String(),
      'customCategory': event.customCategory,
      'color': event.color,
      'completed': event.completed,
      'completedAt': event.completedAt?.toIso8601String(),
      'isRecurring': event.isRecurring,
      'recurrencePattern': event.recurrencePattern,
      'recurrenceRule': event.recurrenceRule,
      'recurrenceCount': event.recurrenceCount,
      'recurrenceEndDate': event.recurrenceEndDate?.toIso8601String(),
      'recurrenceExceptionDates': event.recurrenceExceptionDates,
      'parentEventId': event.parentEventId,
      'reminderEnabled': event.reminderEnabled,
      'reminderTime': event.reminderTime?.toIso8601String(),
      'reminderPreset': event.reminderPreset,
      'createdAt': event.createdAt.toIso8601String(),
      'updatedAt': event.updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _reminderToJson(Reminder reminder) {
    return {
      'id': reminder.id,
      'reminderId': reminder.reminderId,
      'title': reminder.title,
      'description': reminder.description,
      'reminderTime': reminder.reminderTime?.toIso8601String(),
      'isRecurring': reminder.isRecurring,
      'recurrenceRule': reminder.recurrenceRule,
      'recurrenceInterval': reminder.recurrenceInterval,
      'daysOfWeek': reminder.daysOfWeek,
      'recurrenceEndDate': reminder.recurrenceEndDate?.toIso8601String(),
      'parentReminderId': reminder.parentReminderId,
      'maxOccurrences': reminder.maxOccurrences,
      'createdAt': reminder.createdAt.toIso8601String(),
      'updatedAt': reminder.updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _noteToJson(Note note) {
    return {
      'id': note.id,
      'noteId': note.noteId,
      'title': note.title,
      'content': note.content,
      'createdAt': note.createdAt.toIso8601String(),
      'updatedAt': note.updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _energyEntryToJson(EnergyEntry entry) {
    return {
      'id': entry.id,
      'entryId': entry.entryId,
      'timestamp': entry.timestamp.toIso8601String(),
      'energyLevel': entry.energyLevel,
      'moodTags': entry.moodTags,
      'privacyContext': entry.privacyContext,
      'location': entry.location,
      'notes': entry.notes,
      'createdAt': entry.createdAt.toIso8601String(),
      'updatedAt': entry.updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _completionLogToJson(CompletionLog log) {
    return {
      'id': log.id,
      'logId': log.logId,
      'taskId': log.taskId,
      'taskTitle': log.taskTitle,
      'description': log.description,
      'category': log.category,
      'priority': log.priority,
      'completedAt': log.completedAt.toIso8601String(),
      'isSubtask': log.isSubtask,
      'parentTaskTitle': log.parentTaskTitle,
      'energyLevel': log.energyLevel,
      'moodTags': log.moodTags,
      'privacyContext': log.privacyContext,
      'location': log.location,
      'createdAt': log.createdAt.toIso8601String(),
    };
  }

  // Helper methods for CSV conversion
  String _tasksToCSV(List<Task> tasks) {
    StringBuffer csv = StringBuffer();
    csv.writeln(
        'id,taskId,title,description,dueDate,completed,completedAt,category,priority,isRecurring,recurrenceRule,createdAt,updatedAt');
    for (var task in tasks) {
      csv.writeln(
          '"${_escapeCsv(task.id)}","${_escapeCsv(task.taskId)}","${_escapeCsv(task.title)}","${_escapeCsv(task.description ?? '')}","${task.dueDate?.toIso8601String() ?? ''}",${task.completed},"${task.completedAt?.toIso8601String() ?? ''}","${_escapeCsv(task.category ?? '')}","${_escapeCsv(task.priority)}",${task.isRecurring},"${_escapeCsv(task.recurrenceRule ?? '')}","${task.createdAt.toIso8601String()}","${task.updatedAt.toIso8601String()}"');
    }
    return csv.toString();
  }

  String _eventsToCSV(List<Event> events) {
    StringBuffer csv = StringBuffer();
    csv.writeln(
        'eventId,title,description,startDateTime,endDateTime,customCategory,color,completed,isRecurring,recurrenceRule,createdAt,updatedAt');
    for (var event in events) {
      csv.writeln(
          '"${_escapeCsv(event.eventId)}","${_escapeCsv(event.title)}","${_escapeCsv(event.description ?? '')}","${event.startDateTime.toIso8601String()}","${event.endDateTime.toIso8601String()}","${_escapeCsv(event.customCategory ?? '')}","${_escapeCsv(event.color ?? '')}",${event.completed},${event.isRecurring},"${_escapeCsv(event.recurrenceRule ?? '')}","${event.createdAt.toIso8601String()}","${event.updatedAt.toIso8601String()}"');
    }
    return csv.toString();
  }

  String _remindersToCSV(List<Reminder> reminders) {
    StringBuffer csv = StringBuffer();
    csv.writeln(
        'reminderId,title,description,reminderTime,isRecurring,recurrenceRule,createdAt,updatedAt');
    for (var reminder in reminders) {
      csv.writeln(
          '"${_escapeCsv(reminder.reminderId)}","${_escapeCsv(reminder.title)}","${_escapeCsv(reminder.description ?? '')}","${reminder.reminderTime?.toIso8601String() ?? ''}",${reminder.isRecurring},"${_escapeCsv(reminder.recurrenceRule ?? '')}","${reminder.createdAt.toIso8601String()}","${reminder.updatedAt.toIso8601String()}"');
    }
    return csv.toString();
  }

  String _notesToCSV(List<Note> notes) {
    StringBuffer csv = StringBuffer();
    csv.writeln('noteId,title,content,createdAt,updatedAt');
    for (var note in notes) {
      csv.writeln(
          '"${_escapeCsv(note.noteId)}","${_escapeCsv(note.title)}","${_escapeCsv(note.content)}","${note.createdAt.toIso8601String()}","${note.updatedAt.toIso8601String()}"');
    }
    return csv.toString();
  }

  String _energyEntriesToCSV(List<EnergyEntry> entries) {
    StringBuffer csv = StringBuffer();
    csv.writeln(
        'entryId,timestamp,energyLevel,moodTags,privacyContext,location,notes,createdAt,updatedAt');
    for (var entry in entries) {
      csv.writeln(
          '"${_escapeCsv(entry.entryId)}","${entry.timestamp.toIso8601String()}",${entry.energyLevel},"${_escapeCsv(entry.moodTags ?? '')}","${_escapeCsv(entry.privacyContext ?? '')}","${_escapeCsv(entry.location ?? '')}","${_escapeCsv(entry.notes ?? '')}","${entry.createdAt.toIso8601String()}","${entry.updatedAt.toIso8601String()}"');
    }
    return csv.toString();
  }

  String _completionLogsToCSV(List<CompletionLog> logs) {
    StringBuffer csv = StringBuffer();
    csv.writeln(
        'logId,taskId,taskTitle,description,category,priority,completedAt,isSubtask,energyLevel,moodTags,createdAt');
    for (var log in logs) {
      csv.writeln(
          '"${_escapeCsv(log.logId)}","${_escapeCsv(log.taskId ?? '')}","${_escapeCsv(log.taskTitle)}","${_escapeCsv(log.description ?? '')}","${_escapeCsv(log.category ?? '')}","${_escapeCsv(log.priority ?? '')}","${log.completedAt.toIso8601String()}",${log.isSubtask},${log.energyLevel ?? ''},"${_escapeCsv(log.moodTags ?? '')}","${log.createdAt.toIso8601String()}"');
    }
    return csv.toString();
  }

  // Helper: Escape CSV field
  String _escapeCsv(String field) {
    return field
        .replaceAll('"', '""')
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r');
  }

  // Helper: Format datetime for ICS (format: 20231225T120000Z)
  String _formatICSDateTime(DateTime dt) {
    return '${dt.year}${dt.month.toString().padLeft(2, '0')}${dt.day.toString().padLeft(2, '0')}T${dt.hour.toString().padLeft(2, '0')}${dt.minute.toString().padLeft(2, '0')}${dt.second.toString().padLeft(2, '0')}Z';
  }

  // Helper: Escape special characters in ICS text fields
  String _escapeICSText(String text) {
    return text
        .replaceAll('\\', '\\\\')
        .replaceAll(',', '\\,')
        .replaceAll(';', '\\;')
        .replaceAll('\n', '\\n');
  }

  // Helper: Convert Kinetic recurrence rule to RFC 5545 RRULE format
  String _convertToRRULE(String rule) {
    String freq = rule.toUpperCase();
    if (freq == 'DAILY') return 'FREQ=DAILY;INTERVAL=1';
    if (freq == 'WEEKLY') return 'FREQ=WEEKLY;INTERVAL=1';
    if (freq == 'MONTHLY') return 'FREQ=MONTHLY;INTERVAL=1';
    if (freq == 'YEARLY') return 'FREQ=YEARLY;INTERVAL=1';
    return 'FREQ=$freq;INTERVAL=1';
  }
}
