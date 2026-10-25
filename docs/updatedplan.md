# Nawasul — Updated Plan and Cursor Build Prompt (v1.0)

> Save this file as `docs/updatedplan.md` inside the workspace you are building (for the mobile app: `mobileapp/docs/updatedplan.md`).
> It supersedes earlier prompts, screen lists, and the subscription/calling plans. If anything in older docs conflicts with this file, **this file wins**.

---

## 0. How to use this file with Cursor

1. Open the app folder as its own Cursor workspace (`mobileapp/` for phases M0–M9).
2. Start a new **Agent** chat and paste:

   ```
   Read @docs/updatedplan.md fully. Do ONLY Phase M0 now (audit and plan, no code changes).
   Then stop and wait for my approval before starting the next phase.
   ```
3. After each phase, review the result in Chrome, then say: `Approved. Start Phase M<next>.`
4. Never ask Cursor to do several phases in one message.

---

## 1. Instructions to Cursor (read first, applies to every phase)

You are a senior Flutter engineer and UI engineer building the Nawasul mobile app. Follow these rules in every phase:

1. **Plan, then build.** At the start of each phase, write a short plan (files to create or change, risks). Build only what the phase lists.
2. **One phase at a time.** Finish the phase, report, then **stop and wait for approval**.
3. **No scope creep.** Do not add features, screens, packages, or settings that this file does not list. If you think something is missing, add it to the "Questions" list in your report instead of building it.
4. **Ask, don't guess, on business rules** (prices, validity, refunds, policy wording). Use the config values defined here and flag unknowns.
5. **Mock first.** Every screen works with mock data through repository interfaces (section 11). No real network calls until Phase M8.
6. **Theme discipline.** No hardcoded colors, text styles, spacings, radii, or shadows inside screens or widgets. Everything comes from the theme files (section 6). Do not change the color tokens.
7. **Reusability.** Check `lib/shared/widgets/` before building a new widget. If two screens need something similar, it becomes one configurable shared widget.
8. **Localization from the start.** Every user-facing string goes through ARB files (`en` and `ar`). No hardcoded strings. Layout must mirror correctly in Arabic (RTL).
9. **Performance rules.** No Lottie, no Rive, no `BackdropFilter` or blur, no heavy gradients that rebuild, at most 2 chained animations per widget, `const` constructors wherever possible.
10. **Quality gate for every phase:** run `flutter analyze` (must be clean), `flutter test` (must pass), and `flutter run -d chrome` (must launch and navigate). Paste the results.
11. **Web preview limits.** Chrome cannot test push notifications, the alarm sound, deep links from other apps, or Apple Pay. Build those behind interfaces with safe web fallbacks and mark them "needs real-device test".
12. **Security.** Never put API keys, tokens, or secrets in the app code or assets. Use `--dart-define` for the API base URL only. Store tokens in secure storage.
13. **Store policy guardrails (section 4) are requirements, not suggestions.** If a task would break one, stop and tell me.

**Phase report template** (use at the end of every phase):

```
Phase M<n> report
- Done: <list of screens/features>
- Files created/changed: <paths>
- flutter analyze: <result>
- flutter test: <result>
- How I verified in Chrome: <steps>
- Needs real-device test: <items>
- Assumptions made: <list>
- Questions for me: <list>
```

---

## 2. Product summary

**Nawasul (نواصل)** lets a car owner be alerted when someone needs them, without sharing the owner's phone number.

- The owner creates an account (phone verified by WhatsApp code), registers their vehicle(s), and buys a **physical QR sticker** for each vehicle. Each sticker pack is valid for 3, 6, or 12 months.
- The sticker goes on the car. A stranger scans it, which opens a public web page (not the app), picks a reason, and taps "Notify owner".
- The owner is alerted instantly by **three channels at once**: an alarm-style push notification, a WhatsApp message, and an entry in the in-app Alerts list.
- There is **no subscription and no in-app digital purchase.** The app is free. The only thing sold is a physical sticker, paid for on a web payment page (Tap Payments: mada, Apple Pay, cards).

**Apps in the system** (each independent, no shared code): `mobileapp` (Flutter), `website` (Next.js, includes the public QR scan page), `admin-dashboard` (Next.js), `backend` (FastAPI + Supabase).

---

## 3. Locked decisions

| Topic | Decision |
|---|---|
| Business model | Physical goods only. No subscription, no plans, no in-app purchase. |
| Sticker validity | 3, 6, or 12 months. **Starts at payment confirmation.** |
| Sticker print | **QR code only**, plus a short code under the QR (for example `NW-4821`). No plate number printed. |
| Login | Phone number + WhatsApp OTP. No password. One screen for sign-in and sign-up. |
| Backup login | Email code is **not** at launch. Show a clear message when a number has no WhatsApp. |
| Session | Long-lived session (refresh token about 90 days) so users rarely need a new code. |
| Alerts | Push (alarm-style) + WhatsApp message + in-app entry, sent together. No calls, no SMS. |
| Payment | Tap Payments hosted page, opened in the system in-app browser. Backend confirms by webhook. |
| Language | English and Arabic, with full RTL support. Language toggle on onboarding and in settings. |
| Theme | Light theme, existing orange/black/grey tokens (section 6). Do not change them. |
| Permissions | **Notifications only.** No camera, no photos, no location, no contacts in the owner app. |
| Vehicles | Minimal fields: plate, make, model, optional color. No photo upload at launch. |
| Orders | One vehicle per order. |
| Marketing | Optional and off by default. Not required to use the app. |

---

## 4. App Store and Google Play policy guardrails

