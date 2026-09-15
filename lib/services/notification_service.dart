import 'package:kinetic/models/reminder_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  static NotificationService get instance => _instance;

  late FlutterLocalNotificationsPlugin _notificationsPlugin;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _notificationsPlugin = FlutterLocalNotificationsPlugin();

      // iOS initialization
      if (Platform.isIOS) {
        try {
          final darwinSettings = DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
              debugPrint('[NotificationService] iOS notification: $title');
            },
          );

          final initSettings = InitializationSettings(iOS: darwinSettings);
          await _notificationsPlugin.initialize(initSettings);

          final iOSPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
          await iOSPlugin?.requestPermissions(alert: true, badge: true, sound: true);

          debugPrint('[NotificationService] ✅ iOS initialized');
        } catch (e) {
          debugPrint('[NotificationService] iOS init error: $e');
        }
      }

      // macOS initialization
      if (Platform.isMacOS) {
        try {
          final darwinSettings = DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
              debugPrint('[NotificationService] macOS notification: $title');
            },
          );

          final initSettings = InitializationSettings(macOS: darwinSettings);
          await _notificationsPlugin.initialize(initSettings);

          final macOSPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>();
          await macOSPlugin?.requestPermissions(alert: true, badge: true, sound: true);

          debugPrint('[NotificationService] ✅ macOS initialized');
        } catch (e) {
          debugPrint('[NotificationService] macOS init error: $e');
        }
      }

      // Android initialization
      if (Platform.isAndroid) {
        try {
          const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
          final initSettings = InitializationSettings(android: androidSettings);
          await _notificationsPlugin.initialize(initSettings);

          debugPrint('[NotificationService] ✅ Android initialized');
        } catch (e) {
          debugPrint('[NotificationService] Android init error: $e');
        }
      }

      // Windows initialization
      if (Platform.isWindows) {
        try {
          final initSettings = const InitializationSettings();
          await _notificationsPlugin.initialize(initSettings);

          debugPrint('[NotificationService] ✅ Windows initialized');
        } catch (e) {
          debugPrint('[NotificationService] Windows init error: $e');
        }
      }

      // Linux initialization
      if (Platform.isLinux) {
        try {
          final initSettings = const InitializationSettings();
          await _notificationsPlugin.initialize(initSettings);

          debugPrint('[NotificationService] ✅ Linux initialized');
        } catch (e) {
          debugPrint('[NotificationService] Linux init error: $e');
        }
      }

      _isInitialized = true;
      debugPrint('[NotificationService] ✅ Ready on ${Platform.operatingSystem}');
    } catch (e) {
      debugPrint('[NotificationService] ❌ Initialize error: $e');
    }
  }

  Future<void> scheduleNotification(ReminderModel reminder) async {
    if (!_isInitialized) await initialize();

    try {
      final int notificationId = reminder.id.hashCode;
      final DateTime scheduledDateTime = reminder.scheduledTime;

      debugPrint('[NotificationService] 📅 ${reminder.title} at $scheduledDateTime');

      // Android - Full scheduled notification support
      if (Platform.isAndroid) {
        try {
          await _notificationsPlugin.zonedSchedule(
            notificationId,
            reminder.title,
            reminder.body,
            tz.TZDateTime.from(scheduledDateTime, tz.local),
            NotificationDetails(
              android: AndroidNotificationDetails(
                'reminder_channel',
                'Reminders',
                channelDescription: 'Notification reminders',
                importance: Importance.max,
                priority: Priority.high,
                enableVibration: true,
                playSound: true,
                showWhen: true,
              ),
            ),
            androidScheduleMode: AndroidScheduleMode.alarmClock,
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.dateAndTime,
          );
          debugPrint('[NotificationService] ✅ Android scheduled');
        } catch (e) {
          debugPrint('[NotificationService] Android schedule error: $e');
        }
      }

      // iOS - Full scheduled notification support
      if (Platform.isIOS) {
        try {
          await _notificationsPlugin.zonedSchedule(
            notificationId,
            reminder.title,
            reminder.body,
            tz.TZDateTime.from(scheduledDateTime, tz.local),
            const NotificationDetails(
              iOS: DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
            ),
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.dateAndTime,
          );
          debugPrint('[NotificationService] ✅ iOS scheduled');
        } catch (e) {
          debugPrint('[NotificationService] iOS schedule error: $e');
        }
      }

      // macOS - Full scheduled notification support
      if (Platform.isMacOS) {
        try {
          await _notificationsPlugin.zonedSchedule(
            notificationId,
            reminder.title,
            reminder.body,
            tz.TZDateTime.from(scheduledDateTime, tz.local),
            const NotificationDetails(
              macOS: DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
            ),
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.dateAndTime,
          );
          debugPrint('[NotificationService] ✅ macOS scheduled');
        } catch (e) {
          debugPrint('[NotificationService] macOS schedule error: $e');
        }
      }

      // Windows - Immediate notification (scheduling limited)
      if (Platform.isWindows) {
        try {
          await _notificationsPlugin.show(
            notificationId,
            reminder.title,
            reminder.body,
            const NotificationDetails(),
          );
          debugPrint('[NotificationService] ✅ Windows shown');
        } catch (e) {
          debugPrint('[NotificationService] Windows show error: $e');
        }
      }

      // Linux - System notification
      if (Platform.isLinux) {
        try {
          await _notificationsPlugin.show(
            notificationId,
            reminder.title,
            reminder.body,
            const NotificationDetails(),
          );
          debugPrint('[NotificationService] ✅ Linux shown');
        } catch (e) {
          debugPrint('[NotificationService] Linux show error: $e');
        }
      }
    } catch (e) {
      debugPrint('[NotificationService] ❌ Schedule error: $e');
    }
  }

  Future<void> cancelNotification(String notificationId) async {
    try {
      await _notificationsPlugin.cancel(notificationId.hashCode);
      debugPrint('[NotificationService] Canceled: $notificationId');
    } catch (e) {
      debugPrint('[NotificationService] Cancel error: $e');
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await _notificationsPlugin.cancelAll();
      debugPrint('[NotificationService] Canceled all');
    } catch (e) {
      debugPrint('[NotificationService] Cancel all error: $e');
    }
  }
}
