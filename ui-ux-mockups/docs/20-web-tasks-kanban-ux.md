# Web Task Management — Board UX (FR-07)

## 1. BRD jobs (§5.7)

| Requirement | Platform | UX implication |
|-------------|----------|----------------|
| View assigned tasks | Mobile + Web | Managers need portfolio of team tasks |
| Calendar Day/Week/Month | **Mobile** | Stay on mobile My work — don’t clone calendar on web |
| Add / Move / Delete | **Web** | Primary web job |
| Status: Pending · In Progress · Completed | Mobile + Web | Same three statuses everywhere |
| Leave appointment track | Web | Task **type** = Leave appointment (not a separate module) |

Reference mood (Filllo-style board): column board · typed cards · clear status lanes · assign members · Board/List views.  
**Not** copying their purple theme — keep KBZ Coolors blues.

---

## 2. Decision

| Choice | Why |
|--------|-----|
| **Board-first on web** | Move = drag (or column action) matches manager mental model better than table-only |
| Columns = **Pending · In Progress · Completed** | Exact FR-07 statuses — no invented “Need Review” lane |
| **Board \| List** toggle | Board for flow; List for dense filter/export-style scan |
| Card shows type · due · assignee | Leave appointment vs Servicing vs e-App readable at a glance |
| **Add / Edit = centered dialog** | Side panel squeezed the board and felt cluttered — modal keeps Board full-width |
| Overdue = card accent, not new column | Status stays BRD-pure; urgency is visual |

```
Web Tasks
├── Header: title · filters · + Add task · Board | List
├── Board view
│   ├── Pending
│   ├── In Progress
│   └── Completed
└── List view (table) — same data
```

Mobile stays calendar-first (`08-fr07-task-management-ux.md`). Web stays **status-board-first**.

---

## 3. Card anatomy

```
┌─────────────────────────┐
│ Leave appointment · Su Su│
│ [Leave appointment] [Overdue]│
│ Due 06-Aug · Aye Chan   │
│ ⋮ Move · Delete         │
└─────────────────────────┘
```

| Element | Rule |
|---------|------|
| Title | One line, bold |
| Type chip | Leave appointment · Servicing · e-App · Other |
| Overdue | Only if due &lt; today and status ≠ Completed |
| Due | DD-MMM-YYYY |
| Assignee | Name (initial avatar optional) |
| Drag | Between columns = **Move** + status update |

---

## 4. Manager actions (FR-07)

| Action | Board | List |
|--------|-------|------|
| **Add** | `+ Add task` → **centered dialog** (title · assignee · type · due · notes) · lands in chosen column | Same dialog |
| **Move** | Drag card to another column · or card menu Move to… | Status select / bulk |
| **Delete** | Card ✕ → confirm · or Delete in edit dialog | Row action → confirm |
| Status update | Implied by column | Explicit status cell |

### Composer UX (dialog)

| Rule | Why |
|------|-----|
| Modal over board (not right rail) | Board stays 3 equal columns; form doesn’t compete for width |
| Backdrop + Esc / Cancel close | Clear dismiss; focus stays on create job |
| Footer: Cancel · (Delete if edit) · Create/Save | Actions grouped, primary on the right |
| 2-column field grid (assignee/type · due/status) | Shorter dialog; less scroll |
| Title autofocus | Fast keyboard create |

---

## 5. Filters

Shared across Board + List:

- Search title / assignee  
- Type (All · Leave appointment · Servicing · e-App · Other)  
- Assignee (All · FA names)  

Hierarchy note: DM sees team assignees; mock = all sample FAs.

---

## 6. Empty / honesty

| State | Treatment |
|-------|-----------|
| Empty column | Soft “No tasks” + `+ Add` in column footer |
| Delete confirm | “Delete task permanently?” |
| Drag while form open | Allowed; form stays for create |

---

## 7. Acceptance

- [x] Brainstorm documented  
- [x] Web Tasks = Kanban Board (Pending / In Progress / Completed)  
- [x] Board \| List toggle  
- [x] Add / Move (drag) / Delete  
- [x] Leave appointment example cards  
- [x] Coolors palette (not reference purple)  

---

## 8. Out of scope

- Real-time multi-user board sync  
- Timeline / Gantt view from reference  
- Mobile calendar redesign (already done)
