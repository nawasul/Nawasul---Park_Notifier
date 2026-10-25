# Nawasul Mobile — Phase Checklist

> Superseded by [../../docs/updatedplan.md](../../docs/updatedplan.md). If this file conflicts with that plan, the plan wins.

> **Purpose:** Single source of truth for what is complete, what still needs work, and what must come from the **backend later**.
>
> **Rule for now:** Keep using **mock data** (`lib/core/mock/`) until backend endpoints are ready. Do not block UI work on APIs.

**Last reviewed:** 2026-09-14 (frontend prototype checklist complete except live backend — LegalRepository + low-traffic i18n)  
**Branch baseline:** UI prototype — 4-tab shell (Home, QR, Scan, Account), mock auth via `AuthRepository` + `sessionProvider`, orange/black dashboard; EN/AR on high- + low-traffic screens + persisted locale; FastAPI not wired (`AppConfig.useMockData=true`); domain repos + providers fully mock-wired for all frontend-completable items

---

## Legend

| Tag | Meaning |
|---|---|
| `[x]` | Done enough for current UI prototype |
| `[ ]` | Needs work (frontend and/or product) |
| `MOCK` | Use / keep mock data for now |
| `BACKEND` | Must eventually come from FastAPI / real services |
| `NATIVE` | Needs Android/iOS (limited or stubbed on web) |

---

## 1. Overall status

| Area | Status | Notes |
|---|---|---|
| Screen UI coverage | `[x]` | Auth + core + account/settings/legal exist |
| Navigation (go_router shell) | `[x]` | 4 shell tabs: Home, QR, Scan, Account |
| Theme / brand tokens | `[x]` | Orange `#F2572B` + dark `#171717` |
| Mock data layer | `[x]` | Auth, vehicles, alerts, plans, stickers, FAQ, legal |
| Real auth / session | `[~]` | `AuthRepository` mock: login/register/OTP/forgot/reset/session wired; no real tokens yet |
| Backend API client | `[~]` | `ApiClient` stub + `AppConfig` (`useMockData=true`); domain mock repos wired; no live HTTP |
| Real payments | `[ ]` | Checkout is UI-only — **BACKEND** |
| QR camera scanner | `[x]` | Mobile via `mobile_scanner`; web stub |
| Tests | `[x]` | Auth login widget + `vehicleProvider` CRUD + `AppStrings` unit tests |
| Full i18n (EN/AR) | `[x]` | User-visible labels/titles/buttons covered; intentional skips: legal body, FAQ bodies, plan feature bullets (mock CMS) |

---

## 2. Completed (keep; polish later)

Use this as “already shipped UI” — still may need polish or backend swap.

### 2.1 Auth & onboarding UI

- [x] Splash → Onboarding → Language flow
- [x] Register / OTP / Account setup screens
- [x] Forgot-password multi-step UI
- [x] Login screen UI

### 2.2 Core product UI (screens 9–18)

- [x] Home / Dashboard (orange hero + black content)
- [x] Vehicles list / add-edit / details
- [x] My QR (tab + per-vehicle QR screen)
- [x] Sticker order + order status (mock)
- [x] Alerts list + alert detail (mock mark-read / empty / pull-to-refresh; list is pushed, not a shell tab)
- [x] Subscription plans / checkout / success (mock confirm)
- [x] Scan tab (`/scan`) — mobile camera + web stub

### 2.3 Account expansion UI

- [x] Profile / edit profile
- [x] Settings + notification preferences + language/region
- [x] Help FAQ + contact support UI
- [x] Privacy + terms documents
- [x] Delete account UI

### 2.4 Architecture scaffolding

- [x] Feature-based folders
- [x] Riverpod providers for vehicles / subscription / alerts / profile
- [x] Shared widgets batch
- [x] Mock modules under `lib/core/mock/`

---

## 3. Needs work (frontend / product — can use mocks)

**Status:** Frontend-completable items under §3 are **done**. Remaining product work is polish-only or blocked on §4 backend.

### 3.1 Critical bugs / broken flows

- [x] **Login navigates to `/home`** — mock phone/password via `MockAuthData.authenticate()`; credentials in `docs/mock.md` (2026-09-14)
- [x] **Forgot password** — mock phone → OTP `123456` → reset → `/login` + snackbar; rules in `docs/mock.md` (2026-09-14)
- [x] **Auth guard** — splash reads `sessionProvider` (`mock_is_logged_in`); logged-in → `/home`, else onboarding; logout/delete clear flag (2026-09-14)

### 3.2 Dashboard / navigation product decisions

