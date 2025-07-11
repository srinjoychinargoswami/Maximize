import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:maximize/models/reminder_model.dart';
import 'package:maximize/models/database.dart'; // ADDED: Import database for reminder management
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:win_toast/win_toast.dart';
import 'dart:async';

// ADDED: Proper ReminderService class for database operations
class ReminderService {
  final AppDatabase _database;

  ReminderService(this._database);

  // FIXED: Fetch all reminders from database using fromData constructor
  Future<List<ReminderModel>> getReminders() async {
    try {
      final reminderDataList = await _database.getAllReminders();
      return reminderDataList.map((reminderData) => ReminderModel.fromData(reminderData)).toList(); // FIXED: Use fromData instead of fromMap
    } catch (e) {
      print('Error fetching reminders: $e');
      return [];
    }
  }

  // ADDED: Fetch reminders with filtering options
  Future<List<ReminderModel>> getRemindersFiltered({
    bool? completed,
    bool? isToday,
    bool? isUpcoming,
  }) async {
    try {
      final allReminders = await getReminders();
      return allReminders.where((reminder) {
        if (completed != null && reminder.completed != completed) return false;
        if (isToday == true && !reminder.isToday) return false;
        if (isUpcoming == true && !reminder.isUpcoming) return false;
        return true;
      }).toList();
    } catch (e) {
      print('Error fetching filtered reminders: $e');
      return [];
    }
  }

  // ADDED: Get today's reminders for dashboard
  Future<List<ReminderModel>> getTodaysReminders() async {
    try {
      return await getRemindersFiltered(isToday: true);
    } catch (e) {
      print('Error fetching today\'s reminders: $e');
      return [];
    }
  }

  // ADDED: Get completed reminders for productivity tracking
  Future<List<ReminderModel>> getCompletedReminders({DateTime? date}) async {
    try {
      final reminders = await getReminders();
      return reminders.where((reminder) {
        if (!reminder.completed) return false;
        if (date != null && reminder.completedAt != null) {
          return _isSameDay(reminder.completedAt!, date);
        }
        return reminder.completed;
      }).toList();
    } catch (e) {
      print('Error fetching completed reminders: $e');
      return [];
    }
  }

  // ADDED: Get overdue reminders
  Future<List<ReminderModel>> getOverdueReminders() async {
    try {
      final reminders = await getReminders();
      final now = DateTime.now();
      return reminders.where((reminder) {
        return !reminder.completed && reminder.scheduledTime.isBefore(now);
      }).toList();
    } catch (e) {
      print('Error fetching overdue reminders: $e');
      return [];
    }
  }

  // FIXED: Add reminder to database and schedule notification
  Future<void> addReminder(ReminderModel reminder) async {
    try {
      await _database.insertReminder(reminder); // FIXED: Remove return assignment since insertReminder returns void
      
      // Schedule notification if reminder is not completed and in future
      if (!reminder.completed && reminder.scheduledTime.isAfter(DateTime.now())) {
        await NotificationService.instance.scheduleNotification(reminder);
      }
    } catch (e) {
      print('Error adding reminder: $e');
    }
  }

  // ADDED: Update reminder in database
  Future<void> updateReminder(ReminderModel reminder) async {
    try {
      await _database.updateReminder(reminder);
      
      // Cancel existing notification and reschedule if needed
      await NotificationService.instance.cancelNotification(reminder.id);
      
      if (!reminder.completed && reminder.scheduledTime.isAfter(DateTime.now())) {
        await NotificationService.instance.scheduleNotification(reminder);
      }
    } catch (e) {
      print('Error updating reminder: $e');
    }
  }

  // ADDED: Toggle reminder completion status (for checkbox functionality)
  Future<void> toggleReminderCompletion(String reminderId) async {
    try {
      final reminder = await getReminderById(reminderId);
      if (reminder != null) {
        final updatedReminder = reminder.toggleCompletion();
        await updateReminder(updatedReminder);
        
        // Cancel notification if completed
        if (updatedReminder.completed) {
          await NotificationService.instance.cancelNotification(reminderId);
        }
      }
    } catch (e) {
      print('Error toggling reminder completion: $e');
    }
  }

  // ADDED: Mark reminder as completed (for checkbox functionality)
  Future<void> markReminderCompleted(String reminderId) async {
    try {
      final reminder = await getReminderById(reminderId);
      if (reminder != null && !reminder.completed) {
        final updatedReminder = reminder.copyWith(
          completed: true,
          completedAt: DateTime.now(),
        );
        await updateReminder(updatedReminder);
        
        // Cancel notification since it's completed
        await NotificationService.instance.cancelNotification(reminderId);
      }
    } catch (e) {
      print('Error marking reminder as completed: $e');
    }
  }

