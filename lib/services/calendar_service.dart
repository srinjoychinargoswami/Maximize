import 'package:maximize/models/database.dart';
import 'package:maximize/models/event_model.dart';
import 'package:maximize/services/reminder_service.dart'; 
import 'package:maximize/models/reminder_model.dart'; 

class CalendarService {
  final AppDatabase _database;

  CalendarService(this._database);

  // Fetch all events and expand recurring events
  Future<List<Event>> getEvents() async {
    try {
      final eventsData = await _database.getAllEvents();
      List<Event> events = eventsData.map((eventData) => Event.fromEventData(eventData)).toList();

      List<Event> expandedEvents = [];
      final now = DateTime.now();
      final futureLimit = now.add(Duration(days: 365)); // Expand for next year

      for (Event event in events) {
        if (event.isRecurring && event.recurrenceRule != null && event.parentEventId == null) {
          // This is a parent recurring event - generate instances
          List<DateTime> occurrences = _generateRecurrenceOccurrences(
            event.startDateTime,
            event.recurrenceRule!,
            now.subtract(Duration(days: 30)), // Show past month
            futureLimit,
            event.recurrenceExceptionDates,
          );

          for (DateTime occurrence in occurrences) {
            if (event.recurrenceCount != null && 
                occurrences.indexOf(occurrence) >= event.recurrenceCount!) {
              break;
            }
            
            if (event.recurrenceEndDate != null && 
                occurrence.isAfter(event.recurrenceEndDate!)) {
              break;
            }

            // Calculate duration
            Duration eventDuration = event.endDateTime.difference(event.startDateTime);
            
            // Create instance for this occurrence
            Event instance = event.copyWith(
              id: '${event.id}_${occurrence.millisecondsSinceEpoch}',
              startDateTime: occurrence,
              endDateTime: occurrence.add(eventDuration),
              date: occurrence,
              parentEventId: event.id,
            );
            expandedEvents.add(instance);
          }
          
          // DON'T add the parent event to expandedEvents - only add instances
        } else if (!event.isRecurring || event.parentEventId != null) {
          // Non-recurring event OR it's already an instance - add it
          expandedEvents.add(event);
        }
        // Skip parent recurring events (don't add them to the display list)
      }

      print('Total events loaded: ${expandedEvents.length}');
      
      // Count recurring vs non-recurring for debugging
      int instanceCount = expandedEvents.where((e) => e.parentEventId != null).length;
      int singleCount = expandedEvents.where((e) => !e.isRecurring && e.parentEventId == null).length;
      print('Instances: $instanceCount, Single: $singleCount');

      return expandedEvents;
    } catch (e) {
      print('Error fetching events: $e');
      throw Exception('Error fetching events');
    }
  }

  // ADDED: Fetch events with filtering options for better organization
  Future<List<Event>> getEventsFiltered({
    bool? completed,
    String? category,
    DateTime? date,
    bool? isToday,
  }) async {
    try {
      final allEvents = await getEvents();
      return allEvents.where((event) {
        if (completed != null && event.completed != completed) return false;
        if (category != null && event.customCategory != category) return false;
        if (date != null && !_isSameDay(event.startDateTime, date)) return false;
        if (isToday == true && !event.isToday) return false;
        return true;
      }).toList();
    } catch (e) {
      print('Error fetching filtered events: $e');
      return [];
    }
  }

  // ADDED: Get today's events for dashboard overview
  Future<List<Event>> getTodaysEvents() async {
    try {
      final today = DateTime.now();
      return await getEventsFiltered(date: today);
    } catch (e) {
      print('Error fetching today\'s events: $e');
      return [];
    }
  }

  // ADDED: Get completed events for productivity tracking
  Future<List<Event>> getCompletedEvents({DateTime? date}) async {
    try {
      final events = await getEvents();
      return events.where((event) {
        if (!event.completed) return false;
        if (date != null && event.completedAt != null) {
          return _isSameDay(event.completedAt!, date);
        }
        return event.completed;
      }).toList();
    } catch (e) {
      print('Error fetching completed events: $e');
      return [];
    }
  }

  // ADDED: Get overdue events (past events that aren't completed)
  Future<List<Event>> getOverdueEvents() async {
    try {
      final events = await getEvents();
      final now = DateTime.now();
      return events.where((event) {
        return !event.completed && event.endDateTime.isBefore(now);
      }).toList();
    } catch (e) {
      print('Error fetching overdue events: $e');
      return [];
    }
  }

