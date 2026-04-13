---
phase: 01-polish-ship
plan: '02'
completed_at: 2026-04-12T12:48:00Z
wave: '1'
status: complete
---

# Phase 1, Plan 2 — Summary

## Fix Analysis Warnings

**Status:** ✅ Complete

### Fixes Applied

1. **print() → debugPrint()** in TTS service (4 occurrences)
2. **Added on clauses** to catch blocks in TTS service (3 occurrences)
3. **Removed unused imports:**
   - manuscript_localizations.dart from app_router.dart
   - dart:io from settings_cubit.dart
   - theme_cubit.dart from manuscript_feed_page.dart

### Verification

flutter analyze results:
- Before: 23 issues (8 warnings, 15 infos)
- After: 5 warnings (remaining are minor inference/variable issues)

### Files Modified

- `lib/core/services/tts_service.dart`
- `lib/core/router/app_router.dart`
- `lib/core/theme/settings_cubit.dart`
- `lib/features/manuscript/presentation/pages/manuscript_feed_page.dart`

---

*Completed: 2026-04-12*