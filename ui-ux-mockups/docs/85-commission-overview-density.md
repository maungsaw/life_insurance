# 85 — Commission Report · few vs many categories

**Source:** Report scrcpy (4 equal bars) · `80` overview · `CommissionLine` · catalog may grow (Bundled · extra lines)  
**Flutter today:** `CommissionOverviewLayout` + `CommissionOverviewChart` switch density. Live mock (4 lines) stays PNG four-up.  
**Date:** 2026-08-17

**Ask:** Product / category **နည်းရင် တစ်ပုံ · များရင် တစ်ပုံ**။ Overview က ဖတ်လို့ရ၊ ညှပ်မသွား၊ ဘားထဲက count + MMK မပျောက်။

---

## 1. What we are charting (lock this)

This board is **product category**, not SKU.

| Grain | Example | Use here? |
|-------|---------|-----------|
| **Line / category** | Protection · Saving · Health · Travel (+ later Bundled) | **Yes** — PNG + `80` |
| **Product code** | Universal Life · PA · Credit Life · … | **No** on this chart — too many; identity stays on **History** rows |

If Core later has 8+ *lines*, the layout switch still applies. If someone wants per-product bars, that is a **P2 drill-down**, not the default Overview.

Zero-amount lines: **hide** when count of *visible* bars would exceed the “few” layout; when ≤4, showing a `—` column is OK so the PNG’s four slots stay familiar.

---

## 2. Why a single `Expanded` Row fails

| n | What happens today |
|---|-------------------|
| 1 | One skinny 36px bar in a huge row — or one stretched column with a tiny glyph |
| 4 | Matches PNG — OK |
| 6–8 | Labels ellipsis, MMK `9px` clips, bars 36px collide |
| 12+ | Unusable |

MMK above the bar is already `fontSize: 9` + ellipsis. More columns make **money** the first thing to die — the opposite of FR-02.

---

## 3. Layout by count (visible bars, amount > 0 unless noted)

Let `n` = categories to draw (after period filter).

| n | Layout | Why |
|---|--------|-----|
| **0** | Keep empty copy: “No commission this period” | Already shipped |
| **1** | **List row**, not a lonely column: icon · name · thick horizontal bar · MMK + count. Top card can repeat the same category — OK |
| **2–4** | **Equal-width vertical bars** (today / PNG). Min bar width 36. Amount above · count in bar · icon + label below |
| **5–7** | Same bar *chrome*, but **horizontal scroll**. Each column **min width ~72**. Peek the next bar (8px) so it is obvious you can swipe. No page dots |
| **8+** | **Ranked vertical list** (sort by amount desc). Row = icon · name · track bar · MMK · count. Optional **Others** bucket if n > 10 (sum of the tail) |

```
few (2–4)                 many (8+)
[ 156k ] [ 123k ]         Health      ████████  236,500  4
[  |4| ] [  |3| ]         Travel      ███████   210,580  3
  Prot     Saving         Protection  █████     156,000  4
                          Saving      ████      123,000  3
                          Others      ██         42,000  2
```

Do **not** switch the default to a pie. Pie hides MMK comparison; PNG is bars.

---

## 4. Shared rules (all densities)

| Rule | Detail |
|------|--------|
| Sort | Always **amount descending** (left-to-right or top-to-bottom) so “who won” is spatial, not only the Top card |
| Dual signal | MMK + **count** on every density |
| Period | Same `All / This month / …` menu — layout recomputes when `n` changes with the filter |
| Top performing | Unchanged; hide when n = 0 |
| Summary tiles | Unchanged (total count + MMK · vs last month) |
| Dark | Use `onSurface` / `mutedFill` — no white zebra (same as Compare `82`) |
| Tap (P1) | Bar / row → History tab with that `CommissionLine` filter (hub already has line chips) |
| Accessibility | Scrollable bars: semantics “Category, amount, count”. List: one node per row |

**Others** (only n > 10): one row, no fake colour of a real line; subtitle “N more categories”. Tap expands inline or a sheet — P1.

---

## 5. Threshold constants (one mock object)

```
CommissionOverviewLayout
  fewMax = 4          // PNG
  scrollMax = 7       // still bars
  listFrom = 8
  othersAfter = 10
  barMinWidth = 72    // scroll mode
```

Tune later from Core line count; don’t scatter magic numbers in the widget.

---

## 6. Flutter map

| Piece | Work |
|-------|------|
| `CommissionOverviewLayout` | Thresholds + `modeFor(n)` → `few` · `scroll` · `list` |
| `reportLines` | Helper `visibleLines(period)` — drop zeros when `n` would be > 4 |
| `CommissionReportBody` | Switch child: `Row` / `SingleChildScrollView`+`Row` / `Column` of `_CategoryListTile` |
| `_CategoryBar` | Keep for few + scroll; give scroll columns a **fixed min width** |
| New `_CategoryListTile` | Ranked row for 8+ |
| Mock | Optional 5th `CommissionLine.bundled` **or** extra fake lines behind a debug flag to demo scroll/list |

Prototype P0 can demo with **bundled + 4 existing** (n = 5 → scroll) and a debug “stress” list of 8 stubs. Don’t invent Core product types.

---

## 7. What not to do

- Don’t put **SKU** bars on Overview  
- Don’t shrink `fontSize` below 9 to keep 8 `Expanded` columns  
- Don’t wrap bars onto two rows (misaligned baselines)  
- Don’t make pie the default  
- Don’t change History identity rows or withdraw rules (`80` / `61`)  
- Don’t horizontal-scroll **and** shrink — pick one density  

---

## 8. Acceptance

- [x] Grain = category, not SKU  
- [x] 0 / 1 / 2–4 / 5–7 / 8+ layouts  
- [x] Hide zeros when crowded; keep PNG four-up when few  
- [x] Ranked list + optional Others  
- [x] Flutter map + what not to do  
- [x] Implement density switch (`CommissionOverviewLayout` · `CommissionOverviewChart`)  
- [x] Inventory  
