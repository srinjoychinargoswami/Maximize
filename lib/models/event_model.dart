import 'package:maximize/models/database.dart'; // Import your database file
import 'package:intl/intl.dart'; // Import intl package
import 'package:uuid/uuid.dart';

class Event {
  String id; // Make ID non-nullable
  String title;
  String? description; // Make description nullable
  String? comments; // Make comments nullable
  DateTime startDateTime; // Change to DateTime
  DateTime endDateTime; // Change to DateTime
  DateTime date;
  String? customCategory; // Make customCategory nullable to match usage
  String color; // New field for event color
  bool completed; // CHANGED: Made mutable for checkbox functionality
  final DateTime? completedAt; // ALREADY GOOD: Track completion timestamp
  late DateTime createdAt; // ADDED: When the event was created
  late DateTime updatedAt; // ADDED: When the event was last updated

  // Recurring event fields
  bool isRecurring;
  RecurrencePattern? recurrencePattern;
  String? recurrenceRule; // RRULE format for complex patterns
  String? parentEventId; // For linking recurring instances
  List<DateTime>? recurrenceExceptionDates; // Dates to skip
  DateTime? recurrenceEndDate; // When recurrence stops
  int? recurrenceCount; // Number of occurrences

  // Reminder fields
  bool? reminderEnabled; // Whether reminder notification is enabled
  DateTime? reminderTime; // When to show the reminder notification
  String? reminderPreset; // Preset type: 'at_time', '15min', '30min', '1hour', '1day', 'custom'

  Event({
    String? id, // Allow null for auto-generation
    required this.title,
    this.description, // Make description nullable
    this.comments, // Make comments nullable
    required this.startDateTime, // Change to DateTime
    required this.endDateTime, // Change to DateTime
    required this.date,
    this.customCategory, // Remove required since it's nullable
    required this.color, // New required field for color
    this.completed = false, // CHANGED: Made mutable and default to false
    this.completedAt, // ALREADY GOOD: Track completion timestamp
    DateTime? createdAt, // ADDED: Allow setting createdAt
    DateTime? updatedAt, // ADDED: Allow setting updatedAt
    this.isRecurring = false,
    this.recurrencePattern,
    this.recurrenceRule,
    this.parentEventId,
    this.recurrenceExceptionDates,
    this.recurrenceEndDate,
    this.recurrenceCount,
    this.reminderEnabled,
    this.reminderTime,
    this.reminderPreset,
  }) : id = id ?? const Uuid().v4() {
    // Initialize timestamps
    this.createdAt = createdAt ?? DateTime.now();
    this.updatedAt = updatedAt ?? DateTime.now();
  }

  // Conversion method from EventData to Event
  factory Event.fromEventData(EventData eventData) {
    return Event(
      id: eventData.id,
      title: eventData.title,
      description: eventData.description,
      comments: eventData.comments,
      startDateTime: eventData.startDateTime, // Use DateTime directly
      endDateTime: eventData.endDateTime, // Use DateTime directly
      date: eventData.startDateTime, // Use eventDateTime as the date
      customCategory: eventData.customCategory, // Keep nullable
      color: eventData.color ?? '#FFFFFF', // Map color from EventData (default to white)
      completed: eventData.completed ?? false, // ADDED: Map completion status from database
      completedAt: eventData.completedAt, // ADDED: Map completion timestamp from database
      createdAt: eventData.createdAt, // ADDED: Map creation timestamp
      updatedAt: eventData.updatedAt, // ADDED: Map update timestamp
      isRecurring: eventData.isRecurring ?? false,
      recurrenceRule: eventData.recurrenceRule,
      parentEventId: eventData.parentEventId,
      recurrenceExceptionDates: eventData.recurrenceExceptionDates?.split(',')
    .where((d) => d.isNotEmpty)
    .map<DateTime>((d) => DateTime.parse(d))
    .toList(),
      recurrenceEndDate: eventData.recurrenceEndDate,
      recurrenceCount: eventData.recurrenceCount,
      reminderEnabled: eventData.reminderEnabled,
      reminderTime: eventData.reminderTime,
      reminderPreset: eventData.reminderPreset,
    );
  }