> These summarize the public guidelines as understood at the time of writing. Verify the current wording at submission time.

### 4.1 Payments (the most important area)

| Rule | What it means for this app |
|---|---|
| Apple guideline 3.1.3(e): physical goods and services used outside the app must use non-IAP payment | The sticker is sold through Tap on a web page. **Do not use Apple In-App Purchase.** |
| Google Play payments policy: Play Billing must not be used for physical goods; digital subscriptions and features must use it | Same. **Do not use Google Play Billing.** |
| Digital goods and subscription services must use store billing | **Never sell or extend a digital service without shipping a physical sticker.** A renewal is always a new sticker order. |

**Wording rules.** The UI, store listing, screenshots, and review notes must never use: "Subscription", "Plan", "Upgrade", "Premium", "Free plan", "Pro", "Unlock", or "Extend". Use: "Sticker", "Sticker pack", "Order sticker", "Order a new sticker", "Valid until".

**Feature gating.** The app itself is free. Never lock app features (adding vehicles, viewing alerts) behind payment. The paid product is the physical sticker. Alert delivery happens outside the app (web scan page, WhatsApp), which keeps this a physical-goods purchase.

**Do not** link users to external digital purchases or show prices that look like a subscription ("per month").

### 4.2 Accounts and data

| Rule | Implementation |
|---|---|
| In-app account deletion is mandatory on both stores (Apple 5.1.1(v); Google account deletion policy) | Screen 25 plus `DELETE /me`. Google also needs a **web page URL** for deletion requests (built in the website phase). |
| Privacy policy must be reachable in the app and in the store listing | Screen 24, and a link on the Phone screen (before login). |
| Privacy labels (Apple) and Data safety form (Google) must match real data use | Data collected: phone number, name, city, address, vehicle details, device push token, order and alert history. Add analytics/crash data only if Firebase Analytics or Crashlytics are enabled. |
| Do not force marketing consent | WhatsApp consent for **service messages** (codes, alerts, order updates) is part of the terms. **Marketing is a separate, unchecked, optional box.** |
| No "Sign in with Apple" requirement is expected, because login is the app's own phone-number account and not a third-party social login | Confirm at submission. |

### 4.3 Review access

Reviewers cannot receive a WhatsApp code. The backend must support a **review account**:
- Environment variables `REVIEW_PHONE` and `REVIEW_OTP`, enabled by a flag.
- Only that one number may use the fixed code. It sends no WhatsApp message and is rate-limited.
- Put the number and code in the App Store Connect and Play Console review notes.
- The review account should have a sample vehicle, an active sticker, and a sample alert, so the reviewer sees real screens.

### 4.4 Permissions and notifications

| Platform | Requirement |
|---|---|
| iOS | Push capability. **Time-Sensitive notifications** capability (no special approval needed). **Do not request Critical Alerts** (Apple rarely grants it for this use). Notification permission is requested only after the explanation screen, and the user can continue if they say no. |
| Android | `POST_NOTIFICATIONS` runtime permission (Android 13+). A dedicated **alarm-style notification channel**. **Do not use** `USE_FULL_SCREEN_INTENT` or `USE_EXACT_ALARM` (restricted by Google to calling and alarm apps). Overriding Do Not Disturb is optional and user-granted through system settings. |
| Both | No camera, location, photo, contact, or microphone permission. Remove any package or manifest entry that requests them. |

### 4.5 Claims and content

- Do not present Nawasul as an emergency, safety, or security system. Say alerts are sent through push and WhatsApp and **may be delayed or missed if the phone is off, muted, or offline.**
- The scan page uses a **fixed list of reasons**, with no free text from strangers. Owners can "Report as spam".
- App completeness (Apple 2.1): no "Coming soon" screens, no placeholder text, no lorem ipsum, no mock data in release builds. Every button works.

### 4.6 Policy checklist (used in Phase M9)

| # | Item | Phase |
|---|---|---|
| 1 | No IAP or Play Billing code or dependency in the project | M1, M9 |
| 2 | No subscription wording anywhere (search the codebase and ARB files) | M7, M9 |
| 3 | Account deletion works end to end | M6, M8 |
| 4 | Privacy and Terms reachable before login and in settings | M2, M6 |
| 5 | Marketing consent optional and unchecked | M2 |
| 6 | Only the notification permission is requested | M9 |
| 7 | Review account configured and tested | M8, M9 |
| 8 | Alert disclaimer text present | M5, M6 |
| 9 | Privacy label and Data safety answers prepared | M9 |
| 10 | Release build has no mock data and no debug banners | M9 |

---

## 5. Scope

**In scope (launch):** 25 screens listed in section 8, WhatsApp OTP login, vehicles, sticker ordering and payment, alerts (push + WhatsApp + in-app), account, support, legal, Arabic and English.

**Out of scope (do not build):** subscriptions or plans, in-app purchase, calling or ringing screen, SMS, email login, password login, forgot password, QR scanning in the owner app, vehicle photos, share/download QR, multiple vehicles per order, chat, maps, charts, referral or promo codes, dark mode.

---

## 6. Design system

**Design goal:** minimal and to the point. One clear job per screen. Answer the question "Is my car protected, and did anyone alert me?" in a few seconds. No decorative extras.

### 6.1 Color tokens (already in `lib/core/theme/app_colors.dart`, do not change)

