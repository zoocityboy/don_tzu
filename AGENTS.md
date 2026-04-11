# AGENTS.md - Developer Guide for art_of_deal_war

Agentic coding guide for this Flutter repository.

## Project Overview

- **Type**: Flutter mobile app (parody with satirical quotes)
- **Framework**: Flutter 3.41.5 / Dart 3.11.3
- **State Management**: flutter_bloc
- **DI**: get_it | **Storage**: hive_ce

## Build / Lint / Test Commands

```bash
# Run app
flutter run                    # Run on connected device/emulator
flutter run -d <device_id>     # Run on specific device

# Linting
flutter analyze                # Run static analysis
flutter analyze --no-fatal-warnings  # Warnings don't fail build
flutter analyze --fix          # Auto-fix some issues

# Testing
flutter test                              # Run all tests
flutter test test/widget_test.dart       # Run single test file
flutter test --reporter compact          # Compact output format
flutter test --name "test_name"           # Run tests matching pattern

# Building
flutter build apk           # Debug APK
flutter build apk --release # Release APK
flutter build ios          # iOS app
flutter build web          # Web app

# Code generation
flutter pub run build_runner build --delete-conflicting-outputs  # Generate Hive adapters

# Other
flutter doctor   # Check Flutter setup
flutter clean   # Clean build artifacts
```

---

## Code Style Guidelines

### Analysis Configuration

Uses `package:flutter_lints` (`analysis_options.yaml`). Key rules:
- Avoid `print()` in production - use `debugPrint()` instead
- Prefer single quotes for strings
- Use `const` constructors where possible

### Import Ordering

1. **Package imports** (external packages):
   ```dart
   import 'package:flutter/material.dart';
   import 'package:flutter_bloc/flutter_bloc.dart';
   import 'package:get_it/get_it.dart';
   ```
2. **Relative imports** (internal modules):
   ```dart
   import 'core/theme/app_theme.dart';
   import 'features/manuscript/presentation/bloc/manuscript_bloc.dart';
   ```

### Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| Classes | PascalCase | `ManuscriptBloc` |
| Files | snake_case | `manuscript_bloc.dart` |
| Functions/Variables | camelCase | `getManuscriptPages` |
| Constants | camelCase + `k` prefix | `kMaxItems` |
| Private members | prefix `_` | `_repository` |

### Type Annotations

- **Always** specify return types on functions
- **Always** specify types for class fields
- Use `var` only when type is obvious from assignment

```dart
Future<void> loadPages() async { }     // ✅ Good
final ManuscriptRepository _repository; // ✅ Good
final pages = await getPages();        // OK - type is clear
```

### Dart Rules

- Prefer `const` constructors
- Avoid `dynamic` - use proper types
- Use null safety: prefer `?` and defaults over `!`

### Error Handling

```dart
try {
  final pages = await _repository.getManuscriptPages();
  emit(ManuscriptLoaded(pages: pages));
} catch (e) {
  debugPrint('Error loading pages: $e');
  emit(ManuscriptError(e.toString()));
}
```
- Don't expose raw exceptions to users
- Always log errors with debugPrint

### Widgets

- Extract reusable widgets into separate files
- Use `const` for stateless widget constructors
- Prefer composition over inheritance

---

## Architecture

```
lib/
├── core/theme/              # Theme config
├── features/
│   └── manuscript/
│       ├── data/            # Models, datasources, repo impl
│       ├── domain/          # Entities, repository interfaces
│       └── presentation/   # BLoC, pages, widgets
├── injection_container.dart # DI setup
└── main.dart                # Entry point
```

**Layers**: Domain (pure Dart) → Data (Hive/API) → Presentation (Flutter widgets, BLoC)

---

## Testing

- Tests in `test/` directory
- Naming: `<feature>_test.dart`
- Use `flutter_test` package

```dart
void main() {
  group('ManuscriptBloc', () {
    test('initial state is ManuscriptInitial', () {
      expect(bloc.state, equals(const ManuscriptInitial()));
    });
  });
}
```

---

## Key Dependencies

| Package | Purpose |
|---------|---------|
| flutter_bloc | State management |
| get_it | Dependency injection |
| hive_ce | Local storage |
| equatable | Value equality |
| google_fonts | Typography |

---

## Notes for Agents

- This is a Flutter/Dart project, not JavaScript/TypeScript
- Follow clean architecture in `lib/features/`
- Always run `flutter analyze` before committing
- Use `flutter test` to verify changes