# 46 — Home dashboard (LoginRegister home board)

**Source:** `Wireframe/LoginRegister.png` home boards + Policy Renewal / Active KPI cards  
**Brand mark:** `assets/images.png` → `AppAssets.brandMark` (top-left)  
**Flutter today:** `DashboardPage` + `AppHomeHeader` (avatar + greeting + period + bell)  
**Related:** `36` Home mock · `34` commission = display only · `39` AppAssets · `44` pill nav  
**Date:** 2026-08-13

**Ask:** Dashboard should read like the wireframe home. Top-left uses the geometric mark (`images.png`), not the full wordmark. Connect header → balance → services → policy → promos → alerts without breaking BRD or the new pill nav.

---

## 1. Header (locked)

Wireframe shows two variants. **Pick one composition** so the logo always has a home:

```
[ brand mark ]     Welcome Mr Chit! Good Morning     [ bell + red badge ]
```

| Slot | Spec |
|------|------|
| **Left** | `Image.asset(AppAssets.brandMark)` · height **36–40** · `BoxFit.contain` · **rounded square** (`BorderRadius ~10`) because the PNG is a **blue square** (not transparent) |
| **Center** | Greeting + name (one or two lines). Avatar optional — if shown, sit **after** the mark, not instead of it |
| **Right** | Notification bell · red unread badge · tap → stub inbox (`FR-08`) |
| **Drop from chrome** | Month period chip (`Aug 2026`) — not on this PNG. Keep as P1 inside commission “details” if needed |

**Do not** put `main-logo.png` (wordmark) in the Home header — too wide; Splash/Login already use it (`39`).

**DRY:** extend `AppHomeHeader` (or `AppBrandMark.home`) so pages never hardcode `'assets/images.png'`.

---

## 2. Screen stack (top → bottom)

```
AppHomeHeader          mark (images.png) · greeting · bell
AppCommissionCard      wireframe “My Balance” look · BRD label Commission
AppServiceGrid         4×2 Our Services
AppSection · Policy    Active · Pending · Expired (+ See all)
AppSoftBanner          Policy Renewal (bell + policy no + 1d)
AppPromoCarousel       Promotion & Campaign
[optional] Chart / MDRT  keep below fold if space; don’t steal Policy row
pill nav clearance     existing 72px
```

---

## 3. Block decisions (PNG vs BRD vs today)

| Block | Wireframe | Today | Decision |
|-------|-----------|-------|----------|
| Header left | Cube / brand mark | Initials avatar | **`AppAssets.brandMark`** top-left |
| Greeting | “Welcome Mr Chit! Good Morning!” | “Good morning / Mg Htet” | Keep mock name; copy **Welcome {name}! {greeting}** |
| Balance title | **My Balance** | **Commission** | **Commission** on card (BRD `34` — no wallet payout). Layout = PNG (wallet icon · delta · amount · eye · chevron) |
| Amount | 726,000 MMK | 726,080.00 MMK | Keep 2-decimal mock (`36`) |
| Services | 8 tiles, 4×2 | 6 tiles, 3×2 | **4 columns × 2 rows** · labels below |
| Policy KPIs | Active 20 · Pending 10 · Expired 5 + sparkline | New policies / Active / FYP + MDRT | **Policy trio** as primary KPI row. MDRT / chart → below or later |
| Renewal | Bell card · policy no · “1d” | Soft banner “3 premiums due” | Restyle `AppSoftBanner` to **Policy Renewal** card |
| Promos | Claim commission · discounts | Q3 / MDRT / product | Match PNG titles where possible; stub taps |
| Center FAB | Shield+ | Done (`44`) | Don’t rebuild here |

---

## 4. Our Services map (8 tiles)

| Tile | Opens (prototype) |
|------|-------------------|
| New Proposal | Product hub / FAB same stub |
| Product | `tabProduct` |
| Calculator | Product hub stub |
| Commission | Commission details stub (no payout) |
| Proposal Status | Info dialog (tracker later) |
| Task Management | `openTasks()` |
| CRM | `tabCustomer` (Leads via Home tile or FAB) |
| Online | Info dialog (portal / resources later) |

Tiles: white rounded square + light shadow + primary icon (not only tinted circles). 4-across so it matches PNG; labels 10–11pt, 2 lines max.

---

## 5. Policy row + renewal card

**Policy** section header + **See all >** (stub).

Three compact cards:

| Card | Number (mock) | Color |
|------|----------------|-------|
| Active | 20 | success green |
| Pending | 10 | warning orange |
| Expired | 5 | error / pink |

Optional tiny sparkline (static painter or simple `CustomPaint`) — skip live charts.

**Policy Renewal** card (from PNG set):

- Left: bell in pale-blue circle  
- Title **Policy Renewal** · trailing **1d**  
- Body: policy no **23471239074138** expiring soon…  
- Tap → stub  

This is the same job as today’s due banner — **replace**, don’t stack both.

---

## 6. Asset rules

| Asset | Where |
|-------|--------|
| `AppAssets.brandMark` (`images.png`) | Home header left only (this pass) |
| `AppAssets.mainLogo` | Splash + Login only |
| Never | hardcoded `'assets/images.png'` in dashboard |

PNG has a **solid blue plate**. Clip with `ClipRRect` so it doesn’t look like a raw square stuck on grey scaffold. Height 36–40; don’t stretch.

---

## 7. What not to do

- Don’t swap commission for a real wallet / withdraw  
- Don’t put wordmark in the header  
- Don’t hide greeting to make room for logo — logo **and** greeting  
- Don’t add a 5th bottom-nav tab  
- Don’t bind Core / commission APIs this pass  

---

## 8. Flutter follow-up (when implementing)

1. `AppHomeHeader`: leading = brand mark; trailing = bell; middle = welcome copy. Drop period chip from this bar.  
2. `DashboardPage`: 8-service list · `crossAxisCount: 4`.  
3. New compact `AppPolicyStatCard` (or extend `AppKpiTile`) for Active / Pending / Expired.  
4. Restyle due banner → Policy Renewal.  
5. Promo titles closer to PNG.  
6. Keep pill-nav bottom padding.  
7. Smoke: Login → Home · logo visible top-left · bell · services 4×2 · Policy row · scroll under FAB.

---

## 9. Acceptance

- [x] Brainstorm documented (this file)  
- [x] Top-left = `AppAssets.brandMark` (not wordmark, not initials-only)  
- [x] Greeting + unread bell  
- [x] Commission card PNG layout, BRD label  
- [x] Our Services 8 tiles, 4×2  
- [x] Policy Active / Pending / Expired  
- [x] Renewal card · promo strip · nav clearance  

---

## 10. Related

`36` · `34` §4.4 · `39` · `44` · LoginRegister home board · `assets/images.png`  
