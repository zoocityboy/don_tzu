# Coding Conventions

**Analysis Date:** 2026-04-11

## Overview

This Flutter project follows specific naming, import, and style conventions. The codebase uses `very_good_analysis` as the base for linting rules, though many rules have been selectively disabled to allow more flexibility.

---

## Naming Patterns

### Files

- **Pattern**: snake_case
- **Examples**:
  - `manuscript_bloc.dart`
  - `audio_service.dart`
  - `app_theme.dart`
  - `manuscript_page_model.dart`

### Classes and Types

- **Pattern**: PascalCase
- **Examples**:
  - `ManuscriptBloc` - BLoC state management
  - `AudioService` - Service class
  - `AppTheme` - Theme configuration
  - `ManuscriptPage` - Domain entity
  - `ManuscriptPageModel` - Hive data model

### Functions and Variables

- **Pattern**: camelCase
- **Examples**:
  - `getIt` - GetIt instance for DI
  - `playBackgroundMusic()` - Service method
  - `isMuted` - Boolean field
  - `setupDependencies()` - Function name

### Constants

- **Pattern**: camelCase with `_` prefix for private constants
- **Examples**:
  - `_intro` (private constant in `lib/core/router/app_router.dart`)
  - `_home` (private constant in `lib/core/router/app_router.dart`)
  - `kMaxItems` pattern exists per AGENTS.md guidelines

### Private Members

- **Pattern**: prefix with underscore (`_`)
- **Examples**:
  - `_repository` - private field in `ManuscriptBloc`
  - `_l10n` - private field in `ManuscriptBloc`
  - `_player` - private AudioPlayer instance in `AudioService`
  - `_instance` - singleton instance in `AudioService`

---

## Import Organization

### Current Practice

The codebase uses a mixed approach:

1. **Package imports** (external packages):
   ```dart
   import 'package:flutter/material.dart';
   import 'package:flutter_bloc/flutter_bloc.dart';
   import 'package:get_it/get_it.dart';
   import 'package:hive_ce_flutter/hive_ce_flutter.dart';
   import 'package:go_router/go_router.dart';
   ```

2. **Relative imports** (internal modules):
   ```dart
   import 'core/theme/app_theme.dart';
   import 'core/router/app_router.dart';
   import 'core/services/tts_service.dart';
   import 'features/manuscript/data/datasources/manuscript_local_datasource.dart';
   ```

### Import Order in Files

Example from `lib/main.dart`:
```dart
import 'package:art_of_deal_war/features/manuscript/l10n/generated/manuscript_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:art_of_deal_war/core/router/app_router.dart';
import 'package:art_of_deal_war/core/theme/app_theme.dart';
import 'package:art_of_deal_war/core/theme/theme_cubit.dart';
import 'package:art_of_deal_war/injection_container.dart' as di;
import 'package:art_of_deal_war/l10n/generated/app_localizations.dart';
```

Note: The `directives_ordering` rule is disabled in `analysis_options.yaml`, so import order is not strictly enforced.

---

## Code Style

### Analysis Configuration

The project uses `package:flutter_lints` via `very_good_analysis` (`analysis_options.yaml`):

```yaml
include: package:very_good_analysis/analysis_options.yaml

analyzer:
  errors:
    invalid_annotation_target: ignore
  exclude:
    - lib/generated/**
  language:
    strict-casts: false
    strict-raw-types: false
```

### Disabled Linter Rules

The following rules are explicitly disabled, meaning developers have flexibility:

- `public_member_api_docs: false` - No requirement for documentation comments
- `always_put_required_named_parameters_first: false` - Flexible parameter ordering
- `sort_constructors_first: false` - No constructor sorting requirement
- `prefer_if_elements_to_conditional_expressions: false` - Flexible conditional style
- `cascade_invocations: false` - No cascade requirement
- `prefer_const_constructors: false` - Const is optional
- `omit_local_variable_types: false` - Type annotations required
- `unnecessary_lambdas: false` - Lambda flexibility
- `discarded_futures: false` - Async handling flexibility
- `avoid_redundant_argument_values: false` - Argument flexibility
- `prefer_int_literals: false` - Literal flexibility
- `lines_longer_than_80_chars: false` - Line length not enforced
- `directives_ordering: false` - Import order not enforced
- `always_use_package_imports: false` - Relative imports allowed
- `unreachable_from_main: false` - No dead code enforcement
- `unawaited_futures: false` - Async handling flexibility
- `simplify_variable_pattern: false` - Variable pattern flexibility
- `leading_newlines_in_multiline_strings: false` - String formatting flexibility
- `use_colored_box: false` - No ColoredBox requirement
- `avoid_escaping_inner_quotes: false` - Quote flexibility

### Key Style Guidelines (from AGENTS.md)

- **Avoid `print()`** - Use `debugPrint()` instead for logging
- **Prefer single quotes** for strings
- **Use `const` constructors** where possible
- **Always specify return types** on functions
- **Always specify types** for class fields
- **Avoid `dynamic`** - use proper types
- **Use null safety** - prefer `?` and defaults over `!`

---

## Error Handling Patterns

### Pattern 1: Try-Catch with State Emission

