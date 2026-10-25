# Nawasul — Agent Development Guide

> Superseded by [../../docs/updatedplan.md](../../docs/updatedplan.md). If this file conflicts with that plan, the plan wins.

> **Permanent rules:** See [`.cursorrules`](../.cursorrules) for architecture, theme, brand, and code-quality standards.
>
> **Work backlog:** See [PHASE_CHECKLIST.md](./PHASE_CHECKLIST.md) for completed vs pending work and backend dependencies.

## Current phase

**Frontend prototype checklist complete except live backend.** Auth through account/settings/legal are built. **§3.1–§3.5** done (EN/AR labels/titles/buttons including low-traffic screens; intentional skips: legal/FAQ/plan-feature CMS bodies). **§4:** `AppConfig` + `ApiClient` stub + domain mock repositories **wired to screens** (auth, profile, vehicles CRUD, alerts, subscription, sticker, support, legal) behind `useMockData=true`. Real FastAPI HTTP, tokens, payments, and FCM are **not** done. Camera QR scan works on mobile; Chrome uses a safe stub.

| In scope now | Out of scope until decided |
|---|---|
| Screen UI + go_router + Riverpod | Live FastAPI HTTP / real tokens |
| Mock data layer (`lib/core/mock/`) + [mock.md](./mock.md) | Real payments / gateways |
| Domain repositories behind `AppConfig.useMockData` (auth/profile/vehicles/alerts/subscription/sticker/support/legal) | Real photo upload / ticket APIs / CMS |
| Local providers (session, vehicles, subscription, alerts, profile, stickers, support, language) | Production push notifications (FCM) |
| Web preview (`flutter run -d chrome`); device targets for camera when available | |

## Navigation architecture

- **Auth routes (1–8):** no bottom nav — `/` through `/account-setup`
- **Shell routes:** `StatefulShellRoute.indexedStack` + custom `AppBottomNavBar` (4 tabs)
  - `/home`, `/my-qr`, `/scan`, `/account`
  - Bottom nav **hidden** on Scan for full-screen camera
- **Pushed routes:** `/vehicles`, `/alerts`, vehicle details/add/edit/QR, sticker order, alert detail, subscription, profile/settings/legal/support

## Screen map (current)

### Auth / onboarding

| Screen | Route | UI | Backend |
|---|---|---|---|
| Splash | `/` | Done | N/A (local) |
| Onboarding | `/onboarding` | Done | N/A |
| Language | `/language` | Done | Locale API later |
| Login | `/login` | Done (mock → `/home` via `AuthRepository`) | Mock creds → API later |
| Register | `/register` | Done (via `AuthRepository.register` + `sendOtp`) | Mock → API later |
| OTP | `/otp` | Done (verify via `AuthRepository`) | Mock OTP → API |
| Forgot password | `/forgot-password` | Done (via `AuthRepository` → `/login`) | Mock OTP → API later |
| Account setup | `/account-setup` | Done (profile name/city via `ProfileRepository`) | Mock → API |

### Core product (9–18)

| # | Screen | Route | UI |
|---|---|---|---|
| 9 | Home / Dashboard | `/home` | Done (orange hero + black content) |
| 10 | My Vehicles | `/vehicles` (pushed) | Done |
| 11 | Add/Edit Vehicle | `/vehicles/add`, `/vehicles/:id/edit` | Done |
| 12 | Vehicle Details | `/vehicles/:id` | Done |
| 13 | My QR Code | `/vehicles/:id/qr` | Done (share clipboard + download mock dialog) |
| 14 | QR Sticker Order | `/vehicles/:id/sticker-order` | Done (unique mock order IDs) |
| 15 | Sticker Order Status | `/sticker-orders/:id` | Done (loads order by id) |
| 16 | Alert Detail | `/alerts/:id` | Done |
| 17 | Subscription Plans | `/subscription/plans` | Done |
| 18 | Checkout + Success | `/subscription/checkout`, `/subscription/success` | Done (no real payment) |

### Shell helpers + account expansion

