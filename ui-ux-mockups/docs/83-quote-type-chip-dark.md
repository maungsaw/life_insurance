# 83 — Get A Quote · Product Type chips in Dark

**Source:** Screenshot Get A Quote Dark · `63` type chips · `82` semantic tokens  
**Flutter today:** `QuoteTypeChip` still paints **light** fills (`Colors.white` / `#F1F5F9`). Unselected label uses Dark `onSurface` (near-white) on that grey — text vanishes. Selected is a white slab. Product **Name** tiles already use surface + cyan border.  
**Date:** 2026-08-17

**Ask:** Product Type ကို Dark မှာ ဖတ်လို့ရအောင်။ Light PNG (`63`) မပျက်။

---

## 1. What the screenshot shows

| Chip | Paint today | Result in Dark |
|------|-------------|----------------|
| **Saving** (selected) | White fill · cyan label · cyan border · corner dot | Blinding white block |
| **Protection / Travel / Health / Bundle** | `#F1F5F9` fill · `onSurface` label (Dark = `#F5F5F5`) | Light-on-light — looks empty |
| Product **Name** | Dark surface · cyan border when selected | Readable — keep this language |

Root: `QuoteTypeChip` was **not** on the `82` token pass. `ProductSelectChip` (Gender / Yes-No) already uses `surface` + `onSurface`.

```
QuoteTypeChip
  Material color: selected ? Colors.white : Color(0xFFF1F5F9)   ← light-only
  Text: selected ? lightPrimary : onSurface(context)            ← Dark text on light fill
```

---

## 2. Target (same widget, two brightnesses)

Unify Type with **Name** and Identification: **surface fill · cyan border + corner dot when selected · no inverted white pill**.

| State | Light | Dark |
|-------|-------|------|
| Unselected fill | `#F1F5F9` *or* `mutedFill` | `surface` / `mutedFill` (charcoal) |
| Unselected label | `onSurface` | `onSurface` |
| Unselected border | none / hairline | none / `border` |
| Selected fill | `surface` (white) | `surface` (raised charcoal) — **not** `Colors.white` |
| Selected label | `lightPrimary` | `lightPrimary` |
| Selected border | cyan 1.6 | cyan 1.6 |
| Corner dot | cyan | cyan |

Do **not** invert to white-fill + cyan text in Dark. That is the screenshot bug.

Wrap layout, labels, `*`, type → name coupling stay as `63`.

---

## 3. Flutter map

| Piece | Work |
|-------|------|
| `QuoteTypeChip` | `AppColors.surface` / `mutedFill` + `onSurface` · drop `Colors.white` / `#F1F5F9` |
| `QuoteNameTile` | Audit — already closer; match fills if any leftover light hex |
| e-App `ProductSelectChip` | Already theme-aware — don’t restyle unless a leftover grey remains |
| Guest banner / Age hint | Optional same pass: `onSurfaceSecondary` already; bump if still dim |

---

## 4. What not to do

- Don’t give Type a different selected language from Name (fill vs border)  
- Don’t keep a white selected chip “for PNG fidelity” in Dark — PNG is Light  
- Don’t change which types exist or Wrap spacing  
- Don’t restyle the whole calculator in this pass  

---

## 5. Acceptance (brainstorm)

- [x] Screenshot mapped to `QuoteTypeChip` hardcodes  
- [x] Dark = charcoal chip + cyan select · Light = `63`  
- [x] Name tiles stay the reference  
- [x] Flutter `QuoteTypeChip` token pass shipped  
- [x] Inventory  
