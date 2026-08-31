# Nawasul — Agent Development Guide

> **Permanent rules:** See [`.cursorrules`](.cursorrules) for architecture, theme, brand, and code-quality standards.

## Current phase

**Core App Screens 9–18** — COMPLETE (with minimal Alerts + Account shell tabs)

| In scope | Out of scope |
|---|---|
| Screens 9–18 + shell tabs | Backend / API |
| go_router + Riverpod | Real payments / image picker |
| Mock data layer | Screens 19–23 (Profile/Settings expansion) |

---

## Navigation architecture

- **Auth routes (1–8):** no bottom nav — `/` through `/account-setup`
- **Shell routes:** `StatefulShellRoute.indexedStack` + `google_nav_bar` — `/home`, `/vehicles`, `/my-qr`, `/alerts`, `/account`
- **Pushed routes:** vehicle details, add/edit, QR, sticker order, alert detail, subscription flow

---

## Screen checklist (9–18)

| # | Screen | Route | Status |
|---|---|---|---|
| 9 | Home / Dashboard | `/home` | [x] |
| 10 | My Vehicles | `/vehicles` | [x] |
| 11 | Add/Edit Vehicle | `/vehicles/add`, `/vehicles/:id/edit` | [x] |
| 12 | Vehicle Details | `/vehicles/:id` | [x] |
| 13 | My QR Code | `/vehicles/:id/qr` | [x] |
| 14 | QR Sticker Order | `/vehicles/:id/sticker-order` | [x] |
| 15 | Sticker Order Status | `/sticker-orders/:id` | [x] |
| 16 | Alert Detail | `/alerts/:id` | [x] |
| 17 | Subscription Plans | `/subscription/plans` | [x] |
| 18 | Checkout + Success | `/subscription/checkout`, `/subscription/success` | [x] |

**Shell tab helpers:** AlertsListScreen (`/alerts`), AccountScreen (`/account`), MyQrTabScreen (`/my-qr`)

---

## Shared widgets (core batch)

StatusPill, VehicleCard, AlertListItem, EmptyStateWidget, ConfirmationDialog, QuantityStepper, StepperTimeline, PlanCard, SearchField, BillingCycleToggle

---

## State management

- `vehicleProvider` — List<Vehicle> with add/update/delete
- `subscriptionProvider` — plan tier, billing cycle, checkout selection
- `alertsProvider` — mock alerts (read-only this phase)

---

## Performance rules (still apply)

- NO Lottie, Rive, BackdropFilter, ImageFilter
- Shadows via `AppShadows` presets only
- `flutter_staggered_animations` only on plan cards (3) and auth onboarding/language