| Screen | Route | UI |
|---|---|---|
| My QR tab | `/my-qr` | Done |
| Scan tab | `/scan` | Done (mobile camera; web stub) |
| Alerts list | `/alerts` (pushed) | Done (mark-read, empty, pull-to-refresh) |
| Account / Profile | `/account` | Done |
| Edit profile | `/profile/edit` | Done (local photo preview via `image_picker`) |
| Settings | `/settings` | Done |
| Notification prefs | `/settings/notifications` | Done (local only) |
| Language & region | `/settings/language` | Done (persisted locale + EN/AR strings) |
| Help / FAQ | `/help` | Done (`SupportRepository.fetchFaq`) |
| Contact support | `/support/contact` | Done (channels + inbox via `SupportRepository`) |
| Privacy / Terms | `/legal/*` | Done (`LegalRepository` → mock copy) |
| Delete account | `/account/delete` | Done (clears mock session) |

## Shared widgets (core batch)

StatusPill, VehicleCard, AlertListItem, EmptyStateWidget, ConfirmationDialog, QuantityStepper, StepperTimeline, PlanCard, SearchField, BillingCycleToggle, PrimaryButton, AppTextField, PhoneInputField, AppLogo, AppBottomNavBar, …

## State management (current)

| Provider | Role | Source today |
|---|---|---|
| `authRepositoryProvider` | Login / register / OTP / forgot-reset / session / logout / delete | `MockAuthRepository` → `MockAuthData` + prefs |
| `vehicleRepositoryProvider` | Fetch + add/update/delete | `MockVehicleRepository` |
| `profileRepositoryProvider` | Profile read/update/photo | `MockProfileRepository` |
| `alertsRepositoryProvider` | Alert seed / refresh / mark-read / mark-all | `MockAlertsRepository` |
| `subscriptionRepositoryProvider` | Plans + confirm plan | `MockSubscriptionRepository` |
| `stickerOrderRepositoryProvider` | Place / ensure / list orders | `MockStickerOrderRepository` |
| `supportRepositoryProvider` | FAQ + tickets + channels | `MockSupportRepository` |
| `legalRepositoryProvider` | Privacy / terms sections | `MockLegalRepository` |
| `apiClientProvider` | HTTP façade (stub) | Throws while `useMockData` |
| `vehicleProvider` | List add/update/delete; `reload()` | Delegates to `VehicleRepository` |
| `subscriptionProvider` | Plan / billing / checkout | `MockSubscription` + repo confirm |
| `alertsProvider` | Alerts list + mark-read + refresh | Delegates to `AlertsRepository` |
| `profileProvider` | Profile user + local `photoBytes` | Delegates to `ProfileRepository` |
| `sessionProvider` | Mock logged-in flag | `AuthRepository` → SharedPreferences `mock_is_logged_in` |
| `appLanguageProvider` | EN/AR locale preference | SharedPreferences `app_language` (`en`/`ar`) |
| Settings providers | Notification toggles / prefs | Local Riverpod |
| `supportInboxProvider` | Contact-form mock tickets | `SupportRepository` (in-memory) |
| `stickerOrdersProvider` | Sticker orders by id | `StickerOrderRepository` (in-memory) |

## Theme (current)

Orange/black brand tokens in `AppColors`: primary `#F2572B`, brandDark `#171717`, grey `#4D4D4D`, light `#DEDEDE`. Dashboard uses orange status-bar hero + black content; shell nav is black with orange active state.

## Performance rules (still apply)

- NO Lottie, Rive, BackdropFilter, ImageFilter
- Shadows via `AppShadows` presets only
- `flutter_staggered_animations` only on plan cards (3) and auth onboarding/language

## Docs layout

```
mobileapp/
  README.md              ← only root Markdown (how to run)
  .cursorrules           ← permanent Cursor rules
  docs/
    README.md            ← docs index
    AGENTS.md            ← this file (architecture + development log)
    PHASE_CHECKLIST.md   ← backlog + backend vs mock
    mock.md              ← mock credentials / sample users
```

---

## Development log

Append-only. Newest entries at the bottom.

### 2026-09-14 — Login mock auth → `/home`

- **What:** Wired login form to controllers; validate against `MockAuthData.authenticate()`; on success `context.go(AppRoutes.home)`.
- **Files:** `lib/features/auth/presentation/login_screen.dart`, `lib/core/mock/mock_auth_data.dart`, `docs/mock.md` (created), `docs/PHASE_CHECKLIST.md`, `docs/AGENTS.md`
- **Mock credentials:** See [mock.md](./mock.md) (phone `5123454821` / password `Nawasul@123`)
- **Not done:** Forgot password, auth guard, other checklist items

### 2026-09-14 — Auth guard (mock session)

