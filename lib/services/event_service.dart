import 'package:kinetic/database/app_database.dart';
import 'package:kinetic/models/event_model.dart' as event_model;
import 'package:kinetic/services/sync_service.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart';

class EventService {
  final AppDatabase _database;
  final SyncService _sync = SyncService();

  EventService(this._database);

  Future<void> createEvent({
    required String title,
    String? description,
    required DateTime startTime,
    DateTime? endTime,
    bool isRecurring = false,
    String? recurrenceRule,
    int? recurrenceInterval,
    List<int>? daysOfWeek,
    DateTime? recurrenceEndDate,
    int? maxOccurrences,
    bool reminderEnabled = false,
    DateTime? reminderTime,
    String? reminderPreset,
  }) async {
    final eventId = const Uuid().v4();
    final now = DateTime.now();

    // Normalize scheduledDate to midnight of the event's date (local timezone)
    final scheduledDate = DateTime(startTime.year, startTime.month, startTime.day);

    try {
      await _database.into(_database.events).insert(
        EventsCompanion(
          id: Value(eventId),
          eventId: Value(eventId),
          title: Value(title),
          description: Value(description),
          startDateTime: Value(startTime),
          endDateTime: Value(endTime ?? startTime),
          scheduledDate: Value(scheduledDate),
          isRecurring: Value(isRecurring),
          recurrenceRule: Value(recurrenceRule),
          recurrenceCount: Value(maxOccurrences),
          recurrenceEndDate: Value(recurrenceEndDate),
          reminderEnabled: Value(reminderEnabled),
          reminderTime: Value(reminderTime),
          reminderPreset: Value(reminderPreset),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      await _sync.insert('events', eventId, {
        'title': title,
        'description': description,
        'startDateTime': startTime.millisecondsSinceEpoch,
        'endDateTime': (endTime ?? startTime).millisecondsSinceEpoch,
        'scheduledDate': scheduledDate.millisecondsSinceEpoch,
        'isRecurring': isRecurring ? 1 : 0,
        'recurrenceRule': recurrenceRule,
        'recurrenceCount': maxOccurrences,
        'recurrenceEndDate': recurrenceEndDate?.millisecondsSinceEpoch,
        'reminderEnabled': reminderEnabled ? 1 : 0,
        'reminderTime': reminderTime?.millisecondsSinceEpoch,
        'reminderPreset': reminderPreset,
        'createdAt': now.millisecondsSinceEpoch,
        'updatedAt': now.millisecondsSinceEpoch,
      });
    } catch (e) {
      debugPrint('Error creating event: $e');
    }
  }

  Future<List<event_model.Event>> getAllEvents() async {
    try {
      final rows = await _database.select(_database.events).get();
      return rows.map(_rowToModel).toList();
    } catch (e) {
      debugPrint('Error fetching events: $e');
      return [];
    }
  }

  Future<event_model.Event?> getEventById(String eventId) async {
    try {
      final row = await (_database.select(_database.events)
            ..where((e) => e.eventId.equals(eventId)))
          .getSingleOrNull();
      return row != null ? _rowToModel(row) : null;
    } catch (e) {
      debugPrint('Error fetching event: $e');
      return null;
    }
  }

  Future<List<event_model.Event>> getEventsForDate(DateTime date) async {
    try {
      final rows = await _database.select(_database.events).get();
      return rows
          .where((e) =>
            e.scheduledDate.year == date.year &&
            e.scheduledDate.month == date.month &&
            e.scheduledDate.day == date.day)
          .map(_rowToModel)
          .toList();
    } catch (e) {
      debugPrint('Error fetching events for date: $e');
      return [];
    }
  }

  Future<void> updateEvent(String eventId, {
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
  }) async {
    try {
      final updates = <String, Value>{
        if (title != null) 'title': Value(title),
        if (description != null) 'description': Value(description),
        if (startTime != null) ...{
          'startDateTime': Value(startTime),
          'scheduledDate': Value(DateTime(startTime.year, startTime.month, startTime.day)),
        },
        if (endTime != null) 'endDateTime': Value(endTime),
        'updatedAt': Value(DateTime.now()),
      };

      await (_database.update(_database.events)
            ..where((e) => e.eventId.equals(eventId)))
          .write(EventsCompanion(
            title: title != null ? Value(title) : const Value.absent(),
            description: description != null ? Value(description) : const Value.absent(),
            startDateTime: startTime != null ? Value(startTime) : const Value.absent(),
            scheduledDate: startTime != null ? Value(DateTime(startTime.year, startTime.month, startTime.day)) : const Value.absent(),
            endDateTime: endTime != null ? Value(endTime) : const Value.absent(),
            updatedAt: Value(DateTime.now()),
          ));

      final syncUpdates = <String, dynamic>{};
      if (title != null) syncUpdates['title'] = title;
      if (description != null) syncUpdates['description'] = description;
      if (startTime != null) {
        syncUpdates['startDateTime'] = startTime.millisecondsSinceEpoch;
        syncUpdates['scheduledDate'] = DateTime(startTime.year, startTime.month, startTime.day).millisecondsSinceEpoch;
      }
      if (endTime != null) syncUpdates['endDateTime'] = endTime.millisecondsSinceEpoch;
      syncUpdates['updatedAt'] = DateTime.now().millisecondsSinceEpoch;

      if (syncUpdates.isNotEmpty) {
        await _sync.update('events', eventId, syncUpdates);
      }
    } catch (e) {
      debugPrint('Error updating event: $e');
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await (_database.delete(_database.events)
            ..where((e) => e.eventId.equals(eventId)))
          .go();

      await _sync.delete('events', eventId);
    } catch (e) {
      debugPrint('Error deleting event: $e');
    }
  }

  event_model.Event _rowToModel(Event row) {
    return event_model.Event(
      id: row.eventId,
      title: row.title,
      description: row.description,
      startDateTime: row.startDateTime,
      endDateTime: row.endDateTime,
      date: row.scheduledDate,
      color: '#FFFFFF',
      isRecurring: row.isRecurring,
      recurrenceRule: row.recurrenceRule,
      recurrenceCount: row.recurrenceCount,
      recurrenceEndDate: row.recurrenceEndDate,
      reminderEnabled: row.reminderEnabled,
      reminderTime: row.reminderTime,
      reminderPreset: row.reminderPreset,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
