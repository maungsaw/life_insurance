# 90 — Web HQ · Dynamic roles · Permission CRUD · People CRUD · Admin customization

**Surface:** `agent-web-portal/` · Users ▾ (+ how the rest of the desk stays “dynamic”)  
**Reference:** BRD §4.2 · clusters (`71`) · Users/Roles (`87`) · hats (`86`) · Product CRUD (`89`) · Tasks (`88`)  
**Web today:** Roles = **fixed 5 rows** (FA · TL · DM · HOA · Super Admin) · matrix toggle · **no Create role**. People = list + detail + disable · Invite is a CORE-gate dialog, not a full create form. Permissions = **hardcoded `PERM_COLS`**. Header **View as** is a demo hat, not the saved pack.  
**Date:** 2026-08-18

**Ask:** Role ကို **dynamic** + **role creation**. Permission **CRUD**. User **CRUD**. Web design တစ်ခုလုံး CRUD / Admin ကနေ **စိတ်ကြိုက်** ထပ်ထည့် · အစအဆုံး ကြိုက်တာ လုပ်နိုင်အောင်. လိုအပ်တာအားလုံး ပြည့်အောင် brainstorm.

**Rule:** BRD §4.2 dynamism = **same account, new visibility** when the **assigned role + pack** changes. It is **not** a page builder, not ten unique Homes (`71` `87`), not inventing payout / policy-edit / sell wizard on the desk (`86`).

---

## 0. “Dynamic” ကို သုံးလွှာ ခွဲ (မရောရ)

User ပြောတဲ့ စိတ်ကြိုက် / CRUD / တစ်ခုလုံး dynamic ကို **တစ်ပုံးတည်း** မထားရ။

| Layer | Object | Admin can | Admin cannot |
|-------|--------|-----------|--------------|
| **A · Access** | Role · Permission · Person | Create / edit / archive packs, invite/disable people | Invent illegal caps · delete last Super Admin · CORE-unknown invite |
| **B · Setup content** | Product SKU · Resource · Announce · Notif rules · Tasks | Already / will be CRUD on **existing modules** | New *kind* of app (claims payout, Core pricing editor) |
| **C · Shell / IA** | Sidebar, Dashboard widgets, theme | Show/hide **registered** modules via caps | Drag-drop a new portal, rename FR jobs, clone mobile Sell |

**Pick:** Ship **A fully** (this pack). Keep **B** as module CRUD (Products `89` already). **C** = nav follows packs — **not** a CMS for “any screen”.

```
Person ──has one──► Role ──has pack of──► Permissions (caps)
                                      └──► which sidebar + buttons appear
```

If Admin creates a role **without** going through a pack, HQ will paint per-user checkboxes again (`87` warned). **Role creation always clones or edits a pack.**

---

## 1. What exists vs what this pack adds

| Today | After this pack |
|-------|-----------------|
| 5 frozen role names | **Role catalog** · Add role · rename · archive |
| Toggle cells on frozen columns | **Permission catalog** · add/archive **registered** caps · matrix still roles × caps |
| People read + disable + Invite explainer | **People CRUD** inside CORE rules |
| View as Manager/FTE/Admin | Stays **demo**. Production session = person’s role pack (`87`) |
| Products CRUD (`89`) | Unchanged — example of layer B |
| “Whole web is CRUD” | **Every HQ object that is a record** gets list+setup. **Jobs** (quote, UW, payout) stay code |

---

## 2. Naming lock

| Label | Means |
|-------|--------|
| **Role** | Named pack (e.g. `Agency Manager Yangon`) · one primary per person |
| **Cluster** | Producer · Coach · District · FTE · Admin (`71`) — decides **which screens are even allowed** |
| **Permission / cap** | Boolean key bound to a **shipped module** (`canViewBook`, `canAdmin`, …) |
| **Custom permission** | Extra flag Admin names — can only **hide/show an existing module** already in the registry |
| **Person / User** | Login identity (People) — not CRM customer |
| **Hat** | Prototype View as (Manager/FTE/Admin) — maps a **cluster**, not a BRD title |
| **System role** | Seeded FA · Super Admin — archive blocked if anyone still assigned |

---

## 3. Flow A · Role CRUD (creation is the missing piece)

### IA (still one Users group)

```
Users ▾
  People                 /users/people
  Roles                  /users/roles          ← list + Add (not only matrix)
  Role setup             /users/roles/:id      ← name · cluster · pack matrix row
  Permissions            /users/permissions    ← catalog CRUD (optional child)
```

Do **not** put Roles outside Users. Do **not** a fifth top-level “Permissions” app.

### Role list

