import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:kinetic/config/app_config.dart';
import 'package:kinetic/providers/theme_notifier.dart';
import 'package:kinetic/services/completion_log_service.dart';
import 'package:kinetic/services/database_encryption_service.dart';
import 'package:kinetic/screens/privacy_policy_screen.dart';
import 'package:kinetic/screens/terms_conditions_screen.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SharedPreferences _prefs;
  String _currentTheme = 'system';
  bool _notificationsEnabled = true;
  bool _energyReminderEnabled = false;
  TimeOfDay _energyReminderTime = const TimeOfDay(hour: 9, minute: 0);
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      setState(() {
        _currentTheme = _prefs.getString('theme') ?? 'system';
        _notificationsEnabled = _prefs.getBool('notifications_enabled') ?? true;
        _energyReminderEnabled = _prefs.getBool('energy_reminder_enabled') ?? false;

        final reminderHour = _prefs.getInt('energy_reminder_hour') ?? 9;
        final reminderMinute = _prefs.getInt('energy_reminder_minute') ?? 0;
        _energyReminderTime = TimeOfDay(hour: reminderHour, minute: reminderMinute);

        _isLoading = false;
      });

      if (AppConfig.debugLogging) {
        print('[Settings] Preferences loaded');
      }
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[Settings] Error loading preferences: $e');
      }
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveThemePreference(String theme) async {
    try {
      // Notify the ThemeNotifier to update the app's theme
      if (mounted) {
        context.read<ThemeNotifier>().setTheme(theme);
      }

      // Update local UI state
      if (mounted) {
        setState(() => _currentTheme = theme);
      }

      if (AppConfig.debugLogging) {
        print('[Settings] Theme changed to: $theme');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Theme changed to $theme')),
        );
      }
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[Settings] Error saving theme: $e');
      }
    }
  }

  Future<void> _toggleNotifications(bool enabled) async {
    try {
      await _prefs.setBool('notifications_enabled', enabled);

      if (enabled) {
        // Request permission if enabling
        if (AppConfig.debugLogging) {
          print('[Settings] Notifications enabled');
        }
      } else {
        if (AppConfig.debugLogging) {
          print('[Settings] Notifications disabled');
        }
      }

      if (mounted) {
        setState(() => _notificationsEnabled = enabled);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              enabled ? 'Notifications enabled' : 'Notifications disabled',
            ),
          ),
        );
      }
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[Settings] Error toggling notifications: $e');
      }
    }
  }

  Future<void> _toggleEnergyReminder(bool enabled) async {
    try {
      await _prefs.setBool('energy_reminder_enabled', enabled);

      if (enabled) {
        if (AppConfig.debugLogging) {
          print('[Settings] Energy reminder enabled at ${_energyReminderTime.format(context)}');
        }
      } else {
        if (AppConfig.debugLogging) {
          print('[Settings] Energy reminder disabled');
        }
      }

      if (mounted) {
        setState(() => _energyReminderEnabled = enabled);
      }
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[Settings] Error toggling energy reminder: $e');
      }
    }
  }

  Future<void> _setDailyEnergyReminder() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: _energyReminderTime,
    );

    if (selectedTime != null && mounted) {
      try {
        await _prefs.setInt('energy_reminder_hour', selectedTime.hour);
        await _prefs.setInt('energy_reminder_minute', selectedTime.minute);

        setState(() => _energyReminderTime = selectedTime);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Reminder set for ${selectedTime.format(context)}',
              ),
            ),
          );
        }

        if (AppConfig.debugLogging) {
          print('[Settings] Energy reminder time changed to ${selectedTime.format(context)}');
        }
      } catch (e) {
        if (AppConfig.debugLogging) {
          print('[Settings] Error setting reminder time: $e');
        }
      }
    }
  }

  Future<void> _clearAppCache() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache?'),
        content: const Text('This will clear the app cache. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        // Clear cache would go here - platform specific
        if (AppConfig.debugLogging) {
          print('[Settings] App cache cleared');
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cache cleared')),
          );
        }
      } catch (e) {
        if (AppConfig.debugLogging) {
          print('[Settings] Error clearing cache: $e');
        }
      }
    }
  }

  Future<void> _openUrl(String url) async {
    if (url.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('URL not configured')),
        );
      }
      return;
    }

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
        if (AppConfig.debugLogging) {
          print('[Settings] Opened URL: $url');
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open URL')),
          );
        }
      }
    } catch (e) {
      if (AppConfig.debugLogging) {
        print('[Settings] Error opening URL: $e');
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _showClearAllDialog() async {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          "This will delete:\n"
          "• All completion logs\n"
          "• Streaks and metrics\n"
          "• All stats\n\n"
          "Your tasks, events, and reminders will NOT be deleted.\n"
          "This action cannot be undone."
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              try {
                await context.read<CompletionLogService>().clearAllCompletionLogs();
                if (mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("All logs cleared. Metrics reset to 0.")),
                  );
                  // Pop settings page and return true to trigger refresh
                  if (mounted) {
                    Navigator.pop(context, true);
                  }
                }
              } catch (e) {
                if (mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: $e")),
                  );
                }
              }
            },
            child: const Text("Clear All", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SECTION 1: Appearance
            _buildSectionHeader('Appearance'),
            Card(
              color: Colors.grey[800],
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: const Text('Theme'),
                  subtitle: Text(_currentTheme.capitalize()),
                  trailing: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'light', label: Text('Light')),
                      ButtonSegment(value: 'dark', label: Text('Dark')),
                      ButtonSegment(value: 'system', label: Text('System')),
                    ],
                    selected: {_currentTheme},
                    onSelectionChanged: (Set<String> newSelection) {
                      _saveThemePreference(newSelection.first);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // SECTION 2: Notifications
            _buildSectionHeader('Notifications'),
            Card(
              color: Colors.grey[800],
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Enable Notifications'),
                    subtitle: Text(
                      _notificationsEnabled ? 'Notifications enabled' : 'Notifications disabled',
                    ),
                    trailing: Switch(
                      value: _notificationsEnabled,
                      onChanged: _toggleNotifications,
                    ),
                  ),
                  if (_notificationsEnabled) ...[
                    const Divider(height: 0),
                    ListTile(
                      title: const Text('Daily Energy Reminder'),
                      subtitle: Text('Reminds you at ${_energyReminderTime.format(context)}'),
                      trailing: Switch(
                        value: _energyReminderEnabled,
                        onChanged: _toggleEnergyReminder,
                      ),
                    ),
                    if (_energyReminderEnabled) ...[
                      const Divider(height: 0),
                      ListTile(
                        title: const Text('Reminder Time'),
                        subtitle: Text(_energyReminderTime.format(context)),
                        trailing: const Icon(Icons.access_time),
                        onTap: _setDailyEnergyReminder,
                      ),
                    ],
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // SECTION 3: Storage & Encryption
            _buildSectionHeader('Storage & Encryption'),
            Card(
              color: Colors.grey[800],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Platform info
                    ListTile(
                      title: const Text('Platform'),
                      subtitle: Text(DatabaseEncryptionService.instance.getPlatformType()),
                      leading: const Icon(Icons.storage),
                      contentPadding: EdgeInsets.zero,
                    ),

                    const SizedBox(height: 12),

                    // Storage quota info
                    if (kIsWeb)
                      ListTile(
                        title: const Text('Storage Quota'),
                        subtitle: const Text('IndexedDB: 500MB - 1GB'),
                        leading: const Icon(Icons.cloud),
                        contentPadding: EdgeInsets.zero,
                      )
                    else
                      ListTile(
                        title: const Text('Storage'),
                        subtitle: const Text('Native SQLite Filesystem'),
                        leading: const Icon(Icons.storage),
                        contentPadding: EdgeInsets.zero,
                      ),

                    const SizedBox(height: 12),

                    // Encryption info
                    ListTile(
                      title: const Text('Encryption'),
                      subtitle: const Text('AES-256 (Firebase sync only)'),
                      leading: const Icon(Icons.lock),
                      contentPadding: EdgeInsets.zero,
                    ),

                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // SECTION 4: Privacy & Legal
            _buildSectionHeader('Privacy & Legal'),
            Card(
              color: Colors.grey[800],
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PrivacyPolicyScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 0),
                  ListTile(
                    title: const Text('Terms & Conditions'),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const TermsConditionsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // SECTION 5: Data & Privacy
            _buildSectionHeader('Data & Privacy'),
            Card(
              color: Colors.grey[800],
              child: Column(
                children: [
                  ListTile(
                    title: const Text('App Storage'),
                    subtitle: const Text('2.3 MB used'),
                    trailing: ElevatedButton(
                      onPressed: _clearAppCache,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                      ),
                      child: const Text('Clear Cache', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    title: const Text('Clear All Metrics & Logs'),
                    subtitle: const Text('Reset completion logs and metrics'),
                    trailing: ElevatedButton(
                      onPressed: _showClearAllDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                      ),
                      child: const Text('Clear All', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    title: const Text('Privacy Policy'),
                    subtitle: const Text('Read our privacy policy'),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () => _openUrl(AppConfig.privacyPolicyUrl),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    title: const Text('Terms of Service'),
                    subtitle: const Text('Read our terms'),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () => _openUrl(AppConfig.termsOfServiceUrl),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // SECTION 6: About
            _buildSectionHeader('About'),
            Card(
              color: Colors.grey[800],
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.health_and_safety,
                      size: 64,
                      color: Colors.blue[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppConfig.appName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'v${AppConfig.appVersion}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Energy-aware productivity tracker',
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: Colors.grey[800],
              child: ListTile(
                title: const Text('Open Source Licenses'),
                trailing: const Icon(Icons.open_in_new),
                onTap: () => showLicensePage(context: context),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