| Token | Hex | Use |
|---|---|---|
| `primary` | `#F2572B` | Primary buttons, active states, highlights (large or bold only) |
| `primaryDark` | `#D94A24` | Pressed states, gradient end |
| `primaryContainer` | `#FFE8E2` | Tinted icon backgrounds, soft highlights |
| `background` | `#DEDEDE` | Screen background |
| `surface` | `#FFFFFF` | Cards, inputs |
| `surfaceContainer` | `#ECECEC` | Secondary fills |
| `brandDark` / `textPrimary` | `#171717` | Headings, dark hero card |
| `secondary` / `textSecondary` | `#4D4D4D` | Body secondary text |
| `outline` / `outlineVariant` | `#4D4D4D` / `#CFCFCF` | Input borders, dividers |
| `textOnDark` | `#FFFFFF` | Text on dark surfaces |
| `textOnDarkSecondary` | `#A0A0A0` | Secondary text on dark surfaces |
| `surfaceDarkElevated` | `#222222` | Elevated parts on dark surfaces |
| `success` / `successContainer` | `#1B7A52` / `#DCF3E9` | Protected, delivered |
| `warning` / `warningContainer` | `#C45A00` / `#FFE8CC` | Expiring, pending |
| `error` / `errorContainer` | `#C62828` / `#FBE9E7` | Expired, failed |

**Gradients (define once in the theme, reuse):**
- `heroGradient`: `#171717` → `#2E2E2E` (top-left to bottom-right) with a faint orange glow (`primary` at about 12% opacity, radial, top-right corner). The glow is a static decoration, never blurred.
- `primaryGradient`: `#F2572B` → `#D94A24`. Used only on primary buttons and the center tab button.

**Accessibility note.** White text on orange is borderline for contrast. Keep button labels semibold 16px or larger. Never use orange for small body text. Check with a contrast tool, and if a pair fails, use `primaryDark`.

### 6.2 Typography

Poppins (Latin) and Noto Kufi Arabic (Arabic) via `google_fonts`. Use the theme text styles only.

| Style | Size / weight | Use |
|---|---|---|
| `displayL` | 34 / 700, spacing -0.8 | Big numbers (days left) |
| `headingL` | 24 / 600, spacing -0.4 | Screen titles |
| `headingM` | 19 / 600, spacing -0.2 | Section titles |
| `bodyL` | 16 / 400, line height 1.55 | Main text |
| `bodyM` | 14 / 400, line height 1.5 | Secondary text |
| `caption` | 12 / 500 | Labels, timestamps |
| `button` | 16 / 600 | Buttons |

### 6.3 Shape, spacing, depth, motion

- **Radius:** inputs and buttons 16, cards 20, hero card 28, pills 999.
- **Spacing:** 4 / 8 / 16 / 24 / 32 / 48. Screen padding 20. Use `EdgeInsetsDirectional`.
- **Depth:** soft shadow only (blur 24, opacity 0.07, offset y 8, tinted `#171717`). No blur filters.
- **Icons:** Phosphor Icons only (regular weight, filled when active). Decorative icons sit in a soft rounded square or circle (`primaryContainer` or `surfaceContainer`).
- **Motion:** fade and small slide on entry (200–300 ms), press scale to 0.97 on buttons, smooth tab transitions. Respect "reduce motion" (`MediaQuery.disableAnimations`). No Lottie, Rive, or blur.
- **Material 3** is enabled (`useMaterial3: true`) with the existing `AppTheme`. Use the themed `FilledButton`, `OutlinedButton`, `TextButton`, input theme, switch theme, and chip theme.

### 6.4 Shared widgets (build once, reuse everywhere)

`AppScaffold`, `AppBar` variant, `PrimaryButton` (with loading and disabled states, gradient), `SecondaryButton`, `OutlineButton`, `DestructiveButton`, `AppTextField`, `PhoneField` (+966, configurable), `OtpField` (6 boxes, `pinput`), `DropdownField`, `AppCard`, `HeroCard`, `StatusPill`, `SectionHeader`, `InfoBanner`, `EmptyState`, `ErrorState`, `OfflineBanner`, `SkeletonBox` (simple shimmer-free placeholder), `ListRow` (icon, title, subtitle, chevron), `AppBottomBar` with center button, `VehicleCard`, `AlertRow`, `OrderRow`, `PlateBadge`, `StepperTimeline`, `ConfirmDialog`, `LegalDocumentView`, `ValidityOptionCard`, `LanguageToggle`.

### 6.5 Arabic and RTL

- Mirror layouts, arrows, and chevrons. Keep plate text, codes, and phone numbers left-to-right inside their widgets.
- Use Western digits (0–9) in both languages for consistency.
- Arabic translations are drafts and must be reviewed by a native speaker before release.

---

## 7. Navigation

**Library:** `go_router`. **State:** Riverpod.

### 7.1 Structure

```
/splash
/onboarding
/auth/phone
/auth/verify
/auth/name
/auth/allow-alerts
/legal/:type            (privacy | terms | shipping)   <- reachable before login

ShellRoute (bottom bar visible)
  /home
  /vehicles
  /alerts
  /account

Pushed on top of the shell (no bottom bar)
  /vehicles/add
  /vehicles/:id
  /vehicles/:id/edit
  /vehicles/:id/qr
  /order/vehicle        (step 1)
  /order/delivery       (step 2)
  /order/review         (step 3)
  /order/result/:orderId
  /orders
  /orders/:orderId
  /alerts/:alertId
  /account/edit
  /account/notifications
  /account/help
  /account/delete
```

### 7.2 Bottom bar

Five slots: **Home · Vehicles · [＋ Order sticker] · Alerts · Account.**
The center button is a raised circular `primaryGradient` button. It opens `/order/vehicle`. An unread dot appears on Alerts.

### 7.3 Rules