| Column | Notes |
|--------|--------|
| Name | Display (Burmese + EN later) |
| Cluster | Producer … Admin |
| People count | Link to People `?role=` |
| Caps summary | e.g. Sell · Book · Users |
| Status | Active · Archived |

**Add role**

```
Name * 
Cluster *          [Producer | Coach | District | FTE | Admin]
Clone from *       [FA | TL | DM | HOA | Super Admin | existing custom]
Channel default    App | Portal | Both
[ Create ]         → setup page · starts as clone · status Active
```

**Must:** Clone-from is required so a new row never lands with zero caps by accident (empty role = broken Home).  
**Must not:** Free-compose a 12th dashboard layout on create.

### Role setup

- Rename (code/slug locked after create, like Product code `89`)  
- Edit pack = same matrix **one row** + “Open full matrix”  
- Archive: blocked if `peopleCount > 0` (reassign people first)  
- Cannot archive the last **Admin-cluster** role that has `canManageUsers`  
- Super Admin cluster: `canSell` stays optional (already)

**Delete:** soft archive only. Hard delete never — audit + historical assignments.

---

## 4. Flow B · Permission CRUD

Permissions are **not** Excel columns Admin invents (`canPayout`). They are a **registry**.

### Permission catalog (`/users/permissions`)

| Column | Notes |
|--------|--------|
| Key | `canViewBook` — immutable after create |
| Label | Matrix header |
| Module | CRM · e-Apps · Tasks · Mgmt · Users · Audit · Export · Wipe · Sell (mobile) |
| Kind | **System** (seeded) · **Custom** (Admin) |
| Status | Active · Archived |

**Create (Custom only)**

```
Label *
Module *     [pick from registered modules]
Cap key      auto from label (slug) · cannot collide
Effect       Show module in nav  |  Allow export  |  Allow setup write
```

**Update:** label + description only. **Cannot** change key or bind to a module that isn’t registered.  
**Delete:** archive. Matrix hides archived columns. Roles keep stored `false`.

### Registry lock (code owns the effect)

| Cap (system) | Unlocks |
|--------------|---------|
| `canSell` | Mobile sell spine only — **no web wizard** |
| `canViewOwnKpis` / Team / District / Portfolio | Dashboard slices |
| `canExport` | Excel buttons |
| `canViewBook` / `canViewAllBooks` | CRM · e-Apps |
| `canAdmin` | Management setup |
| `canManageUsers` | Users · Roles · Permissions |
| `canWipe` | Devices |

**Custom cap** may only map to **those same effects** (e.g. “Hide e-Apps for this coach pack” = `canViewBook` off, or a duplicate alias). It **cannot** create a new API or a new page type.

**Must not:** Permission named `Edit issued policy`, `Approve claim payout`, `Override CORE KYC`.

---

## 5. Flow C · People / User CRUD

Still **Users → People**. CORE identity is read-only.

| CRUD | HQ does | Guard |
|------|---------|--------|
| **C** | Invite / Add **if CORE-active** · pick role · channel · district | Unknown / pending → Audit Application List (`45` `87`) — **no** create here |
| **R** | List · detail · devices · audit directory | Manager never |
| **U** | Role · channel · status · (P2: no per-user cap override — change role) | Last Super Admin cannot be Disabled |
| **D** | **Disable** (sessions end). Optional **remove from People** = hide + Disabled, identity stays in Audit | Never wipe devices from this screen |

**Add person (replace Invite-only dialog)**

```
Mobile *     CORE check mock
Name         from CORE (read)
Role *       from Role catalog (dynamic list — not 5 hardcoded options)
Channel *
[ Create ]   Active · audit “Created login”
```

People **role dropdown** reads the Role catalog (this is the visible “dynamic” for HQ).

---

## 6. “Web တစ်ခုလုံး CRUD / စိတ်ကြိုက်” — honest map

Admin “အစအဆုံး ကြိုက်တာ” ကို **module by module** ပြောရင်:

| Module | CRUD now | This pack | Still never |
|--------|----------|-----------|-------------|
| **Users / Roles / Perms** | Partial | **P0** | Payout caps · 10 Homes |
| **Products** | Shipped `89` | — | Calculator · Core pricing |
| **Resource / Announce / Notif rules** | Setup CRUD | Keep | Inbox consume ≠ setup |
| **CRM customers** | Read + notes + reassign | Not “create fake clients” | Make client without Core policy |
| **e-Apps** | Read queue | — | Wizard |
| **Tasks** | Create/edit/delete + status `88` | Optional: **task type catalog** P1 | Illegal status jumps |
| **Audit** | Directory / pending / log | Append-only | Edit history rows |
| **Dashboard** | Read KPIs | Nav visibility via caps | Admin-designed chart builder P2+ |
| **Sidebar / theme** | Fixed IA | Show/hide from pack | Drag new top-level apps |
| **Login / OTP** | — | — | Custom auth protocols |

