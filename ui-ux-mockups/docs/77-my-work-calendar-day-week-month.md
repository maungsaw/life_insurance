# 77 — My work calendar · Day / Week / Month clarity

**Source:** Current Flutter screenshot (2026-08-17) · BRD §5.7 FR-07 · `08` `68` `73`  
**Flutter today:** Day / Week / Month changes task scope, but all three still render one flat agenda list. Header has date arrows + scope tabs + 3 stats + assignment banner + 2 filter rows before work appears.  
**Date:** 2026-08-17

**Ask:** Make all three modes feel like a real calendar, reduce visual noise, and keep every FR-07 job clear.

**Rule:** BRD wins behavior. Mobile = calendar-first My work; manager board/admin stays Web.

---

## 1. What is wrong in the current screenshot

| Problem | User effect | Fix |
|---------|-------------|-----|
| Day / Week / Month share the same flat list | Tabs feel like filters, not calendar views | Give each scope its own calendar body |
| Six layers before first task | The day’s work is below controls | Keep only AppBar + scope + calendar above tasks |
| Date arrows always move one day | Wrong mental model in Week / Month | Day ±1 day · Week ±7 days · Month ±1 month |
| Header date always says one day | Week / Month context is unclear | Day date · week range · month name |
| Stats are global, not selected scope | Counts appear unrelated to calendar | Scope-aware compact summary |
| Two horizontal filter rows | Scrolling chips compete with calendar | One **Filter** button + bottom sheet |
| “New from AM” always occupies a row | Alert competes with actual work | Small dismissible calendar badge / task marker |
| Priority red rails dominate every card | Looks like errors | Thin priority marker; red only overdue |
| Month currently has no month grid | Not a calendar view | 7-column month grid with task dots |

**Core issue:** the screen is a dashboard stacked above a list. It needs to become a **calendar with an agenda**, not a report page.

---

## 2. One shared shell

```
My work · 6                                      [+]

[ Day ] [ Week ] [ Month ]

‹     Fri, 14 Aug / 10–16 Aug / August 2026     ›
      tap title = date picker        [Today]

┌──────────── calendar body ─────────────┐
│ changes by Day / Week / Month          │
└────────────────────────────────────────┘

3 tasks · 1 overdue                         [Filter]

selected scope / selected day agenda
```

### Keep

- AppBar title + one filled `+` (`73`)
- Day / Week / Month segmented control
- Previous / next
- Task status and priority inside task cards
- Empty-state Create task

### Remove from the main stack

- Three large Pending / In progress / Overdue cards
- Two always-visible filter-chip rows
- Full-width “New from AM” banner
- Duplicate calendar/list labels

Counts move to one compact line. Filters move to a bottom sheet.

---

## 3. Date navigation semantics

| Scope | Center title | ‹ / › | Today |
|-------|--------------|-------|-------|
| **Day** | Fri, 14 Aug 2026 | Previous / next day | Select today |
| **Week** | 10–16 Aug 2026 | Previous / next week | Current week + today |
| **Month** | August 2026 | Previous / next month | Current month + today |

Swiping the calendar body follows the same unit. Switching scope keeps the selected date.

---

## 4. Day view — one-day calendar + timeline

Day must look like a calendar, not only cards.

```
M 10   T 11   W 12   T 13  [F 14]  S 15   S 16
  •             •      •     •••      •

All day  [ Leave appointment ]

09:00 ── [ Agent · On-Boarding        ]
10:00 ── [ Meeting appointment        ]
11:00 ──
12:00 ──
14:30 ── [ Follow-up call             ]
```

| Element | Rule |
|---------|------|
| 7-day strip | Selected day filled cyan; today gets a small outline; dots = task count |
| Timeline | Time column + light horizontal guides |
| Timed task | Positioned near start time; title · type · status |
| Long / overlapping tasks | Stack vertically; do not squeeze side-by-side on narrow phones |
| All-day / multi-day | Separate compact row above timeline |
| Tap date | Changes selected day and timeline |
| Tap empty time | P1: create task with prefilled time |

