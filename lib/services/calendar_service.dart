import 'package:kinetic/database/app_database.dart';
import 'package:kinetic/models/event_model.dart' as models;
import 'package:kinetic/models/reminder_model.dart';
import 'package:kinetic/utils/web_persistence_helper.dart';
import 'package:drift/drift.dart' as drift;

class CalendarService {
  final AppDatabase _database;

  CalendarService(this._database);

  Future<void> removeRecurrenceException(String parentId, DateTime exceptionDate) async {
    try {
      print('Removing exception for parent: $parentId, date: $exceptionDate');

      final query = _database.select(_database.events)
        ..where((tbl) => tbl.eventId.equals(parentId));
      final eventRows = await query.get();

      if (eventRows.isEmpty) throw Exception('Parent event not found');

      final eventRow = eventRows.first;
      final exceptionsStr = eventRow.recurrenceExceptionDates ?? '';
      final exceptions = exceptionsStr.isEmpty
        ? <DateTime>[]
        : exceptionsStr.split(',').map((s) => DateTime.parse(s)).toList();

      final originalLength = exceptions.length;
      exceptions.removeWhere((ex) => _isSameDay(ex, exceptionDate));

      if (exceptions.length < originalLength) {
        final updatedRow = eventRow.copyWith(
          recurrenceExceptionDates: drift.Value(exceptions.isEmpty
            ? null
            : exceptions.map((d) => d.toIso8601String()).join(',')),
        );
        await _database.update(_database.events).replace(updatedRow);
        print('Successfully removed exception date');
      } else {
        print('Exception date not found');
      }
    } catch (e) {
      print('Error removing recurrence exception: $e');
      rethrow;
    }
  }

  Future<List<models.Event>> getEvents() async {
    try {
      final eventRows = await _database.select(_database.events).get();
      List<models.Event> events = eventRows.map((row) => _rowToEventModel(row)).toList();

      List<models.Event> expandedEvents = [];
      final now = DateTime.now();
      final futureLimit = now.add(Duration(days: 365));

      for (models.Event event in events) {
        if (event.isRecurring && event.recurrenceRule != null && event.parentEventId == null) {
          List<DateTime> occurrences = _generateRecurrenceOccurrences(
            event.startDateTime,
            event.recurrenceRule!,
            now.subtract(Duration(days: 30)),
            futureLimit,
            event.recurrenceExceptionDates,
          );

          for (DateTime occurrence in occurrences) {
            if (event.recurrenceCount != null &&
                occurrences.indexOf(occurrence) >= event.recurrenceCount!) {
              break;
            }

            if (event.recurrenceEndDate != null &&
                occurrence.isAfter(event.recurrenceEndDate!)) {
              break;
            }

            Duration eventDuration = event.endDateTime.difference(event.startDateTime);

            models.Event instance = event.copyWith(
              id: '${event.id}_${occurrence.millisecondsSinceEpoch}',
              startDateTime: occurrence,
              endDateTime: occurrence.add(eventDuration),
              date: occurrence,
              parentEventId: event.id,
            );
            expandedEvents.add(instance);
          }
        } else if (!event.isRecurring || event.parentEventId != null) {
          expandedEvents.add(event);
        }
      }

      print('Total events loaded: ${expandedEvents.length}');

      int instanceCount = expandedEvents.where((e) => e.parentEventId != null).length;
      int singleCount = expandedEvents.where((e) => !e.isRecurring && e.parentEventId == null).length;
      print('Instances: $instanceCount, Single: $singleCount');

      return expandedEvents;
    } catch (e) {
      print('Error fetching events: $e');
      throw Exception('Error fetching events');
    }
  }

  Future<List<models.Event>> getEventsFiltered({
    bool? completed,
    String? category,
    DateTime? date,
    bool? isToday,
  }) async {
    try {
      final allEvents = await getEvents();
      return allEvents.where((event) {
        if (completed != null && event.completed != completed) return false;
        if (category != null && event.customCategory != category) return false;
        if (date != null && !_isSameDay(event.startDateTime, date)) return false;
        if (isToday == true && !event.isToday) return false;
        return true;
      }).toList();
    } catch (e) {
      print('Error fetching filtered events: $e');
      return [];
    }
  }

  Future<List<models.Event>> getTodaysEvents() async {
    try {
      final today = DateTime.now();
      return await getEventsFiltered(date: today);
    } catch (e) {
      print('Error fetching today\'s events: $e');
      return [];
    }
  }

