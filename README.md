# MindFlow (知序)

MindFlow is a local-first personal app for tasks, structured knowledge, and a daily diary. It is designed for long-term personal use: there are no accounts, cloud sync, social features, learning plans, monetization, or AI diary features.

## Features

- Tasks: local CRUD, priorities, categories, dates, times, recurring rules, filters, completion, and timezone-aware local reminders.
- Knowledge: staged OpenAI-compatible generation, multi-level tree editing, graph view, prerequisite/related links, confirmed AI suggestions, checkpoint resume, undo history, Markdown export, PNG graph export, and local backup/recovery.
- Diary: local Markdown writing, autosave before close, dates, month navigation, calendar day filter, title/body search, tags, local image attachments, recent edits, word count, and image cleanup when entries are deleted.
- Settings: system/light/dark appearance, default task reminder time, notification permissions, knowledge-only AI settings, full data backup/restore, storage inspection, and confirmed data clearing.

Diary content is never sent to AI. AI features are only available from the knowledge module.

## Requirements

- Flutter stable (the project was initialized with Flutter 3.47.9 / Dart 3.13.7)
- Android SDK for Android builds; Xcode on macOS for iOS builds

## Flutter installation

On Windows, download the stable Flutter SDK from the official Flutter archive, extract it to a path without spaces (the current environment uses `D:\dev\flutter`), install Android Studio/SDK API 36, and add `<flutter>\bin` to `PATH`. Run `flutter doctor -v` and enable Windows Developer Mode before `flutter pub get` so plugin symlinks work. On macOS, install the stable Flutter SDK, Xcode, CocoaPods, and an iOS simulator or device.

## Setup

On Windows, enable Developer Mode so Flutter can create plugin symlinks. Add `D:\dev\flutter\bin` to your user `PATH`, then restart the terminal.

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

For the included Windows SDK layout, Flutter is installed at `D:\dev\flutter`, Android SDK at `D:\Android\Sdk`, and `D:\dev\flutter\bin` must be added to the user `PATH`. Windows Developer Mode is recommended so Flutter can create plugin symlinks.

## Android APK

The release artifact is generated at:

`build/app/outputs/flutter-apk/app-release.apk`

It is also copied to `release/app-release.apk` when the release build completes. Install it on an Android device with:

```sh
adb install -r release/app-release.apk
```

The current release build uses the Flutter debug signing key for local installation. Configure a private release keystore before distributing outside personal devices. Android notification permission and exact-alarm behavior still require validation on the target Android version.

## Knowledge AI configuration

Open `设置 → 知识体系 AI`. Enter an OpenAI-compatible Base URL (for example `https://api.openai.com/v1/`), model, API key, temperature, and maximum output tokens, then use `保存并测试`. The key is stored with `flutter_secure_storage` and is not included in backups. A client-side key can still be extracted from a compromised or instrumented device, so use restricted keys and spending limits.

Generation is persisted branch by branch. If a request stops, open the project and choose `继续 AI 生成`. AI suggestions show a before/after confirmation and never silently overwrite manual edits.

## Backup and restore

`设置 → 数据管理 → 导出本地数据` writes a timestamped JSON backup in the app documents directory. It contains tasks, reminders, categories, knowledge projects and relations, diary text, tags, and copied diary image bytes. API keys and theme preferences are excluded.

Import validates the format, record limits, IDs, references, parent cycles, dates, and image sizes. It creates new records with remapped IDs and never overwrites existing data. The individual knowledge workspace also supports Markdown, graph PNG, and knowledge-only `.mindflow.json` exports.

`清空本地数据` requires two confirmations, cancels task notifications, deletes business records, and removes diary image files. It does not delete AI credentials or theme preferences.

## Database design

See [DATABASE_DESIGN.md](DATABASE_DESIGN.md) for the Drift tables, foreign keys, migrations, date encoding, transaction boundaries, and backup mapping rules.

## Checks

```sh
dart format .
flutter analyze
flutter test
```

The final stage test suite covers task notification lifecycle, multi-level knowledge generation/resume, cycle protection, graph synchronization, Markdown and PNG export, diary CRUD/autosave/tags/images/month search, and full backup validation/recovery.

All primary data is stored locally. AI is reserved for optional knowledge features and must use a user-configured provider; diary content is never processed by AI. There are no accounts, cloud sync, social features, learning plans, or commercial features.

## Knowledge AI

Open **知识 → AI 设置** to enter an OpenAI-compatible API Base URL, model, API key, temperature, and maximum output tokens. The key is stored with `flutter_secure_storage`; provider requests, structured JSON validation, retry handling, branch checkpoints, and completeness suggestions are limited to the knowledge module. The API key is still present on the client device and can potentially be extracted from a compromised or instrumented app; use a key with restricted scope and spending limits. Never commit a real key.

Generation is split into an overall outline followed by independently persisted first-level branches. If a request is interrupted, open that project and choose **继续 AI 生成**. Existing completed branches stay local. Generated systems are suggestions rather than claims of completeness; the user can edit the tree, node Markdown, and prerequisite/related links at any time. Diary data is never included in AI requests.

Knowledge projects can be exported as Markdown and as a local `.mindflow.json` backup. Backup restoration imports a new project from a path entered on-device. PNG graph export captures the current graph viewport; for a large project, search/filter to a smaller set before exporting.

## Knowledge module checks

```sh
dart analyze
flutter test --no-pub
```

Android builds require Android SDK API 36. iOS builds require macOS and Xcode.
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

## iOS build

The complete `ios/` project is retained. On macOS, install Xcode and CocoaPods, open the project once with `open ios/Runner.xcworkspace`, select a signing team and bundle identifier, then run:

```sh
flutter pub get
flutter build ios --release
```

Use Xcode to configure signing and archive an IPA for a device or TestFlight. The iOS project includes the photo-library usage description, local notification plugin registration, and the app document storage used by Drift and diary images. This Windows environment cannot build, sign, install, or validate an iOS IPA.

## Common issues

- `Building with plugins requires symlink support`: enable Windows Developer Mode and restart the terminal.
- Android Gradle or SDK errors: install the SDK platform/build tools required by the Flutter stable version and check `flutter doctor -v`.
- Notifications do not appear: grant notification permission, allow exact alarms on Android where requested, and verify battery-optimization rules on the device.
- AI generation fails: test the Base URL and model in Settings, confirm the provider accepts `/chat/completions`, and retry the saved project; completed branches remain local.
- Image import fails: confirm photo permission and available app storage. Images are copied into the app documents directory; source gallery paths are not retained.

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
