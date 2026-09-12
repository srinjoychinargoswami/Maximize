import 'package:kinetic/database/app_database.dart';
import 'package:kinetic/models/event_model.dart' as event_model;
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart';

class EventService {
  final AppDatabase _database;

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

    try {
      await _database.into(_database.events).insert(
        EventsCompanion(
          id: Value(eventId),
          eventId: Value(eventId),
          title: Value(title),
          description: Value(description),
          startDateTime: Value(startTime),
          endDateTime: Value(endTime ?? startTime),
          date: Value(startTime),
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
            e.date.year == date.year &&
            e.date.month == date.month &&
            e.date.day == date.day)
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
      await (_database.update(_database.events)
            ..where((e) => e.eventId.equals(eventId)))
          .write(EventsCompanion(
            title: title != null ? Value(title) : const Value.absent(),
            description: description != null ? Value(description) : const Value.absent(),
            startDateTime: startTime != null ? Value(startTime) : const Value.absent(),
            endDateTime: endTime != null ? Value(endTime) : const Value.absent(),
            updatedAt: Value(DateTime.now()),
          ));
    } catch (e) {
      debugPrint('Error updating event: $e');
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await (_database.delete(_database.events)
            ..where((e) => e.eventId.equals(eventId)))
          .go();
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
      date: row.date,
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
