import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kinetic/database/app_database.dart';
import 'package:kinetic/models/import_result.dart';

class ImportService {
  final AppDatabase _database;

  ImportService(this._database);

  /// Import data from JSON content
  Future<ImportResult> importFromJSON(String jsonContent) async {
    try {
      // Parse JSON
      Map<String, dynamic> data = jsonDecode(jsonContent);

      // Validate structure
      if (!data.containsKey('tasks') && !data.containsKey('events')) {
        throw Exception('Invalid backup format: missing tasks or events');
      }

      int tasksImported = 0;
      int eventsImported = 0;
      int remindersImported = 0;
      int notesImported = 0;
      int energyEntriesImported = 0;
      int completionLogsImported = 0;

      // Import tasks
      if (data.containsKey('tasks') && data['tasks'] is List) {
        for (var taskJson in data['tasks']) {
          try {
            final task = _jsonToTask(taskJson);
            await _database.into(_database.tasks).insert(task);
            tasksImported++;
          } catch (e) {
            debugPrint('[ImportService] Error importing task: $e');
          }
        }
      }

      // Import events
      if (data.containsKey('events') && data['events'] is List) {
        for (var eventJson in data['events']) {
          try {
            final event = _jsonToEvent(eventJson);
            await _database.into(_database.events).insert(event);
            eventsImported++;
          } catch (e) {
            debugPrint('[ImportService] Error importing event: $e');
          }
        }
      }

      // Import reminders
      if (data.containsKey('reminders') && data['reminders'] is List) {
        for (var reminderJson in data['reminders']) {
          try {
            final reminder = _jsonToReminder(reminderJson);
            await _database.into(_database.reminders).insert(reminder);
            remindersImported++;
          } catch (e) {
            debugPrint('[ImportService] Error importing reminder: $e');
          }
        }
      }

      // Import notes
      if (data.containsKey('notes') && data['notes'] is List) {
        for (var noteJson in data['notes']) {
          try {
            final note = _jsonToNote(noteJson);
            await _database.into(_database.notes).insert(note);
            notesImported++;
          } catch (e) {
            debugPrint('[ImportService] Error importing note: $e');
          }
        }
      }

      // Import energy entries
      if (data.containsKey('energy_entries') &&
          data['energy_entries'] is List) {
        for (var entryJson in data['energy_entries']) {
          try {
            final entry = _jsonToEnergyEntry(entryJson);
            await _database.into(_database.energyEntries).insert(entry);
            energyEntriesImported++;
          } catch (e) {
            debugPrint('[ImportService] Error importing energy entry: $e');
          }
        }
      }

      // Import completion logs
      if (data.containsKey('completion_logs') &&
          data['completion_logs'] is List) {
        for (var logJson in data['completion_logs']) {
          try {
            final log = _jsonToCompletionLog(logJson);
            await _database.into(_database.completionLogs).insert(log);
            completionLogsImported++;
          } catch (e) {
            debugPrint('[ImportService] Error importing completion log: $e');
          }
        }
      }

      return ImportResult(
        success: true,
        tasksImported: tasksImported,
        eventsImported: eventsImported,
        remindersImported: remindersImported,
        notesImported: notesImported,
        energyEntriesImported: energyEntriesImported,
        completionLogsImported: completionLogsImported,
        message:
            'Successfully imported $tasksImported tasks, $eventsImported events, $remindersImported reminders, $notesImported notes, $energyEntriesImported energy entries, and $completionLogsImported completion logs',
      );
    } catch (e) {
      debugPrint('[ImportService] Error importing from JSON: $e');
      return ImportResult(
        success: false,
        error: e.toString(),
      );
    }
  }

  /// Import events from ICS (iCalendar) format
  Future<ImportResult> importFromICS(String icsContent) async {
    try {
      List<Event> events = _parseICS(icsContent);

      int eventsImported = 0;

      for (var event in events) {
        try {
          // Check if event already exists by eventId
          final existingEvents = await (_database.select(_database.events)
                ..where((e) => e.eventId.equals(event.eventId)))
              .get();

          if (existingEvents.isEmpty) {
            await _database.into(_database.events).insert(event);
            eventsImported++;
          }
        } catch (e) {
          debugPrint('[ImportService] Error importing ICS event: $e');
        }
      }

      return ImportResult(
        success: true,
        eventsImported: eventsImported,
        message:
            'Successfully imported $eventsImported events from calendar file',
      );
    } catch (e) {
      debugPrint('[ImportService] Error importing from ICS: $e');
      return ImportResult(
        success: false,
        error: e.toString(),
      );
    }
  }

