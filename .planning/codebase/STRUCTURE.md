# Codebase Structure

**Analysis Date:** 2026-04-11

## Directory Layout

```
don_tzu/
├── lib/
│   ├── core/
│   │   ├── router/           # Navigation configuration
│   │   ├── services/         # Shared services (TTS, audio)
│   │   └── theme/            # Theme and styling
│   ├── features/
│   │   └── manuscript/
│   │       ├── data/         # Data layer (models, datasources, repo impl)
│   │       ├── domain/       # Domain layer (entities, repository interfaces)
│   │       ├── l10n/         # Localization files
│   │       └── presentation/ # Presentation layer (BLoC, pages, widgets)
│   ├── l10n/                 # App-level localization
│   ├── injection_container.dart  # Dependency injection setup
│   └── main.dart             # App entry point
├── assets/                   # Images, backgrounds, sounds
├── test/                     # Test files
├── pubspec.yaml              # Dependencies and build config
└── l10n.yaml                 # Localization configuration
```

---

## Directory Purposes

### lib/core/ (Cross-Cutting)

**Purpose:** Shared infrastructure used by multiple features. Contains services, theme configuration, and navigation.

**Contents:**

- `lib/core/router/` - Navigation configuration
  - `app_router.dart` - GoRouter setup with route definitions and page builders

- `lib/core/services/` - Shared services
  - `tts_service.dart` - Text-to-speech using Edge TTS, manages audio playback
  - `audio_service.dart` - Background music playback using AudioPlayer

- `lib/core/theme/` - Theme configuration
  - `app_theme.dart` - ThemeData for light/dark modes, AppColors palette
  - `theme_cubit.dart` - Cubit for theme mode state management

**Key Pattern:** Services are singletons, theme uses Cubit for simple state, router handles navigation declaratively.

### lib/features/ (Feature Modules)

**Purpose:** Feature-based organization. Each feature is a self-contained module with its own layers.

**Organization:** Feature-based (manuscript feature)

- `lib/features/manuscript/domain/` - Domain layer (pure Dart)
  - `entities/manuscript_page.dart` - Core business entity
  - `repositories/manuscript_repository.dart` - Repository interface

- `lib/features/manuscript/data/` - Data layer (implementations)
  - `datasources/manuscript_local_datasource.dart` - Data source interface and implementation
  - `models/manuscript_page_model.dart` - Hive-persistable model
  - `repositories/manuscript_repository_impl.dart` - Repository implementation

- `lib/features/manuscript/presentation/` - Presentation layer (Flutter UI)
  - `bloc/` - BLoC pattern files (events, states, bloc classes)
  - `pages/` - Full screen page widgets
  - `widgets/` - Reusable UI component widgets

- `lib/features/manuscript/l10n/` - Feature-specific localization
  - `l10n.yaml` - Localization config
  - `generated/` - Generated localization dart files

**Key Pattern:** Each feature follows clean architecture internally. Data flows: Domain (interface) → Data (implementation) → Presentation (BLoC → UI).

### lib/l10n/ (App-Level)

**Purpose:** App-wide localization for UI elements (labels, buttons, etc.)

**Contents:**
- `app_localizations.dart` - Generated app-level localization delegate
- Generated files: `app_localizations_en.dart`, `app_localizations_sk.dart`, etc.

### lib/ Root Files

- `injection_container.dart` - Dependency injection setup using get_it
- `main.dart` - App entry point, Hive init, app widget composition

---

## Key File Locations

### Entry Points

| File | Purpose |
|------|---------|
| `lib/main.dart` | App entry point, initializes Hive, DI, sets up MaterialApp.router |
| `lib/injection_container.dart` | Registers all services, repositories, BLoCs with get_it |

### Configuration

| File | Purpose |
|------|---------|
| `pubspec.yaml` | Dependencies, assets, Flutter config |
| `l10n.yaml` | Localization configuration |
| `lib/core/router/app_router.dart` | Route definitions |

### Core Infrastructure

| File | Purpose |
|------|---------|
| `lib/core/theme/app_theme.dart` | ThemeData and color palette |
| `lib/core/theme/theme_cubit.dart` | Theme state management |
| `lib/core/services/tts_service.dart` | TTS audio generation/playback |
| `lib/core/services/audio_service.dart` | Background music playback |

### Feature: Manuscript

**Domain Layer:**
- `lib/features/manuscript/domain/entities/manuscript_page.dart` - Entity with id, title, quote, imageAsset, isLiked
- `lib/features/manuscript/domain/repositories/manuscript_repository.dart` - Repository interface

**Data Layer:**
- `lib/features/manuscript/data/datasources/manuscript_local_datasource.dart` - Local data source (hardcoded content)
- `lib/features/manuscript/data/models/manuscript_page_model.dart` - Hive model
- `lib/features/manuscript/data/repositories/manuscript_repository_impl.dart` - Repository implementation

**Presentation Layer (BLoC):**
- `lib/features/manuscript/presentation/bloc/manuscript_bloc.dart` - Main BLoC for manuscript pages
- `lib/features/manuscript/presentation/bloc/manuscript_event.dart` - Events: LoadManuscriptPages, ToggleLike
- `lib/features/manuscript/presentation/bloc/manuscript_state.dart` - States: Initial, Loading, Loaded, Error
- `lib/features/manuscript/presentation/bloc/intro_bloc.dart` - Intro BLoC
- `lib/features/manuscript/presentation/bloc/intro_event.dart` - Event: InitializeIntro
- `lib/features/manuscript/presentation/bloc/intro_state.dart` - States: Initial, Loading, Ready, Error

