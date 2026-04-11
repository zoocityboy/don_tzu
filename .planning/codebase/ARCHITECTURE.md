# Architecture

**Analysis Date:** 2026-04-11

## Pattern Overview

**Overall:** Clean Architecture with BLoC State Management

This Flutter app follows **Clean Architecture** (also known as Hexagonal Architecture or Ports & Adapters) with three distinct layers: **Domain**, **Data**, and **Presentation**. State management is handled via **flutter_bloc** (BLoC pattern), providing clear separation between UI events, business logic, and state updates. Dependency injection is managed by **get_it** for service location.

## Layers

### Domain Layer (Inner Core)

**Purpose:** Pure Dart business logic with no external dependencies. Defines entities and repository interfaces.

**Location:** `lib/features/manuscript/domain/`

**Contains:**
- **Entities:** `manuscript_page.dart` - Core business object representing a manuscript page
- **Repository Interfaces:** `manuscript_repository.dart` - Abstract repository contract

**Depends on:** None (pure Dart, no external packages except `equatable`)

**Used by:** Presentation layer via dependency inversion

**Key Files:**
- `lib/features/manuscript/domain/entities/manuscript_page.dart` - The `ManuscriptPage` entity class with immutable properties (id, title, quote, imageAsset, isLiked) and `copyWith()` method for creating modified copies
- `lib/features/manuscript/domain/repositories/manuscript_repository.dart` - Abstract interface defining `getManuscriptPages()`, `toggleLike()`, and `getLikedPageIds()` contracts

**Pattern:** Domain entities use `Equatable` for value equality. Repository pattern enables dependency inversion, allowing the data layer to be swapped without touching domain logic.

### Data Layer (Outer Adapter)

**Purpose:** Implements repository contracts and handles data access. Transforms between domain entities and data models. Manages local persistence with Hive.

**Location:** `lib/features/manuscript/data/`

**Contains:**
- **Data Sources:** `manuscript_local_datasource.dart` - Local data access implementation
- **Repository Implementations:** `manuscript_repository_impl.dart` - Concrete repository implementation
- **Models:** `manuscript_page_model.dart` - Hive-persistable data model with TypeAdapter

**Depends on:** `hive_ce` for persistence, domain layer interfaces

**Used by:** Presentation layer via dependency injection

**Key Files:**
- `lib/features/manuscript/data/datasources/manuscript_local_datasource.dart` - `ManuscriptLocalDataSource` interface and `ManuscriptLocalDataSourceImpl` class. Contains hardcoded manuscript content (20 chapters) localized via `ManuscriptLocalizations`, provides `getManuscriptPages()` and `getChaptersForTts()` methods
- `lib/features/manuscript/data/repositories/manuscript_repository_impl.dart` - `ManuscriptRepositoryImpl` implements the repository interface, coordinates between datasource and domain entities. Maps `ManuscriptPageModel` to `ManuscriptPage` entity, manages liked pages state
- `lib/features/manuscript/data/models/manuscript_page_model.dart` - `ManuscriptPageModel` with `@HiveType(typeId: 0)` annotation for Hive persistence

**Pattern:** Data models carry serialization metadata. Repository implementation maps between model and entity. Data source provides raw data access.

### Presentation Layer (UI)

**Purpose:** Handles Flutter UI, state management, and user interactions. Contains BLoCs and widgets.

**Location:** `lib/features/manuscript/presentation/`

**Contains:**
- **BLoCs:** `manuscript_bloc.dart`, `intro_bloc.dart` - Business logic components
- **Pages:** `manuscript_feed_page.dart`, `intro_cover_page.dart` - Screen implementations
- **Widgets:** `manuscript_page_card.dart` - Reusable UI components

**Depends on:** Domain layer entities, Flutter, flutter_bloc

**Key BLoC Files:**
- `lib/features/manuscript/presentation/bloc/manuscript_bloc.dart` - Main BLoC handling `LoadManuscriptPages` and `ToggleLike` events. Emits states: `ManuscriptInitial`, `ManuscriptLoading`, `ManuscriptLoaded`, `ManuscriptError`. Injects repository, TtsService, and datasource via constructor
- `lib/features/manuscript/presentation/bloc/manuscript_event.dart` - Event definitions using Equatable: `LoadManuscriptPages`, `ToggleLike(pageId)`
- `lib/features/manuscript/presentation/bloc/manuscript_state.dart` - State definitions using Equatable: `ManuscriptInitial`, `ManuscriptLoading`, `ManuscriptLoaded(pages, currentPageIndex)`, `ManuscriptError(message)`
- `lib/features/manuscript/presentation/bloc/intro_bloc.dart` - Onboarding BLoC for intro initialization with `InitializeIntro` event

**Key Page Files:**
- `lib/features/manuscript/presentation/pages/manuscript_feed_page.dart` - Main feed UI with PageView, action bar, theme toggle, TTS controls. Uses BlocBuilder to consume ManuscriptBloc states
- `lib/features/manuscript/presentation/pages/intro_cover_page.dart` - Animated intro screen with story content, plays background music

**Widget Files:**
- `lib/features/manuscript/presentation/widgets/manuscript_page_card.dart` - Decorative widgets: `PaperTextureWidget`, `AgedEdgesWidget`, `AnimatedCharacterImageWidget`, `AnimatedTextContentWidget`, `CenteredTitleWidget`, `CenteredQuoteWidget`

**Pattern:** BLoC pattern decouples UI from business logic. Pages dispatch events to BLoC, BLoC emits states, pages rebuild via BlocBuilder.

### Core Layer (Cross-Cutting)

**Purpose:** Shared infrastructure and services used across features.

