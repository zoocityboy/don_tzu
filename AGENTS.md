# AGENTS.md - Developer Guide for art_of_deal_war

This file provides essential information for agentic coding agents operating in this repository.

## Project Overview

- **Name**: art_of_deal_war (The Art of Deal War)
- **Type**: Flutter mobile application
- **Core Functionality**: A parody app with satirical quotes from "The Art of Deal War"
- **Framework**: Flutter 3.41.5 / Dart 3.11.3
- **State Management**: flutter_bloc
- **Dependency Injection**: get_it
- **Local Storage**: hive_ce

## Build / Lint / Test Commands

### Development
```bash
flutter run                    # Run app on connected device/emulator
flutter run -d <device_id>   # Run on specific device
```

### Linting (Static Analysis)
```bash
flutter analyze             # Run static analysis (runs dart analyze)
flutter analyze --no-fatal-warnings  # Warnings don't fail build
flutter analyze --fix        # Auto-fix some issues
```

### Testing
```bash
flutter test                 # Run all tests
flutter test test/widget_test.dart     # Run single test file
flutter test --reporter compact       # Compact output format
flutter test --name "test_name"        # Run tests matching pattern
```

### Building
```bash
flutter build apk           # Build debug APK
flutter build apk --release  # Build release APK
flutter build ios          # Build iOS app
flutter build web         # Build web app
```

### Code Generation
```bash
flutter pub run build_runner build --delete-conflicting-outputs  # Generate Hive adapters
```

### Other
```bash
flutter doctor             # Check Flutter setup
flutter clean            # Clean build artifacts
```

---

## Code Style Guidelines

### Analysis Configuration

This project uses `package:flutter_lints` (see `analysis_options.yaml`). Key rules:
- Avoid `print()` statements in production code
- Prefer single quotes for strings
- Use `const` constructors where possible

### Import Ordering

Order imports as follows (grouped by blank lines):

1. **Package imports** (external packages):
   ```dart
   import 'package:flutter/material.dart';
   import 'package:flutter_bloc/flutter_bloc.dart';
   import 'package:get_it/get_it.dart';
   ```

2. **Relative imports** (internal project modules):
   ```dart
   import 'core/theme/app_theme.dart';
   import 'core/theme/theme_provider.dart';
   import 'features/manuscript/presentation/bloc/manuscript_bloc.dart';
   ```

- Use `package:` imports for external dependencies
- Use relative imports (`package:...` or relative paths) for internal modules

### Naming Conventions

| Element | Convention | Example |
|--------|------------|---------|
| Classes | PascalCase | `ManuscriptBloc`, `AppTheme` |
| Files | snake_case | `manuscript_bloc.dart`, `app_theme.dart` |
| Functions/Variables | camelCase | `getManuscriptPages`, `isLiked` |
| Constants | camelCase with `k` prefix | `kMaxItems` |
| Private members | prefix with `_` | `_repository`, `_onLoadPages` |

### Type Annotations

- **Always** specify return types on functions:
  ```dart
  Future<void> loadPages() async { }  // ✅ Good
  Future loadPages() async { }          // ❌ Avoid
  ```

- **Always** specify types for class fields:
  ```dart
  final ManuscriptRepository _repository;  // ✅ Good
  final repository;                    // ❌ Avoid
  ```

- Use `var` only when type is obvious from assignment:
  ```dart
  final pages = await _repository.getPages();  // OK - type is clear
  List<ManuscriptPage> pages = [];           // Required - type not obvious
  ```

### Dart Language Rules

- **Prefer** `const` constructors:
  ```dart
  const ManuscriptInitial()  // ✅ Good
  ManuscriptInitial()        // ❌ Avoid
  ```

- **Avoid** `dynamic` - use proper types instead

- Use **null safety** - prefer `?` and default values over `!`:
  ```dart
  final String? title;  // ✅ Good - explicitly nullable
  final String title = '';  // ✅ Good - with default
  ```

### Error Handling

Use try-catch in async methods, emit error states:

```dart
try {
  final pages = await _repository.getManuscriptPages();
  emit(ManuscriptLoaded(pages: pages));
} catch (e) {
  emit(ManuscriptError(e.toString()));
}
```

- **Don't** expose raw exceptions to users - convert to user-friendly messages
- **Don't** silently swallow errors without logging:
  ```dart
  } catch (e) {
    debugPrint('Error loading pages: $e');  // ✅ Always log
  }
  ```

### Widgets

- Extract reusable widgets into separate files
- Use `const` for stateless widget constructors
- Prefer composition over inheritance
- Use `late` only when initialization is guaranteed before use

### Documentation

- Document public APIs with dartdoc (`///` comments)
- Keep comments current - outdated comments are worse than none

---

## Architecture

```
lib/
├── core/
│   └── theme/              # Theme configuration
├── features/
│   └── manuscript/
│       ├── data/           # Data layer (models, datasources, repos impl)
│       ├── domain/         # Domain layer (entities, repository interfaces)
│       └── presentation/   # UI layer (bloc, pages, widgets)
├── injection_container.dart # Dependency injection setup
└── main.dart             # App entry point
```

### Layer Responsibilities

- **Domain**: Pure Dart, no Flutter dependencies. Defines entities and repository interfaces.
- **Data**: Implements repositories, handles data sources (Hive, API)
- **Presentation**: Flutter widgets, BLoC state management, UI logic

### Dependency Injection

Uses `get_it` in `injection_container.dart`:

```dart
getIt.registerLazySingleton<ManuscriptRepository>(
  () => ManuscriptRepositoryImpl(getIt<ManuscriptLocalDataSource>()),
);
```

Access in widgets: `di.getIt<ManuscriptBloc>()`

---

## Testing Guidelines

- Tests go in `test/` directory
- Place tests next to the code they test when possible
- Use `flutter_test` package
- Follow naming: `<feature>_test.dart`

Example test structure:
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

## Common Patterns

### BLoC Pattern

Events → BLoC → States (see `lib/features/manuscript/presentation/bloc/`)

```dart
class ManuscriptBloc extends Bloc<ManuscriptEvent, ManuscriptState> {
  final ManuscriptRepository _repository;

  ManuscriptBloc(this._repository) : super(const ManuscriptInitial()) {
    on<LoadManuscriptPages>(_onLoadManuscriptPages);
  }
}
```

### Repository Pattern

```dart
abstract class ManuscriptRepository {
  Future<List<ManuscriptPage>> getManuscriptPages();
  Future<void> toggleLike(String pageId);
}
```

### Entity with Equatable

```dart
class ManuscriptPage extends Equatable {
  final String id;
  final String title;
  final bool isLiked;

  ManuscriptPage copyWith({ bool? isLiked }) {
    return ManuscriptPage(
      id: id,
      title: title,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
```

---

## Key Dependencies

| Package | Version | Purpose |
|--------|---------|---------|
| flutter_bloc | ^9.1.0 | State management |
| get_it | ^8.0.3 | Dependency injection |
| hive_ce | ^2.10.1 | Local storage |
| provider | ^6.1.2 | Theme provider |
| equatable | ^2.0.7 | Value equality |
| google_fonts | ^6.2.1 | Typography |

---

## Notes for Agents

- This is a Flutter project, not JavaScript/TypeScript
- Use `dart:async` for async utilities
- Follow the layer structure in `lib/features/`
- Always run `flutter analyze` before committing
- Use `flutter test` to verify changes
- When adding new features, follow clean architecture separation