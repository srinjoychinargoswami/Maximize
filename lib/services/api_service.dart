import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maximize/models/database.dart';
import 'package:maximize/utils/encryption_helper.dart';

class ApiService {
  static const String defaultGitHubUsername = 'your-github-username';
  static const String defaultRepoName = 'productivity-sync';
  static const String fileName = 'sync_data.json.enc';

  static const String tokenKey = 'github_token';
  static const String usernameKey = 'github_username';
  static const String repoKey = 'github_repo';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final AppDatabase db;

  ApiService({required this.db});

  // Token methods
  Future<String?> getStoredToken() async {
    return await _storage.read(key: tokenKey);
  }

  Future<void> saveGitHubToken(String token) async {
    await _storage.write(key: tokenKey, value: token);
  }

  Future<void> deleteGitHubToken() async {
    await _storage.delete(key: tokenKey);
  }

  // Username methods
  Future<String> getGitHubUsername() async {
    final username = await _storage.read(key: usernameKey);
    return username ?? defaultGitHubUsername;
  }

  Future<void> saveGitHubUsername(String username) async {
    await _storage.write(key: usernameKey, value: username);
  }

  Future<void> deleteGitHubUsername() async {
    await _storage.delete(key: usernameKey);
  }

  // Repo name methods
  Future<String> getGitHubRepo() async {
    final repo = await _storage.read(key: repoKey);
    return repo ?? defaultRepoName;
  }

  Future<void> saveGitHubRepo(String repo) async {
    await _storage.write(key: repoKey, value: repo);
  }

  Future<void> deleteGitHubRepo() async {
    await _storage.delete(key: repoKey);
  }

  // Build repo URL dynamically
  Future<Uri> _getRepoFileUri() async {
    final username = await getGitHubUsername();
    final repo = await getGitHubRepo();
    return Uri.parse('https://api.github.com/repos/$username/$repo/contents/$fileName');
  }

  // Upload method (unchanged)
  Future<void> syncToGitHub() async {
    final token = await getStoredToken();
    if (token == null) throw Exception("GitHub token not set in secure storage.");

    final data = await db.getAllDataAsJson();
    final encrypted = EncryptionHelper.encrypt(jsonEncode(data));
    final base64Content = base64Encode(utf8.encode(encrypted));

    final url = await _getRepoFileUri();
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
      throw Exception("Failed to upload sync file to GitHub");
    }
  }

  // FIXED: Download method with deletion detection
  Future<void> syncFromGitHub() async {
    try {
      final token = await getStoredToken();
      if (token == null) throw Exception("GitHub token not set in secure storage.");

      final url = await _getRepoFileUri();
      final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode != 200) throw Exception("Failed to download sync file from GitHub");

      final jsonResponse = jsonDecode(response.body);
      final githubBase64Content = jsonResponse['content'];
      
      // Clean Base64 content
      final cleanBase64Content = githubBase64Content
          .replaceAll(RegExp(r'\s'), '')
          .replaceAll(RegExp(r'[^\w+/=]'), '')
          .trim();
      
      // Decode
      final encryptedString = utf8.decode(base64Decode(cleanBase64Content));
      final decrypted = EncryptionHelper.decrypt(encryptedString);

      final data = jsonDecode(decrypted);
      
      // Detect and delete items that exist locally but not in GitHub
      await _syncWithDeletionDetection(data);
      
    } catch (e) {
      print('Error syncing from GitHub: $e');
      throw Exception('Error syncing from GitHub: $e');
    }
  }

  // Sync with deletion detection - UPDATED WITH NOTES
  Future<void> _syncWithDeletionDetection(Map<String, dynamic> githubData) async {
    print('[ApiService] Starting sync with deletion detection...');
    
    // Step 1: Get IDs from GitHub data
    final githubTaskIds = _extractIds(githubData['tasks']);
    final githubSubtaskIds = _extractIds(githubData['subtasks']);
    final githubEventIds = _extractIds(githubData['events']);
    final githubReminderIds = _extractIds(githubData['reminders']);
    final githubNoteIds = _extractIds(githubData['notes']); // ADDED
    
    print('[ApiService] GitHub has: ${githubTaskIds.length} tasks, ${githubSubtaskIds.length} subtasks, ${githubEventIds.length} events, ${githubReminderIds.length} reminders, ${githubNoteIds.length} notes');
    
    // Step 2: Get IDs from local database
    final localTasks = await db.getAllTasks();
    final localSubtasks = await db.getAllSubtasks(''); // Empty string gets all subtasks
    final localEvents = await db.getAllEvents();
    final localReminders = await db.getAllReminders();
    final localNotes = await db.getAllNotes(); // ADDED
    
    final localTaskIds = localTasks.map((t) => t.id).toSet();
    final localSubtaskIds = localSubtasks.map((s) => s.id).toSet();
    final localEventIds = localEvents.map((e) => e.id).toSet();
    final localReminderIds = localReminders.map((r) => r.id).toSet();
    final localNoteIds = localNotes.map((n) => n.id).toSet(); // ADDED
    
    print('[ApiService] Local has: ${localTaskIds.length} tasks, ${localSubtaskIds.length} subtasks, ${localEventIds.length} events, ${localReminderIds.length} reminders, ${localNoteIds.length} notes');
    
    // Step 3: Find items to delete (exist locally but not in GitHub)
    final tasksToDelete = localTaskIds.difference(githubTaskIds);
    final subtasksToDelete = localSubtaskIds.difference(githubSubtaskIds);
    final eventsToDelete = localEventIds.difference(githubEventIds);
    final remindersToDelete = localReminderIds.difference(githubReminderIds);
    final notesToDelete = localNoteIds.difference(githubNoteIds); // ADDED
    
    print('[ApiService] Items to delete: ${tasksToDelete.length} tasks, ${subtasksToDelete.length} subtasks, ${eventsToDelete.length} events, ${remindersToDelete.length} reminders, ${notesToDelete.length} notes');
    
    // Step 4: Delete orphaned items from local database
    for (final taskId in tasksToDelete) {
      print('[ApiService] Deleting orphaned task: $taskId');
      await db.deleteTask(taskId);
    }
    
    for (final subtaskId in subtasksToDelete) {
      print('[ApiService] Deleting orphaned subtask: $subtaskId');
      await db.deleteSubtask(subtaskId);
    }
    
    for (final eventId in eventsToDelete) {
      print('[ApiService] Deleting orphaned event: $eventId');
      await db.deleteEvent(eventId);
    }
    
    for (final reminderId in remindersToDelete) {
      print('[ApiService] Deleting orphaned reminder: $reminderId');
      await db.deleteReminder(reminderId);
    }
    
    // ADDED: Delete orphaned notes
    for (final noteId in notesToDelete) {
      print('[ApiService] Deleting orphaned note: $noteId');
      await db.deleteNote(noteId);
    }
    
    // Step 5: Insert/update items from GitHub (existing functionality)
    print('[ApiService] Inserting/updating items from GitHub...');
    await db.insertAllFromJson(githubData);
    
    print('[ApiService] Sync with deletion detection complete!');
  }

  // Helper method to extract IDs from JSON list
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
}
