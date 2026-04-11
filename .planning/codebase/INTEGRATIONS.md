# External Integrations

**Analysis Date:** 2026-04-11

## APIs & External Services

### Text-to-Speech (TTS)

**Service:** Microsoft Edge TTS (via edge_tts package)
- **Package:** `edge_tts` 0.1.4
- **Implementation:** `lib/core/services/tts_service.dart`
- **How it works:**
  - Uses Microsoft's Edge browser-based TTS engine
  - Voices are auto-selected based on device locale
  - Audio is generated as MP3 files and cached locally
  - Playback via audioplayers package

- **Voice Selection Logic:**
  ```dart
  // From TTS service - selects voice matching device locale
  final voice = voices.firstWhere(
    (v) => v.locale.startsWith(languageCode),
    orElse: () => voices.firstWhere(
      (v) => v.locale.startsWith('en'),
      orElse: () => voices.first,
    ),
  );
  ```

- **Voice Parameters:**
  - Rate: '-10%' (slightly slower for clarity)
  - Pitch: '-20Hz' (deeper tone)
  - Volume: '+0%' (default)

- **Caching:**
  - Generated audio files stored in app documents directory: `{docsDir}/tts_audio/{locale}/`
  - File format: MP3
  - Lazy generation - only created when needed
  - Persists across app sessions

- **Supported Locales:** Automatic detection from device (en, cs, de, hu, pl, sk supported in app)

### Audio Playback

**Service:** audioplayers (multi-track audio)
- **Package:** `audioplayers` 6.4.0
- **Implementation Locations:**
  - `lib/core/services/audio_service.dart` - Background music
  - `lib/core/services/tts_service.dart` - TTS playback

- **Audio Player Configurations:**
  ```dart
  // TTS Player
  final AudioPlayer _audioPlayer = AudioPlayer(playerId: 'tts_player')
    ..setReleaseMode(ReleaseMode.stop)
    ..setPlayerMode(PlayerMode.mediaPlayer)
    ..setVolume(1);

  // Background Music Player  
  final AudioPlayer _player = AudioPlayer(playerId: 'background_music')
    ..setReleaseMode(ReleaseMode.loop)
    ..setVolume(0.2);
  ```

- **Audio Sources:**
  - Asset Source: Background music from `assets/sound/walen-lonely-samurai.mp3`
  - Device File Source: Cached TTS audio files

### Background Music

**Audio File:** `assets/sound/walen-lonely-samurai.mp3`
- **Implementation:** `lib/core/services/audio_service.dart`
- **Playback:** Looped with 20% volume
- **Controls:** Play, pause, resume, stop, toggle mute

## Data Storage

### Local Database

**Database:** Hive CE (Community Edition)
- **Package:** `hive_ce` 2.10.1 + `hive_ce_flutter` 2.2.0
- **Implementation:** `lib/features/manuscript/data/models/manuscript_page_model.dart`
- **Type ID:** 0
- **Fields:**
  - id (String)
  - title (String)
  - quote (String)
  - imageAsset (String)
  - isLiked (bool)

- **Generated Adapter:** `manuscript_page_model.g.dart`

### File Storage

**Local File System:**
- **Service:** `path_provider` 2.1.5
- **Purpose:** Access app documents directory for TTS cache
- **Implementation:** `lib/core/services/tts_service.dart`
- **Cache Location:** `{application_documents}/tts_audio/`

## Image Assets

**Image Storage:** Bundled in app as Flutter assets
- **Location:** `assets/images/`, `assets/backgrounds/`
- **Files:**
  - 1.webp through 25.webp (manuscript page images)
  - Background tiles: row-{1-4}-column-{1-4}.webp
  - Background: page.png
  - App icon: app_icon.png, samurai_1.png

- **Usage:**
  - Loaded via Flutter's asset system
  - Referenced by path: `assets/images/{n}.webp`
  - Used by: `lib/features/manuscript/data/datasources/manuscript_local_datasource.dart`

## Authentication & Identity

**Auth Provider:** Not applicable
- No authentication system implemented
- No user accounts or login
- Local-only app

## Localization & Internationalization

### Multi-Language Support

**Implementation:** Flutter's built-in l10n + custom ARB files
- **Supported Locales:**
  - English (en)
  - Czech (cs)
  - German (de)
  - Hungarian (hu)
  - Polish (pl)
  - Slovak (sk)

- **Localization Structure:**
  - App-level: `lib/l10n/generated/`
  - Feature-level: `lib/features/manuscript/l10n/generated/`

- **Key Translations:**
  - Chapter titles (1-20)
  - Chapter quotes ( satirical "Art of War - Deal Edition" quotes)
  - UI strings

- **Locale Detection:**
  ```dart
  // From TTS service
  final currentLanguage = Intl.defaultLocale ?? Platform.localeName.split('_').first;
  ```

## Platform Integrations

### Share Functionality

**Package:** share_plus 10.1.4
- **Purpose:** Native share dialog
- **Status:** Imported but not actively used in current code

### Navigation

**Routing:** go_router 15.1.0
- **Implementation:** `lib/core/router/app_router.dart`
- **Routes:**
  - `/intro` - Intro cover page with animations
  - `/` - Manuscript feed page (home)

- **Features:**
  - CustomTransitionPage for fade transitions
  - NoTransitionPage for home route
  - BlocProvider creation per route

### Theme Management

**Implementation:** ThemeCubit + go_router
- **File:** `lib/core/theme/theme_cubit.dart`
- **Supports:** Light/Dark mode switching

## Monitoring & Observability

**Error Tracking:** Not implemented
- Uses `debugPrint()` for development logging
- No crash reporting or analytics

**Logs:**
- Console logging via `debugPrint()` in:
  - `lib/core/services/tts_service.dart`
  - `lib/core/services/audio_service.dart`
  - `lib/main.dart`

## CI/CD & Deployment

**Hosting:** Not applicable (local build)
- Standard Flutter build targets
- No cloud deployment

**CI Pipeline:** None
- Manual build process
- Uses local Flutter SDK

## Environment Configuration

**Required Configuration:**
- Flutter SDK 3.41.5+
- Dart SDK 3.10.7+
- Platform-specific tools (Xcode for iOS, Android SDK for Android)

**Build Configuration Files:**
- `pubspec.yaml` - Dependencies and assets
- `analysis_options.yaml` - Linting (via very_good_analysis)

## Architecture Summary

### Data Flow

1. **Manuscript Data Flow:**
   - `ManuscriptLocalDataSource` provides localized content from ARB files
   - `ManuscriptRepositoryImpl` transforms models to entities
   - `ManuscriptBloc` manages state and coordinates TTS init
   - UI renders via `ManuscriptFeedPage`

2. **Audio/TTS Flow:**
   - User visits intro -> TTS generates/cache audio for all chapters
   - User taps play on manuscript page -> TTS plays corresponding cached audio
   - Background music plays in loop via AudioService

3. **Localization Flow:**
   - Device locale detected via `Platform.localeName`
   - Flutter loads appropriate ARB translations
   - TTS auto-selects voice matching locale

### Key Services as Singletons

Registered in `lib/injection_container.dart`:
```dart
getIt.registerLazySingleton<AudioService>(() => AudioService());
getIt.registerLazySingleton<TtsService>(() => TtsService());
getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
getIt.registerLazySingleton<ManuscriptLocalDataSource>(...);
getIt.registerLazySingleton<ManuscriptRepository>(...);
```

---

*Integration audit: 2026-04-11*