  Future<List<models.Event>> getCompletedEvents({DateTime? date}) async {
    try {
      final events = await getEvents();
      return events.where((event) {
        if (!event.completed) return false;
        if (date != null && event.completedAt != null) {
          return _isSameDay(event.completedAt!, date);
        }
        return event.completed;
      }).toList();
    } catch (e) {
      print('Error fetching completed events: $e');
      return [];
    }
  }

  Future<List<models.Event>> getOverdueEvents() async {
    try {
      final events = await getEvents();
      final now = DateTime.now();
      return events.where((event) {
        return !event.completed && event.endDateTime.isBefore(now);
      }).toList();
    } catch (e) {
      print('Error fetching overdue events: $e');
      return [];
    }
  }

  Future<List<models.Event>> getBaseEvents() async {
    try {
      final eventRows = await _database.select(_database.events).get();
      return eventRows.map((row) => _rowToEventModel(row)).toList();
    } catch (e) {
      print('Error fetching base events: $e');
      throw Exception('Error fetching base events');
    }
  }

  Future<int> addEvent(models.Event event) async {
    if (event.id.isEmpty) {
      throw Exception('Event ID is required');
    }

    try {
      if (event.isRecurring && event.recurrencePattern != null) {
        event.recurrenceRule = event.generateRRule();
      }

      final companion = _eventModelToCompanion(event);
      await _database.transaction(() async {
        await _database.into(_database.events).insert(companion);
      });

      await WebPersistenceHelper.flush();
      WebPersistenceHelper.logPersistence('[CalendarService] Event added: ${event.id}');
      await _scheduleEventNotification(event);

      return 1;
    } catch (e) {
      print('Error inserting event: $e');
      throw Exception('Error inserting event');
    }
  }

  Future<void> updateEvent(models.Event event, {bool updateSeries = false}) async {
    if (event.id.isEmpty) {
      throw Exception('Event ID is required');
    }

    try {
      await _cancelEventNotification(event.id);

      if (updateSeries && event.parentEventId != null) {
        final query = _database.select(_database.events)
          ..where((tbl) => tbl.eventId.equals(event.parentEventId!));
        final parentRows = await query.get();

        if (parentRows.isEmpty) throw Exception('Parent event not found');

        final parentRow = parentRows.first;
        final parentEvent = _rowToEventModel(parentRow);

        final updatedParent = parentEvent.copyWith(
          title: event.title,
          description: event.description,
          customCategory: event.customCategory,
          color: event.color,
          completed: event.completed,
          completedAt: event.completedAt,
          isRecurring: event.isRecurring,
          recurrencePattern: event.recurrencePattern,
          recurrenceCount: event.recurrenceCount,
          recurrenceEndDate: event.recurrenceEndDate,
          reminderEnabled: event.reminderEnabled,
          reminderTime: event.reminderTime,
          reminderPreset: event.reminderPreset,
        );

        if (updatedParent.isRecurring && updatedParent.recurrencePattern != null) {
          updatedParent.recurrenceRule = updatedParent.generateRRule();
        }

        final companion = _eventModelToCompanion(updatedParent);
        await _database.transaction(() async {
          await (_database.update(_database.events)
            ..where((t) => t.eventId.equals(updatedParent.id)))
            .write(companion);
        });

        await WebPersistenceHelper.flush();
        WebPersistenceHelper.logPersistence('[CalendarService] Event series updated: ${updatedParent.id}');
        await _scheduleEventNotification(updatedParent);
      } else {
        if (event.isRecurring && event.recurrencePattern != null) {
          event.recurrenceRule = event.generateRRule();
        }
        final companion = _eventModelToCompanion(event);
        await _database.transaction(() async {
          await (_database.update(_database.events)
            ..where((t) => t.eventId.equals(event.id)))
            .write(companion);
        });

        await WebPersistenceHelper.flush();
        WebPersistenceHelper.logPersistence('[CalendarService] Event updated: ${event.id}');
        await _scheduleEventNotification(event);
      }
    } catch (e) {
      print('Error updating event: $e');
      throw Exception('Error updating event');
    }
  }

  Future<void> toggleEventCompletion(String eventId) async {
    try {
      final event = await getEventById(eventId);
      if (event != null) {
        final updatedEvent = event.toggleCompletion();
        await updateEvent(updatedEvent);
      }
    } catch (e) {
      print('Error toggling event completion: $e');
    }
  }

