# Roadmap - The Art of Deal War

**Generated:** 2026-04-11 after initialization
**Version:** 1.0.0
**Phases:** 2 | **Requirements:** 12 mapped | All v1 requirements covered ✓

## Overview

| # | Phase | Goal | Requirements | Success Criteria |
|---|-------|------|--------------|------------------|
| 1 | Polish & Ship | Fix issues and prepare release | REQ-001 to REQ-012 | 6 criteria |
| 2 | Features | Settings + TTS generation | REQ-SETTINGS, REQ-TTS | 4 criteria |

## Phase Details

### Phase 1: Polish & Ship

**Goal:** Address code issues, fix localization problems, and prepare for production release.

**Requirements:** REQ-001, REQ-002, REQ-003, REQ-004, REQ-005, REQ-006, REQ-007, REQ-008, REQ-009, REQ-010, REQ-011, REQ-012, LANG-01

**Success criteria:**
1. Fix localization import errors in manuscript_localizations.dart
2. Replace print() with debugPrint() in TTS service
3. Add on clauses to catch blocks (analysis warnings)
4. Verify all 12 requirements tested and passing
5. Build APK successfully (debug)
6. Code analysis passes with no errors
7. Language parameter support (cs-CZ format)
8. Proper translations based on locale

**Plans:**
- [ ] 01-01-PLAN.md — Language parameter support
- [ ] 02-01-PLAN.md — Fix analysis warnings (print, catch blocks)

### Phase 2: Features

**Goal:** Implement settings with repository pattern and TTS generation improvements.

**Requirements:** REQ-SETTINGS (user preferences), REQ-TTS (enhanced TTS)

**Success criteria:**
1. Settings repository with data source pattern
2. TTS generation improvements
3. Clean architecture compliance
4. flutter analyze passes

**Plans:**
- [x] 02-01-PLAN.md — Settings repository

---

**Next step:** Run `/gsd-plan-phase 1` to begin execution.