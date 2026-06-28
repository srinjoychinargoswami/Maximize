# Maximize

A cross-platform offline-first productivity app for tasks, calendar, reminders, and notes with optional GitHub sync. Built with Flutter for Windows, Android, macOS, and Linux.

## Features

- **Tasks & Subtasks** — Create, prioritize, and track tasks with subtasks, due dates, and categories
- **Calendar** — Month, week, day, and list views with recurring events and reminders
- **Reminders** — Set reminders for tasks and events with push notifications
- **Notes** — Simple note-taking integrated into your workflow
- **GitHub Sync** — Optional cloud sync via GitHub API (no servers required)
- **Offline-First** — Works completely offline; sync is optional and user-controlled
- **Cross-Platform** — Single codebase running on Android, Windows, macOS, and Linux

## Technical Highlights

- **Framework:** Flutter / Dart
- **Local Database:** Drift ORM with SQLite
- **Notifications:** Platform-native push notifications (Android, Windows)
- **Sync:** Custom GitHub REST API integration (no external backend)
- **Architecture:** Service-based layer with clean separation of concerns

For detailed architecture documentation, see [ARCHITECTURE.md](docs/ARCHITECTURE.md).

## Installation

### macOS
1. Download `maximize-macos-x64.dmg` from [Releases](https://github.com/[srinjoychinargoswami]/maximize/releases)
2. Double-click the DMG to mount it
3. Drag the Maximize app to your Applications folder
4. Run from Applications

### Windows
1. Download `maximize-windows-x64.exe` from [Releases](https://github.com/[srinjoychinargoswami]/maximize/releases)
2. Run the executable (no installation required)
3. The app will launch immediately

### Android
1. Download `app-release-arm64-v8a.apk` (or `armeabi-v7a.apk` for older phones) from [Releases](https://github.com/[srinjoychinargoswami]/maximize/releases)
2. Enable "Unknown Sources" in Settings → Security
3. Open the downloaded APK file to install
4. Launch Maximize from your app drawer

**Note:** Google Play Store version coming soon; currently distributed via sideloading for portfolio and personal use.

### Linux
1. Download `maximize-linux-x64.tar.gz` from [Releases](https://github.com/[srinjoychinargoswami]/maximize/releases)
2. Extract: `tar -xzf maximize-linux-x64.tar.gz`
3. Run: `./maximize/maximize`

## Usage

### GitHub Sync Setup
1. Open Maximize → Sync tab
2. Generate a GitHub Personal Access Token:
   - Go to GitHub → Settings → Developer Settings → Personal Access Tokens
   - Create a new token with `repo` scope
   - Copy the token
3. Paste token in Maximize's Sync tab
4. Pull to refresh to sync your data

Your data is stored as JSON files in a GitHub repository of your choice. No backend servers, no tracking.

## Building from Source

### Prerequisites
- Flutter SDK (latest stable)
- Dart 3.0+

### Clone & Build
```bash
git clone https://github.com/[srinjoychinargoswami]/maximize.git
cd maximize
flutter pub get

# Run on your device/emulator
flutter run -d <device_id>

# Build release binaries
flutter build macos --release      # macOS
flutter build windows --release    # Windows
flutter build apk --release        # Android
flutter build linux --release      # Linux
```

See [ARCHITECTURE.md](docs/ARCHITECTURE.md) for database schema, data models, and sync implementation details.

## Known Limitations

- iOS not yet supported (Apple's sandbox restrictions on external app installation)
- Calendar search only works in list view
- Subtasks: drag-and-drop reordering coming soon

## Future Roadmap

- Offline LLM integration for AI-assisted task creation
- Operation-log based sync (replacing snapshot model)
- Rich text notes with formatting
- Calendar integrations (Google Calendar, Outlook)
- Team collaboration features

## License

This project is licensed under the Apache 2.0 LICENSE— see [LICENSE](LICENSE) file for details.

## Contributing

Contributions welcome! Feel free to open issues, suggest features, or submit PRs.

## Author

Built by Srinjoy Goswami as a personal productivity tool and portfolio project.

---

**Why Maximize?** Most productivity apps are bloated or cloud-first. Maximize is designed for people who want a unified, offline-first tool they can trust and extend.