  Future<void> markEventCompleted(String eventId) async {
    try {
      final event = await getEventById(eventId);
      if (event != null && !event.completed) {
        final updatedEvent = event.copyWith(
          completed: true,
          completedAt: DateTime.now(),
        );
        final companion = _eventModelToCompanion(updatedEvent);
        await _database.transaction(() async {
          await (_database.update(_database.events)
            ..where((t) => t.eventId.equals(eventId)))
            .write(companion);
        });

        await WebPersistenceHelper.flush();
        WebPersistenceHelper.logPersistence('[CalendarService] Event marked completed: $eventId');
        await _cancelEventNotification(eventId);
      }
    } catch (e) {
      print('Error marking event as completed: $e');
    }
  }

  Future<void> markEventIncomplete(String eventId) async {
    try {
      final event = await getEventById(eventId);
      if (event != null && event.completed) {
        final updatedEvent = event.copyWith(
          completed: false,
          completedAt: null,
        );
        final companion = _eventModelToCompanion(updatedEvent);
        await _database.transaction(() async {
          await (_database.update(_database.events)
            ..where((t) => t.eventId.equals(eventId)))
            .write(companion);
        });

        await WebPersistenceHelper.flush();
        WebPersistenceHelper.logPersistence('[CalendarService] Event marked incomplete: $eventId');
        await _scheduleEventNotification(updatedEvent);
      }
    } catch (e) {
      print('Error marking event as incomplete: $e');
    }
  }

  Future<models.Event?> getEventById(String eventId) async {
    try {
      final query = _database.select(_database.events)
        ..where((tbl) => tbl.eventId.equals(eventId));
      final eventRows = await query.get();
      if (eventRows.isEmpty) return null;
      return _rowToEventModel(eventRows.first);
    } catch (e) {
      print('Error fetching event by ID: $e');
      return null;
    }
  }

  Future<void> deleteEvent(String id, {bool deleteSeries = false}) async {
    try {
      print('Deleting event - ID: $id, deleteSeries: $deleteSeries');

      await _cancelEventNotification(id);

      if (deleteSeries) {
        final allEvents = await getBaseEvents();

        final parentEvent = allEvents.firstWhere(
          (e) => e.id == id || e.parentEventId == id,
          orElse: () => throw Exception('Event not found'),
        );

        String parentId = parentEvent.parentEventId ?? parentEvent.id;
        print('Deleting parent event with ID: $parentId');

        await _database.transaction(() async {
          await (_database.delete(_database.events)
            ..where((t) => t.eventId.equals(parentId))).go();

          for (models.Event event in allEvents) {
            if (event.parentEventId == parentId && event.id != parentId) {
              print('Deleting instance: ${event.id}');
              await _cancelEventNotification(event.id);
              await (_database.delete(_database.events)
                ..where((t) => t.eventId.equals(event.id))).go();
            }
          }
        });

        await WebPersistenceHelper.flush();
        WebPersistenceHelper.logPersistence('[CalendarService] Event series deleted: $parentId');
        print('Successfully deleted entire series');
      } else {
        print('Deleting single event with ID: $id');
        await _database.transaction(() async {
          await (_database.delete(_database.events)
            ..where((t) => t.eventId.equals(id))).go();
        });
        await WebPersistenceHelper.flush();
        WebPersistenceHelper.logPersistence('[CalendarService] Event deleted: $id');
        print('Successfully deleted single event');
      }
    } catch (e) {
      print('Error deleting event: $e');
      throw Exception('Error deleting event: $e');
    }
  }

  Future<void> addRecurrenceException(String parentEventId, DateTime exceptionDate) async {
    try {
      print('Adding exception for parent: $parentEventId, date: $exceptionDate');

      final query = _database.select(_database.events)
        ..where((tbl) => tbl.eventId.equals(parentEventId));
      final eventRows = await query.get();

      if (eventRows.isEmpty) throw Exception('Parent event not found');

      final eventRow = eventRows.first;
      final parentEvent = _rowToEventModel(eventRow);

      List<DateTime> exceptions = List.from(parentEvent.recurrenceExceptionDates ?? []);
      if (!exceptions.any((ex) => _isSameDay(ex, exceptionDate))) {
        exceptions.add(exceptionDate);

        final updatedEvent = parentEvent.copyWith(
          recurrenceExceptionDates: exceptions,
        );

        final companion = _eventModelToCompanion(updatedEvent);
        await (_database.update(_database.events)
          ..where((t) => t.eventId.equals(parentEventId)))
          .write(companion);
        print('Successfully added exception date');
      } else {
        print('Exception date already exists');
      }
    } catch (e) {
      print('Error adding recurrence exception: $e');
      throw Exception('Error adding recurrence exception: $e');
    }
  }

