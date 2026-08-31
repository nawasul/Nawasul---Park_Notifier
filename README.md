# Nawasul

QR-based vehicle owner notification platform. Four **independent** applications — no shared packages, workspaces, or monorepo tooling.

| App | Path | Stack |
|-----|------|--------|
| Mobile | `mobileapp/` | Flutter (Android + iOS) |
| Website | `website/` | Next.js 16 (App Router), React 19, TypeScript, Tailwind, next-intl |
| Admin | `admin-dashboard/` | Next.js 16 (App Router), React 19, TypeScript, Tailwind, Material UI |
| Backend | `backend/` | FastAPI, SQLAlchemy, Alembic, Supabase |

Notes and specs live in `docs/` (`architecture.md`, `api-spec.md`, `db-schema.md`).

## Prerequisites

- **Mobile:** Flutter SDK 3.13+ (stable), Android Studio / Xcode
- **Website & Admin:** Node.js 20.9+ and npm
- **Backend:** Python 3.11+

## Run locally

### Backend (FastAPI)

```bash
cd backend
python -m venv venv

# Windows
venv\Scripts\activate
# macOS / Linux
# source venv/bin/activate

pip install -r requirements.txt
```

Copy `backend/.env.example` to `backend/.env` and fill in secrets before using integrations:

| Variable | Purpose |
|----------|---------|
| `SUPABASE_URL` / `SUPABASE_KEY` | Supabase project |
| `JWT_SECRET` | Token signing |
| `TAQNYAT_API_KEY` | SMS / voice notifications |
| `FIREBASE_CREDENTIALS_PATH` | FCM credentials file |
| `GOOGLE_PLAY_CREDENTIALS` | Play Store IAP |
| `APPLE_SHARED_SECRET` | App Store IAP |
| `DATABASE_URL` | Database connection (optional until models are wired) |

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

- Health: [http://localhost:8000/health](http://localhost:8000/health)
- OpenAPI UI: [http://localhost:8000/docs](http://localhost:8000/docs)
- API prefix: `/api/v1` (`auth`, `users`, `vehicles`, `qr`, `subscriptions`, `notifications`, `admin`)

### Website (public site + QR landing)

```bash
cd website
npm install
npm run dev
```

Open [http://localhost:3000](http://localhost:3000).

Optional: create `website/.env.local` with `NEXT_PUBLIC_API_URL` (defaults to `http://localhost:8000`).

Marketing routes: `/`, `/features`, `/pricing`, `/faq`, `/contact`, `/privacy`, `/terms`. QR landing: `/qr/[code]`.

### Admin dashboard

```bash
cd admin-dashboard
npm install
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) (use a different port if the website is already running, e.g. `npm run dev -- -p 3001`).

Optional: create `admin-dashboard/.env.local` with `NEXT_PUBLIC_API_URL` (defaults to `http://localhost:8000`).

Routes: `/login`, `/dashboard`, `/users`, `/vehicles`, `/subscriptions`, `/qr-orders`, `/call-logs`, `/settings`. `/` redirects to `/dashboard`.

### Mobile app (Flutter)

```bash
cd mobileapp
flutter pub get
flutter run
```

## Project layout

```
├── mobileapp/           # Flutter owner app
│   └── lib/
├── website/             # Public marketing site + /qr/[code]
│   ├── app/(marketing)/
│   ├── app/qr/[code]/
│   ├── components/
│   └── lib/api.ts
├── admin-dashboard/     # Internal admin panel
│   ├── app/
│   ├── components/
│   └── lib/             # api.ts, auth.ts
├── backend/             # FastAPI API
│   ├── app/api/v1/
│   ├── app/core/
│   ├── app/services/    # Taqnyat, Firebase, IAP stubs
│   ├── alembic/
│   └── .env.example
└── docs/                # Architecture, API, and DB notes
```

Each app has its own dependencies and can be deployed separately.
