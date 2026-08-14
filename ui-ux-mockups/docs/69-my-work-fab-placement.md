# 69 — My work FAB placement vs pill nav

**Source:** Screenshot — My work empty Week view · cyan `+` FAB floating **high** above pill nav  
**Flutter today:** `TaskBoardPage` uses `Scaffold.floatingActionButton` + `padding.bottom: scrollClearance - 16`  
**Related:** `08` §App bar vs FAB · `44`/`57` pill nav · center shield FAB · `68` My work  
**Date:** 2026-08-14

**Ask:** Task FAB looks stranded mid-screen (large gap above bottom nav). Brainstorm how to place create so it feels intentional and doesn’t fight the shell FAB.

---

## 1. What’s wrong

| Issue | Cause |
|-------|--------|
| FAB sits too high | Extra `bottom: AppBottomNavBar.scrollClearance − 16` (~80–100px+) lifts it into empty content |
| Feels “lost” on empty Week | No agenda cards → white sea + high FAB |
| Two create affordances | Shell **center shield +** (Quick actions → New Task) **and** My work **FAB +** |
| Shape clash | Scaffold FAB = rounded square · shell FAB = shield notch |

`08` wanted a create FAB above the tab bar — intent is right; **implementation over-cleared** the nav.

---

## 2. Options (pick one)

| Option | Idea | Pros | Cons |
|--------|------|------|------|
| **A · Soft dock** | Keep Scaffold FAB · `location: endFloat` · **small** bottom inset only (`8–12` + safe area), **not** full `scrollClearance` | Matches `08` · thumb reach · list still scrolls under with list padding | Must keep list bottom padding so last row isn’t hidden |
| **B · App bar `+` only** | Remove page FAB · `+` in My work AppBar | No overlap with shell FAB · clean empty state | Create less reachable while scrolling long agenda (`08` preferred FAB) |
| **C · No page FAB** | Create only via shell Quick actions “New Task” | One create button app-wide | Extra tap · My work less self-contained |
| **D · Extended FAB / bottom bar** | `+ Create task` bar above nav | Clear label · hard to miss | Heavier chrome · competes with pill |

**P0 pick: A · Soft dock** — keep local create on My work, fix height; keep shell Quick actions as secondary path (OK for Home).

**Also:** On empty state, show a **center CTA** (“Create task”) so Week empty doesn’t rely on a floating `+` alone.

---

## 3. Soft-dock spec (A)

```
Scaffold
  floatingActionButtonLocation: FloatingActionButtonLocation.endFloat
  floatingActionButton: FAB(+) → TaskForm   // NO large bottom Padding
  body: … list …
    bottom spacer: scrollClearance + 8     // list clears pill; FAB stays default
```

| Rule | Spec |
|------|------|
| FAB bottom inset | Default Material (~16) · **do not** add `scrollClearance` to the FAB |
| List clearance | Keep `SizedBox(height: scrollClearance + 56)` (or FAB size) so last card clears pill **and** FAB |
| Empty state | Illustration/copy + **Create task** text button → same form |
| Hide on scroll | Optional P1 `extendBody` + hide FAB while scrolling — not required |
| Shape | Prefer **circle** FAB to match Material; avoid competing with shield silhouette |

---

## 4. Dual-create policy

| Entry | Job |
|-------|-----|
| My work FAB / empty CTA | Primary when already on Tasks |
| Shell Quick actions → New Task | Primary from Home / other tabs |
| Don’t add third `+` in AppBar if FAB stays | Avoid `08` “Don’t duplicate header + FAB” |

If A still feels noisy after soft-dock, fall back to **B** (AppBar only) in a follow-up.

---

## 5. Empty Week UX (related)

“No tasks for this scope” + high FAB = worst case. With soft-dock + empty CTA:

```
No tasks this week
[ Create task ]
```

Date ‹ › still works; filters stay.

---

## 6. Flutter map (when fixing)

| File | Change |
|------|--------|
| `task/.../index.dart` | Remove FAB `Padding(bottom: scrollClearance…)` · optional `endFloat` · empty-state CTA |
| Docs | This file · inventory |

---

## 7. Acceptance

- [x] Problem diagnosed (over-clearance + dual create)  
- [x] Soft-dock chosen for P0  
- [x] FAB sits just above pill (small gap)  
- [x] Empty state has Create CTA  
- [x] Inventory updated  

**Shipped:** Soft-dock FAB via **Stack + Positioned** (`overlayHeight + 8`) — not Scaffold FAB (nested under pill). AppBar `+` · empty Create CTA. Profile-side blue arc fixed.  

---

## 8. Related

Screenshot · `TaskBoardPage` · `AppBottomNavBar.scrollClearance` · `08` · `68`  
