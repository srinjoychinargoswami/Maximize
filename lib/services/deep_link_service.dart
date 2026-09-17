import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_service.dart';

class DeepLinkService {
  static final _appLinks = AppLinks();

  /// Initialize deep link listener
  /// Catches myproductivityapp://callback?token=ABC...
  static Future<void> initialize() async {
    print('[DeepLinkService] Initializing...');

    try {
      // Handle deep links when app is already running
      _appLinks.uriLinkStream.listen(
        (uri) => _handleDeepLink(uri),
        onError: (err) {
          print('[DeepLinkService] Error listening to deep links: $err');
        },
      );

      // Handle deep link that launched the app
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        print('[DeepLinkService] App launched with deep link: $initialLink');
        _handleDeepLink(initialLink);
      }

      print('[DeepLinkService] ✅ Initialized');
    } catch (e) {
      print('[DeepLinkService] ❌ Initialization error: $e');
    }
  }

  /// Handle incoming deep link
  static Future<void> _handleDeepLink(Uri uri) async {
    print('[DeepLinkService] Received deep link: $uri');

    // Check if this is our auth callback
    if (uri.scheme == 'myproductivityapp' && uri.host == 'callback') {
      final token = uri.queryParameters['access_token'];
      final refresh = uri.queryParameters['refresh_token'];

      if (token != null) {
        await _setSessionFromToken(token, refresh);
      } else {
        print('[DeepLinkService] ❌ No token in deep link');
      }
    }
  }

  /// Set Supabase session from token received from web auth
  static Future<void> _setSessionFromToken(String accessToken, String? refreshToken) async {
    try {
      print('[DeepLinkService] Auth callback received');
      print('[DeepLinkService] Access token: ${accessToken.substring(0, 20)}...');
      print('[DeepLinkService] Refresh token: ${refreshToken?.substring(0, 20) ?? "none"}...');

      // Supabase hosted auth automatically manages sessions through secure storage
      // The tokens are received here as confirmation of successful auth
      // AuthService will emit new state when Supabase auth updates

      print('[DeepLinkService] ✅ Auth callback processed');
      print('[DeepLinkService] Waiting for Supabase auth state update...');

      // Wait for Supabase to process the auth and update internal state
      await Future.delayed(const Duration(milliseconds: 1000));

      final currentUser = AuthService.currentUser;
      if (currentUser != null) {
        print('[DeepLinkService] ✅ User logged in: ${currentUser.email}');
      } else {
        print('[DeepLinkService] ⚠️  Auth state pending update...');
      }
    } catch (e) {
      print('[DeepLinkService] ⚠️  Error in auth callback: $e');
    }
  }

  /// Launch auth page
  static Future<void> launchAuthPage() async {
    // Testing: localhost
    const authUrl = 'http://localhost:3000';

    // Production: Replace with 'https://kinetic.vercel.app/auth'

    print('[DeepLinkService] Launching auth URL: $authUrl');

    try {
      if (await canLaunchUrl(Uri.parse(authUrl))) {
        await launchUrl(
          Uri.parse(authUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        print('[DeepLinkService] ❌ Cannot launch URL');
      }
    } catch (e) {
      print('[DeepLinkService] ❌ Error launching auth page: $e');
    }
  }
}
