import 'package:uuid/uuid.dart';

class ReminderModel {
  final String id; // UUID for internal tracking
  final String title; // Title shown in notification
  final String body; // Body/content of the notification
  final DateTime scheduledTime; // Exact time to trigger notification
  final String notificationId; // Changed to String to match flutter_local_notifications
  
  // Recurring reminder fields
  final bool isRecurring;
  final ReminderRecurrencePattern? recurrencePattern;
  String? recurrenceRule; // RRULE format for complex patterns
  final String? parentReminderId; // For linking recurring instances
  final List<DateTime>? recurrenceExceptionDates; // Dates to skip
  final DateTime? recurrenceEndDate; // When recurrence stops
  final int? recurrenceCount; // Number of occurrences

  ReminderModel({
    String? id,
    required this.title,
    required this.body,
    required this.scheduledTime,
    String? notificationId,
    this.isRecurring = false,
    this.recurrencePattern,
    this.recurrenceRule,
    this.parentReminderId,
    this.recurrenceExceptionDates,
    this.recurrenceEndDate,
    this.recurrenceCount,
  })  : id = id ?? const Uuid().v4(),
        notificationId = notificationId ?? DateTime.now().millisecondsSinceEpoch.toString();

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'body': body,
        'scheduledTime': scheduledTime.toIso8601String(),
        'notificationId': notificationId,
        'isRecurring': isRecurring,
        'recurrenceRule': recurrenceRule,
        'parentReminderId': parentReminderId,
        'recurrenceExceptionDates': recurrenceExceptionDates?.map((d) => d.toIso8601String()).join(','),
        'recurrenceEndDate': recurrenceEndDate?.toIso8601String(),
        'recurrenceCount': recurrenceCount,
      };

  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    return ReminderModel(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      scheduledTime: DateTime.parse(map['scheduledTime']),
      notificationId: map['notificationId'],
      isRecurring: map['isRecurring'] ?? false,
      recurrenceRule: map['recurrenceRule'],
      parentReminderId: map['parentReminderId'],
      recurrenceExceptionDates: map['recurrenceExceptionDates'] != null 
          ? map['recurrenceExceptionDates'].split(',')
              .where((d) => d.isNotEmpty)
              .map<DateTime>((d) => DateTime.parse(d))
              .toList()
          : null,
      recurrenceEndDate: map['recurrenceEndDate'] != null 
          ? DateTime.parse(map['recurrenceEndDate'])
          : null,
      recurrenceCount: map['recurrenceCount'],
    );
  }

  ReminderModel copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? scheduledTime,
    String? notificationId,
    bool? isRecurring,
    ReminderRecurrencePattern? recurrencePattern,
    String? recurrenceRule,
    String? parentReminderId,
    List<DateTime>? recurrenceExceptionDates,
    DateTime? recurrenceEndDate,
    int? recurrenceCount,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      notificationId: notificationId ?? this.notificationId,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrencePattern: recurrencePattern ?? this.recurrencePattern,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      parentReminderId: parentReminderId ?? this.parentReminderId,
      recurrenceExceptionDates: recurrenceExceptionDates ?? this.recurrenceExceptionDates,
      recurrenceEndDate: recurrenceEndDate ?? this.recurrenceEndDate,
      recurrenceCount: recurrenceCount ?? this.recurrenceCount,
    );
  }

  // Generate RRULE string based on pattern
  String generateRRule() {
    if (recurrenceRule != null) return recurrenceRule!;
    if (recurrencePattern == null) return '';

    String rrule = 'FREQ=${recurrencePattern!.frequency.name.toUpperCase()}';
    
    if (recurrencePattern!.interval > 1) {
      rrule += ';INTERVAL=${recurrencePattern!.interval}';
    }
    
    if (recurrenceCount != null) {
      rrule += ';COUNT=$recurrenceCount';
    }
    
    if (recurrenceEndDate != null) {
      final until = recurrenceEndDate!.toUtc().toIso8601String()
          .replaceAll('-', '')
          .replaceAll(':', '')
          .split('.')[0] + 'Z';
      rrule += ';UNTIL=$until';
    }
    
    if (recurrencePattern!.byWeekDay != null && recurrencePattern!.byWeekDay!.isNotEmpty) {
      final days = recurrencePattern!.byWeekDay!.map((day) => _weekDayToString(day)).join(',');
      rrule += ';BYDAY=$days';
    }
    
    if (recurrencePattern!.byHour != null && recurrencePattern!.byHour!.isNotEmpty) {
      rrule += ';BYHOUR=${recurrencePattern!.byHour!.join(',')}';
    }
    
    return rrule;
  }

  // Helper method to convert weekday to RRULE format
  String _weekDayToString(int weekDay) {
    const days = ['SU', 'MO', 'TU', 'WE', 'TH', 'FR', 'SA'];
    return days[weekDay % 7];
  }

  // Check if this is a recurring reminder instance
  bool get isRecurringInstance => parentReminderId != null;

  // Get human-readable recurrence description
  String get recurrenceDescription {
    if (!isRecurring || recurrencePattern == null) return 'Does not repeat';
    
    final pattern = recurrencePattern!;
    String description = '';
    
    switch (pattern.frequency) {
      case ReminderRecurrenceFrequency.hourly:
        description = pattern.interval == 1 ? 'Hourly' : 'Every ${pattern.interval} hours';
        break;
      case ReminderRecurrenceFrequency.daily:
        description = pattern.interval == 1 ? 'Daily' : 'Every ${pattern.interval} days';
        break;
      case ReminderRecurrenceFrequency.weekly:
        if (pattern.interval == 1) {
          if (pattern.byWeekDay != null && pattern.byWeekDay!.isNotEmpty) {
            final dayNames = pattern.byWeekDay!.map((day) => _getDayName(day)).join(', ');
            description = 'Weekly on $dayNames';
          } else {
            description = 'Weekly';
          }
        } else {
          description = 'Every ${pattern.interval} weeks';
        }
        break;
      case ReminderRecurrenceFrequency.monthly:
        description = pattern.interval == 1 ? 'Monthly' : 'Every ${pattern.interval} months';
        break;
      case ReminderRecurrenceFrequency.yearly:
        description = pattern.interval == 1 ? 'Yearly' : 'Every ${pattern.interval} years';
        break;
      case ReminderRecurrenceFrequency.custom:
        description = 'Custom pattern';
        break;
    }
    
    if (recurrenceEndDate != null) {
      description += ' until ${recurrenceEndDate!.toLocal().toString().substring(0, 10)}';
    } else if (recurrenceCount != null) {
      description += ' for $recurrenceCount times';
    }
    
    return description;
  }

  String _getDayName(int weekDay) {
    const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    return days[weekDay % 7];
  }

  // Get next scheduled time for recurring reminders
  DateTime? getNextOccurrence() {
    if (!isRecurring || recurrencePattern == null) return null;
    
    final now = DateTime.now();
    if (scheduledTime.isAfter(now)) return scheduledTime;
    
    return _calculateNextOccurrence(scheduledTime, recurrencePattern!);
  }

  DateTime _calculateNextOccurrence(DateTime current, ReminderRecurrencePattern pattern) {
    switch (pattern.frequency) {
      case ReminderRecurrenceFrequency.hourly:
        return current.add(Duration(hours: pattern.interval));
      case ReminderRecurrenceFrequency.daily:
        return current.add(Duration(days: pattern.interval));
      case ReminderRecurrenceFrequency.weekly:
        return current.add(Duration(days: 7 * pattern.interval));
      case ReminderRecurrenceFrequency.monthly:
        return DateTime(
          current.year,
          current.month + pattern.interval,
          current.day,
          current.hour,
          current.minute,
        );
      case ReminderRecurrenceFrequency.yearly:
        return DateTime(
          current.year + pattern.interval,
          current.month,
          current.day,
          current.hour,
          current.minute,
        );
      case ReminderRecurrenceFrequency.custom:
        return current.add(Duration(days: pattern.interval));
    }
  }
}

