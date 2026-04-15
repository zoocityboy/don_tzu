# AGENTS.md - Developer Guide for art_of_deal_war

Agentic coding guide for this Flutter repository.

## Project Overview

- **Type**: Flutter mobile app (parody with satirical quotes)
- **Framework**: Flutter 3.38.6 / Dart 3.10.7
- **State Management**: flutter_bloc
- **DI**: get_it | **Storage**: hive_ce

## Build Commands

```bash
# Run app
flutter run
flutter run -d <device_id>

# Linting & Type checking
flutter analyze                # Run static analysis (this is the main check)
flutter analyze --fix          # Auto-fix some issues

# Testing
flutter test                   # Run all tests
flutter test test/widget_test.dart

# Building
flutter build apk              # Debug APK
flutter build apk --release    # Release APK
flutter build web             # Web app

# Code generation (Hive adapters)
flutter pub run build_runner build --delete-conflicting-outputs
```

## Critical Warnings

⚠️ **SDK version constraints**: This project uses Dart 3.10.7. Some packages require newer SDK (e.g., `edge_tts` needs 3.10.8+). Check pubspec before adding packages.

⚠️ **Asset directories**: Every path in pubspec.yaml `assets:` must exist. Unused paths cause warnings. Current valid paths: `en`, `de`, `hu`, `pl`, `sk`, `ja`, `zh`.

⚠️ **analysis_options.yaml**: Do NOT use `include: package:flutter_lints/flutter.yaml` - it won't resolve. Use explicit rules or leave empty.

## Architecture

```
lib/
├── core/
│   ├── services/           # AppLogger, ErrorService, DataService
│   ├── theme/              # Theme config
│   └── widgets/            # Global widgets
├── features/
│   ├── manuscript/         # Main content feature
│   │   ├── data/           # Models, datasources, repo impl
│   │   ├── domain/         # Entities, repository interfaces
│   │   └── presentation/   # BLoC, pages, widgets
│   └── settings/           # Settings, TTS, audio
├── injection_container.dart
└── main.dart
```

## Key Services

- **DataService** (`lib/core/services/data_service.dart`): GitHub-based data download. Downloads from `https://raw.githubusercontent.com/zoocityboy/art-of-deal-war-data/main/data/`. Falls back to local assets in `assets/data/<lang>/quotes.json`.

- **TTS**: Uses `flutter_tts` package. Entry point: `lib/features/settings/presentation/cubit/tts_cubit.dart`.

## Supported Languages

UI: `en`, `cs`, `de`, `hu`, `pl`, `sk`, `ja`, `zh`  
Content: `en`, `de`, `hu`, `pl`, `sk`, `ja`, `zh` (cs/ was removed - no data)

## Code Style

- Use `AppLogger` from `core/services/app_logger.dart` instead of `print()`
- Import order: external packages first, then relative imports
- Prefer `const` constructors, avoid `dynamic`

## Testing

- Tests in `test/` directory
- Run: `flutter test --coverage`

## Notes

- No PocketBase - data comes from GitHub releases
- Uses `release-please` for versioning (conventional commits)
- CI: GitHub Actions (pull_request.yml, release.yml)