  // ADDED: Mark reminder as incomplete (for checkbox functionality)
  Future<void> markReminderIncomplete(String reminderId) async {
    try {
      final reminder = await getReminderById(reminderId);
      if (reminder != null && reminder.completed) {
        final updatedReminder = reminder.copyWith(
          completed: false,
          completedAt: null,
        );
        await updateReminder(updatedReminder);
        
        // Reschedule notification if it's still in the future
        if (updatedReminder.scheduledTime.isAfter(DateTime.now())) {
          await NotificationService.instance.scheduleNotification(updatedReminder);
        }
      }
    } catch (e) {
      print('Error marking reminder as incomplete: $e');
    }
  }

  // ADDED: Get reminder by ID
  Future<ReminderModel?> getReminderById(String id) async {
    try {
      final reminders = await getReminders();
      return reminders.firstWhere(
        (reminder) => reminder.id == id,
        orElse: () => throw Exception('Reminder not found'),
      );
    } catch (e) {
      print('Error fetching reminder by ID: $e');
      return null;
    }
  }

  // ADDED: Delete reminder from database and cancel notifications
  Future<void> deleteReminder(String reminderId) async {
    try {
      final reminder = await getReminderById(reminderId);
      if (reminder != null) {
        // Cancel all notifications for this reminder
        await NotificationService.instance.deleteReminderWithCleanup(reminder);
        
        // Delete from database
        await _database.deleteReminder(reminderId);
      }
    } catch (e) {
      print('Error deleting reminder: $e');
    }
  }

  // ADDED: Get reminder statistics for productivity tracking
  Future<Map<String, int>> getReminderStats() async {
    try {
      final reminders = await getReminders();
      final completed = reminders.where((reminder) => reminder.completed).length;
      final pending = reminders.where((reminder) => !reminder.completed).length;
      final overdue = reminders.where((reminder) => 
        !reminder.completed && reminder.scheduledTime.isBefore(DateTime.now())).length;
      
      return {
        'total': reminders.length,
        'completed': completed,
        'pending': pending,
        'overdue': overdue,
      };
    } catch (e) {
      print('Error getting reminder stats: $e');
      return {'total': 0, 'completed': 0, 'pending': 0, 'overdue': 0};
    }
  }

  // ADDED: Helper method to check if two dates are the same day
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

// ENHANCED: NotificationService class with better integration
class NotificationService {
  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  static NotificationService get instance => _instance;

  FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;
  bool _isInitialized = false;
  
  // Store Windows timers for proper scheduling
  final Map<String, Timer> _windowsTimers = {};

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      tz.initializeTimeZones();
      
      // Set proper timezone based on system
      if (Platform.isWindows) {
        // Use system timezone for Windows - ENHANCED: Make this more dynamic
        tz.setLocalLocation(tz.getLocation('America/New_York')); // You can make this dynamic
      } else {
        tz.setLocalLocation(tz.local);
      }

      if (Platform.isWindows) {
        final result = await WinToast.instance().initialize(
          aumId: 'com.maximize.productivity',
          displayName: 'Maximize Productivity App',
          iconPath: '',
          clsid: '936C39FC-6BBC-4A57-B8F8-7C627E401B2F',
        );
        print(result
            ? '[NotificationService] WinToast initialized for Windows'
            : '[NotificationService] Failed to initialize WinToast');
      } else {
        _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
        const initializationSettings = InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        );
        
        // ENHANCED: Add notification tap handling
        await _flutterLocalNotificationsPlugin!.initialize(
          initializationSettings,
          onDidReceiveNotificationResponse: _onNotificationTap, // ADDED: Handle notification taps
        );

        if (Platform.isAndroid) {
          final androidPlugin = _flutterLocalNotificationsPlugin!
              .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
          await androidPlugin?.requestNotificationsPermission();
        }
      }

