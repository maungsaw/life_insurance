# Brand Logo Placement — Brainstorm

**Canvas:** `brand-logo-placement-brainstorm.canvas.tsx`

**Goal:** Use official KBZ LIFE logos correctly on Get Started, Login, and App bar (HTML prototype + Flutter `AppAssets`).

---

## Three assets → three jobs

| Asset | File | Role |
|---|---|---|
| **Stacked lockup** | `assets/splash-lockup.png` | Get Started / Splash · Login (above form) · `AppAssets.splashLockup` |
| **Horizontal main** | `assets/main-logo.png` | Alt / wide · `AppAssets.mainLogo` |
| **Mark only** | `assets/brand-mark.png` (+ `images.png` alias) | App bar left · Home header · `AppAssets.brandMark` |

---

## Placement rules

### 1) Get Started (Splash)
- Centered stacked lockup · cream · Get Started CTA
- No duplicate “KBZ LIFE” text under logo

### 2) Login (above fields)
- Same stacked lockup ~160×120 max · then “Login Account”

### 3) App bar (left)
- Mark only 32–36px · Guest / FA / Products headers

---

## Implementation status

- [x] Download 3 files into `assets/`
- [x] `AppAssets` + pubspec
- [x] HTML: `login.html` splash + login
- [x] HTML: before-login / after-login / products app-bar mark
- [x] Flutter: `AppBrandMark` uses `splashLockup`; `AppHomeHeader` uses `brandMark`

See also: `docs/39-splash-login-brand-assets.md`
