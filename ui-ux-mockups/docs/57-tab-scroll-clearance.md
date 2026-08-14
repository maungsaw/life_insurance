# 57 — Tab pages: scroll past the floating pill (Logout visible)

**Source:** Profile scrcpy — scrolled to end; light-blue **Logout** sits on top of the pill nav  
**Flutter today:** Profile `ListView` ends with `SizedBox(height: 100)`. Nav overlay is **taller** than 100 on this Samsung (FAB clearance + 64px bar + system inset).  
**Related:** `44` · `47` · `50` Profile hub · `54` shadow  
**Date:** 2026-08-14

**Ask:** When the user pulls to the bottom of Profile (and other tabs), **Logout** (and last rows) must sit **above** the floating pill, not tucked under it.

---

## 1. What’s happening

Host is `extendBody` + overlay `AppBottomNavBar`. Content **does** scroll under the pill (correct). Last widgets need extra **bottom padding** equal to the overlay height, not a guessed `72` / `100`.

```
AppBottomNavBar height
  = (fabSize − fabOverlap)     // 56 − 22 = 34  top clearance
  + barHeight                  // 64
  + max(systemBottom, 12)      // 3-button nav often ~48
  ≈ 146px on this device
```

Profile spacer **100 < 146** → Logout (50px stadium) lands in the pill/FAB zone. Screenshot: wide light-blue bar fused with the nav.

Same class of bug: Home `72`, Customer list `100`. Product uses `120` (safer, still not measured).

---

## 2. Decision

**One measured clearance**, used by every tab that lives under the overlay.

```dart
AppBottomNavBar.scrollClearance(context)
  = overlayHeight + 16   // 16px air above the pill
```

| Page | Apply to |
|------|----------|
| **Profile** | Last `SizedBox` after Logout (this screenshot) |
| Home | End of `CustomScrollView` |
| Customer list | `ListView` padding bottom |
| Product hub | Existing bottom padding |
| Leads / Tasks | If shown in the same shell |

Pushed routes (Customer Details, FAQ, …) have **no pill** — don’t add this spacer there.

---

## 3. UX

- User must be able to rest Logout fully **above** the white capsule, then still overscroll a little.  
- Do **not** hide Logout or pin it into the nav. PNG: Logout in the scroll, then nav.  
- Do **not** shrink the pill.  
- Do **not** turn off `extendBody` (that brings back the white slab, `47`).

Optional P1: slightly more gap after Report before Logout (16–20) so Setting list doesn’t kiss the button — secondary to clearance.

---

## 4. Flutter map

| File | Change |
|------|--------|
| `bottom_nav.dart` | `static double scrollClearance(BuildContext context)` from the same math as `build` |
| `profile/.../index.dart` | Replace `100` with `scrollClearance` |
| Dashboard · Customers · Product | Same |

---

## 5. What not to do

- Don’t hardcode `200` and hope  
- Don’t `SafeArea` the whole Profile body (double-counts status bar, still misses overlay)  
- Don’t put Logout in `bottomNavigationBar`

---

## 6. Acceptance

- [x] Brainstorm documented (this file)  
- [x] Profile scroll-end shows full Logout above the pill  
- [x] Clearance uses nav height + system inset, not a magic 100  
- [x] Other overlay tabs use the same helper  
- [x] Host stays transparent  

---

## 7. Related

`50` Profile · `44` / `47` overlay · `AppBottomNavBar`  