Used in `lib/features/manuscript/presentation/bloc/manuscript_bloc.dart`:

```dart
Future<void> _onLoadManuscriptPages(
  LoadManuscriptPages event,
  Emitter<ManuscriptState> emit,
) async {
  emit(const ManuscriptLoading());
  try {
    final pages = await _repository.getManuscriptPages(_l10n);
    final chapters = _dataSource.getChaptersForTts(_l10n);
    await _ttsService.initWithChapters(chapters);
    emit(ManuscriptLoaded(pages: pages));
  } on Exception catch (e) {
    emit(ManuscriptError(e.toString()));
  }
}
```

**Key points:**
- Emit loading state before async operation
- Catch generic `Exception` type
- Emit error state with message
- Use `e.toString()` for error message

### Pattern 2: Try-Catch with Debug Print

Used in `lib/main.dart` and `lib/core/services/audio_service.dart`:

```dart
Future<void> clearCache() async {
  try {
    await Hive.deleteFromDisk();
    debugPrint('Cache cleared successfully');
  } on Exception catch (e) {
    debugPrint('Error clearing cache: $e');
  }
}

Future<void> playBackgroundMusic() async {
  if (_isMuted) return;
  try {
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setVolume(0.2);
    await _player.play(AssetSource('sound/walen-lonely-samurai.mp3'));
    debugPrint('Background music started');
  } on Exception catch (e) {
    debugPrint('Error playing audio: $e');
  }
}
```

**Key points:**
- Use `debugPrint()` instead of `print()`
- No state emission for non-critical failures
- Graceful degradation (silently fail)

### Pattern 3: Silent Failure

Used in `lib/features/manuscript/presentation/bloc/manuscript_bloc.dart`:

```dart
Future<void> _onToggleLike(
  ToggleLike event,
  Emitter<ManuscriptState> emit,
) async {
  final currentState = state;
  if (currentState is ManuscriptLoaded) {
    try {
      await _repository.toggleLike(event.pageId);

      final updatedPages = currentState.pages.map((page) {
        if (page.id == event.pageId) {
          return page.copyWith(isLiked: !page.isLiked);
        }
        return page;
      }).toList();

      emit(currentState.copyWith(pages: updatedPages));
    } on Exception {
      // Silently fail - don't disrupt the user experience
    }
  }
}
```

**Key points:**
- Catch exception without re-throwing
- Add explanatory comment for why failure is silent
- Update UI optimistically even if persistence fails

### Pattern 4: No Error Handling

Some methods let exceptions propagate naturally:

```dart
void setupDependencies() {
  getIt.registerLazySingleton<AudioService>(() => AudioService());
  getIt.registerLazySingleton<TtsService>(() => TtsService());
  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
}
```

**Key points:**
- Let DI setup failures surface immediately (crash on startup)
- Appropriate for initialization code

---

## Type Annotations

### Return Types

**Always specify return types:**

```dart
Future<void> loadPages() async { }     // Good
Future<List<ManuscriptPage>> getPages() async { }  // Good
Widget build(BuildContext context) => ...  // Good
```

### Field Types

**Always specify types for class fields:**

```dart
class ManuscriptBloc extends Bloc<ManuscriptEvent, ManuscriptState> {
  final ManuscriptRepository _repository;
  final ManuscriptLocalizations _l10n;
  final TtsService _ttsService;
  final ManuscriptLocalDataSource _dataSource;
  // All fields have explicit types
}
```

### Variable Declarations

Use `var` only when type is obvious from assignment:

```dart
final pages = await getManuscriptPages();  // OK - type inferred
final page = pages.first;  // OK - type obvious
var index = 0;  // OK - type obvious
```

---

## Widget Conventions

### Stateless Widgets

Use `const` constructors:

```dart
class ArtOfDealWarApp extends StatelessWidget {
  const ArtOfDealWarApp({super.key});

  @override
  Widget build(BuildContext context) { ... }
}
```

### State Classes

Follow BLoC pattern with events and states:

```dart
// Event
abstract class ManuscriptEvent extends Equatable { ... }
class LoadManuscriptPages extends ManuscriptEvent { ... }

// State
abstract class ManuscriptState extends Equatable { ... }
class ManuscriptInitial extends ManuscriptState { ... }
class ManuscriptLoading extends ManuscriptState { ... }
class ManuscriptLoaded extends ManuscriptState { ... }
class ManuscriptError extends ManuscriptState { ... }
```

---

## Architecture Pattern

The codebase uses clean architecture with clear layer separation:

```
lib/
├── core/
│   ├── router/           # App routing (GoRouter)
│   ├── services/          # Business services (Audio, TTS)
│   └── theme/            # Theme configuration
├── features/
│   └── manuscript/
│       ├── data/         # Models, datasources, repository impl
│       ├── domain/       # Entities, repository interfaces
│       └── presentation/ # BLoC, pages, widgets
├── injection_container.dart  # DI setup
└── main.dart             # Entry point
```

**Layer Rules:**
- Domain layer (pure Dart) - no Flutter imports
- Data layer - Hive models, repository implementations
- Presentation layer - BLoC, UI widgets

---

*Convention analysis: 2026-04-11*