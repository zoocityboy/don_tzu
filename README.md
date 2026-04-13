# art_of_deal_war

![app icon](assets/app_icon.png)

A Flutter app that delivers a satirical, localized take on *The Art of War*. It includes theme settings, offline persistence, and build support for Android and Web.

[![PR Checks](https://github.com/zoocityboy/don_tzu/actions/workflows/pull_request.yml/badge.svg)](https://github.com/zoocityboy/don_tzu/actions/workflows/pull_request.yml)
[![Release](https://github.com/zoocityboy/don_tzu/actions/workflows/release.yml/badge.svg)](https://github.com/zoocityboy/don_tzu/actions/workflows/release.yml)

## What this project contains

- Flutter app with Android and Web targets
- Localized content and UI strings
- Theme and settings management
- Offline persistence using Hive
- GitHub Actions for PR validation and releases
- `release-please` based versioning from conventional commits

## Getting started

```bash
flutter pub get
flutter run
```

### Build targets

```bash
flutter build apk --release
flutter build web --release
```

## Development workflow

### Pull request verification

The `pull_request.yml` workflow runs on PRs to `main` and performs:

- Flutter SDK setup with caching
- dependency restore via `flutter pub get`
- `flutter analyze`
- `flutter test --coverage`
- Android debug APK build
- Web release build

### Release automation

The `release.yml` workflow runs on pushes to `main` and manual dispatch. It uses `release-please` to:

- derive the next Dart package version from conventional commit messages
- update `pubspec.yaml`
- tag the release
- generate changelog entries in `CHANGELOG.md`
- build Android and Web release artifacts
- upload the Android APK to the GitHub release

## Notes

This repository is prepared for downstream distribution workflows such as F-Droid by keeping release tags and artifacts in sync with conventional commit versioning.

## CI and Release

This repository includes GitHub Actions workflows for pull request verification and release automation.

- `pull_request.yml` runs on PRs to `main` and verifies the project on Ubuntu using:
  - Flutter SDK setup with caching
  - `flutter pub get` with cached pub dependencies
  - `flutter analyze`
  - `flutter test --coverage`
  - `flutter build apk --debug`
  - `flutter build web --release`

- `release.yml` runs on pushes to `main` and manual dispatch, and it uses `release-please` for conventional commit versioning:
  - `release-please` determines the next Dart version from commit messages
  - updates `pubspec.yaml`, tags the release, and generates changelog content
  - builds Android release APK and Web release
  - uploads the Android APK to the generated GitHub release

This workflow is designed to support downstream distribution paths such as F-Droid by keeping release tags and artifacts in sync.
