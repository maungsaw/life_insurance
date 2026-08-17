# 87 — Web HQ · CRM · e-App list · User management (roles)

**Surface:** `agent-web-portal/`  
**Reference:** Flutter CRM (`51` `79`) · e-App tracker (`26` `81`) · hats (`71` `86`) · FR-03 / FR-05 / FR-12 / §4.2  
**Web today:** CRM list + record · e-Apps queue · Users People + Roles matrix. Audit keeps FR-01 Application List (not the policy queue). Hats = Manager · FTE · Admin.  
**Date:** 2026-08-17

**Ask:** Web မှာ **Customer list** · **CRM** · **e-Application list** · **User management** (ထဲမှာ **Role & permission**) ထည့်မယ်။ သက်ဆိုင်ရာတွေနဲ့ ချိတ်ပြီး လိုအပ်သမျှ ပြည့်အောင် brainstorm။

**Rule:** ဒါက `16` “CRM stays on mobile” ကို **HQ job အသစ်** အဖြစ် ပြန်ဖွင့်တာ။ Mobile ကို clone မဟုတ် — desk tables · owner FA · filters · read-first. Sell wizard / NRC / quote calculator / Start e-App **web မလုပ်ဘူး** (`86`).

---

## 0. Four modules, not five bags

| User said | One module? | Why |
|-----------|-------------|-----|
| Customer list | **CRM → list** | List is the landing of CRM, not a second app |
| CRM | **CRM** | Leads \| Clients · detail · activity · owner FA |
| e-Application list | **e-Apps** | Policy applications (FR-05) — **not** agent register |
| User management + Role & permission | **Users** | People who sign in · roles · permission matrix **inside Users** |

Do **not** put Customer list, CRM, and “Clients” as three sidebar items.

```
Sidebar (proposed)
Dashboard ▾
Tasks
CRM ▾                         ← new (was redirect)
  Customers                   ← list (Leads | Clients)
  (detail is a route, not nav)
e-Apps                        ← new (policy applications)
Management ▾                  ← existing HQ setup
Users ▾                       ← new
  People
  Roles & permissions
Audit                         ← keep FR-12 / agent Application List / log
```

**Why CRM is a group, Users is a group, Audit stays:**

| Module | Object | Job |
|--------|--------|-----|
| **CRM** | Lead / Client (customer) | Book of business · support · coach the FA |
| **e-Apps** | Application (policy) | Pipeline of submissions · correction · UW status |
| **Users** | Portal / app **login identity** | Enable, disable, assign role, permissions |
| **Audit** | Change trail + **agent Application List** (FR-01) | Who changed what · pending identity · CORE-unknown register |

Same human can appear in Users **and** Audit directory. Different screens, linked by agent code.

---

## 1. Naming lock (easy to mix up)

| Label | Means | Lives |
|-------|--------|-------|
| **Customers** | Leads + Clients lists | CRM |
| **Lead** | Prospect, **zero** issued policy (`79`) | CRM · Leads tab |
| **Client** | Policyholder (`79`) | CRM · Clients tab |
| **e-App / Applications** | FR-05 quote→submit→UW | **e-Apps** module |
| **Application List** | FR-01 agent not-in-CORE / pending invite (`45`) | **Audit** (keep). Never merge with e-Apps |
| **Directory** | Approved agent master (`86`) | Audit |
| **People** | Who can log in (app + portal) | Users |
| **Role** | FA · TL · AM · … · Super Admin (`71`) | Users → Roles |
| **Permission** | `canSell` · `canAdmin` · `canWipe` · … | Bound to a **role**, not painted per screen ad-hoc |

Inbox / Tasks “Open task” for correction still jumps to **Tasks**. e-Apps row can **also** deep-link that task.

---

## 2. Who sees what (hats × modules)

Reuse `86` hats. Add two caps (don’t invent ten dashboards).