- **What:** Added `sessionProvider` (SharedPreferences `mock_is_logged_in`). Splash → `/home` if logged in, else onboarding. Login + account-setup set flag; logout + delete-account clear it.
- **Files:** `lib/features/auth/presentation/providers/session_provider.dart`, `splash_screen.dart`, `login_screen.dart`, `account_setup_screen.dart`, `profile_screen.dart`, `delete_account_screen.dart`, `docs/mock.md`, `docs/PHASE_CHECKLIST.md`, `docs/AGENTS.md`; dep `shared_preferences`
- **Next checklist item:** §3.1 **Forgot password** — steps mostly print; wire mock success → login

### 2026-09-14 — Forgot password mock flow → `/login`

- **What:** Wired forgot-password steps: validate phone via `MockAuthData.findUserByPhone()`, OTP via `mockOtp` / `verifyOtp()`, new password + confirm, then snackbar and `context.go(AppRoutes.login)`. Removed debugPrint-only progression.
- **Files:** `forgot_password_screen.dart`, `mock_auth_data.dart`, `docs/mock.md`, `docs/PHASE_CHECKLIST.md`, `docs/AGENTS.md`
- **Mock OTP:** `123456` (see [mock.md](./mock.md)); reset does not change shared login password
- **Next checklist item:** §3.2 Dashboard / navigation product decisions (or first open item under §3.3 if product decisions are deferred)

### 2026-09-14 — §3.2 Dashboard + 4-tab nav + Scan

- **What:** Locked product decisions implemented: orange hero (`#F2572B`) + black content (`#171717`) dashboard (no CTAs in hero; name/plan from `profileProvider` / `subscriptionProvider`); shell reduced to **Home · QR · Scan · Account**; Vehicles & Alerts moved to pushed routes with dashboard “View all” links; Scan tab with `mobile_scanner` + permissions + `url_launcher` (http/https open externally, non-URL result sheet, duplicate-scan lock); web-safe stub; bottom nav hidden on Scan.
- **Files:** `app_colors.dart`, `app_shadows.dart`, `app_typography.dart`, `app_theme.dart`, `app_routes.dart`, `app_router.dart`, `main_shell.dart`, `app_bottom_nav_bar.dart`, `home_screen.dart` + dashboard widgets, `scan/` feature, vehicles/alerts list back affordances, Android/iOS camera permissions, `pubspec.yaml` (`mobile_scanner`, `permission_handler`, `url_launcher`; removed `google_nav_bar`)
- **Next:** §3.3 remaining items (photo upload, support channels, etc.)

### 2026-09-14 — §3.3 QR share/download mock clarity

- **What:** Share copies `MockVehicles.shareUrl(id)` (`https://nawasul.app/qr/{id}`) to clipboard with explicit snackbar; Download shows an explanatory mock “saved PNG” dialog; QR payload uses the same mock URL.
- **Files:** `my_qr_code_screen.dart`, `my_qr_tab_screen.dart`, `mock_vehicles.dart`, docs
- **Next checklist item:** §3.3 **Photo upload on edit profile** — image picker or explicit “coming soon”

### 2026-09-14 — §3.3 Edit profile photo (local preview)

- **What:** Avatar tap opens a bottom sheet: Choose photo (`image_picker` gallery/file — works on web), Take photo (mobile; web shows not-available), Use sample photo (`MockAuthData.mockProfilePhotoPng`), Remove. Bytes stored on `MockUser.photoBytes` via `profileProvider` for in-session preview only (no upload). Shared `ProfileAvatar` on Account + Edit Profile.
- **Files:** `edit_profile_screen.dart`, `profile_screen.dart`, `profile_avatar.dart`, `profile_provider.dart`, `mock_auth_data.dart`, `pubspec.yaml` (`image_picker`), iOS photo usage strings, docs
- **Next checklist item:** §3.3 **Contact support channels (Call / WhatsApp / Email)** — deep links or keep stubs

### 2026-09-14 — §3.3 Contact support channels (deep links)

- **What:** Replaced Call / WhatsApp / Email “coming soon” stubs with `url_launcher` deep links from `MockSupport` (`tel:+966920001234`, `https://wa.me/966920001234`, `mailto:support@nawasul.app`). Launch failure shows snackbar. Android `queries` + iOS `LSApplicationQueriesSchemes` for tel/mailto.
- **Files:** `contact_support_screen.dart`, `mock_support.dart`, `AndroidManifest.xml`, `Info.plist`, `docs/mock.md`, `docs/PHASE_CHECKLIST.md`, `docs/AGENTS.md`
- **Next checklist item:** §3.3 **Contact form “sent successfully”** — persist to mock inbox or queue for backend

