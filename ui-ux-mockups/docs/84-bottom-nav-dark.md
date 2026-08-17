# 84 — Bottom nav · Dark contrast

**Source:** Guest/FA Home scrcpy Dark · `44` pill + FAB · `47` transparent host · `54` halo · `82` tokens  
**Flutter today:** Pill fill follows `AppColors.surface`. **Inactive tab color is still light-only** `#2D2D2D`. Home (selected) is cyan and readable; Customer / Product / Profile nearly vanish.  
**Date:** 2026-08-17

**Ask:** Dark မှာ bottom nav ကို **မြင်ရ၊ နှိပ်ရ**။ Light PNG (`44`) မပျက် — ဖြူကတ် · မည်းတဲ့ inactive · cyan active.

---

## 1. What the screenshot shows

| Piece | Light intent (`44`) | Dark today | Result |
|-------|---------------------|------------|--------|
| Selected **Home** | Cyan icon + label | Cyan | OK |
| Inactive Customer / Product / Profile | Near-black `#2D2D2D` on **white** pill | Same `#2D2D2D` on charcoal `#1E1E1E` pill | **No contrast** |
| Pill | Opaque white | `surface` `#1E1E1E` vs page `#121212` | Capsule is weak |
| FAB circle | White + cyan shield | `surface` on `surface` pill | Disc melts into the bar |
| Halo (`54`) | Black 12–20% on white | Black shadow on charcoal | Halo **disappears** |

Root (one line):

```
_NavItem: selected ? lightPrimary : const Color(0xFF2D2D2D)
```

`82` painted the pill `surface`, but left this **light-chrome inactive** token. Guest and signed-in shells share `AppBottomNavBar` — one fix covers both.

The “four dots” over Our Services is the **Product** `grid_view` icon sitting in the floating pill (content scrolls behind — `47`). Not a second FAB. Contrast fix makes that icon readable instead of a mystery blob.

---

## 2. Target tokens

Inactive must **invert with brightness**. Do not keep `#2D2D2D` in Dark.

| Role | Light | Dark |
|------|-------|------|
| Inactive icon + label | `#2D2D2D` (keep PNG) **or** `onSurfaceSecondary` | `#C8C8C8` / `onSurfaceSecondary` (`#B0B0B0`) — never `#2D2D2D` |
| Active | `lightPrimary` | `lightPrimary` |
| Pill fill | White `surface` | Lifted charcoal — `mutedFill` `#2A2A2A` **or** `surface` + **hairline** `border` on the notched path |
| FAB disc | White | Same as pill **or** one step lighter; cyan shield + white `+` stay |
| Halo | Black 0.12 / 0.20 (`54`) | Dark: **skip black smear** · use a faint **light** halo (`white` ~8%) **or** 1px `border` on the path |

P0 minimum: **inactive color from theme**. Pill lift / halo is the same pass if cheap (painter already has `color`; add optional `outline`).

Contrast check: inactive vs pill ≥ ~4.5:1 for labels (11px). `#B0B0B0` on `#2A2A2A` is in range; `#2D2D2D` on `#1E1E1E` is not.

---

## 3. UX rules (don’t restyle the chrome)

- Still **4 tabs + shield FAB**, not a Material 3 NavigationBar  
- Host stays **transparent** (`47`) — no full-width Dark slab  
- Active = cyan only; don’t fill the whole tab with a pill highlight  
- FAB still **not a fifth tab**  
- Don’t copy iOS tab-bar top hairline across the screen  

---

## 4. Flutter map

| Piece | Work |
|-------|------|
| `_NavItem` | `selected ? lightPrimary : AppColors.onSurfaceSecondary(context)` (or dedicated `navInactive`) |
| `_PillNotchPainter` | Dark: slightly lighter fill and/or `Paint()..style = stroke` border |
| `_NavCenterFab` | Disc = pill color; keep cyan shield · `onPrimary` plus |
| Shadow | Dark: reduce black `drawShadow` or add light halo |
| Tests | Dark: inactive `Text` color ≠ `#2D2D2D`; ≠ pill color |

---

## 5. Nearby (out of this pass unless it falls out)

- Our Services **labels** on Guest Home are also mid-grey — `app_service_grid`, not the nav. Separate if still dim after nav fix.  
- Partner banner / promo cards already cyan — leave.

---

## 6. What not to do

- Don’t force inactive cyan (everything looks selected)  
- Don’t paint the pill white in Dark  
- Don’t restore an opaque `bottomNavigationBar` slot  
- Don’t retune `44` Light inactive away from near-black  

---

## 7. Acceptance (brainstorm)

- [x] Screenshot = `#2D2D2D` on dark `surface`  
- [x] Inactive token follows brightness  
- [x] Pill/FAB/halo Dark affordance  
- [x] Transparent host stays  
- [x] Flutter `_NavItem` + pill Dark pass shipped  
- [x] Inventory  
