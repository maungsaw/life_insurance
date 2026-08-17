# 86 — Web admin view · mobile-referenced UX map

**Surface:** `agent-web-portal/` (React)  
**Reference:** Flutter Agent App (field) · BRD v2.3 · docs `10` `16` `17` `22` `23` `31` `71`  
**Web today:** Role hats · gated Management + Products · Audit (pending · Application List · queue · lookup) · auth CORE gates · profile/password · P1 Tasks/Announce/Notification/Resource polish (`86` shipped).  
**Date:** 2026-08-17

**Ask:** Mobile မှာ လုပ်ပြီးသားကို reference ထားပြီး **web = admin / HQ view** ကို flow တစ်ခုချင်း လိုအပ်သမျှ ပြည့်အောင် brainstorm။ Clone မဟုတ် — **counterpart**။

**Rule:** BRD wins *who acts on which surface*. Mobile wins field patterns. Web wins dense tables, filters, confirm dialogs, export. Frontend displays API numbers — do not invent FYP / weighting / persistency math.

---

## 0. Lock this first

| | **Mobile (Agent App)** | **Web (this portal)** |
|--|------------------------|------------------------|
| Who | FA · TL · field managers (`canSell`) | AM→HOA · FTE · **Super Admin / ops** |
| Job | Sell · CRM · quote · e-App · own KPIs · calendar | Oversight · **setup** · **control** · **audit** · export |
| Density | Thumb · cards · sheets | Sidebar · filters · tables · dialogs |

Web is **not** a second Agent App. If a mobile flow has no HQ job, **do not rebuild it** on web.

### Three portal *views* (one shell, role-gated)

BRD does not want ten dashboards (`71`). Web has **three hats**:

| View | Typical titles | Lands on | Sees |
|------|----------------|----------|------|
| **Manager** | DM / AADM / ADM (and coaches who open portal) | Dashboard → Overview **Manager View** | Own hierarchy · red flags · Tasks for their line · consume inbox |
| **FTE** | SADM · RADM · HOA · FTE exec | Overview **FTE Employees** | Full portfolio · K1/K2 · full export |
| **Admin** (this doc’s focus) | Super Admin · Ops · Security | **Management** (or quiet ops home) | Resource · Notification rules · Announcement · **Products On/Off** · Devices wipe · Audit / Application List |

Capability flags (same as `71`, session from Core later; prototype = header **role switch**):

| Flag | Web unlock |
|------|------------|
| `canViewDistrict` | Overview Manager View · scoped filters |
| `canViewPortfolio` | Overview FTE tab · full export |
| `canExport` | Export Excel |
| `canAdmin` | Management children + Audit write actions |
| `canWipe` | Devices remote wipe (subset of admin) |
| `canSell` | **Not a web job** — if an FA opens portal → “Use the Agent App” or own KPI slice only |

**Do not** show Super Admin an MDRT war-room as the default home.

---

## 1. Master map — every mobile flow → web admin job

| # | Mobile flow (shipped / spec’d) | Web admin counterpart | Today in portal | Need |
|---|-------------------------------|------------------------|-----------------|------|
| A | Login · OTP · Forgot (`07` `43` `45`) | Same identity · no biometric · no guest | Pages exist, no CORE gate / remark parity | **P0** honesty + Application List handoff |
| B | Role Home (`71`) | Role-gated nav + landing | Auth = boolean only · everyone sees Overview | **P0** demo role + Admin landing |
| C | Home KPIs / commission card (`46` `80` `85`) | Overview KPIs (API) · **not** personal History/Report | Manager\|FTE Overview | Keep; Admin skips KPI home |
| D | Team hub (`32` `72`) | Team Performance + Overview tables | Shipped (`18` `30` `31`) | P1 polish (empty, persistency copy) |
| E | Leads \| Clients CRM (`51` `79`) | **None in nav** (`16`) | Redirects to Overview | Keep out. P2 lookup only if UAT |
| F | Policy list/detail (`66`) | **None in nav** · no policy edit | Redirects | Keep out. P2 support search |
| G | Catalog · Quote · e-App · Renew (`59` `65` `81`) | **Products On/Off** · correction **tasks** · optional Application queue | Products **hidden** · e-App type on Tasks | **P0 restore Products** · P1 app queue |
| H | Guest calculator (`75`) | None | — | Never on web |
| I | My work calendar (`68` `77`) | Tasks **board** Add/Move/Delete (`20`) | Board + list shipped | P1 On-Boarding type (`76`) |
| J | Bell inbox (`49`) | Header bell = **consume** (same types, HQ copy) | `/notifications` | Keep; deep links already (`16`) |
| K | Announcement **feed** (read-only) | Announcement **setup** FR-09 | Shipped | P1 schedule / unpublish |
| L | Notification **toggles** (profile) | Notification **rules** FR-08 | Shipped | P1 preview “who gets this” |
| M | Resources **download** | Resource **library config** FR-10 | Shipped (`33` offline col hidden) | P1 publish / archive confirm |
| N | Product control (authorized mobile) | Management → **Products** (`23`) | Page exists, **nav commented out** | **P0 restore** |
| O | Profile · password · FAQ · biometric (`50` `70`) | Header menu · change password · ENG/MM · **no biometric** | Placeholder Profile / Language | P1 real profile + password |
| P | Register pending (`45`) | **Application List** (HQ) | Missing as named job | **P0** under Audit |
| Q | Device (NFR wipe receive) | Devices registry + wipe (`19`) | Shipped | Keep; confirm copy P1 |
| R | — | Audit log FR-12 (approved vs pending) | Directory + log, **no pending-change queue** | **P0** pending tab |
| S | Dark theme (`82`) | Not required for HQ desk | Light Coolors | P2 |
| T | Commission History/Report (`80` `85`) | KPI + export only · **no payout** | Commission in Overview metrics | Do not clone History/Report |

