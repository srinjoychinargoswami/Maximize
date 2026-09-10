import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maximize/models/database.dart';
import 'package:maximize/database/app_database_adapter.dart';
import 'package:maximize/services/settings_service.dart';

class FirebaseSyncService {
  final AppDatabase db;
  final SettingsService _settings = SettingsService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseSyncService({required this.db});

  // Sign in anonymously — no email/password, completely free
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

  // Each user gets their own isolated collection: users/{uid}/tasks etc.
  CollectionReference _col(String uid, String collection) =>
      _firestore.collection('users').doc(uid).collection(collection);

  // ─── UPLOAD ────────────────────────────────────────────────
  Future<void> syncToFirebase() async {
    final uid = await _uid;
    if (uid == null) throw Exception('Firebase not authenticated');

    final data = await db.getAllDataAsJson();

    // Write each collection in parallel
    await Future.wait([
      _syncCollection(uid, 'tasks',     data['tasks']     ?? []),
      _syncCollection(uid, 'subtasks',  data['subtasks']  ?? []),
      _syncCollection(uid, 'events',    data['events']    ?? []),
      _syncCollection(uid, 'reminders', data['reminders'] ?? []),
      _syncCollection(uid, 'notes',     data['notes']     ?? []),
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

  // ─── DOWNLOAD ──────────────────────────────────────────────
  Future<void> syncFromFirebase() async {
    final uid = await _uid;
    if (uid == null) throw Exception('Firebase not authenticated');

    final results = await Future.wait([
      _col(uid, 'tasks').get(),
      _col(uid, 'subtasks').get(),
      _col(uid, 'events').get(),
      _col(uid, 'reminders').get(),
      _col(uid, 'notes').get(),
    ]);

    final data = {
      'tasks':     _docsToList(results[0]),
      'subtasks':  _docsToList(results[1]),
      'events':    _docsToList(results[2]),
      'reminders': _docsToList(results[3]),
      'notes':     _docsToList(results[4]),
    };

    await _syncWithDeletionDetection(data);
  }

  List<Map<String, dynamic>> _docsToList(QuerySnapshot snap) =>
      snap.docs.map((d) => d.data() as Map<String, dynamic>).toList();

  // Same deletion logic as your ApiService
  Future<void> _syncWithDeletionDetection(
      Map<String, dynamic> remoteData) async {
    final remoteTaskIds     = _extractIds(remoteData['tasks']);
    final remoteSubtaskIds  = _extractIds(remoteData['subtasks']);
    final remoteEventIds    = _extractIds(remoteData['events']);
    final remoteReminderIds = _extractIds(remoteData['reminders']);
    final remoteNoteIds     = _extractIds(remoteData['notes']);

    final localTasks     = await db.getAllTasks();
    final localSubtasks  = await db.getAllSubtasks('');
    final localEvents    = await db.getAllEvents();
    final localReminders = await db.getAllReminders();
    final localNotes     = await db.getAllNotes();

    for (final id in localTasks.map((t) => t.id).toSet().difference(remoteTaskIds)) {
      await db.deleteTask(id);
    }
    for (final id in localSubtasks.map((s) => s.id).toSet().difference(remoteSubtaskIds)) {
      await db.deleteSubtask(id);
    }
    for (final id in localEvents.map((e) => e.id).toSet().difference(remoteEventIds)) {
      await db.deleteEvent(id);
    }
    for (final id in localReminders.map((r) => r.id).toSet().difference(remoteReminderIds)) {
      await db.deleteReminder(id);
    }
    for (final id in localNotes.map((n) => n.id).toSet().difference(remoteNoteIds)) {
      await db.deleteNote(id);
    }

    await db.insertAllFromJson(remoteData);
  }

  Set<String> _extractIds(dynamic list) {
    if (list == null || list is! List) return {};
    return list
        .whereType<Map<String, dynamic>>()
        .map((item) => item['id'] as String?)
        .whereType<String>()
        .toSet();
  }

  // ─── DISCONNECT ────────────────────────────────────────────
  Future<void> disconnect() async {
    await _auth.signOut();
    await _settings.clearFirebaseUid();
    await _settings.setSyncProvider(SyncProvider.none);
  }

  // Check if currently connected
  Future<bool> get isConnected async {
    final uid = await _settings.getFirebaseUid();
    return uid != null && _auth.currentUser != null;
  }
}