**Customization that *is* in scope (Admin):**

1. Create role `Regional Coach` cloned from TL · turn off Export  
2. Add custom permission label “CRM book (read)” aliased to `canViewBook`  
3. Invite person → assign that role → **next session** sidebar matches  
4. Product SKU add (`89`) · announcement publish · resource upload  
5. Archive a role after moving people off it  

**Customization that is *out* of scope (looks “dynamic” but breaks BRD):**

- Admin draws a new “Claims” module in a form  
- Admin adds `canPayout`  
- Admin rearranges FA Home / quote chips on web  
- Dark portal as a role setting (`86` deferred)  
- Per-user permission matrix (prefer role change; P2 only)

---

## 7. How the shell stays dynamic (without a page builder)

```
Login → person.roleId → pack caps
  caps.canViewBook     → CRM + e-Apps
  caps.canAdmin        → Management
  caps.canManageUsers  → Users
  caps.canWipe         → Devices
  caps.canViewPortfolio / District → Dashboard filters
```

**Prototype hook:** today `capsFor(hat)` from View as. After this pack:

- Admin hat still uses View as for demos  
- **Optional:** “Preview role” on Role setup — render nav ghost from that pack (P1)  
- People.Save role → toast “menus apply next session” (already copy)

Do **not** live-reload another Admin’s session from a pack save (confusing). Next login / next session.

---

## 8. Guards (so CRUD doesn’t brick HQ)

- Last `canManageUsers` person cannot Disable self  
- Last Admin-cluster role cannot Archive  
- System permission keys cannot Delete  
- Role with assignees cannot Archive  
- Custom permission cannot point at unregistered module  
- People Create requires CORE-ok mobile  
- All C/U/D write **Audit log** (previous → new)  
- Burmese labels optional P1; EN keys stay stable  

---

## 9. Screen inventory

| Route | Screen | P0 |
|-------|--------|-----|
| `/users/roles` | Role **list** + Add + link matrix | Yes |
| `/users/roles/:id` | Role setup · cluster · pack · archive | Yes |
| `/users/roles` matrix | Full grid (existing, fed by catalog) | Yes |
| `/users/permissions` | Permission catalog CRUD | Yes |
| `/users/people` | List + **Add person** (CORE) | Yes |
| `/users/:id` | Person · role from catalog · disable | Yes (extend) |
| Preview nav from role | Ghost sidebar | P1 |
| Per-user cap override | Extra column | P2 |
| Dashboard widget builder | — | No |
| Custom module builder | — | No |

---

## 10. Mock / Flutter

| Piece | Behaviour |
|-------|-----------|
| Role catalog seed | Current 5 BRD titles + 0–1 custom example |
| People.orgRole | Becomes `roleId` → name from catalog |
| `capsFor(hat)` | Still drives View as; pack save updates **matrix state** in memory |
| Mobile | Unchanged this pass — app still uses field roles; web packs don’t clone Sell |

Prototype in-memory (like Product `CatalogProvider`). Refresh resets.

---

## 11. What not to do

- Ten dashboards from ten created roles  
- Permission free-text that executes new backend powers  
- Hard-delete people or roles  
- Merge Users with CRM Customers  
- Let Manager `canManageUsers`  
- Page-builder / “add any menu”  
- Web Start e-App / quote because a custom cap was ticked  
- Replace View as before packs actually change nav (do both: save pack **and** map at least Admin/FTE/Manager clusters to hats for demo)

---

## 12. Suggested ship order (when you say ဟုတ်ကဲ့)

| Slice | What |
|-------|------|
| **P0a** | Role catalog list + Add (clone) + setup + archive guards · People dropdown reads catalog | shipped |
| **P0b** | Permission catalog (system rows + custom alias) · matrix columns from catalog | shipped |
| **P0c** | People Add (CORE) · last-admin guards · audit-style history on Users | shipped |
| **P1** | Preview nav · EN/MM role labels · pack save actually filters sidebar in-session for View as mapped cluster |
| **P2** | Per-user overrides · widget builder **out** |

---

## 13. Acceptance (brainstorm)

- [x] Dynamic = role catalog + pack, not 10 Homes  
- [x] Role **creation** = clone cluster pack  
- [x] Permission CRUD = registry + custom **aliases**, not new powers  
- [x] People CRUD inside CORE / disable / no hard delete  
- [x] “Whole web CRUD” = every **record** module; not a CMS for jobs  
- [x] Admin customize = packs · people · setup content (`89` etc.)  
- [x] Guards · audit · View as vs production  
- [x] Implement — P0 shipped 2026-08-18 (`agent-web-portal` Users · Roles · Permissions) 
