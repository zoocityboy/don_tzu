# The Art of Deal War - Project Context

**Project Type:** Flutter Mobile Application (Parody/Satirical Content)
**Last Updated:** 2026-04-11 after initialization

## What This Is

A satirical mobile app featuring "2500-year-old military scrolls" with humorous business/dealership quotes attributed to fictional Commander-in-Chief "Don Tzu". The app presents these as newly discovered ancient manuscripts with dramatic intro animation and text-to-speech audio.

## Core Value

Deliver an engaging, humorous reading experience with atmospheric presentation (animated intro, TTS audio, parchment UI) across multiple languages.

## Context

**Platform:** Flutter (iOS, Android, Web)
**State Management:** BLoC pattern with flutter_bloc
**DI:** get_it
**Storage:** hive_ce
**Architecture:** Clean Architecture (Domain → Data → Presentation)

## Requirements

### Validated

- ✓ Intro cover page with story narrative — existing
- ✓ Manuscript feed with satirical quotes — existing
- ✓ Text-to-speech audio generation using edge_tts — existing
- ✓ Multi-language localization (cs, de, hu, pl, sk, en) — existing
- ✓ BLoC state management pattern — existing
- ✓ GoRouter navigation (/intro, /home) — existing
- ✓ Background audio (walen-lonely-samurai.mp3) — existing

### Active

- [ ] Fix localization import errors in generated files
- [ ] Complete any missing features from initial spec

### Out of Scope

- User accounts/authentication
- Cloud sync or backend services
- Push notifications

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Use edge_tts for TTS | Generates MP3 files locally, no API costs | Implemented |
| Per-feature localization | Better separation than single app_en.arb | Implemented (manuscript_en.arb, app_en.arb) |
| BLoC pattern for intro | Follows AGENTS.md requirement | Implemented via IntroBloc |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd-transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd-complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state