import 'dart:io';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:maximize/models/reminder_model.dart';
import 'package:maximize/models/database.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:win_toast/win_toast.dart';


// 1. ReminderService
// Handles Database Operations & Business Logic

class ReminderService {
  final AppDatabase _database;

  ReminderService(this._database);

  Future<List<ReminderModel>> getReminders() async {
    try {
      final reminderDataList = await _database.getAllReminders();
      return reminderDataList.map((reminderData) => ReminderModel.fromData(reminderData)).toList();
    } catch (e) {
      print('Error fetching reminders: $e');
      return [];
    }
  }

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

  Future<List<ReminderModel>> getTodaysReminders() async {
    try {
      return await getRemindersFiltered(isToday: true);
    } catch (e) {
      print('Error fetching today\'s reminders: $e');
      return [];
    }
  }

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

  Future<void> addReminder(ReminderModel reminder) async {
    try {
      await _database.insertReminder(reminder);
      
      if (!reminder.completed && reminder.scheduledTime.isAfter(DateTime.now())) {
        await NotificationService.instance.scheduleNotification(reminder);
      }
    } catch (e) {
      print('Error adding reminder: $e');
    }
  }

  Future<void> insertReminder(ReminderModel reminder) async {
  try {
    // Cancel any stale notification first
    await NotificationService.instance.cancelNotification(reminder.id);
    
    // Re-insert into database
    await _database.insertReminder(reminder);
    
    // Reschedule notification if still in future
    if (!reminder.completed && reminder.scheduledTime.isAfter(DateTime.now())) {
      await NotificationService.instance.scheduleNotification(reminder);
    }
    
    print('[ReminderService] Reminder restored: ${reminder.title}');
  } catch (e) {
    print('Error inserting reminder: $e');
    rethrow;
  }
}

  Future<void> updateReminder(ReminderModel reminder) async {
    try {
      await _database.updateReminder(reminder);
      
      await NotificationService.instance.cancelNotification(reminder.id);
      
      if (!reminder.completed && reminder.scheduledTime.isAfter(DateTime.now())) {
        await NotificationService.instance.scheduleNotification(reminder);
      }
    } catch (e) {
      print('Error updating reminder: $e');
    }
  }

  Future<void> toggleReminderCompletion(String reminderId) async {
    try {
      final reminder = await getReminderById(reminderId);
      if (reminder != null) {
        final updatedReminder = reminder.toggleCompletion();
        await updateReminder(updatedReminder);
        
        if (updatedReminder.completed) {
          await NotificationService.instance.cancelNotification(reminderId);
        }
      }
    } catch (e) {
      print('Error toggling reminder completion: $e');
    }
  }

  Future<void> markReminderCompleted(String reminderId) async {
    try {
      final reminder = await getReminderById(reminderId);
      if (reminder != null && !reminder.completed) {
        final updatedReminder = reminder.copyWith(
          completed: true,
          completedAt: DateTime.now(),
        );
        await updateReminder(updatedReminder);
        await NotificationService.instance.cancelNotification(reminderId);
      }
    } catch (e) {
      print('Error marking reminder as completed: $e');
    }
  }

  Future<void> markReminderIncomplete(String reminderId) async {
    try {
      final reminder = await getReminderById(reminderId);
      if (reminder != null && reminder.completed) {
        final updatedReminder = reminder.copyWith(
          completed: false,
          completedAt: null,
        );
        await updateReminder(updatedReminder);
        
        if (updatedReminder.scheduledTime.isAfter(DateTime.now())) {
          await NotificationService.instance.scheduleNotification(updatedReminder);
        }
      }
    } catch (e) {
      print('Error marking reminder as incomplete: $e');
    }
  }

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

  Future<void> deleteReminder(String reminderId) async {
    try {
      final reminder = await getReminderById(reminderId);
      if (reminder != null) {
        await NotificationService.instance.deleteReminderWithCleanup(reminder);
        await _database.deleteReminder(reminderId);
      }
    } catch (e) {
      print('Error deleting reminder: $e');
    }
  }

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

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

// 2. NotificationService
// Handles Platform-Specific Notifications (Windows, Android, macOS)

class NotificationService {
  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  static NotificationService get instance => _instance;

  FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;
  bool _isInitialized = false;
  
  final Map<String, Timer> _windowsTimers = {};

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      tz.initializeTimeZones();
      
      // Set proper timezone
      if (Platform.isWindows) {
        tz.setLocalLocation(tz.getLocation('America/New_York')); 
      } else {
        // macOS and Android usually handle local time correctly automatically
        tz.setLocalLocation(tz.local);
      }

      if (Platform.isWindows) {
        // --- WINDOWS INIT ---
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
        // --- ANDROID & MACOS INIT ---
        _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
        
        // Android Settings
        const AndroidInitializationSettings initializationSettingsAndroid =
            AndroidInitializationSettings('@mipmap/ic_launcher');
            
        // ADDED: macOS Settings (Critical for MacBook support)
        const DarwinInitializationSettings initializationSettingsDarwin =
            DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );
        