  // Convert Event to Map (optional, if needed for other purposes)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'comments': comments,
      'startTime': DateFormat('HH:mm').format(startDateTime), // Format using intl
      'endTime': DateFormat('HH:mm').format(endDateTime), // Format using intl
      'date': date.toIso8601String(),
      'category': customCategory, // Include custom category
      'color': color, // Include color
      'completed': completed, // ADDED: Include completion status in map
      'completedAt': completedAt?.toIso8601String(), // ADDED: Include completion timestamp
      'isRecurring': isRecurring,
      'recurrenceRule': recurrenceRule,
      'parentEventId': parentEventId,
      'recurrenceExceptionDates': recurrenceExceptionDates?.map((d) => d.toIso8601String()).join(','),
      'recurrenceEndDate': recurrenceEndDate?.toIso8601String(),
      'recurrenceCount': recurrenceCount,
      'reminderEnabled': reminderEnabled, 
      'reminderTime': reminderTime?.toIso8601String(), 
      'reminderPreset': reminderPreset, 
    };
  }

  // Convert Map to Event (optional, if needed for other purposes)
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      comments: map['comments'],
      startDateTime: DateTime.parse(map['startTime']), // Parse DateTime directly
      endDateTime: DateTime.parse(map['endTime']), // Parse DateTime directly
      date: DateTime.parse(map['date']),
      customCategory: map['category'], // Parse category from map (nullable)
      color: map['color'] ?? '#FFFFFF', // Parse color from map (default to white)
      completed: map['completed'] ?? false, // ADDED: Parse completion status from map
      completedAt: map['completedAt'] != null // ADDED: Parse completion timestamp from map
          ? DateTime.parse(map['completedAt'])
          : null,
      isRecurring: map['isRecurring'] ?? false,
      recurrenceRule: map['recurrenceRule'],
      parentEventId: map['parentEventId'],
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
      reminderEnabled: map['reminderEnabled'], 
      reminderTime: map['reminderTime'] != null 
          ? DateTime.parse(map['reminderTime'])
          : null,
      reminderPreset: map['reminderPreset'], 
    );
  }

  // Copy with method for easy updates
  Event copyWith({
    String? id,
    String? title,
    String? description,
    String? comments,
    DateTime? startDateTime,
    DateTime? endDateTime,
    DateTime? date,
    String? customCategory,
    String? color,
    bool? completed, // ADDED: Allow updating completion status
    DateTime? completedAt, // ADDED: Allow updating completion timestamp
    DateTime? createdAt, // ADDED: Allow updating creation timestamp
    DateTime? updatedAt, // ADDED: Allow updating update timestamp
    bool? isRecurring,
    RecurrencePattern? recurrencePattern,
    String? recurrenceRule,
    String? parentEventId,
    List<DateTime>? recurrenceExceptionDates,
    DateTime? recurrenceEndDate,
    int? recurrenceCount,
    bool? reminderEnabled,
    DateTime? reminderTime,
    String? reminderPreset,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      comments: comments ?? this.comments,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      date: date ?? this.date,
      customCategory: customCategory ?? this.customCategory,
      color: color ?? this.color,
      completed: completed ?? this.completed, // ADDED: Update completion status
      completedAt: completedAt ?? this.completedAt, // ADDED: Update completion timestamp
      createdAt: createdAt ?? this.createdAt, // ADDED: Update creation timestamp
      updatedAt: updatedAt ?? this.updatedAt, // ADDED: Update update timestamp
      isRecurring: isRecurring ?? this.isRecurring,
      recurrencePattern: recurrencePattern ?? this.recurrencePattern,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      parentEventId: parentEventId ?? this.parentEventId,
      recurrenceExceptionDates: recurrenceExceptionDates ?? this.recurrenceExceptionDates,
      recurrenceEndDate: recurrenceEndDate ?? this.recurrenceEndDate,
      recurrenceCount: recurrenceCount ?? this.recurrenceCount,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      reminderPreset: reminderPreset ?? this.reminderPreset,
    );
  }

  // ADDED: Method to toggle completion status (for checkbox functionality)
  Event toggleCompletion() {
    return copyWith(
      completed: !completed,
      completedAt: !completed ? DateTime.now() : null, // Set timestamp when completing
    );
  }

  // ADDED: Helper methods for checkbox functionality
  bool get isCompleted => completed;
  bool get isPastDue => DateTime.now().isAfter(endDateTime) && !completed;
  bool get isToday => DateTime.now().day == date.day && 
                     DateTime.now().month == date.month && 
                     DateTime.now().year == date.year;
  bool get isUpcoming => DateTime.now().isBefore(startDateTime);
  
  //  Helper method to check if reminder is set
  bool get hasReminder => reminderEnabled == true && reminderTime != null;

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
    
    if (recurrencePattern!.byMonthDay != null && recurrencePattern!.byMonthDay!.isNotEmpty) {
      rrule += ';BYMONTHDAY=${recurrencePattern!.byMonthDay!.join(',')}';
    }
    
    return rrule;
  }

  // Helper method to convert weekday to RRULE format
  String _weekDayToString(int weekDay) {
    const days = ['SU', 'MO', 'TU', 'WE', 'TH', 'FR', 'SA'];
    return days[weekDay % 7];
  }

  // Check if this is a recurring event instance
  bool get isRecurringInstance => parentEventId != null;

  // Get human-readable recurrence description
  String get recurrenceDescription {
    if (!isRecurring || recurrencePattern == null) return 'Does not repeat';
    
    final pattern = recurrencePattern!;
    String description = '';
    
    switch (pattern.frequency) {
      case RecurrenceFrequency.daily:
        description = pattern.interval == 1 ? 'Daily' : 'Every ${pattern.interval} days';
        break;
      case RecurrenceFrequency.weekly:
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
      case RecurrenceFrequency.monthly:
        description = pattern.interval == 1 ? 'Monthly' : 'Every ${pattern.interval} months';
        break;
      case RecurrenceFrequency.yearly:
        description = pattern.interval == 1 ? 'Yearly' : 'Every ${pattern.interval} years';
        break;
      case RecurrenceFrequency.custom:
        description = 'Custom pattern';
        break;
    }
    
    if (recurrenceEndDate != null) {
      description += ' until ${DateFormat('MMM d, y').format(recurrenceEndDate!)}';
    } else if (recurrenceCount != null) {
      description += ' for $recurrenceCount occurrences';
    }
    
    return description;
  }

  String _getDayName(int weekDay) {
    const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    return days[weekDay % 7];
  }
}

