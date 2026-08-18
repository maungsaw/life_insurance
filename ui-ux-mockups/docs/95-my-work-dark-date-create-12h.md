# 95 — My work Dark · date beside title · Create · 12-hour clock

**Surface:** Flutter My work (`TaskBoardPage` · `task_calendar.dart`)  
**Reference:** Calendar hub (`77`) · AppBar create (`73`) · Dark tokens (`82`) · Date `dd-MMM-yyyy` (`94`)  
**Today:** Dark paints **white task cards** and a **white Filter** pill on charcoal (`Colors.white`). Date hero `Fri, 14 Aug 2026` sits **under** Day/Week/Month with chevrons. Create is a cyan **circle** `+` that will collide if the date moves into the AppBar. Timeline is **24h** (`08:00` … `17:00`).  
**Date:** 2026-08-18

**Ask:** Dark အဆင်ပြေအောင် · Day/Week/Month **အောက်က ရက်** ကို **My work ညာဘက်** · Create ကြည့်ကောင်းအောင် · time **AM/PM** နဲ့ 12 ကျော်ရင် **01** က ပြန်.

**Rule:** One local create (`73`) — no page FAB. Cards use `AppColors.surface` (`82`). Clock is **12-hour padded 01–12** + AM/PM; date in the header is **`dd-MMM-yyyy`** (`94`). Do not restyle the shell pill FAB.

---

## 0. What is actually wrong

| Symptom | Cause |
|---------|--------|
| Dark cards glare | `TaskAgendaCard` `color: Colors.white` |
| Filter capsule glows | `_FilterButton` inactive fill `Colors.white` |
| Date sits in the middle of the chrome | `_DateNav` under `_ScopeBar` |
| Circle `+` vs date | Both want the AppBar trailing slot |
| `13:00` on the rail | `hour.padLeft(2):00` 24h |

---

## 1. Jobs

| Job | UI | Not |
|-----|-----|-----|
| **Know which day** | `14-Aug-2026` next to **My work** | Second date under the tabs |
| **Create** | Labeled **Create** (not a mystery circle) | Page FAB · third `+` |
| **Read hours** | `09:00 AM` · `01:00 PM` | 24h `13:00` |
| **Dark** | Surface cards on background | White sheets |

---

## 2. Options

### Date placement

| Option | Verdict |
|--------|---------|
| Keep centered `_DateNav` | ❌ asked to move |
| **Title row: My work · `< 14-Aug-2026 >` · Create** | ✅ **P0** |
| Date replaces Create | ❌ loses create (`73`) |

Chevrons travel **with the date** into the AppBar. Day/Week/Month stay a full-width bar. Week strip / month grid stay. **Today:** tap the date (when not today) — drop the extra Today column that stole 56px.

Week header: `10–16-Aug-2026` (same month) or `28-Aug – 03-Sep-2026`. Month: `Aug-2026`.

### Create

| Option | Verdict |
|--------|---------|
| Keep 40px cyan circle | ❌ two cyans / no label once date is nearby |
| **Cyan pill `+ Create`** | ✅ **P0** — still one AppBar control (`73`) |
| Move to Filter row | Extra hunt · Filter is a different job |

Empty list still has text **Create task** (`73` fallback).

### Clock

| Option | Verdict |
|--------|---------|
| 24h | ❌ asked AM/PM |
| `1 PM` unpadded | ❌ asked **01** after 12 |
| **`hh:mm a` via `intl` `en_US`** | ✅ `01:00 PM` · `09:00 AM` · `12:00 PM` |

`AppDate.h12` / `AppDate.h12Hour`. `TaskFormat.timeOf` delegates. Gutter wider (~72).

---

## 3. Dark P0

- Agenda cards: `AppColors.surface(context)` (done tasks still `background`)  
- Filter + filter-sheet chips: `surface`, not `Colors.white`  
- Selected day cells: cyan + **white** glyphs (on-primary — keep)  
- Light unchanged  

---

## 4. What not to do

- Don’t add a My work FAB (`73`)  
- Don’t put Myanmar month names on the header (`94`)  
- Don’t 12-hour the OTP timer  
- Don’t rewrite Week/Month **grid** weekday letters (`M T W…`)

---

## 5. Test

- `AppDate.h12Hour(13) == '01:00 PM'` · `(9) == '09:00 AM'` · `(12) == '12:00 PM'` · `(0) == '12:00 AM'`  
- My work shows `14-Aug-2026` and **Create**; no `Fri, 14 Aug 2026` under the tabs  
- Dark: agenda `Material` color is `darkSurface`, not white