  // Fetch only base events (without expansion) for editing purposes
  Future<List<Event>> getBaseEvents() async {
    try {
      final eventsData = await _database.getAllEvents();
      return eventsData.map((eventData) => Event.fromEventData(eventData)).toList();
    } catch (e) {
      print('Error fetching base events: $e');
      throw Exception('Error fetching base events');
    }
  }

  // Add a new event to the database with recurrence support + notifications
  Future<int> addEvent(Event event) async {
    if (event.id.isEmpty) {
      throw Exception('Event ID is required');
    }

    try {
      // Generate RRULE if recurring
      if (event.isRecurring && event.recurrencePattern != null) {
        event.recurrenceRule = event.generateRRule();
      }
      
      final result = await _database.insertEvent(event);
      
      // Schedule notification if reminder is enabled
      await _scheduleEventNotification(event);
      
      return result;
    } catch (e) {
      print('Error inserting event: $e');
      throw Exception('Error inserting event');
    }
  }

  // Update an existing event with notifications
  Future<void> updateEvent(Event event, {bool updateSeries = false}) async {
    if (event.id.isEmpty) {
      throw Exception('Event ID is required');
    }

    try {
      // Cancel old notification before updating
      await _cancelEventNotification(event.id);
      
      if (updateSeries && event.parentEventId != null) {
        // Update entire series - find parent event
        final eventsData = await _database.getAllEvents();
        final events = eventsData.map((e) => Event.fromEventData(e)).toList();
        final parentEvent = events.firstWhere(
          (e) => e.id == event.parentEventId,
          orElse: () => throw Exception('Parent event not found'),
        );
        
        // Update parent with new details but keep original start time
        final updatedParent = parentEvent.copyWith(
          title: event.title,
          description: event.description,
          customCategory: event.customCategory,
          color: event.color,
          completed: event.completed,
          completedAt: event.completedAt,
          isRecurring: event.isRecurring,
          recurrencePattern: event.recurrencePattern,
          recurrenceCount: event.recurrenceCount,
          recurrenceEndDate: event.recurrenceEndDate,
          reminderEnabled: event.reminderEnabled, 
          reminderTime: event.reminderTime, 
          reminderPreset: event.reminderPreset, 
        );
        
        if (updatedParent.isRecurring && updatedParent.recurrencePattern != null) {
          updatedParent.recurrenceRule = updatedParent.generateRRule();
        }
        
        await _database.updateEvent(updatedParent);
        
        // Schedule notification for updated parent
        await _scheduleEventNotification(updatedParent);
      } else {
        // Update single event or non-recurring event
        if (event.isRecurring && event.recurrencePattern != null) {
          event.recurrenceRule = event.generateRRule();
        }
        await _database.updateEvent(event);
        
        // Schedule notification for updated event
        await _scheduleEventNotification(event);
      }
    } catch (e) {
      print('Error updating event: $e');
      throw Exception('Error updating event');
    }
  }

  // ADDED: Toggle event completion status (for checkbox functionality)
  Future<void> toggleEventCompletion(String eventId) async {
    try {
      final event = await getEventById(eventId);
      if (event != null) {
        final updatedEvent = event.toggleCompletion();
        await updateEvent(updatedEvent);
      }
    } catch (e) {
      print('Error toggling event completion: $e');
    }
  }

  // Mark event as completed + cancel notification
  Future<void> markEventCompleted(String eventId) async {
    try {
      final event = await getEventById(eventId);
      if (event != null && !event.completed) {
        final updatedEvent = event.copyWith(
          completed: true,
          completedAt: DateTime.now(),
        );
        await _database.updateEvent(updatedEvent);
        
        //  Cancel notification when completed
        await _cancelEventNotification(eventId);
      }
    } catch (e) {
      print('Error marking event as completed: $e');
    }
  }

  // Mark event as incomplete + reschedule notification
  Future<void> markEventIncomplete(String eventId) async {
    try {
      final event = await getEventById(eventId);
      if (event != null && event.completed) {
        final updatedEvent = event.copyWith(
          completed: false,
          completedAt: null,
        );
        await _database.updateEvent(updatedEvent);
        
        // Reschedule notification if still in future
        await _scheduleEventNotification(updatedEvent);
      }
    } catch (e) {
      print('Error marking event as incomplete: $e');
    }
  }

