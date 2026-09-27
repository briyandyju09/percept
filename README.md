# Percept

> Notice more, understand better, react less.

## Stack

- **Framework:** Flutter (Dart, Cupertino UI)
- **State:** [Riverpod](https://riverpod.dev/) (`flutter_riverpod`)
- **Routing:** [go_router](https://pub.dev/packages/go_router)
- **Local storage:** [Hive CE](https://pub.dev/packages/hive_ce) (`hive_ce`, `hive_ce_flutter`) with code generation
- **Notifications:** `flutter_local_notifications` + `timezone`
- **CI:** Codemagic

## Description

Percept is a cross-platform app for training observation and everyday psychology — learning to
read situations and people, hold your composure, and grow as a person. It blends a structured
learning path with practice drills, case-file mysteries, a knowledge library, and daily missions
into a single "mentalist OS." It's local-first (no backend required), so your progress lives on
your device. The original concept doc lives in [`docs/idea.txt`](docs/idea.txt).

## Features

- **Today** — a daily-mission home screen to keep a practice streak.
- **Learn** — a structured lesson path on observation and psychology.
- **Practice** — a drills lab to apply what you've learned.
- **Library** — a browsable knowledge base.
- **Case Files** — mystery scenarios to test your reasoning.
- **Profile & onboarding** — an onboarding flow that sets up your profile; light/dark theming.
- **Daily reminders** — scheduled local notifications with timezone support.

## How to Build / Run

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # generates Hive adapters
flutter run
```

Percept targets Android, iOS, web, Windows, macOS, and Linux.

To (re)generate the launcher icon:

```bash
flutter pub run flutter_launcher_icons
```

## License

Released under the [MIT License](LICENSE).
