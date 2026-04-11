# Testing Patterns

**Analysis Date:** 2026-04-11

## Test Framework

### Runner

- **Framework**: `flutter_test` (Flutter SDK built-in)
- **Version**: Provided via Flutter SDK
- **Config**: No specific test configuration file present

### Additional Testing Dependencies

From `pubspec.yaml`:
- `flutter_test` - Core test framework
- `build_runner: ^2.4.15` - Code generation (used for Hive adapters)
- `hive_ce_generator: ^1.7.0` - Hive adapter code generation

### Run Commands

```bash
# Run all tests
flutter test

# Run single test file
flutter test test/widget_test.dart

# Run tests matching pattern
flutter test --name "test_name"

# Compact output
flutter test --reporter compact

# With code coverage
flutter test --coverage
```

---

## Test File Organization

### Location

- **Root**: `test/` directory
- **Current Tests**: Only `test/widget_test.dart` exists

### Naming Convention

- **Pattern**: `<feature>_test.dart` or `test.dart`
- **Examples**:
  - `test/widget_test.dart` - Main widget test

### Current Test Structure

The only test file (`test/widget_test.dart`) is minimal:

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App builds successfully', (tester) async {
    // Basic test - app structure verification
    // Full widget tests would require mocking dependencies
    expect(true, isTrue);
  });
}
```

**Note**: The test is a placeholder that always passes. Full widget tests would require mocking dependencies (Hive, GetIt, etc.)

---

## Test Structure

### Missing Test Files

Based on the codebase structure, the following test files should exist but are missing:

| Expected Test File | Expected Coverage |
|-------------------|------------------|
| `test/manuscript_bloc_test.dart` | ManuscriptBloc unit tests |
| `test/intro_bloc_test.dart` | IntroBloc unit tests |
| `test/manuscript_repository_test.dart` | Repository tests |
| `test/audio_service_test.dart` | Service unit tests |
| `test/tts_service_test.dart` | TTS Service tests |
| `test/manuscript_page_model_test.dart` | Model/Hive tests |
| `test/manuscript_page_entity_test.dart` | Entity tests |

---

## BLoC Testing Patterns

### Expected Pattern for BLoC Tests

Based on the existing BLoC structure in `lib/features/manuscript/presentation/bloc/manuscript_bloc.dart`:

```dart
void main() {
  group('ManuscriptBloc', () {
    late ManuscriptBloc bloc;
    late MockManuscriptRepository mockRepository;
    late MockTtsService mockTtsService;
    late MockManuscriptLocalDataSource mockDataSource;
    late ManuscriptLocalizations mockL10n;

    setUp(() {
      mockRepository = MockManuscriptRepository();
      mockTtsService = MockTtsService();
      mockDataSource = MockManuscriptLocalDataSource();
      bloc = ManuscriptBloc(
        mockRepository,
        mockL10n,
        mockTtsService,
        mockDataSource,
      );
    });

    test('initial state is ManuscriptInitial', () {
      expect(bloc.state, equals(const ManuscriptInitial()));
    });

    blocTest<ManuscriptBloc, ManuscriptState>(
      'emits [Loading, Loaded] when LoadManuscriptPages is added',
      build: () {
        when(() => mockRepository.getManuscriptPages(mockL10n))
            .thenAnswer((_) async => []);
        when(() => mockDataSource.getChaptersForTts(mockL10n))
            .thenReturn([]);
        when(() => mockTtsService.initWithChapters(any()))
            .thenAnswer((_) async {});
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadManuscriptPages()),
      expect: () => [
        const ManuscriptLoading(),
        isA<ManuscriptLoaded>(),
      ],
    );

    blocTest<ManuscriptBloc, ManuscriptState>(
      'emits [Loading, Error] when repository throws',
      build: () {
        when(() => mockRepository.getManuscriptPages(mockL10n))
            .thenThrow(Exception('Test error'));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadManuscriptPages()),
      expect: () => [
        const ManuscriptLoading(),
        isA<ManuscriptError>(),
      ],
    );
  });
}
```

---

## Mocking Patterns

### Required Mocks

For proper testing, the following mocks would be needed:

| Mock | Location | Purpose |
|------|----------|---------|
| MockManuscriptRepository | `test/mocks/manuscript_repository.dart` | Stub repository |
| MockManuscriptLocalDataSource | `test/mocks/manuscript_local_datasource.dart` | Stub datasource |
| MockAudioService | `test/mocks/audio_service.dart` | Stub audio |
| MockTtsService | `test/mocks/tts_service.dart` | Stub TTS |

### Mock Example

```dart
class MockManuscriptRepository extends Mock implements ManuscriptRepository {}

class MockManuscriptLocalDataSource extends Mock
    implements ManuscriptLocalDataSource {}
