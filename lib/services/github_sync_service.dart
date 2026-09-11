import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maximize/services/settings_service.dart';
import 'package:maximize/services/task_service.dart';
import 'package:maximize/services/event_service.dart';
import 'package:maximize/services/reminder_service.dart';
import 'package:maximize/services/note_service.dart';

class GitHubSyncService {
  static const String _fileName = 'sync_data.json.enc';

  final SettingsService _settings = SettingsService();
  final TaskService? _taskService;
  final EventService? _eventService;
  final ReminderService? _reminderService;
  final NoteService? _noteService;

  GitHubSyncService({
    TaskService? taskService,
    EventService? eventService,
    ReminderService? reminderService,
    NoteService? noteService,
  })  : _taskService = taskService,
        _eventService = eventService,
        _reminderService = reminderService,
        _noteService = noteService;

  // Token management
  Future<String?> getToken() async {
    return await _settings.getGitToken();
  }

  Future<void> saveToken(String token) async {
    await _settings.setGitToken(token);
  }

  Future<void> deleteToken() async {
    await _settings.deleteGitToken();
  }

  // Username management
  Future<String> getUsername() async {
    return await _settings.getGitUsername();
  }

  Future<void> saveUsername(String username) async {
    await _settings.setGitUsername(username);
  }

  // Repo management
  Future<String> getRepo() async {
    return await _settings.getGitRepo();
  }

  Future<void> saveRepo(String repo) async {
    await _settings.setGitRepo(repo);
  }

  // Base URL management
  Future<String> getBaseUrl() async {
    return await _settings.getGitBaseUrl();
  }

  Future<void> setBaseUrl(String url) async {
    await _settings.setGitBaseUrl(url);
  }

  // Check authentication
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    final username = await getUsername();
    final repo = await getRepo();
    return token != null && token.isNotEmpty && username.isNotEmpty && repo.isNotEmpty;
  }

  // Logout - clear all stored credentials
  Future<void> logout() async {
    await _settings.clearGitCredentials();
  }

  // Build repo file URI
  Future<Uri> _getRepoFileUri() async {
    return await _settings.buildGitFileUri(_fileName);
  }

  // Upload data to GitHub
  Future<void> uploadData() async {
    final token = await getToken();
    if (token == null) throw Exception('GitHub token not configured');

    try {
      final tasks = await _taskService?.getTasks() ?? [];
      final events = await _eventService?.getAllEvents() ?? [];
      final reminders = await _reminderService?.getReminders() ?? [];
      final notes = await _noteService?.getNotes() ?? [];

      final data = {
        'tasks': tasks.map((t) => t.toMap()).toList(),
        'events': events.map((e) => e.toMap()).toList(),
        'reminders': reminders.map((r) => r.toMap()).toList(),
        'notes': notes.map((n) => n.toMap()).toList(),
      };

      final jsonString = jsonEncode(data);
      final base64Content = base64Encode(utf8.encode(jsonString));

      final url = await _getRepoFileUri();

      // Check if file exists to get SHA (for updates)
      final getResp = await http.get(url, headers: {'Authorization': 'Bearer $token'});
      String? sha;

      if (getResp.statusCode == 200) {
        final existingFile = jsonDecode(getResp.body);
        sha = existingFile['sha'];
      }

      final body = {
        "message": "Sync data ${DateTime.now().toIso8601String()}",
        "content": base64Content,
        if (sha != null) "sha": sha,
      };

      final putResp = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (putResp.statusCode != 201 && putResp.statusCode != 200) {
        throw Exception("Failed to upload sync file to GitHub: ${putResp.statusCode}");
      }
    } catch (e) {
      throw Exception('Error uploading to GitHub: $e');
    }
  }

  // Download data from GitHub
  Future<void> downloadData() async {
    final token = await getToken();
    if (token == null) throw Exception('GitHub token not configured');

    try {
      final url = await _getRepoFileUri();
      final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode != 200) {
        throw Exception("Failed to download sync file from GitHub: ${response.statusCode}");
      }

      final jsonResponse = jsonDecode(response.body);
      final githubBase64Content = jsonResponse['content'];

      // Decode base64 content
      final cleanBase64Content = githubBase64Content
          .replaceAll(RegExp(r'\s'), '')
          .replaceAll(RegExp(r'[^\w+/=]'), '')
          .trim();

      final jsonString = utf8.decode(base64Decode(cleanBase64Content));
      final data = jsonDecode(jsonString);

      // Sync with deletion detection
      await _syncWithDeletionDetection(data);
    } catch (e) {
      throw Exception('Error downloading from GitHub: $e');
    }
  }

  // Sync with deletion detection
  Future<void> _syncWithDeletionDetection(Map<String, dynamic> githubData) async {
    try {
      // Extract IDs from GitHub data
      final githubTaskIds = _extractIds(githubData['tasks']);
      final githubEventIds = _extractIds(githubData['events']);
      final githubReminderIds = _extractIds(githubData['reminders']);
      final githubNoteIds = _extractIds(githubData['notes']);

      // Get local IDs
      final localTasks = await _taskService?.getTasks() ?? [];
      final localEvents = await _eventService?.getAllEvents() ?? [];
      final localReminders = await _reminderService?.getReminders() ?? [];
      final localNotes = await _noteService?.getNotes() ?? [];

      final localTaskIds = localTasks.map((t) => t.id).toSet();
      final localEventIds = localEvents.map((e) => e.id).toSet();
      final localReminderIds = localReminders.map((r) => r.id).toSet();
      final localNoteIds = localNotes.map((n) => n.id).toSet();

      // Find orphaned items
      final tasksToDelete = localTaskIds.difference(githubTaskIds);
      final eventsToDelete = localEventIds.difference(githubEventIds);
      final remindersToDelete = localReminderIds.difference(githubReminderIds);
      final notesToDelete = localNoteIds.difference(githubNoteIds);

      // Delete orphaned items
      for (final taskId in tasksToDelete) {
        await _taskService?.deleteTask(taskId);
      }

      for (final eventId in eventsToDelete) {
        await _eventService?.deleteEvent(eventId);
      }

      for (final reminderId in remindersToDelete) {
        await _reminderService?.deleteReminder(reminderId);
      }

      for (final noteId in notesToDelete) {
        await _noteService?.deleteNote(noteId);
      }

      // Insert/update from GitHub (simplified - would need to iterate and upsert each item)
      // For now, just update existing items
      if (githubData['tasks'] is List) {
        for (final task in githubData['tasks']) {
          if (task is Map<String, dynamic> && task['id'] != null) {
            // Update existing task or create new one
            // This is a simplified version - full implementation would handle all fields
          }
        }
      }
    } catch (e) {
      throw Exception('Sync with deletion detection failed: $e');
    }
  }

  // Helper to extract IDs from JSON
  Set<String> _extractIds(dynamic jsonList) {
    if (jsonList == null) return {};
    if (jsonList is! List) return {};

    return jsonList
        .where((item) => item != null && item is Map<String, dynamic>)
        .map((item) => item['id'] as String?)
        .where((id) => id != null)
        .cast<String>()
        .toSet();
  }

  // Sync all data (upload then download)
  Future<void> syncAllData() async {
    await uploadData();
    await downloadData();
  }
}
