# Nawasul Group — Company Website (Next.js) — Master Build Plan

## Context: What this website actually is

This is NOT just the Nawasul product's marketing site. This is the **parent company's website** — a company that builds and launches digital products, with Nawasul being one of its products (possibly the flagship/first one, with more to follow). The site must therefore:

1. Portray the COMPANY as a product studio/builder — one that turns ideas into meaningful, real, shipped products
2. Showcase LAUNCHED PRODUCTS (Nawasul being the first entry, structured so more products can be added later without rebuilding the page)
3. Contain Nawasul's own product-specific pages (features, pricing, FAQ) either as sub-pages or a dedicated product section
4. Serve the QR notification landing page (`/qr/[code]`) — the functional, non-marketing part of the site that real end-users (people who scan a sticker) will actually land on

Treat this as two intertwined experiences: a polished company/agency-style site for visitors evaluating the company, and a lightweight, fast, functional utility page for QR scanners who just need to send a notification.

## Tech stack (already scaffolded — confirm, don't recreate)

- Next.js 16, App Router, React 19, TypeScript
- Tailwind CSS
- next-intl (bilingual English / Arabic, RTL support required)
- Folder already exists at project root: `website/` with `app/(marketing)/`, `app/qr/[code]/`, `components/`, `styles/tokens.css`, `lib/api.ts`

## PHASE 0 — Plan before building (do this first, show me the plan before writing code)