// Recurrence pattern class for structured recurrence rules - NO CHANGES NEEDED
class RecurrencePattern {
  final RecurrenceFrequency frequency;
  final int interval; // Every N days/weeks/months/years
  final List<int>? byWeekDay; // Days of week (0=Sunday, 1=Monday, etc.)
  final List<int>? byMonthDay; // Days of month (1-31)
  final List<int>? byMonth; // Months (1-12)
  final int? bySetPos; // Which occurrence (1st, 2nd, last, etc.)

  RecurrencePattern({
    required this.frequency,
    this.interval = 1,
    this.byWeekDay,
    this.byMonthDay,
    this.byMonth,
    this.bySetPos,
  });

  Map<String, dynamic> toMap() {
    return {
      'frequency': frequency.index,
      'interval': interval,
      'byWeekDay': byWeekDay?.join(','),
      'byMonthDay': byMonthDay?.join(','),
      'byMonth': byMonth?.join(','),
      'bySetPos': bySetPos,
    };
  }

  factory RecurrencePattern.fromMap(Map<String, dynamic> map) {
    return RecurrencePattern(
      frequency: RecurrenceFrequency.values[map['frequency']],
      interval: map['interval'] ?? 1,
      byWeekDay: map['byWeekDay']?.split(',').map<int>((e) => int.parse(e)).toList(),
      byMonthDay: map['byMonthDay']?.split(',').map<int>((e) => int.parse(e)).toList(),
      byMonth: map['byMonth']?.split(',').map<int>((e) => int.parse(e)).toList(),
      bySetPos: map['bySetPos'],
    );
  }
}

// Enum for recurrence frequencies - NO CHANGES NEEDED
enum RecurrenceFrequency {
  daily,
  weekly,
  monthly,
  yearly,
  custom, // For complex custom patterns
}

// Predefined common recurrence patterns - NO CHANGES NEEDED
class CommonRecurrencePatterns {
  static RecurrencePattern daily() => RecurrencePattern(frequency: RecurrenceFrequency.daily);
  
  static RecurrencePattern weekly() => RecurrencePattern(frequency: RecurrenceFrequency.weekly);
  
  static RecurrencePattern weekdays() => RecurrencePattern(
    frequency: RecurrenceFrequency.weekly,
    byWeekDay: [1, 2, 3, 4, 5], // Monday to Friday
  );
  
  static RecurrencePattern weekends() => RecurrencePattern(
    frequency: RecurrenceFrequency.weekly,
    byWeekDay: [0, 6], // Sunday and Saturday
  );
  
  static RecurrencePattern monthly() => RecurrencePattern(frequency: RecurrenceFrequency.monthly);
  
  static RecurrencePattern yearly() => RecurrencePattern(frequency: RecurrenceFrequency.yearly);
  
  static RecurrencePattern everyNDays(int n) => RecurrencePattern(
    frequency: RecurrenceFrequency.daily,
    interval: n,
  );
  
  static RecurrencePattern everyNWeeks(int n, {List<int>? onDays}) => RecurrencePattern(
    frequency: RecurrenceFrequency.weekly,
    interval: n,
    byWeekDay: onDays,
  );
  
  static RecurrencePattern everyNMonths(int n) => RecurrencePattern(
    frequency: RecurrenceFrequency.monthly,
    interval: n,
  );
}
