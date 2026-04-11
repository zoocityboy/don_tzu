# Phase 1: Polish & Ship - Context

**Gathered:** 2026-04-11
**Status:** Ready for planning
**Source:** User requirement via plan-phase

<domain>
## Phase Boundary

Add language parameter support to manuscript repository for localized quotes. The repository should accept language in format cs-CZ (locale format) and return proper translations. Optional: auto-detect system language.

</domain>

<decisions>
## Implementation Decisions

### Language Parameter
- Language format: cs-CZ (with region code, e.g., cs-CZ, de-DE, en-US)
- Parameter name: `language` in getManuscriptPages method
- Return: Proper translations based on locale

### Auto-Detection (Optional)
- If language not provided, auto-detect from system locale
- Fallback to default locale if unsupported

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Architecture
- `.planning/codebase/ARCHITECTURE.md` — Project architecture decisions
- `.planning/codebase/CONVENTIONS.md` — Code conventions

### Existing Implementation
- `lib/features/manuscript/domain/repositories/manuscript_repository.dart` — Current repository interface
- `lib/features/manuscript/data/repositories/manuscript_repository_impl.dart` — Repository implementation
- `lib/features/manuscript/l10n/generated/manuscript_localizations.dart` — Localization system

</canonical_refs>

<specifics>
## Specific Ideas

- Add language parameter (String locale, e.g., "cs-CZ") to getManuscriptPages
- Update ManuscriptLocalizations lookup to handle locale format
- Current supported locales: cs, de, en, hu, pl, sk (need to map cs-CZ → cs)
- Optional: implement auto-detect from device locale

</specifics>

<deferred>
## Deferred Ideas

- None — this is the initial feature requirement

</deferred>

---

*Phase: 01-polish-ship*
*Context gathered: 2026-04-11 via plan-phase*