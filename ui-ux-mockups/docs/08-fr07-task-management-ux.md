# FR-07 Task Management UX (Mobile + Web)

**BRD §5.7**

| Requirement | Channel | UX |
|-------------|---------|-----|
| Assigned tasks in **calendar** | Mobile (+ view on portal) | Day / Week / Month |
| Notifications on assign/update | Mobile | Push + in-app Work badge |
| Create / view / complete tasks | Mobile | On calendar hub · linked to client/lead/recruit |
| Managers **Add / Move / Delete** | Web | Task admin + leave appointment example |
| Status: Pending · In Progress · Completed | Mobile + Web | Explicit status control |
| Leave appointment tracking | Web (+ mobile view) | Task type = Leave appointment (see `21`) |

---

## 1. Mental model

```
Manager (Web) creates / assigns / moves / deletes
        ↓ push
FA (Mobile) sees My work (calendar + day’s tasks) + notification
        ↓ updates status
Manager sees completion on portal
```

---

## 2. Decision: no separate To-Do tab (mobile)

**Why remove Calendar | To-Do toggle**
| Problem | Effect |
|---------|--------|
| Two homes for the same tasks | FA unsure where to look / create |
| Duplicate lists (calendar day vs To-Do checklist) | Inconsistency risk |
| Extra tap to create | Create lived only on To-Do |
| “To-Do” is product jargon | Field users think in dates + due work |

**Chosen model — calendar-centric “My work”**
1. One Work hub: **My work**
2. Day / Week / Month controls the date scope
3. Selected date shows that day’s (or range’s) task list
4. **+ Task** in the header creates a task with a due date (lands on calendar)
5. Task detail → status update → back to My work
6. Assigned / overdue surfaced as alert strip + status pills (not a second tab)

**Optional later (don’t ship as second tab)**
- Filter chips under the list: All · Pending · Assigned to me  
- “Overdue” section pinned above today’s list when Day = today  

---

## 2b. My work redesign (agenda, not checklist)

**Problem after removing To-Do:** Screen still felt like “calendar chrome + To-Do list” — redundant subtitle, flat task rows, yellow alert competing with list, Day/Week/Month didn’t change the body.

**Redesign principles**
| Principle | UI |
|-----------|-----|
| One job | Plan the day / week / month — not manage two lists |
| Date first | Big date + ‹ › · scope segment Day/Week/Month |
| Scope changes content | Day = agenda timeline · Week = day rollups · Month = grid + dots |
| Agenda > checklist | Time on the left · colored rail cards · status pills |
| Soft assign cue | Compact “New from AM” banner (not loud yellow alert) |
| Status language | Pending / In Progress / Completed only (drop “Active”) |
| Create nearby | `+ Task` in header; due date ties into calendar |

**Day (default)**  
Week strip for jump · agenda ordered by time · all-day at bottom  

**Week (same visual language as Day)**  
Scrollable agenda of the week · **day headers** (`Mon, 3 Aug`) · same time + card rows as Day  
Do **not** use rollup summary cards (“Mon · 3 tasks”) — that felt like a different product  

**Month**  
Month grid · dots on busy days · CTA into selected day agenda  

**Superseded by `77` (shipped):** each scope now has its own calendar body (Day 7-day strip + working-hours timeline · Week date strip + grouped agenda · Month grid + selected-day agenda), arrows move by day/week/month, the three stat cards and both chip carousels collapse into one compact count line + Filter sheet, and the “New from AM” banner becomes a `n new` badge plus per-task `NEW` pill.

**App bar vs FAB**
| Zone | Content |
|------|---------|
| Top left | Title `My work` + count |
| Top right | Filled `+` → Create task (`73` — page FAB removed) |
| Why header | One create control · doesn’t sit on the shell shield FAB |
| Don’t | Duplicate `+` in header **and** a page FAB |

---

## 3. Mobile screens

1. **My work** — date hero · Day/Week/Month panels · agenda / week rollup / month grid  
2. **Create task** — title, due date, optional link, notes → Save → My work  
3. **Task detail** — title, due, assignee source, link, status, complete  
4. Entry from Notifications / Policy “Create follow-up” → task detail or create  

---

## 4. Web screens (Tasks module)

**Board-first** (see `20-web-tasks-kanban-ux.md`) — Filllo-style columns, KBZ Coolors palette.

1. **Board** — columns Pending · In Progress · Completed (FR-07 statuses)  
2. **List** — dense table of the same tasks  
3. **Add / Move / Delete** — **dialog composer** · drag between columns · card/row delete  
4. Cards show type (Leave appointment / Servicing / e-App) · due · assignee · overdue accent  

Mobile stays calendar-first My work. Web stays status-board-first.

---

## 5. Acceptance

- [x] Calendar supports Day / Week / Month (mock)  
- [x] No Calendar \| To-Do toggle on mobile  
- [x] Create + complete from My work / task detail  
- [x] Status Pending / In Progress / Completed on detail  
- [x] Web Add / Move / Delete (Kanban board)  
- [x] Leave appointment task example present  
- [x] Notification entry point from Work / Notifs  
- [x] Web Board \| List views  
