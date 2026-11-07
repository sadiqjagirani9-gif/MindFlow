# MindFlow (知序) Project Plan

## Product boundaries

MindFlow is a local-first personal app with three modules: tasks, a structured knowledge system, and a daily diary. It has no accounts, sync, social features, monetization, learning plans, or AI diary features. AI is only an optional, separately configured knowledge-generation provider.

## Delivery stages

1. Foundation: Flutter app structure, navigation, themes, local Drift database, home dashboard, and starter task/knowledge/diary/settings screens.
2. Tasks: CRUD, categories, filters and views, recurrence rules, local notifications, and tests.
3. Knowledge: structured staged AI generation; editable multi-level tree and knowledge graph; relations; confirmed AI suggestions; edit history; Markdown and local backup export/recovery.
4. Diary: dated entries, Markdown, tags, local images, month/day navigation, title/body search, recent edits, word count, and autosave; no AI assistance or monthly review.
5. Stabilization: migrations, accessibility, Android/iOS checks, data management, backup/export, release build, and test report.

## Architecture

- Presentation: Flutter widgets and Riverpod controllers/providers.
- Domain: module-owned entities and use cases, separated from widgets and storage.
- Data: repositories and adapters, with Drift as the local persistence layer.
- Shared services: local notification scheduling, secure storage, and optional Dio-based AI providers.
- Routing: go_router with a four-tab shell; app-wide light, dark, and system themes.

## Initial environment

- Flutter 3.47.9 stable and Dart 3.13.7 installed at `D:\dev\flutter`.
- Android SDK at `D:\Android\Sdk`, currently missing API 36 and Android BuildTools 28.0.3 required by this Flutter release.
- No Android device is connected. Windows, Chrome, and Edge are available.
- Flutter Doctor reports intermittent network timeouts to Maven Central and GitHub.

## Current implementation

- Foundation: four-tab navigation, system/light/dark theme with local persistence, home dashboard, settings, and schema version 4 Drift database.
- Tasks: local CRUD, default/custom categories, today/all/completed/overdue views, category/priority filtering, time/priority/category sorting, due date/time, reminder time, daily/weekly/custom intervals, completion/undo, and recurring instances.
- Notifications: timezone-aware local scheduling, Android/iOS permission requests, exact-alarm fallback, boot restoration receiver, edit/delete/completion cancellation, and timezone refresh when the app resumes.
- Knowledge: OpenAI-compatible provider configuration, secure API-key storage, staged JSON generation with retries and per-branch checkpoints, recursive content, completeness findings, node create/edit/move/copy/delete, cycle protection, tree/graph views, prerequisite/related links, history undo, Markdown export, JSON backup/recovery, and PNG graph capture.
- Diary: local Markdown editor with debounced autosave and close-time flush, date/month/calendar navigation, title/body search, recent-edits sort, tags, word count, image picker copied into app storage, image preview/removal, delete cleanup, and persistence tests.
- Settings/data management: knowledge-only AI configuration dialog, system/light/dark themes, default task reminder time, notification permissions, full validated non-overwriting backup/restore, storage inspection, two-step clear, and task reminder rescheduling.
- Platform: Android photo/notification/network permissions and iOS photo-library usage description/local notification delegate configured. Android release APK builds successfully. Real device notification/photo/install checks and iOS compilation still require hardware/macOS.
- Verification: full mocked knowledge, task, diary, data-management, PNG/Markdown export, large-tree, and navigation suite passes; analyzer passes.

## Decisions

- Keep all primary user data on-device. AI provider credentials are never source-controlled and should be stored in secure storage.
- Persist task date/time and recurrence rule separately from platform notification IDs.
- Use schema versioning and explicit migrations from the first database schema.
- Treat knowledge and diary as separate domains; diary content is never sent to AI.
- Keep generation checkpoints in the existing `generationStatus` JSON column. Persist each completed branch before requesting the next branch so an interrupted run can resume without losing prior work.
