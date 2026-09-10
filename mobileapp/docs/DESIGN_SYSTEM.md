# Nawasul Design System

> **Source of truth:** [`design.json`](design.json) — all theme Dart files must stay in sync with this file.

## Brand

- **Name:** Nawasul (نواصل)
- **Tagline:** We Connect

## Core palette (approved)

| Token | Hex | Usage |
|---|---|---|
| **Dark** | `#171717` | Headings, primary text, dashboard hero card, shadow tint |
| **Accent** | `#F2572B` | Primary buttons, links, active nav, icon accents, CTAs |
| **Grey** | `#4D4D4D` | Secondary text, borders, outlines, muted labels |
| **Light** | `#DEDEDE` | Page background (scaffold canvas) |

**Surface white** (`#FFFFFF`) is used for cards and inputs so content lifts off the grey background.

## Semantic colors

Status and feedback colors are defined in `design.json` → `colors.success`, `warning`, `error` (+ containers). Use `StatusPill` variants — do not hardcode status colors in screens.

## Typography

- **Latin:** Poppins (via `google_fonts`)
- **Arabic:** Noto Kufi Arabic

Scale: `displayL`, `headingL`, `headingM`, `bodyL`, `bodyM`, `caption`, `button` — see `design.json` → `typography.scale`.

Dart mirror: `AppTypography` in `lib/core/theme/app_typography.dart`.

## Spacing & radius

- Spacing: `xs` 4 · `sm` 8 · `md` 16 · `lg` 24 · `xl` 32 · `xxl` 48
- Radius: `sm` 12 · `md` 16 · `lg` 20 · `pill` 999
- Button height: 56px

## Elevation

Shadows use `#171717` (cards, floating) and `#F2572B` (buttons). Presets live in `AppShadows` — no custom BoxShadow in screens.

## Component rules

| Component | Rule |
|---|---|
| Primary button | Orange fill, white text, `radius.md`, `AppShadows.button` |
| Secondary button | `#ECECEC` fill, orange text |
| Outline button | Transparent, 1.5px orange border |
| Card | White on `#DEDEDE` bg, `radius.lg`, `AppShadows.card` |
| Input | White fill, grey border, orange 2px border on focus |
| Dashboard hero | `#171717` card, white text, orange plan chip |

## Dart theme files

When changing the design system, update **both** `docs/design.json` and:

```
lib/core/theme/app_colors.dart
lib/core/theme/app_typography.dart
lib/core/theme/app_spacing.dart
lib/core/theme/app_radius.dart
lib/core/theme/app_shadows.dart
lib/core/theme/app_theme.dart
```

Run `flutter analyze` after any theme change.

## Material 3

- `useMaterial3: true`
- `ColorScheme.fromSeed(seedColor: #F2572B)` with role overrides from `design.json`
