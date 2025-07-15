import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maximize/models/database.dart';
import 'package:maximize/utils/encryption_helper.dart';

class ApiService {
  static const String githubUsername = 'your-github-username';
  static const String repoName = 'productivity-sync';
  static const String fileName = 'sync_data.json.enc';
  static const String tokenKey = 'github_token';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final AppDatabase db;

  ApiService({required this.db});

  Future<String?> getStoredToken() async {
    return await _storage.read(key: tokenKey);
  }

  Future<void> saveGitHubToken(String token) async {
    await _storage.write(key: tokenKey, value: token);
  }

  Future<void> deleteGitHubToken() async {
    await _storage.delete(key: tokenKey);
  }

  Future<void> syncToGitHub() async {
    final token = await _storage.read(key: tokenKey);
    if (token == null) throw Exception("GitHub token not set in secure storage.");

    final data = await db.getAllDataAsJson();
    final encrypted = EncryptionHelper.encrypt(jsonEncode(data));
    final base64Content = base64Encode(utf8.encode(encrypted));

    final url = Uri.parse('https://api.github.com/repos/$githubUsername/$repoName/contents/$fileName');
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

  Future<void> syncFromGitHub() async {
    final token = await _storage.read(key: tokenKey);
    if (token == null) throw Exception("GitHub token not set in secure storage.");

    final url = Uri.parse('https://api.github.com/repos/$githubUsername/$repoName/contents/$fileName');
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode != 200) throw Exception("Failed to download sync file from GitHub");

    final jsonResponse = jsonDecode(response.body);
    final base64Content = jsonResponse['content'];
    final encrypted = utf8.decode(base64Decode(base64Content));
    final decrypted = EncryptionHelper.decrypt(encrypted);
    final data = jsonDecode(decrypted);

    await db.insertAllFromJson(data);
  }
}