---

## 2. Flow-by-flow (admin UX)

Each block: **mobile job** · **web admin job** · **screens** · **must have** · **must not**.

### A · Auth (FR-01)

**Mobile:** Splash → mobile+password → OTP → optional biometric → Home. Forgot = OTP + **mandatory remark**. Register = CORE gate; pending = Application List, not Home.

**Web admin:** Same mental model, desk chrome.

```
/login  →  /otp  →  role landing
/forgot → OTP + remark * → new password → /login
```

| Must have | Must not |
|-----------|----------|
| Same labels · “Same account as the Agent App” | Biometric enroll |
| CORE unknown → stop + “Handled on Application List” | Public self-register form |
| Forgot **remark** field (parity with `41` `42`) | Guest calculator after login fail |
| Session timeout language | Pixel-clone of mobile splash |

**Today:** Login/OTP/Forgot mock through. No remark, no CORE fail state, no role after OTP.

**Screens:** Login · OTP · Forgot (remark + new password) · error toasts · pending-application message (read-only: “Your request is in Application List”).

---

### B · Session, role, landing

**Mobile:** Preview role on Home (`71`).

**Web admin:** After OTP, **landing depends on hat**.

| Hat | Default route | Sidebar |
|-----|---------------|---------|
| Manager | `/dashboard/overview` (Manager tab) | Dashboard · Tasks · bell · **no** Management write (or read-only) |
| FTE | `/dashboard/overview` (FTE tab) | Same + full filters + Export Full |
| Admin | `/management/resources` **or** `/audit` | Management ▾ + Audit + Devices; Dashboard **optional** (collapsed) |

Prototype: header **View as** `Manager · FTE · Admin` (like mobile role chip). Session stores `canAdmin` / `canWipe`.

**Must not:** Hide Overview from a DM who also sells; hide Management from Super Admin; let FA `canSell` land on wipe.

---

### C · Shell (sidebar + header)

**Keep lean IA (`16`):**

```
Dashboard ▾          Manager / FTE
  Overview
  Team Performance
Tasks                All hats who coach or ops
Management ▾         Admin (canAdmin)
  Resource
  Notification
  Announcement
  Products           ← restore (P0)
  Devices            canWipe
Audit                Admin · FR-12 + Application List
```

Header (`14`): logo · **role chip** · bell · profile menu (Profile · Language ENG/MM · Change password · Sign out danger).

**Must not:** Bring back CRM / Policies / Recruit / Ops as top-level (already trimmed). Don’t rename Devices back to “Remote Wipe” as the folder (`19`).

---

### D · Dashboard Overview (FR-02.4)

**Mobile:** Light personal KPIs + Team pulse.

**Web:** Dense BI — **not** an admin config screen.

| Tab (`31`) | Admin relevance |
|------------|-----------------|
| Manager View | District proposals · FA table · red flags · Export |
| FTE Employees | Portfolio · K1/K2 · underperformers · Export Full |

**Admin hat:** Do **not** force this as home. If they open it, read-only same charts (portfolio or “ops has no book” empty: “No production slice — switch to Management”).

Must: hierarchy filters · Freelance/Internal weighting toggle (`09`) · API-honesty footnote · red-flag chip → Team Performance filtered.  
Must not: invent weighting; clone mobile commission bars (`85`); payout.

---

### E · Team Performance

