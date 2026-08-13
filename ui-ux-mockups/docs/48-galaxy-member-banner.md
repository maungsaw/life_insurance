# 48 — Galaxy Member banner on Home

**Asset (shown):** gold “Galaxy Member” strip + black membership cards (screenshot has **dark-gray studio background**)  
**Ask:** How to add it so it looks right and **does not cover** header / commission / pill nav  
**Flutter today:** Home stack = header (brand mark) → Commission → Services → Policy → Renewal → Promos (`46`)  
**Related:** `34` commission = display only · `39` AppAssets · `47` floating nav  
**Date:** 2026-08-13

---

## 1. What this piece is

A **membership status banner**, not the app logo and not the commission card.

| Is | Is not |
|----|--------|
| Agent tier / club badge (Galaxy) | `AppAssets.brandMark` (blue cube, header left) |
| Horizontal promo-like card | Wallet / Commission amount |
| Tappable “see membership” | Overlay / watermark on the whole screen |

**Do not** put this PNG in the top-left header. That slot stays `images.png` (docs/46). Putting Galaxy there would hide the greeting and look like a second logo.

---

## 2. Why “transparent” came up

The file you showed sits on a **solid dark gray rectangle**. If we `Image.asset` that as-is:

- Gray plate covers Home’s light scaffold  
- Rounded yellow card doesn’t “float”  
- Looks pasted, not part of the layout  

**Transparency here ≠ bottom-nav transparency (`47`).**  
Nav = see-through **around the pill**.  
Galaxy = **no gray studio background** around the gold card.

### Asset rule (before Flutter)

| Need | Why |
|------|-----|
| PNG with **alpha** (gray cropped out) | Only gold rounded card + cards graphic |
| Or export just the yellow rounded art | We can `ClipRRect` in Flutter |
| Register in `AppAssets` | No hardcoded `'assets/…'` in dashboard |

Until a clean export exists, Flutter can still **clip** to a rounded rect and `BoxFit.cover` so gray edges are less visible — but a real transparent PNG is the right fix.

---

## 3. Placement (pick one)

### A — In the scroll, under Commission (recommended)

```
Header (mark · welcome · bell)
Commission card
★ Galaxy Member banner     ← full width, page padding
Our Services
Policy …
```

**Why:** Status after money snapshot; doesn’t fight the header; scrolls away; pill nav never covered.

### B — Under header, above Commission

Galaxy first, then Commission. Stronger “VIP” but pushes earnings down. Use only if stakeholders want membership before money.

### C — Overlay top-left / watermark

**Reject.** Covers logo + greeting; gray bg problem; clashes with `46`.

### D — Replace a promo carousel card

Weak: Galaxy is identity, not a campaign. Keep promos as campaigns.

**Decision for prototype: A.**

---

## 4. Layout spec (when implementing)

| Token | Value |
|-------|--------|
| Width | `double.infinity` inside 20px page padding (same as Commission) |
| Height | ~88–104 (don’t eat half the screen) |
| Shape | `BorderRadius.circular(16–20)` · clip asset |
| Fit | `BoxFit.cover` or `contain` if art already includes its own gold plate |
| Tap | Stub dialog “Galaxy Member — benefits later (no API)” |
| Below | Existing 16–22 gap before Our Services |
| Nav | Same 72px scroll clearance as now — banner is **in** the list, not `Positioned` over the FAB |

Widget: `AppGalaxyMemberBanner` (DRY) · path `AppAssets.galaxyMember`.

---

## 5. Copy / product

- Banner text can stay **in the art** (“Galaxy Member”) if the PNG is the source of truth.  
- Don’t duplicate a big title above it.  
- BRD has no Galaxy API this phase → **visual + tap stub only**.  
- Don’t mix with MDRT bar (different job: production vs club).

---

## 6. What not to do

- Don’t swap header brand mark for this art  
- Don’t overlay on Commission  
- Don’t `Positioned` it over the pill nav  
- Don’t ship the screenshot **with gray background** as the production asset  
- Don’t treat it as `main-logo.png`  

---

## 7. Flutter follow-up (when implementing)

1. Export / add `assets/galaxy-member.png` (no gray) + `pubspec` + `AppAssets.galaxyMember`.  
2. `AppGalaxyMemberBanner` — clipped image, InkWell, 16–20 radius.  
3. Insert on `DashboardPage` **after** `AppCommissionCard`.  
4. Hot-restart: header still cube+bell; Galaxy sits under Commission; scroll under floating pill.

---

## 8. Acceptance

- [x] Brainstorm documented (this file)  
- [x] Placement = in-flow banner (not header overlay)  
- [x] Asset without gray plate (or clipped so gray doesn’t show)  
- [x] Header logo + Commission + nav still fully visible  

---

## 9. Related

`46` Home stack · `39` AppAssets · `47` nav host · LoginRegister home board  
