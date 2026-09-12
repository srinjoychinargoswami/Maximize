import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            const Text(
              'Last Updated: September 2026',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            _buildSection(
              'Introduction',
              'Kinetic ("we", "our", or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and otherwise handle your information when you use our mobile and web application.',
            ),

            _buildSection(
              'Information We Collect',
              'When you use Kinetic, we collect the following types of information:\n\n'
              '• Data you enter: Tasks, events, reminders, notes, and energy tracking entries\n'
              '• Usage data: App interactions, features used (collected locally only)\n'
              '• Device information: Device type, platform (Android/iOS/macOS/Windows/Linux/Web)\n'
              '• Encryption metadata: Platform identifier and sync timestamps',
            ),

            _buildSection(
              'How We Use Your Information',
              'We use your information to:\n\n'
              '• Enable app functionality (storing and retrieving your data)\n'
              '• Improve the app through usage analytics\n'
              '• Provide customer support\n'
              '• Comply with legal obligations',
            ),

            _buildSection(
              'Data Storage & Security',
              'Your data is stored locally on your device in an encrypted database.\n\n'
              '• Web (Chrome/Safari): Data stored in browser IndexedDB (500MB-1GB)\n'
              '• Mobile (Android/iOS): Data stored in device SQLite database\n'
              '• Desktop (macOS/Windows/Linux): Data stored in native SQLite database\n\n'
              'When you sync with Firebase, your data is encrypted with AES-256 encryption before transmission and storage.',
            ),

            _buildSection(
              'Firebase Sync',
              'Kinetic offers optional Firebase sync to synchronize your data across devices. When you enable sync:\n\n'
              '• Your data is encrypted with AES-256 before upload\n'
              '• Encrypted data is stored in Firebase Realtime Database\n'
              '• Platform information (device type) is logged with sync timestamps\n'
              '• You can disable sync at any time',
            ),

            _buildSection(
              'Third-Party Services',
              'Kinetic uses the following third-party services:\n\n'
              '• Firebase (Google): Cloud sync and data storage\n'
              '• Flutter: Mobile and web framework\n'
              '• SQLite: Local database engine',
            ),

            _buildSection(
              'Your Rights',
              'You have the right to:\n\n'
              '• Access your data at any time\n'
              '• Export your data (via sync)\n'
              '• Delete your data (local deletion is your control)\n'
              '• Disable sync features\n'
              '• Contact us with privacy questions',
            ),

            _buildSection(
              'Data Retention',
              'Your data is retained locally on your device as long as you use the app. If you uninstall Kinetic:\n\n'
              '• Local data is permanently deleted\n'
              '• Cloud data persists in Firebase until you manually delete your account',
            ),

            _buildSection(
              'Contact Us',
              'If you have questions about this Privacy Policy, please contact us at:\n\n'
              'Email: privacy@kinetic.app\n'
              'GitHub: github.com/srinjoychinargoswami/Maximize',
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
