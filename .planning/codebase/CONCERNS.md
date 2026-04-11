# Codebase Concerns

**Analysis Date:** 2026-04-11

## Tech Debt

### Hive Persistence Not Implemented
- **Issue:** Hive is initialized in `lib/main.dart` but never actually used for data persistence
- **Files:**
  - `lib/features/manuscript/data/datasources/manuscript_local_datasource.dart` (lines 17-19, 151)
  - `lib/main.dart` (line 18)
- **Impact:** User "likes" on manuscript pages are not persisted across app restarts. Every launch starts with no liked pages.
- **Fix approach:** Implement actual Hive storage by creating a Hive box for liked page IDs and updating `getLikedPageIds()` and `saveLikedPageIds()` to read/write from the box.

### TTS Service Debug Print Statements
- **Issue:** Multiple `print()` statements used for debugging instead of `debugPrint()`
- **Files:** `lib/core/services/tts_service.dart` (lines 48, 73, 74, 77, 95)
- **Impact:** Linting warnings in production, debug output in console
- **Fix approach:** Replace all `print()` calls with `debugPrint()` or remove entirely

### Duplicate Print Statement
- **Issue:** Lines 77-78 in `tts_service.dart` are identical duplicate prints
- **Files:** `lib/core/services/tts_service.dart` (lines 77-79)
- **Impact:** Redundant logging output
- **Fix approach:** Remove one of the duplicate print statements

### Generic Catch Clauses
- **Issue:** Several catch blocks don't specify exception type with `on`
- **Files:**
  - `lib/core/services/tts_service.dart` (lines 114, 142, 152)
  - `lib/features/manuscript/presentation/bloc/intro_bloc.dart` (line 27)
- **Impact:** Less precise error handling, cannot differentiate between exception types
- **Fix approach:** Use `on Exception catch (e)` or specific exception types

### Silent Error Swallowing
- **Issue:** `ToggleLike` event handler silently catches exceptions without user feedback
- **Files:** `lib/features/manuscript/presentation/bloc/manuscript_bloc.dart` (lines 57-59)
- **Impact:** Users don't know when their like action fails
- **Fix approach:** Emit a failure state or show error message to user

### Empty Test Coverage
- **Issue:** Only one placeholder test exists with no actual assertions or coverage
- **Files:** `test/widget_test.dart`
- **Impact:** No regression protection, cannot verify business logic
- **Fix approach:** Add unit tests for BLoCs, widget tests for key UI components

## Architecture Concerns

### Monolithic Data Source
- **Issue:** All 20 manuscript chapters are hardcoded in a single method with no separation between data layer and content
- **Files:** `lib/features/manuscript/data/datasources/manuscript_local_datasource.dart` (lines 22-148)
- **Impact:** Difficult to maintain, extend, or localize content; violates single responsibility principle
- **Fix approach:** Extract content to separate data files or localization keys, create content model classes

### BLoC Mixing Responsibilities
- **Issue:** `ManuscriptBloc` handles both data loading AND TTS service initialization
- **Files:** `lib/features/manuscript/presentation/bloc/manuscript_bloc.dart` (lines 31-33)
- **Impact:** BLoC has too many responsibilities, harder to test, couples presentation to services
- **Fix approach:** Move TTS initialization to a service or use case that runs before BLoC creation

### Singleton Services with GetIt Mismatch
- **Issue:** `TtsService` and `AudioService` use manual singleton pattern (`_instance`) but are also registered as `LazySingleton` in get_it, causing potential initialization conflicts
- **Files:**
  - `lib/core/services/tts_service.dart` (lines 10-12)
  - `lib/core/services/audio_service.dart` (lines 5-7)
  - `lib/injection_container.dart` (lines 13-14)
- **Impact:** Duplicate instances possible, unclear ownership, potential memory leaks
- **Fix approach:** Remove manual singleton pattern and rely solely on GetIt, or remove GetIt registration

### No Lifecycle Management for Services
- **Issue:** Services with `dispose()` methods (`TtsService`, `AudioService`) are never disposed
- **Files:**
  - `lib/core/services/tts_service.dart` (line 159)
  - `lib/core/services/audio_service.dart` (line 49)
- **Impact:** Resource leaks, especially audio players
- **Fix approach:** Register services with `registerFactory` or implement proper cleanup on app dispose

