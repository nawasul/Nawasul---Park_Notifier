# Nawasul — Mock credentials & data

> Superseded by [../../docs/updatedplan.md](../../docs/updatedplan.md). If this file conflicts with that plan, the plan wins.

> Prototype-only fake auth and sample data. **Not** real secrets. Replace with backend auth when available.
>
> Source of truth in code: `lib/core/mock/` (auth: `mock_auth_data.dart`).
> Navigation shape: 4 shell tabs Home · QR · Scan · Account; vehicles/alerts are pushed — see [AGENTS.md](./AGENTS.md).

**Last updated:** 2026-09-14 (frontend checklist closeout — LegalRepository + low-traffic i18n; no live HTTP)

---

## API / mock flag

All backend-shaped access is **mock-flagged** until FastAPI is ready:

| Item | Detail |
|---|---|
| Flag | `AppConfig.useMockData` (default `true`; override `--dart-define=USE_MOCK_DATA=false` only when live HTTP exists) |
| Base URL | `AppConfig.apiBaseUrl` (default `https://api.nawasul.app`; `--dart-define=API_BASE_URL=...`) — **not** a secret |
| Auth | `AuthRepository` → `MockAuthRepository` (login / register / OTP / forgot-reset / session) |
| Other domains | `ProfileRepository`, `VehicleRepository`, `AlertsRepository`, `SubscriptionRepository`, `StickerOrderRepository`, `SupportRepository`, `LegalRepository` — mock implementations + Riverpod providers |
| HTTP | `ApiClient` does **not** perform network calls while `useMockData` is true |

Login still uses the credentials below; register / forgot-password / OTP verify go through `AuthRepository`. Behavior for testers is unchanged.

---

## Login (phone + password)

The login screen validates via `AuthRepository.login()` → `MockAuthData.sampleUsers` and the shared mock password.

| Field | How to enter | Notes |
|---|---|---|
| Phone | Local Saudi mobile digits in the `+966` field | Country code is fixed in the UI |
| Password | Shared mock password below | Same for all sample users |

### Shared mock password

```
Nawasul@123
```

Constant: `MockAuthData.mockPassword`

### Sample users

| Name | Phone (E.164) | Enter in phone field (after +966) | City |
|---|---|---|---|
| Ahmed Al-Rashid (primary) | `+9665123454821` | `5123454821` | Riyadh |
| Fatima Al-Harbi (secondary) | `+9665987654321` | `5987654321` | Jeddah |

### Quick test

1. Open `/login`
2. Phone: `5123454821`
3. Password: `Nawasul@123`
4. Expect navigation to `/home`

Wrong phone or password shows **Invalid phone or password** and stays on login.

---

## Mock session (auth guard)

Prototype “already logged in” flag used by splash routing.

| Item | Detail |
|---|---|
| Repository | `AuthRepository` / `MockAuthRepository` (`lib/features/auth/data/`) |
| Provider | `sessionProvider` (`lib/features/auth/presentation/providers/session_provider.dart`) — reads/writes through repo |
| Storage | `SharedPreferences` key `mock_is_logged_in` |
| Set logged-in | Successful `AuthRepository.login`; account-setup `establishSession` (register path → `/home`) |
| Cleared | Account **Logout** (`logout()`); **Delete account** confirm (`deleteAccount()`) — both clear via repo |
| After delete | Snackbar **Account deleted successfully** → `context.go(/login)` |
| Splash | If flag is `true` → `/home`; else → `/onboarding` (existing auth path) |

This is **not** a real token. Backend later: secure storage + refresh tokens. Delete account has **no** server call — local session clear only.

### Quick session test

1. Log in with mock credentials above
2. Fully restart the app (cold start)
3. Splash should land on `/home`
4. Logout (or delete account) → restart → splash should land on `/onboarding`

### Quick delete-account test