      _isInitialized = true;
      print('[NotificationService] Initialized on ${Platform.operatingSystem}');
    } catch (e) {
      print('[NotificationService] Initialization error: $e');
      _isInitialized = false;
    }
  }

  // ADDED: Handle notification tap events
  void _onNotificationTap(NotificationResponse response) {
    print('[NotificationService] Notification tapped: ${response.payload}');
    // TODO: Add navigation logic here to open specific reminder/task
    // You can use this to navigate to the reminder details page
  }

  Future<void> scheduleNotification(ReminderModel reminder) async {
    try {
      if (!_isInitialized) await initialize();

      // ENHANCED: Skip scheduling if reminder is already completed
      if (reminder.completed) {
        print('[NotificationService] Reminder is completed, skipping scheduling');
        return;
      }

      // Validate that the scheduled time is in the future
      final now = DateTime.now();
      if (reminder.scheduledTime.isBefore(now)) {
        print('[NotificationService] Scheduled time is in the past: ${reminder.scheduledTime}');
        return;
      }

      print('[NotificationService] Scheduling notification for: ${reminder.scheduledTime}');

      if (reminder.isRecurring && reminder.recurrenceRule != null) {
        final futureLimit = now.add(const Duration(days: 90));
        final occurrences = _generateRecurrenceOccurrences(
          reminder.scheduledTime,
          reminder.recurrenceRule!,
          now,
          futureLimit,
          reminder.recurrenceExceptionDates,
        ).take(10);

        for (int i = 0; i < occurrences.length; i++) {
          final occurrence = occurrences.elementAt(i);
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
    } catch (e) {
      print('[NotificationService] Error scheduling: $e');
    }
  }

  Future<void> _scheduleWindowsNotification(ReminderModel reminder) async {
    final now = DateTime.now();
    final delay = reminder.scheduledTime.difference(now);
    
    print('[NotificationService] Windows notification delay: ${delay.inMinutes} minutes');
    
    if (delay.isNegative) {
      print('[NotificationService] Time is in the past, showing immediately');
      await _showWindowsToast(reminder.title, reminder.body);
    } else {
      // Cancel any existing timer for this reminder
      _windowsTimers[reminder.id]?.cancel();
      
      // Create new timer
      _windowsTimers[reminder.id] = Timer(delay, () async {
        print('[NotificationService] Firing Windows notification for: ${reminder.title}');
        await _showWindowsToast(reminder.title, reminder.body);
        _windowsTimers.remove(reminder.id);
      });
      
      print('[NotificationService] Windows timer set for ${delay.inMinutes} minutes from now');
    }
  }

  Future<void> _showWindowsToast(String title, String body) async {
    try {
      final limitedTitle = (title.trim().isNotEmpty ? title.trim() : "Reminder");
      final limitedBody = (body.trim().isNotEmpty ? body.trim() : "Notification");
      
      // Ensure we don't exceed Windows toast limits
      final finalTitle = limitedTitle.length > 100 ? limitedTitle.substring(0, 100) : limitedTitle;
      final finalBody = limitedBody.length > 200 ? limitedBody.substring(0, 200) : limitedBody;
      
      await WinToast.instance().showToast(
        toast: Toast(
          duration: ToastDuration.short,
          children: [
            ToastChildVisual(
              binding: ToastVisualBinding(
                children: [
                  ToastVisualBindingChildText(text: finalTitle, id: 1),
                  ToastVisualBindingChildText(text: finalBody, id: 2),
                ],
              ),
            ),
          ],
        ),
      );
      print('[NotificationService] Windows toast shown: $finalTitle');
    } catch (e) {
      print('[NotificationService] Error showing Windows toast: $e');
    }
  }

  Future<void> _scheduleFlutterNotification(ReminderModel reminder) async {
    try {
      final notificationIdInt = int.tryParse(reminder.notificationId);
      if (notificationIdInt == null) { 
        print('[Error] Invalid notificationId: ${reminder.notificationId}');
        return;
      }

      // ENHANCED: Add action buttons for dismiss/snooze (foundation for future feature)
      const androidDetails = AndroidNotificationDetails(
        'reminder_channel_id',
        'Reminders',
        channelDescription: 'Channel for scheduled reminders',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
        // ADDED: Foundation for future snooze/dismiss functionality
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            'dismiss',
            'Dismiss',
            cancelNotification: true,
          ),
          // TODO: Add snooze action in future update
        ],
      );

      const platformChannelSpecifics = NotificationDetails(
        android: androidDetails,
      );

      // Convert to timezone-aware datetime
      final scheduledDate = tz.TZDateTime.from(reminder.scheduledTime, tz.local);
      final now = tz.TZDateTime.now(tz.local);
      
      print('[NotificationService] Current time: $now');
      print('[NotificationService] Scheduled time: $scheduledDate');
      print('[NotificationService] Time difference: ${scheduledDate.difference(now).inMinutes} minutes');

      // Double-check that we're scheduling for the future
      if (scheduledDate.isBefore(now)) {
        print('[NotificationService] Scheduled date is in the past, cannot schedule');
        return;
      }

      await _flutterLocalNotificationsPlugin!.zonedSchedule(
        notificationIdInt,
        reminder.title,
        reminder.body,
        scheduledDate,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: reminder.id // ENHANCED: Use reminder ID for better tracking
      );
      
      print('[NotificationService] Flutter notification scheduled successfully');
    } catch (e) {
      print('[NotificationService] Error scheduling Flutter notification: $e');
    }
  }

  // Cancel a specific notification
  Future<void> cancelNotification(String reminderId) async {
    try {
      // Cancel Windows timer if exists
      _windowsTimers[reminderId]?.cancel();
      _windowsTimers.remove(reminderId);
      
      // Cancel Flutter notification
      if (_flutterLocalNotificationsPlugin != null) {
        final notificationId = int.tryParse(reminderId);
        if (notificationId != null) {
          await _flutterLocalNotificationsPlugin!.cancel(notificationId);
        }
      }
      
      print('[NotificationService] Cancelled notification: $reminderId');
    } catch (e) {
      print('[NotificationService] Error cancelling notification: $e');
    }
  }

  // ENHANCED: Cancel notifications with better error handling
  Future<void> cancelNotifications(ReminderModel reminder) async {
    try {
      // Cancel Windows timer
      _windowsTimers[reminder.id]?.cancel();
      _windowsTimers.remove(reminder.id);

      // Cancel Flutter notification
      if (_flutterLocalNotificationsPlugin != null) {
        final notificationId = int.tryParse(reminder.notificationId);
        if (notificationId != null) {
          await _flutterLocalNotificationsPlugin!.cancel(notificationId);
        }
      }

      print('[NotificationService] Cancelled notification: ${reminder.notificationId}');
    } catch (e) {
      print('[NotificationService] Error cancelling notification: $e');
    }
  }

  // Cancel all recurring instances generated from a base reminder
  Future<void> cancelRecurringInstances(String baseNotificationId, {int maxInstances = 10}) async {
    for (int i = 0; i < maxInstances; i++) {
      final instanceId = '$baseNotificationId\_$i';
      final parsedId = int.tryParse(instanceId);

      // Cancel scheduled Android/iOS notification
      if (_flutterLocalNotificationsPlugin != null && parsedId != null) {
        await _flutterLocalNotificationsPlugin!.cancel(parsedId);
        print('[NotificationService] Cancelled recurring Flutter notification ID: $parsedId');
      }

      // Cancel Windows timer if exists
      _windowsTimers.removeWhere((key, _) => key == instanceId);
    }

    print('[NotificationService] Cancelled all recurring instances of: $baseNotificationId');
  }

  // ENHANCED: Complete reminder cleanup with better integration
  Future<void> deleteReminderWithCleanup(ReminderModel reminder) async {
    await cancelNotification(reminder.notificationId);
    if (reminder.isRecurring) {
      await cancelRecurringInstances(reminder.notificationId);
    }

    // Note: Database deletion should be handled by ReminderService
    print('[NotificationService] Cleaned up notifications for reminder: ${reminder.id}');
  }

  // ENHANCED: Generate recurrence occurrences with better limits
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
      
      // ENHANCED: Better safety check to prevent infinite loops
      if (occurrenceCount > 50) {
        print('[NotificationService] Reached maximum occurrences limit (50)');
        break;
      }
    }

    return occurrences;
  }

  Map<String, String> _parseRRule(String rrule) {
    return Map.fromEntries(
      rrule.split(';').map((part) {
        final keyValue = part.split('=');
        return MapEntry(keyValue[0], keyValue[1]);
      }),
    );
  }

  DateTime _getNextOccurrence(DateTime current, String frequency, int interval) {
    switch (frequency.toUpperCase()) {
      case 'HOURLY': return current.add(Duration(hours: interval));
      case 'DAILY': return current.add(Duration(days: interval));
      case 'WEEKLY': return current.add(Duration(days: 7 * interval));
      case 'MONTHLY': return DateTime(current.year, current.month + interval, current.day, current.hour, current.minute);
      case 'YEARLY': return DateTime(current.year + interval, current.month, current.day, current.hour, current.minute);
      default: return current.add(Duration(days: interval));
    }
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  // ENHANCED: Cleanup method with better resource management
  void dispose() {
    print('[NotificationService] Disposing ${_windowsTimers.length} Windows timers');
    for (final timer in _windowsTimers.values) {
      timer.cancel();
    }
    _windowsTimers.clear();
    print('[NotificationService] Disposed successfully');
  }
}
