import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SyncProvider { none, git, firebase }
enum ThemeModePref { system, light, dark }
enum CalendarView { month, week, day }
enum WeekStart { monday, sunday }
enum TimeFormat { h12, h24 }
enum FontSize { small, medium, large }

class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  final FlutterSecureStorage _secure = const FlutterSecureStorage();

  // ─── Keys ────────────────────────────────────────────────────
  // Sync
  static const _syncProviderKey       = 'sync_provider';
  // Git (provider-agnostic)
  static const _gitBaseUrlKey         = 'sync_git_base_url';
  static const _gitUsernameKey        = 'sync_git_username';
  static const _gitRepoKey            = 'sync_git_repo';
  static const _gitTokenKey           = 'sync_git_token';      // secure
  // Firebase
  static const _firebaseUidKey        = 'sync_firebase_uid';   // secure
  // Appearance
  static const _themeModeKey          = 'theme_mode';
  static const _accentColorKey        = 'accent_color';
  static const _fontSizeKey           = 'font_size';
  static const _compactModeKey        = 'compact_mode';
  // Calendar
  static const _calendarViewKey       = 'calendar_view';
  static const _weekStartKey          = 'week_start';
  static const _timeFormatKey         = 'time_format';
  static const _dateFormatKey         = 'date_format';
  // Notifications
  static const _notificationsKey      = 'notifications_enabled';
  static const _defaultReminderKey    = 'default_reminder_mins';
  static const _quietStartKey         = 'quiet_hours_start';
  static const _quietEndKey           = 'quiet_hours_end';

  // ─── SYNC PROVIDER ───────────────────────────────────────────
  Future<SyncProvider> getSyncProvider() async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getString(_syncProviderKey) ?? 'none';
    return SyncProvider.values.firstWhere(
      (e) => e.name == val,
      orElse: () => SyncProvider.none,
    );
  }

  Future<void> setSyncProvider(SyncProvider provider) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_syncProviderKey, provider.name);
  }

  // ─── GIT SYNC (works for GitHub, GitLab, Bitbucket, Gitea, any) ──
  // Base URL examples:
  //   GitHub:    https://api.github.com
  //   GitLab:    https://gitlab.com/api/v4
  //   Bitbucket: https://api.bitbucket.org/2.0
  //   Gitea:     https://yourgitea.com/api/v1
  //   Self-host: https://github.yourcompany.com/api/v3

  Future<String> getGitBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_gitBaseUrlKey) ?? 'https://api.github.com';
  }

  Future<void> setGitBaseUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_gitBaseUrlKey, url.trimRight().replaceAll(RegExp(r'/$'), ''));
  }

  Future<String> getGitUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_gitUsernameKey) ?? '';
  }

  Future<void> setGitUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_gitUsernameKey, username.trim());
  }

  Future<String> getGitRepo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_gitRepoKey) ?? '';
  }

  Future<void> setGitRepo(String repo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_gitRepoKey, repo.trim());
  }

  // Token stored in secure storage (encrypted on device)
  Future<String?> getGitToken() async {
    return await _secure.read(key: _gitTokenKey);
  }

  Future<void> setGitToken(String token) async {
    await _secure.write(key: _gitTokenKey, value: token.trim());
  }

  Future<void> deleteGitToken() async {
    await _secure.delete(key: _gitTokenKey);
  }

  // Detect provider from base URL for label display
  String detectProviderLabel(String baseUrl) {
    final url = baseUrl.toLowerCase();
    if (url.contains('github.com'))    return 'GitHub';
    if (url.contains('gitlab.com'))    return 'GitLab';
    if (url.contains('bitbucket.org')) return 'Bitbucket';
    return 'Git (Self-Hosted)';
  }

  // Build repo file URI from base URL + username + repo
  Future<Uri> buildGitFileUri(String fileName) async {
    final base     = await getGitBaseUrl();
    final username = await getGitUsername();
    final repo     = await getGitRepo();

    // GitHub / self-hosted GitHub enterprise
    if (base.contains('api.github.com') || base.contains('/api/v3')) {
      return Uri.parse('$base/repos/$username/$repo/contents/$fileName');
    }
    // GitLab (uses URL-encoded project path)
    if (base.contains('gitlab')) {
      final encoded = Uri.encodeComponent('$username/$repo');
      return Uri.parse('$base/projects/$encoded/repository/files/$fileName');
    }
    // Bitbucket
    if (base.contains('bitbucket')) {
      return Uri.parse('$base/repositories/$username/$repo/src/main/$fileName');
    }
    // Gitea / Forgejo
    return Uri.parse('$base/repos/$username/$repo/contents/$fileName');
  }

  // Clear all git credentials
  Future<void> clearGitCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_gitBaseUrlKey);
    await prefs.remove(_gitUsernameKey);
    await prefs.remove(_gitRepoKey);
    await _secure.delete(key: _gitTokenKey);
  }

  // ─── FIREBASE ────────────────────────────────────────────────
  Future<String?> getFirebaseUid() async {
    return await _secure.read(key: _firebaseUidKey);
  }

  Future<void> setFirebaseUid(String uid) async {
    await _secure.write(key: _firebaseUidKey, value: uid);
  }

  Future<void> clearFirebaseUid() async {
    await _secure.delete(key: _firebaseUidKey);
  }

  // ─── APPEARANCE ──────────────────────────────────────────────
  Future<ThemeModePref> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getString(_themeModeKey) ?? 'dark';
    return ThemeModePref.values.firstWhere(
      (e) => e.name == val,
      orElse: () => ThemeModePref.dark,
    );
  }

  Future<void> setThemeMode(ThemeModePref mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.name);
  }

  ThemeMode toFlutterThemeMode(ThemeModePref pref) {
    switch (pref) {
      case ThemeModePref.light:  return ThemeMode.light;
      case ThemeModePref.dark:   return ThemeMode.dark;
      case ThemeModePref.system: return ThemeMode.system;
    }
  }

  Future<Color> getAccentColor() async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getInt(_accentColorKey) ?? Colors.blue.value;
    return Color(val);
  }

  Future<void> setAccentColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_accentColorKey, color.value);
  }

  Future<FontSize> getFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getString(_fontSizeKey) ?? 'medium';
    return FontSize.values.firstWhere(
      (e) => e.name == val,
      orElse: () => FontSize.medium,
    );
  }

  Future<void> setFontSize(FontSize size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fontSizeKey, size.name);
  }

  double toFontScaleFactor(FontSize size) {
    switch (size) {
      case FontSize.small:  return 0.85;
      case FontSize.medium: return 1.0;
      case FontSize.large:  return 1.2;
    }
  }

  Future<bool> getCompactMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_compactModeKey) ?? false;
  }

  Future<void> setCompactMode(bool compact) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_compactModeKey, compact);
  }

  // ─── CALENDAR ────────────────────────────────────────────────
  Future<CalendarView> getCalendarView() async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getString(_calendarViewKey) ?? 'month';
    return CalendarView.values.firstWhere(
      (e) => e.name == val,
      orElse: () => CalendarView.month,
    );
  }

  Future<void> setCalendarView(CalendarView view) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_calendarViewKey, view.name);
  }

  Future<WeekStart> getWeekStart() async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getString(_weekStartKey) ?? 'monday';
    return WeekStart.values.firstWhere(
      (e) => e.name == val,
      orElse: () => WeekStart.monday,
    );
  }

  Future<void> setWeekStart(WeekStart day) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_weekStartKey, day.name);
  }

  Future<TimeFormat> getTimeFormat() async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getString(_timeFormatKey) ?? 'h12';
    return TimeFormat.values.firstWhere(
      (e) => e.name == val,
      orElse: () => TimeFormat.h12,
    );
  }

  Future<void> setTimeFormat(TimeFormat format) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_timeFormatKey, format.name);
  }

  Future<String> getDateFormat() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_dateFormatKey) ?? 'MMM dd, yyyy';
  }

  Future<void> setDateFormat(String format) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dateFormatKey, format);
  }

  // ─── NOTIFICATIONS ───────────────────────────────────────────
  Future<bool> getNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsKey) ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, enabled);
  }

  Future<int> getDefaultReminderMinutes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_defaultReminderKey) ?? 30;
  }

  Future<void> setDefaultReminderMinutes(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_defaultReminderKey, minutes);
  }

  Future<TimeOfDay?> getQuietStart() async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getString(_quietStartKey);
    if (val == null) return null;
    final parts = val.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Future<void> setQuietStart(TimeOfDay? time) async {
    final prefs = await SharedPreferences.getInstance();
    if (time == null) {
      await prefs.remove(_quietStartKey);
    } else {
      await prefs.setString(_quietStartKey, '${time.hour}:${time.minute}');
    }
  }

  Future<TimeOfDay?> getQuietEnd() async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getString(_quietEndKey);
    if (val == null) return null;
    final parts = val.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Future<void> setQuietEnd(TimeOfDay? time) async {
    final prefs = await SharedPreferences.getInstance();
    if (time == null) {
      await prefs.remove(_quietEndKey);
    } else {
      await prefs.setString(_quietEndKey, '${time.hour}:${time.minute}');
    }
  }

  // ─── NUCLEAR OPTION ──────────────────────────────────────────
  Future<void> clearAllSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _secure.deleteAll();
  }
}