Only render useful working hours around tasks (for example 08:00–18:00); do not make a 24-hour empty scroll.

---

## 5. Week view — week calendar, then grouped agenda

A seven-column Outlook-style hourly grid is too narrow on mobile. Use a real **week calendar strip** plus grouped daily agenda.

```
10–16 Aug 2026

 Mon   Tue   Wed   Thu  [Fri]  Sat   Sun
 10    11    12    13    14    15    16
  0     0     1     1     3     1     0
                      └ task dots / count

Fri, 14 Aug · 3 tasks
  09:00  Agent
  10:00  Meeting appointment
  14:30  Follow-up call

Sat, 15 Aug · 1 task
  11:00  e-App signature follow-up
```

| Element | Rule |
|---------|------|
| Week strip | All 7 days visible; count/dots below each date |
| Selected day | Cyan background; tapping scrolls to that day section |
| Agenda | Same task card language as Day, grouped by date |
| Empty days | Remain visible in calendar strip; omit empty agenda groups |
| Week total | Compact line “5 tasks · 2 in progress · 1 overdue” |

This keeps Week recognizably calendar-based while preserving readable task titles.

---

## 6. Month view — month grid + selected-day agenda

```
August 2026
 M   T   W   T   F   S   S
                         1   2
 3   4   5   6   7   8   9
10  11  12• 13• [14••] 15• 16
17  18  19  20  21  22  23
...

Fri, 14 Aug · 3 tasks
  Agent
  Meeting appointment
  Follow-up call
```

| Element | Rule |
|---------|------|
| Grid | 7 columns · 5/6 weeks · weekday header |
| Outside-month dates | Muted but tappable |
| Selected date | Cyan circle / soft cyan cell |
| Today | Thin primary outline if not selected |
| Task indicators | Max 3 small dots; `+2` for more |
| Dot colors | Status: amber Pending · cyan In Progress · green Completed |
| Overdue | Tiny red corner marker, not a full red cell |
| Tap date | Select day and show that day’s agenda below |
| Tap agenda card | Task detail / edit |

Do not place full task names inside month cells; mobile cells are too small.

---

## 7. Filters and status summary

### Compact summary

Below the calendar:

`3 tasks · 2 in progress · 1 overdue`         `Filter`

- Counts come from the visible Day / Week / Month scope.
- Overdue is red only when non-zero.
- Tapping a count may apply that status filter later; P0 = display only.

### Filter bottom sheet

```
Filter tasks
Status       [All] [Pending] [In Progress] [Completed]
Type         [All] [Meeting] [On-Boarding] [...]
Assignment   [All] [Assigned to me] [New]

[ Reset ]                              [ Show 3 tasks ]
```

- AppBar/filter button shows a badge when filters are active.
- Active filters appear as one removable summary row only:
  `Pending ×  ·  Meeting ×`
- No two permanent horizontal chip carousels.

---

## 8. New assignment and overdue behavior

| State | UI |
|-------|----|
| New assignment | Small blue `NEW` pill on the task + blue dot on its date |
| Multiple new tasks | Calendar header badge `2 new`; no full-width banner |
| Overdue | Red `Overdue` pill and red date corner marker |
| Completed | Muted card + green status; remains visible unless filtered |
| Manager assigned | Meta line `Assigned by AM`; FA updates status/notes only |

Opening a new assignment clears its `NEW` marker.

---

## 9. Task cards — simplify

```
10:00  Meeting appointment                         ›
       Meeting · Client May Chan Myae
       [Pending]                         High
```

- White card, 12–14 radius, subtle border rather than heavy shadow.
- Priority uses a 3 px side marker: High amber; overdue alone uses red.
- One status pill.
- No duplicated date inside a card when already under a day heading.
- On-Boarding title may use agent name, but type must remain visible.

---

## 10. Empty states

