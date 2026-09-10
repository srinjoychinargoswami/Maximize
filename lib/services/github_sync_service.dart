import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GitHubSyncService {
  static const String _tokenKey = 'github_token';
  static const String _usernameKey = 'github_username';
  static const String _repoKey = 'github_repo';

  static const String _defaultUsername = 'your-github-username';
  static const String _defaultRepo = 'productivity-sync';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Token management
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Username management
  Future<String> getUsername() async {
    final username = await _storage.read(key: _usernameKey);
    return username ?? _defaultUsername;
  }

  Future<void> saveUsername(String username) async {
    await _storage.write(key: _usernameKey, value: username);
  }

  // Repo management
  Future<String> getRepo() async {
    final repo = await _storage.read(key: _repoKey);
    return repo ?? _defaultRepo;
  }

  Future<void> saveRepo(String repo) async {
    await _storage.write(key: _repoKey, value: repo);
  }

  // Check authentication
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Logout - clear all stored credentials
  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _usernameKey);
    await _storage.delete(key: _repoKey);
  }

  // Upload data to GitHub (placeholder)
  Future<void> uploadData() async {
    final token = await getToken();
    if (token == null) throw Exception('GitHub token not configured');

    // TODO: Implement actual GitHub sync using gist API or GitHub repo
    // For now, this is a placeholder
  }

  // Download data from GitHub (placeholder)
  Future<void> downloadData() async {
    final token = await getToken();
    if (token == null) throw Exception('GitHub token not configured');

    // TODO: Implement actual GitHub sync using gist API or GitHub repo
    // For now, this is a placeholder
  }

  // Sync all data (upload then download)
  Future<void> syncAllData() async {
    await uploadData();
    await downloadData();
  }
}