- [x] **Dashboard redesign** — orange hero (`#F2572B`) + black content (`#171717`); no CTAs in hero; greeting/name from `profileProvider`, plan from `subscriptionProvider` (2026-09-14)
- [x] **Shell tabs** — exactly 4: Home, QR, Scan, Account. Vehicles & Alerts removed from shell; reachable via push from dashboard (2026-09-14)
- [x] **Scan** — `mobile_scanner` + camera permissions + `url_launcher`; http/https open externally; non-URL result UI; duplicate-scan lock; bottom nav hidden on Scan; web-safe stub (`NATIVE` + stub on Chrome) (2026-09-14)

### 3.3 Mock-backed features that feel incomplete

- [x] QR share / download — Share copies `MockVehicles.shareUrl`; Download shows explicit mock-save dialog (2026-09-14)
- [x] Photo upload on edit profile — `image_picker` local preview + sample photo; web gallery OK, camera stubbed (2026-09-14)
- [x] Contact support channels (Call / WhatsApp / Email) — `tel:` / `wa.me` / `mailto:` via `url_launcher`; mock values in `docs/mock.md` (2026-09-14)
- [x] Contact form “sent successfully” — `supportInboxProvider` in-memory mock inbox + Recent messages on contact screen (2026-09-14)
- [x] Sticker order — unique mock order IDs via `stickerOrdersProvider` + status by route id (2026-09-14)
- [x] Alerts — mark as read / empty states / pull-to-refresh (`alertsProvider` notifier + `MockAlerts.seed()`) (2026-09-14)
- [x] Delete account — clear local mock session (`deleteAccount()` / `mock_is_logged_in`) → snackbar → `/login`; splash guard stays logged-out (2026-09-14)

### 3.4 Quality / maintainability

- [x] Replace remaining `debugPrint`-only actions with real navigation or user feedback
- [x] Add meaningful widget/integration tests for auth navigation + vehicle CRUD (2026-09-14)
- [x] Keep `docs/` in sync when routes or phase status change (2026-09-14) — `docs/*` + root `README.md` aligned to 4-tab shell, pushed vehicles/alerts, mock auth, orange/black dashboard
- [x] Update root `README.md` run instructions if device targets change — Chrome primary + `flutter devices` / `-d <id>` for native camera/photo (2026-09-14)

### 3.5 Localization (can start without backend)

- [x] i18n foundation — `AppStrings` EN/AR maps + `appStringsProvider`; `MaterialApp.router` locale + `flutter_localizations` delegates; RTL via `locale: ar` (2026-09-14)
- [x] Extract user-facing strings — high-traffic + low-traffic screens (onboarding, delete account, notification prefs, add/edit vehicle, vehicle details, sticker order/status, checkout/success, help/contact chrome, privacy/terms titles, alert detail chrome, PlanCard Most Popular / Select / Current Plan). **Intentional skips:** MockLegal body paragraphs, MockFaq Q&A bodies, MockSubscription plan feature bullet lists (CMS/catalog copy)
- [x] Wire English / Arabic + RTL for covered screens
- [x] Persist language preference — `appLanguageProvider` AsyncNotifier + SharedPreferences `app_language` (`en`/`ar`), same style as session (2026-09-14)

---

## 4. Backend later (use mock data for now)

Everything below should stay **mock-backed** until the FastAPI (or agreed) backend exposes endpoints. Flutter must **not** call privileged third-party APIs directly (see `.cursorrules`).

**§4 status (2026-09-14):** Mock repository layer **scaffolded and UI-wired** for all frontend-completable domains including legal. `AppConfig.useMockData=true`. No live HTTP.

| Repository | Location | Wired call sites |
|---|---|---|
| `AuthRepository` | `features/auth/data/` | Login, register (+ sendOtp), session logout/delete, forgot-password, register OTP verify |
| `VehicleRepository` | `features/vehicles/data/` | `vehicleProvider` fetch/reload **and** add/update/delete |
| `ProfileRepository` | `features/account/data/` | `profileProvider` update/photo; account-setup name/city |
| `AlertsRepository` | `features/alerts/data/` | `alertsProvider` fetch/refresh **and** mark-read / mark-all |
| `SubscriptionRepository` | `features/subscription/data/` | `confirmSubscription()` via repo |
| `StickerOrderRepository` | `features/sticker/data/` | place/ensure via repo |
| `SupportRepository` | `features/support/data/` | FAQ (`fetchFaq`), contact channels, contact-form inbox |
| `LegalRepository` | `features/legal/data/` | Privacy + terms screens via `fetchPrivacyPolicy` / `fetchTermsConditions` |

