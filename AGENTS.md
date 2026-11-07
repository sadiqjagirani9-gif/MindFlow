# MindFlow contributor notes

- Keep task, knowledge, diary, and settings code inside their feature modules.
- Keep widgets presentation-only; persistence belongs behind repositories.
- Preserve local-first operation. Never introduce accounts, cloud sync, social/monetization features, or AI diary processing.
- Do not put secrets or API keys in source, assets, examples, or committed configuration.
- Add Drift schema migrations when changing persisted tables and cover domain behavior with tests.
- Run `dart format .`, `flutter analyze`, and relevant `flutter test` targets for changes.
- Do not claim platform notification behavior is verified without running on Android and iOS.
