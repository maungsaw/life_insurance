# 82 — Dark theme · every screen readable

**Source:** Appearance Light / Dark / System · `AppTheme` · screens hardcoding `AppColors.light*`  
**Flutter today:** `theme` + `darkTheme` + `themeMode` work. Almost every screen still paints **light** canvas, **white** cards, and **near-black** text. Dark mode looks broken.  
**Date:** 2026-08-17

**Ask:** System / Dark ပြောင်းရင် စာရော ကတ်ရော ခလုတ်ရော **ဖတ်လို့ရ၊ နာမကျန်း မဖြစ်**။ Light မပျက်။

---

## 1. Why Dark looks wrong (not the switch)

The switch is fine (`AppearanceBloc` → `MaterialApp.themeMode`). The paint is not.

| Layer | What happens in Dark |
|-------|----------------------|
| `ThemeData.darkTheme` | Exists, but **screens ignore it** |
| `AppColors.lightTextPrimary` (`#1A1A1A`) | Black text on dark canvas → unreadable |
| `Colors.white` / `#F8FAFC` scaffolds | Whole page stays a light sheet |
| White `BoxDecoration` cards | Blinding rectangles on a dark shell |
| `AppColors.darkPrimary` `#005E9A` | Navy on charcoal — CTAs vanish |
| Dark **surface darker than background** | Cards sink instead of lifting |
| Theme picker unselected color | `listTileTheme.tileColor` is null |

Lead Details also hardcodes `Colors.black87` / `Colors.white` and never touches `AppColors`.

---

## 2. Tokens (one semantic set)

| Role | Light | Dark |
|------|-------|------|
| **Background** (page) | `#FAFAFA` | `#121212` |
| **Surface** (card / app bar / field) | `#FFFFFF` | `#1E1E1E` |
| **Border** | `#EAEAEA` | `#3A3A3A` |
| **Text primary** | `#1A1A1A` | `#F5F5F5` |
| **Text secondary** | `#757575` | `#B0B0B0` |
| **Hint** | `#9E9E9E` | `#8E8E8E` |
| **Brand / primary** | `#00ADEE` | `#00ADEE` (same cyan — not navy) |
| **On primary** | White | White |

Call from widgets: `AppColors.onSurface(context)`, `.surface(context)`, `.background(context)`, `.border(context)`, `.hint(context)`.  
**Keep** `AppColors.lightPrimary` for brand tints (cyan still reads on dark).

Do **not** invent a second visual language (purple, red leftover comments). Coolors cyan stays.

---

## 3. What to paint from theme

| Widget | Use |
|--------|-----|
| Scaffold | `AppColors.background(context)` — never `#F8FAFC` |
| AppBar | surface + `onSurface` foreground |
| Cards / list tiles / sheets | `surface` + `border` |
| Body copy | `onSurface` / `onSurfaceSecondary` / `hint` |
| Primary buttons / FAB | brand cyan + **white** label |
| Bottom pill | `surface` (not `Colors.white`) |
| Dividers | `border` |
| Status pills (Active / Expired) | keep light tints — they are semantic, not canvas |

Icons on cyan (FAB glyph, primary button spinner) stay **white**.

---

## 4. What not to do

- Don’t ship Dark by swapping the Material switch only  
- Don’t leave `const TextStyle(color: AppColors.lightTextPrimary)`  
- Don’t use navy `#005E9A` as Dark primary  
- Don’t invert surface/background (cards must be **lighter** than the page in Dark)  
- Don’t restyle Light as a side effect of Dark  
- Don’t theme charts/confetti pixel-perfect in P0 — readable chrome first  
- Don’t add a fourth theme (AMOLED / high-contrast) in this pass  

---

## 5. Flutter map

| Piece | Work |
|-------|------|
| `AppColors` | Dark tokens fixed · `of` helpers from `Brightness` |
| `AppTheme.darkTheme` | ColorScheme · buttons · fields · sheets · dividers |
| Shared components | Text field · button · nav pill · dialogs · headers |
| Feature screens | Replace light canvas / black text / white cards |
| Theme page | Unselected row uses `onSurface` |
| Smoke | A Dark scaffold is not white; body text is not `#1A1A1A` |

---

## 6. Phasing

| Phase | Scope |
|-------|-------|
| **P0** | Tokens + ThemeData + every shipped screen uses semantic colors |
| **P1** | Chart series, signature pad, photo-heavy splash logo plate |
| **Out** | Per-screen one-off palettes · web portal |

---

## 7. Acceptance (brainstorm)

- [x] Root cause = hardcoded light paint, not ThemeMode  
- [x] Semantic token table  
- [x] Brand cyan stays  
- [x] Flutter Dark pass (implement)  
- [x] Inventory  
