import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/deep_link_service.dart';
import 'home_page.dart';

class AuthCheckWrapper extends StatelessWidget {
  const AuthCheckWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService.authStateChanges(),
      builder: (context, snapshot) {
        // Checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // User is logged in → show app
        if (AuthService.currentUser != null) {
          print('[AuthCheckWrapper] User logged in: ${AuthService.currentUser?.email}');
          return const MyHomePage();
        }

        // User NOT logged in → show launch auth button
        print('[AuthCheckWrapper] User not logged in, showing auth button');
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Kinetic',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    DeepLinkService.launchAuthPage();
                  },
                  icon: const Icon(Icons.login),
                  label: const Text('Log In / Sign Up'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