| Cap | Unlocks |
|-----|---------|
| `canViewBook` | CRM list/detail in **own hierarchy** (Manager) or **portfolio** (FTE) |
| `canViewAllBooks` | HQ search across districts (Admin + FTE) |
| `canManageUsers` | Users · Roles (Admin only) |
| existing `canAdmin` | Management setup |
| existing `canWipe` | Devices |

| Hat | CRM | e-Apps | Users / Roles | Audit |
|-----|-----|--------|---------------|-------|
| **Manager** | Own line · read + notes · **no** convert-by-hand | Own line · open correction **task** | Hidden | Hidden |
| **FTE** | Portfolio · export | Portfolio · export | Hidden | Read log optional P2 |
| **Admin** | All books · support lookup (same CRM, wider filter) | All apps · no wizard | **Full** | Full (already) |

**Must not:** FA `canSell` lands on Users. Manager edits Roles. Admin’s default home stays Management (`86`), not CRM war-room.

---

## 3. Flow A · CRM / Customer list (FR-03 HQ)

### Mobile job (reference)

Leads \| Clients tabs · search · filter · detail · convert on **policy insurance** (`79`). Quote / e-App / Renew stay on the phone.

### Web HQ job

Portfolio **oversight + support**. Coach sees the FA’s book without selling from the desk.

```
/crm/customers?tab=clients|leads
  → /crm/customers/:id          record
       ├─ Overview (contact · owner FA · stage)
       ├─ Policies (read-only accordion)     [Clients]
       ├─ Quotes / e-Apps (links)            [both]
       ├─ Activity / notes
       └─ Tasks (create servicing task)
```

### 3.1 Customer list (landing)

Same chrome as mobile list, **desk density**:

| | Leads tab | Clients tab |
|--|-----------|-------------|
| Row | Name · phone · stage · **owner FA** · district · last activity | Name · phone · policy status · owner FA · due badge |
| Search | Name / phone / NRC last 6 / FA code | + POL- ref |
| Filters | Stage · district · FA · product interest | Status (Active/Pending/Expired) · product line · district · FA |
| Empty | “No leads in this slice” | “No clients in this slice” |
| Export | Excel (FTE/Admin) | Excel |

**Hard split:** a person is **never** on both tabs (`79`). Convert is **not** a web button that invents a policy.

### 3.2 Record (CRM detail)

| Block | HQ can | HQ cannot |
|-------|--------|-----------|
| Contact | Read · request change → Audit **Pending** (same as agent identity) | Silent overwrite of CORE KYC |
| Owner FA | Read · **reassign** (Admin/FTE) with confirm + reason | Steal book without audit row |
| Notes | Add HQ note (visible to owner FA on next sync) | Delete FA’s field notes |
| Policies | Open read-only policy sheet (`66` fields) | Edit issued policy · claims · payout |
| Quotes / e-Apps | Jump to **e-Apps** row | Start e-App / Get a quote / Compare |
| Convert | Show **history** (“Converted 14-Aug · POL-…”) | Manual “Make client” without Core policy |

**Reassign FA (HQ-only):** dialog · new FA in hierarchy · reason * · writes Audit log.

### 3.3 Why this is not the old `/crm` redirect

`16` dropped CRM because it cloned the **sell spine**. This CRM has a **different job**: filter by **owner FA**, reassign, notes, export, jump to e-Apps/Tasks. No calculator.

---

## 4. Flow B · e-Application list (FR-05 HQ)

### Mobile job

Wizard + tracker: Draft · Submitted · Mark for Correction · Approved · Rejected (`26`). Renew / Start e-App on device (`81`).

### Web HQ job

**Queue of applications** — read status, chase correction, never fill the form.

```
/eapps
  filters: status · FA · product · district · period
  row: APP-ref · client/lead · product · FA · status · age · POL- if any
  → /eapps/:id  read-only dossier
       timeline · correction reason · Open task · Open CRM record
```

### Status UX (same labels as mobile)

