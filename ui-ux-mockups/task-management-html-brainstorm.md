# Task Management — HTML mobile UX brainstorm

**Canvas:** `task-management-html-brainstorm.canvas.tsx`  
**Source of truth:** Flutter `TaskBoardPage` · docs `08` `68` `77` · FR-07  
**Gap:** HTML prototype has Tools tile only — no My work screen yet.

---

## Principle
Mobile HTML = **calendar-first My work** (match Flutter).  
**Not** web Kanban Board|List (`docs/20`) on a 375px phone.

---

## Status (required)

| Status | Color | Role |
|---|---|---|
| **Pending** | Amber `#F59E0B` | Not started |
| **In Progress** | Sky / Steel | Active |
| **Completed** | Mint `#57C785` | Done |
| **Overdue** | Rose `#E11D48` | Flag (not a 4th stage) on open tasks past end |

Also on cards: **Priority** (H/M/L rail) · **Type** · **12h time range** · optional **NEW**.

---

## Views

| Scope | Body | Hourly detail |
|---|---|---|
| **Day** (default) | 7-day strip + hour timeline (≈08–18) | **Yes** — cards per start hour + status pill |
| **Week** | Strip + counts · agenda by day | Time on card, not hour gutter |
| **Month** | Grid + dots · selected-day agenda | Same as week agenda |

“List / board” on mobile = **agenda cards** under the calendar — not three Kanban columns. Geometric logo you shared = optional icon language only.

---

## HTML placement
- Open from **YOUR TOOLS → Task Management** (`after-login.html`)
- Implement as **`tasksView`** (same pattern as Profile) — ProtoType can’t add new HTML files easily
- Shell: My work · Create · Day|Week|Month · ‹ date › · Today · Filter · count

---

## Ship order
1. **P0** Day timeline + status pills + entry from Tools  
2. **P0** Week + Month + date nav  
3. **P1** Filter · Create stub · Overdue  
4. **P2** Optional List toggle · gallery

## Next
Say **go** (or **P0**) to implement in `after-login.html`.

## Status
**P0 shipped** in `after-login.html` — `tasksView` · Day timeline · Week · Month · Tools entry · Flutter mock tasks (Aug 14, 2026).
