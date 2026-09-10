<!-- BEGIN:nextjs-agent-rules -->

# This is NOT the Next.js you know

This version has breaking changes — APIs, conventions, and file structure may all differ from your training data. Read the relevant guide in `node_modules/next/dist/docs/` (resolved from this file's directory; in monorepos the `next` package may not be visible from the repo root) before writing any code. Heed deprecation notices.

This block is written and re-added by `next dev` — verify at `node_modules/next/dist/server/lib/generate-agent-files.js`. Removing it from a diff only re-creates the uncommitted change; committing it with your work keeps the tree clean.

<!-- END:nextjs-agent-rules -->

## Build Log

### Phase 1 — Design tokens + fonts (2026-09-04)
- Replaced blue brand tokens with orange/black/grey system from `mobileapp/docs/design.json`
- Mapped Tailwind v4 `@theme` named colors (`primary`, `surface`, `text-primary`, etc.) via `--nw-*` CSS vars
- Loaded Poppins + Noto Kufi Arabic in root layout; RTL body uses Arabic font
- Key files: `styles/tokens.css`, `app/globals.css`, `app/layout.tsx`

### Phase 2 — Shared UI components (2026-09-04)
- Built `Button` (primary/secondary/outline), `Card`, `Badge`/`StatusPill`, `Input`, `Textarea`, `Accordion`
- All styles use design tokens only (no arbitrary hex)
- Key files: `components/ui/*`

### Phase 3 — next-intl + shell (2026-09-04)
- Wired next-intl with `i18n/routing.ts`, `navigation.ts`, `request.ts`, `proxy.ts` (Next.js 16), plugin in `next.config.ts`
- Locales: `en` (default), `ar` with RTL via `LocaleHtmlAttributes` + layout `dir`
- Message files: `messages/en.json`, `messages/ar.json` (Arabic is placeholder — native review needed)
- Navbar (lang switcher + mobile menu) and Footer
- Marketing shell: `app/[locale]/layout.tsx`
- Key files: `i18n/*`, `proxy.ts`, `components/sections/Navbar.tsx`, `Footer.tsx`

### Phase 4 — Company pages (2026-09-04)
- Home, About, Contact (mock form submit), Privacy, Terms under `app/[locale]/`
- Each page has `generateMetadata` (title/description/OG where relevant)
- Removed legacy `app/(marketing)/` stubs

### Phase 5 — Products section (2026-09-04)
- Data-driven catalog: `lib/products.ts` (`products[]` + `getProductById`)
- Routes: `/products`, `/products/nawasul`, plus features/pricing/faq under nawasul
- Pricing mirrors mobile Free/Pro/Premium (SAR); CTA = download app (no web checkout)
- FAQ mirrored from mobile `mock_faq.dart`
- Components: `ProductGrid`, `PricingTable`, `FAQAccordion`

### Phase 6 — QR landing (2026-09-04)
- `/qr/[code]` outside marketing chrome; `robots: noindex`
- Mock API in `lib/api.ts`: `getQrInfo`, `notifyQrOwner`, `QrNotFoundError`
- Demo codes: `DEMO01`, `DEMO02`; other codes → friendly error
- Components: `QRLandingClient`, vehicle summary, reason chips, notify button, success/error states
- Locale from `NEXT_LOCALE` cookie (fallback `en`); footer link to Nawasul product page

### Phase 7 — Verify (2026-09-04)
- `npm run build` passed (exit 0) — EN/AR SSG routes + dynamic `/qr/[code]`
- Proxy/middleware active for locale routing; QR excluded from locale prefix matcher

## Deliverable checklist
- Routes: `/[locale]`, `/about`, `/products`, `/products/nawasul` (+ features/pricing/faq), `/contact`, `/privacy`, `/terms`, `/qr/[code]`
- Products config: `lib/products.ts` — append objects to add products later
- QR mock flow: load → summary + chips → notify → success; invalid → error
- Bilingual EN/AR + RTL wired for marketing + QR copy
- Build clean
- Assumptions to review: company name “Nawasul Group”, hero positioning copy, placeholder team, legal pages, Arabic translations, App Store/Play links
