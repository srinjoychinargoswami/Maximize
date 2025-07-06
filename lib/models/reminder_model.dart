import 'package:uuid/uuid.dart';

class ReminderModel {
  final String id; // UUID for internal tracking
  final String title; // Title shown in notification
  final String body; // Body/content of the notification
  final DateTime scheduledTime; // Exact time to trigger notification
  final String notificationId; // Changed to String to match flutter_local_notifications

  ReminderModel({
    String? id,
    required this.title,
    required this.body,
    required this.scheduledTime,
    String? notificationId,
  })  : id = id ?? const Uuid().v4(),
        notificationId = notificationId ?? (id ?? const Uuid().v4()).hashCode.toString();

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'body': body,
        'scheduledTime': scheduledTime.toIso8601String(),
        'notificationId': notificationId,
      };

  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    return ReminderModel(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      scheduledTime: DateTime.parse(map['scheduledTime']),
      notificationId: map['notificationId'],
    );
  }

  ReminderModel copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? scheduledTime,
    String? notificationId,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      notificationId: notificationId ?? this.notificationId,
    );
  }
}