| Status | HQ action |
|--------|-----------|
| Draft | See owner FA · **do not** edit wizard |
| Submitted | Ageing · “waiting UW” |
| Mark for Correction | Primary CTA **Open task** (existing Tasks type e-App) |
| Approved | Link to Client + policy (CRM) |
| Rejected | Reason (Core) · read-only |

**Optional later:** Applications **board** (columns = statuses). P0 = **table**. Board is P1 if UAT wants Kanban (don’t duplicate Tasks board).

### Split from Audit tabs (`86`)

| Today under Audit | After this pack |
|-------------------|-----------------|
| **Applications** (e-App queue) | **Move** to `/eapps` — canonical list |
| **Lookup** | Fold into CRM search (or keep Audit lookup as alias → CRM) |
| **Application List** | **Stay** in Audit (agent register FR-01) |

Rename Audit tab copy: `Application List` subtitle = “Agent register / CORE invite” so nobody confuses it with e-Apps.

---

## 5. Flow C · User management (inside: Roles & permissions)

### 5.1 Two screens, one group

```
Users ▾
  People              /users
  Roles & permissions /users/roles
```

People **without** a Roles child makes HQ invent per-user checkboxes (unmaintainable). Roles **without** People is a PDF.

### 5.2 People list

| Column | Notes |
|--------|--------|
| Code | AGT-… / HQ-… |
| Name · mobile | Same identity as login (`07`) |
| Channel | App · Portal · Both |
| Role | One primary role (BRD dynamic — not ten Homes) |
| Status | Active · Disabled · Pending invite |
| District / line | Hierarchy slice |
| Last login | Device count → link **Devices** if `canWipe` |

**Actions (Admin):** Invite (only if CORE-active) · Disable · Reset to Application List · Change role · Open Audit directory.

**Invite vs Application List:** If mobile not in CORE → **cannot** invite here; row belongs on Audit Application List (`45`). Users.People only lists **activated** (and Disabled) identities.

### 5.3 Person detail

```
Identity (read from CORE)
Role *          [select]
Portal access   Manager | FTE | Admin hat  ← maps to 86 prototype hats
App access      on/off (canSell)
Status          Active / Disabled
[ Save ]        → Audit log (previous role → new role)
```

Disable confirm: “App + portal sessions end on next check. Devices not wiped unless you go to Devices.”

### 5.4 Roles & permissions

**Do not** ship 11 unique dashboards. Ship **roles as named packs of caps** (`71` clusters).

| Role (BRD titles) | Cluster | Typical caps |
|-------------------|---------|--------------|
| FA | Producer | `canSell` `canViewOwnKpis` |
| Team Lead / AM / SAM | Coach | + `canViewTeam` `canViewBook` (line) |
| DM / AADM / ADM | District | + `canViewDistrict` `canExport` |
| SADM / RADM / HOA | FTE | + `canViewPortfolio` `canViewAllBooks` |
| Super Admin / Ops | Admin | `canAdmin` `canManageUsers` `canWipe` — **no** `canSell` required |

**Permissions matrix UI** (Roles tab):

```
              Sell  Own KPI  Team  District  Portfolio  Export  CRM book  e-Apps  Tasks admin  Mgmt  Users  Wipe
FA             ●      ●
TL             ●      ●      ●                         ●
DM             ●      ●      ●      ●          ·        ●       ●         ●
HOA / FTE      ·      ·      ●      ●          ●        ●       ●         ●
Super Admin    ·      ·      ·      ●          ●        ●       ●         ●        ●           ●     ●      ●
```

Prototype: matrix is **read + toggle on a copy of the pack** with “Reset to BRD defaults”. Custom per-user permission overrides = **P2** (prefer role change).

**Must:** Changing a role updates **next session** menus (`71` dynamism). Header **View as** stays a **demo** switcher; production uses this screen.

**Must not:** Let Roles toggle invent `canPayout` or policy-edit. Don’t put biometric on web users.

---

## 6. Cross-links (everything “related”)