**Location:** `lib/core/`

**Contains:**
- **Theme:** `app_theme.dart`, `theme_cubit.dart` - Theme configuration
- **Services:** `tts_service.dart`, `audio_service.dart` - Audio playback services
- **Router:** `app_router.dart` - GoRouter navigation configuration

**Key Files:**
- `lib/core/theme/app_theme.dart` - ThemeData definitions for light/dark modes. Uses Google Fonts (Noto Serif/Noto Sans JP). Custom color palette simulating aged parchment. Defines `AppColors` class with light/dark color constants
- `lib/core/theme/theme_cubit.dart` - `ThemeCubit extends Cubit<ThemeMode>` - Simple Cubit for theme mode switching (light/dark/system)
- `lib/core/services/tts_service.dart` - Edge TTS integration for text-to-speech generation and playback, caches generated audio files by language
- `lib/core/services/audio_service.dart` - Background music playback using AudioPlayer with loop mode
- `lib/core/router/app_router.dart` - GoRouter config with routes: `/intro` (intro cover) and `/` (manuscript feed). Uses `CustomTransitionPage` for fade transitions

**Pattern:** Services use singleton pattern for audio players. ThemeCubit provides app-wide theme state. GoRouter handles declarative routing.

### Dependency Injection

**Purpose:** Centralized service location for dependency injection.

**Location:** `lib/injection_container.dart`

**Implementation:**
```dart
final GetIt getIt = GetIt.instance;

void setupDependencies() {
  // Services (lazy singletons)
  getIt.registerLazySingleton<AudioService>(() => AudioService());
  getIt.registerLazySingleton<TtsService>(() => TtsService());
  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  
  // Data sources
  getIt.registerLazySingleton<ManuscriptLocalDataSource>(
    () => ManuscriptLocalDataSourceImpl(),
  );
  
  // Repositories
  getIt.registerLazySingleton<ManuscriptRepository>(
    () => ManuscriptRepositoryImpl(getIt<ManuscriptLocalDataSource>()),
  );
}
```

**Pattern:** All services, BLoCs, data sources, and repositories are registered via get_it. Uses lazy singletons for efficiency (created on first access). BLoCs are created per-route in `app_router.dart` pageBuilder.

### Entry Point

**Location:** `lib/main.dart`

**Flow:**
1. `main()` initializes Hive, calls `di.setupDependencies()`, configures SystemChrome
2. `ArtOfDealWarApp` widget uses BlocProvider for ThemeCubit
3. BlocBuilder consumes theme state, MaterialApp.router applies theme and router
4. Routes resolve to pages which create their own BLoC instances with injected dependencies

---

## Data Flow

### Loading Manuscript Pages

1. **UI Event:** User navigates to feed → `ManuscriptFeedPage.initState()` dispatches `LoadManuscriptPages()`
2. **BLoC Processing:** `ManuscriptBloc._onLoadManuscriptPages()`:
   - Emits `ManuscriptLoading` state
   - Calls `repository.getManuscriptPages(l10n)` which queries datasource
   - Inits TTS with chapters
   - Emits `ManuscriptLoaded(pages: pages)` state
3. **UI Rebuild:** BlocBuilder rebuilds, renders `CenteredLayout` with pages

### Toggling Like

1. **UI Event:** User taps like button → dispatches `ToggleLike(pageId)`
2. **BLoC Processing:** `ManuscriptBloc._onToggleLike()`:
   - Calls `repository.toggleLike(pageId)`
   - Maps pages, toggles isLiked on matching page
   - Emits updated `ManuscriptLoaded` state
3. **UI Rebuild:** BlocBuilder rebuilds, updates heart icon

### Navigation

- `/intro` → `IntroCoverPage` with `IntroBloc` → navigates to `/` on tap
- `/` → `ManuscriptFeedPage` with `ManuscriptBloc` → permanent

---

## State Management

**Approach:** BLoC Pattern with flutter_bloc

**Characteristics:**
- **Events:** Immutable classes extending Equatable, dispatched from UI
- **States:** Immutable classes extending Equatable, emitted by BLoC
- **BLoC:** Extends Bloc<Event, State>, handles events with `on<Event>()` registration
- **Equatable:** All events/states use Equatable for proper comparison

**Usage in this codebase:**
- `ManuscriptBloc` - Main app state (loaded pages, current page index, like states)
- `IntroBloc` - Onboarding state (initializing, ready, error)
- `ThemeCubit` - Simple Cubit for theme mode (lighter than full BLoC for simple state)

---

## Error Handling

**Strategy:** Catch exceptions in BLoC, emit error state instead of propagating

**Example (from `manuscript_bloc.dart`):**
```dart
Future<void> _onLoadManuscriptPages(...) async {
  emit(const ManuscriptLoading());
  try {
    final pages = await _repository.getManuscriptPages(_l10n);
    emit(ManuscriptLoaded(pages: pages));
  } on Exception catch (e) {
    emit(ManuscriptError(e.toString()));
  }
}
```

**UI Handling:**
- `ManuscriptLoaded` → show pages
- `ManuscriptLoading` → show spinner
- `ManuscriptError` → show error message with retry option

---

## Localization

**Approach:** Flutter's built-in internationalization with ARB files

**Configuration:**
- `pubspec.yaml`: `generate: true`
- `l10n.yaml` - Localization config
- `lib/l10n/` - Generated app localizations
- `lib/features/manuscript/l10n/` - Feature-specific localizations

**Usage:** Pages receive `ManuscriptLocalizations` as constructor parameter, pass to repository/datasource for content localization

---

*Architecture analysis: 2026-04-11*