  Future<void> createModifiedOccurrence(models.Event originalEvent, models.Event modifiedEvent) async {
    try {
      if (originalEvent.parentEventId != null) {
        await addRecurrenceException(originalEvent.parentEventId!, originalEvent.startDateTime);
      }

      final newSingleEvent = modifiedEvent.copyWith(
        isRecurring: false,
        recurrencePattern: null,
        recurrenceRule: null,
        parentEventId: null,
        recurrenceExceptionDates: null,
        recurrenceCount: null,
        recurrenceEndDate: null,
      );

      await addEvent(newSingleEvent);
    } catch (e) {
      print('Error creating modified occurrence: $e');
      throw Exception('Error creating modified occurrence');
    }
  }

  Future<void> _scheduleEventNotification(models.Event event) async {
    try {
      if (event.reminderEnabled == true &&
          event.reminderTime != null &&
          !event.completed &&
          event.reminderTime!.isAfter(DateTime.now())) {
        // TODO: Implement NotificationService integration
        print('[CalendarService] Would schedule notification for event: ${event.title} at ${event.reminderTime}');
      }
    } catch (e) {
      print('[CalendarService] Error scheduling event notification: $e');
    }
  }

  Future<void> _cancelEventNotification(String eventId) async {
    try {
      // TODO: Implement NotificationService integration
      print('[CalendarService] Would cancel notification for event: $eventId');
    } catch (e) {
      print('[CalendarService] Error cancelling event notification: $e');
    }
  }

  List<DateTime> _generateRecurrenceOccurrences(
    DateTime startDate,
    String rrule,
    DateTime rangeStart,
    DateTime rangeEnd,
    List<DateTime>? exceptions,
  ) {
    List<DateTime> occurrences = [];
    Map<String, String> rules = _parseRRule(rrule);

    String? frequency = rules['FREQ'];
    int interval = int.parse(rules['INTERVAL'] ?? '1');
    int? count = rules['COUNT'] != null ? int.parse(rules['COUNT']!) : null;

    DateTime current = startDate;
    int occurrenceCount = 0;

    while (current.isBefore(rangeEnd) && (count == null || occurrenceCount < count)) {
      if (current.isAfter(rangeStart) || current.isAtSameMomentAs(rangeStart)) {
        bool isException = exceptions?.any((ex) => _isSameDay(ex, current)) ?? false;
        if (!isException) {
          occurrences.add(current);
          occurrenceCount++;
        }
      }

      current = _getNextOccurrence(current, frequency!, interval);

      if (occurrenceCount > 1000) break;
    }

    return occurrences;
  }

  Map<String, String> _parseRRule(String rrule) {
    Map<String, String> rules = {};
    List<String> parts = rrule.split(';');

    for (String part in parts) {
      List<String> keyValue = part.split('=');
      if (keyValue.length == 2) {
        rules[keyValue[0]] = keyValue[1];
      }
    }

    return rules;
  }