1. Open Account → Delete Account (`/account/delete`)
2. Confirm **Delete Account** in the dialog
3. Expect brief snackbar and land on `/login`
4. Cold-start the app → splash should land on `/onboarding` (not `/home`)

---

## Forgot password (mock reset)

Three-step UI on `/forgot-password`. Phone must match a sample user; OTP is a fixed mock code.

| Step | Rule |
|---|---|
| 1. Phone | Must match a [sample user](#sample-users) (same local digits as login) |
| 2. OTP | Accept only the mock code below |
| 3. New password | Min 8 chars; confirm must match. **Does not** change `MockAuthData.mockPassword` — login still uses `Nawasul@123` |

### Mock OTP

```
123456
```

Constant: `MockAuthData.mockOtp`

Also used by register OTP verification (`/otp`) — same code, then continue to account setup.

### Register (mock)

`/register` validates the form, then calls `AuthRepository.register` + `sendOtp` before `/otp`.

| Rule | Detail |
|---|---|
| Phone | Must **not** match a [sample user](#sample-users) (those already “exist”) |
| Password | Min 8 chars; confirm must match |
| On success | `sendOtp` (no-op mock) → `/otp` → verify with mock OTP above → account setup |
| Rejected phone | Inline error **An account already exists for this phone number** |

### Quick register test

1. Open `/register`
2. Name any; phone e.g. `5111111111` (not a sample user); password ≥ 8 chars matching confirm
3. Expect `/otp` → enter `123456` → account setup → `/home`
4. Try phone `5123454821` → expect already-registered error

### Quick reset test

1. Open `/forgot-password` (or Login → Forgot password?)
2. Phone: `5123454821` → Send Code
3. OTP: `123456` → Verify
4. New + confirm password (any matching strings ≥ 8 chars) → Reset Password
5. Expect snackbar **Password reset successfully** and navigation to `/login`
6. Sign in with the original mock password `Nawasul@123`

Unknown phone → **No account found for this phone number**. Wrong OTP → **Invalid verification code**.

---

## Profile photo (edit profile — local only)

| Item | Detail |
|---|---|
| Entry | Account → Edit Profile → tap avatar |
| Gallery / file | `image_picker` → bytes stored on `profileProvider` (`MockUser.photoBytes`) |
| Camera | Mobile only; **web (Chrome)** shows “not available” and points to Choose photo |
| Sample photo | “Use sample photo” → `MockAuthData.mockProfilePhotoPng` (tiny brand PNG) |
| Remove | Clears `photoBytes`; avatar falls back to initials |
| Persistence | In-memory for the session only — no SharedPreferences / no upload |
| Backend later | Multipart upload via API; keep UI + provider method shapes |

### Quick photo test

1. Open `/profile/edit` (or Account → Edit Profile)
2. Tap avatar → **Use sample photo** → avatar shows orange circle sample
3. Tap again → **Choose photo** → pick any image (file picker on web) → preview updates
4. Tap → **Remove photo** → initials return
5. Confirm Account tab avatar matches

---

## Contact support channels (mock deep links)

Prototype channels on `/support/contact`. Source: `SupportRepository.channels` → `MockSupport`. Opens via `url_launcher` (`LaunchMode.externalApplication`). Launch failure → snackbar **Could not open {channel}**.

| Channel | URI | Value |
|---|---|---|
| Call Us | `tel:` | `+966920001234` (`MockSupport.phoneE164`) |
| WhatsApp | `https://wa.me/{digits}` | `966920001234` (`MockSupport.whatsAppDigits`) |
| Email | `mailto:` | `support@nawasul.app` (`MockSupport.email`) with subject `Nawasul Support` |

These are **fake** support contacts for UI testing — not real Nawasul ops numbers.

### Quick channel test

1. Open `/support/contact` (Help → Contact Support)
2. Tap **Call Us** → dialer / browser prompt for `+966920001234` (or failure snackbar if no handler)
3. Tap **WhatsApp** → opens `https://wa.me/966920001234`
4. Tap **Email** → mail client / browser for `support@nawasul.app`

---

## Contact form (mock inbox)

Form on `/support/contact` queues tickets in-memory via `supportInboxProvider` (no SharedPreferences, no server).

| Item | Detail |
|---|---|
| Provider | `supportInboxProvider` (`lib/features/support/presentation/providers/support_inbox_provider.dart`) |
| Model | `MockSupportTicket` in `mock_support.dart` (`id`, `subject`, `message`, `createdAt`) |
| On send | Fake delay → append ticket (newest first) → clear fields → snackbar **Message sent successfully** |
| UI | Screen shows **Recent messages (N)** list (up to 5) when inbox is non-empty |
| Persistence | Session only — lost on app restart |
| Backend later | Support ticket API; keep provider method shape |

### Quick form test

1. Open `/support/contact`
2. Subject + message → **Send Message**
3. Expect snackbar **Message sent successfully** and a **Recent messages** card under the button
4. Send again → count increments; newest appears first
5. Restart app → recent list is empty again

---

## Sticker orders (mock)

Place Order creates a unique in-memory order and opens `/sticker-orders/{id}`. Status loads that record (not always `order-001`).

| Item | Detail |
|---|---|
| Factory | `MockStickerOrders.create(...)` → id `order-{millisecondsSinceEpoch}` |
| Provider | `stickerOrdersProvider` (`lib/features/sticker/presentation/providers/sticker_orders_provider.dart`) |
| Seed | `MockStickerOrders.sampleOrder` (`order-001`, shipped) still seeded for deep-link demos |
| On submit | Fake delay → `placeOrder()` → navigate with new id; step starts at **Ordered** |
| Status | Looks up by route `:id`; unknown id → `ensureById()` materializes a mock record |
| UI | Status shows **Order ID** plus date / qty / address / total |
| Persistence | Session only — lost on app restart |
| Backend later | Order create / status / shipping APIs |

### Quick sticker order test

1. Open a vehicle → Order QR Sticker (`/vehicles/{id}/sticker-order`)
2. Optionally fill address / change quantity → **Place Order**
3. Expect `/sticker-orders/order-{timestamp}` with matching Order ID and **Ordered** step
4. Place another order → different Order ID
5. Open `/sticker-orders/order-001` → sample shipped order still works

---

## Alerts (mock feed)

In-memory alerts via `alertsProvider` → `AlertsRepository`. Seed mixes unread + read; opening detail marks read; pull-to-refresh re-seeds.

| Item | Detail |
|---|---|
| Model | `Alert` in `mock_alerts.dart` (`isRead`, reason, vehicle, location, method) |
| Seed | `MockAlerts.seed()` — 3 alerts; `alert-001`/`002` unread, `alert-003` read |
| Provider | `alertsProvider` (`lib/features/alerts/presentation/providers/alerts_provider.dart`) — mark-read / refresh via `AlertsRepository` |
| Mark read | Opening `/alerts/{id}` calls repo `markAsRead`; list has **Mark all read** when unread > 0 |
| Empty | List shows empty state when feed is empty (pull still works) |
| Refresh | Pull-to-refresh → ~600ms delay → `AlertsRepository.refreshAlerts()` / `MockAlerts.seed()` |
| Dashboard | Recent alerts (top 3) from same provider; unread shows orange dot |
| Persistence | Session only — lost on app restart |
| Backend later | List / detail / mark-read APIs |

### Quick alerts test

1. Open `/alerts` (or Home → View all alerts)
2. Expect 2 unread (soft orange tiles + dot) and 1 read
3. Open an unread alert → back → tile looks read
4. Tap **Mark all read** → unread count clears
5. Pull to refresh → seed resets (2 unread again)

---

## QR share / scan (mock)

| Item | Detail |
|---|---|
| Share URL | `MockVehicles.shareUrl(id)` → `https://nawasul.app/qr/{vehicleId}` |
| Share action | Copies that URL to clipboard (prototype; no OS share sheet yet) |
| Download action | Dialog confirming mock PNG save — no real file write |
| Scan (mobile) | `/scan` tab — `mobile_scanner` + camera permission; http/https opens externally via `url_launcher`; other payloads show result sheet |
| Scan (web) | Safe stub UI — no camera; does not crash Chrome preview |
| Duplicate lock | Same payload ignored for 3s while processing |

---

## Language preference (mock locale)

Prototype EN/AR switching — **persisted** across cold starts via SharedPreferences.

| Item | Detail |
|---|---|
| Provider | `appLanguageProvider` (`settings_provider.dart`) — AsyncNotifier `AppLanguage.english` / `.arabic` |
| Storage | SharedPreferences key `app_language` (`en` / `ar`) |
| Default | English (missing key) |
| Set from | Onboarding `/language` Continue; Settings → Language & Region Save |
| Effect | `MaterialApp.router` `locale` (`en` / `ar`) → RTL for Arabic; `appStringsProvider` swaps EN/AR maps |
| Strings file | `lib/core/l10n/app_strings.dart` |
| Covered UI | Login, bottom nav, Home; Register / OTP / Forgot / Account setup / Language / Onboarding; Account / Settings / Edit profile / Delete account / Notification prefs; My QR tab + QR screen; Vehicles list + add/edit + details; Alerts list + alert detail chrome; Scan messages; Subscription plans + PlanCard chrome + checkout/success; Sticker order/status; Help/contact chrome; Privacy/Terms titles |
| Still English (intentional) | MockLegal body paragraphs; MockFaq Q&A bodies; MockSubscription plan feature bullet lists (CMS/catalog copy) |
| Persistence | Survives app restart (like `mock_is_logged_in`) |

Backend later: store language on user profile; keep SharedPreferences as cache.

### Quick language test

1. Open `/language` (or Account → Settings → Language & Region)
2. Select **العربية** → Continue / Save
3. Expect RTL layout and Arabic copy on covered screens (Login, nav, Home, Account, QR, etc.)
4. Cold-start the app → language should stay Arabic
5. Switch back to English → LTR + English strings; restart keeps English

---

## Related mock modules

| File | Role |
|---|---|
| `mock_auth_data.dart` | Users, cities, `authenticate()`, `findUserByPhone()`, `verifyOtp()`, `mockOtp`, `mockProfilePhotoPng` |
| Auth repo (`auth/data/`) | Login / register / OTP / forgot-reset / session |
| Session (`session_provider.dart`) | Mock logged-in flag (`mock_is_logged_in`) |
| Language (`settings_provider.dart`) | Locale preference (`app_language` en/ar) |
| `mock_vehicles.dart` | Seed vehicles + `shareUrl()` |
| Vehicle repo (`vehicles/data/`) | Fetch + add/update/delete |
| `mock_alerts.dart` | Alerts feed (`seed()`, `isRead`) |
| Alerts repo + `alerts_provider.dart` | Refresh + mark-read / mark-all via repo |
| `mock_subscription.dart` | Plans / billing UI |
| Subscription repo | Plans + mock confirm (no payment) |
| `mock_sticker_orders.dart` | Sticker pricing + `create()` + sample seed |
| Sticker order repo + provider | In-memory mock sticker orders |
| `mock_faq.dart` | Help FAQ (loaded via `SupportRepository.fetchFaq`) |
| `mock_support.dart` | Contact Call / WhatsApp / Email URIs + `MockSupportTicket` |
| Support repo + inbox provider | FAQ / tickets / channels — help + contact screens |
| `mock_legal.dart` | Privacy / terms copy |
| Legal repo (`legal/data/`) | Privacy / terms via `LegalRepository` → screens |

When adding new mock credentials or users, update this file and `MockAuthData` together.
