# 76 — On-Boarding task type · Agent Info + Training Detail

**Source:** Stakeholder crops (Agent Info · Training Detail) · `Wireframe/Task Management.png` (Meeting form)  
**BRD:** §5.7 **FR-07** · `08` `21` `68`  
**Flutter today:** Create/edit form is **Meeting-shaped only** (`68`) · types = Meeting · Call · Leave appointment · Servicing · e-App · Other · **no On-Boarding body**  
**Date:** 2026-08-14

**Ask:** Two extra Task Management frames (On-Boarding). Brainstorm **everything** so they work with FR-07 — including UI the crops don’t label.

**Rule:** BRD wins *who may act and what a task is*. PNG wins *On-Boarding form layout* when that type is selected.

---

## 1. What the two frames are

Same shell as Meeting (`Task Management` · Task Information) but **Task Type = On-Boarding**. Body is **Task Detail** with two tabs.

### Shared header (this type)

```
← Task Management
Task Information
  Task ID *
  Task Name *          (PNG “Agent”)
  Task Type *          On-Boarding
  Priority *           High
  Status *             Open
  Start Date * · End Date *
```

### Tab · Agent Info

```
[ Agent Info ]  [ Training Detail ]
Structure Interview Score
Agent Name *
NRC | Passport
  NRC: state / township / type + number   (or Identification field)
Phone No.
State/Region
Full Address
Join Date
Upload · two image stubs
```

### Tab · Training Detail

Long required-looking dropdowns:

HO Assignment · Lead Source Type · Lead Source Detail  
Licensing Training · Mock Test  
Exam Result (1st / 2nd / 3rd Round)  
PD Training (UL) · PD Training (Non-Unit)  
Sales Process · Ethics and compliance · Underwriting · Claim  
Customer Care · Financial Planning · Concept Selling · Product Refresher  
Contract Type · Other Insurer · License Application  
License No. · Agent Code

Meeting PNG (already shipped `68`) stays for **other** types: Title · Description · no tabs.

---

## 2. BRD vs PNG

| Topic | PNG | BRD / existing docs | **Decision** |
|-------|-----|---------------------|--------------|
| What is this? | Full recruit / license checklist | FR-07 = **assigned daily tasks** · calendar · create/view/complete | **On-Boarding is a task type**, not a second Recruitment app. Pipeline Screening→Contracted stays **Audit / web** (`21`) |
| Who fills it? | Looks like HO/manager HR | Manager **Add/Move/Delete others** = **Web**. Mobile FA: **own** follow-ups | FA may **create/edit On-Boarding they own**. Don’t add delete-other-agents |
| Status **Open** | Dropdown Open | Pending · In Progress · Completed | **Open → Pending** (`68`) |
| Every field `*` | All required | Daily task must **save** without finishing 20 trainings | Header + **Agent Name** required. Training defaults **Not started**. SAVE always allowed |
| Task ID | Editable empty | IDs from system | **Read-only** (`T-00n` or `New`) |
| Task Name vs Title | Name | Meeting form uses Title | Same field. Label **Task Name** when On-Boarding, **Task Title** otherwise |
| COMPLETED CTA | Meeting frame | `68` SAVE / Mark completed | Same CTAs on On-Boarding. Never lone COMPLETED on create |
| NRC inline 3-drop | Yes | e-App Identification sheet (`62`) | **Reuse sheet** on Identification tap + NRC/Passport toggle. Inline 3-drop = P1 |
| Company / entity recruit | Not on these crops | Entity OOS | Don’t add |
| Description | Hidden on these crops | Meeting has it | Hide when type = On-Boarding |
| Calendar | Not on crops | FR-07 hub | Dates still drive **My work**. Seed one On-Boarding on the agenda |

**Pick:** One `TaskFormPage`. Type switch **swaps the body** (same idea as Get A Quote schemas). Do **not** fork `onboarding_task_page.dart` as a new app.

---

## 3. Type set (mobile)

`Meeting` · `Call` · `On-Boarding` · `Leave appointment` · `Servicing` · `e-App` · `Other`

`21` dropped **Recruitment** as a type name. **On-Boarding** is the PNG label for this checklist — keep that word, don’t revive Recruitment.

---

## 4. Extra UI (needed, not on the crops)

| Extra | Why |
|-------|-----|
| Type switch | Changing away from On-Boarding hides tabs; coming back keeps in-memory answers |
| Sticky **SAVE** | Crops are long; don’t lose the CTA (`68`) |
| **Mark completed** | BRD complete · not PNG COMPLETED-as-only-button |
| Training option set | PNG doesn’t show values → **Not started / In progress / Completed / N/A**; exams **Not taken / Pass / Fail** |
| Defaults | New On-Boarding: Task Name empty · trainings Not started · exams Not taken |
| My work filter chip | **On-Boarding** |
| Seed task | One mock on today’s agenda so the type is discoverable |
| Identification | Existing `showIdentificationPickerSheet` — don’t invent a second NRC kit |
| Upload | Same stub as Meeting (max 3) · Agent Info tab |
| Validation copy | “Agent name is required for On-Boarding.” |
| Web | Still kanban; this body is **mobile form**. Don’t block web |

---

## 5. Mock training / exam options

| Kind | Options |
|------|---------|
| Training / HO / license app | Not started · In progress · Completed · N/A |
| Exam rounds | Not taken · Pass · Fail |
| Lead source type | Referral · Walk-in · Campaign · Digital · Other |
| Contract type | Agency · Broker · Other |
| Other insurer | None · Yes |
| HO Assignment | Unassigned · HO Yangon · HO Mandalay |
| State/Region | Yangon · Mandalay · Naypyitaw · Other |

Prototype only — no Core license API.

---

## 6. What not to do

- Don’t build Screening→Contracted pipeline on mobile  
- Don’t let FA delete **other agents’** onboarding (web)  
- Don’t require all training `*` to SAVE  
- Don’t make Task ID a free-text primary key  
- Don’t replace Meeting form with this checklist for every type  
- Don’t use Recruitment as the type label (`21`)  
- Don’t add a real upload API or OCR for NRC on this form  
- Don’t use mockup red — cyan tabs/borders  

---

## 7. Flutter map

| Piece | Work |
|-------|------|
| `TaskType.onboarding` | Label **On-Boarding** |
| `OnboardingMock` on `TaskMock` | Agent + training map |
| `task_form_page` | Header variant + tabs when type is onboarding |
| `onboarding_detail_fields.dart` | Agent Info / Training widgets |
| My work filter | Include type |
| `TaskSession.create/upsert` | Persist onboarding payload |

---

## 8. Phasing

| Phase | Scope |
|-------|-------|
| **P0** | Type + header + Agent Info + Training dropdowns + SAVE · ID read-only · status BRD · seed + filter |
| **P1** | Inline NRC 3-drop · link to recruit record · notif “training updated” |
| **Out** | Full HR system · Core license sync · manager delete on mobile |

---

## 9. Acceptance (brainstorm)

- [x] Crops mapped vs Meeting PNG vs FR-07  
- [x] On-Boarding = task type, not Audit pipeline  
- [x] Required vs SAVE rules · status · CTA  
- [x] Extra UI listed  
- [x] Flutter P0  
- [x] Inventory updated  

---

## 10. Related

Crops · `Task Management.png` · FR-07 · `08` `21` `62` `68` `73`