**Still blocked on backend (do not mark complete):** real HTTP/`dio`, auth tokens, payments, FCM/push, CMS legal/FAQ content, photo upload, ticket API, error/offline, analytics, force-update.

### 4.1 Auth & identity — `BACKEND`

| Capability | Mock now | Backend later | Scaffolding |
|---|---|---|---|
| Register / login / logout | `MockAuthRepository`; login + **register screen** + logout wired | Phone/password or OTP auth APIs + tokens | `[x]` mock repo + screens |
| OTP send / verify | `sendOtp` / `verifyOtp` → `MockAuthData.mockOtp`; register send + OTP screens wired | SMS provider via backend | `[x]` mock repo methods + OTP screens |
| Forgot / reset password | `requestPasswordReset` / `resetPassword` via auth repo → `/login` | Reset token APIs | `[x]` mock repo + forgot-password screen |
| Account setup (name, city) | `ProfileRepository.updateProfile` + `establishSession` → home | PATCH profile | `[x]` mock via profile + session repos |
| Session persistence | `sessionProvider` → `AuthRepository` + SharedPreferences | Secure storage + refresh tokens | `[~]` mock flag only — **tokens BACKEND** |
| Delete account | Clears mock session → login | Hard/soft delete API | `[~]` local clear via repo — **API BACKEND** |

### 4.2 Profile & settings — `BACKEND`

| Capability | Mock now | Backend later | Scaffolding |
|---|---|---|---|
| Profile read/update | `ProfileRepository` + `profileProvider` / `MockUser` | User profile CRUD | `[x]` mock repo; provider delegates updates |
| Profile photo | Local preview via `image_picker` / sample PNG through repo | Upload to storage via backend | `[x]` mock repo photo methods; **upload BACKEND** |
| Notification preferences | Local toggles | Persist prefs + FCM device token | `[ ]` **BACKEND** |
| Language / city | Local prefs (`app_language` SharedPreferences; city via profile mock) | Persist on user profile | `[~]` language local; city mock; **API BACKEND** |
| Push notifications | UI only | FCM + backend notification service | `[ ]` **BACKEND** |

### 4.3 Vehicles & QR — `BACKEND`

| Capability | Mock now | Backend later | Scaffolding |
|---|---|---|---|
| Vehicle list / CRUD | `VehicleRepository` + `vehicleProvider` (fetch + add/update/delete) | Vehicle APIs | `[x]` mock repo CRUD wired; **HTTP BACKEND** |
| QR payload / deep link | Local `qr_flutter` value | Signed QR URLs / public scan landing | `[ ]` **BACKEND** |
| Share / save QR | Mock snackbars | CDN asset or generated PNG from API | `[ ]` **BACKEND** |
| Sticker orders | `StickerOrderRepository` + `stickerOrdersProvider` | Order create / status / shipping | `[x]` mock repo; place/ensure wired; **HTTP BACKEND** |

### 4.4 Alerts / scan events — `BACKEND`

| Capability | Mock now | Backend later | Scaffolding |
|---|---|---|---|
| Alert feed | `AlertsRepository` + `alertsProvider` (fetch, refresh, mark-read, mark-all) | List / detail / mark-read | `[x]` mock repo fully wired; **HTTP BACKEND** |
| Scan → notify owner | Not implemented | Public scan endpoint → call/push without exposing phone | `[ ]` **BACKEND** |
| Alert metadata (location, method) | Hardcoded mock fields | Backend event payload | `[ ]` **BACKEND** |

### 4.5 Subscription & payments — `BACKEND`

| Capability | Mock now | Backend later | Scaffolding |
|---|---|---|---|
| Plans / pricing | `SubscriptionRepository.fetchPlans` / `MockSubscription` | Catalog from API | `[x]` mock repo (plans + current); **HTTP BACKEND** |
| Checkout | `confirmSubscription()` → repo `confirmPlan` | Payment gateway via backend | `[~]` mock confirm only; **payments BACKEND** |
| Active plan / days remaining | Local dates on `subscriptionProvider` | Subscription status from billing | `[~]` mock; **BACKEND** |
| Invoices / receipts | None | Billing history APIs | `[ ]` **BACKEND** |

### 4.6 Support & legal — `BACKEND` (optional / CMS)

