# 98 — One select chip · MDRT ring that reads

**Surface:** Shared select control · MDRT Tracker ring · Get A Quote type/name  
**Reference:** Quote chips (`63`) · Team visuals (`72`) · Dark (`82`)  
**Today:** MDRT filters are Material **ChoiceChip** (fill + check). Get A Quote is **cyan border + corner dot**. Customer filters copy the quote look but the **dot hangs outside** (`top: -4`) and paints a smear on the next chip. `TeamRing` is a raw `CircularProgressIndicator` — thin arc, square caps, grey track that looks unfinished at 33%.  
**Date:** 2026-08-18

**Ask:** ပထမပုံ selected ကို ဒုတိယပုံစံလို **တစ်မျိုးထဲ** · နေရာတိုင်း · ပထမ **circle** ကြည့်ကောင်းအောင်.

**Rule:** Selectable **chips / tiles** share one language. Do **not** restyle segmented bars (My work Day|Week|Month), calendar day cells, or status pills (Pending / High).

**Follow-up:** `Container(alignment:)` made every chip **full width** inside a `Wrap` → Filter leads looked like a **vertical list** and overflowed ~6px. Idle chips **shrink to the label** so they sit **one flow** (row, then wrap) again.

---

## 0. Two jobs

| Job | Canonical look | Not |
|-----|----------------|-----|
| **Pick one option** | Surface fill · 1.6 cyan border · **inset** 8px corner dot | ChoiceChip check · fill-only |
| **Show a share of a total** | Round-cap ring · thick track · `%` in brand | Square-cap `CircularProgressIndicator` |

---

## 1. Select chip (everywhere that is a pick)

**Idle:** `mutedFill` or `surface` + hairline `border`  
**On:** same fill · **cyan 1.6 border** · label cyan · **dot inside** top-right (not `Positioned(top: -4)` — that is the “line” on Universal Life)

`AppSelectChip` in `components`. Wrappers keep old names:

- `ProductSelectChip` / `QuoteTypeChip` / `QuoteNameTile`  
- MDRT All · Qualified · In Progress · Not Yet  
- App tracker chips  
- Team pulse Personal/Total  
- Team hub Personal Team / Total Group  
- Customer / Lead / Task filter chips  
- Commission history period chips  

Skip: splash file picker, OTP, password rules.

---

## 2. MDRT ring

Custom paint (all `TeamRing` sizes):

- Track: muted cyan 12% · full circle  
- Progress: brand · **StrokeCap.round** · start at 12 o’clock  
- Center `%` in brand, w800  
- MDRT hero size **128** (was 88)

---

## 3. What not to do

- Don’t use a checkmark on quote-style chips  
- Don’t let the dot overflow into the neighbour  
- Don’t fill the selected chip cyan (that’s a segment, not a chip)  
- Don’t animate a fake countdown on the ring  

---

## 4. Test

- MDRT: no `ChoiceChip` · selected chip has no check icon  
- Ring shows `33%`  
- Quote type chip still `Saving` with a corner dot **inside** the tile
