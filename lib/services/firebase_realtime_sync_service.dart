import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maximize/models/task_model.dart';
import 'package:maximize/models/event_model.dart';
import 'package:maximize/models/reminder_model.dart';
import 'package:maximize/models/note_model.dart';
import 'package:maximize/models/energy_entry.dart';
import 'package:maximize/config/app_config.dart';

class FirebaseRealtimeSyncService {
  static final FirebaseRealtimeSyncService _instance =
      FirebaseRealtimeSyncService._internal();

  factory FirebaseRealtimeSyncService() {
    return _instance;
  }

  FirebaseRealtimeSyncService._internal();

  late FirebaseDatabase _database;
  late FirebaseAuth _auth;
  late DatabaseReference _tasksRef;
  late DatabaseReference _eventsRef;
  late DatabaseReference _remindersRef;
  late DatabaseReference _notesRef;
  late DatabaseReference _energyEntriesRef;

  String? _currentUserId;

  bool get isInitialized => _currentUserId != null;

  /// Initialize Firebase Realtime Database
  /// Call this once in main.dart after Firebase.initializeApp()
  Future<void> initialize() async {
    try {
      _auth = FirebaseAuth.instance;
      _database = FirebaseDatabase.instance;

      // Sign in anonymously if not already signed in
      if (_auth.currentUser == null) {
        final cred = await _auth.signInAnonymously();
        _currentUserId = cred.user?.uid;
      } else {
        _currentUserId = _auth.currentUser?.uid;
      }

      if (_currentUserId == null) {
        throw Exception('Failed to authenticate with Firebase');
      }

      // Initialize database references
      // [BUYER CUSTOMIZATION]: Change database structure if needed
      _tasksRef =
          _database.ref('users/$_currentUserId/tasks');
      _eventsRef =
          _database.ref('users/$_currentUserId/events');
      _remindersRef =
          _database.ref('users/$_currentUserId/reminders');
      _notesRef =
          _database.ref('users/$_currentUserId/notes');
      _energyEntriesRef =
          _database.ref('users/$_currentUserId/energy_entries');

      if (AppConfig.debugLogging) {
        print('[Firebase] Initialized with user: $_currentUserId');
      }
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[Firebase] Initialization error: $e');
      }
    }
  }

  /// Sync a single task to Firebase
  Future<void> syncTask(TaskModel task) async {
    try {
      await _tasksRef.child(task.id).set(task.toJson());
      if (AppConfig.debugLogging) {
        print('[Firebase] Task synced: ${task.id}');
      }
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[Firebase] Error syncing task: $e');
      }
    }
  }

  /// Sync a single event to Firebase
  Future<void> syncEvent(Event event) async {
    try {
      await _eventsRef.child(event.id).set(event.toMap());
      if (AppConfig.debugLogging) {
        print('[Firebase] Event synced: ${event.id}');
      }
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[Firebase] Error syncing event: $e');
      }
    }
  }

  /// Sync a single reminder to Firebase
  Future<void> syncReminder(ReminderModel reminder) async {
    try {
      await _remindersRef.child(reminder.id).set(reminder.toMap());
      if (AppConfig.debugLogging) {
        print('[Firebase] Reminder synced: ${reminder.id}');
      }
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[Firebase] Error syncing reminder: $e');
      }
    }
  }

  /// Sync a single note to Firebase
  Future<void> syncNote(NoteModel note) async {
    try {
      await _notesRef.child(note.id).set({
        'id': note.id,
        'title': note.title,
        'content': note.content,
        'category': note.category,
        'color': note.color,
        'createdAt': note.createdAt.toIso8601String(),
        'updatedAt': note.updatedAt.toIso8601String(),
        'isPinned': note.isPinned,
      });
      if (AppConfig.debugLogging) {
        print('[Firebase] Note synced: ${note.id}');
      }
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[Firebase] Error syncing note: $e');
      }
    }
  }

  /// Listen to real-time task changes
  void listenToTasks(Function(List<TaskModel>) callback) {
    _tasksRef.onValue.listen((event) {
      try {
        final tasks = <TaskModel>[];
        if (event.snapshot.value is Map) {
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);
          data.forEach((key, value) {
            if (value is Map<String, dynamic>) {
              tasks.add(TaskModel.fromJson(value));
            }
          });
        }
        callback(tasks);
        if (AppConfig.debugLogging) {
          print('[Firebase] Tasks updated: ${tasks.length} items');
        }
      } catch (e) {
        if (AppConfig.debugLogging) {
          print('[Firebase] Error parsing tasks: $e');
        }
      }
    });
  }

  /// Listen to real-time event changes
  void listenToEvents(Function(List<Event>) callback) {
    _eventsRef.onValue.listen((event) {
      try {
        final events = <Event>[];
        if (event.snapshot.value is Map) {
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);
          data.forEach((key, value) {
            if (value is Map<String, dynamic>) {
              events.add(Event.fromMap(value));
            }
          });
        }
        callback(events);
        if (AppConfig.debugLogging) {
          print('[Firebase] Events updated: ${events.length} items');
        }
      } catch (e) {
        if (AppConfig.debugLogging) {
          print('[Firebase] Error parsing events: $e');
        }
      }
    });
  }

  /// Listen to real-time reminder changes
  void listenToReminders(Function(List<ReminderModel>) callback) {
    _remindersRef.onValue.listen((event) {
      try {
        final reminders = <ReminderModel>[];
        if (event.snapshot.value is Map) {
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);
          data.forEach((key, value) {
            if (value is Map<String, dynamic>) {
              reminders.add(ReminderModel.fromMap(value));
            }
          });
        }
        callback(reminders);
        if (AppConfig.debugLogging) {
          print('[Firebase] Reminders updated: ${reminders.length} items');
        }
      } catch (e) {
        if (AppConfig.debugLogging) {
          print('[Firebase] Error parsing reminders: $e');
        }
      }
    });
  }

  /// Listen to real-time note changes
  void listenToNotes(Function(List<NoteModel>) callback) {
    _notesRef.onValue.listen((event) {
      try {
        final notes = <NoteModel>[];
        if (event.snapshot.value is Map) {
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);
          data.forEach((key, value) {
            if (value is Map<String, dynamic>) {
              notes.add(_noteFromMap(value));
            }
          });
        }
        callback(notes);
        if (AppConfig.debugLogging) {
          print('[Firebase] Notes updated: ${notes.length} items');
        }
      } catch (e) {
        if (AppConfig.debugLogging) {
          print('[Firebase] Error parsing notes: $e');
        }
      }
    });
  }

  /// Delete a task from Firebase
  Future<void> deleteTask(String taskId) async {
    try {
      await _tasksRef.child(taskId).remove();
      if (AppConfig.debugLogging) {
        print('[Firebase] Task deleted: $taskId');
      }
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[Firebase] Error deleting task: $e');
      }
    }
  }

  /// Delete an event from Firebase
  Future<void> deleteEvent(String eventId) async {
    try {
      await _eventsRef.child(eventId).remove();
      if (AppConfig.debugLogging) {
        print('[Firebase] Event deleted: $eventId');
      }
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[Firebase] Error deleting event: $e');
      }
    }
  }

  /// Delete a reminder from Firebase
  Future<void> deleteReminder(String reminderId) async {
    try {
      await _remindersRef.child(reminderId).remove();
      if (AppConfig.debugLogging) {
        print('[Firebase] Reminder deleted: $reminderId');
      }
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[Firebase] Error deleting reminder: $e');
      }
    }
  }

  /// Delete a note from Firebase
  Future<void> deleteNote(String noteId) async {
    try {
      await _notesRef.child(noteId).remove();
      if (AppConfig.debugLogging) {
        print('[Firebase] Note deleted: $noteId');
      }
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[Firebase] Error deleting note: $e');
      }
    }
  }

  /// Sync a single energy entry to Firebase
  Future<void> syncEnergyEntry(EnergyEntry entry) async {
    try {
      await _energyEntriesRef.child(entry.id).set(entry.toJson());
      if (AppConfig.debugLogging) {
        print('[Firebase] Energy entry synced: ${entry.id}');
      }
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[Firebase] Error syncing energy entry: $e');
      }
    }
  }

  /// Delete an energy entry from Firebase
  Future<void> deleteEnergyEntry(String entryId) async {
    try {
      await _energyEntriesRef.child(entryId).remove();
      if (AppConfig.debugLogging) {
        print('[Firebase] Energy entry deleted: $entryId');
      }
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[Firebase] Error deleting energy entry: $e');
      }
    }
  }

  /// Listen to real-time energy entry changes
  void listenToEnergyEntries(Function(List<EnergyEntry>) callback) {
    _energyEntriesRef.onValue.listen((event) {
      try {
        final entries = <EnergyEntry>[];
        if (event.snapshot.value is Map) {
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);
          data.forEach((key, value) {
            if (value is Map<String, dynamic>) {
              entries.add(EnergyEntry.fromJson(value));
            }
          });
        }
        callback(entries);
        if (AppConfig.debugLogging) {
          print('[Firebase] Energy entries updated: ${entries.length} items');
        }
      } catch (e) {
        if (AppConfig.debugLogging) {
          print('[Firebase] Error parsing energy entries: $e');
        }
      }
    });
  }

  /// Cleanup listeners and disconnect
  Future<void> dispose() async {
    try {
      // Note: Firebase listeners are automatically cleaned up when refs are garbage collected
      await _auth.signOut();
      if (AppConfig.debugLogging) {
        print('[Firebase] Disconnected');
      }
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[Firebase] Error during cleanup: $e');
      }
    }
  }

  /// Helper to convert map to NoteModel
  NoteModel _noteFromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      category: map['category'],
      color: map['color'] ?? '#FFD700',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
      isPinned: map['isPinned'] ?? false,
    );
  }

  static FirebaseRealtimeSyncService get instance => _instance;
}
