import 'package:maximize/models/database.dart';
import 'package:maximize/models/event_model.dart';

class CalendarService {
  final AppDatabase _database;

  CalendarService(this._database);

  // Fetch all events from the database
  Future<List<Event>> getEvents() async {
    try {
      final eventsData = await _database.getAllEvents();
      return eventsData.map((eventData) => Event.fromEventData(eventData)).toList();
    } catch (e) {
      print('Error fetching events: $e');
      throw Exception('Error fetching events');
    }
  }

  // Add a new event to the database
  Future<int> addEvent(Event event) async {
    if (event.id.isEmpty) {
      throw Exception('Event ID is required');
    }

    try {
      return await _database.insertEvent(event); // Returns the inserted event ID
    } catch (e) {
      print('Error inserting event: $e');
      throw Exception('Error inserting event');
    }
  }

  // Update an existing event in the database
  Future<void> updateEvent(Event event) async {
    if (event.id.isEmpty) {
      throw Exception('Event ID is required');
    }

    try {
      await _database.updateEvent(event);
    } catch (e) {
      print('Error updating event: $e');
      throw Exception('Error updating event');
    }
  }

  // Delete an event from the database
  Future<void> deleteEvent(String id) async {
    try {
      await _database.deleteEvent(id);
    } catch (e) {
      print('Error deleting event: $e');
      throw Exception('Error deleting event');
    }
  }
}