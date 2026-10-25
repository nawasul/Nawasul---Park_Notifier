# Store readiness

Prepared for the first TestFlight and Play internal upload. Do not upload until the open items below are decided.

## Application id

`com.nawasul.app.mobileapp` on Android and iOS. This cannot be changed after the first upload. It is still the placeholder from the plan.

## What a release build does

A release build sets mock mode off and calls `https://api.nawasul.app` unless you pass `--dart-define=USE_MOCK=true` or `--dart-define=API_BASE_URL=...`. Debug and profile builds stay on the mock repositories. The debug home-state switcher is compiled out of release builds. There is no debug banner.

There is no Apple In-App Purchase or Google Play Billing dependency.

## Android signing

`android/key.properties` is gitignored. Copy `android/key.properties.example`, create an upload keystore outside the repo, and point `storeFile` at it. Until that file exists, a local release build is signed with the debug key so it can be installed, and it is not a Play upload.

## Review notes

Phone: the review number from `REVIEW_PHONE`.
Code: the review OTP from `REVIEW_OTP`.
That number does not send a WhatsApp message.
The account should already have one vehicle, an active sticker, and one alert.

The app sells a physical sticker. Payment opens a web page. Do not look for a subscription, plan, or in-app purchase.

## Privacy label (Apple) and Data safety (Google)

Collected, linked to the user, not used for tracking:

- Phone number
- Name
- City and delivery address
- Vehicle details (plate, make, model, color)
- Device push token
- Order history and alert history

Not collected unless a later decision turns them on: analytics, crash logs, advertising id, location, contacts, photos.

Marketing messages are optional and off by default. Service messages (codes, alerts, order updates) are part of continuing past the phone screen.

Account deletion is inside the app at Account, then Delete account. Google also needs the website deletion URL from the website phase.

## Store text

Nawasul sends a private alert when someone scans the sticker on your car. You get a push, a WhatsApp message, and an alert in the app. Your number is not shared. Alerts may be delayed or missed if the phone is off, muted, or offline.

Order a sticker for 3, 6, or 12 months. The sticker is delivered to your address. The app itself does not charge a fee.

## Policy checklist

| # | Item | Status |
|---|---|---|
| 1 | No IAP or Play Billing dependency | Checked in `pubspec.yaml` |
| 2 | No forbidden wording in the app or ARB files | Checked |
| 3 | Account deletion works with the mock repository | Checked in tests. Live `DELETE /me` is implemented and not run against staging |
| 4 | Privacy and Terms before login and from Account | Checked |
| 5 | Marketing consent optional and unchecked | Checked |
| 6 | Only the notification permission is requested | `POST_NOTIFICATIONS` and internet on Android. No camera, location, photo, contact, or microphone usage strings on iOS |
| 7 | Review account | Needs the backend flag and a staging test |
| 8 | Alert disclaimer | On alert details and notification settings |
| 9 | Privacy label and Data safety | Drafted above |
| 10 | Release build has no mock data and no debug banner | Mock mode is off in release. Banner is off |

## Not done on this machine

- Real-device push, alarm sound, Do Not Disturb, and Apple Pay
- TestFlight and Play internal upload (needs Apple and Google accounts)
- An iOS archive (this computer is Windows)
- Brand launcher artwork (the project still uses the Flutter placeholder icons)
- Firebase push (no `google-services` or Apple push key in the repo)
- A staging backend to walk the live journey, including the review account
