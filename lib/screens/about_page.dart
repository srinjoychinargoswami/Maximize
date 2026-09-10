import 'package:flutter/material.dart';
import 'package:maximize/screens/privacy_policy_screen.dart';
import 'package:maximize/screens/terms_conditions_screen.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Maximize'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Header
            Center(
              child: Column(
                children: [
                  const Icon(Icons.task_alt, size: 64, color: Colors.blue),
                  const SizedBox(height: 16),
                  const Text(
                    'Maximize',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // About Description
            const Text(
              'About Maximize',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Maximize is a cross-platform productivity app that combines task management, calendar, reminders, and energy tracking in one unified application.',
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),

            // Features Section
            const Text(
              'Features',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildFeatureItem('✓ Task Management', 'Create, organize, and track tasks with priorities and categories'),
            _buildFeatureItem('✓ Calendar', 'Month, week, day, and list views for event management'),
            _buildFeatureItem('✓ Reminders', 'Set reminders with notifications across all platforms'),
            _buildFeatureItem('✓ Energy Tracking', 'Monitor your energy levels and correlate with productivity'),
            _buildFeatureItem('✓ Analytics', '11+ metrics and 4 chart types for insights'),
            _buildFeatureItem('✓ Notes', 'Quick capture and organized note-taking'),
            _buildFeatureItem('✓ Cross-Device Sync', 'Sync your data securely across Android, iOS, macOS, Windows, Linux, and Web'),
            _buildFeatureItem('✓ AES-256 Encryption', 'Your data is encrypted before syncing to the cloud'),
            _buildFeatureItem('✓ Offline-First', 'Full functionality works without internet connection'),
            const SizedBox(height: 24),

            // Platforms Section
            const Text(
              'Supported Platforms',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildPlatformChip('Android'),
                _buildPlatformChip('iOS'),
                _buildPlatformChip('macOS'),
                _buildPlatformChip('Windows'),
                _buildPlatformChip('Linux'),
                _buildPlatformChip('Web'),
              ],
            ),
            const SizedBox(height: 24),

            // Privacy & Legal Section
            const Text(
              'Privacy & Legal',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.arrow_forward),
              contentPadding: EdgeInsets.zero,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Terms & Conditions'),
              trailing: const Icon(Icons.arrow_forward),
              contentPadding: EdgeInsets.zero,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TermsConditionsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Licenses Section
            const Text(
              'Licenses',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showLicensePage(context: context);
                },
                child: const Text('View Dependencies & Licenses'),
              ),
            ),
            const SizedBox(height: 24),

            // Footer
            const Divider(),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                '© 2026 Maximize. All rights reserved.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformChip(String platform) {
    return Chip(
      label: Text(platform),
      backgroundColor: Colors.blue.withValues(alpha: 0.2),
      labelStyle: const TextStyle(color: Colors.blue),
    );
  }
}
