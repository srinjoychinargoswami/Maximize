import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maximize/models/event_model.dart';
import 'package:maximize/models/task_model.dart';
import 'package:maximize/models/database.dart';


class ApiService {
  // Replace with your actual API base URL
  static const String baseUrl = 'https://your-api-url.com/api';

  // Fetch all events for a user (or all, depending on your backend)
  Future<List<Event>> fetchEvents() async {
    final response = await http.get(Uri.parse('$baseUrl/events'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Event.fromMap(json)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  // Create a new event
  Future<Event> createEvent(Event event) async {
    final response = await http.post(
      Uri.parse('$baseUrl/events'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(event.toMap()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Event.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create event');
    }
  }

  // Update an existing event
  Future<Event> updateEvent(Event event) async {
    final response = await http.put(
      Uri.parse('$baseUrl/events/${event.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(event.toMap()),
    );
    if (response.statusCode == 200) {
      return Event.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update event');
    }
  }

  // Delete an event
  Future<void> deleteEvent(String eventId) async {
    final response = await http.delete(Uri.parse('$baseUrl/events/$eventId'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete event');
    }
  }
}