### 2026-09-14 — §3.3 Contact form mock inbox

- **What:** Contact form submit stores `MockSupportTicket` in `supportInboxProvider` (in-memory, newest first); keeps success snackbar; shows light **Recent messages (N)** list (up to 5) on the same screen. No backend / no SharedPreferences.
- **Files:** `contact_support_screen.dart`, `support_inbox_provider.dart`, `mock_support.dart`, `docs/mock.md`, `docs/PHASE_CHECKLIST.md`, `docs/AGENTS.md`
- **Next checklist item:** §3.3 **Sticker order** — generate unique mock order IDs instead of always sample order

### 2026-09-14 — §3.3 Sticker order unique mock IDs

- **What:** Place Order creates a unique `order-{timestamp}` via `MockStickerOrders.create()` + `stickerOrdersProvider.placeOrder()`, then navigates to `/sticker-orders/{id}`. Status screen loads that order (shows Order ID); unknown ids get `ensureById()` mock record. Seed `order-001` retained.
- **Files:** `mock_sticker_orders.dart`, `sticker_orders_provider.dart`, `sticker_order_screen.dart`, `sticker_order_status_screen.dart`, `docs/mock.md`, `docs/PHASE_CHECKLIST.md`, `docs/AGENTS.md`
- **Next checklist item:** §3.3 **Alerts** — mark as read / empty states / pull-to-refresh (still `MOCK`)

### 2026-09-14 — §3.3 Alerts mark-read / empty / pull-to-refresh

- **What:** Upgraded `alertsProvider` to a Riverpod notifier with `isRead`, mark-as-read (opens detail + Mark all read), empty state, and pull-to-refresh that re-seeds via `MockAlerts.seed()`. Light unread styling on list + dashboard tiles. Moved alerts providers out of `subscription_provider.dart`.
- **Files:** `mock_alerts.dart`, `alerts_provider.dart`, `alerts_list_screen.dart`, `alert_detail_screen.dart`, `alert_list_item.dart`, `dashboard_alert_tile.dart`, `home_screen.dart`, `vehicle_details_screen.dart`, `subscription_provider.dart`, docs
- **Next checklist item:** §3.3 **Delete account** — clear local mock session and return to login

### 2026-09-14 — §3.3 Delete account clears mock session

- **What:** Confirm delete calls `sessionProvider.deleteAccount()` (clears SharedPreferences `mock_is_logged_in`, same local effect as logout), shows success snackbar, navigates to `/login`. Splash auth guard still routes logged-out users to onboarding on cold start. Logout path unchanged (`logout()` → `/login`).
- **Files:** `session_provider.dart`, `delete_account_screen.dart`, `docs/mock.md`, `docs/PHASE_CHECKLIST.md`, `docs/AGENTS.md`
- **Next checklist item:** §3.4 **Replace remaining `debugPrint`-only actions** with real navigation or user feedback

### 2026-09-14 — §3.4 Replace debugPrint-only actions

- **What:** Cleared leftover `debugPrint` stubs on auth/language CTAs. Register OTP now validates `MockAuthData.mockOtp` with inline errors before `/account-setup`. Onboarding language Continue writes `appLanguageProvider` then goes to `/login`. Register / account-setup already navigated — removed dead prints only. Moved `AppLanguage` enum into `settings_provider.dart` to avoid a circular import.
- **Files:** `otp_verification_screen.dart`, `register_screen.dart`, `account_setup_screen.dart`, `language_selection_screen.dart`, `language_region_screen.dart`, `settings_provider.dart`, `docs/mock.md`, `docs/PHASE_CHECKLIST.md`, `docs/AGENTS.md`
- **Next checklist item:** §3.4 **Add meaningful widget/integration tests** for auth navigation + vehicle CRUD

### 2026-09-14 — §3.4 Auth + vehicle CRUD tests

- **What:** Added focused tests (no camera/plugins): login widget tests (failure shows **Invalid phone or password**; success sets `sessionProvider` / `mock_is_logged_in` and navigates to `/home` stub) using mock creds `5123454821` / `Nawasul@123`; `MockAuthData.authenticate` unit checks; `vehicleProvider` add/update/delete unit tests; hardened splash smoke test (SharedPreferences mock + clear timer).
- **Files:** `test/auth_login_test.dart`, `test/vehicle_provider_test.dart`, `test/widget_test.dart`, `docs/PHASE_CHECKLIST.md`, `docs/AGENTS.md`
- **Verify:** `flutter test` (9 passed); `flutter analyze` clean
- **Next checklist item:** §3.4 **Keep `docs/` in sync** when routes or phase status change

