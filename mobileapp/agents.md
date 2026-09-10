# Nawasul — Agent Development Guide

> **Permanent rules:** See [`.cursorrules`](.cursorrules) for architecture, theme, brand, and code-quality standards.
> **Design system:** See [`docs/design.json`](docs/design.json) and [`docs/DESIGN_SYSTEM.md`](docs/DESIGN_SYSTEM.md).

## Current phase

**Screens 1–28** — COMPLETE (auth, core app, account, support, legal)

| In scope | Out of scope |
|---|---|
| Screens 1–28 + shell tabs | Backend / API |
| go_router + Riverpod | Real payments / image picker |

---

## Color scheme (approved)

| Token | Hex | Dart constant |
|---|---|---|
| Dark | `#171717` | `AppColors.brandDark` / `AppColors.textPrimary` |
| Accent | `#F2572B` | `AppColors.primary` |
| Grey | `#4D4D4D` | `AppColors.secondary` |
| Light | `#DEDEDE` | `AppColors.background` |

Material 3 seed: `#F2572B`. Theme files mirror `docs/design.json`.

---

## Navigation architecture

- **Auth routes (1–8):** no bottom nav — `/` through `/account-setup`
- **Shell routes:** `StatefulShellRoute.indexedStack` + `google_nav_bar` — `/home`, `/vehicles`, `/my-qr`, `/alerts`, `/account`
- **Pushed routes:** vehicle details, add/edit, QR, sticker order, alert detail, subscription, profile, settings, support, legal

---

## Screen checklist (1–28)

| # | Screen | Route | Status |
|---|---|---|---|
| 1 | Splash | `/` | [x] |
| 2 | Onboarding | `/onboarding` | [x] |
| 3 | Language Selection | `/language` | [x] |
| 4 | Login | `/login` | [x] |
| 5 | Register | `/register` | [x] |
| 6 | OTP Verification | `/otp` | [x] |
| 7 | Forgot Password | `/forgot-password` | [x] |
| 8 | Account Setup | `/account-setup` | [x] |
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
| 19 | Profile | `/account` | [x] |
| 20 | Edit Profile | `/profile/edit` | [x] |
| 21 | Settings | `/settings` | [x] |
| 22 | Notification Preferences | `/settings/notifications` | [x] |
| 23 | Language & Region | `/settings/language` | [x] |
| 24 | Help / FAQ | `/help` | [x] |
| 25 | Contact Support | `/support/contact` | [x] |
| 26 | Privacy Policy | `/legal/privacy` | [x] |
| 27 | Terms & Conditions | `/legal/terms` | [x] |
| 28 | Delete Account | `/account/delete` | [x] |

**Shell tab helpers:** AlertsListScreen (`/alerts`), ProfileScreen (`/account`), MyQrTabScreen (`/my-qr`)

---

## Shared widgets (core batch)

StatusPill, VehicleCard, AlertListItem, EmptyStateWidget, ConfirmationDialog, QuantityStepper, StepperTimeline, PlanCard, SearchField, BillingCycleToggle, ProfileMenuItem, ToggleSettingRow, ExpandableFAQItem, LegalDocumentScreen, RadioOptionList, DestructiveButton, CitySelectField

---

## State management

- `vehicleProvider` — List<Vehicle> with add/update/delete
- `subscriptionProvider` — plan tier, billing cycle, checkout selection
- `alertsProvider` — mock alerts (read-only this phase)
- `profileProvider` — editable mock user profile
- `notificationPreferencesProvider` / `appLanguageProvider` — settings

---

## Performance rules (still apply)

- NO Lottie, Rive, BackdropFilter, ImageFilter
- Shadows via `AppShadows` presets only
- `flutter_staggered_animations` only on plan cards (3) and auth onboarding/language