- **Route guard:** unauthenticated users can only reach `/splash`, `/onboarding`, `/auth/*`, and `/legal/*`.
- **Startup:** valid session → `/home`. Otherwise onboarding not seen → `/onboarding`, else `/auth/phone`.
- **After verify:** new user → `/auth/name` → `/auth/allow-alerts` → `/home`. Returning user → `/home`.
- **Back behavior:** Android back from a shell tab goes to Home, then exits. Order steps keep entered data while moving back and forward.
- **Deep links:** `nawasul://alerts/<id>` (from a push tap) opens Alert details. `nawasul://order/<id>` opens the payment result. Links must work when the app is closed, in the background, and open.
- **Payment return:** the app never trusts the browser redirect. On return or on app resume, it re-fetches the order from the backend (section 9.3).

---

## 8. Screens (25)

Each screen lists content, states, actions, and notes. Every list screen needs loading, empty, and error states.

### Group A — Start

**1. Splash** (`/splash`)
- Logo centered on `background`, fade-in, maximum about 1.5 seconds or until the session check finishes.
- Routes as described in 7.3.

**2. Onboarding** (`/onboarding`)
- 3 slides: (1) "Add your car" (2) "Stick the QR on your car" (3) "Get alerted, privately. Your number is never shared."
- Each slide: large icon in a soft circle, heading, one short line.
- Top: language toggle (EN | AR) and "Skip". Bottom: page dots (active dot is a pill) and a primary button "Next", then "Get started" on slide 3.
- Default language: device language if Arabic or English, otherwise English. Persist the choice.

**3. Phone number** (`/auth/phone`)
- Title "Enter your number". Subtitle "We'll send a code on WhatsApp."
- `PhoneField`: +966 prefix, 9 digits starting with 5 (configurable, so other countries can be added later).
- Consent text: "By continuing you agree to our Terms and Privacy Policy, and to receive service messages (codes, alerts, order updates) on WhatsApp." Links open the legal screens.
- Separate **unchecked** optional checkbox: "Send me offers and news".
- Button "Continue" (disabled until valid). States: invalid number, too many attempts (show retry time), network error.

**4. Verify code** (`/auth/verify`)
- "Enter the 6-digit code we sent to WhatsApp" with the masked number, "Edit number", `OtpField`, resend timer (60 s), auto-submit on the sixth digit.
- Small link "Open WhatsApp".
- Errors: wrong code (shake and message, attempts left), expired code, too many attempts (locked, show time).
- **No-WhatsApp state:** "We couldn't deliver a code. Make sure this number has WhatsApp, or contact support." with a link to Help.
- Success: new user → Name. Returning user → Home.

**5. Your name** (`/auth/name`)
- Title "What should we call you?" Name (required, 2–50 characters), city (optional dropdown of Saudi cities). Button "Continue".

**6. Allow alerts** (`/auth/allow-alerts`) (shown once)
- Short explanation: alerts arrive instantly, with sound, and may be missed if the phone is off or muted.
- Button "Allow notifications" opens the system dialog. Secondary "Maybe later" (the user must be able to continue).
- Android only: an optional second step that explains how to let alerts ring loudly and opens the channel or Do Not Disturb settings.
- Always continues to Home. If notifications are denied, Home shows the "Alerts are blocked" banner.

### Group B — Vehicles

**7. Home** (`/home`)
- **Header:** "Good morning, {name}" and a bell (unread dot) that opens Alerts.
- **Protection card (hero, `heroGradient`):** vehicle make, model and `PlateBadge`, status, valid-until date, days left (`displayL`), thin progress bar. Swipes sideways when there are several vehicles, with page dots.
- **Quick actions (3 round buttons):** Add vehicle, Order sticker, My QR (opens the QR of the shown vehicle).
- **Recent alerts:** last 3 `AlertRow`s and "See all". Empty text: "No alerts yet."
- **One banner at most**, by priority: (1) notifications blocked, (2) sticker expiring within 14 days or expired, (3) payment pending.
- **Hero states:**

| State | Hero shows | Button |
|---|---|---|
| No vehicle | "Add your first vehicle" | Add vehicle |
| No sticker | "Not protected yet" | Order sticker |
| Payment pending | "Waiting for payment" | View order |
| In transit | "Sticker on the way", valid until date | View order |
| Active | "Protected", days left (success color) | none |
| Expiring (14 days or less) | "Expires soon" (warning) | Order new sticker |
| Expired | "Not protected" (error color) | Order new sticker |

**8. Vehicles** (`/vehicles`)
- List of `VehicleCard`s (make, model, plate, status pill). Top-right "Add". Tap opens details. Empty state with "Add vehicle".

**9. Add or edit vehicle** (`/vehicles/add`, `/vehicles/:id/edit`)
- Fields: plate (required, letters Arabic or English plus digits, with format hint), make (required, dropdown of common makes plus "Other"), model (required), color (optional color chips).
- Duplicate plate shows an error. Save opens Vehicle details. For a new vehicle, show the banner "Order a sticker to protect this car".

**10. Vehicle details** (`/vehicles/:id`)
- Vehicle header (`PlateBadge`, make, model). Status card (state, valid until, days left, progress).
- Buttons: primary "Order sticker" or "Order new sticker", secondary "View QR".
- Section: recent alerts for this vehicle (up to 5). Section: latest order row (opens Order details).
- Menu: Edit, Delete. Delete asks for confirmation and warns that an active sticker will stop working and that no refund applies.

