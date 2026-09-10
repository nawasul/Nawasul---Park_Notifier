# Nawasul Admin Dashboard — Master Build Plan

## Context: What this dashboard is for

This is the internal, staff-only operations dashboard for running the Nawasul business day-to-day: managing users, fulfilling physical QR sticker orders, monitoring subscriptions/revenue, and — critically — auditing the notification system for abuse (since anyone can trigger a call to a vehicle owner via a QR scan, this dashboard is how the team investigates misuse). This is NOT public-facing and is never linked from the website or mobile app's public flows.

## Tech stack (already scaffolded — confirm, don't recreate)

- Next.js 16, App Router, React 19, TypeScript
- Material UI (MUI) + MUI X Data Grid
- Folder already exists: `admin-dashboard/` with routes for `login`, `dashboard`, `users`, `vehicles`, `qr-orders`, `subscriptions`, `call-logs`, `settings`, plus `lib/api.ts`, `lib/auth.ts`

## PHASE 0 — Plan before building (do this first, show me the plan before writing code)

Before writing any code, respond with:
1. A proposed full route list (including new routes beyond the original 8, per the additions below)
2. A proposed component inventory (what's reusable across pages — tables, filters, status chips, modals)
3. Confirmation of the mock data structure you'll use (since backend isn't live yet)
4. Any clarifying assumptions you're making

Wait for my go-ahead on the plan before starting implementation, unless it's straightforward — if so, proceed but clearly state assumptions made.

## Design system — use the existing design tokens, do not invent new colors

Reference `@docs/design.json` if present in this project (check first) — this must be visually consistent with the mobile app's current theme: bold orange primary (`#F2572B`), near-black (`#171717`) for dark surfaces/text, neutral greys for backgrounds (`#DEDEDE` background, `#ECECEC`/`#D4D4D4` surface containers), white cards. Do NOT use the old blue palette.

Since this app uses MUI, build a proper MUI theme (`lib/theme.ts` or `theme/index.ts`) using `createTheme()`, mapping the palette to these exact values (`palette.primary.main = '#F2572B'`, etc.), and wrap the app in `ThemeProvider`. Every component must use theme values (`theme.palette.primary.main`, `theme.spacing()`, etc.) — never hardcoded hex colors or raw pixel values inline.

Typography: Poppins (Latin) — load via `next/font/google` and wire into the MUI theme's typography config.

Since this is an internal tool (not a public marketing site), prioritize DATA DENSITY and CLARITY over decorative polish — this should feel like a clean, efficient operations tool (think Stripe Dashboard, Linear, or Retool), not a marketing site. Tables, filters, and status indicators matter more than hero sections or illustrations here.

## Full route list

### Auth
1. **Login (`/login`)** — email + password, "Forgot password" link, role-aware redirect after login

### Overview
2. **Dashboard (`/dashboard`)** — see detailed spec below

### Core operational sections
3. **Users (`/users`)** — list + detail view
4. **Vehicles (`/vehicles`)** — list + detail view
5. **QR Orders (`/qr-orders`)** — fulfillment pipeline
6. **Subscriptions (`/subscriptions`)** — billing/plan management
7. **Call Logs (`/call-logs`)** — notification audit trail

### New sections to add (beyond original spec — see reasoning notes)
8. **Support Tickets (`/support`)** — inbox for Contact Support submissions from mobile app + website
9. **Audit Log (`/audit-log`)** — record of admin actions (who did what, when) — accountability once more than one admin exists
10. **Settings (`/settings`)** — admin team management, app config, integration health, legal content

`/` redirects to `/dashboard` (already established pattern).

## Detailed page specs

### Dashboard (`/dashboard`)
- Metric cards (use MUI Card + Grid): Total Users, Active Subscriptions, Vehicles Registered, Pending QR Orders, Alerts Triggered (today/this week toggle)
- Revenue snapshot card: MRR estimate, plan distribution (Free/Pro/Premium breakdown — simple bar or donut chart using a lightweight charting lib like `recharts`, already available per our tooling)
- Recent activity feed: latest signups, latest QR orders, latest alerts — a simple timeline list
- Quick-action buttons: "View Pending QR Orders," "View Flagged Alerts," "View Support Tickets" (link to filtered views of the relevant section)
- Simple line/bar chart: signups over time, alert volume over time (mock 30 days of data) — useful for spotting abuse spikes, note this in a code comment

