import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terms & Conditions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            const Text(
              'Last Updated: September 2026',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            _buildSection(
              '1. Acceptance of Terms',
              'By downloading, installing, and using Maximize, you agree to these Terms & Conditions. If you do not agree, do not use the application.',
            ),

            _buildSection(
              '2. License Grant',
              'Maximize is open-source software licensed under the Apache 2.0 License. You are granted a non-exclusive, worldwide license to use, modify, and distribute this software in accordance with the license terms.',
            ),

            _buildSection(
              '3. User Responsibilities',
              'You agree to:\n\n'
              '• Use Maximize only for lawful purposes\n'
              '• Not reverse-engineer or attempt to breach security features\n'
              '• Not use the app to store illegal or harmful content\n'
              '• Maintain the confidentiality of your device access\n'
              '• Back up your data regularly',
            ),

            _buildSection(
              '4. Limitation of Liability',
              'Maximize is provided "as is" without warranty of any kind. In no event shall we be liable for:\n\n'
              '• Data loss or corruption\n'
              '• Lost productivity\n'
              '• Any indirect, incidental, or consequential damages\n'
              '• Service interruptions',
            ),

            _buildSection(
              '5. Disclaimer of Warranties',
              'We make no warranties, express or implied, regarding:\n\n'
              '• Accuracy or completeness of data\n'
              '• Uninterrupted service availability\n'
              '• Freedom from errors or bugs\n'
              '• Fitness for a particular purpose',
            ),

            _buildSection(
              '6. Firebase & Third-Party Services',
              'Maximize uses Firebase for optional sync features. By enabling sync, you agree to:\n\n'
              '• Firebase\'s Terms of Service\n'
              '• Google\'s Privacy Policy\n'
              '• Storage of encrypted data on Firebase servers\n'
              '• Platform-specific logging for sync operations',
            ),

            _buildSection(
              '7. Data Backup',
              'You are responsible for backing up your data. We are not liable for data loss. Use the Firebase sync feature to maintain backups across devices.',
            ),

            _buildSection(
              '8. Modifications to Terms',
              'We may update these Terms & Conditions at any time. Continued use of Maximize after updates constitutes acceptance of new terms.',
            ),

            _buildSection(
              '9. Termination',
              'Your right to use Maximize terminates automatically if you breach these terms. Upon termination:\n\n'
              '• Delete all copies of the application\n'
              '• Cease all use of Maximize\n'
              '• Your local data is permanently deleted upon uninstall',
            ),

            _buildSection(
              '10. Governing Law',
              'These Terms & Conditions are governed by and construed in accordance with the laws of the United States, and you irrevocably submit to the exclusive jurisdiction of the courts in that location.',
            ),

            _buildSection(
              '11. Contact Us',
              'If you have questions about these Terms & Conditions, please contact us at:\n\n'
              'Email: legal@maximize.app\n'
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
            fontSize: 16,
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
        const SizedBox(height: 20),
      ],
    );
  }
}
