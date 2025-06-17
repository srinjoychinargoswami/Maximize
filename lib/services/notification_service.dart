import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:maximize/models/notification_model.dart';
import 'package:timezone/timezone.dart' as tz; // For timezone support

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    _initialize();
  }

  Future<void> _initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      // Add other platforms if needed
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleNotification(NotificationModel notification) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id', // Replace with your channel ID
      'your_channel_name', // Replace with your channel name
      channelDescription: 'your_channel_description', // Use named parameter for description
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      // Add other platforms if needed
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notification.id.hashCode, // Use hash code of the ID as the notification ID
      notification.title,
      notification.body,
      tz.TZDateTime.from(notification.scheduledTime, tz.local), // Schedule time
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotification(String id) async {
    await flutterLocalNotificationsPlugin.cancel(id.hashCode);
  }

  Future<void> modifyNotification(NotificationModel notification) async {
    // Cancel the existing notification
    await cancelNotification(notification.id);

    // Schedule a new notification with the updated details
    await scheduleNotification(notification);
  }

  // Add more functions as needed (e.g., retrieving notifications, etc.)
}