// Recurrence pattern class specifically for reminders
class ReminderRecurrencePattern {
  final ReminderRecurrenceFrequency frequency;
  final int interval; // Every N hours/days/weeks/months/years
  final List<int>? byWeekDay; // Days of week (0=Sunday, 1=Monday, etc.)
  final List<int>? byHour; // Hours of day (0-23) for hourly reminders
  final List<int>? byMinute; // Minutes of hour (0-59) for minute-level control

  ReminderRecurrencePattern({
    required this.frequency,
    this.interval = 1,
    this.byWeekDay,
    this.byHour,
    this.byMinute,
  });

  Map<String, dynamic> toMap() {
    return {
      'frequency': frequency.index,
      'interval': interval,
      'byWeekDay': byWeekDay?.join(','),
      'byHour': byHour?.join(','),
      'byMinute': byMinute?.join(','),
    };
  }

  factory ReminderRecurrencePattern.fromMap(Map<String, dynamic> map) {
    return ReminderRecurrencePattern(
      frequency: ReminderRecurrenceFrequency.values[map['frequency']],
      interval: map['interval'] ?? 1,
      byWeekDay: map['byWeekDay'] != null 
          ? map['byWeekDay'].split(',').map<int>((e) => int.parse(e)).toList()
          : null,
      byHour: map['byHour'] != null 
          ? map['byHour'].split(',').map<int>((e) => int.parse(e)).toList()
          : null,
      byMinute: map['byMinute'] != null 
          ? map['byMinute'].split(',').map<int>((e) => int.parse(e)).toList()
          : null,
    );
  }
}

