import 'package:isar/isar.dart';
import '../isar_database_service.dart';
import '../models/isar_models.dart';

class EventDAO {
  Future<void> insertEvent(IsarEvent event) async {
    await IsarDatabaseService.db.writeTxn(() async {
      await IsarDatabaseService.events.put(event);
    });
  }

  Future<List<IsarEvent>> getAllEvents() async {
    return await IsarDatabaseService.events.where().findAll();
  }

  Future<IsarEvent?> getEventById(String eventId) async {
    final events = await IsarDatabaseService.events.where().findAll();
    try {
      return events.firstWhere((event) => event.eventId == eventId);
    } catch (e) {
      return null;
    }
  }

  Future<List<IsarEvent>> getBaseEvents() async {
    final events = await IsarDatabaseService.events.where().findAll();
    return events.where((event) => event.parentEventId == null).toList();
  }

  Future<List<IsarEvent>> getRecurringEvents() async {
    final events = await IsarDatabaseService.events.where().findAll();
    return events.where((event) => event.isRecurring).toList();
  }

  Future<List<IsarEvent>> getCompletedEvents() async {
    final events = await IsarDatabaseService.events.where().findAll();
    return events.where((event) => event.completed).toList();
  }

  Future<List<IsarEvent>> getEventsInRange(DateTime start, DateTime end) async {
    final events = await IsarDatabaseService.events.where().findAll();
    return events.where((event) {
      final eventStart = event.startDateTime;
      return eventStart != null &&
             eventStart.isAfter(start) &&
             eventStart.isBefore(end);
    }).toList();
  }

  Future<void> updateEvent(IsarEvent event) async {
    await IsarDatabaseService.db.writeTxn(() async {
      await IsarDatabaseService.events.put(event);
    });
  }

  Future<void> deleteEvent(String eventId) async {
    final event = await getEventById(eventId);
    if (event != null) {
      await IsarDatabaseService.db.writeTxn(() async {
        await IsarDatabaseService.events.delete(event.id!);
      });
    }
  }

  Future<void> deleteEventSeries(String parentEventId) async {
    final parent = await getEventById(parentEventId);
    final events = await IsarDatabaseService.events.where().findAll();
    final children = events.where((event) => event.parentEventId == parentEventId).toList();

    await IsarDatabaseService.db.writeTxn(() async {
      if (parent != null) {
        await IsarDatabaseService.events.delete(parent.id!);
      }
      for (final child in children) {
        await IsarDatabaseService.events.delete(child.id!);
      }
    });
  }

  Future<int> countEvents() async {
    return await IsarDatabaseService.events.count();
  }

  Future<int> countCompletedEvents() async {
    final events = await IsarDatabaseService.events.where().findAll();
    return events.where((event) => event.completed).length;
  }
}
