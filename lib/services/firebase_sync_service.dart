import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kinetic/database/app_database.dart';
import 'package:kinetic/services/settings_service.dart';
import 'package:kinetic/services/task_service.dart';
import 'package:kinetic/services/event_service.dart';
import 'package:kinetic/services/reminder_service.dart';
import 'package:kinetic/services/note_service.dart';

class FirebaseSyncService {
  final AppDatabase db;
  final SettingsService _settings;
  final TaskService _taskService;
  final EventService _eventService;
  final ReminderService _reminderService;
  final NoteService _noteService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseSyncService({
    required this.db,
    required SettingsService settings,
    required TaskService taskService,
    required EventService eventService,
    required ReminderService reminderService,
    required NoteService noteService,
  })  : _settings = settings,
        _taskService = taskService,
        _eventService = eventService,
        _reminderService = reminderService,
        _noteService = noteService;

  Future<String> signInAnonymously() async {
    User? user = _auth.currentUser;
    if (user == null) {
      final cred = await _auth.signInAnonymously();
      user = cred.user!;
    }
    await _settings.setFirebaseUid(user.uid);
    return user.uid;
  }

  Future<String?> get _uid async {
    final stored = await _settings.getFirebaseUid();
    if (stored != null) return stored;
    return await signInAnonymously();
  }

  CollectionReference _col(String uid, String collection) =>
      _firestore.collection('users').doc(uid).collection(collection);

  Future<void> syncToFirebase() async {
    final uid = await _uid;
    if (uid == null) throw Exception('Firebase not authenticated');

    final tasks = await _taskService.getTasks();
    final events = await _eventService.getAllEvents();
    final reminders = await _reminderService.getReminders();
    final notes = await _noteService.getNotes();

    final data = {
      'tasks': tasks.map((t) => t.toMap()).toList(),
      'events': events.map((e) => e.toMap()).toList(),
      'reminders': reminders.map((r) => r.toMap()).toList(),
      'notes': notes.map((n) => n.toMap()).toList(),
    };

    await Future.wait([
      _syncCollection(uid, 'tasks', data['tasks'] ?? []),
      _syncCollection(uid, 'events', data['events'] ?? []),
      _syncCollection(uid, 'reminders', data['reminders'] ?? []),
      _syncCollection(uid, 'notes', data['notes'] ?? []),
    ]);
  }

  Future<void> _syncCollection(
      String uid, String name, List<dynamic> items) async {
    final col = _col(uid, name);
    final batch = _firestore.batch();
    for (final item in items) {
      if (item is Map<String, dynamic> && item['id'] != null) {
        batch.set(col.doc(item['id']), item, SetOptions(merge: true));
      }
    }
    await batch.commit();
  }

  Future<void> syncFromFirebase() async {
    final uid = await _uid;
    if (uid == null) throw Exception('Firebase not authenticated');

    final results = await Future.wait([
      _col(uid, 'tasks').get(),
      _col(uid, 'events').get(),
      _col(uid, 'reminders').get(),
      _col(uid, 'notes').get(),
    ]);

    final data = {
      'tasks': _docsToList(results[0]),
      'events': _docsToList(results[1]),
      'reminders': _docsToList(results[2]),
      'notes': _docsToList(results[3]),
    };

    await _syncWithDeletionDetection(data);
  }

  List<Map<String, dynamic>> _docsToList(QuerySnapshot snap) =>
      snap.docs.map((d) => d.data() as Map<String, dynamic>).toList();

  Future<void> _syncWithDeletionDetection(
      Map<String, dynamic> remoteData) async {
    final remoteTaskIds = _extractIds(remoteData['tasks']);
    final remoteEventIds = _extractIds(remoteData['events']);
    final remoteReminderIds = _extractIds(remoteData['reminders']);
    final remoteNoteIds = _extractIds(remoteData['notes']);

    final localTasks = await _taskService.getTasks();
    final localEvents = await _eventService.getAllEvents();
    final localReminders = await _reminderService.getReminders();
    final localNotes = await _noteService.getNotes();

    for (final task in localTasks) {
      if (!remoteTaskIds.contains(task.id)) {
        // Delete locally if not in remote
        // Note: would need to implement delete in TaskService
      }
    }

    for (final event in localEvents) {
      if (!remoteEventIds.contains(event.id)) {
        // Delete locally if not in remote
        await _eventService.deleteEvent(event.id);
      }
    }

    for (final reminder in localReminders) {
      if (!remoteReminderIds.contains(reminder.id)) {
        // Delete locally if not in remote
      }
    }

    for (final note in localNotes) {
      if (!remoteNoteIds.contains(note.id)) {
        // Delete locally if not in remote
      }
    }

    // Merge remote data (simplified - full implementation would handle conflicts)
  }

  Set<String> _extractIds(dynamic list) {
    if (list == null || list is! List) return {};
    return list
        .whereType<Map<String, dynamic>>()
        .map((item) => item['id'] as String?)
        .whereType<String>()
        .toSet();
  }

  Future<void> disconnect() async {
    await _auth.signOut();
    await _settings.clearFirebaseUid();
  }

  Future<bool> get isConnected async {
    final uid = await _settings.getFirebaseUid();
    return uid != null && _auth.currentUser != null;
  }
}