### Users (`/users`)
- MUI X Data Grid: columns for Name, Phone, City, Signup Date, Subscription Status, Account Status (Active/Suspended/Deleted), with search and column filtering
- Row click → User Detail view (`/users/[id]`):
  - Profile info card
  - Linked vehicles list (mini table)
  - Subscription history
  - Alert/call history for this user (as scanner or as owner)
  - Account status control: Suspend / Reactivate / Trigger Deletion buttons (each with a confirmation dialog — build a reusable `ConfirmActionDialog` component)
  - Internal notes field (free text, for support agents to leave context for each other)

### Vehicles (`/vehicles`)
- Data Grid: Make, Model, Plate Number, Owner (linked to user), QR Status, columns filterable/searchable
- Row click → Vehicle Detail view (`/vehicles/[id]`):
  - Vehicle info, owner link, QR code status
  - Sticker order history for this vehicle
  - Alert history for this vehicle
  - "Deactivate QR Code" action (with confirmation dialog) — for sold vehicles, fraud, or user request
  - "Flag for Review" action if abuse is suspected on this vehicle's QR

### QR Orders (`/qr-orders`)
- Data Grid with status pipeline column: Ordered → Printed → Shipped → Delivered (render as a colored status chip, not plain text)
- Filter by status (tabs or dropdown: All / Ordered / Printed / Shipped / Delivered)
- Bulk selection + bulk status update action (select multiple rows, "Mark as Printed" etc.)
- Row detail (modal or side panel, not full page nav — keeps workflow fast): shipping address, quantity, order date, and an editable Tracking Number field
- "Export to CSV" button (for handing the order batch to a printing/shipping vendor) — implement as a real client-side CSV export from the mock data

### Subscriptions (`/subscriptions`)
- Data Grid: User, Plan (Free/Pro/Premium), Billing Cycle, Platform (iOS/Android icon), Status (Active/Cancelled/Expired), Next Renewal Date
- Filter by plan and status
- Row click → shows subscription detail (payment platform reference ID, renewal history) — this is where support agents reconcile "I paid but app shows Free" disputes
- Top-of-page summary stats: MRR, churn rate (mock calculated values), plan distribution

### Call Logs (`/call-logs`)
- Data Grid: Vehicle (plate), Timestamp, Reason Selected, Delivery Method (Call/Push/SMS icon), Delivery Status (Success/Failed), with date range filter
- Row click → full detail (any additional metadata)
- "Flag as Abusive/Spam" action on each row (with confirmation) — flagged entries should be visually distinct (colored chip) and filterable via a dedicated "Flagged" tab/filter
- This page's filtering must support investigating a pattern (e.g. "show me all alerts on Vehicle X in the last 7 days") — make vehicle and date-range filtering prominent, not buried

### Support Tickets (`/support`) — NEW
- Inbox-style list: Subject, Submitter (name/email/phone), Date, Status (Open/In Progress/Resolved)
- Ticket detail view: full message, submitter info, an internal reply/notes field, status change dropdown
- Source indicator (submitted via Mobile App or Website) — data-driven, tag each mock ticket with a source field

### Audit Log (`/audit-log`) — NEW
- Simple chronological table: Admin User, Action Taken, Target (e.g. "Suspended User #1234"), Timestamp
- Read-only page, no actions — this is purely a trust/accountability record
- Every action performed elsewhere in this dashboard (suspend user, update QR order status, flag a call log, etc.) should — in the real implementation — write an entry here. For this mock-data phase, just build the display and seed it with realistic mock entries; note in a code comment that real actions should call an audit-log-writing function once the backend exists