```
CRM customer ──owner──► Users person (FA)
         └──e-Apps──► e-App row ──correction──► Tasks
Users person ──► Audit directory (same code)
         └──► Devices (wipe)
e-App Approved ──► CRM Client + policy (read)
Login CORE fail ──► Audit Application List (not Users, not e-Apps)
Product Off ──► mobile catalog; e-Apps in-flight still listed
```

Notification deep links (`16` update):

| Type | Goes to |
|------|---------|
| Task | `/tasks` |
| App correction | `/eapps/:id` **and** task |
| Premium due | CRM client (policy due) **or** Overview |
| News | Announcement setup (Admin) / inbox consume |
| Role change | Users person |

---

## 7. Screen inventory (this pack)

| Route | Screen | P0 |
|-------|--------|----|
| `/crm/customers` | Leads \| Clients table | Yes · shipped |
| `/crm/customers/:id` | Record · tabs | Yes · shipped |
| `/crm/customers/:id/reassign` | Dialog (not a page) | Yes · shipped |
| `/eapps` | Application table + status chips | Yes · shipped |
| `/eapps/:id` | Read-only dossier + timeline | Yes · shipped |
| `/users` | People table | Yes · shipped |
| `/users/:id` | Person · role · access | Yes · shipped |
| `/users/roles` | Matrix | Yes · shipped |
| Audit Application List | Keep; rename helper text | Yes · shipped |
| Audit Applications tab | Redirect → `/eapps` (`/audit/queue`) | Yes · shipped |
| Audit Lookup | Redirect → CRM search (`/audit/lookup`) | Yes · shipped |
| CRM pipeline board | Stage kanban | P2 |
| e-Apps kanban | Status columns | P2 |
| Per-user permission override | Extra column | P2 |

---

## 8. Flutter / mock data reuse

| Mobile | Web reuse |
|--------|-----------|
| `CustomerHubSession` Leads vs Clients | Same IDs · add `ownerFa` · `district` on every row |
| `LeadEntity` stages | Same stage labels |
| Policy accordion (`66`) | Read-only panel |
| e-App statuses (`26`) | Same five statuses |
| `HAT_PROFILES` / `capsFor` | Drive from **role pack**, not only three hats |
| Agent directory seed | Shared with Users.People |

Prototype still mock — no Core API. Export buttons stay “workbook of current filter”.

---

## 9. What not to do

- Clone mobile Home, quote chips, Compare, NRC sheet, e-App stepper, guest calculator, biometric  
- Merge **e-Apps** with Audit **Application List**  
- Three nav items: Customer list + CRM + Clients  
- Web **Start e-App** / **Renew** / **Get a quote**  
- Manual convert Lead→Client without Core policy  
- Edit issued policy / claims / commission payout  
- Ten dashboards from ten roles — packs of caps only (`71`)  
- Roles screen outside Users  
- Let Manager `canManageUsers`  
- Put CRM back as a duplicate of FA personal book with no owner-FA column  

---

## 10. Suggested ship order (when you say ဟုတ်ကဲ့)

| Slice | What |
|-------|------|
| **P0a** | IA: CRM ▾ · e-Apps · Users ▾ · Audit redirects · caps `canViewBook` `canManageUsers` | shipped |
| **P0b** | Customers list (Leads \| Clients) + record read-only + reassign dialog | shipped |
| **P0c** | e-Apps table + dossier (move queue off Audit) | shipped |
| **P0d** | Users People + Roles matrix · wire `capsFor(role)` | shipped |
| **P1** | CRM notes · export · Lookup redirect · inbox deep links | shipped |
| **P2** | Boards · per-user overrides · dark | later |

---

## 11. Acceptance (brainstorm)

- [x] Customer list = CRM landing, not a fifth module  
- [x] FR-03 Leads \| Clients hard split on web  
- [x] e-Apps ≠ FR-01 Application List  
- [x] Users contains People **and** Roles & permissions  
- [x] Caps × hats × must/must-not  
- [x] Cross-links to Tasks · Audit · Devices · mobile  
- [x] Inventory  
- [x] Implement — P0 + P1 shipped 2026-08-17 (`agent-web-portal`)