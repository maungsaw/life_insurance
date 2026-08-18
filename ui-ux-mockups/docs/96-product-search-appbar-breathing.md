# 96 — Product Search AppBar · unstick the pill

**Surface:** Flutter Product Search (`ProductSearchPage`)  
**Reference:** Blue AppBar + pill (`59` §J · `60`) · Dark tokens (`82`)  
**Today:** Back `IconButton` in the default 56px leading slot; `TextField` is the **title** with `contentPadding` vertical **0**. No extra inset from the screen edge, the bar, or the back glyph. The frost fill (`surface @ 18%`) blends into cyan so the pill looks **stuck** to the AppBar.  
**Date:** 2026-08-18

**Ask:** AppBar မှာ ကြည့်ရတာ **ကပ်** နေတယ် — back နဲ့ search ခွာ၊ ရှူလို့ရအောင် brainstorm ပြီး ship.

**Rule:** Keep **one** cyan AppBar + **one** pill field (`59`). Do not add a second search on the catalog tab. Do not drop the back affordance.

---

## 0. What is actually cramped

| Symptom | Cause |
|---------|--------|
| Arrow kisses the left safe edge | Default `leadingWidth` 56 · no extra left inset |
| Arrow kisses the pill | Title sits flush in the remaining slot · `titleSpacing` unused |
| Pill kisses top/bottom of the blue bar | Field fills `kToolbarHeight` · vertical padding 0 |
| Pill kisses the right edge | No trailing inset on the title |
| Pill ≠ a separate control | Translucent fill on the same cyan |

The left hamburger in the screenshot is **scrcpy / system**, not this page.

---

## 1. Options

| Option | Idea | Verdict |
|--------|------|---------|
| 1 · Padding only | Inset leading + title | Helps, pill still a cyan smear |
| **2 · Inset + 40px white/surface pill + 64 toolbar** | Back 8px from edge · 8px gap to pill · 16px from right · 10px vertical | ✅ **P0** |
| 3 · Search under a titled AppBar | Two rows | Taller · extra tap |
| 4 · No back, swipe only | More room for the pill | ❌ Can’t leave Search |

**Pick: Option 2.**

---

## 2. P0

```
[ 8 ] [ ← 44 ] [ 8 ] [ 🔍 Search products …… ] [ 16 ]
         ↑ toolbar 64 · pill height 40
```

- `toolbarHeight: 64`  
- `leadingWidth: 64` · back padded left **8**  
- `titleSpacing: 0` · title `Padding(left: 8, right: 16, top/bottom: 10)`  
- Pill: radius 24 · **opaque white** on Light · **white 16%** on Dark (still on cyan)  
- Icon + hint: brand cyan on Light · white on Dark  
- Typed text: onSurface / white  
- `isDense` · prefix icon 40×40 so the glyph isn’t jammed into the stroke  

Clear-on-X when the query is non-empty (same row, not a second action).

---

## 3. What not to do

- Don’t move Search into the Product tab AppBar  
- Don’t use a rectangular Material field (pill stays)  
- Don’t change catalog card grid in this pass  

---

## 4. Test

- Search page shows back + `Search products`  
- AppBar toolbar height is 64  
- Typing filters the grid (existing `filtered`)
