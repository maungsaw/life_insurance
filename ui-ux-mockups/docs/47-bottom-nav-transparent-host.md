# 47 — Floating nav: transparent chrome, opaque pill only

**Problem:** Screenshot shows a **full-width white slab** behind Home · Customer · FAB · Product · Profile. Chart / list content is **hidden** under that slab.  
**Design intent (PNG):** Only the **pill + FAB** are solid white. Everything around them is **see-through** so Home content peeks through.  
**Flutter today:** `Scaffold(extendBody: true)` + `AppBottomNavBar` in `bottomNavigationBar` — the **slot** still paints opaque Material / full-height box.  
**Related:** `44` pill FAB · `46` Home · `LifeInsurancePage`  
**Date:** 2026-08-13

---

## 1. What should be opaque vs transparent

| Layer | Opacity | Why |
|-------|---------|-----|
| Scaffold body (scroll content) | Visible under nav gaps | Floating chrome effect |
| Area **around** the pill (left/right inset, above notch, under FAB clearance) | **Transparent** | Content must show through |
| White **pill** shape | Opaque white + shadow | Design chrome |
| Center **FAB** circle | Opaque white | Design chrome |
| System gesture / 3-button inset | Still padded | Taps stay above system UI |

**Not** “make the whole bar frosted glass.” Design stays a **floating white capsule**, not a blurred strip.

---

## 2. Root cause (why it’s blocked now)

1. `bottomNavigationBar` child is a tall `SizedBox` (`topClearance + barHeight + bottomPad`).  
2. That rectangle sits in Scaffold’s bottom slot. Theme / Material often fills the slot with **surface white**, even if our painter only draws a pill.  
3. `extendBody: true` lets body draw **under** the slot, but an opaque slot still **covers** what body drew.  
4. Result: chart bottom (and any last cards) look “cut off” by a white wall — matching the user’s screenshot.

---

## 3. Decision

**Transparent host · opaque pill.**

```
┌─────────────────────────────┐
│  page content (scrolls)     │  ← visible through gaps
│                             │
│     ╭─ FAB ─╮               │
│  ╭──┤       ├──╮            │  ← only this pill is white
│  │H │ C │+│ P │Pr│          │
│  ╰──┴───┴─┴───┴──╯          │
│  (transparent padding)      │
└─────────────────────────────┘
```

### Implementation rules

1. Wrap `AppBottomNavBar` (or the Scaffold slot) so the **host** is  
   `Material(type: MaterialType.transparency)` / `color: Colors.transparent` — **no** surface fill.  
2. Keep `extendBody: true`.  
3. Pill stays `Colors.white` via `_PillNotchPainter` only (path-clipped).  
4. Hit-testing: only pill + FAB + tab ink wells receive taps; transparent gaps pass through to body **or** absorb nothing harmful (prefer ignore on empty host).  
5. Scroll pages keep **bottom clearance** ≥ pill stack height so last content can scroll **above** the opaque pill (not trapped under it). Transparent gaps are for **parallax / peek**, not for reading text under the capsule.

---

## 4. Hit-test / UX notes

| Zone | Tap |
|------|-----|
| Tab icon / label | Switch tab |
| FAB | Quick actions sheet |
| Transparent left/right of pill | Prefer **pass-through** or no-op (don’t block scroll if finger starts there) |
| Opaque pill body | Don’t scroll content under finger on the capsule |

Optional polish: `IgnorePointer(ignoring: false)` only on pill/FAB children; host uses `IgnorePointer` on empty regions — usually automatic if host has no Material ink.

---

## 5. What not to do

- Don’t remove the white pill (design stays)  
- Don’t use a full-width frosted `BackdropFilter` as the main fix  
- Don’t drop bottom safe-area padding (Android system buttons)  
- Don’t shrink content padding to zero — text must clear the **opaque** pill when scrolled to end  
- Don’t put chart/list **behind** the capsule expecting it to stay readable  

---

## 6. Flutter follow-up (when implementing)

1. `AppBottomNavBar` root: transparent `Material` / no decoration on outer `SizedBox`.  
2. `LifeInsurancePage`: if Scaffold still paints a bar background, force  
   `bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Colors.transparent)`  
   or wrap: `Theme(data: Theme.of(context).copyWith(canvasColor: Colors.transparent), …)`.  
3. Verify Home / Customer / Product / Profile scroll under side gaps.  
4. Smoke on device with gesture nav **and** 3-button nav.  

---

## 7. Acceptance

- [x] Brainstorm documented (this file)  
- [x] No full-width white slab behind the pill  
- [x] Home content visible in gaps around pill + FAB  
- [x] Pill + FAB still solid white, same silhouette  
- [x] Last list/chart items scroll clear of the opaque pill  
- [ ] Smoke on device (gesture nav + 3-button)  

---

## 8. Related

`44` · `46` · LoginRegister floating nav PNG  
