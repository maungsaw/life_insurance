# 55 — Home Policy KPI mini-charts (wireframe sparkline)

**Source:** Home Policy row — Active / Pending / Expired cards with area sparkline  
**Flutter today:** `AppPolicyStatCard` — icon + number on top, label, then an 18px **stroke-only** bezier. Looks like a doodle, not the PNG chart.  
**Related:** `46` Home · `34` display-only · `fl_chart` already in pubspec  
**Date:** 2026-08-14

**Ask:** Policy counts should sit on a **small chart** like the wireframe (colored number + filled wave + dashed midline), without turning Home into an analytics dashboard.

---

## 1. Gap vs PNG

| PNG | App now |
|-----|---------|
| Label **Active** (grey, top) | Icon left · number right · label under |
| Big count in status color | Same colors (green / amber / rose) — keep |
| Chart ~⅓ of the card: **line + gradient fill** | 18px stroke, no fill |
| Horizontal **dashed** guide through the wave | Missing |
| Three equal white cards | OK |

---

## 2. What these charts are (and are not)

| They are | They are not |
|----------|----------------|
| Decorative **sparklines** — trend *feel* | Interactive `fl_chart` dashboards |
| Mock series (prototype) | Live Core time-series (later API) |
| Color = status (Active green, Pending amber, Expired rose) | Extra legends / axes / tooltips |

Tap on a card **P1:** stub “Active policies” list (same as See all + filter). **P0:** no new screen — visual only.

**See all >** stays the FR-06 stub (`46`). Do not deep-link Customer Policies until that list exists.

---

## 3. Card layout (match PNG)

```
Active                 ← 12px grey
20                     ← 22–24px accent, bold
[~ dashed ~ wave ~]    ← ~36–44px sparkline
```

Drop the **verified icon** on P0 (not on PNG). Number goes **under** the label, full width, not a top-right pair.

Three cards stay in one `Row` + `Expanded`. Chart height must stay modest so Home still fits above the pill.

---

## 4. Sparkline drawing (P0)

Prefer **`CustomPaint`** inside `AppPolicyStatCard` — three tiny charts, no `fl_chart` overhead, already started.

| Layer | Spec |
|-------|------|
| **Fill** | Closed path to baseline · `LinearGradient` accent → transparent downward |
| **Line** | Same path, stroke 1.8–2.2, round caps |
| **Guide** | Horizontal dashed line at ~45–55% height, accent at ~35% opacity, dash `[4, 3]` |
| **Series** | 6–8 mock points per card (slightly different shapes so the three don’t look identical) |

`HomeMockData` can hold `List<double>` per status (0–1). Prototype only — not real history.

**Do not** use `fl_chart` here unless CustomPaint can’t do dashes cleanly (it can). Keep `fl_chart` for Profile **Commission Report** (`50`).

---

## 5. Colors (reuse)

| Card | Accent |
|------|--------|
| Active | `AppColors.successGreen` |
| Pending | `#F59E0B` |
| Expired | `#E11D48` |

Fill alpha ~0.25 at the line, 0 at the bottom.

---

## 6. Flutter map

| File | Change |
|------|--------|
| `app_kpi_tile.dart` `AppPolicyStatCard` | Restack label → value → taller sparkline; painter = fill + dash + stroke |
| `home_mock_data.dart` | Optional sparkline samples |
| Dashboard `Row` | Same three cards; pass series if extracted |

---

## 7. What not to do

- Don’t add Y-axis / month labels on Home KPIs  
- Don’t animate on every rebuild  
- Don’t replace the three counts with one big bar chart (that’s Profile Report)  
- Don’t imply commission / payout in this row — **policy headcount only** (`34`)

---

## 8. Build order

1. Restack card (label, value, chart height ~40).  
2. Painter: dashed guide → fill → stroke.  
3. Distinct mock paths per status.  
4. Glance on device: three cards still equal width, text not clipped.

---

## 9. Acceptance

- [ ] Brainstorm documented (this file)  
- [ ] Cards read like PNG (label · count · area sparkline)  
- [ ] Dashed midline + gradient fill  
- [ ] Still three compact KPIs, not a dashboard  
- [ ] See all / tap = stub unless already wired  

---

## 10. Related

`46` · `AppPolicyStatCard` · LoginRegister / Home Policy board  
