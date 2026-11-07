# MindFlow Test Report

Environment: Flutter 3.47.9, Dart 3.13.7, Windows host, Android SDK API 36.

## Automated checks

- `flutter pub get`: passed.
- `flutter analyze`: passed with no issues.
- `flutter test`: passed. The suite covers 24 tests across task, knowledge, diary, data management, and navigation behavior.
- `flutter build apk --release`: passed; the installable APK is produced at `build/app/outputs/flutter-apk/app-release.apk`.

## Covered behavior

- Tasks: creation, editing, deletion, completion/undo, recurrence, reminder scheduling, notification cancellation, and default reminder settings.
- Knowledge: structured Mock AI generation, JSON validation/retry, branch checkpoint resume, multi-level persistence, edit/move/delete/copy, cycle protection, undo history, graph synchronization, large-tree loading, Markdown export, PNG byte/export path, backup restore, and AI HTTP adapter configuration.
- Diary: create/edit, Markdown content, debounced autosave before close, word count, month/day browsing data, title/body filtering, tags, copied local images, image preview/removal, deletion cleanup, and SQLite persistence after reopen.
- Data management: full export, strict validation, remapped non-overwriting restore, image base64 handling, storage counts, and two-step clear with image cleanup.

## Platform limits

- No Android device was connected during this run, so notification delivery, exact alarms, reboot restoration, photo picker behavior, and APK installation were not exercised on hardware.
- iOS compilation, signing, IPA creation, and device testing require macOS + Xcode and were not claimed here.
- The release APK uses the debug signing key for personal/local installation; production distribution needs a private release keystore.
