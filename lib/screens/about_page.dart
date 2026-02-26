// lib/screens/about_page.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; 
import 'dart:async'; 



class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About Maximize')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // App info
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue,
            child: Text('M', style: TextStyle(fontSize: 40, color: Colors.white)),
          ),
          SizedBox(height: 16),
          Text('Maximize v1.0.0', 
               style: Theme.of(context).textTheme.headlineSmall),
          Text('Tasks • Calendar • Reminders • Sync', 
               style: TextStyle(color: Colors.grey)),
          SizedBox(height: 24),

          // Auto Flutter licenses ✅
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Licenses'),
            subtitle: Text('All Flutter packages'),
            onTap: () => showLicensePage(
              context: context,
              applicationName: 'Maximize',
              applicationVersion: '1.0.0',
              applicationIcon: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text('M'),
              ),
            ),
          ),

          // Privacy
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Privacy Policy'),
            subtitle: Text('No tracking. GitHub sync optional.'),
            onTap: () => launchUrl(Uri.parse('https://your-github-repo/privacy.md')),
          ),

          // Contact
          ListTile(
            leading: Icon(Icons.email),
            title: Text('Contact'),
            subtitle: Text('support@maximize.app'),
            onTap: () => launchUrl(Uri.parse('mailto:support@maximize.app')),
          ),
        ],
      ),
    );
  }
}