| Capability | Mock now | Backend later | Scaffolding |
|---|---|---|---|
| FAQ | `SupportRepository.fetchFaq` → help screen | CMS or static API | `[x]` mock repo + help screen wired; **CMS BACKEND** |
| Contact form | `SupportRepository.submitTicket` + `supportInboxProvider` | Support ticket API | `[x]` mock repo + inbox wired; **API BACKEND** |
| Contact channels | `SupportRepository.channels` → contact screen | Real support numbers via CMS/config | `[x]` repo + contact screen wired; **CMS BACKEND** |
| Privacy / Terms | `LegalRepository` → `MockLegal` via privacy/terms screens | CMS or versioned legal docs | `[x]` mock repo + screens wired; **CMS BACKEND** |

### 4.7 Infrastructure — `BACKEND` / ops

- [x] API base URL / environments — **scaffolding:** `AppConfig.apiBaseUrl` + `--dart-define=API_BASE_URL` (default `https://api.nawasul.app`); live HTTP still TODO
- [x] Mock-vs-live flag — `AppConfig.useMockData` (default `true`) / `--dart-define=USE_MOCK_DATA`
- [x] Domain mock repositories (auth, profile, vehicles, alerts, subscription, sticker, support, legal) — UI call sites wired for mock path
- [ ] Error handling / offline messaging — **BACKEND**
- [ ] Analytics (if required) — **BACKEND**
- [ ] App version / force-update policy — **BACKEND**
- [ ] Wire `ApiClient` to `http`/`dio` against FastAPI (keep `useMockData` until ready) — **BACKEND**
---

## 5. Mock data inventory (keep until backend)

| File | Used for |
|---|---|
| `lib/core/mock/mock_auth_data.dart` | User, cities, mock login (`authenticate`) — see `docs/mock.md` |
| `session_provider.dart` (auth) | Mock logged-in flag via `AuthRepository` (`mock_is_logged_in`) |
| `auth_repository.dart` / `mock_auth_repository.dart` | Login / register / OTP / forgot-reset / session / logout / delete |
| `lib/core/config/app_config.dart` | `apiBaseUrl` + `useMockData` (no secrets) |
| `lib/core/network/api_client.dart` | HTTP stub; mock mode refuses network |
| `vehicle_repository.dart` (vehicles/data) | Fetch + add/update/delete — `vehicleProvider` delegates |
| `profile_repository.dart` (account/data) | Profile read/update/photo — `profileProvider` + account-setup |
| `alerts_repository.dart` (alerts/data) | Seed/refresh + mark-read / mark-all — `alertsProvider` delegates |
| `subscription_repository.dart` (subscription/data) | Plans + confirm plan (no payment) |
| `sticker_order_repository.dart` (sticker/data) | Place / ensure / list orders |
| `support_repository.dart` (support/data) | FAQ + tickets + channel URIs — help + contact screens |
| `legal_repository.dart` (legal/data) | Privacy / terms sections — legal screens |
| `lib/core/mock/mock_vehicles.dart` | Seed vehicles + QR status |
| `lib/core/mock/mock_alerts.dart` | Dashboard / alerts feed (`seed()`, `isRead`) |
| `alerts_provider.dart` (alerts) | Mark-read + refresh via `AlertsRepository` |
| `lib/core/mock/mock_subscription.dart` | Plans, prices, current tier |
| `lib/core/mock/mock_sticker_orders.dart` | Order pricing + `create()` + sample seed |
| `sticker_orders_provider.dart` (sticker) | Mirrors `StickerOrderRepository` |
| `lib/core/mock/mock_faq.dart` | Help FAQ (via `SupportRepository.fetchFaq`) |
| `lib/core/mock/mock_support.dart` | Contact Call / WhatsApp / Email + ticket model |
| `support_inbox_provider.dart` (support) | Contact-form tickets via `SupportRepository` |
| `lib/core/mock/mock_legal.dart` | Privacy / terms sections (via `LegalRepository`) |

When backend lands: replace provider implementations; **keep UI screens** and swap data sources.

---

## 6. Suggested next decisions (for you)

Frontend prototype checklist is **complete except live backend**. Pick one track:

1. **Backend swap** — implement FastAPI-backed repositories one domain at a time when APIs exist (keep `useMockData` until ready)  
2. **Polish / NATIVE** — verify Scan + camera photo on a real device when available  
3. **Optional CMS i18n** — translate MockLegal / MockFaq / plan feature bullets if product wants full bilingual mock content  

Do **not** start all three at once unless scoped. Prefer first FastAPI repository when APIs exist.

---

## 7. Definition of “ready for backend swap”

A feature is ready to leave mocks when:

1. UI states exist: loading / empty / error / success  
2. Provider API is stable (methods match intended endpoints)  
3. No secrets in the Flutter app  
4. Mock repository can be replaced by a real repository without rewriting screens