| Scope | Copy | CTA |
|-------|------|-----|
| Day | No tasks on Fri, 14 Aug | Create task |
| Week | No tasks this week | Create task |
| Month | No tasks in August | Create task |
| Filtered | No tasks match these filters | Reset filters |

Creating from Day / selected Week day / selected Month date prefills that date.

---

## 11. Accessibility and interaction

- Minimum 44×44 tap targets for dates and arrows.
- Status is conveyed by text + color, never color alone.
- Month dots have semantics such as “3 tasks, 1 overdue”.
- Preserve selected scope/date/filter after returning from task detail.
- Do not auto-jump back to today after Save.
- AppBar `+` remains visible; no page FAB (`73`).
- Shell shield FAB remains unrelated to task creation.

---

## 12. BRD coverage

| FR-07 | UX |
|-------|----|
| Assigned tasks in calendar | Day timeline · Week strip/agenda · Month grid |
| Day / Week / Month report | Scope-aware calendar and counts |
| Daily create/view/complete | Selected-date agenda · AppBar `+` · task detail |
| Pending / In Progress / Completed | Pills · dots · filter sheet |
| Assignment/update awareness | NEW marker · assigned-by metadata |
| Manager Add/Move/Delete | Still Web-only |

No separate To-Do tab. No mobile Kanban board.

---

## 13. Flutter map (when implementing)

| Piece | Work |
|-------|------|
| `TaskBoardPage` | Split shared shell from scope bodies |
| `TaskDayCalendar` | 7-day strip + working-hours timeline |
| `TaskWeekCalendar` | week date strip + grouped agenda |
| `TaskMonthCalendar` | month matrix + selected-day agenda |
| Navigation | shift by day / 7 days / month; Today button |
| Counts | scope-aware, not global |
| Filters | one bottom sheet + active-filter badge |
| Data helpers | `forRange` · `countForDay` · `monthMatrix` |
| New marker | clear when detail opens |

---

## 14. Phasing

| Phase | Scope |
|-------|-------|
| **P0** | Real Day strip/timeline · Week strip/grouped agenda · Month grid/day agenda · correct arrows/titles · compact scope counts · Filter sheet |
| **P1** | Swipe navigation · tap empty time to create · date picker · animated scope transition |
| **Out** | Mobile manager Kanban · drag/drop task scheduling · Google/Outlook sync |

---

## 15. Acceptance (brainstorm)

- [x] Current screenshot clutter diagnosed
- [x] Day / Week / Month each has a distinct calendar body
- [x] Scope-aware navigation, counts, empty states
- [x] Filters reduced to one bottom sheet
- [x] NEW / overdue / status rules
- [x] BRD FR-07 boundaries retained
- [x] Flutter calendar redesign shipped (P0)
- [x] Inventory updated

---

## 16. Shipped (P0)

| File | What landed |
|------|-------------|
| `task_mock_data.dart` | `TaskFilter` · `TaskAssignment` · `forRange` · `forDayFiltered` · `countForDay` · `monthMatrix` · `startOfWeek` · week/month titles |
| `widgets/task_calendar.dart` | `TaskDayStrip` · `TaskDayTimeline` · `TaskWeekStrip` · `TaskMonthGrid` · `TaskAgendaCard` · `TaskDayDots` |
| `widgets/task_filter_sheet.dart` | `showTaskFilterSheet` with live “Show N tasks” · `TaskActiveFilterRow` |
| `pages/index.dart` | Shared shell: scope bar · scope-aware arrows/title/Today · calendar body · compact counts + Filter badge · scope empty states |

Behavior: date/scope/filter survive task detail; opening a task clears its `NEW`; three stat cards, both chip carousels and the “New from AM” banner are gone.

P1 remains open: swipe navigation, tap empty time to create, date picker, week agenda auto-scroll, animated scope transition.

---

## 17. Related

BRD §5.7 FR-07 · `08` · `20` · `21` · `68` · `73` · `76`