Before writing any code, respond with:
1. A proposed sitemap (every route/page)
2. A proposed component inventory (what's reusable across pages)
3. Confirmation of how you'll structure the "Products" section so it's easy to add a second/third product later without restructuring
4. Any clarifying assumptions you're making

Wait for my go-ahead on the plan before starting implementation, unless the plan is straightforward — if so, proceed but clearly state the assumptions you made.

## Design system — use the existing design tokens, do not invent new colors

Reference `@docs/design.json` if it exists in the project (check first), and mirror whatever color/typography/spacing/radius system is defined there — this must be VISUALLY CONSISTENT with the Flutter mobile app's current theme (bold orange primary `#F2572B`, dark near-black `#171717` for dark surfaces/text, neutral greys for backgrounds, white cards). Do not default to the old blue brand-guide colors — the actual current system is the orange/black/grey one. If `design.json` isn't present in this project folder, ask me for the current color values before proceeding rather than guessing.

Typography: Poppins (Latin) + Noto Kufi Arabic (Arabic) — matches the mobile app.

Build this as an actual Tailwind config extension (`tailwind.config.ts`) with named colors (e.g. `primary`, `surface`, `background`, `textPrimary`, etc.) mapped to the exact hex values — every component must use these Tailwind color tokens, never arbitrary hex values inline in className strings.

## Site structure — full page list

### Company / Marketing pages (`app/(marketing)/`)
1. **Home (`/`)** — Company-level homepage, NOT Nawasul-specific. Hero section establishing the company's identity ("We turn ideas into meaningful products" or similar positioning), a preview/teaser of the Products section, a brief "How we work" or "What we do" section, and a call-to-action (contact / explore products).
2. **About (`/about`)** — Company story, mission, what "executing ideas into meaningful products" means in practice, team section (can use placeholder/mock team data for now).
3. **Products (`/products`)** — THE KEY SECTION. A grid/list of launched products, each as a card (logo/icon, name, one-line description, status badge like "Live"/"Coming Soon", link to that product's detail page). Build this as a **data-driven** list (a `products.ts` config file with an array of product objects), NOT hardcoded JSX per product — so adding product #2 later is just adding an entry to the array, not rebuilding the page.
4. **Product Detail — Nawasul (`/products/nawasul`)** — Full product page for Nawasul specifically: what it does, how it works (register vehicle → get QR → get notified privately), screenshots/mockup placeholders, link to download on App Store/Play Store (placeholder links for now), link through to Nawasul's own Features/Pricing/FAQ pages.
5. **Nawasul Features (`/products/nawasul/features`)**
6. **Nawasul Pricing (`/products/nawasul/pricing`)** — reflect the Free/Pro/Premium plan structure already defined in the mobile app's subscription screens
7. **Nawasul FAQ (`/products/nawasul/faq`)** — reuse FAQ content style/structure from the mobile app's Help/FAQ screen if available, otherwise write realistic placeholder FAQs
8. **Contact (`/contact`)** — company-level contact form + info (not Nawasul-support-specific — this is "get in touch with the company," e.g. for partnerships, press, or general inquiries)
9. **Privacy Policy (`/privacy`)** — company-level privacy policy
10. **Terms & Conditions (`/terms`)** — company-level terms

### Functional / Utility route (NOT part of marketing navigation)
11. **QR Landing Page (`/qr/[code]`)** — see detailed spec below. This route is NOT linked from the main nav — it's only ever reached by scanning a physical QR sticker.

## QR Landing Page — detailed functional spec (from architecture docs)

This is the most functionally important page on the site — build it carefully:

- URL pattern: `/qr/[code]` where `[code]` is the unique QR identifier printed on the vehicle sticker
- **Purpose**: A stranger scans a sticker on someone's car and needs to notify the owner WITHOUT ever seeing the owner's phone number
- **Page behavior**:
  1. On load, call the backend (`GET /api/v1/qr/{code}` via `lib/api.ts` — build this as a typed fetch function, but since backend isn't live yet, MOCK the response for now with a realistic shape: `{ vehicleMake, vehicleModel, plateNumberMasked, ownerFirstName }` — note: mask or omit anything overly identifying, this is a privacy-sensitive page even in its content, not just its notify action)
  2. Display minimal vehicle info (e.g. "Toyota Camry — ABC 1234") so the scanner can confirm they scanned the right car
  3. Show a clear primary action: "Notify Owner" button
  4. Below/before that, show quick-reason chips the scanner can optionally select (e.g. "Blocking my car", "Lights left on", "Flat tire", "Other") — selecting one should feed into the notify action
  5. Tapping "Notify Owner" should call (mock for now) `POST /api/v1/qr/{code}/notify` and show a clear success state ("Owner has been notified via call/notification")
  6. Handle the invalid/expired QR code state gracefully (code doesn't exist → clear, friendly error message, not a generic 404)
- **Design requirements specific to this page**:
  - Must work perfectly on mobile web (this is ALWAYS opened on a phone browser immediately after scanning — assume zero desktop traffic here)
  - Must load FAST — this page should be the leanest, most optimized page on the whole site (minimal JS, no heavy imagery) since someone is standing next to a car wanting quick action, not browsing
  - No main navigation/header clutter — a minimal, focused, single-purpose layout (maybe just the Nawasul logo small at top, nothing else from the main site chrome)
  - Should NOT require login/signup — this must work for any random stranger
  - Include a small, unobtrusive footer link like "What is Nawasul?" that links back to the main site for the curious, but the primary flow must not require leaving this page

## Component inventory to build (in `components/`)

- `components/ui/` — Button (primary/secondary/outline variants matching Tailwind tokens), Card, Badge/StatusPill, Input, Accordion (for FAQ)
- `components/sections/` — Hero, ProductCard, ProductGrid, FeatureGrid, PricingTable, FAQAccordion, ContactForm, Footer, Navbar (with language switcher for next-intl)
- `components/qr/` — QRVehicleSummary, QRNotifyButton, QRReasonChips, QRSuccessState, QRErrorState (all specific to the QR landing page, kept separate from marketing components since this page has different design constraints)

## Bilingual / RTL requirements

- Wire up next-intl properly: locale-based routing (`app/[locale]/...`), message files for `en` and `ar` under a `messages/` or `i18n/` folder
- Every page listed above needs both English and Arabic content (can use reasonable placeholder Arabic translations for now, flag that these should be reviewed by a native speaker later)
- Test that layout flips correctly in RTL mode — especially the Products grid, Navbar, and QR landing page's button/chip layout
- Include a visible language switcher in the Navbar

## SEO & metadata

- Every marketing page needs proper `generateMetadata` (title, description, OG tags) — this is a real company site, SEO matters
- The QR landing page should be `noindex` (it's not meant to be discovered via search, only via physical sticker scan) — set this explicitly in its metadata

## What I want you to explicitly NOT do

- Do not fetch from or hardcode any real backend URL yet — use typed mock functions in `lib/api.ts` that return realistic mock data, structured so swapping in real fetch calls later is a small change, not a rewrite
- Do not add real payment/checkout logic on the Pricing page — it should link to the mobile app or show "Download the app to subscribe," not process payment on web (unless you tell me otherwise later)
- Do not hardcode Arabic/English strings directly in components outside the next-intl message system — every user-facing string must go through the translation system from the start, not be retrofitted later

## Execution order

1. Phase 0 planning (sitemap + component inventory + confirm design token source) — show me first
2. Tailwind config + design tokens setup
3. Shared UI components (`components/ui/`)
4. next-intl setup + Navbar/Footer with language switching
5. Company pages: Home, About, Contact, Privacy, Terms
6. Products section: `/products` index (data-driven) + Nawasul product detail + Features + Pricing + FAQ
7. QR Landing Page (`/qr/[code]`) — build this carefully per the detailed spec above, it's functionally the most important route
8. Run `npm run build` to confirm no build errors, and `npm run dev` for me to review locally

## Deliverable at the end

1. Full list of routes/pages created
2. Confirm the Products section is data-driven (show me the products config structure)
3. Confirm QR landing page mock data flow and how notify/error states work
4. Confirm bilingual EN/AR + RTL works across at least the Home, Products, and QR landing pages
5. Confirm `npm run build` passes cleanly
6. Flag any assumption made about company positioning/copy that I should review and replace with real content later