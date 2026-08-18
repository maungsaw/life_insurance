# 99 — See more · My performance as FA detail

**Surface:** Home team pulse · Team hub My performance sheet  
**Reference:** Team 6-up (`72`) · FA detail (`72` mockup 5) · Ring (`98`)  
**Today:** Home link says **See team >**. My performance is a **label/value list** (Overall · APE · FYP · MDRT · Policies). FA Performance Detail already has the language leaders expect: **ring + Achievement/MoM + KPI bars**.  
**Date:** 2026-08-18

**Ask:** See team → **See more**. My performance UI = **last screenshot** (U Win Naing breakdown).

---

## 0. Two jobs

| Where | Change |
|-------|--------|
| Home **Team performance** card | `See team >` → **See more** (same tap → Team hub) |
| Hub **My performance** sheet | Same body as FA detail · **self** numbers only |

Do **not** mix team roll-up into this sheet. Caption stays: *Your personal figures — not the team roll-up.*

---

## 1. Sheet = FA detail, not a list

1. **Hero** — `TeamRing` · Achievement `8.4M / 11.8M` · MoM  
2. **Performance breakdown** — APE · FYP · Subsequent FYP · Weighted Freelance FYP (`TeamKpiBar`)  
3. **Road to MDRT** — bar + % of target  
4. **Policies** — New · Active as a caption (FA page has no policies; keep the data)

Scrollable sheet (`isScrollControlled`) so Dark + small phones don’t overflow.

---

## 2. What not to do

- Don’t put team APE/FYP in My performance  
- Don’t send the leader to the FA’s login  
- Don’t invent Core math — display-only mock, same as FA rows  
- Don’t rename **View org chart**

---

## 3. Test

- Pulse card shows **See more**, not See team  
- Opening My performance finds **Performance breakdown**, **Achievement**, **TeamRing**, APE bar