**Presentation Layer (UI):**
- `lib/features/manuscript/presentation/pages/manuscript_feed_page.dart` - Main feed with PageView, action bar
- `lib/features/manuscript/presentation/pages/intro_cover_page.dart` - Animated intro screen

**Presentation Layer (Widgets):**
- `lib/features/manuscript/presentation/widgets/manuscript_page_card.dart` - Decorative widgets (paper texture, aged edges, character images, animated text)

---

## Naming Conventions

### Files

| Type | Convention | Example |
|------|------------|---------|
| BLoC files | `feature_bloc.dart` | `manuscript_bloc.dart` |
| Events/States | `feature_event.dart`, `feature_state.dart` | `manuscript_event.dart` |
| Entities | `entity_name.dart` | `manuscript_page.dart` |
| Models | `model_name.dart` | `manuscript_page_model.dart` |
| Repositories | `feature_repository.dart` | `manuscript_repository.dart` |
| Pages | `feature_page.dart` | `manuscript_feed_page.dart` |
| Widgets | `widget_name.dart` | `manuscript_page_card.dart` |

### Directories

| Type | Convention | Example |
|------|------------|---------|
| Feature | snake_case | `manuscript/` |
| Layer | snake_case | `presentation/` |
| Sub-folder | snake_case | `bloc/`, `pages/`, `widgets/` |

### Classes

| Type | Convention | Example |
|------|------------|---------|
| BLoCs | PascalCase | `ManuscriptBloc` |
| Events | PascalCase | `LoadManuscriptPages` |
| States | PascalCase | `ManuscriptLoaded` |
| Entities | PascalCase | `ManuscriptPage` |
| Models | PascalCase | `ManuscriptPageModel` |
| Cubits | PascalCase | `ThemeCubit` |

### Constants

| Convention | Example |
|------------|---------|
| camelCase with k prefix | `kIntroAnimationDuration` |

---

## Where to Add New Code

### New Feature

1. Create feature directory: `lib/features/[feature_name]/`
2. Create layer directories: `domain/`, `data/`, `presentation/`
3. Domain: Add entity and repository interface
4. Data: Add datasource and repository implementation
5. Presentation: Add BLoC (event/state/bloc), pages, widgets
6. Register dependencies in `lib/injection_container.dart`
7. Add routes in `lib/core/router/app_router.dart`

**Primary code location:** `lib/features/[feature_name]/`
**Tests:** `test/` directory

### New BLoC

1. Create BLoC file: `lib/features/[feature]/presentation/bloc/feature_bloc.dart`
2. Create events: `lib/features/[feature]/presentation/bloc/feature_event.dart`
3. Create states: `lib/features/[feature]/presentation/bloc/feature_state.dart`
4. Register in DI container or create per-route in router

### New Service

1. Create service file: `lib/core/services/service_name.dart`
2. Implement as singleton or factory
3. Register in `lib/injection_container.dart`

### New Page

1. Create page file: `lib/features/[feature]/presentation/pages/page_name_page.dart`
2. Add route in `lib/core/router/app_router.dart`
3. Wrap with BlocProvider if using BLoC

### New Widget

1. Create widget file: `lib/features/[feature]/presentation/widgets/widget_name.dart`
2. Keep focused on single responsibility
3. Extract to separate file if reused more than once

### New Entity

1. Create entity: `lib/features/[feature]/domain/entities/entity_name.dart`
2. Use Equatable for value equality
3. Implement copyWith() method

---

## Special Directories

### assets/

**Purpose:** Static assets (images, sounds, backgrounds)

**Contents:**
- `assets/images/` - Character/scene images (1.webp through 20.webp)
- `assets/sound/` - Background music (walen-lonely-samurai.mp3)
- `assets/backgrounds/` - Background images

**Generated:** No (committed to repo)

### test/

**Purpose:** Test files

**Note:** Test infrastructure present (flutter_test in pubspec), but no specific test files found in current codebase

### l10n/ (lib/l10n/)

**Purpose:** App-level generated localizations

**Generated:** Yes (auto-generated from ARB files)

**Commits:** Yes (generated Dart files committed)

---

## Feature Organization Pattern

This codebase uses **feature-based organization** with internal clean architecture layers.

### Structure by Feature

```
lib/features/
└── manuscript/
    ├── data/           # Implementation details
    ├── domain/         # Business logic (interfaces, entities)
    ├── l10n/           # Feature-specific translations
    └── presentation/   # UI (BLoC, pages, widgets)
```

### Layer Dependencies

```
Presentation → Domain ← Data
     ↓            ↓
   flutter    Equatable
     ↓
  flutter_bloc
```

- Domain has no dependencies (pure Dart)
- Data implements domain interfaces
- Presentation depends on domain and Flutter

### Why This Structure

1. **Modularity:** Each feature is self-contained
2. **Testability:** Domain layer has no Flutter dependencies, easy to unit test
3. **Maintainability:** Clear separation of concerns
4. **Scalability:** Adding new features doesn't affect existing code
5. **Reusability:** Core services shared across features

---

## Migration Note

**Note:** The codebase currently has only one feature (manuscript). The structure scales well as features are added. Each feature should follow the same pattern: domain/data/presentation subdirectories with localized content.

---

*Structure analysis: 2026-04-11*