import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kinetic/models/task_model.dart';
import 'package:kinetic/models/event_model.dart';
import 'package:kinetic/models/reminder_model.dart';
import 'package:kinetic/models/note_model.dart';
import 'package:kinetic/models/energy_entry.dart';
import 'package:kinetic/config/app_config.dart';
import 'package:kinetic/services/notification_service.dart';
import 'package:kinetic/services/encryption_service.dart';
import 'package:kinetic/services/database_encryption_service.dart';

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
        print('[Firebase] Platform: ${DatabaseEncryptionService.instance.getPlatformType()}');
      }
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[Firebase] Initialization error: $e');
      }
    }
  }

  /// Sync a single task to Firebase (encrypted)
  Future<void> syncTask(TaskModel task) async {
    try {
      // Encrypt task data before uploading
      final taskJson = task.toJson();
      final encryptedPayload = await EncryptionService.instance.encryptPayload(taskJson);

      // Add platform info to sync metadata
      final platformType = DatabaseEncryptionService.instance.getPlatformType();
      final syncPayload = {
        ...encryptedPayload,
        'platform': platformType,
        'syncTimestamp': DateTime.now().toIso8601String(),
      };

      await _tasksRef.child(task.id).set(syncPayload);
      if (AppConfig.debugLogging) {
        print('[Firebase] Task synced (encrypted) from $platformType: ${task.id}');
      }
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[Firebase] Error syncing task: $e');
      }
    }
  }

  /// Sync a single event to Firebase (encrypted)
  Future<void> syncEvent(Event event) async {
    try {
      // Encrypt event data before uploading
      final eventMap = event.toMap();
      final encryptedPayload = await EncryptionService.instance.encryptPayload(eventMap);

      // Add platform info to sync metadata
      final platformType = DatabaseEncryptionService.instance.getPlatformType();
      final syncPayload = {
        ...encryptedPayload,
        'platform': platformType,
        'syncTimestamp': DateTime.now().toIso8601String(),
      };

      await _eventsRef.child(event.id).set(syncPayload);
      if (AppConfig.debugLogging) {
        print('[Firebase] Event synced (encrypted) from $platformType: ${event.id}');
      }
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[Firebase] Error syncing event: $e');
      }
    }
  }

  /// Sync a single reminder to Firebase (encrypted)
  Future<void> syncReminder(ReminderModel reminder) async {
    try {
      // Encrypt reminder data before uploading
      final reminderMap = reminder.toMap();
      final encryptedPayload = await EncryptionService.instance.encryptPayload(reminderMap);

      // Add platform info to sync metadata
      final platformType = DatabaseEncryptionService.instance.getPlatformType();
      final syncPayload = {
        ...encryptedPayload,
        'platform': platformType,
        'syncTimestamp': DateTime.now().toIso8601String(),
      };

      await _remindersRef.child(reminder.id).set(syncPayload);
      if (AppConfig.debugLogging) {
        print('[Firebase] Reminder synced (encrypted) from $platformType: ${reminder.id}');
      }
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[Firebase] Error syncing reminder: $e');
      }
    }
  }

  /// Sync a single note to Firebase (encrypted)
  Future<void> syncNote(NoteModel note) async {
    try {
      // Encrypt note data before uploading
      final noteData = {
        'id': note.id,
        'title': note.title,
        'content': note.content,
        'category': note.category,
        'color': note.color,
        'createdAt': note.createdAt.toIso8601String(),
        'updatedAt': note.updatedAt.toIso8601String(),
        'isPinned': note.isPinned,
      };
      final encryptedPayload = await EncryptionService.instance.encryptPayload(noteData);

      // Add platform info to sync metadata
      final platformType = DatabaseEncryptionService.instance.getPlatformType();
      final syncPayload = {
        ...encryptedPayload,
        'platform': platformType,
        'syncTimestamp': DateTime.now().toIso8601String(),
      };

      await _notesRef.child(note.id).set(syncPayload);
      if (AppConfig.debugLogging) {
        print('[Firebase] Note synced (encrypted) from $platformType: ${note.id}');
      }
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[Firebase] Error syncing note: $e');
      }
    }
  }

  /// Listen to real-time task changes (decrypted)
  /// CRITICAL: Decrypts encrypted tasks and schedules notifications for synced tasks
  void listenToTasks(Function(List<TaskModel>) callback) {
    _tasksRef.onValue.listen((event) async {
      try {
        final tasks = <TaskModel>[];
        if (event.snapshot.value is Map) {
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);
          for (final entry in data.entries) {
            try {
              final value = entry.value as Map<String, dynamic>;

              // Decrypt task data
              Map<String, dynamic> taskData;
              if (value.containsKey('v') && value.containsKey('data')) {
                // New encrypted format
                taskData = await EncryptionService.instance.decryptPayload(value);
              } else {
                // Legacy plaintext format (backward compatibility)
                if (AppConfig.debugLogging) {
                  print('[Firebase] Found legacy unencrypted task, will re-sync encrypted');
                }
                taskData = value;
              }

              tasks.add(TaskModel.fromJson(taskData));
            } catch (e) {
              if (AppConfig.debugLogging) {
                print('[Firebase] Error decrypting task: $e');
              }
            }
          }
        }

        // Schedule notifications for synced tasks
        for (final task in tasks) {
          try {
            if (task.reminderEnabled == true &&
                task.reminderTime != null &&
                !task.completed &&
                task.reminderTime!.isAfter(DateTime.now())) {
              final reminder = ReminderModel(
                id: 'task_${task.id}',
                title: task.title,
                body: task.description ?? 'Task reminder',
                scheduledTime: task.reminderTime!,
                notificationId: task.id.hashCode.toString(),
                completed: false,
              );

              await NotificationService.instance.scheduleNotification(reminder);
              if (AppConfig.debugLogging) {
                print('[Firebase] Scheduled notification for synced task: ${task.title}');
              }
            }
          } catch (e) {
            if (AppConfig.debugLogging) {
              print('[Firebase] Error scheduling notification for synced task: $e');
            }
          }
        }

        callback(tasks);
        if (AppConfig.debugLogging) {
          print('[Firebase] Tasks updated: ${tasks.length} items (decrypted)');
        }
      } catch (e) {
        if (AppConfig.debugLogging) {
          print('[Firebase] Error parsing tasks: $e');
        }
      }
    });
  }

  /// Listen to real-time event changes (decrypted)
  /// CRITICAL: Decrypts encrypted events and schedules notifications for synced events
  void listenToEvents(Function(List<Event>) callback) {
    _eventsRef.onValue.listen((event) async {
      try {
        final events = <Event>[];
        if (event.snapshot.value is Map) {
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);
          for (final entry in data.entries) {
            try {
              final value = entry.value as Map<String, dynamic>;

              // Decrypt event data
              Map<String, dynamic> eventData;
              if (value.containsKey('v') && value.containsKey('data')) {
                // New encrypted format
                eventData = await EncryptionService.instance.decryptPayload(value);
              } else {
                // Legacy plaintext format (backward compatibility)
                if (AppConfig.debugLogging) {
                  print('[Firebase] Found legacy unencrypted event, will re-sync encrypted');
                }
                eventData = value;
              }

              events.add(Event.fromMap(eventData));
            } catch (e) {
              if (AppConfig.debugLogging) {
                print('[Firebase] Error decrypting event: $e');
              }
            }
          }
        }

        // Schedule notifications for synced events
        for (final evt in events) {
          try {
            if (evt.reminderEnabled == true &&
                evt.reminderTime != null &&
                !evt.completed &&
                evt.reminderTime!.isAfter(DateTime.now())) {
              final reminder = ReminderModel(
                id: 'event_${evt.id}',
                title: evt.title,
                body: evt.description ?? 'Event reminder',
                scheduledTime: evt.reminderTime!,
                notificationId: evt.id.hashCode.toString(),
                completed: false,
              );

              await NotificationService.instance.scheduleNotification(reminder);
              if (AppConfig.debugLogging) {
                print('[Firebase] Scheduled notification for synced event: ${evt.title}');
              }
            }
          } catch (e) {
            if (AppConfig.debugLogging) {
              print('[Firebase] Error scheduling notification for synced event: $e');
            }
          }
        }

        callback(events);
        if (AppConfig.debugLogging) {
          print('[Firebase] Events updated: ${events.length} items (decrypted)');
        }
      } catch (e) {
        if (AppConfig.debugLogging) {
          print('[Firebase] Error parsing events: $e');
        }
      }
    });
  }

  /// Listen to real-time reminder changes (decrypted)
  /// CRITICAL: Decrypts encrypted reminders and schedules notifications
  void listenToReminders(Function(List<ReminderModel>) callback) {
    _remindersRef.onValue.listen((event) async {
      try {
        final reminders = <ReminderModel>[];
        if (event.snapshot.value is Map) {
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);
          for (final entry in data.entries) {
            try {
              final value = entry.value as Map<String, dynamic>;

              // Decrypt reminder data
              Map<String, dynamic> reminderData;
              if (value.containsKey('v') && value.containsKey('data')) {
                // New encrypted format
                reminderData = await EncryptionService.instance.decryptPayload(value);
              } else {
                // Legacy plaintext format (backward compatibility)
                if (AppConfig.debugLogging) {
                  print('[Firebase] Found legacy unencrypted reminder, will re-sync encrypted');
                }
                reminderData = value;
              }

              reminders.add(ReminderModel.fromMap(reminderData));
            } catch (e) {
              if (AppConfig.debugLogging) {
                print('[Firebase] Error decrypting reminder: $e');
              }
            }
          }
        }

        // Schedule notifications for synced reminders
        for (final reminder in reminders) {
          try {
            if (!reminder.completed && reminder.scheduledTime.isAfter(DateTime.now())) {
              await NotificationService.instance.scheduleNotification(reminder);
              if (AppConfig.debugLogging) {
                print('[Firebase] Scheduled notification for synced reminder: ${reminder.title}');
              }
            }
          } catch (e) {
            if (AppConfig.debugLogging) {
              print('[Firebase] Error scheduling notification for synced reminder: $e');
            }
          }
        }

        callback(reminders);
        if (AppConfig.debugLogging) {
          print('[Firebase] Reminders updated: ${reminders.length} items (decrypted)');
        }
      } catch (e) {
        if (AppConfig.debugLogging) {
          print('[Firebase] Error parsing reminders: $e');
        }
      }
    });
  }

  /// Listen to real-time note changes (decrypted)
  void listenToNotes(Function(List<NoteModel>) callback) {
    _notesRef.onValue.listen((event) async {
      try {
        final notes = <NoteModel>[];
        if (event.snapshot.value is Map) {
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);
          for (final entry in data.entries) {
            try {
              final value = entry.value as Map<String, dynamic>;

              // Decrypt note data
              Map<String, dynamic> noteData;
              if (value.containsKey('v') && value.containsKey('data')) {
                // New encrypted format
                noteData = await EncryptionService.instance.decryptPayload(value);
              } else {
                // Legacy plaintext format (backward compatibility)
                if (AppConfig.debugLogging) {
                  print('[Firebase] Found legacy unencrypted note, will re-sync encrypted');
                }
                noteData = value;
              }

              notes.add(_noteFromMap(noteData));
            } catch (e) {
              if (AppConfig.debugLogging) {
                print('[Firebase] Error decrypting note: $e');
              }
            }
          }
        }
        callback(notes);
        if (AppConfig.debugLogging) {
          print('[Firebase] Notes updated: ${notes.length} items (decrypted)');
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

  /// Sync a single energy entry to Firebase (encrypted)
  Future<void> syncEnergyEntry(EnergyEntry entry) async {
    try {
      // Encrypt energy entry data before uploading
      final entryJson = entry.toJson();
      final encryptedPayload = await EncryptionService.instance.encryptPayload(entryJson);

      // Add platform info to sync metadata
      final platformType = DatabaseEncryptionService.instance.getPlatformType();
      final syncPayload = {
        ...encryptedPayload,
        'platform': platformType,
        'syncTimestamp': DateTime.now().toIso8601String(),
      };

      await _energyEntriesRef.child(entry.id).set(syncPayload);
      if (AppConfig.debugLogging) {
        print('[Firebase] Energy entry synced (encrypted) from $platformType: ${entry.id}');
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

  /// Listen to real-time energy entry changes (decrypted)
  void listenToEnergyEntries(Function(List<EnergyEntry>) callback) {
    _energyEntriesRef.onValue.listen((event) async {
      try {
        final entries = <EnergyEntry>[];
        if (event.snapshot.value is Map) {
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);
          for (final entry in data.entries) {
            try {
              final value = entry.value as Map<String, dynamic>;

              // Decrypt energy entry data
              Map<String, dynamic> entryData;
              if (value.containsKey('v') && value.containsKey('data')) {
                // New encrypted format
                entryData = await EncryptionService.instance.decryptPayload(value);
              } else {
                // Legacy plaintext format (backward compatibility)
                if (AppConfig.debugLogging) {
                  print('[Firebase] Found legacy unencrypted energy entry, will re-sync encrypted');
                }
                entryData = value;
              }

              entries.add(EnergyEntry.fromJson(entryData));
            } catch (e) {
              if (AppConfig.debugLogging) {
                print('[Firebase] Error decrypting energy entry: $e');
              }
            }
          }
        }
        callback(entries);
        if (AppConfig.debugLogging) {
          print('[Firebase] Energy entries updated: ${entries.length} items (decrypted)');
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