// Enum for reminder recurrence frequencies
enum ReminderRecurrenceFrequency {
  hourly,
  daily,
  weekly,
  monthly,
  yearly,
  custom, // For complex custom patterns
}

// Predefined common reminder recurrence patterns
class CommonReminderPatterns {
  static ReminderRecurrencePattern hourly() => ReminderRecurrencePattern(frequency: ReminderRecurrenceFrequency.hourly);
  
  static ReminderRecurrencePattern daily() => ReminderRecurrencePattern(frequency: ReminderRecurrenceFrequency.daily);
  
  static ReminderRecurrencePattern weekly() => ReminderRecurrencePattern(frequency: ReminderRecurrenceFrequency.weekly);
  
  static ReminderRecurrencePattern weekdays() => ReminderRecurrencePattern(
    frequency: ReminderRecurrenceFrequency.weekly,
    byWeekDay: [1, 2, 3, 4, 5], // Monday to Friday
  );
  
  static ReminderRecurrencePattern weekends() => ReminderRecurrencePattern(
    frequency: ReminderRecurrenceFrequency.weekly,
    byWeekDay: [0, 6], // Sunday and Saturday
  );
  
  static ReminderRecurrencePattern monthly() => ReminderRecurrencePattern(frequency: ReminderRecurrenceFrequency.monthly);
  
  static ReminderRecurrencePattern yearly() => ReminderRecurrencePattern(frequency: ReminderRecurrenceFrequency.yearly);
  
  static ReminderRecurrencePattern everyNHours(int n) => ReminderRecurrencePattern(
    frequency: ReminderRecurrenceFrequency.hourly,
    interval: n,
  );
  
  static ReminderRecurrencePattern everyNDays(int n) => ReminderRecurrencePattern(
    frequency: ReminderRecurrenceFrequency.daily,
    interval: n,
  );
  
  static ReminderRecurrencePattern everyNWeeks(int n, {List<int>? onDays}) => ReminderRecurrencePattern(
    frequency: ReminderRecurrenceFrequency.weekly,
    interval: n,
    byWeekDay: onDays,
  );
  
  static ReminderRecurrencePattern workdayReminder() => ReminderRecurrencePattern(
    frequency: ReminderRecurrenceFrequency.daily,
    byWeekDay: [1, 2, 3, 4, 5], // Monday to Friday
  );
  
  static ReminderRecurrencePattern medicationReminder({required List<int> hours}) => ReminderRecurrencePattern(
    frequency: ReminderRecurrenceFrequency.daily,
    byHour: hours,
  );
}
