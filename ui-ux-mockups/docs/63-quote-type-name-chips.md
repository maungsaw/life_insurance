# 63 — Get A Quote · Product Type & Product Name chips

**Source:** Wireframe crop — **Product Type *** · **Product Name *** selection tiles (Get A Quote / Calculator)  
**Flutter today:** `ProductQuotePage` uses `ProductSelectChip` in a `Wrap` for both rows  
**Related:** `59` §C calculator · `62` ID tiles (same selected language) · `Calculator.png`  
**Date:** 2026-08-14

**Ask:** Product Type / Product Name must read like the PNG — required labels, type as a wrapping chip row, name as equal side-by-side tiles with blue border + corner dot. Fix the current chip so it stops looking wrong on Get A Quote.

---

## 1. What the PNG is

```
Product Type *
[ Protection ] [ Saving ● ] [ Travel ]
[ Health ] [ Bundle ]

Product Name *
[ Universal Life ● ] [ Short Term Endowment ]
```

| Slot | Spec |
|------|------|
| Labels | **Product Type *** · **Product Name *** — red asterisk (required) |
| Type options | Protection · Saving · Travel · Health · Bundle |
| Type layout | **Wrap** — variable width from label · 8px gaps · wraps to next line |
| Name options | Products in the **selected type** only (e.g. Saving → Universal Life · Short Term Endowment) |
| Name layout | **One row**, equal-width tiles when 2; wrap / 2-col when 3+ |
| Selected | Primary blue border (~1.6) · **corner blue dot** (top-right) · label primary |
| Unselected | White fill · **no** (or hairline) border · dark grey label |

PNG crop: Type selected may look border-only; Name shows border **+** dot. **Unify both to border + corner dot** (same as Identification tiles / Gender) so selection is consistent.

---

## 2. What is wrong today

| Issue | Why it feels wrong |
|-------|---------------------|
| `ProductSelectChip` sets `width: double.infinity` | Inside `Wrap`, each chip becomes a **full-width bar** — not the PNG’s compact type chips |
| Same widget for Type and Name | Type needs **intrinsic width**; Name needs **Expanded equal columns** |
| Labels missing `*` | Wireframe marks both required |
| Unselected always light border | PNG unselected Type tiles look **borderless / flat white** |
| Bundled labeled `Bundle` | Match PNG string **Bundle** (already) — keep |
| Changing type | Works (picks first product in line) — keep; make selection chrome match |

`ProductSelectChip` is also used in e-App (Gender, Yes/No). **Don’t break those** — either add a `expand: false` flag or split widgets:

| Widget | Use |
|--------|-----|
| `ProductSelectChip` | Gender / Yes-No / compact choices (may stay expanded in a `Row`) |
| `QuoteChoiceChip` (new) | Get A Quote **Type** — intrinsic width · wrap-friendly |
| `QuoteNameTile` (new) | Get A Quote **Name** — fills cell · taller padding · multi-line name OK |

---

## 3. Decisions

### 3.1 Product Type

- Source: `ProductMockData.linesInCatalog` (On products only — already).  
- Tap type → `_applyProduct(first product of that line)` · refresh Name row · reset variant / frequency / term / SI defaults for that product.  
- Layout: `Wrap(spacing: 8, runSpacing: 8)` + intrinsic chips.  
- No “All” on this screen (catalog already has All).

### 3.2 Product Name

- Source: products where `p.line == selectedType`.  
- Tap name → `_applyProduct(p)` without changing type.  
- Layout P0: `Row` of `Expanded` children when count ≤ 3; if count ≥ 4 use 2-col `GridView` / Wrap with min width. Saving line has 2 names — **exact PNG**.  
- Long names: `maxLines: 2` · center · `fontSize` 13–14.

### 3.3 Arrival from Product Details

Pre-select type + name from `widget.product` (already). User may still change both — single-product quote rule stays (one selected name at a time, no cart).

### 3.4 Required / validation

Visual `*` only on P0. Block Save only if product missing (impossible if always one selected). No extra dialog.

### 3.5 Shared selection chrome

```
┌─────────────────┐
│  Saving      ●  │  ← 10–12px circle, sits on top-right corner (clip: none)
└─────────────────┘
```

Radius ~10–12 · padding Type `H14 V10` · Name `H12 V14`.

---

## 4. Flutter map (when building)

| File | Change |
|------|--------|
| `product_widgets.dart` | Add `QuoteChoiceChip` + `QuoteNameTile` (or `expand` param on chip) |
| `quote.dart` | Labels with `*` · Type Wrap · Name equal Row · drop full-width chip for type |
| e-App Gender chips | Keep using existing `ProductSelectChip` in `Expanded` Row (unchanged) |

---

## 5. What not to do

- Don’t use dropdowns for Type / Name on Get A Quote (PNG is tiles)  
- Don’t show Off / Group products  
- Don’t multi-select names (no cart)  
- Don’t put Type/Name on Product Details (Details already chose the product)  
- Don’t change catalog card layout in this pass  

---

## 6. Acceptance

- [x] Brainstorm documented (this file)  
- [x] Type chips wrap with intrinsic width (not full-bleed bars)  
- [x] Name tiles equal side-by-side for Saving pair  
- [x] Selected = blue border + corner dot on **both** rows  
- [x] Labels show red `*`  
- [x] Type change filters Name list and applies first / kept product correctly  
- [x] Inventory updated  

---

## 7. Related

`Calculator.png` · `59` · `62` · `ProductQuotePage` · `ProductSelectChip`  