**11. My QR** (`/vehicles/:id/qr`)
- Large QR (`qr_flutter`) encoding `https://<domain>/qr/<code>`, the short code (`NW-xxxx`), and the vehicle name.
- Button "Preview scan page" (opens the web page in the in-app browser).
- If there is no paid sticker: info "Your QR becomes active when your payment is confirmed."
- View-only. No share or download button.

### Group C — Order and payment

A 3-step flow with a progress indicator (1/3, 2/3, 3/3). Data is kept while moving between steps.

**12. Order step 1: Vehicle and validity** (`/order/vehicle`)
- Choose a vehicle (pre-selected when coming from a vehicle). "Add a new vehicle" opens a bottom sheet using the same minimal form.
- Three `ValidityOptionCard`s: 3, 6, 12 months with prices from `GET /pricing`. Show a "Best value" tag on the cheapest per-month option. Text: "Valid for 12 months from payment."
- If the vehicle already has time left, an info line explains that the new validity starts at payment.
- Continue.

**13. Order step 2: Delivery** (`/order/delivery`)
- Fields: full name (prefilled), phone (prefilled), city (dropdown), address (street, district, building), optional Saudi short address, optional notes.
- "Save this address" is checked by default. Shows the estimated delivery time from config.
- Continue.

**14. Order step 3: Review and pay** (`/order/review`)
- Summary card: vehicle, validity and valid-until date, delivery address (edit link).
- Price breakdown: sticker, delivery, VAT, total. Use `GET /pricing` (VAT rate and whether prices include VAT come from config).
- Accepted methods row: mada, Apple Pay, Visa, Mastercard (static labels).
- Text: "By paying you accept the Terms and Shipping and refunds policy."
- Button "Pay SAR {total}": create the order, request the payment link, open it with `url_launcher` in the **system in-app browser** (Safari View Controller on iOS, Custom Tabs on Android), not an embedded WebView.
- After returning, show "Confirming your payment…" and go to the result screen.

**15. Payment result** (`/order/result/:orderId`)
- States: **confirming** (poll the order about every 2 seconds, up to 60 seconds), **success** (order number, valid-until date, buttons "View order" and "Back to Home"), **failed** ("Try again" creates a new payment for the same order), **pending** ("We're confirming your payment. We'll notify you." with "Back to Home").
- Never show "Try again" while the status is unknown. This avoids double charges.

**16. Order details** (`/orders/:orderId`)
- Order number, status stepper (Paid → Printed → Shipped → Delivered with timestamps), vehicle, validity dates, delivery address, tracking number (copy) when available, "Download invoice" (opens link), "Need help with this order?" (opens Help).
- No cancel button at launch. Users contact support.

### Group D — Alerts

**17. Alerts** (`/alerts`)
- Notification center, grouped by day. Item types: car alert (alarm icon, reason, vehicle, time, delivery chips for push and WhatsApp), order update, sticker expiry notice.
- Unread dot. Pull to refresh. Opening an item marks it read. Empty state.

**18. Alert details** (`/alerts/:alertId`)
- Reason, vehicle, time, delivery rows (Push: delivered; WhatsApp: sent, delivered, read, or failed).
- Actions: **"Stop alarm"** (visible while the alert is recent and unacknowledged), **"I'm coming"** (sends an acknowledgment, then the button is disabled), "Report as spam" (confirm dialog).
- Footer note: "Alerts may be delayed or missed if your phone is off, muted, or offline."
- Reached from a push tap through the deep link.

### Group E — Account, support, legal

**19. Account** (`/account`)
- Header: avatar with initials, name, masked phone, edit icon.
- Rows: My orders, Notifications, Language (bottom sheet with AR | EN), Help and contact, Legal, Delete account, Log out (confirm). App version at the bottom.

**20. Edit profile** (`/account/edit`)
- Name (required), city. Phone is shown but locked ("To change your number, contact support").

**21. My orders** (`/orders`)
- List of `OrderRow`s (vehicle, validity, status pill, date). Empty state.

**22. Notification settings** (`/account/notifications`)
- Toggles: WhatsApp alerts, push alerts (at least one must stay on), alert style (**Loud alarm** or **Normal**), marketing messages (default off).
- "Send test alert" button (sends a real test through the backend and shows the delivery result).
- A checklist showing whether notifications are allowed and whether loud alerts are set up, with a "Fix" action that opens system settings.

**23. Help and contact** (`/account/help`)
- FAQ accordion (about 8 items): How does it work? Is my number visible? What if I'm not reachable? What if my sticker expires? How long does delivery take? Can I move the sticker to another car? Do alerts work when my phone is silent? How do I delete my account?
- Contact: WhatsApp support (`wa.me` link) and email. Texts are config values.

**24. Legal** (`/legal/:type`)
- One `LegalDocumentView` template used for Privacy Policy, Terms, and Shipping and refunds. Reachable from the Phone screen and the Account screen.

**25. Delete account** (`/account/delete`)
- Explains what happens: vehicles and alert history are removed, the sticker stops working, and records required by law (such as invoices) are kept.
- If a paid order is in progress, show a notice about it and a link to support.
- Optional reason. Red `DestructiveButton` opens a confirm dialog. On success: log out and go to the Phone screen.

### System states (shared widgets, not screens)

Empty, error with retry, offline banner, loading placeholders, expired session (silent refresh, then a redirect to Phone), "no WhatsApp" message, payment pending.

---

## 9. Functional specifications

### 9.1 Authentication (WhatsApp OTP)

- Request: phone (E.164, `+9665XXXXXXXX`). Backend creates a 6-digit code, stores a hash with a 5-minute expiry, limits attempts, and rate-limits requests per phone and per device.
- The code is sent as a WhatsApp **authentication template**.
- Verify returns an access token (short life) and a refresh token (about 90 days, rotated on use) and `isNewUser`.
- The app stores tokens in secure storage and refreshes silently. A refresh failure logs the user out.
- Logout revokes the refresh token and the device push token.

