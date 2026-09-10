<!-- BEGIN:nextjs-agent-rules -->

# This is NOT the Next.js you know

This version has breaking changes — APIs, conventions, and file structure may all differ from your training data. Read the relevant guide in `node_modules/next/dist/docs/` (resolved from this file's directory; in monorepos the `next` package may not be visible from the repo root) before writing any code. Heed deprecation notices.

This block is written and re-added by `next dev` — verify at `node_modules/next/dist/server/lib/generate-agent-files.js`. Removing it from a diff only re-creates the uncommitted change; committing it with your work keeps the tree clean.

<!-- END:nextjs-agent-rules -->

# Nawasul Admin Dashboard — Build Progress

Progress log for the operations dashboard built from `prompt.md`. Keep the Next.js agent-rules block above intact.

## Assumptions (review)

1. Mock auth only — seeded admins in `lib/mock/mock-admins.ts`, password `nawasul-admin`, session in `localStorage`.
2. No real backend — mutations update in-memory mock arrays for the browser session.
3. QR order + subscription details use right Drawer; user/vehicle/support use `/[id]` pages.
4. CSV export is client-side blob download (`lib/csv.ts`).
5. Forgot password is UI stub only.
6. MUI 9 APIs: layout props like `alignItems`/`justifyContent` on `Stack`, and `fontWeight` on `Typography`, go via `sx`; drawers use `slotProps.paper` (not `PaperProps`).
7. Design tokens aligned to `mobileapp/docs/design.json` (orange `#F2572B`), not the old blue palette.

## Demo logins

| Email | Role | Password |
|-------|------|----------|
| sara@nawasul.app | super_admin | nawasul-admin |
| omar@nawasul.app | support_agent | nawasul-admin |
| layla@nawasul.app | fulfillment_staff | nawasul-admin |

## Routes delivered

- `/` → `/dashboard`
- `/login`
- `/dashboard`
- `/users`, `/users/[id]`
- `/vehicles`, `/vehicles/[id]`
- `/qr-orders` (drawer detail, bulk status, CSV)
- `/subscriptions` (drawer detail)
- `/call-logs` (flag abuse, vehicle/date filters)
- `/support`, `/support/[id]`
- `/audit-log` (read-only)
- `/settings` (Admin Team / App Config / Integrations / Legal; role-gated)

## Phase log

### Phase 0 — Plan (2026-09-04)
Approved plan: full routes, shared components, interconnected mocks, phased delivery, AGENTS.md documentation.

### Phase 1 — Theme & providers
- Added `lib/theme.ts` (MUI `createTheme` from design.json).
- Updated `styles/tokens.css` to orange/grey Nawasul tokens.
- Added `components/providers/AppProviders.tsx` + `RootProviders.tsx`.
- Installed `recharts`.
- Wired providers in `app/layout.tsx`.

### Phase 2 — Auth
- Expanded mock auth: `components/providers/AuthProvider.tsx`, `lib/auth.ts`.
- Login page with role-aware redirect.
- `AuthGuard` + `app/(dashboard)/layout.tsx` AppShell protection.

### Phase 3 — Shell & shared UI
- Layout: `Sidebar`, `Topbar`, `PageHeader`, `AppShell`; nav config in `lib/nav.ts`.
- UI: `DataTable`, `StatusChip`, `ConfirmActionDialog`, `MetricCard`, `EmptyState`.
- Charts: `SimpleLineChart`, `SimpleBarChart`, `SimpleDonutChart`.

### Phase 4 — Mock data
- `lib/mock/*` interconnected (users ↔ vehicles ↔ orders ↔ call logs ↔ subscriptions ↔ tickets ↔ audit ↔ admins).
- Typed getters mirror future `lib/api.ts` shapes.

### Phase 5 — Dashboard
- Metric cards, alerts today/week toggle, MRR + plan donut, 30-day signup/alert line chart, activity feed, quick actions.

### Phase 6 — Users & Vehicles
- List grids + detail pages with linked entities, confirm dialogs for suspend/reactivate/delete and QR deactivate/flag.

### Phase 7 — QR Orders, Subscriptions, Call Logs
- QR: status tabs, bulk update, tracking drawer, CSV export.
- Subscriptions: MRR/churn summary, filters, detail drawer with renewal history.
- Call logs: flagged tab, vehicle + date filters, flag-as-abuse action.

### Phase 8 — Support & Audit
- Support inbox + ticket detail (status/notes).
- Audit log read-only table; comment that real mutations should write audit entries.

### Phase 9 — Settings
- Tabs by role: Super Admin sees Admin Team; fulfillment sees Integrations only; support sees config/integrations/legal.

### Phase 10 — Verify (2026-09-04)
- `npm run build` passes cleanly (Next.js 16.3.3).
- Shared `DataTable` + `StatusChip` used on all list pages.
- Mock data interconnected (e.g. `usr_001` → `veh_001`/`veh_002` → orders/logs).
- Role-based sidebar: switch demo accounts to verify.

## Key directories

```
app/(dashboard)/     # protected pages + layout
app/login/
components/layout/
components/ui/
components/charts/
components/providers/
lib/mock/
lib/theme.ts
lib/nav.ts
lib/csv.ts
```