### Settings (`/settings`)
- Tabbed or sectioned layout:
  - **Admin Team**: list of admin users, roles (Super Admin / Support Agent / Fulfillment Staff), invite new admin (mock form)
  - **App Configuration**: rate-limit threshold input (max notifications per QR code per hour — this directly supports abuse prevention), editable subscription plan pricing fields
  - **Integration Health**: simple status panel showing mock connection status (green/red indicator) for Taqnyat SMS, Taqnyat Voice, Firebase, Supabase — so the team can see at a glance if something's down, without digging through logs
  - **Legal Content**: simple rich-text or markdown editor stub for Privacy Policy / Terms content (mock save action for now — actual publishing to mobile app/website is a future backend integration)

## Component inventory to build

- `components/layout/` — Sidebar (nav with all routes + role-based visibility awareness), Topbar (admin user menu, notifications bell), PageHeader (title + breadcrumb + primary action slot)
- `components/ui/` — StatusChip (configurable color/label — reuse pattern across QR order status, subscription status, call log status, ticket status), ConfirmActionDialog, DataTable wrapper (a consistent wrapper around MUI X Data Grid with our styling defaults so every list page looks consistent), MetricCard (for dashboard stats), EmptyState
- `components/charts/` — SimpleLineChart, SimpleBarChart/DonutChart (thin wrappers around recharts, styled to match our theme)

Every list/table page (Users, Vehicles, QR Orders, Subscriptions, Call Logs, Support Tickets, Audit Log) MUST use the shared DataTable wrapper and StatusChip components — do not build one-off tables per page.

## Auth & role awareness

- Build `lib/auth.ts` with a mock auth context: a logged-in mock admin user object with a `role` field (`super_admin` | `support_agent` | `fulfillment_staff`)
- Sidebar navigation and page-level actions should respect role for now in a LIGHT way (e.g. hide "Admin Team" settings from non-super-admins) — this doesn't need to be airtight security yet since there's no real backend, just establish the pattern so it's easy to wire up real permission checks later
- Protect all routes except `/login` behind the mock auth check (redirect to login if "logged out")

## Mock data

Create `lib/mock/` with realistic, interconnected mock data (a user should link to real mock vehicles, which link to real mock QR orders and call logs — not disconnected random data):
- `mock-users.ts`
- `mock-vehicles.ts`
- `mock-qr-orders.ts`
- `mock-subscriptions.ts`
- `mock-call-logs.ts`
- `mock-support-tickets.ts`
- `mock-audit-log.ts`
- `mock-admins.ts`

Structure these so swapping in real API calls later (via `lib/api.ts`) is straightforward — export typed functions like `getUsers()`, `getUserById(id)` that currently return mock data but mirror what a real API call would return.

## What NOT to do

- Do not implement real authentication — mock auth context only, as described above
- Do not wire up real payment/subscription verification — this dashboard only DISPLAYS subscription data, it doesn't process payments
- Do not build real CSV export libraries if unnecessary — a simple client-side CSV string generation + download blob is sufficient for the QR Orders export
- Do not skip the Audit Log or Support Tickets sections — these were missing from the original spec but are operationally necessary once real users exist

## Execution order

1. Phase 0 planning — show me first
2. MUI theme setup matching design tokens
3. Auth mock + protected route wrapper + Login page
4. Shared layout (Sidebar, Topbar) + shared components (DataTable, StatusChip, ConfirmActionDialog, MetricCard)
5. Mock data files (interconnected, as described)
6. Dashboard overview page
7. Users, Vehicles (list + detail views)
8. QR Orders, Subscriptions, Call Logs
9. Support Tickets, Audit Log (new sections)
10. Settings (all sub-sections)
11. Run `npm run build` to confirm no errors, `npm run dev` for me to review locally

## Deliverable at the end

1. Full list of routes/pages created, including the 3 new ones (Support Tickets, Audit Log, expanded Settings)
2. Confirm mock data is interconnected (e.g. clicking a user shows their real linked vehicles, not random unrelated ones)
3. Confirm shared components (DataTable, StatusChip) are actually reused across all list pages, not duplicated
4. Confirm role-based sidebar visibility works with the mock admin roles
5. Confirm `npm run build` passes cleanly
6. Flag any assumption made that I should review