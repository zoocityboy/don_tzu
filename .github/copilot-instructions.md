<!-- Bootstrap instructions for Copilot-style assistants -->
# Repository assistant bootstrap

This repository already includes a comprehensive agent/dev guide at [AGENTS.md](../AGENTS.md). Create changes here only when you need a short, machine-friendly summary for automation or chat assistants.

## Purpose
- Provide a minimal set of instructions for AI assistants and CI bots to be productive immediately.

## Quickstart (commands)
- `flutter pub get`
- `flutter analyze` (or `flutter analyze --no-fatal-warnings`)
- `flutter test`
- `flutter pub run build_runner build --delete-conflicting-outputs` (generate Hive adapters)
- `flutter run -d <device_id>` or `flutter build apk --release`

## Key places to look
- Project agent/guide: [AGENTS.md](../AGENTS.md)
- App entry & providers: [lib/main.dart](../lib/main.dart)
- DI registration: [lib/injection_container.dart](../lib/injection_container.dart)
- Routing: [lib/core/router/app_router.dart](../lib/core/router/app_router.dart)
- Features: [lib/features/](../lib/features/)
- CI workflows: [.github/workflows/](../.github/workflows/)

## Conventions (short)
- Architecture: Feature-first, Clean Architecture (Domain → Data → Presentation).
- State management: `flutter_bloc` (Blocs/Cubits). Use `SafeEmitMixin` where applicable.
- DI: `get_it` pattern in `lib/injection_container.dart` (register singletons for app services; factories for feature use-cases/blocs).
- Persistence: `hive_ce` — run build_runner after model changes.

## Agent behavior hints
- Prefer to `link` to existing docs (AGENTS.md, README.md) instead of duplicating.
- When editing code: run `flutter analyze` and `flutter test` locally (or via CI) before proposing merges.
- For changes impacting DI or routing, run quick local smoke (`flutter run` or `flutter build apk`) where feasible.

---
If you'd like, I can expand this with example prompts for common tasks (e.g., "run tests", "add a feature scaffold", "create DI registration"), or create applyTo-based instructions scoped to `lib/features/*`.

## Example assistant prompts
- "Run the test suite and return failing tests only."
- "Create a new feature scaffold named `quotes` with data/domain/presentation folders and DI registration."
- "Add a `flutter_test` that asserts `ManuscriptBloc` emits loading then success states for sample data." 
- "List files that register singletons in `lib/injection_container.dart`."
- "Explain how to regenerate Hive adapters and show the exact command to run." 

## Suggested applyTo-based instructions
- Scope: `lib/features/*` — guidance for feature scaffolding, DI registration, and Bloc conventions.
- Scope: `lib/core/*` — guidance for routing, global services, and lifecycle rules (e.g., TTS/audio cleanup).
- Scope: `.github/workflows/*` — CI expectations and commands to validate before merging.

These scoped `applyTo` files can be added when you want targeted assistant behavior for specific parts of the repo.