        // Combine Settings
        final InitializationSettings initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          macOS: initializationSettingsDarwin, // <--- ADDED THIS
          iOS: initializationSettingsDarwin,   // Good practice
        );
        
        await _flutterLocalNotificationsPlugin!.initialize(
          initializationSettings,
          onDidReceiveNotificationResponse: _onNotificationTap,
        );

        // Request Permissions Explicitly
        if (Platform.isAndroid) {
          final androidPlugin = _flutterLocalNotificationsPlugin!
              .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
          await androidPlugin?.requestNotificationsPermission();
        } 
        // ADDED: macOS Permission Request
        else if (Platform.isMacOS) {
           await _flutterLocalNotificationsPlugin!
              .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(
                alert: true,
                badge: true,
                sound: true,
              );
        }
      }

      _isInitialized = true;
      print('[NotificationService] Initialized on ${Platform.operatingSystem}');
    } catch (e) {
      print('[NotificationService] Initialization error: $e');
      _isInitialized = false;
    }
  }

  void _onNotificationTap(NotificationResponse response) {
    print('[NotificationService] Notification tapped: ${response.payload}');
  }

  Future<void> scheduleNotification(ReminderModel reminder) async {
    try {
      if (!_isInitialized) await initialize();

      if (reminder.completed) {
        print('[NotificationService] Reminder is completed, skipping scheduling');
        return;
      }

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
    
    if (delay.isNegative) {
      await _showWindowsToast(reminder.title, reminder.body);
    } else {
      _windowsTimers[reminder.id]?.cancel();
      _windowsTimers[reminder.id] = Timer(delay, () async {
        await _showWindowsToast(reminder.title, reminder.body);
        _windowsTimers.remove(reminder.id);
      });
    }
  }

  Future<void> _showWindowsToast(String title, String body) async {
    try {
      final limitedTitle = (title.trim().isNotEmpty ? title.trim() : "Reminder");
      final limitedBody = (body.trim().isNotEmpty ? body.trim() : "Notification");
      
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
    } catch (e) {
      print('[NotificationService] Error showing Windows toast: $e');
    }
  }

  Future<void> _scheduleFlutterNotification(ReminderModel reminder) async {
    try {
      final notificationIdInt = int.tryParse(reminder.notificationId);
      if (notificationIdInt == null) return;

      // Android Details
      const androidDetails = AndroidNotificationDetails(
        'reminder_channel_id',
        'Reminders',
        channelDescription: 'Channel for scheduled reminders',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            'dismiss',
            'Dismiss',
            cancelNotification: true,
          ),
        ],
      );

      // ADDED: macOS Details (Critical for MacBook)
      const darwinDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      // Combine Details
      const platformChannelSpecifics = NotificationDetails(
        android: androidDetails,
        macOS: darwinDetails, // <--- ADDED THIS
        iOS: darwinDetails,
      );

      final scheduledDate = tz.TZDateTime.from(reminder.scheduledTime, tz.local);
      final now = tz.TZDateTime.now(tz.local);
      
      if (scheduledDate.isBefore(now)) return;

      await _flutterLocalNotificationsPlugin!.zonedSchedule(
        notificationIdInt,
        reminder.title,
        reminder.body,
        scheduledDate,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: reminder.id
      );
      
      print('[NotificationService] Flutter notification scheduled successfully');
    } catch (e) {
      print('[NotificationService] Error scheduling Flutter notification: $e');
    }
  }

  Future<void> cancelNotification(String reminderId) async {
    try {
      _windowsTimers[reminderId]?.cancel();
      _windowsTimers.remove(reminderId);
      
      if (_flutterLocalNotificationsPlugin != null) {
        final notificationId = int.tryParse(reminderId);
        if (notificationId != null) {
          await _flutterLocalNotificationsPlugin!.cancel(notificationId);
        }
      }
    } catch (e) {
      print('[NotificationService] Error cancelling notification: $e');
    }
  }

  // Legacy method wrapper
  Future<void> cancelNotifications(ReminderModel reminder) async {
      await cancelNotification(reminder.notificationId);
  }

  Future<void> cancelRecurringInstances(String baseNotificationId, {int maxInstances = 10}) async {
    for (int i = 0; i < maxInstances; i++) {
      final instanceId = '${baseNotificationId}_$i'; // Fixed string interpolation
      final parsedId = int.tryParse(instanceId);

      if (_flutterLocalNotificationsPlugin != null && parsedId != null) {
        await _flutterLocalNotificationsPlugin!.cancel(parsedId);
      }
      _windowsTimers.removeWhere((key, _) => key == instanceId);
    }
  }

  Future<void> deleteReminderWithCleanup(ReminderModel reminder) async {
    await cancelNotification(reminder.notificationId);
    if (reminder.isRecurring) {
      await cancelRecurringInstances(reminder.notificationId);
    }
  }

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
      
      if (occurrenceCount > 50) break;
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

  void dispose() {
    for (final timer in _windowsTimers.values) {
      timer.cancel();
    }
    _windowsTimers.clear();
  }
}
