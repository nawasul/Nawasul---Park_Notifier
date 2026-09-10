# Nawasul Mobile App

**Nawasul** (نواصل) — *We Connect* — is a QR-based vehicle owner notification app for the Saudi/Gulf market. Vehicle owners register cars, receive a QR sticker, and get notified via automated call/push when someone scans it — without revealing their phone number.

Built in **Flutter** with **Riverpod** + **go_router**. Local preview via `flutter run -d chrome`.

## Design system

All visual tokens are defined in:

- [`docs/design.json`](docs/design.json) — machine-readable source of truth
- [`docs/DESIGN_SYSTEM.md`](docs/DESIGN_SYSTEM.md) — human-readable reference

### Approved color palette

| Token | Hex | Role |
|---|---|---|
| Dark | `#171717` | Headings, primary text |
| Accent | `#F2572B` | Buttons, links, active states |
| Grey | `#4D4D4D` | Secondary text, borders |
| Light | `#DEDEDE` | Page background |

Dart implementation: `lib/core/theme/` (`AppColors`, `AppTypography`, `AppSpacing`, `AppRadius`, `AppShadows`, `AppTheme`).

## Getting started

```bash
flutter pub get
flutter run -d chrome
flutter analyze
```

## Project structure

```
lib/
├── core/          # theme, router, mock data
├── features/      # feature-based screens (auth, home, vehicles, account, …)
└── shared/        # reusable widgets
```

Agent/development guide: [`agents.md`](agents.md) · Persistent rules: [`.cursorrules`](.cursorrules)

## Screens

28 screens implemented (auth 1–8, core app 9–18, account/support/legal 19–28). See [`agents.md`](agents.md) for the full route checklist.
