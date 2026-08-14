# 68 — Task Management · BRD FR-07 + wireframe + UI/UX gaps

**Source:** `Wireframe/Task Management.png` (create/edit form)  
**BRD:** §5.7 **FR-07** — Calendar view · Day/Week/Month · Daily create/view/complete · Status Pending / In Progress / Completed · Manager Add/Move/Delete (**Web**) · assign/update notifications  
**Flutter today:** Thin **Task Board** list (static) · filters/summary not wired · `+` stub · **no** calendar · **no** create/edit form · **no** detail  
**Related:** `08` My work · `21` Leave appointment · `20` web kanban · `34` · Home `openTasks`  
**Date:** 2026-08-14

**Ask:** Wireframe alone is one form screen — likely **not enough** for FR-07. Brainstorm everything needed (BRD-first · PNG for form fidelity) so Tasks feels complete.

---

## 1. BRD jobs (must cover)

| BRD | Channel | Mobile UX job |
|-----|---------|----------------|
| **Task Management** | Mobile | Show **assigned** tasks in a **calendar** context |
| **Task Report** | Mobile | Switch **Day / Week / Month** |
| **Daily Task** | Mobile | **Create · view · complete** · link to related work (client / lead / e-App / policy follow-up) |
| **Task Status** | Mobile + Web | Update **Pending · In Progress · Completed** |
| **Add/Manage Task** | **Web** | Manager Add / Move / Delete (e.g. leave / onboarding) — **not** FA self-admin of others’ assignments |
| Notifs on assign/update | Mobile | FR-08 deep-link into task detail (`11` / inbox) |

Wireframe PNG covers **one slice**: create/edit **form fields**. It does **not** replace calendar My work.

---

## 2. Wireframe form (layout source)

```
← Task Management
Task Information
  Start Date * · End Date *
  Task Title *
  Task Type *          (Meeting …)
  Task Description *
  Priority *           (High …)
  Status *             (Open …)
Upload · thumbnails
[ COMPLETED ]
```

| Field | Keep? | Notes |
|-------|-------|-------|
| Start / End date | **Yes** | BRD calendar needs a date; prefer **Start = schedule · End = due** (or single Due if product later simplifies — P0 keep both to match PNG) |
| Title · Description | **Yes** | |
| Task Type | **Yes** | Align vocabulary with `21` + field types: **Meeting · Call · Leave appointment · Servicing · e-App · Other** (PNG “Meeting” stays) |
| Priority | **Yes** | High · Medium · Low |
| Status | **Yes** | Map PNG **Open** → BRD **Pending**; also **In Progress · Completed** |
| Upload | **Yes** | Stub attach (camera/gallery) · preview chips · no real upload API |
| COMPLETED button | **Clarify** (below) |

---

## 3. COMPLETED button — UX ambiguity

PNG primary CTA = **COMPLETED**. That can mean:

| Reading | Problem |
|---------|---------|
| A · Mark task completed | Wrong for **create** flow; destroys Save |
| B · Save / Submit form | Label mismatch with status field |
| C · Save **and** set status Completed | Surprising if Status dropdown still says Open |

**Decision:**

| Mode | Primary CTA | Secondary |
|------|-------------|-----------|
| **Create** | **SAVE** | Cancel / Back |
| **Edit / Detail** | **SAVE** | **Mark completed** (sets status Completed + optional confetti-free toast) |
| If status already Completed | Primary **SAVE** only · show Completed pill |

Never use a lone **COMPLETED** label as the only create CTA. Optional: if user sets Status = Completed then taps SAVE — same outcome as Mark completed.

---

## 4. What UI/UX must be **added** beyond the PNG

User instinct is right — BRD needs a **hub**, not only a form.

### A. My work (calendar hub) — from `08` + BRD

```
My work                    (count)
‹  14 Aug 2026  ›     [ Day | Week | Month ]

[ Soft “New assignment” strip if any ]

Agenda / week agenda / month grid
  time · title · type · priority rail · status pill

FAB +  → Create task (prefill start/end = selected day)
```

| Rule | Spec |
|------|------|
| No Calendar \| To-Do toggle | One hub (`08`) — BRD “Daily Task” lives **inside** the day list + create |
| Day/Week/Month | Changes body (not chrome-only) |
| Row tap | **Task detail / edit** (wireframe form in edit mode) |
| FAB / App bar `+` / Home “New Task” | Open **Create** form |
| Summary | Pending · In Progress · Overdue counts from **real mock list** |

