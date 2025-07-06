import 'package:maximize/models/database.dart';
import 'package:maximize/models/event_model.dart';

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
        if (event.isRecurring && event.recurrenceRule != null) {
          // Generate recurring instances
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
        } else {
          // Non-recurring event
          expandedEvents.add(event);
        }
      }

      return expandedEvents;
    } catch (e) {
      print('Error fetching events: $e');
      throw Exception('Error fetching events');
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

  // Add a new event to the database with recurrence support
  Future<int> addEvent(Event event) async {
    if (event.id.isEmpty) {
      throw Exception('Event ID is required');
    }

    try {
      // Generate RRULE if recurring
      if (event.isRecurring && event.recurrencePattern != null) {
        event.recurrenceRule = event.generateRRule();
      }
      
      return await _database.insertEvent(event); // Returns the inserted event ID
    } catch (e) {
      print('Error inserting event: $e');
      throw Exception('Error inserting event');
    }
  }

  // Update an existing event in the database with series/single occurrence handling
  Future<void> updateEvent(Event event, {bool updateSeries = false}) async {
    if (event.id.isEmpty) {
      throw Exception('Event ID is required');
    }

    try {
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
          isRecurring: event.isRecurring,
          recurrencePattern: event.recurrencePattern,
          recurrenceCount: event.recurrenceCount,
          recurrenceEndDate: event.recurrenceEndDate,
        );
        
        if (updatedParent.isRecurring && updatedParent.recurrencePattern != null) {
          updatedParent.recurrenceRule = updatedParent.generateRRule();
        }
        
        await _database.updateEvent(updatedParent);
      } else {
        // Update single event or non-recurring event
        if (event.isRecurring && event.recurrencePattern != null) {
          event.recurrenceRule = event.generateRRule();
        }
        await _database.updateEvent(event);
      }
    } catch (e) {
      print('Error updating event: $e');
      throw Exception('Error updating event');
    }
  }

  // Delete an event with series/single occurrence handling
  Future<void> deleteEvent(String id, {bool deleteSeries = false}) async {
    try {
      if (deleteSeries) {
        // Delete entire series
        final eventsData = await _database.getAllEvents();
        final events = eventsData.map((e) => Event.fromEventData(e)).toList();
        
        // Find the parent event
        Event? eventToDelete = events.firstWhere(
          (e) => e.id == id,
          orElse: () => throw Exception('Event not found'),
        );
        
        String parentId = eventToDelete.parentEventId ?? eventToDelete.id;
        await _database.deleteEvent(parentId);
      } else {
        // Delete single event
        await _database.deleteEvent(id);
      }
    } catch (e) {
      print('Error deleting event: $e');
      throw Exception('Error deleting event');
    }
  }

  // Add exception to recurring event (for single occurrence deletion)
  Future<void> addRecurrenceException(String parentEventId, DateTime exceptionDate) async {
    try {
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
      }
    } catch (e) {
      print('Error adding recurrence exception: $e');
      throw Exception('Error adding recurrence exception');
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
}