### 9.2 Vehicles

- Fields: `plate`, `make`, `model`, `color?`. Backend assigns a stable `qrCode` (token) and `shortCode` (`NW-xxxx`) per vehicle. The QR stays the same across renewals.
- `protectedUntil` (date) is stored on the vehicle and is updated when a payment is confirmed.

### 9.3 Orders and payment

Order statuses (backend): `pending_payment`, `paid`, `printed`, `shipped`, `delivered`, `payment_failed`, `cancelled`, `expired`.

**Flow:**
1. App sends `POST /orders` with vehicle, months, delivery. Backend creates the order as `pending_payment` and calculates prices.
2. App calls `POST /orders/{id}/pay`. Backend creates the Tap charge and returns `paymentUrl`.
3. App opens `paymentUrl` in the in-app system browser.
4. Tap calls the backend webhook. Backend verifies it, marks the order `paid` (idempotent, so repeated webhooks are safe), sets `paidAt`, and updates the vehicle's `protectedUntil`.
5. App returns, polls `GET /orders/{id}`, and shows the result.
6. Unpaid orders expire after about 30 minutes.

**Validity rule (one function only):**

```dart
DateTime computeProtectedUntil(DateTime paidAt, int months, {int bufferDays = 0})
// = paidAt + months (calendar months) + bufferDays
```

Keep this logic in one place with unit tests, because the rule may change (see section 17).

**Protection state (derived, one function with unit tests):**

```
if no vehicle                       -> noVehicle
if no paid order                    -> noSticker (or paymentPending if an order is pending)
if now > protectedUntil             -> expired
if latest paid order not delivered  -> inTransit
if daysLeft <= 14                   -> expiring
else                                -> active
```

### 9.4 Alerts and notifications

**When a stranger taps "Notify owner"** (web page → backend), the backend sends three things at once:

| Channel | Details |
|---|---|
| Push | `car_alert` category. iOS: Time-Sensitive interruption level with a custom sound (about 30 seconds maximum). Android: high-priority message, alarm-style channel, repeating sound until dismissed (insistent), no full-screen intent. |
| WhatsApp | Approved **utility** template with vehicle, reason, and time. Neutral wording, no promotions. |
| In-app | An Alerts list entry with delivery status updates from webhooks. |

**Other push types:** `order_update` and `sticker_expiry` (reminders at 14, 7, and 1 days before expiry). Reminders and order updates use **push only** (not WhatsApp) to save WhatsApp quota and avoid marketing classification.

**Reasons (fixed list):** Blocking another car · Lights left on · Door or window open · Flat tire or damage · Other, urgent.

**Notification service interface** (implemented in Phase M5, real FCM in M8):

```dart
abstract class NotificationService {
  Future<bool> requestPermission();
  Future<String?> getPushToken();
  Stream<NotificationEvent> get onTap;       // opens deep links
  Future<void> showAlarmAlert(AlertPayload p); // Android alarm channel
  Future<void> stopAlarm(String alertId);
}
```

Chrome uses a no-op implementation.

### 9.5 Account deletion

`DELETE /me` removes personal data, deactivates QR codes, revokes sessions, and keeps only legally required records (such as invoices). The app then clears local storage and returns to the Phone screen.

### 9.6 Localization

ARB files in `lib/l10n/` (`app_en.arb`, `app_ar.arb`) with `flutter gen-l10n`. Dates, numbers, and currency use `intl`. Currency is shown as "SAR 150" in English and "150 ر.س" in Arabic.

---

## 10. Data models and API contract

### 10.1 Models (Dart, immutable)

`User(id, name, phone, city?, preferences)`, `Preferences(whatsappAlerts, pushAlerts, alarmStyle, marketing)`, `Vehicle(id, plate, make, model, color?, qrCode, shortCode, protectedUntil?)`, `PricingItem(months, priceSar)`, `Pricing(items, deliveryFeeSar, vatRate, pricesIncludeVat, deliveryEta)`, `Order(id, number, vehicleId, months, status, amounts, delivery, paidAt?, protectedUntil?, trackingNumber?, invoiceUrl?, timeline)`, `DeliveryDetails(name, phone, city, address, shortAddress?, notes?)`, `AlertItem(id, type, vehicleId?, reason?, createdAt, readAt?, ackAt?, deliveries)`, `DeliveryStatus(channel, status)`.

### 10.2 API (mobile-facing, prefix `/api/v1`)

| Area | Endpoint |
|---|---|
| Auth | `POST /auth/otp/send` · `POST /auth/otp/verify` · `POST /auth/refresh` · `POST /auth/logout` |
| Profile | `GET /me` · `PATCH /me` · `DELETE /me` · `GET /me/preferences` · `PATCH /me/preferences` |
| Devices | `POST /devices` (push token, platform, locale) · `DELETE /devices/{id}` |
| Vehicles | `GET /vehicles` · `POST /vehicles` · `GET /vehicles/{id}` · `PATCH /vehicles/{id}` · `DELETE /vehicles/{id}` |
| Pricing | `GET /pricing` |
| Orders | `POST /orders` · `POST /orders/{id}/pay` · `GET /orders` · `GET /orders/{id}` · `GET /orders/{id}/invoice` |
| Alerts | `GET /alerts` · `GET /alerts/{id}` · `POST /alerts/{id}/ack` · `POST /alerts/{id}/report` · `POST /alerts/test` |
| Public (website) | `GET /qr/{code}` · `POST /qr/{code}/notify` |
| Webhooks | `POST /webhooks/tap` · `GET/POST /webhooks/whatsapp` |

