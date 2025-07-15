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
  bool _tokenSaved = false;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final storedToken = await widget.api.getStoredToken(); // <-- Use public getter here
    if (storedToken != null) {
      _tokenController.text = storedToken;
      setState(() {
        _tokenSaved = true;
      });
    }
  }

  @override
  void dispose() {
    _tokenController.dispose();
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sync from Cloud complete!')),
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

          // GitHub Token Input Section
          Text(
            'GitHub Token',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _tokenController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter your GitHub Personal Access Token',
              hintText: 'ghp_XXXXXXXXXXXXXXXXXXXX',
            ),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              final token = _tokenController.text.trim();
              if (token.isNotEmpty) {
                await widget.api.saveGitHubToken(token);
                setState(() {
                  _tokenSaved = true;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Token saved successfully!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid token.')),
                );
              }
            },
            child: Text(_tokenSaved ? 'Update Token' : 'Save Token'),
          ),

          const SizedBox(height: 8),

          if (_tokenSaved)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () async {
                await widget.api.deleteGitHubToken();
                _tokenController.clear();
                setState(() {
                  _tokenSaved = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Token deleted successfully.')),
                );
              },
              child: const Text('Delete Token'),
            ),
        ],
      ),
    );
  }
}