```

---

## Entity and Model Testing

### ManuscriptPage Entity

From `lib/features/manuscript/domain/entities/manuscript_page.dart`:

```dart
void main() {
  group('ManuscriptPage', () {
    test('supports value equality', () {
      const page1 = ManuscriptPage(
        id: '1',
        title: 'Test',
        quote: 'Quote',
        imageAsset: 'test.png',
      );
      const page2 = ManuscriptPage(
        id: '1',
        title: 'Test',
        quote: 'Quote',
        imageAsset: 'test.png',
      );
      expect(page1, equals(page2));
    });

    test('copyWith creates new instance with updated values', () {
      const page = ManuscriptPage(
        id: '1',
        title: 'Test',
        quote: 'Quote',
        imageAsset: 'test.png',
        isLiked: false,
      );
      final likedPage = page.copyWith(isLiked: true);
      expect(likedPage.isLiked, isTrue);
      expect(page.isLiked, isFalse); // Original unchanged
    });

    test('props includes all fields for equality', () {
      const page = ManuscriptPage(
        id: '1',
        title: 'Test',
        quote: 'Quote',
        imageAsset: 'test.png',
        isLiked: false,
      );
      expect(page.props, hasLength(5));
    });
  });
}
```

### ManuscriptPageModel (Hive)

From `lib/features/manuscript/data/models/manuscript_page_model.dart`:

```dart
void main() {
  group('ManuscriptPageModel', () {
    test('can be created with default isLiked value', () {
      final model = ManuscriptPageModel(
        id: '1',
        title: 'Test',
        quote: 'Quote',
        imageAsset: 'test.png',
      );
      expect(model.isLiked, isFalse);
    });

    test('copyWith updates isLiked field', () {
      final model = ManuscriptPageModel(
        id: '1',
        title: 'Test',
        quote: 'Quote',
        imageAsset: 'test.png',
      );
      final liked = model.copyWith(isLiked: true);
      expect(liked.isLiked, isTrue);
    });
  });
}
```

---

## Service Testing

### AudioService Testing

From `lib/core/services/audio_service.dart`:

```dart
void main() {
  group('AudioService', () {
    late AudioService service;

    setUp(() {
      service = AudioService();
    });

    test('isMuted defaults to false', () {
      expect(service.isMuted, isFalse);
    });

    test('toggleMute flips isMuted state', () {
      expect(service.isMuted, isFalse);
      service.toggleMute();
      expect(service.isMuted, isTrue);
      service.toggleMute();
      expect(service.isMuted, isFalse);
    });

    test('playBackgroundMusic does nothing when muted', () async {
      service.toggleMute();
      // Should return early without throwing
      await service.playBackgroundMusic();
      expect(service.isMuted, isTrue);
    });
  });
}
```

**Key Points:**
- Singleton pattern requires careful test setup
- Consider dependency injection for easier mocking

---

## Integration Test Considerations

### App Integration Tests

For `test/widget_test.dart`, proper integration testing would require:

1. **Mocking Hive** - Initialize with in-memory box
2. **Mocking GetIt** - Register mock services
3. **Providing dependencies** - Via BlocProvider, etc.

### Example Setup

```dart
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    // Mock Hive
    Hive.init();
  });

  tearDownAll(() {
    // Clean up Hive
    Hive.close();
  });

  testWidgets('App shows intro page on launch', (tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(
            create: (_) => ThemeCubit(),
          ),
        ],
        child: MaterialApp(
          home: const IntroCoverPage(),
        ),
      ),
    );
    expect(find.byType(IntroCoverPage), findsOneWidget);
  });
}
```

---

## Test Coverage

### Current Coverage

- **Status**: No real test coverage
- **Existing Test**: Placeholder test only
- **Coverage**: ~0%

### Recommended Coverage Targets

| Layer | Target | Priority |
|-------|--------|----------|
| BLoC | 80%+ | High |
| Services | 70%+ | High |
| Entities | 90%+ | Medium |
| Models | 80%+ | Medium |
| Widgets | 50%+ | Low |

---

## Test Best Practices

### Unit Test Guidelines

1. **Test one thing per test** - Each test should verify a single behavior
2. **Use descriptive names** - `test('emits X when Y happens')`
3. **Follow AAA pattern** - Arrange, Act, Assert
4. **Test edge cases** - Null values, empty lists, errors

### BLoC Test Guidelines

1. **Test initial state** - Verify initial emissions
2. **Test state transitions** - Verify state changes
3. **Test error handling** - Verify error states
4. **Test event handling** - Mock dependencies

### Widget Test Guidelines

1. **Use `testWidgets`** - Widget tests wrap with this
2. **Use `pumpAndSettle`** - Wait for animations
3. **Provide dependencies** - Mock BLoC, services
4. **Find widgets** - Use `find.byType()`, `find.text()`

---

## Missing Test Infrastructure

### Mocks Directory

The project lacks a `test/mocks/` directory with:
- Mock repository classes
- Mock data source classes
- Mock service classes

### Test Helpers

The project lacks a `test/helpers/` directory with:
- Test data factories
- Common test setup utilities

### Widget Test Helpers

Missing helpers for:
- `pumpAppWithMocks()` - Pump widget with mocks
- `createTestSubject()` - Create bloc mock

---

*Testing analysis: 2026-04-11*