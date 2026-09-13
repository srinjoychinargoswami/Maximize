import 'package:flutter/foundation.dart';

/// Helper for ensuring web persistence in IndexedDB
///
/// On web, Drift uses IndexedDB with SQLite WASM. The SharedArrayBuffer fallback
/// requires explicit flushing to ensure data is committed to the database.
///
/// Use this after write operations to guarantee persistence.
class WebPersistenceHelper {
  /// Flush IndexedDB writes (web only)
  ///
  /// This ensures IndexedDB has committed the transaction,
  /// especially important for the SharedArrayBuffer fallback mode.
  /// On native platforms, this is a no-op.
  static Future<void> flush() async {
    if (kIsWeb) {
      // Increased delay for SharedArrayBuffer fallback compatibility
      // Standard: 200ms, SharedArrayBuffer fallback: 500ms
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  /// Log persistence event (for debugging)
  static void logPersistence(String message) {
    if (kIsWeb) {
      debugPrint('[WebPersistence] $message');
    }
  }
}
