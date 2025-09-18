import 'package:flutter/material.dart';
import 'package:maximize/services/api_service.dart';

class SettingsPage extends StatefulWidget {
  final ApiService api; // Pass your ApiService instance

  const SettingsPage({super.key, required this.api});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _repoController = TextEditingController();

  bool _tokenSaved = false;
  bool _usernameSaved = false;
  bool _repoSaved = false;
  bool _obscureText = true; // For token visibility toggle

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final storedToken = await widget.api.getStoredToken();
    final storedUsername = await widget.api.getGitHubUsername();
    final storedRepo = await widget.api.getGitHubRepo();

    if (storedToken != null) {
      _tokenController.text = storedToken;
      _tokenSaved = true;
    }

    if (storedUsername.isNotEmpty) {
      _usernameController.text = storedUsername;
      _usernameSaved = true;
    }

    if (storedRepo.isNotEmpty) {
      _repoController.text = storedRepo;
      _repoSaved = true;
    }

    setState(() {});
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _usernameController.dispose();
    _repoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Cloud Sync',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
            ),
          ),
          // Cloud Sync Buttons
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.cloud_upload),
                    label: const Text("Sync to Cloud"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      try {
                        await widget.api.syncToGitHub();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sync to Cloud complete!')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Sync to Cloud failed: $e')),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.cloud_download),
                    label: const Text("Sync from Cloud"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      try {
                        await widget.api.syncFromGitHub();
                        
                        // FIXED: Force UI refresh by navigating back to home
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        
                        // Small delay to ensure navigation completes
                        await Future.delayed(const Duration(milliseconds: 100));
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sync from Cloud complete! Data refreshed.')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Sync from Cloud failed: $e')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // GitHub Username Input
          Text(
            'GitHub Username',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter your GitHub username',
            ),
          ),

          const SizedBox(height: 24),

          // GitHub Repo Input
          Text(
            'GitHub Repository Name',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _repoController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter your GitHub repo name',
            ),
          ),

          const SizedBox(height: 24),

          // GitHub Token Input Section
          Text(
            'GitHub Token',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _tokenController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Enter your GitHub Personal Access Token',
              hintText: 'github_XXXXXXXXXXXXXXXXXXXX',
              suffixIcon: IconButton(
                icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
            obscureText: _obscureText,
            enableSuggestions: false,
            autocorrect: false,
          ),

          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: () async {
              final token = _tokenController.text.trim();
              final username = _usernameController.text.trim();
              final repo = _repoController.text.trim();

              if (token.isEmpty || username.isEmpty || repo.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill in all fields before saving.')),
                );
                return;
              }

              await widget.api.saveGitHubToken(token);
              await widget.api.saveGitHubUsername(username);
              await widget.api.saveGitHubRepo(repo);

              setState(() {
                _tokenSaved = true;
                _usernameSaved = true;
                _repoSaved = true;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings saved successfully!')),
              );
            },
            child: Text(_tokenSaved && _usernameSaved && _repoSaved ? 'Update Settings' : 'Save Settings'),
          ),

          const SizedBox(height: 8),

          if (_tokenSaved || _usernameSaved || _repoSaved)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () async {
                await widget.api.deleteGitHubToken();
                await widget.api.deleteGitHubUsername();
                await widget.api.deleteGitHubRepo();

                _tokenController.clear();
                _usernameController.clear();
                _repoController.clear();

                setState(() {
                  _tokenSaved = false;
                  _usernameSaved = false;
                  _repoSaved = false;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All GitHub settings deleted successfully.')),
                );
              },
              child: const Text('Delete All Settings'),
            ),
        ],
      ),
    );
  }
}
