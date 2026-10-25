# Nawasul Mobile — Docs Index

> Superseded by [../../docs/updatedplan.md](../../docs/updatedplan.md). If this file conflicts with that plan, the plan wins.

Project documentation for the Flutter mobile app lives here.

| Document | Purpose |
|---|---|
| [AGENTS.md](./AGENTS.md) | Current phase, 4-tab navigation, screen map, providers, development log |
| [PHASE_CHECKLIST.md](./PHASE_CHECKLIST.md) | What is done (§3.1–§3.5 partial), what needs work, mock vs backend |
| [mock.md](./mock.md) | Mock login, session, OTP, language/locale, support, stickers, alerts, QR/scan |

**Current app shape (code-aligned):**

- Shell: `/home`, `/my-qr`, `/scan`, `/account` (bottom nav hidden on Scan)
- Pushed: `/vehicles`, `/alerts`, plus vehicle/QR/sticker/subscription/account/settings/legal routes
- Brand: orange `#F2572B` + dark `#171717` dashboard
- Data: `lib/core/mock/` + local Riverpod providers (no FastAPI yet)

**Root files (keep in place):**

- [`../README.md`](../README.md) — project entry / how to run
- [`../.cursorrules`](../.cursorrules) — permanent Cursor rules (not Markdown)

Do not put product/docs Markdown at the repo root except `README.md`.
