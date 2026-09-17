import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final _supabase = Supabase.instance.client;

  // Check if user is logged in
  static User? get currentUser => _supabase.auth.currentUser;

  static Stream<AuthState> authStateChanges() =>
    _supabase.auth.onAuthStateChange;

  /// Sign up with email + password
  /// Returns: user object or throws exception
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Log in with email + password
  static Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Log out
  static Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  /// Request password reset (sends email)
  static Future<void> resetPassword({
    required String email,
  }) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  /// Update password (user calls this AFTER clicking reset link)
  /// Note: In web flow, this is called after user submits new password on reset page
  static Future<void> updatePassword({
    required String newPassword,
  }) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Get current user session
  static Future<Session?> getCurrentSession() async {
    try {
      return _supabase.auth.currentSession;
    } catch (e) {
      rethrow;
    }
  }
}