**Mobile:** Team Sales Performance 6-up · FA card · MDRT (`72`).

**Web:** FA production table · drill · export (`18`). Same Core metrics, desk density.

Must: click FA → side panel or row expand (code · district · MDRT · flags) — **not** that FA’s CRM book.  
Must not: Start e-App from this table.

---

### F · CRM (FR-03) — explicitly **not** admin nav

**Mobile:** Leads vs Clients hard split · convert on policy insurance.

**Web:** Field book stays on the phone (`16`). Dashboard already shows new policies / APE.

**P2 (only if UAT):** “Book lookup” under Audit or a utility: search client/policy **read-only** for HQ support — no convert, no edit KYC, no Start e-App.

---

### G · Policies (FR-06) — not admin edit

**Mobile:** List · chart · detail · Renew / Start e-App.

**Web:** No policy admin (`34` §3.2). P2 read-only search same as F.

Must not: edit issued fields · claims · group/entity · payout.

---

### H · Sell spine (FR-04 / FR-05) vs Product control

Two jobs (`23`) — **do not mix**.

| Job | Surface |
|-----|---------|
| **A · Sell** | Mobile catalog · quote · e-App · renew |
| **B · Control** | **Web Management → Products** (+ authorized mobile Product control) |

**Admin flow (P0 restore nav):**

```
Products table
  filters: All | On | Off · search code/name
  row: code · name · category · On/Off switch · last change
Turn Off → dialog: impact copy · reason * · Confirm
Turn On → toast
History: who / when / reason
```

Same catalog state as mobile Sell (Off disappears for FA after sync).

**Must not:** Quote calculator, compare, NRC, wizard, or “Start e-App” on this page.

**e-App HQ (P1, not the wizard):**

- Tasks type **e-App** / **Mark for Correction** (already in inbox → `/tasks`)
- Optional **Applications** table under Audit: status · owner FA · policy ref · “Open task” — **not** a second stepper

---

### I · Guest / before-login quote

**Mobile only** (`75`). Web login is for HQ. **No guest mode on portal.**

---

### J · Tasks (FR-07)

**Mobile:** Calendar Day/Week/Month · create/edit · complete.

**Web admin:** **Board-first** Add / Move / Delete (`20`). Same 3 statuses. Leave appointment is a **type**, not a module (`16`).

```
Tasks
  filters: assignee · type · overdue
  Board | List
  + Add → dialog
  Drag = Move
  Delete → confirm
```

**P1:** Task type **On-Boarding** with Agent Info + Training Detail (`76`) — HQ creates, FA executes on mobile.

**Must not:** Clone the mobile calendar as the default web view.

---

### K · Inbox (consume) vs Notification **setup** (FR-08)

Do not merge these (`22`).

| | Mobile | Web |
|--|--------|-----|
| **Inbox** | Bell list · deep link | Header bell → `/notifications` (HQ wording) |
| **Setup** | Profile toggles only | Management → Notification **rules** |

**Admin setup flow:**

```
Rule list (enabled switch)
+ Add rule → trigger preset (premium / renewal / task / e-App)
  lead time · audience (hierarchy) · enabled
Preview: “FAs in Yangon A get this 7 days before due”
```

Must not: put image+URL composer here (that is FR-09).

---

### L · Announcements (FR-09 setup / FR-10 feed)

**Mobile:** Read-only feed (+ optional push card).

**Web admin:** Compose.

```
Create: title * · image * · URL * · body · audience · Also send as push
List: live / scheduled / unpublished
Unpublish → confirm (feed card disappears on next sync)
```

Must not: let FAs compose from mobile.

---

### M · Resources (FR-10)

**Mobile:** Browse / download · offline honesty.

**Web admin:** Sections + documents.

```
Sections: name · visible to FA · default offline policy (hidden col until `33` ships)
Docs: title · file · version · status (live/draft/archived) · updated
Publish / archive confirms
```

Must not: invent a second “training LMS”.

---

### N · Devices (NFR §6)

**Mobile:** Register device · receive wipe · clear local · ack · logout.

**Web admin:** Find agent → devices → wipe (`19`).

```
Search agent / device id
Row: agent · device · OS · build · last seen · status
Wipe → reason * (loss/theft/compromise/deactivation) · type-to-confirm agent code
Wipe log: pending / acked / failed
```

Must not: live under Audit; must not look like a factory reset of the phone OS (copy = **app data wipe**).

---

### O · Audit + Application List (FR-12 + FR-01)

**Mobile:** Agent cannot freely change approved identity; pending goes to HQ. Register-not-in-CORE never opens Home (`45`).

