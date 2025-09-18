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

  // Token methods (unchanged)
  Future<String?> getStoredToken() async {
    return await _storage.read(key: tokenKey);
  }

  Future<void> saveGitHubToken(String token) async {
    await _storage.write(key: tokenKey, value: token);
  }

  Future<void> deleteGitHubToken() async {
    await _storage.delete(key: tokenKey);
  }

  // Username methods (unchanged)
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

  // Repo name methods (unchanged)
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

  // Build repo URL dynamically (unchanged)
  Future<Uri> _getRepoFileUri() async {
    final username = await getGitHubUsername();
    final repo = await getGitHubRepo();
    return Uri.parse('https://api.github.com/repos/$username/$repo/contents/$fileName');
  }

  // FIXED: Upload method with proper Base64 encoding
  Future<void> syncToGitHub() async {
    final token = await getStoredToken();
    if (token == null) throw Exception("GitHub token not set in secure storage.");

    final data = await db.getAllDataAsJson();
    final encrypted = EncryptionHelper.encrypt(jsonEncode(data));
    final base64Content = base64Encode(utf8.encode(encrypted)); // ✅ FIXED: Proper Base64 encoding

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

  // FIXED: Download method with proper Base64 decoding
  Future<void> syncFromGitHub() async {
    try {
      final token = await getStoredToken();
      if (token == null) throw Exception("GitHub token not set in secure storage.");

      final url = await _getRepoFileUri();
      final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode != 200) throw Exception("Failed to download sync file from GitHub");

      final jsonResponse = jsonDecode(response.body);
      final githubBase64Content = jsonResponse['content'];
      
      // FIXED: Enhanced Base64 cleaning
      final cleanBase64Content = githubBase64Content
          .replaceAll(RegExp(r'\s'), '')           // Remove all whitespace
          .replaceAll(RegExp(r'[^\w+/=]'), '')     // Keep only valid Base64 characters
          .trim();
      
      // FIXED: Proper decoding sequence
      final encryptedString = utf8.decode(base64Decode(cleanBase64Content));
      final decrypted = EncryptionHelper.decrypt(encryptedString);

      final data = jsonDecode(decrypted);
      await db.insertAllFromJson(data);
    } catch (e) {
      print('Error syncing from GitHub: $e');
      throw Exception('Error syncing from GitHub: $e');
    }
  }
}
