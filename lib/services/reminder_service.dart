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

      if (reminder.isRecurring && reminder.recurrenceRule != null) {
        // Schedule all upcoming instances (e.g., next 10 occurrences)
        final now = DateTime.now();
        final futureLimit = now.add(Duration(days: 90)); // Next 3 months

        final occurrences = _generateRecurrenceOccurrences(
          reminder.scheduledTime,
          reminder.recurrenceRule!,
          now,
          futureLimit,
          reminder.recurrenceExceptionDates,
        );

        // Limit to 10 occurrences to avoid overwhelming the notification system
        final limitedOccurrences = occurrences.take(10).toList();

        for (int i = 0; i < limitedOccurrences.length; i++) {
          final occurrence = limitedOccurrences[i];
          final instanceReminder = reminder.copyWith(
            id: '${reminder.id}_$i',
            scheduledTime: occurrence,
            notificationId: '${reminder.notificationId}_$i',
          );

          if (Platform.isWindows) {
            await _scheduleWindowsNotification(instanceReminder);
          } else {
            await _scheduleFlutterNotification(instanceReminder);
          }
        }
      } else {
        if (Platform.isWindows) {
          await _scheduleWindowsNotification(reminder);
        } else {
          await _scheduleFlutterNotification(reminder);
        }
      }

      print('[NotificationService] Scheduled: ${reminder.title} @ ${reminder.scheduledTime}');
    } catch (e) {
      print('[NotificationService] Error scheduling: $e');
    }
  }

  // Generate recurrence occurrences based on RRULE
  List<DateTime> _generateRecurrenceOccurrences(
    DateTime startDate,
    String rrule,
    DateTime rangeStart,
    DateTime rangeEnd,
    List<DateTime>? exceptions,
  ) {
    List<DateTime> occurrences = [];
    Map<String, String> rules = _parseRRule(rrule);
    
    String? frequency = rules['FREQ'];
    int interval = int.parse(rules['INTERVAL'] ?? '1');
    int? count = rules['COUNT'] != null ? int.parse(rules['COUNT']!) : null;
    
    DateTime current = startDate;
    int occurrenceCount = 0;
    
    while (current.isBefore(rangeEnd) && (count == null || occurrenceCount < count)) {
      if (current.isAfter(rangeStart) || current.isAtSameMomentAs(rangeStart)) {
        bool isException = exceptions?.any((ex) => _isSameDay(ex, current)) ?? false;
        if (!isException) {
          occurrences.add(current);
          occurrenceCount++;
        }
      }
      
      current = _getNextOccurrence(current, frequency!, interval);
      
      // Safety check to prevent infinite loops
      if (occurrenceCount > 50) break;
    }
    
    return occurrences;
  }

  Map<String, String> _parseRRule(String rrule) {
    Map<String, String> rules = {};
    List<String> parts = rrule.split(';');
    
    for (String part in parts) {
      List<String> keyValue = part.split('=');
      if (keyValue.length == 2) {
        rules[keyValue[0]] = keyValue[1];
      }
    }
    
    return rules;
  }

  DateTime _getNextOccurrence(DateTime current, String frequency, int interval) {
    switch (frequency.toUpperCase()) {
      case 'HOURLY':
        return current.add(Duration(hours: interval));
      case 'DAILY':
        return current.add(Duration(days: interval));
      case 'WEEKLY':
        return current.add(Duration(days: 7 * interval));
      case 'MONTHLY':
        return DateTime(current.year, current.month + interval, current.day, 
                       current.hour, current.minute);
      case 'YEARLY':
        return DateTime(current.year + interval, current.month, current.day, 
                       current.hour, current.minute);
      default:
        return current.add(Duration(days: interval));
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
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
      // Validate inputs before sending to win_toast
      final String safeTitle = (title.trim().isNotEmpty) ? title.trim() : "Reminder";
      final String safeBody = (body.trim().isNotEmpty) ? body.trim() : "Notification";
      
      // Limit string length to prevent issues
      final String limitedTitle = safeTitle.length > 100 ? safeTitle.substring(0, 100) : safeTitle;
      final String limitedBody = safeBody.length > 200 ? safeBody.substring(0, 200) : safeBody;
      
      print('[DEBUG] Toast title: "$limitedTitle" (length: ${limitedTitle.length})');
      print('[DEBUG] Toast body: "$limitedBody" (length: ${limitedBody.length})');
      
      // Use the correct win_toast API from search results
      await WinToast.instance().showToast(
        toast: Toast(
          duration: ToastDuration.short,
          children: [
            ToastChildVisual(
              binding: ToastVisualBinding(
                children: [
                  ToastVisualBindingChildText(
                    text: limitedTitle,
                    id: 1,
                  ),
                  ToastVisualBindingChildText(
                    text: limitedBody,
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
      
      // Fallback: try with minimal safe content
      try {
        await WinToast.instance().showToast(
          toast: Toast(
            duration: ToastDuration.short,
            children: [
              ToastChildVisual(
                binding: ToastVisualBinding(
                  children: [
                    ToastVisualBindingChildText(
                      text: "Reminder",
                      id: 1,
                    ),
                    ToastVisualBindingChildText(
                      text: "Notification",
                      id: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      } catch (fallbackError) {
        print('[NotificationService] Fallback toast also failed: $fallbackError');
      }
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

  Future<void> cancelNotification(String notificationId, {bool isSeries = false}) async {
    try {
      // Ensure initialization before use
      if (!_isInitialized) {
        await initialize();
      }

      if (Platform.isWindows) {
        // WinToast doesn't support cancellation of scheduled notifications
        print('[NotificationService] Windows notification cancellation not fully supported');
      } else {
        if (_flutterLocalNotificationsPlugin == null) {
          throw Exception('Failed to initialize notification plugin');
        }

        if (isSeries) {
          // Cancel all notifications for the series
          // Assuming notificationId is base id, cancel all with suffixes
          for (int i = 0; i < 10; i++) {
            final id = int.tryParse('${notificationId}_$i');
            if (id != null) {
              await _flutterLocalNotificationsPlugin!.cancel(id);
            }
          }
        } else {
          final int notificationIdInt = int.parse(notificationId);
          await _flutterLocalNotificationsPlugin!.cancel(notificationIdInt);
        }
      }
      
      print('[NotificationService] Cancelled notification with id: $notificationId');
    } catch (e) {
      print('[NotificationService] Error canceling notification: $e');
    }
  }

  Future<void> modifyNotification(ReminderModel reminder, {bool isSeries = false}) async {
    try {
      await cancelNotification(reminder.notificationId, isSeries: isSeries);
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

  // Cancel all notifications for a specific recurring series
  Future<void> cancelRecurringSeries(String baseNotificationId) async {
    await cancelNotification(baseNotificationId, isSeries: true);
  }

  // Reschedule recurring reminders (useful when updating recurrence rules)
  Future<void> rescheduleRecurringReminder(ReminderModel reminder) async {
    try {
      // Cancel existing series
      await cancelNotification(reminder.notificationId, isSeries: true);
      
      // Reschedule with new rules
      await scheduleNotification(reminder);
      
      print('[NotificationService] Rescheduled recurring reminder: ${reminder.title}');
    } catch (e) {
      print('[NotificationService] Error rescheduling recurring reminder: $e');
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