# 113 — Flutter-first mockups (PNG wireframe pack)

**Date:** 2026-08-19  
**Why this replaces HTML:** Stakeholders review **images** (same format as `KBZ_UI&UX/Wireframe1/` · `Wireframe2/`). HTML/CSS mockups do not match that review habit, and they are not the real app.  
**Approach:** Build P0 screens as **Flutter widgets** (same stack as `main`), then capture **PNG mockups** from those widgets so the pictures are close to production reality.

---

## 1. What stakeholders asked for

| They gave us | They want from us |
|--------------|-------------------|
| PNG wireframe sheets | PNG mockup sheets |
| One folder per direction | `Branch1_Atelier` · `Branch2_Signal` · `Branch3_Grove` |
| Visual, not Figma | Flutter-rendered screens, not HTML |

`main` stays the current Coolors / Wireframe1/2 Flutter app. New looks live on **design branches** only.

---

## 2. Why Flutter → PNG (not HTML)

1. **Same components** — Material, icons, type, spacing as the shipping app  
2. **Review format** — drop PNGs into a slide / email like Wireframe1/2  
3. **No extra language** — no CSS that will never ship  
4. **Goldens** — `flutter test --update-goldens` regenerates images after a design tweak  

HTML files under `ui-ux-mockups/branch-*` are **not** the review source. Use the PNG packs.

---

## 3. P0 screens (same jobs as `main`)

1. Guest Home  
2. Login  
3. OTP  
4. Home (FA)  
5. Customer list  
6. Customer detail  
7. Task Management  

Same BRD flows. Different **nav, color, hierarchy**.

---

## 4. Image pack layout (mirrors Wireframe1/2)

```
KBZ_UI&UX/
  Wireframe1/          ← stakeholder original (do not restyle)
  Wireframe2/
  Branch1_Atelier/     ← Flutter-rendered PNGs
    Guest Home.png
    Login.png
    OTP.png
    Home.png
    Customer.png
    Customer Detail.png
    Task Management.png
    Overview sheet.png
  Branch2_Signal/
  Branch3_Grove/
```

---

## 5. How images are produced

| Step | Tool |
|------|------|
| Draw screens | `lib/design_mockups/` Flutter widgets |
| Capture | `test/design_mockups/design_mockup_goldens_test.dart` |
| Publish | copy goldens → `KBZ_UI&UX/BranchN_*/` |

```bash
flutter test test/design_mockups/design_mockup_goldens_test.dart --update-goldens
```

Phone canvas: **390 × 844** (iPhone 14 logical). Sheets: phones in a row on a board, like Wireframe1.

---

## 6. Three directions (unchanged)

| Pack | Nav | Home | Palette |
|------|-----|------|---------|
| **Atelier** | Top chips, no FAB | Today timeline | Stone · forest · terracotta |
| **Signal** | Left icon rail | Bento KPIs | Dark · cyan · amber |
| **Grove** | 3 bottom tabs | Next-best-step | Lilac · plum · gold |

---

## 7. Git (main untouched)

| Branch | Role |
|--------|------|
| `main` | Current Flutter app (wireframe-aligned) |
| `design/baseline-wireframe-aligned` | Mockup widgets + PNG packs + docs |
| `design/branch-1-atelier` | Same commit until a direction is picked, then full app restyle |
| `design/branch-2-signal` | ″ |
| `design/branch-3-grove` | ″ |

After stakeholders pick a pack, that branch gets the **real** `AppColors` / nav / P0 page restyle (not a second HTML prototype).

---

## 8. Meeting use

1. Open `KBZ_UI&UX/Branch1_Atelier/Overview sheet.png` (and 2, 3) on a projector  
2. Compare next to `Wireframe1/` · `Wireframe2/`  
3. Drill into per-screen PNGs if needed  
4. Record choice in `docs/112` section 9  