**Web admin (P0 complete this page):**

```
Audit
  [ Directory ]  [ Pending changes ]  [ Application List ]  [ Log ]
```

| Tab | Job |
|-----|-----|
| **Directory** | Approved agent data (code · name · role · mobile · status · district) |
| **Pending changes** | Requested field · previous · new · requester · Approve / Reject |
| **Application List** | CORE-unknown / invite / pending register · status · assign district |
| **Log** | Action · previous · new · user · timestamp (immutable) |

Must: Approved vs Pending visually split (`06`).  
Must not: mix wipe history here (Devices has its own log).

---

### P · Profile / language / password

**Mobile:** Full settings hub + biometric (`50` `70`).

**Web:** Header menu is enough.

| Item | Web |
|------|-----|
| Profile | Name · role · mobile · district (read) |
| Language | ENG / MM labels (BRD) |
| Change password | OTP + new password (same rules as mobile) |
| FAQ | Optional link |
| Biometric | **None** |
| Notification toggles | Optional; rules still live in Management |

---

### Q · Commission

**Mobile:** Display-only History + Report (`80` `85`) · no withdraw.

**Web:** Overview **Commission KPI** (product commission + UL note from `09`). Export with performance workbook.

Must not: wallet, payout, personal bar-chart clone, “vs last month” density switch on HQ.

---

### R · Recruitment

**Was** a sidebar module; **now** Tasks (Leave appointment / On-Boarding) + Audit statuses (`16`). Do not resurrect a fourth kanban of hiring stages unless BRD reopens it.

---

### S · Export

First-class on Overview and Team Performance (`06` `30`). Admin may export directory / wipe log / product-change history as **separate** buttons on those pages — not one global dump.

Format: Excel. Dates `DD-MMM-YYYY`. Money 2 decimals + commas.

---

### T · Visual / i18n / dark

| Topic | Web admin |
|-------|-----------|
| Palette | Coolors blues already (`13` `29`) |
| Dark | P2 — HQ is light desk; don’t block on `82` |
| ENG + MM | Header toggle; every **new** screen ships both labels |
| Empty / loading | Skeleton tables; “No rows in this filter” |
| Destructive | Dialog + primary danger · never toast-only for wipe / reject / turn off |

---

## 3. Suggested ship order (when you say ဟုတ်ကဲ့)

Do **not** implement this whole map in one pass. Natural slices:

| Slice | Flows | Why first |
|-------|-------|-----------|
| **P0a** | B · C · H Products restore | Admin hat + missing control panel |
| **P0b** | A auth honesty · O Application List + Pending | FR-01 / FR-12 actually look like HQ |
| **P1** | J On-Boarding · K rule preview · L unpublish · P profile/password | Depth on screens that exist |
| **P1** | H Applications queue (read-only) | Support without cloning e-App |
| **P2** | F/G lookup · S dark · D empty states | Only if UAT asks |

Each slice = its own later brainstorm tick **or** a thin implement pass against this doc.

---

## 4. What not to do

- Clone mobile Home, pill nav, guest quote, biometric, calendar-first My work, e-App stepper, Compare, NRC sheet, commission History/Report, Dark-first portal  
- Full policy admin · claims · group/entity · commission **payment**  
- Put CRM / Policies back in the sidebar without a new BRD decision  
- Merge Notification setup with Announcement composer  
- Let Super Admin’s default home be MDRT  
- Invent Core math  

---

## 5. Acceptance

- [x] Web ≠ mobile clone; three hats (Manager · FTE · Admin)  
- [x] Every major mobile flow mapped to a web job or explicit **none**  
- [x] Flow-by-flow screens + must / must-not  
- [x] P0 / P1 implemented in `agent-web-portal`  
- [x] P2 polish shipped (empty states · FA drill · destructive dialogs · persistency copy) — **dark deferred** (HQ light desk)  
- [x] Inventory  
- [x] **Shipped** — `portalRole.ts` · `RequireCap` · header View as · Products nav · Audit tabs · lookup · On-Boarding tasks · announce unpublish · notif preview · resource publish/archive · P2 empty/FA/sign-out/export dialogs  

### Flutter map (reference only — web code)

| Piece | Path |
|-------|------|
| Hats + caps | `src/auth/portalRole.ts` |
| Session | `src/auth/AuthContext.tsx` |
| Route gates | `src/auth/RequireCap.tsx` |
| Shell | `src/layout/AppShell.tsx` · `HeaderActions.tsx` |
| Audit HQ | `src/pages/AuditPage.tsx` |
| Profile | `src/pages/ProfilePage.tsx` · `ChangePasswordPage.tsx` |
