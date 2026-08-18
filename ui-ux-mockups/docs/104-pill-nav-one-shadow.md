# 104 — Pill nav: one shadow, not stacked bands

**Surface:** `AppBottomNavBar` · `_PillNotchPainter` (all tabs, Dark especially)  
**Reference:** Pill + FAB (`44`) · transparent host (`47`) · halo (`54`) · Dark contrast (`84`)  
**Today:** Under the floating pill, Dark shows **1–2–3 light bands** before the system home indicator. Looks like stacked slabs, not one chrome.  
**Date:** 2026-08-18

**Ask:** Bottom nav အောက်က shadow အလွှာတွေကို **တစ်ထပ်** · သန့်သန့်။

---

## 0. What is stacking

Painter (`bottom_nav.dart`):

| Pass | Dark | Light |
|------|------|--------|
| Halo | **White** `drawShadow` α 0.10 · elevation **14** (`84` “light halo”) | **Two** black `drawShadow` (α 0.12 / 16 **and** α 0.20 / 8) (`54`) |
| Fill | `navPill` | white |
| Edge | 1px `border` stroke | none |
| FAB | `Material` elevation **6** | same |

`drawShadow` bleeds **every direction**. Extra paint sits **under** the rounded pill, into `bottomPad` / the Android home indicator. White glow on charcoal reads as **rings**. Two light shadows = two more rings.

Not a second nav bar. Not the list. The pill’s own halo + stroke + FAB disc shadow.

---

## 1. Pick

**One contact. No rings.**

| Mode | Halo | Edge |
|------|------|------|
| **Dark** | **No** white `drawShadow`. Optional **one** black shadow elevation **6**, α ~0.35 | Keep **1px border** (that *is* the lift) |
| **Light** | **One** black `drawShadow` elevation **10**, α ~0.16 (drop the second pass) | none |

Do **not** paint a light halo under the pill. If Dark still needs separation from the page, the hairline is enough (`84` already allowed “border **or** faint light halo” — pick **border only**).

FAB: keep elevation 6 (it’s on the disc, not a third bar). Don’t add a second FAB shadow in the painter.

Clip: keep `clipBehavior: Clip.none` so the notch halo above the bar still exists on Light. Dark just stops drawing a glow.

---

## 2. What not to do

- Don’t bring back a full-width Dark slab (`47`)  
- Don’t stack two `drawShadow` calls  
- Don’t use white shadow on Dark (that *is* the bands)  
- Don’t hide the system home indicator  

---

## 3. Test (when shipping)

- Dark Customer tab: painter uses at most **one** `drawShadow`  
- Light still has a visible halo on white Home (`54`)
