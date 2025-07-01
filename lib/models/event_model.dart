import 'package:maximize/models/database.dart'; // Import your database file
import 'package:intl/intl.dart'; // Import intl package

class Event {
  String id; // Make ID non-nullable
  String title;
  String? description; // Make description nullable
  String? comments; // Make comments nullable
  DateTime startDateTime; // Change to DateTime
  DateTime endDateTime; // Change to DateTime
  DateTime date;
  String? customCategory; // Make customCategory nullable to match usage
  String color; // New field for event color

  Event({
    required this.id, // Make ID required
    required this.title,
    this.description, // Make description nullable
    this.comments, // Make comments nullable
    required this.startDateTime, // Change to DateTime
    required this.endDateTime, // Change to DateTime
    required this.date,
    this.customCategory, // Remove required since it's nullable
    required this.color, // New required field for color
  });

  // Conversion method from EventData to Event
  factory Event.fromEventData(EventData eventData) {
    return Event(
      id: eventData.id,
      title: eventData.title,
      description: eventData.description,
      comments: eventData.comments,
      startDateTime: eventData.startDateTime, // Use DateTime directly
      endDateTime: eventData.endDateTime, // Use DateTime directly
      date: eventData.startDateTime, // Use eventDateTime as the date
      customCategory: eventData.customCategory, // Keep nullable
      color: eventData.color ?? '#FFFFFF', // Map color from EventData (default to white)
    );
  }

  // Convert Event to Map (optional, if needed for other purposes)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'comments': comments,
      'startTime': DateFormat('HH:mm').format(startDateTime), // Format using intl
      'endTime': DateFormat('HH:mm').format(endDateTime), // Format using intl
      'date': date.toIso8601String(),
      'category': customCategory, // Include custom category
      'color': color, // Include color
    };
  }

  // Convert Map to Event (optional, if needed for other purposes)
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      comments: map['comments'],
      startDateTime: DateTime.parse(map['startTime']), // Parse DateTime directly
      endDateTime: DateTime.parse(map['endTime']), // Parse DateTime directly
      date: DateTime.parse(map['date']),
      customCategory: map['category'], // Parse category from map (nullable)
      color: map['color'] ?? '#FFFFFF', // Parse color from map (default to white)
    );
  }
}