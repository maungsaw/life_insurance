# 64 — e-App Success · corner confetti animation

**Source:** Wireframe Success screen (confetti · green check · PROPOSAL | TRACKING · Proposal→Underwrite→Payment→Policy · share)  
**Flutter today:** `ProductEappSuccessPage` — static `✦ ✦ ✦` text · check · stacked buttons · mini stepper · share  
**Related:** `59` §G · `26` tracker · `34` (no fake UW timer)  
**Date:** 2026-08-14

**Ask:** When the Success screen opens, celebration pieces should **burst in from the top-left and top-right corners** (like the PNG confetti), then settle — not a static star row. Brainstorm motion + the rest of the screen so the whole success moment feels complete.

---

## 1. What the PNG is celebrating

| Layer | Job |
|-------|-----|
| Confetti (top band) | Joy / “submitted” presence — pink · yellow · teal dots/rects |
| Green check | Primary status |
| Success + copy | Confirmation |
| PROPOSAL \| TRACKING | Two equal secondary/primary exits (PNG: both outlined side-by-side; our P0 had PROPOSAL then TRACKING full-width — align to PNG pair) |
| Stepper | Proposal ✓ → Underwrite (2) → Payment (3 dashed) → Policy (4) |
| Share | Bottom circle |

Motion ask focuses on **confetti origin = top-left + top-right corners**, spreading inward/down on entry.

---

## 2. Motion concept (P0 pick)

### Burst from corners (recommended)

```
t=0     Screen push complete
t=0–80ms  Check scales in (0.85 → 1.0) + fade
t=0–600ms Confetti from TL + TR arcs toward center-top, then fall / fade
t=600ms+  Idle — pieces stay lightly scattered OR fade out leaving a few
```

| Rule | Spec |
|------|------|
| Origins | **Top-left** cluster · **Top-right** cluster (under status bar / SafeArea top) |
| Count | ~10–16 pieces total (5–8 per side) — enough presence, not fireworks |
| Shapes | Small circles + short rounded rects (match PNG) |
| Colors | Soft pink · pale yellow · `AppColors.lightPrimary` / teal — no purple glow spam |
| Path | Ease-out from corner → inward + slight downward; optional tiny rotate |
| Duration | 500–700ms entry · optional 200ms settle |
| Reduce motion | If `MediaQuery.disableAnimations` / accessibility — show **static** PNG-like scatter, no motion |
| Replay | Once per visit (initState). Don’t loop forever |

### Options considered

| Option | Idea | Verdict |
|--------|------|---------|
| **A · Corner burst** | TL + TR emit on open | ✅ Pick — matches user ask |
| B · Fall from top edge only | Rain down full width | ❌ Weaker “from corners” |
| C · Lottie / package confetti | Rich but heavy + dependency | P2 if A isn’t enough |
| D · Only check bounce | No confetti | ❌ Misses wireframe |

**P0 = A** with `AnimationController` + `CustomPainter` / positioned `Transform` dots — no new package required.

---

## 3. Implementation sketch (Flutter)

```
Stack(
  children: [
    // 1) Confetti layer (IgnorePointer) — full width, ~180–220px tall at top
    SuccessCornerConfetti(controller: _entry),
    // 2) Content column (check, copy, buttons, stepper, share)
  ],
)
```

| Piece | Note |
|-------|------|
| `TickerProviderStateMixin` | Page becomes `StatefulWidget` |
| Seeds | Fixed random seed per open so layout is stable in demos |
| Painter | Draw N particles: `{side: L\|R, dx, dy, size, color, rot, delay}` |
| Progress | `Interval(delay, 1, curve: Curves.easeOutCubic)` per particle |
| Hit testing | `IgnorePointer` so confetti never blocks buttons |

Check animation (same controller or short sibling):

- Scale + fade 0→1 in first ~300ms  
- Optional light overshoot `Curves.elasticOut` **once** — keep subtle (field app, not game)

---

## 4. Rest of Success screen (ship with motion)

Align chrome while touching this page:

| PNG | Today | Decision |
|-----|-------|----------|
| Confetti | `✦ ✦ ✦` | Replace with corner confetti layer |
| Check green | Green circle ✓ | Keep · add entry scale |
| PROPOSAL \| TRACKING | PROPOSAL full then TRACKING+share | **Row:** both outlined or PROPOSAL secondary + TRACKING primary side-by-side (PNG both outline — use **both secondary** or TRACKING filled for hierarchy; prefer PNG: **two outlined** + share below) |
| Stepper dashed to Payment | Solid mute lines | P1: dashed segment Proposal→… optional; P0 solid OK if colors match done/current/upcoming |
| Share | Bottom with TRACKING | Keep stub share · don’t imply social API |
| Copy | Submitted | Keep · ref line stays |

**Still never:** fake 03:00 underwriting countdown (`34` `59`).

### Button actions (unchanged jobs)

| Button | Goes to |
|--------|---------|
| PROPOSAL | Pop to shell (Product tab / catalog) |
| TRACKING | Shell + `productTracker` |
| Share | Stub dialog |

---

## 5. What not to do

- Don’t loop confetti forever (battery + noise)  
- Don’t block taps with particles  
- Don’t add a heavy confetti package for P0  
- Don’t put confetti over the stepper/buttons mid-screen  
- Don’t invent Payment/Policy as live e-App steps — stepper is **status story** only  

---

## 6. Flutter map

| File | Change |
|------|--------|
| `eapp_success.dart` | Stateful · entry controller · `SuccessCornerConfetti` · check scale · button row polish |
| Optional widget | `product_widgets.dart` or `success_confetti.dart` if painter grows |

---

## 7. Acceptance

- [x] Brainstorm documented (this file)  
- [x] On open: particles emit from **top-left and top-right**  
- [x] Motion ~0.5–0.7s then idle / soft settle · no infinite loop  
- [x] `IgnorePointer` · respect reduce-motion  
- [x] Check has short entrance; confetti replaces `✦` row  
- [x] PROPOSAL / TRACKING / Share jobs unchanged  
- [x] Inventory updated  

**Shipped:** `success_confetti.dart` + stateful `eapp_success.dart` (side-by-side CTAs · dashed UW→Payment · centered share).

---

## 8. Related

Success crop · `59` §G · `ProductEappSuccessPage` · `26`  
