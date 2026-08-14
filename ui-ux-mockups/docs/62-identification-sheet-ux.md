# 62 — Identification bottom sheet (NRC picker fix)

**Source:** Wireframe crop — **Identification** sheet (NRC · Old NRC · Passport · No ID · State / Township / Type · NRC Number)  
**Flutter today:** `showIdentificationPickerSheet` in `product_pickers.dart` · opened from e-App Policyholder **Identification** field (`eapp_wizard`)  
**Related:** `59` §F pickers · `60` P1 · Height / Weight sheets (same file — must stay separate)  
**Date:** 2026-08-14

**Ask:** Current Identification sheet **does not match** the wireframe. Brainstorm so the sheet looks and behaves like the PNG, without height-wheel ghosts, and so Policyholder does not double-ask ID type.

---

## 1. What the PNG is (target)

```
Identification

┌──────────┐  ┌──────────┐
│ NRC   ●  │  │ Old NRC  │     ← 2×2 tiles · selected = blue border + corner dot
├──────────┤  ├──────────┤
│ Passport │  │ No ID    │     ← unselected = light grey fill, no border
└──────────┘  └──────────┘

[ State ▾ ] [ Township ▾ ] [ Type ▾ ]   ← only when NRC / Old NRC

┌─────────────────────────┐
│ NRC Number              │
└─────────────────────────┘
```

| Slot | Wireframe cue |
|------|----------------|
| Title | **Identification** (bold, left) |
| Type grid | **Four equal tiles** · 2 columns · large tap targets |
| Selected | Primary border + **small blue circle top-right** (same language as Product / Gender chips) |
| Unselected | Soft grey fill · no blue border |
| NRC row | Three **outlined** dropdowns: State · Township · Type |
| Number | Full-width outlined field label **NRC Number** (Passport → **Passport Number**) |
| Ghost `5' / 3' / ft-in` | **Wireframe collage bleed** from Height sheet under this crop — **not** part of Identification |

---

## 2. What is wrong today (Flutter)

| Issue | Why it feels “လွဲ” |
|-------|---------------------|
| Chips via `Wrap` + `ProductSelectChip` | Looks like **small buttons**, not the PNG’s **tall 2×2 tiles** |
| Unselected = white | PNG unselected = **grey wash** |
| `_MiniDrop` shows value always | PNG empties read as **labels** State / Township / Type until picked (or light placeholder) |
| Township list = `KaMaNa` strings only | OK for mock, but sheet should show **codes** clearly; optional live preview `12/KaMaNa(N)127487` |
| Policyholder has **Identification Type** chips **and** Identification field → sheet | Double UX — type asked twice |
| `IdPick` open with only `type` + raw `number` string | Sheet **doesn’t parse** existing `12/KaMaNa(N)127487` back into State / Township / Type / serial |
| Height + ID share one file | Fine; but if sheets stack or route wrong, wheels can bleed — keep **one sheet at a time**, opaque white sheet background |
| Extra **Done** styling | Keep Done; PNG crop often cuts footer — still need a clear primary CTA |

---

## 3. Decisions

### 3.1 One job = build / edit ID value

Sheet returns a structured `IdPick` and a **display string** for the form field:

| Type | Display on Policyholder field |
|------|-------------------------------|
| NRC / Old NRC | `12/KaMaNa(N)127487` |
| Passport | passport number only |
| No ID | literal `No ID` (or empty + chip on form — prefer store `No ID`) |

### 3.2 Type grid (match PNG)

Rebuild as `_IdTypeTile` (not generic product chip):

- Fixed height ~48–52  
- `GridView` / `Table` 2×2, equal width  
- Selected: white fill · `AppColors.lightPrimary` border 1.6 · corner badge  
- Unselected: `#F1F5F9` (or `lightBorder` wash) · no border  

### 3.3 Conditional body

| Type | Show |
|------|------|
| **NRC** / **Old NRC** | State · Township · Type + **NRC Number** (6 digits, numeric) |
| **Passport** | **Passport Number** only (no State row) |
| **No ID** | Short note: “No identification on file” · no number field |

Old NRC vs NRC: same layout; mark `IdPick.isOldNrc` for Core later. Serial rules can stay soft in prototype.

### 3.4 State · Township · Type

| Field | Mock source (P0) |
|-------|------------------|
| State | `1`…`14` (common MM codes; start with wireframe-relevant `12`, `9`, …) |
| Township | Code list e.g. `KaMaNa`, `PaZaTa`, `LaMaNa`, `AhGaYa` (expand later from Core) |
| Type | `N` · `P` · `E` (and rare codes if product adds) |

UI: three `AppTextField`-style outlined dropdowns (label on border), chevron, tap → option sheet.  
**Live preview** under the row (P0 recommended): muted text `12/KaMaNa(N)••••••` updating as user types.

### 3.5 Policyholder form cleanup

| Today | After |
|-------|--------|
| Gender chips | Keep on form |
| **Identification Type** NRC \| Passport chips on form | **Remove** (or comment-out) — type lives **only** in Identification sheet |
| Identification field | Read-only · opens sheet · shows composed string |

Scanner step can still toggle NRC/Passport for **capture mode**; that is KYC photo, not the ID string editor.

### 3.6 Height ghost

- Identification sheet scaffold: **solid white** `Container` / `Material` full sheet (not transparent).  
- Never open Height and Identification together.  
- Ignore `5' / ft-in` in the PNG crop — documentation only.

---

## 4. Validation (prototype)

| Rule | P0 |
|------|----|
| NRC / Old NRC | State · Township · Type required · number length **6** soft (warn, don’t hard-block if empty until Done) |
| Passport | Number non-empty |
| No ID | Always valid |
| Done | Pop with `IdPick`; cancel = drag dismiss → null |

---

## 5. Flutter map (when fixing)

| File | Change |
|------|--------|
| `product_pickers.dart` `_IdSheet` | Retile 2×2 · grey unselected · opaque sheet · preview line · parse initial NRC |
| `IdPick` | Add `isOldNrc` · `parse(String display)` helper |
| `eapp_wizard.dart` | Drop on-form ID type chips · `_pickId` passes full `IdPick` / parse from `_ph.identification` |
| Height / Weight | Unchanged; ensure sheet `backgroundColor: Colors.white` |

---

## 6. What not to do

- Don’t put height/weight wheels on the Identification sheet  
- Don’t keep duplicate ID type chips on Policyholder **and** in the sheet  
- Don’t invent free-text township when the PNG is dropdown-first  
- Don’t require OCR to fill the sheet (manual always works)  
- Don’t use company/entity ID types here  

---

## 7. Acceptance

- [x] Brainstorm documented (this file)  
- [x] Sheet matches PNG: 2×2 tiles · State/Township/Type · NRC Number  
- [x] Unselected tiles grey · selected blue border + corner dot  
- [x] Passport / No ID hide NRC row correctly  
- [x] Policyholder: single Identification field → sheet (no duplicate type row)  
- [x] Initial value parses back into dropdowns when possible  
- [x] No height-wheel bleed on Identification  
- [x] Inventory updated  

---

## 8. Related

`Calculator.png` / `New Proposal.png` picker strip · `59` · `60` · `product_pickers.dart` · e-App Policyholder  