### 2026-09-14 — §3.4 Docs sync (routes + phase status)

- **What:** Audited `app_routes.dart` / `app_router.dart` / `main_shell.dart` against docs. Aligned root `README.md`, `docs/README.md`, `PHASE_CHECKLIST.md`, and this file with current product shape: **4 shell tabs** (Home, QR, Scan, Account), pushed `/vehicles` + `/alerts`, orange/black dashboard, mock auth/session credentials pointer, completed §3.1–§3.3 and §3.4 items so far. Marked docs-sync checklist item done. No Dart changes; no i18n/backend work.
- **Files:** `README.md`, `docs/README.md`, `docs/PHASE_CHECKLIST.md`, `docs/AGENTS.md` (`docs/mock.md` already accurate — left as-is)
- **Still open:** §3.4 README run-instructions if device targets change; §3.5 i18n; §4 backend sections
- **Next checklist item:** §3.4 **Update root `README.md` run instructions if device targets change** (or §3.5 Localization)

### 2026-09-14 — §3.4 README device targets + §3.5 i18n foundation

- **What:** Root `README.md` documents primary `flutter run -d chrome` plus Android/iOS via `flutter devices` / `flutter run -d <id>` for camera/scan/photo. Added lightweight EN/AR `AppStrings` + `appStringsProvider`; wired `MaterialApp.router` locale + `flutter_localizations`; applied strings to Login, bottom nav, and Home/dashboard. Language via existing `appLanguageProvider` (in-memory mock).
- **Files:** `README.md`, `pubspec.yaml` (`flutter_localizations`), `lib/core/l10n/app_strings.dart`, `main.dart`, `login_screen.dart`, `app_bottom_nav_bar.dart`, `home_screen.dart`, `dashboard_hero.dart`, `docs/mock.md`, `docs/PHASE_CHECKLIST.md`, `docs/AGENTS.md`
- **Still open:** Full string extraction on remaining screens; language persistence; §4 backend
- **Next checklist item:** Continue §3.5 remaining screens **or** §4 backend kickoff

### 2026-09-14 — §3.5 i18n expansion + language persistence

- **What:** Expanded `AppStrings` EN/AR for high-traffic screens (auth rest, account/settings/edit profile, My QR tab+screen, vehicles list, alerts list, scan messages, subscription plans headings + billing toggle). Converted needed screens to Consumer. Persisted language via `appLanguageProvider` AsyncNotifier + SharedPreferences `app_language` (same style as session).
- **Files:** `app_strings.dart`, `settings_provider.dart`, `main.dart`, auth screens (register/otp/forgot/account-setup), `language_selection_screen.dart`, `language_region_screen.dart`, profile/edit/settings, my_qr screens, vehicles/alerts lists, `qr_scanner_screen.dart`, subscription plans + `billing_cycle_toggle.dart`, docs, `test/app_strings_test.dart`
- **Still open (i18n leftovers):** add/edit vehicle, vehicle details, sticker flows, checkout/success, help/legal/delete, notification prefs, onboarding, alert detail, PlanCard body/mock plan features
- **Next checklist item:** §4 backend kickoff (preferred) **or** finish leftover §3.5 strings

### 2026-09-14 — §4 Backend kickoff (ApiClient + AuthRepository)

- **What:** Added non-secret `AppConfig` (`apiBaseUrl` default `https://api.nawasul.app`, `useMockData=true` / `--dart-define` overrides). Stub `ApiClient` + `apiClientProvider` (refuses HTTP in mock mode; `UnimplementedError` otherwise). Feature repos: `AuthRepository` / `MockAuthRepository` (login, establishSession, logout, deleteAccount, isLoggedIn via `MockAuthData` + `mock_is_logged_in`); thin `VehicleRepository` / `MockVehicleRepository`. Login screen + `sessionProvider` logout/delete go through `authRepositoryProvider`. No live network, payments, or FCM.
- **Files:** `lib/core/config/app_config.dart`, `lib/core/network/api_client.dart`, `network_providers.dart`, `lib/features/auth/data/*`, `session_provider.dart`, `login_screen.dart`, `lib/features/vehicles/data/vehicle_repository.dart`, `docs/PHASE_CHECKLIST.md`, `docs/mock.md`, this file
- **Still open (§4):** real HTTP wiring, tokens, OTP/register APIs, profile/vehicles/alerts/subscription/support remote repos, error/offline, analytics, force-update
- **Next checklist item:** Grow more mock repositories **or** leftover §3.5 strings

