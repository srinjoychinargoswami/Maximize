import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:maximize/models/reminder_model.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    _initialize();
  }

  Future<void> _initialize() async {
    tz.initializeTimeZones(); // Ensure timezone support

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      // Add iOS/macOS/Linux initialization if needed
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleNotification(ReminderModel reminder) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'reminder_channel_id', // Replace with consistent channel ID
        'Reminders',
        channelDescription: 'Channel for scheduled reminders',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.zonedSchedule(
        reminder.notificationId, // Use notificationId from model
        reminder.title,
        reminder.body,
        tz.TZDateTime.from(reminder.scheduledTime, tz.local),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: null, // Change for repeating notifications
      );

      print('[NotificationService] Scheduled: ${reminder.title} @ ${reminder.scheduledTime}');
    } catch (e) {
      print('[NotificationService] Error scheduling: $e');
    }
  }

  Future<void> cancelNotification(String id) async {
    try {
      await flutterLocalNotificationsPlugin.cancel(id.hashCode);
      print('[NotificationService] Cancelled notification with id: $id');
    } catch (e) {
      print('[NotificationService] Error canceling notification: $e');
    }
  }

  Future<void> modifyNotification(ReminderModel reminder) async {
    try {
      await cancelNotification(reminder.id); // Uses the hashCode to cancel
      await scheduleNotification(reminder);   // Reschedules with new values
      print('[NotificationService] Modified: ${reminder.title}');
    } catch (e) {
      print('[NotificationService] Error modifying: $e');
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await flutterLocalNotificationsPlugin.cancelAll();
      print('[NotificationService] All notifications cancelled');
    } catch (e) {
      print('[NotificationService] Error cancelling all: $e');
    }
  }
}