  // ADDED: Get event by ID (helper method for completion functions)
  Future<Event?> getEventById(String eventId) async {
    try {
      final eventsData = await _database.getAllEvents();
      final eventData = eventsData.firstWhere(
        (event) => event.id == eventId,
        orElse: () => throw Exception('Event not found'),
      );
      return Event.fromEventData(eventData);
    } catch (e) {
      print('Error fetching event by ID: $e');
      return null;
    }
  }

  // Delete an event with notification cleanup
  Future<void> deleteEvent(String id, {bool deleteSeries = false}) async {
    try {
      print('Deleting event - ID: $id, deleteSeries: $deleteSeries');
      
      // Cancel notification before deleting
      await _cancelEventNotification(id);
      
      if (deleteSeries) {
        // Delete entire series - find all related events
        final eventsData = await _database.getAllEvents();
        final events = eventsData.map((e) => Event.fromEventData(e)).toList();
        
        // Find the parent event
        Event? parentEvent = events.firstWhere(
          (e) => e.id == id || e.parentEventId == id,
          orElse: () => throw Exception('Event not found'),
        );
        
        String parentId = parentEvent.parentEventId ?? parentEvent.id;
        print('Deleting parent event with ID: $parentId');
        
        // Delete parent event
        await _database.deleteEvent(parentId);
        
        // Also delete any instances that might exist as separate records
        for (Event event in events) {
          if (event.parentEventId == parentId && event.id != parentId) {
            print('Deleting instance: ${event.id}');
            await _cancelEventNotification(event.id); 
            await _database.deleteEvent(event.id);
          }
        }
        
        print('Successfully deleted entire series');
      } else {
        // Delete single event
        print('Deleting single event with ID: $id');
        await _database.deleteEvent(id);
        print('Successfully deleted single event');
      }
    } catch (e) {
      print('Error deleting event: $e');
      throw Exception('Error deleting event: $e');
    }
  }

  // Add exception to recurring event (for single occurrence deletion)
  Future<void> addRecurrenceException(String parentEventId, DateTime exceptionDate) async {
    try {
      print('Adding exception for parent: $parentEventId, date: $exceptionDate');
      
      final eventsData = await _database.getAllEvents();
      final events = eventsData.map((e) => Event.fromEventData(e)).toList();
      
      final parentEvent = events.firstWhere(
        (e) => e.id == parentEventId,
        orElse: () => throw Exception('Parent event not found'),
      );
      
      List<DateTime> exceptions = List.from(parentEvent.recurrenceExceptionDates ?? []);
      if (!exceptions.any((ex) => _isSameDay(ex, exceptionDate))) {
        exceptions.add(exceptionDate);
        
        final updatedEvent = parentEvent.copyWith(
          recurrenceExceptionDates: exceptions,
        );
        
        await _database.updateEvent(updatedEvent);
        print('Successfully added exception date');
      } else {
        print('Exception date already exists');
      }
    } catch (e) {
      print('Error adding recurrence exception: $e');
      throw Exception('Error adding recurrence exception: $e');
    }
  }

  // Create a modified single occurrence (for editing single occurrence)
  Future<void> createModifiedOccurrence(Event originalEvent, Event modifiedEvent) async {
    try {
      // Add exception to parent event
      if (originalEvent.parentEventId != null) {
        await addRecurrenceException(originalEvent.parentEventId!, originalEvent.startDateTime);
      }
      
      // Create new single event
      final newSingleEvent = modifiedEvent.copyWith(
        isRecurring: false,
        recurrencePattern: null,
        recurrenceRule: null,
        parentEventId: null,
        recurrenceExceptionDates: null,
        recurrenceCount: null,
        recurrenceEndDate: null,
      );
      
      await addEvent(newSingleEvent);
    } catch (e) {
      print('Error creating modified occurrence: $e');
      throw Exception('Error creating modified occurrence');
    }
  }

