# 54 — Pill nav: keep transparent host, add a readable shadow

**Source:** Home scrcpy — pill sits on white content; users can’t tell it’s a bar  
**Keep:** Transparent host · opaque pill only (`47`)  
**Flutter today:** `_PillNotchPainter` already calls `drawShadow` (alpha 0.14, elevation 10) — **barely visible** on white Home, and likely **clipped** to the 64px paint box  
**Related:** `44` · `47`  
**Date:** 2026-08-14

**Ask:** Transparency is correct. Add a **slight** shadow so the floating pill reads as chrome, without bringing back the full-width white slab.

---

## 1. What must stay / what to add

| Layer | Keep | Change |
|-------|------|--------|
| Host around the pill | Transparent (`MaterialType.transparency`) | No |
| Pill fill | Opaque white | No |
| FAB | Opaque white + its own elevation | Optional: match pill softness |
| **Shadow** | Intent already there | **Stronger + not clipped** · still soft |

**Not** a frosted full-width bar. **Not** a 1px top border across the screen. Shadow belongs to the **capsule path** (including the FAB notch), not the whole bottom of the phone.

---

## 2. Why users don’t see it now

1. **White on white** — Home background `#F8FAFC` / white cards vs white pill. Shadow alpha **0.14** washes out.  
2. **Clip** — painter lives in `SizedBox(height: barHeight)`. `drawShadow` paints *outside* the path; the box **crops** the halo above/below. Stack `clipBehavior: Clip.none` does not expand the `CustomPaint` canvas.  
3. **`drawShadow(..., transparent: true)`** — softer, even weaker on light surfaces.

So this is not “add shadow from zero.” It’s **make the existing halo visible**.

---

## 3. Recommended look (P0)

```
     ░░ soft halo ░░
   ╭─────────╮╭─╮╭─────────╮
   │ Home …  ││+││ … Profile│
   ╰─────────╯╰─╯╰─────────╯
        ↑ only the pill casts
```

| Token | Value |
|-------|--------|
| Color | Black ~**18–22%** (`0.20`) — still grey, not a black smear |
| Blur / elevation | **12–16** logical px (up from 10) |
| Offset | Slightly **down + up** so it separates from content *above* the bar (the important edge) |
| Spread | Follow the **notched path** so the bite around FAB also has halo |

**How to unclip:** paint on a larger layer than `barHeight`:

- `CustomPaint` height = `barHeight + shadowPad` (e.g. 16px extra top/bottom), icons still laid out in the inner 64px, **or**
- wrap the painter in `OverflowBox` / extra `Padding` so the halo can draw into the existing FAB `topClearance`.

P0 = one `canvas.drawShadow` (or two: a tighter dark + a wider faint) on the **same** notched path.

---

## 4. What not to do

| Tempting | Why not |
|----------|---------|
| Opaque `bottomNavigationBar` slot again | Undoes `47` — content dies under a slab |
| `BackdropFilter` blur strip | Different product; PNG is a solid capsule |
| Heavy Material `elevation: 24` | Looks like a floating card / dialog |
| Hairline across full width | Reads as iOS tab bar, not a floating pill |
| Shadow only under FAB | Bar still invisible |

---

## 5. UX notes

- Shadow is **affordance**, not decoration: “this is tappable chrome; content scrolls behind the gaps.”  
- Home (white) is the hard case; Customer/Profile grey `#F8FAFC` already helps — tune against **Home**.  
- Don’t darken the pill fill; contrast comes from the halo.  
- Android 3-button inset: halo must not sit under the system bar; keep `bottomPad`.  
- FAB already has `elevation: 6` — keep it; don’t double a harsh ring. Pill halo should sit **behind** the FAB.

---

## 6. Flutter map

| File | Change |
|------|--------|
| `bottom_nav.dart` `_PillNotchPainter` | Stronger `shadowColor`; maybe `transparent: false` for a crisper contact shadow + second soft pass |
| Same file layout | Extra paint bounds so halo isn’t clipped |
| Host | Stay `MaterialType.transparency` |

No route / no page padding change if the halo uses existing `topClearance`.

---

## 7. Build order

1. Unclip (overflow / taller paint box).  
2. Bump alpha ~0.20 and elevation ~14.  
3. Check Home (worst) · Customer · Profile · Product.  
4. Stop if it reads as a floating capsule; don’t add blur.

---

## 8. Acceptance

- [x] Brainstorm documented (this file)  
- [x] Host around pill still transparent  
- [x] Soft shadow visible on white Home  
- [x] No full-width white slab  
- [x] FAB notch still clean  

---

## 9. Related

`44` · `47` · `bottom_nav.dart` `_PillNotchPainter`  
