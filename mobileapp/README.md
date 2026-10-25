# Nawasul Mobile App

Flutter client for **Nawasul** (نواصل) — QR-based vehicle owner notification for the Saudi/Gulf market.

## Docs

All project Markdown (except this file) lives in [`docs/`](./docs/):

| Doc | Description |
|---|---|
| [docs/README.md](./docs/README.md) | Docs index |
| [docs/AGENTS.md](./docs/AGENTS.md) | Phase notes, navigation, screen map, development log |
| [docs/PHASE_CHECKLIST.md](./docs/PHASE_CHECKLIST.md) | Completed vs pending; mock vs backend |
| [docs/mock.md](./docs/mock.md) | Mock login credentials, session, OTP, support channels |

Permanent Cursor rules: [`.cursorrules`](./.cursorrules)

## Run

### Primary — web preview (Chrome)

This phase’s default target (see `.cursorrules`):

```bash
flutter pub get
flutter run -d chrome
```

Camera QR scan on `/scan` uses a **web-safe stub** in Chrome. Profile “Take photo” is also stubbed on web.

### Android / iOS (when a device is available)

Native camera/scan/photo need a connected device or emulator. List targets, then run with an id:

```bash
flutter devices
flutter run -d <device_id>
```

Examples: physical phone, Android emulator, or iOS simulator (when the Flutter toolchain can see them). Use this for:

- Real QR camera scanning (`mobile_scanner` on `/scan`)
- Profile “Take photo” (`image_picker` camera)

Web preview remains enough for most UI work.

## Stack

- Flutter + Material 3
- Riverpod
- go_router (`StatefulShellRoute` + custom `AppBottomNavBar`)
- Lightweight EN/AR strings (`lib/core/l10n/app_strings.dart`) + locale/RTL from `appLanguageProvider`
- Mock data layer (`lib/core/mock/`) until backend APIs are connected

## Status (short)

UI prototype on **mock data**: auth/session, vehicles, QR, stickers, alerts, subscription, account/settings, and Scan are navigable.

- **Shell tabs (4):** Home · QR · Scan · Account
- **Pushed:** `/vehicles`, `/alerts`, vehicle/sticker/subscription/profile/settings/legal/support flows
- **Look:** orange `#F2572B` hero + black `#171717` dashboard / shell
- **Auth:** mock phone/password + `sessionProvider` (`mock_is_logged_in`) — credentials in [docs/mock.md](./docs/mock.md)
- **i18n:** foundation + Login / bottom nav / Home (dashboard); remaining screens still English
- **Not wired yet:** real backend/API client, real payments, full-app string extraction

Backlog: [docs/PHASE_CHECKLIST.md](./docs/PHASE_CHECKLIST.md)