### Hardcoded TTS Voice Settings
- **Issue:** TTS voice parameters (rate -10%, pitch -20Hz) are hardcoded with no configuration option
- **Files:** `lib/core/services/tts_service.dart` (lines 65-68)
- **Impact:** Users cannot adjust speech rate/pitch, one-size-fits-all approach
- **Fix approach:** Add configuration options or user preferences for voice settings

## Performance Concerns

### TTS Generation Blocks App Startup
- **Issue:** `initWithChapters()` generates audio files synchronously during app initialization
- **Files:** `lib/core/services/tts_service.dart` (lines 82-118)
- **Impact:** Slow app startup, especially on first launch when all 20 chapters need TTS generation
- **Fix approach:** Implement lazy generation (on-demand), show loading indicator, or generate in background isolate

### No Image Caching Strategy
- **Issue:** 20 manuscript page images loaded from assets with no caching mechanism
- **Files:** `lib/features/manuscript/data/datasources/manuscript_local_datasource.dart` (line 31)
- **Impact:** Potential memory issues with large images, no offline optimization
- **Fix approach:** Implement image caching with `cached_network_image` or pre-cache on startup

### Google Fonts Runtime Loading
- **Issue:** Google Fonts loaded at runtime with no offline fallback
- **Files:** `lib/core/theme/app_theme.dart` (lines 91-165)
- **Impact:** Text rendering fails or uses fallback if no network, potential FOUT
- **Fix approach:** Bundle font files or add offline fallback fonts

## Security Considerations

### No Asset Validation
- **Issue:** Image assets referenced without validation that files exist
- **Files:** `lib/features/manuscript/data/datasources/manuscript_local_datasource.dart` (line 31)
- **Impact:** Missing assets cause runtime crashes
- **Fix approach:** Add asset existence validation or graceful fallback

### No Input Sanitization
- **Issue:** User-provided data not sanitized (though currently no user input accepted)
- **Files:** `lib/features/manuscript/data/repositories/manuscript_repository_impl.dart`
- **Impact:** Future feature additions may introduce vulnerabilities
- **Fix approach:** Implement input validation when user-generated content is added

## Known Limitations

### Single Feature Implementation
- **Issue:** App only has manuscript/quote viewing feature - no settings, no additional content
- **Impact:** Limited functionality, no user preferences (theme is the only one via ThemeCubit)
- **Recommendation:** Add settings screen, more content categories, user preferences

### No Offline Support Indicator
- **Issue:** No indication to user whether app works offline or requires network
- **Impact:** Confusing UX on poor connectivity
- **Recommendation:** Add connectivity indicator or offline mode badge

### No Error Recovery UI
- **Issue:** Errors show only as state (ManuscriptError) without retry mechanism
- **Files:** `lib/features/manuscript/presentation/bloc/manuscript_bloc.dart` (line 36)
- **Impact:** Users stuck on error screen with no way to recover
- **Recommendation:** Add retry button in error state UI

### Hardcoded Locale Detection
- **Issue:** Language detection uses `Intl.defaultLocale` without fallback strategy
- **Files:** `lib/core/services/tts_service.dart` (line 87)
- **Impact:** Unpredictable behavior on devices without locale set
- **Recommendation:** Add explicit fallback to English

## Test Coverage Gaps

### No BLoC Tests
- **What's not tested:** ManuscriptBloc and IntroBloc state transitions, event handling
- **Files:**
  - `lib/features/manuscript/presentation/bloc/manuscript_bloc.dart`
  - `lib/features/manuscript/presentation/bloc/intro_bloc.dart`
- **Risk:** Logic errors in state management go undetected
- **Priority:** High

### No Service Tests
- **What's not tested:** TtsService audio generation, AudioService playback
- **Files:**
  - `lib/core/services/tts_service.dart`
  - `lib/core/services/audio_service.dart`
- **Risk:** Audio functionality breaks without detection
- **Priority:** High

### No Widget Tests
- **What's not tested:** UI components, navigation, user interactions
- **Files:**
  - `lib/features/manuscript/presentation/pages/`
  - `lib/features/manuscript/presentation/widgets/`
- **Risk:** UI regressions undetected, broken interactions
- **Priority:** Medium

### No Repository Tests
- **What's not tested:** Data mapping, like toggle logic
- **Files:** `lib/features/manuscript/data/repositories/manuscript_repository_impl.dart`
- **Risk:** Data transformation bugs
- **Priority:** Medium

---

*Concerns audit: 2026-04-11*