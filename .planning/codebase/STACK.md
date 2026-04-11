# Technology Stack

**Analysis Date:** 2026-04-11

## Languages

**Primary:**
- Dart 3.10.7 - Core language for entire Flutter application

**Secondary:**
- N/A - No secondary languages used

## Runtime

**Environment:**
- Flutter 3.41.5 - Cross-platform UI framework
- Dart SDK ^3.10.7 - Language runtime

**Package Manager:**
- Flutter's Dart SDK (bundled with Flutter)
- Lockfile: `pubspec.lock` (generated)

## Frameworks

**Core:**
- Flutter 3.41.5 - Application framework for iOS, Android, Web, macOS, Windows, Linux

**State Management:**
- flutter_bloc 9.1.0 - BLoC pattern state management
  - Implementation: `lib/features/manuscript/presentation/bloc/manuscript_bloc.dart`
  - Implementation: `lib/features/manuscript/presentation/bloc/intro_bloc.dart`
  - Event-driven architecture with clear separation of concerns

**Routing:**
- go_router 15.1.0 - Declarative routing
  - Implementation: `lib/core/router/app_router.dart`
  - Supports deep linking and custom page transitions

**Dependency Injection:**
- get_it 8.0.3 - Service locator for DI
  - Implementation: `lib/injection_container.dart`
  - Registers lazy singletons for services, repositories, and blocs

**Local Storage:**
- hive_ce 2.10.1 - Fast NoSQL database (community edition)
  - Implementation: `lib/features/manuscript/data/models/manuscript_page_model.dart`
  - hive_ce_flutter 2.2.0 - Flutter adapter for Hive CE
  - Code generation: `manuscript_page_model.g.dart` via hive_ce_generator

## Key Dependencies

**Critical:**
- flutter_bloc 9.1.0 - State management using BLoC pattern
- get_it 8.0.3 - Dependency injection
- hive_ce 2.10.1 - Local data persistence
- go_router 15.1.0 - Navigation and routing

**Audio & Multimedia:**
- audioplayers 6.4.0 - Multi-track audio playback
  - Used by: `lib/core/services/audio_service.dart` (background music)
  - Used by: `lib/core/services/tts_service.dart` (TTS playback)
  - Supports device file sources, asset sources, streaming
  - Release modes: stop, loop, release
- edge_tts 0.1.4 - Microsoft Edge TTS (Web Speech API compatible)
  - Used by: `lib/core/services/tts_service.dart`
  - Generates speech from text using Edge's AI voices
  - Supports multiple languages via locale selection
  - Voice parameters: rate, pitch, volume adjustments

**UI & Theming:**
- google_fonts 6.2.1 -Typography
  - Implementation: `lib/core/theme/app_theme.dart`
  - Uses: NotoSerif, NotoSerifJp, NotoSansJp fonts
  - Supports both light and dark themes
- flutter_animate 4.5.2 - Animation library
  - Used in page transitions and UI effects
- cupertino_icons 1.0.8 - iOS-style icons

**Utilities:**
- equatable 2.0.7 - Value equality for Dart objects
  - Used in BLoC states and events
  - Implementation: state classes implement Equatable
- intl 0.20.2 - Internationalization
  - Used for localization and locale detection
- path_provider 2.1.5 - File system paths
  - Used for TTS audio cache directory
- share_plus 10.1.4 - Native sharing capabilities
- flutter_localizations - Built-in Flutter i18n

**Dev Dependencies:**
- build_runner 2.4.15 - Code generation
- hive_ce_generator 1.7.0 - Hive adapter generation
- flutter_test - Testing framework
- flutter_launcher_icons 0.10.0 - App icon generation
- very_good_analysis 10.2.0 - Linting rules

## Configuration

**Environment:**
- `pubspec.yaml` - Project manifest with all dependencies
- Flutter's standard l10n configuration enabled
- Asset folders declared: assets/images/, assets/backgrounds/, assets/sound/

**Build:**
- Platforms targeted: iOS, Android, Web, macOS, Windows, Linux
- App icon generation configured for all platforms

**Analysis:**
- Uses `very_good_analysis` for strict linting
- Standard Flutter analysis options

## Platform Requirements

**Development:**
- Flutter SDK 3.41.5+
- Dart SDK 3.10.7+
- Platform-specific build tools (Xcode, Android SDK)

**Production:**
- Standard Flutter build targets
- No special platform channels required
- Native audio capabilities

## Architecture Pattern

**Clean Architecture (Domain/Data/Presentation):**
- Domain Layer: `lib/features/manuscript/domain/`
  - Entities: `manuscript_page.dart`
  - Repository interfaces: `manuscript_repository.dart`
- Data Layer: `lib/features/manuscript/data/`
  - Models: `manuscript_page_model.dart`
  - Data sources: `manuscript_local_datasource.dart`
  - Repository implementations: `manuscript_repository_impl.dart`
- Presentation Layer: `lib/features/manuscript/presentation/`
  - BLoCs: `manuscript_bloc.dart`, `intro_bloc.dart`
  - Pages: `intro_cover_page.dart`, `manuscript_feed_page.dart`
  - Widgets: `manuscript_page_card.dart`

**Services (Core):**
- `lib/core/services/tts_service.dart` - Text-to-speech generation and playback
- `lib/core/services/audio_service.dart` - Background music playback
- `lib/core/theme/app_theme.dart` - Theme configuration
- `lib/core/theme/theme_cubit.dart` - Theme state management

**Entry Point:**
- `lib/main.dart` - App initialization
  - Hive initialization
  - Dependency injection setup
  - MaterialApp.router configuration with localization