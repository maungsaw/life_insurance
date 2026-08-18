# 93 — Height / Weight picker · stop the cramped wheels

**Surface:** Flutter e-App · Policyholder (and Life Assured) · `showHeightPickerSheet` / `showWeightPickerSheet` in `product_pickers.dart`  
**Reference:** Pickers table (`59` §F) · Identification sheet chrome (`62`) · Dark tokens (`82`)  
**Today:** Two `Expanded` `ListWheel`s, each with a **full-width cyan fill** (40px). They sit flush → one fused bar. Unit caption (`ft-in` / `lb-oz`) is a third column squeezed on the right. Sheet padding 20 / 12 / 12. Weight wheels are **decimal pounds** (`105` + `.0`) but the caption still says **lb-oz**.  
**Date:** 2026-08-18

**Ask:** Height / Weight sheet တွေ **ကပ်နေတယ်** — ပြန်ကြည့်ကောင်းအောင် brainstorm။ (Implement after ဟုတ်ကဲ့.)

**Rule:** Keep **wheel + Done** (not a typed number). Same sheet pattern as Identification (`62`). Do **not** add BMI, Core conversion APIs, or a third measure system this pass. Dark cyan highlight stays brand (`82`) — we fix **geometry**, not the colour.

---

## 0. What is actually cramped

| Symptom (screenshot) | Cause in code |
|----------------------|----------------|
| Cyan 5' and 3" look like **one bar** | Each `CupertinoStylePicker` paints a `Container(height: 40)` the **full Expanded width**; row gap = 0 |
| `ft-in` / `lb-oz` jammed on the selection | Third `Row` child, `padding: left 8` only |
| Numbers stacked tight | `itemExtent: 40`, sheet wheel `height: 180` |
| Title / wheels / Done stacked tight | `SizedBox(12)` above and below wheels; title 16px |
| Weight reads `105 .0 lb-oz` | Caption copied from PNG; data model is `whole.tenth` (`WeightPick.label` = `105.0`) — **not** pounds + ounces |

Policyholder **form** fields (Email → Age) use 12px gaps — a bit dense, but the complaint is the **sheets**. Form spacing = P1 unless asked.

---

## 1. Two jobs (keep both)

| Job | UI | Not |
|-----|-----|-----|
| **Pick a legal measure** | Two wheels, confirm with Done | Keyboard `TextField` for ft/in (typos, locale) |
| **Know the unit** | Header or per-column label | A mystery caption kissing the highlight |

Height stays **feet + inches** (`59`). Weight stays **one number the quote/e-App already stores** (`105.0`) until Core says kg.

---

## 2. Options

| Option | Idea | Pros | Cons | Verdict |
|--------|------|------|------|---------|
| **1 · Gap only** | 12–16px between columns; inset each cyan pill | Fast; bands stop kissing | Unit still a side squeeze; weight lie remains | ❌ alone |
| **2 · iOS hairlines** | One overlay: two thin lines across the row, no fill | Classic; less “block” | Dark: cyan lines on charcoal can vanish; less brand | P1 alt |
| **3 · Column headers + preview + gap** | Title · live `5' 3"` · **ft** / **in** over each wheel · 16px gutter · inset pills · taller wheels | Reads as two controls; matches screenshot intent | Slightly taller sheet | ✅ **P0** |
| **4 · kg / cm only** | One metric wheel | Myanmar-natural | Breaks `59` PNG units · stored strings change | P1 if Core |
| **5 · Honest lb + oz** | Second wheel 0–15 oz, caption `lb` `oz` | Matches `lb-oz` label | Form today is `105.0` decimal; Confirm/Health copy | ❌ unless schema changes |
| **6 · Type it** | Numeric fields | Not cramped | Worse for field agents; validation | ❌ |

**Pick: Option 3 for P0**, plus **weight caption honesty** (below). Option 2 later if UAT still hates filled pills.

---

## 3. P0 behaviour (must) — after approval

### 3.1 Shared sheet chrome (Height and Weight)

```
[ drag handle ]
     Select your height
         5' 3"          ← live preview, brand colour, 22–24px
    ft              in  ← column labels, secondary
   (wheel)  16px  (wheel)
     [        Done        ]
```

- Horizontal inset **24**; title → preview **16**; preview → wheels **12**; wheels → Done **20**  
- Wheel viewport **220** (was 180); `itemExtent` **48** (was 40)  
- Cyan highlight: **inset 8px** left/right inside each column so the two pills **never touch**; radius 10  
- Unselected rows: secondary text; selected: white on cyan (keep)  
- No third column for the unit string  

### 3.2 Height

- Left wheel: `2'`–`8'` · header **ft**  
- Right wheel: `0"`–`11"` · header **in**  
- Preview: `5' 3"` (same as field `HeightPick.label`)  
- Drop the side `ft-in` caption  

### 3.3 Weight (keep decimal, fix the lie)

`59` said unit `lb-oz` “mock follows PNG”. The wheels were never ounces.

- Left: 70–250 · header **lb**  
- Right: `.0`–`.9` · header **.** (or `.0`)  
- Preview: **`105.0 lb`**  
- Caption **`lb-oz` removed** — that is what makes 105 / .0 look like a broken imperial pair  
- Stored value unchanged: `105.0` on Policyholder / Confirm  

Do **not** switch to kg in this pass (no Core conversion, no BMI).

### 3.4 Dark

- Sheet `AppColors.surface` · page stays dimmed  
- Highlight = `AppColors.lightPrimary` (same cyan as Done)  
- Preview text = primary, not a second cyan bar  

### 3.5 Reuse

Same chrome for Life Assured height/weight if that step uses the same sheets. Identification (`62`) stays its own grid — do not restyle NRC in this pass.

---

## 4. P1

- Metric toggle cm / kg when product schema says so — **not this pass**  
- iOS hairline selection instead of fill — **not this pass**  
- Policyholder form field gap **12 → 16** · label-to-box **8 → 10** · list inset 16 — **shipped**  
- Highlight differing Compare cells (unrelated)  
- Remember last height/weight per party  

---

## 5. What not to do

- Don’t merge the two wheels into one cyan stadium across the row (that **is** the cramped look)  
- Don’t label decimal tenths as ounces  
- Don’t add BMI or “healthy range”  
- Don’t replace Done with live-commit-on-scroll (easy to overshoot)  
- Don’t invent a Core measure API  

---

## 6. Prototype data (no API)

Defaults stay: height **5' 7"** (sheet init) / screenshot **5' 3"** from the field; weight **105.0**. Ranges unchanged (ft 2–8, in 0–11, lb 70–250, tenth 0–9).

---

## 7. Test (when shipping)

- Height: two separate cyan pills with a visible gap; preview matches wheels; field gets `5' 3"`  
- Weight: preview `105.0 lb`; no `lb-oz` string; field still `105.0`  
- Dark: unselected numbers readable (`82`) · no overflow on small width  
- Done dismisses; cancel (drag down) leaves the previous field value
