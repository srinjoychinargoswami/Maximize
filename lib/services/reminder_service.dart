import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:maximize/models/reminder_model.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:win_toast/win_toast.dart';

class NotificationService {
  // Private constructor
  NotificationService._internal();

  // Static instance variable
  static final NotificationService _instance = NotificationService._internal();

  // Factory constructor to return the singleton instance
  factory NotificationService() => _instance;

  // Static getter for accessing the instance
  static NotificationService get instance => _instance;

  FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize timezone data
      tz.initializeTimeZones();

      if (Platform.isWindows) {
        // Initialize WinToast for Windows using the correct API from search results
        final result = await WinToast.instance().initialize(
          aumId: 'com.maximize.productivity',
          displayName: 'Maximize Productivity App',
          iconPath: '',
          clsid: '936C39FC-6BBC-4A57-B8F8-7C627E401B2F', // Generate your own GUID
        );
        
        if (result) {
          print('[NotificationService] WinToast initialized for Windows');
        } else {
          print('[NotificationService] Failed to initialize WinToast');
        }
      } else {
        // Initialize flutter_local_notifications for other platforms
        _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

        const AndroidInitializationSettings initializationSettingsAndroid =
            AndroidInitializationSettings('@mipmap/ic_launcher');

        const InitializationSettings initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
        );

        // Initialize the plugin
        await _flutterLocalNotificationsPlugin!.initialize(initializationSettings);

        // Request permission on Android 13+
        if (Platform.isAndroid) {
          final androidPlugin = _flutterLocalNotificationsPlugin!
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>();
          await androidPlugin?.requestNotificationsPermission();
        }
      }

      _isInitialized = true;
      print('[NotificationService] Successfully initialized for ${Platform.operatingSystem}');
    } catch (e) {
      print('[NotificationService] Initialization error: $e');
      _isInitialized = false;
    }
  }

  Future<void> scheduleNotification(ReminderModel reminder) async {
    try {
      // Ensure initialization before use
      if (!_isInitialized) {
        await initialize();
      }

      if (Platform.isWindows) {
        // Use WinToast for Windows
        await _scheduleWindowsNotification(reminder);
      } else {
        // Use flutter_local_notifications for other platforms
        await _scheduleFlutterNotification(reminder);
      }

      print('[NotificationService] Scheduled: ${reminder.title} @ ${reminder.scheduledTime}');
    } catch (e) {
      print('[NotificationService] Error scheduling: $e');
    }
  }

  Future<void> _scheduleWindowsNotification(ReminderModel reminder) async {
    try {
      final now = DateTime.now();
      final scheduledTime = reminder.scheduledTime;
      
      if (scheduledTime.isAfter(now)) {
        // Calculate delay and schedule
        final delay = scheduledTime.difference(now);
        
        // Use Future.delayed for scheduling
        Future.delayed(delay, () async {
          await _showWindowsToast(reminder.title, reminder.body);
        });
        
        print('[NotificationService] Windows notification scheduled for ${delay.inMinutes} minutes');
      } else {
        // Show immediately if time has passed
        await _showWindowsToast(reminder.title, reminder.body);
      }
    } catch (e) {
      print('[NotificationService] Windows notification error: $e');
    }
  }

  Future<void> _showWindowsToast(String title, String body) async {
    try {
      // Use the correct win_toast API based on search results
      await WinToast.instance().showToast(
        toast: Toast(
          duration: ToastDuration.short,
          children: [
            ToastChildVisual(
              binding: ToastVisualBinding(
                children: [
                  ToastVisualBindingChildText(
                    text: title,
                    id: 1,
                  ),
                  ToastVisualBindingChildText(
                    text: body,
                    id: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      print('[NotificationService] Error showing Windows toast: $e');
    }
  }

  Future<void> _scheduleFlutterNotification(ReminderModel reminder) async {
    if (_flutterLocalNotificationsPlugin == null) {
      throw Exception('Failed to initialize notification plugin');
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'reminder_channel_id',
      'Reminders',
      channelDescription: 'Channel for scheduled reminders',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    final int notificationIdInt = int.parse(reminder.notificationId);

    try {
      await _flutterLocalNotificationsPlugin!.zonedSchedule(
        notificationIdInt,
        reminder.title,
        reminder.body,
        tz.TZDateTime.from(reminder.scheduledTime, tz.local),
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      // Fallback to immediate notification if scheduling fails
      print('[NotificationService] Scheduling failed, showing immediate notification: $e');
      await _flutterLocalNotificationsPlugin!.show(
        notificationIdInt,
        reminder.title,
        reminder.body,
        platformChannelSpecifics,
      );
    }
  }

  Future<void> cancelNotification(String notificationId) async {
    try {
      // Ensure initialization before use
      if (!_isInitialized) {
        await initialize();
      }

      if (Platform.isWindows) {
        // WinToast doesn't have a direct cancel method for scheduled notifications
        print('[NotificationService] Windows notification cancellation not fully supported');
      } else {
        if (_flutterLocalNotificationsPlugin == null) {
          throw Exception('Failed to initialize notification plugin');
        }

        final int notificationIdInt = int.parse(notificationId);
        await _flutterLocalNotificationsPlugin!.cancel(notificationIdInt);
      }
      
      print('[NotificationService] Cancelled notification with id: $notificationId');
    } catch (e) {
      print('[NotificationService] Error canceling notification: $e');
    }
  }

  Future<void> modifyNotification(ReminderModel reminder) async {
    try {
      await cancelNotification(reminder.notificationId);
      await scheduleNotification(reminder);
      print('[NotificationService] Modified: ${reminder.title}');
    } catch (e) {
      print('[NotificationService] Error modifying: $e');
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      // Ensure initialization before use
      if (!_isInitialized) {
        await initialize();
      }

      if (Platform.isWindows) {
        // WinToast doesn't have a cancel all method
        print('[NotificationService] Windows cancel all notifications not supported');
      } else {
        if (_flutterLocalNotificationsPlugin == null) {
          throw Exception('Failed to initialize notification plugin');
        }

        await _flutterLocalNotificationsPlugin!.cancelAll();
      }
      
      print('[NotificationService] All notifications cancelled');
    } catch (e) {
      print('[NotificationService] Error cancelling all: $e');
    }
  }

  // Test method to show immediate Windows notification
  Future<void> testWindowsNotification() async {
    if (Platform.isWindows) {
      try {
        await _showWindowsToast('Test Notification', 'This is a test notification from Maximize!');
        print('[NotificationService] Test Windows notification sent');
      } catch (e) {
        print('[NotificationService] Test notification error: $e');
      }
    }
  }
}
