# Splash / Login brand logo + AppAssets

**Surface:** Flutter `lib/` only (no HTML this pass)  
**Wireframe:** `LoginRegister.png` — **1st screen = Splash**, **2nd = Login**  
**Asset:** `assets/main-logo.png` (full wordmark) · also register `assets/images.png` (icon mark)  
**Related:** `35` AppBrandMark · `38` prototype  

---

## 1. Ask

1. Splash uses **`assets/main-logo.png`**.  
2. Login (wireframe 2nd) uses the same brand asset consistently.  
3. All image paths live in a **dedicated assets class** — never hardcode scattered strings.

---

## 2. Asset inventory

| File | Role | Use |
|------|------|-----|
| `assets/main-logo.png` | Full logo: mark + **KBZ LIFE** + slogan on dark plate | Splash hero · Login header |
| `assets/images.png` | Geometric mark only (blue field) | Optional compact icon / future favicon-style |

**Class:** `lib/core/assets/app_assets.dart`

```dart
abstract final class AppAssets {
  static const String mainLogo = 'assets/main-logo.png';
  static const String brandMark = 'assets/images.png';
}
```

**pubspec.yaml:** declare `assets/` (or each file).

---

## 3. Screen rules (wireframe 1st + 2nd)

| Screen | Layout | Logo treatment |
|--------|--------|----------------|
| **Splash** | Centered single composition | `mainLogo` large · **no** duplicate title · **background = theme scaffold** (follows system / light / dark — never hardcode black) |
| **Login** | Logo top · then form | `mainLogo` medium · theme scaffold · form on themed surface |

`AppBrandMark` modes:

- `wordmark` → `AppAssets.mainLogo` only (default for splash/login)  
- `markAndTitle` → `AppAssets.brandMark` + title/subtitle text (optional later)

---

## 4. DRY

- Pages call `AppBrandMark(style: wordmark)` or `Image.asset(AppAssets.mainLogo)` via BrandMark only.  
- Never `Image.asset('assets/...')` inline in features.

---

## 5. Acceptance

- [x] Brainstorm documented  
- [x] `AppAssets` class + pubspec  
- [x] Splash uses `main-logo.png`  
- [x] Login brand uses same asset via `AppBrandMark`  
- [x] No hardcoded asset paths in splash/login  

---

## 6. Related

`35` · `38` · LoginRegister.png · `assets/main-logo.png`  
