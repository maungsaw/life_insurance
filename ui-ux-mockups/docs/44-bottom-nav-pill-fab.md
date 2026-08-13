# 44 — Bottom nav chrome (pill + center FAB)

**Source:** Stakeholder bottom-nav PNG (Home · Customer · shield+ · Product · Profile)  
**Also:** `Wireframe/LoginRegister.png` home board · `34` §4.2 · `36` shell  
**Flutter today:** `AppBottomNavBar` = flat 5-tab `BottomNavigationBar`  
`Home · Leads · Customers · Tasks · More`  
**Date:** 2026-08-13

**Ask:** Bottom bar should look like the pill + notched center FAB. Brainstorm what else must change so IA, Home tiles, and prototype still connect.

---

## 1. What the PNG is (chrome only)

| Piece | Spec |
|-------|------|
| Bar | White **pill** · large radius · soft shadow · inset from screen edges |
| Notch | Semi-circle cut under center FAB |
| Slots | **4** labeled tabs + **1** center action (not a tab) |
| Labels | Home · Customer · Product · Profile |
| Active | Primary blue `#00adee` icon + label |
| Inactive | Near-black / dark gray |
| FAB | White circle · blue **shield + plus** · sits in notch (docked) |

This is **shell chrome**, not a new feature set.

---

## 2. Conflict with today’s app

| Today (`LifeInsurancePage`) | PNG |
|-----------------------------|-----|
| 5 equal tabs | 4 tabs + FAB |
| Leads · Tasks · More as tabs | No Leads / Tasks / More labels |
| Flat Material bar | Floating pill + notch |
| No center action | Shield+ FAB |

`34` already said: keep Concept A modules; **center FAB optional** for New quote / New lead; hamburger → More.

So: **match PNG look**, **map destinations** so BRD modules are not lost.

---

## 3. Decision — chrome + IA map

### Chrome (locked for Flutter)

Rebuild `AppBottomNavBar` as custom docked bar (not stock `BottomNavigationBar`):

- `Scaffold(extendBody: true)` already on Home shell — keep  
- `floatingActionButton` + `FloatingActionButtonLocation.centerDocked` **or** custom `Stack` in `bottomNavigationBar`  
- Prefer **custom painted / `ClipPath` pill + notch** so radius matches PNG (stock `CircularNotchedRectangle` is square bar)  
- Safe-area padding + horizontal margin (~12–16) so pill floats  

### Destinations (prototype map)

| Slot | Label | Opens | Notes |
|------|-------|-------|-------|
| 0 | **Home** | `DashboardPage` | Unchanged |
| 1 | **Customer** | `CustomersPage` | Primary CRM list. **Leads** via Home “CRM / Leads” tile → `MainTabScope` *or* later Customer top tabs (Leads \| Clients) |
| — | **FAB** | Action sheet (not a tab) | See §4 — does **not** change `selectedIndex` |
| 2 | **Product** | Product hub stub | Prototype: placeholder page **or** first “Our Services → Product” destination. Not Tasks. |
| 3 | **Profile** | `ProfilePage` | Absorbs **More**: profile · notifs entry · logout. Tasks stay reachable from Home services / FAB. |

### Where Leads & Tasks go (don’t orphan)

| Module | Primary entry after nav change |
|--------|--------------------------------|
| Leads | Home service tile **and/or** Customer screen segment (P1) |
| Tasks | Home service tile **and/or** FAB “New Task” / open `TaskBoardPage` via `MainTabScope` |
| More items | Profile (and Home header bell) |

**IndexedStack size:** keep existing pages in memory if useful, but **nav indices become 0..3** + FAB overlay. Remap `MainTabScope` / `PrototypeConfig.tab*` constants.

---

## 4. Center FAB job

FAB is **create / shortcut**, not a fifth destination.

**Tap → modal bottom sheet** (prototype, no API):

| Action | Result |
|--------|--------|
| New Proposal / Quote | Info dialog or stub “Product → Calculator” |
| New Lead | Info dialog or push Leads add stub |
| New Task | `goToTab(Tasks)` if page kept off-nav, or stub |

Shield+ icon: use asset if in brand pack; else `Icons.shield` + overlay `+` / custom painter. Color = `AppColors.lightPrimary`.

**Don’t:** select a nav tab when FAB opens; don’t navigate to empty “+” page.

---

## 5. Shell layout rules

```
┌─────────────────────────────┐
│  page content               │
│  (bottom padding ≥ bar+FAB) │
└─────────────────────────────┘
     ╭─────╮  FAB
 ╭───┤     ├───╮
 │ H │ C │+│ P │ Pr │   ← floating pill
 ╰───┴───┴─┴───┴────╯
```

| Rule | Why |
|------|-----|
| `extendBody: true` | Content can scroll under translucent area; pill floats |
| Extra bottom padding on scroll views | Last cards not hidden under pill |
| Active tab = blue only one of four | FAB never “selected” |
| Hide bar on focused flows | e-App stepper / full-screen auth already no shell |

---

## 6. `MainTabScope` / Home tiles impact

Today tiles jump to Leads · Customers · Tasks · More by **index**.

After remap:

| Old index | Old tab | New behavior |
|-----------|---------|--------------|
| 0 Home | Home | same |
| 1 Leads | — | `goToLeads()` → Customer tab **or** push Leads route |
| 2 Customers | Customer | index 1 |
| 3 Tasks | — | open Tasks via helper / temporary 5th IndexedStack child without nav slot |
| 4 More | Profile | index 3 |

Clean approach: `MainTabScope` exposes **named** methods (`goHome`, `goCustomer`, `goProduct`, `goProfile`, `openTasks`, `openLeads`) instead of raw ints.

---

## 7. What not to do

- Don’t force 5 labeled tabs into the pill (breaks PNG)  
- Don’t put Tasks as the center “tab” under the shield  
- Don’t make FAB open FA Home or commission wallet payout  
- Don’t bring back full hamburger drawer as primary nav (`34`)  
- Don’t block demo on real Product module — stub OK for P0  

---

## 8. Build order (when implementing)

1. **Doc accept** this map (chrome + 4 destinations + FAB sheet).  
2. Rewrite `AppBottomNavBar` → pill + notch + 4 items + FAB slot API.  
3. Update `LifeInsurancePage` Scaffold (FAB + body padding + index 0..3).  
4. Add lightweight **Product** stub page (title + “Coming in FR-04”).  
5. Remap `MainTabScope` + Home service taps + `PrototypeConfig.tab*`.  
6. FAB → `showModalBottomSheet` with 2–3 actions.  
7. Device check: Home active blue · FAB notch · no clip on iPhone home indicator.  

---

## 9. Acceptance

- [x] Brainstorm documented (this file)  
- [x] Pill + notch + shield FAB matches PNG silhouette  
- [x] Four labels: Home · Customer · Product · Profile  
- [x] FAB opens sheet; does not steal tab selection  
- [x] Leads / Tasks still reachable (Home tile and/or FAB)  
- [x] Profile covers former More (logout path intact)  

---

## 10. Related

`34` nav decision · `36` Home mock · `37` prototype shell · `01` IA · LoginRegister home board  