Errors use one shape: `{ "code": "...", "message": "..." }` and the app maps codes to localized messages.

### 10.3 Configuration values (not hardcoded in screens)

Sticker prices for 3, 6, 12 months, delivery fee, VAT rate (15%), whether prices include VAT, estimated delivery time, support WhatsApp number and email, expiry reminder days, `shippingBufferDays` (default 0). The app reads pricing from `GET /pricing` and uses mock values until M8.

---

## 11. Mock-first architecture

- Each feature defines an abstract repository (`AuthRepository`, `VehicleRepository`, `OrderRepository`, `AlertRepository`, `AccountRepository`, `PricingRepository`).
- `Mock*Repository` implementations hold in-memory data with realistic Saudi-context values and small artificial delays (300–600 ms).
- A single flag `AppConfig.useMock` (set by `--dart-define=USE_MOCK=true`) selects the implementation through Riverpod providers.
- Mock data must cover every state: user with no vehicle, vehicle with no sticker, payment pending, in transit, active, expiring, expired, failed payment, empty alerts.
- Add a **debug-only** state switcher (hidden in release builds) so every Home state can be reviewed without editing code.

---

## 12. Packages

**Use:** `flutter_riverpod`, `go_router`, `google_fonts`, `flutter_animate`, `phosphor_flutter`, `pinput`, `intl`, `flutter_localizations` (SDK), `dio`, `flutter_secure_storage`, `shared_preferences`, `qr_flutter`, `url_launcher`.
**Added in later phases:** `firebase_core`, `firebase_messaging`, `flutter_local_notifications`, `app_links` (deep links), `package_info_plus`.
**Remove if present:** `mobile_scanner`, `lottie`, `flutter_screenutil` (unless already used consistently), `google_nav_bar` (custom bottom bar instead), any in-app purchase package.
Add a package only when its phase needs it. Do not leave unused dependencies.

---

## 13. Folder structure

```
lib/
  core/
    config/          # app_config.dart (flags, base URL), constants
    theme/           # app_colors, app_typography, app_spacing, app_radius, app_shadows, app_gradients, app_theme
    router/          # app_router.dart, route names, guards
    network/         # dio client, interceptors (M8)
    notifications/   # notification_service.dart (+ web no-op)
    utils/           # validators, formatters, date helpers
    mock/            # mock repositories and seed data
  features/
    auth/            # data / domain / presentation
    onboarding/
    home/
    vehicles/
    orders/
    alerts/
    account/
    support/         # help, legal
  shared/
    widgets/
  l10n/              # app_en.arb, app_ar.arb
  main.dart
test/
  unit/              # validity, protection state, validators
```

---

## 14. Phases — mobile app (`mobileapp/`)

Run each phase in a fresh Agent message. After each, produce the phase report and wait for approval.

### Phase M0 — Audit and plan (no code changes)
- Inspect the current project: folders, packages, theme files, existing screens and widgets, router, mock data.
- Produce a table: **keep / modify / delete / new** for every file or folder.
- List everything that conflicts with this plan (subscription, password login, forgot password, camera permission, calling or ringing code, unneeded packages).
- Propose the final folder tree and the phase-by-phase file list.
- List questions.
- **Done when:** I approve the audit and the plan.

### Phase M1 — Foundation and cleanup
- Delete or archive out-of-scope screens, models, and packages (section 5 and 12).
- Verify theme tokens match section 6 (do not change values), add `app_gradients.dart`, finish `AppTheme`.
- Set up `flutter gen-l10n` with `app_en.arb` and `app_ar.arb` (starter keys), locale switching, and RTL check.
- Build the router skeleton with the shell, all routes in section 7 pointing to temporary placeholder pages (developer only, removed by the end of the phase that builds each screen), and route guards.
- Define models, enums, repository interfaces, mock repositories, providers, and `AppConfig`.
- Build the shared widgets listed in 6.4 that every phase needs first: `AppScaffold`, buttons, `AppTextField`, `PhoneField`, `OtpField`, `AppCard`, `StatusPill`, `SectionHeader`, `EmptyState`, `ErrorState`, `AppBottomBar` with center button.
- Unit tests for `computeProtectedUntil`, protection state derivation, phone and plate validators.
- **Done when:** the app launches in Chrome, the bottom bar and route skeleton work, analyzer and tests are clean.

### Phase M2 — Start and sign-in (screens 1–6)
- Splash, Onboarding with language toggle, Phone, Verify, Name, Allow alerts, plus the Legal screen template (needed from the Phone screen).
- Mock auth: any phone works, code `123456` succeeds, other codes fail. Include all error states.
- **Done when:** a new user can go from Splash to an empty Home, and a returning user goes straight to Home. English and Arabic both work.

### Phase M3 — Home and vehicles (screens 7–11)
- Home with all hero states, quick actions, recent alerts, banner priority. Vehicles list, Add and edit vehicle, Vehicle details, My QR.
- The debug state switcher shows every hero state.
- **Done when:** adding, editing, and deleting a vehicle works across Home, Vehicles, and Details.

### Phase M4 — Order and payment (screens 12–16)
- 3-step flow, pricing from the mock repository, order creation, mock "payment" that simulates success, failure, and pending paths, result screen with polling, Order details, My orders.
- Inline "Add a new vehicle" sheet in step 1.
- **Done when:** a mock order moves a vehicle from "No sticker" to "In transit" to "Active", and all payment outcomes are reachable from the debug switcher.