  // Helper methods for JSON conversion
  Task _jsonToTask(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? '',
      taskId: json['taskId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      content: json['content'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      completed: json['completed'] ?? false,
      completedAt:
          json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      category: json['category'],
      priority: json['priority'] ?? 'Low',
      isRecurring: json['isRecurring'] ?? false,
      recurrenceRule: json['recurrenceRule'],
      recurrenceInterval: json['recurrenceInterval'] ?? 1,
      daysOfWeek: json['daysOfWeek'],
      recurrenceEndDate: json['recurrenceEndDate'] != null
          ? DateTime.parse(json['recurrenceEndDate'])
          : null,
      parentTaskId: json['parentTaskId'],
      maxOccurrences: json['maxOccurrences'],
      skipWeekends: json['skipWeekends'] ?? false,
      dayOfMonth: json['dayOfMonth'],
      weekOfMonth: json['weekOfMonth'],
      reminderEnabled: json['reminderEnabled'] ?? false,
      reminderTime: json['reminderTime'] != null
          ? DateTime.parse(json['reminderTime'])
          : null,
      reminderPreset: json['reminderPreset'],
      energyRequired: json['energyRequired'] ?? 5,
      pageId: json['pageId'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Event _jsonToEvent(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? '',
      eventId: json['eventId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      startDateTime: json['startDateTime'] != null
          ? DateTime.parse(json['startDateTime'])
          : DateTime.now(),
      endDateTime: json['endDateTime'] != null
          ? DateTime.parse(json['endDateTime'])
          : DateTime.now().add(const Duration(hours: 1)),
      scheduledDate: json['scheduledDate'] != null
          ? DateTime.parse(json['scheduledDate'])
          : DateTime.now(),
      customCategory: json['customCategory'],
      color: json['color'],
      completed: json['completed'] ?? false,
      completedAt:
          json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      isRecurring: json['isRecurring'] ?? false,
      recurrencePattern: json['recurrencePattern'],
      recurrenceRule: json['recurrenceRule'],
      recurrenceCount: json['recurrenceCount'],
      recurrenceEndDate: json['recurrenceEndDate'] != null
          ? DateTime.parse(json['recurrenceEndDate'])
          : null,
      recurrenceExceptionDates: json['recurrenceExceptionDates'],
      parentEventId: json['parentEventId'],
      reminderEnabled: json['reminderEnabled'] ?? false,
      reminderTime: json['reminderTime'] != null
          ? DateTime.parse(json['reminderTime'])
          : null,
      reminderPreset: json['reminderPreset'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Reminder _jsonToReminder(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'] ?? '',
      reminderId: json['reminderId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      reminderTime: json['reminderTime'] != null
          ? DateTime.parse(json['reminderTime'])
          : null,
      isRecurring: json['isRecurring'] ?? false,
      recurrenceRule: json['recurrenceRule'],
      recurrenceInterval: json['recurrenceInterval'] ?? 1,
      daysOfWeek: json['daysOfWeek'],
      recurrenceEndDate: json['recurrenceEndDate'] != null
          ? DateTime.parse(json['recurrenceEndDate'])
          : null,
      parentReminderId: json['parentReminderId'],
      maxOccurrences: json['maxOccurrences'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Note _jsonToNote(Map<String, dynamic> json) {
    return Note(
      id: json['id'] ?? '',
      noteId: json['noteId'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  EnergyEntry _jsonToEnergyEntry(Map<String, dynamic> json) {
    return EnergyEntry(
      id: json['id'] ?? '',
      entryId: json['entryId'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      energyLevel: json['energyLevel'] ?? 5,
      moodTags: json['moodTags'],
      privacyContext: json['privacyContext'],
      location: json['location'],
      notes: json['notes'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  CompletionLog _jsonToCompletionLog(Map<String, dynamic> json) {
    return CompletionLog(
      id: json['id'] ?? '',
      logId: json['logId'] ?? '',
      taskId: json['taskId'],
      taskTitle: json['taskTitle'] ?? '',
      description: json['description'],
      category: json['category'],
      priority: json['priority'],
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : DateTime.now(),
      isSubtask: json['isSubtask'] ?? false,
      parentTaskTitle: json['parentTaskTitle'],
      energyLevel: json['energyLevel'],
      moodTags: json['moodTags'],
      privacyContext: json['privacyContext'],
      location: json['location'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  // Helper: Parse ICS format
  List<Event> _parseICS(String icsContent) {
    List<Event> events = [];

    // Split by VEVENT blocks
    List<String> eventBlocks = icsContent.split('BEGIN:VEVENT');

    for (String block in eventBlocks) {
      if (!block.contains('END:VEVENT')) continue;

      String eventData = block.split('END:VEVENT')[0];
      Map<String, String> fields = _parseICSFields(eventData);

      try {
        String eventId =
            fields['UID']?.replaceAll('@kinetic.local', '') ?? _generateId();
        DateTime startTime =
            _parseICSDateTime(fields['DTSTART'] ?? '') ?? DateTime.now();
        DateTime endTime = _parseICSDateTime(fields['DTEND'] ?? '') ?? startTime;

        Event event = Event(
          id: eventId,
          eventId: eventId,
          title: _unescapeICSText(fields['SUMMARY'] ?? 'Untitled'),
          description: fields['DESCRIPTION'] != null
              ? _unescapeICSText(fields['DESCRIPTION']!)
              : null,
          startDateTime: startTime,
          endDateTime: endTime,
          scheduledDate: startTime,
          customCategory: null,
          color: '#FFFFFF',
          completed: false,
          isRecurring: fields['RRULE'] != null,
          recurrenceRule:
              fields['RRULE'] != null ? _parseRRULE(fields['RRULE']!) : null,
          reminderEnabled: fields.containsKey('BEGIN:VALARM'),
          reminderTime: fields.containsKey('BEGIN:VALARM')
              ? _extractReminderTime(fields, fields['DTSTART'] ?? '')
              : null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        events.add(event);
      } catch (e) {
        debugPrint('[ImportService] Warning: Could not parse event: $e');
      }
    }

    return events;
  }

  // Helper: Parse ICS field lines (KEY:VALUE format)
  Map<String, String> _parseICSFields(String icsBlock) {
    Map<String, String> fields = {};
    List<String> lines = icsBlock.split('\n');
    for (String line in lines) {
      if (line.contains(':')) {
        int colonIndex = line.indexOf(':');
        String key = line.substring(0, colonIndex).trim();
        String value = line.substring(colonIndex + 1).trim();
        fields[key] = value;
      }
    }
    return fields;
  }

  // Helper: Parse ICS datetime format (20231225T120000Z or 20231225T120000)
  DateTime? _parseICSDateTime(String icsDate) {
    if (icsDate.isEmpty) return null;

    // Remove 'Z' if present (UTC indicator)
    icsDate = icsDate.replaceAll('Z', '');

    // Parse format: 20231225T120000
    if (icsDate.length >= 15) {
      try {
        int year = int.parse(icsDate.substring(0, 4));
        int month = int.parse(icsDate.substring(4, 6));
        int day = int.parse(icsDate.substring(6, 8));
        int hour = int.parse(icsDate.substring(9, 11));
        int minute = int.parse(icsDate.substring(11, 13));
        int second = icsDate.length >= 15
            ? int.parse(icsDate.substring(13, 15))
            : 0;

        return DateTime(year, month, day, hour, minute, second);
      } catch (e) {
        debugPrint('[ImportService] Error parsing ICS datetime: $e');
        return null;
      }
    }

    return null;
  }

  // Helper: Unescape ICS text
  String _unescapeICSText(String text) {
    return text
        .replaceAll('\\\\', '\\')
        .replaceAll('\\,', ',')
        .replaceAll('\\;', ';')
        .replaceAll('\\n', '\n');
  }

  // Helper: Parse RFC 5545 RRULE
  String _parseRRULE(String rrule) {
    if (rrule.contains('FREQ=DAILY')) return 'DAILY';
    if (rrule.contains('FREQ=WEEKLY')) return 'WEEKLY';
    if (rrule.contains('FREQ=MONTHLY')) return 'MONTHLY';
    if (rrule.contains('FREQ=YEARLY')) return 'YEARLY';
    return 'DAILY';
  }

  // Helper: Extract reminder time from ICS alarm
  DateTime? _extractReminderTime(
      Map<String, String> fields, String eventStart) {
    if (!fields.containsKey('BEGIN:VALARM')) return null;

    String trigger = fields['TRIGGER'] ?? '';
    if (trigger.contains('-PT')) {
      String minutes = trigger.replaceAll(RegExp(r'[^0-9]'), '');
      if (minutes.isNotEmpty) {
        DateTime? eventTime = _parseICSDateTime(eventStart);
        if (eventTime != null) {
          return eventTime.subtract(Duration(minutes: int.parse(minutes)));
        }
      }
    }

    return null;
  }

  // Helper: Generate unique ID
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
