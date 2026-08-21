# Splash / Login brand logo + AppAssets

**Surface:** Flutter `lib/` + HTML prototypes  
**Wireframe:** `LoginRegister.png` — **1st = Splash / Get Started**, **2nd = Login**  
**Related:** `brand-logo-placement-brainstorm.md`

---

## Asset inventory

| File | Role | Use |
|------|------|-----|
| `assets/splash-lockup.png` | Stacked: icon + KBZ LIFE + Insurance | Splash / Get Started · Login header |
| `assets/main-logo.png` | Horizontal wordmark | Wide / marketing · `AppBrandMarkStyle.horizontal` |
| `assets/brand-mark.png` | Geometric mark only | App bar · home header |
| `assets/images.png` | Alias of brand-mark | Legacy path |

**Class:** `lib/core/assets/app_assets.dart`

```dart
static const String mainLogo = 'assets/main-logo.png';
static const String splashLockup = 'assets/splash-lockup.png';
static const String brandMark = 'assets/brand-mark.png';
```

---

## Screen rules

| Screen | Treatment |
|--------|-----------|
| **Splash** | `AppBrandMark.splash()` → `splashLockup` ~160h · no duplicate title |
| **Login** | `AppBrandMark.login()` → `splashLockup` ~112h |
| **App bar / Home** | `AppAssets.brandMark` 36×36 · `BoxFit.contain` |

Scaffold follows theme — never hardcode black behind logo on cream.

---

## Acceptance

- [x] Assets downloaded + pubspec  
- [x] `AppAssets` paths  
- [x] Splash / Login via `AppBrandMark`  
- [x] Home header mark  
- [x] HTML prototype wired (`../assets/…`)  