### Phase M5 — Alerts and notifications (screens 17–18)
- Alerts list, Alert details, "Stop alarm", "I'm coming", "Report as spam".
- Define `NotificationService` with the web no-op. Add a mock "simulate alert" action (debug only) that creates an alert and opens its details.
- Build the Android alarm channel and iOS Time-Sensitive configuration **as code and documentation only** if they cannot be tested in Chrome, and list them under "needs real-device test".
- **Done when:** alerts appear in the list and on Home, deep links open the right screen, and read and acknowledged states update.

### Phase M6 — Account, support, legal (screens 19–25)
- Account, Edit profile, Notification settings (including test alert and the check list), Help and contact, Legal documents, Delete account.
- Log out and delete account clear local data and return to the Phone screen.
- **Done when:** every row on Account opens a working screen, and deletion works with the mock repository.

### Phase M7 — Quality pass
- Complete empty, loading, error, and offline states on every list screen.
- Full Arabic and RTL review of all 25 screens (mirroring, alignment, number and plate direction).
- Accessibility: text scale 1.3 does not break layouts, tap targets at least 48 px, labels for icon buttons, contrast check.
- Performance check with `flutter run -d chrome --profile`: smooth scrolling and transitions.
- Search the codebase and ARB files for forbidden wording (section 4.1) and fix.
- Remove dead code, unused packages, and temporary placeholders.
- **Done when:** analyzer and tests are clean and a written QA list for all 25 screens passes.

### Phase M8 — Backend integration
- Implement the Dio client with token refresh, error mapping, and the real repositories behind `useMock=false`.
- Connect real push (`firebase_messaging`, device token registration), deep links, and real alert delivery status.
- Connect pricing, orders, payment link, and invoice link.
- Run against the staging backend and test the review account.
- **Done when:** the full journey works against staging with mock mode off.

### Phase M9 — Store readiness
- Android: manifest permissions (only `POST_NOTIFICATIONS`, internet), alarm channel, signing, app icon, adaptive icon, splash.
- iOS: Push and Time-Sensitive capabilities, `Info.plist` (no unused permission strings), icons, launch screen.
- Final application ID decision (currently `com.nawasul.app.mobileapp`). Change before the first store upload because it cannot be changed after.
- Real-device tests on iPhone and Android: push in background and closed states, alarm sound on silent and Do Not Disturb, battery-saver devices, deep links, payment in the system browser including Apple Pay.
- Complete the policy checklist (section 4.6), prepare review notes, privacy label and Data safety answers, screenshots, and store descriptions without forbidden wording.
- Build release versions, upload to TestFlight and the Play internal testing track.
- **Done when:** the policy checklist is fully checked and both test builds are installable.

---

## 15. Other apps (separate workspaces, summary)

Run these in their own Cursor windows with their own plan files. Update the existing `prompt.md` files to match the decisions in section 3.

| App | Phase | Work |
|---|---|---|
| **backend** | B1 | Models and migrations: users, vehicles, orders, order_events, alerts, alert_deliveries, devices, otp_codes, notification_logs, pricing config |
| | B2 | Auth: WhatsApp OTP service, rate limits, tokens, review account |
| | B3 | Vehicles, pricing, orders, Tap charge creation, webhook verification (idempotent), invoice generation |
| | B4 | Alerts: public QR endpoints, rate limits per QR, push (FCM/APNs), WhatsApp utility template, delivery webhooks |
| | B5 | Expiry reminder jobs, account deletion, admin endpoints, deployment |
| **website** | W1 | Company pages, Products section, Nawasul pages (no pricing "plans", show sticker packs instead) |
| | W2 | `/qr/[code]` scan page (fixed reasons, no login, minimal, noindex, expired and invalid states, "owner is on the way" state) |
| | W3 | Payment return page, delete-account request page (needed by Google), privacy, terms, shipping and refunds |
| **admin-dashboard** | A1 | Remove Subscriptions. Orders pipeline (paid, printed, shipped, delivered) with CSV export and tracking |
| | A2 | Users, vehicles (QR deactivate), notification logs (replaces Call Logs), support tickets, audit log |
| | A3 | Settings: pricing, rate limits, integration health (WhatsApp, Tap, push) |

---

## 16. Definition of done (every phase)

- `flutter analyze` is clean, `flutter test` passes, the app launches in Chrome.
- No hardcoded colors, text styles, spacing, or user-facing strings.
- Every list screen has loading, empty, and error states.
- Screens work in English (LTR) and Arabic (RTL).
- No forbidden wording from section 4.1.
- The phase report is written and the agent has stopped for approval.

---

## 17. Open items (flag, do not decide silently)

| # | Item | Default until decided |
|---|---|---|
| 1 | Final application ID and bundle ID | `com.nawasul.app.mobileapp` (decide before first store upload) |
| 2 | Sticker prices, delivery fee, whether prices include VAT | Placeholder values in mock config |
| 3 | Validity when a vehicle still has an active sticker | Validity starts at payment (the function can change later) |
| 4 | Shipping buffer added to validity | 0 days |
| 5 | Saudi numbers only at launch, or other countries | Saudi (+966) only, configurable |
| 6 | Deleting an account with a paid order in progress | Allowed, with a notice and a link to support |
| 7 | Replacement stickers for lost or damaged stickers | Not at launch (handled by support) |
| 8 | Firebase Analytics and Crashlytics | Off until decided (affects privacy forms) |
| 9 | Arabic translations | Drafts, native review required |
| 10 | Support WhatsApp number and email | Placeholder config values |
