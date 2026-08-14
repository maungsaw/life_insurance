# 58 — Home Policy KPI card (icon + count)

**Source:** Cropped Active card — green shield-in-circle · **27** · label **Active**  
**Where it lives:** Home **Policy** row (`46`), not Profile stats  
**Flutter today:** `AppPolicyStatCard` = filled accent circle + count over label (sparkline commented, P1)  
**Related:** `46` trio · `55` sparkline (optional under this layout)  
**Date:** 2026-08-14

**Ask:** The crop shows **one** KPI. On Home we still show **three** (Active · Pending · Expired). Restyle each card to this **icon-left + number-over-label** chip so it reads as a dashboard status, not a mini chart-first tile.

---

## 1. This is Dashboard Policy — not a new screen

| Crop | App |
|------|-----|
| One **Active** example | Same widget ×3 under **Policy** + See all |
| Count **27** on the PNG crop | Keep prototype **20 / 10 / 5** (`HomeMockData`) unless product supplies 27 |
| Green shield / check | Active only. Pending / Expired get their own icon + color |

Do **not** add a fourth “Policies sold” / “Customers” row here (`MetricsView` old bento stays unused). FR-02 Home = Policy **status** counts.

---

## 2. Card anatomy (match crop)

```
┌─────────────────┐
│ (● shield)  27  │
│             Active │
└─────────────────┘
```

| Slot | Spec |
|------|------|
| Container | White · radius ~14 · light shadow (already) |
| **Left** | Circle ~36–40px, **tint of accent** (not a tiny 16px icon) · white glyph |
| **Right** | Big count (accent, ~22–24, w800) · label grey 12px under it |
| Axis | `Row`: circle + `SizedBox(8)` + `Column` (value, label) |

PNG crop: circle is **filled green** with white shield+check. Use filled circle + white icon (stronger than outline-only).

---

## 3. Trio (one crop → three cards)

| Card | Accent | Circle icon |
|------|--------|-------------|
| **Active** | Success green | `Icons.verified_rounded` / shield+check |
| **Pending** | Amber `#F59E0B` | `Icons.schedule_rounded` |
| **Expired** | Rose `#E11D48` | `Icons.cancel_rounded` or `event_busy` |

Same `Row` + `Expanded` + 8px gaps as now. Narrow phones: keep one line of three; shrink circle to 32 if needed, **don’t** wrap to two rows.

---

## 4. Sparkline (`55`) vs this crop

Two Home wireframe langs exist: **area sparkline** vs **icon chip**.

**P0 = this crop** (icon + 27 + Active). It’s clearer at a glance on a phone.  
**Sparkline** = P1 under the label *or* drop so the card stays short above the pill.

Don’t stack both on P0 — three fat chart cards crowd Our Services → Renewal.

---

## 5. Interaction

| Gesture | P0 | P1 |
|---------|----|----|
| Card tap | None (display) | Stub “Active policies” (FR-06) |
| See all > | Existing stub | Policy list |

Headcount only — no commission (`34`).

---

## 6. Flutter map

| File | Change |
|------|--------|
| `app_kpi_tile.dart` `AppPolicyStatCard` | Rebuild to circle + value/label `Row`; optional `IconData` |
| Dashboard Policy `Row` | Pass icons per status |
| `_SparklinePainter` | Keep commented or P1 |

---

## 7. What not to do

- Don’t show only Active and hide Pending/Expired  
- Don’t use the crop’s **27** unless mock data changes  
- Don’t resurrect `MetricsView` as the Policy row  
- Don’t put this chip on Profile (Profile has Total Premium / Commission)  

---

## 8. Acceptance

- [x] Brainstorm documented (this file)  
- [x] Home Policy = three icon-count cards  
- [x] Active looks like the crop (green circle + number + label)  
- [x] Sparkline not required on P0  
- [x] See all unchanged  

---

## 9. Related

`46` · `55` · `AppPolicyStatCard` · LoginRegister Home Policy  
