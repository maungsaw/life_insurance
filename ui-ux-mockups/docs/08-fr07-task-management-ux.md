# FR-07 Task Management UX (Mobile + Web)

**BRD §5.7**

| Requirement | Channel | UX |
|-------------|---------|-----|
| Assigned tasks in **calendar** | Mobile (+ view on portal) | Day / Week / Month |
| Notifications on assign/update | Mobile | Push + in-app Work badge |
| Create / view / complete tasks | Mobile | On calendar hub · linked to client/lead/recruit |
| Managers **Add / Move / Delete** | Web | Task admin + recruitment example |
| Status: Pending · In Progress · Completed | Mobile + Web | Explicit status control |
| Recruitment onboarding tracking | Web (+ mobile view) | Task linked to candidate status |

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

**App bar vs FAB**
| Zone | Content |
|------|---------|
| Top left | Title `My work` + count only — no create button |
| FAB | Round `+` sticky bottom-right above tab bar → Create task |
| Why FAB | Primary create action stays reachable while scrolling agenda; header stays calm/readable |
| A11y | `aria-label="Create task"` · visible label for screen readers |
| Don’t | Duplicate `+ Task` in header and FAB |

---

## 3. Mobile screens

1. **My work** — date hero · Day/Week/Month panels · agenda / week rollup / month grid  
2. **Create task** — title, due date, optional link, notes → Save → My work  
3. **Task detail** — title, due, assignee source, link, status, complete  
4. Entry from Notifications / Policy “Create follow-up” → task detail or create  

---

## 4. Web screens (Tasks module)

1. Task table: title, assignee FA, type, status, due  
2. **Add / Move / Delete** (manager)  
3. Recruitment board linkage  
4. Status visibility for managers  

Web keeps list/admin density; mobile stays date-first. No need for a mobile To-Do clone of the web table.

---

## 5. Acceptance

- [x] Calendar supports Day / Week / Month (mock)  
- [x] No Calendar \| To-Do toggle on mobile  
- [x] Create + complete from My work / task detail  
- [ ] Status Pending / In Progress / Completed on detail  
- [ ] Web Add / Move / Delete  
- [ ] Recruitment task example present  
- [ ] Notification entry point from Work / Notifs  
