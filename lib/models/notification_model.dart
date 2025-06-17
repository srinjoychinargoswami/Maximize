import 'package:uuid/uuid.dart'; // Import the UUID package

class NotificationModel {
  final String id; // Unique identifier for the notification
  final String title; // Title of the notification
  final String body; // Body/content of the notification
  final DateTime scheduledTime; // When the notification is scheduled to appear

  // Constructor with an optional id parameter
  NotificationModel({
    String? id, // Make id optional
    required this.title,
    required this.body,
    required this.scheduledTime,
  }) : id = id ?? Uuid().v4(); // Generate a new UUID if id is not provided

  // Convert a NotificationModel instance to a Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'scheduledTime': scheduledTime.toIso8601String(), // Store as ISO 8601 string
    };
  }

  // Create a NotificationModel instance from a Map
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      scheduledTime: DateTime.parse(map['scheduledTime']), // Parse from ISO 8601 string
    );
  }
}