  // Schedule notification for event reminder
  Future<void> _scheduleEventNotification(Event event) async {
    try {
      // Only schedule if reminder is enabled and time is set
      if (event.reminderEnabled == true && 
          event.reminderTime != null && 
          !event.completed &&
          event.reminderTime!.isAfter(DateTime.now())) {
        
        // Create a reminder model for the notification system
        final reminder = ReminderModel(
          id: 'event_${event.id}',
          title: event.title,
          body: event.description ?? 'Event reminder',
          scheduledTime: event.reminderTime!,
          notificationId: event.id.hashCode.toString(),
          completed: false,
        );
        
        await NotificationService.instance.scheduleNotification(reminder);
        print('[CalendarService] Scheduled notification for event: ${event.title} at ${event.reminderTime}');
      }
    } catch (e) {
      print('[CalendarService] Error scheduling event notification: $e');
    }
  }

  // Cancel notification for event
  Future<void> _cancelEventNotification(String eventId) async {
    try {
      await NotificationService.instance.cancelNotification('event_$eventId');
      print('[CalendarService] Cancelled notification for event: $eventId');
    } catch (e) {
      print('[CalendarService] Error cancelling event notification: $e');
    }
  }

  // Helper method to generate recurrence occurrences
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
      if (occurrenceCount > 1000) break;
    }
    
    return occurrences;
  }

  // Parse RRULE string into components
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

  // Calculate next occurrence based on frequency and interval
  DateTime _getNextOccurrence(DateTime current, String frequency, int interval) {
    switch (frequency.toUpperCase()) {
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

  // Check if two dates are the same day
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // Get events for a specific date range
  Future<List<Event>> getEventsInRange(DateTime start, DateTime end) async {
    try {
      final allEvents = await getEvents();
      return allEvents.where((event) {
        return (event.startDateTime.isAfter(start) || _isSameDay(event.startDateTime, start)) &&
               (event.startDateTime.isBefore(end) || _isSameDay(event.startDateTime, end));
      }).toList();
    } catch (e) {
      print('Error fetching events in range: $e');
      throw Exception('Error fetching events in range');
    }
  }

  // Get events for a specific day
  Future<List<Event>> getEventsForDay(DateTime day) async {
    try {
      final allEvents = await getEvents();
      return allEvents.where((event) => _isSameDay(event.startDateTime, day)).toList();
    } catch (e) {
      print('Error fetching events for day: $e');
      throw Exception('Error fetching events for day');
    }
  }

  // Validate recurrence rule
  bool isValidRRule(String rrule) {
    try {
      final rules = _parseRRule(rrule);
      return rules.containsKey('FREQ');
    } catch (e) {
      return false;
    }
  }

  // Get upcoming events (next N occurrences)
  Future<List<Event>> getUpcomingEvents({int limit = 10}) async {
    try {
      final allEvents = await getEvents();
      final now = DateTime.now();
      
      final upcomingEvents = allEvents
          .where((event) => event.startDateTime.isAfter(now))
          .toList()
        ..sort((a, b) => a.startDateTime.compareTo(b.startDateTime));
      
      return upcomingEvents.take(limit).toList();
    } catch (e) {
      print('Error fetching upcoming events: $e');
      throw Exception('Error fetching upcoming events');
    }
  }

  // ADDED: Get event completion statistics
  Future<Map<String, int>> getEventStats() async {
    try {
      final events = await getEvents();
      final completed = events.where((event) => event.completed).length;
      final pending = events.where((event) => !event.completed).length;
      final overdue = events.where((event) => 
        !event.completed && event.endDateTime.isBefore(DateTime.now())).length;
      
      return {
        'total': events.length,
        'completed': completed,
        'pending': pending,
        'overdue': overdue,
      };
    } catch (e) {
      print('Error getting event stats: $e');
      return {'total': 0, 'completed': 0, 'pending': 0, 'overdue': 0};
    }
  }

  // Debug method to check database state
  Future<void> debugDatabaseState() async {
    try {
      final allEvents = await _database.getAllEvents();
      print('=== Database Events Debug ===');
      for (var event in allEvents) {
        print('ID: ${event.id}');
        print('  Title: ${event.title}');
        print('  Parent: ${event.parentEventId}');
        print('  Recurring: ${event.isRecurring}');
        print('  Start: ${event.startDateTime}');
        print('  Completed: ${event.completed}');
        print('  Reminder: ${event.reminderEnabled}'); 
        print('---');
      }
      print('Total database events: ${allEvents.length}');
    } catch (e) {
      print('Error debugging database state: $e');
    }
  }
}