  DateTime _getNextOccurrence(DateTime current, String frequency, int interval) {
    switch (frequency.toUpperCase()) {
      case 'DAILY':
        return current.add(Duration(days: interval));
      case 'WEEKLY':
        return current.add(Duration(days: 7 * interval));
      case 'MONTHLY':
        return DateTime(current.year, current.month + interval, current.day,
                       current.hour, current.minute);
      case 'YEARLY':
        return DateTime(current.year + interval, current.month, current.day,
                       current.hour, current.minute);
      default:
        return current.add(Duration(days: interval));
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<List<models.Event>> getEventsInRange(DateTime start, DateTime end) async {
    try {
      final allEvents = await getEvents();
      return allEvents.where((event) {
        return (event.startDateTime.isAfter(start) || _isSameDay(event.startDateTime, start)) &&
               (event.startDateTime.isBefore(end) || _isSameDay(event.startDateTime, end));
      }).toList();
    } catch (e) {
      print('Error fetching events in range: $e');
      throw Exception('Error fetching events in range');
    }
  }

  Future<List<models.Event>> getEventsForDay(DateTime day) async {
    try {
      final allEvents = await getEvents();
      return allEvents.where((event) => _isSameDay(event.startDateTime, day)).toList();
    } catch (e) {
      print('Error fetching events for day: $e');
      throw Exception('Error fetching events for day');
    }
  }

  bool isValidRRule(String rrule) {
    try {
      final rules = _parseRRule(rrule);
      return rules.containsKey('FREQ');
    } catch (e) {
      return false;
    }
  }

  Future<List<models.Event>> getUpcomingEvents({int limit = 10}) async {
    try {
      final allEvents = await getEvents();
      final now = DateTime.now();

      final upcomingEvents = allEvents
          .where((event) => event.startDateTime.isAfter(now))
          .toList()
        ..sort((a, b) => a.startDateTime.compareTo(b.startDateTime));

      return upcomingEvents.take(limit).toList();
    } catch (e) {
      print('Error fetching upcoming events: $e');
      throw Exception('Error fetching upcoming events');
    }
  }

  Future<Map<String, int>> getEventStats() async {
    try {
      final events = await getEvents();
      final completed = events.where((event) => event.completed).length;
      final pending = events.where((event) => !event.completed).length;
      final overdue = events.where((event) =>
        !event.completed && event.endDateTime.isBefore(DateTime.now())).length;

      return {
        'total': events.length,
        'completed': completed,
        'pending': pending,
        'overdue': overdue,
      };
    } catch (e) {
      print('Error getting event stats: $e');
      return {'total': 0, 'completed': 0, 'pending': 0, 'overdue': 0};
    }
  }

  Future<void> debugDatabaseState() async {
    try {
      final eventRows = await _database.select(_database.events).get();
      print('=== Database Events Debug ===');
      for (var row in eventRows) {
        print('ID: ${row.eventId}');
        print('  Title: ${row.title}');
        print('  Parent: ${row.parentEventId}');
        print('  Recurring: ${row.isRecurring}');
        print('  Start: ${row.startDateTime}');
        print('  Completed: ${row.completed}');
        print('  Reminder: ${row.reminderEnabled}');
        print('---');
      }
      print('Total database events: ${eventRows.length}');
    } catch (e) {
      print('Error debugging database state: $e');
    }
  }

  models.Event _rowToEventModel(dynamic dbEvent) {
    final exceptionsStr = dbEvent.recurrenceExceptionDates ?? '';
    final exceptions = exceptionsStr.isEmpty
      ? <DateTime>[]
      : exceptionsStr.split(',').map((s) => DateTime.parse(s)).toList();

    return models.Event(
      id: dbEvent.eventId,
      title: dbEvent.title,
      description: dbEvent.description,
      startDateTime: dbEvent.startDateTime,
      endDateTime: dbEvent.endDateTime,
      date: dbEvent.date,
      customCategory: dbEvent.customCategory,
      color: dbEvent.color,
      completed: dbEvent.completed,
      completedAt: dbEvent.completedAt,
      isRecurring: dbEvent.isRecurring,
      recurrencePattern: dbEvent.recurrencePattern,
      recurrenceRule: dbEvent.recurrenceRule,
      recurrenceCount: dbEvent.recurrenceCount,
      recurrenceEndDate: dbEvent.recurrenceEndDate,
      reminderEnabled: dbEvent.reminderEnabled,
      reminderTime: dbEvent.reminderTime,
      reminderPreset: dbEvent.reminderPreset,
      parentEventId: dbEvent.parentEventId,
      recurrenceExceptionDates: exceptions,
      createdAt: dbEvent.createdAt,
      updatedAt: dbEvent.updatedAt,
    );
  }

  EventsCompanion _eventModelToCompanion(models.Event event) {
    return EventsCompanion(
      id: drift.Value(event.id),
      eventId: drift.Value(event.id),
      title: drift.Value(event.title),
      description: drift.Value(event.description),
      startDateTime: drift.Value(event.startDateTime),
      endDateTime: drift.Value(event.endDateTime),
      date: drift.Value(event.date),
      customCategory: drift.Value(event.customCategory),
      color: drift.Value(event.color),
      completed: drift.Value(event.completed),
      completedAt: drift.Value(event.completedAt),
      isRecurring: drift.Value(event.isRecurring),
      recurrencePattern: drift.Value(event.recurrencePattern?.toString()),
      recurrenceRule: drift.Value(event.recurrenceRule),
      recurrenceCount: drift.Value(event.recurrenceCount),
      recurrenceEndDate: drift.Value(event.recurrenceEndDate),
      reminderEnabled: drift.Value(event.reminderEnabled ?? false),
      reminderTime: drift.Value(event.reminderTime),
      reminderPreset: drift.Value(event.reminderPreset),
      parentEventId: drift.Value(event.parentEventId),
      recurrenceExceptionDates: drift.Value(
        event.recurrenceExceptionDates?.isEmpty ?? true
          ? null
          : event.recurrenceExceptionDates!.map((d) => d.toIso8601String()).join(','),
      ),
      createdAt: drift.Value(event.createdAt),
      updatedAt: drift.Value(event.updatedAt),
    );
  }
}