### B. Task detail = wireframe form (read/edit)

- Same fields as PNG  
- Link field (optional P0): Client / Lead / Quote / e-App / Policy — “link them to specific tasks” (BRD Daily Task)  
- Attachments stub  
- Status control prominent  
- SAVE · Mark completed  

### C. Notifications bridge

- Assign / update → inbox item → deep-link **Task detail**  
- Home Task Management tile → **My work** (already `openTasks`)

### D. What stays Web-only

- Manager Add/Move/Delete of **other agents’** tasks  
- Kanban admin (`20`)  

Mobile FA may create **own** follow-ups; assigned-from-manager tasks are editable for **status / notes / complete**, not delete others’ assignments (soft rule).

---

## 5. BRD vs wireframe vs Flutter today

| Topic | Winner |
|-------|--------|
| Calendar D/W/M · My work hub | **BRD + `08`** |
| Form fields (dates · type · priority · upload) | **Task Management.png** |
| Status vocabulary | **BRD** Pending / In Progress / Completed (Open → Pending) |
| Task types | **`21` + Meeting/Call** (field-friendly) |
| Separate To-Do tab | **No** (`08`) |
| Flutter list-only board | **Replace / evolve** into My work + form |

---

## 6. Screen map (complete mobile FR-07)

| # | Screen | Source |
|---|--------|--------|
| 1 | **My work** | BRD calendar + `08` |
| 2 | **Create task** | PNG form · CTA **SAVE** |
| 3 | **Task detail / edit** | PNG form · SAVE · Mark completed |
| 4 | (Optional) Attachment viewer | Stub |

**Entry points:** Tasks tab / Home tile / FAB New Task / Notif deep-link / Policy or Customer “Create follow-up” (P1).

---

## 7. Mock data model (gaps to add)

| Field | Why |
|-------|-----|
| `id` · `title` · `description` | Form |
| `startAt` · `endAt` / due | Calendar + PNG |
| `type` · `priority` · `status` | Form + filters |
| `linkKind` · `linkId` · `linkLabel` | BRD “link them to specific tasks” |
| `attachmentCount` / stub URIs | Upload |
| `assignedBy` · `isNewAssignment` | Soft banner |
| `updatedAt` | Sort · notifs |

Filters on board must **actually filter** the list (today they don’t).

---

## 8. Form UX polish (length)

Form is tall (description + upload). Unlike Confirm e-App:

| Approach | Spec |
|----------|------|
| P0 | Single scrollable form · sticky SAVE — OK for task create |
| Density | Start/End **side-by-side** on wide phones optional |
| Description | 3–4 lines min, not half-screen empty |
| Upload | Compact row · max 3 stubs |

Don’t split create into many steps — one form is fine.

---

## 9. Flutter map (when building)

| Piece | Work |
|-------|------|
| `task` models | Rich `TaskMock` + session list |
| `TaskBoardPage` → **My work** | Date hero · D/W/M · agenda · wired filters · FAB |
| `task_form_page.dart` | Create/edit · PNG fields · SAVE / Mark completed |
| Routes | `taskForm` · optional `taskDetail` (or same page) |
| Home FAB / `+` | → create form |
| Docs | This file · tick `34` form parity |

---

## 10. Phasing

| Phase | Scope |
|-------|-------|
| **P0** | My work Day agenda + create/edit form (PNG fields) · status Pending/In Progress/Completed · SAVE / Mark completed · attach stub · wire filters · Home/FAB entry |
| **P1** | Week / Month panels · link to Client/Lead · notif deep-link · Overdue strip |
| **P2** | Real attachments · Core assign sync · manager web parity |

---

## 11. Acceptance

- [x] BRD FR-07 mapped beyond single form  
- [x] PNG form retained with SAVE vs COMPLETED clarified  
- [x] UI/UX additions listed (My work · detail · link · notifs)  
- [x] Status / type vocabulary locked  
- [x] Flutter My work + form (P0)  
- [x] Inventory updated  

**Shipped P0:** `task_mock_data.dart` · My work Day/Week/Month · create/edit form · SAVE / Mark completed · attach stub · FAB New Task → form · filters wired.  

---

## 12. Related

`Task Management.png` · BRD §5.7 · `08` · `21` · `20` · `34` · `TaskBoardPage` · On-Boarding body `76`  