### 2026-09-14 — §4 Expand mock repository layer

- **What:** Extended `AuthRepository` with register / sendOtp / verifyOtp / requestPasswordReset / resetPassword; wired forgot-password + register OTP screens through auth repo. Added mock repos + providers: `ProfileRepository`, `AlertsRepository`, `SubscriptionRepository`, `StickerOrderRepository`, `SupportRepository`. Providers gradually delegate (profile updates/photo, alerts refresh, subscription confirm, sticker place/ensure, support inbox). `vehicleProvider` references `VehicleRepository` + `reload()`; CRUD remains in-memory. `useMockData=true`; no dio/http live calls.
- **Files:** `features/*/data/*_repository.dart`, auth/forgot/otp screens, profile/alerts/subscription/sticker/support/vehicle providers + related screens, `docs/PHASE_CHECKLIST.md`, `docs/mock.md`, this file
- **Still open (§4):** FastAPI HTTP, tokens, register form wiring, vehicle CRUD via repo, alert mark-read API, payments, FCM, FAQ/help + contact channels still read `MockFaq`/`MockSupport` directly, legal CMS, error/offline
- **Next checklist item:** Leftover §3.5 i18n **or** implement first live FastAPI repository when backend is ready

### 2026-09-14 — §4 Mock-layer wiring pass (no live HTTP)

- **What:** Closed remaining frontend mock wiring gaps while keeping `AppConfig.useMockData=true`. Register → `AuthRepository.register` + `sendOtp` before OTP. Help FAQ → `SupportRepository.fetchFaq`. Contact channels → `SupportRepository.channels`. Vehicle add/update/delete → `VehicleRepository`. Alerts mark-read / mark-all → `AlertsRepository`. Account-setup name/city → `ProfileRepository` via `profileProvider`. Updated checklist to mark scaffolded/wired items and leave HTTP/tokens/payments/FCM/CMS clearly backend-blocked.
- **Files:** `register_screen.dart`, `account_setup_screen.dart`, `help_faq_screen.dart`, `contact_support_screen.dart`, `vehicle_repository.dart`, `vehicle_provider.dart`, `add_edit_vehicle_screen.dart`, `vehicle_details_screen.dart`, `alerts_repository.dart`, `alerts_provider.dart`, `app_strings.dart`, `test/vehicle_provider_test.dart`, `docs/PHASE_CHECKLIST.md`, `docs/mock.md`, this file
- **Verify:** `flutter analyze` + `flutter test`
- **Still backend-blocked:** live `dio`/HTTP, tokens, payments, FCM, CMS legal/FAQ content, photo upload, real ticket API, error/offline
- **Optional leftover (frontend):** §3.5 low-traffic i18n; legal screens still read `MockLegal` directly
- **Next checklist item:** Leftover §3.5 strings **or** first FastAPI repository when APIs exist

### 2026-09-14 — Frontend checklist closeout (LegalRepository + low-traffic i18n)

- **What:** Closed remaining frontend-completable leftovers. Added `LegalRepository` / `MockLegalRepository` + `legalRepositoryProvider`; privacy/terms screens load via repo. Expanded `AppStrings` EN/AR and wired onboarding, delete account, notification prefs, add/edit vehicle, vehicle details, sticker order/status, checkout/success, help/contact chrome, alert detail chrome, PlanCard labels. **Intentional i18n skips:** MockLegal body, MockFaq Q&A, plan feature bullets (CMS/catalog). Checklist marks §3 done; §4 HTTP/tokens/payments/FCM stay open.
- **Files:** `features/legal/data/legal_repository.dart`, privacy/terms screens, `app_strings.dart`, leftover presentation screens, `plan_card.dart`, `test/app_strings_test.dart`, `docs/PHASE_CHECKLIST.md`, `docs/mock.md`, this file
- **Verify:** `flutter analyze` + `flutter test`
- **Checklist status:** Frontend prototype checklist **complete except live backend**
- **Still backend-blocked:** live `dio`/HTTP, tokens, payments, FCM, CMS legal/FAQ content, photo upload, real ticket API, error/offline, analytics, force-update
- **Next checklist item:** First FastAPI-backed repository when APIs exist (or NATIVE Scan/photo polish on device)
