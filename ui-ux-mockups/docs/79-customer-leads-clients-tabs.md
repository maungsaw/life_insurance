# 79 — Customer hub · Leads | Clients tabs (FR-03)

**Source:** Live Customer screenshot (2026-08-17) · BRD §5.3 FR-03 · ask: split Lead vs Client with two tabs  
**Flutter today:** One **Customer** list (Active / Expired pills) · orphan `LeadsPage` still in IndexedStack but not the Customer chrome (`51` · `44`)  
**Related:** `05` FR-03 · `34` §4.3 · `44` nav · `51` Customer hub · `02` Lead→Client flow · FR-04 Save Quote · FR-05 e-App · FR-06 Policy  
**Date:** 2026-08-17

**Ask:** Customer ကို **Lead** နဲ့ **Client** ခွဲပါ။ Lead = client မဖြစ်သေး · policy မရှိသေး · condition အဆင့်။ Condition submit လုပ်မှ Client ဖြစ်မယ်။ UI က tab နှစ်ခု။

---

## 1. BRD source of truth (FR-03)

| BRD item | Meaning |
|----------|---------|
| **Two separate, searchable lists** | 1) **Clients** = existing **policyholders** · 2) **Leads** = prospects who have **not yet purchased** |
| **Lead management** | Add / edit leads · **convert** leads to clients upon **successful policy insurance** |
| **Client profile** | Contact · active/lapsed policies · family / associated contacts · notes / activity |

FR-04: Save Quote can link to **Lead or Client**.  
FR-05: Start e-App from client profile or saved quote.  
FR-06: Policy servicing lives on the **client** side.

**Rule:** BRD wins list definitions. Wireframe list chrome (search · filter · avatar · row) applies to **both** tabs (`34` §4.3).

---

## 2. What is wrong today

| Today | Problem |
|-------|---------|
| Single title **Customer** + one list | Mixes FR-03’s two objects into one bag |
| Pills = Active / Expired | Policy-servicing language on what should also be prospects |
| `51` said “Leads stay off this tab” | Conflicts with BRD + `34` IA (`Customers → Leads \| Clients`) |
| Separate `LeadsPage` in shell | Orphan UX · different chrome · not discoverable from Customer tab |

Screenshot mental model stays: search + filter + rows. The missing piece is the **Leads | Clients** hard split.

---

## 3. Object model (aligned with ask + BRD)

```
Prospect ──► Lead ──► (quote / nurture / e-App draft) ──► Condition / App submitted
                                                              │
                                                              ▼
                                                         Client (policyholder path)
                                                              │
                                                              ▼
                                                    Active / Pending / Expired policies
```

### Lead

| Field | Rule |
|-------|------|
| Who | Prospect — **not yet purchased** (BRD) |
| Policy | **Zero** issued/servicing policies |
| Pipeline | Condition / sales stage only (New · Contacted · Quoted · Applied / Submitted …) |
| Can have | Saved quotes · draft e-App · notes · tasks |
| Cannot show | Active / Expired policy pills as primary status |

### Client

| Field | Rule |
|-------|------|
| Who | Existing **policyholder** (BRD) |
| Policy | ≥1 policy in book (Active · Pending · Expired / lapsed) |
| Profile | Contact + policies + family + activity (`05` · `51`) |
| Status pill | Derived from policies (same as today’s Customer list) |

### Convert trigger (important)

| Source | Convert when… |
|--------|----------------|
| **BRD FR-03** | **Successful policy insurance** (issued / becomes policyholder) |
| **Product ask** | **Condition submit** → become Client |

**Prototype decision for P0 (document + ship):**

1. **Lead** = no policy rows linked.  
2. **Client** = has ≥1 policy (including **Pending** if Core already created a policy stub after application submit).  
3. **Convert moment** UI fires when the person first gains a policy record (matches BRD “policy insurance” for issued; if product treats **condition submit** as creating a Pending policy, that same move lands them on the **Clients** tab with a **Pending** pill).

Do **not** keep the same person in both tabs. Convert removes them from Leads and shows a one-shot banner: “{Name} is now a Client”.

If stakeholders later insist convert happens on submit **without** any policy row yet, add an explicit `CrmKind.client` flag — still **one** list membership, never dual.

---

## 4. IA — Customer tab becomes the CRM hub

```
Bottom nav · Customer
├─ Title: Customer
├─ Tabs: [ Leads ] [ Clients ]     ← hard split (FR-03)
├─ Search.. + Filter
├─ List (scope = selected tab)
└─ Detail
     ├─ Lead detail  → Quote · Start e-App · Edit · Notes
     └─ Client detail → Phone · Email · Profile · Policies (51)
```

| Entry | Behavior |
|-------|----------|
| Bottom **Customer** | Opens hub · default tab **Clients** (daily servicing) **or** last-used tab |
| Home “CRM” tile | Opens Customer hub · prefer **Leads** if that was the old Leads jump |
| FAB “New Lead” | Opens Add Lead · lands on Leads tab after save |
| Quote “Link to Lead/Client” | Picker lists both scopes (`59` / `65`) |

**Retire as primary UI:** standalone `LeadsPage` chrome. Keep route/data temporarily; hub owns the experience.

---

## 5. UI shell (two tabs)

```
Customer

[ Leads ] [ Clients ]

[ Search..                    🔍 ] [≡]

  (M)  May Chan Myae          [Quoted]
       09 750337968

  (C)  Chit Thu               [Active]
       09 …
```

### Shared chrome

| Piece | Spec |
|-------|------|
| Title | **Customer** (wireframe word; tabs carry the BRD split) |
| Segmented control | Same language as My work Day/Week/Month — filled primary selected |
| Search | Filters **current tab only** · placeholder `Search leads..` / `Search clients..` |
| Filter button | Opens sheet whose chips depend on tab (see §6) |
| Row | Avatar initial · name · phone · trailing pill |
| Empty | Tab-specific copy + CTA |

### Tab-specific

| | **Leads** | **Clients** |
|--|-----------|-------------|
| Pill | Stage: New · Contacted · Quoted · Applied | Policy-derived: Active · Pending · Expired |
| Trailing meta (optional P1) | Last activity / “Quote saved” | Policy count `2 policies` |
| Primary empty CTA | **Add lead** | **Add lead** (nurture path) or deep-link Product |
| Row tap | Lead detail | Client detail (`51`) |
| AppBar / header `+` (P0) | Add lead | Optional — Clients usually created by convert, not manual |

Counts on tab labels (P1): `Leads · 12` · `Clients · 48` — only if not noisy.

---

## 6. Filters

### Leads filter sheet

| Section | Chips |
|---------|--------|
| Stage | All · New · Contacted · Quoted · Applied |
| (P1) Has quote | All · With quote · No quote |

### Clients filter sheet

Keep today’s Customer filter (`51`):

| Section | Chips |
|---------|--------|
| Status | All · Active · Expired *(Pending stays on rows; Status=All shows it)* |
| Product | All · Protection · Saving · Travel |

Search + filter state **resets or is stored per tab** — recommend **per-tab** so switching Leads ↔ Clients doesn’t wipe work.

---

## 7. Lead detail vs Client detail

### Lead detail (new / upgrade)

```
← Lead
Avatar · name · [Quoted]
Phone · Email · Edit
Next best: [ Get a quote ] [ Start e-App ]
Saved quotes · Apps (draft/submitted)
Notes / activity
```

- No **Policies List** block (they have none).  
- If Applied / condition submitted and convert pending Core: show amber banner “Application submitted — waiting for policy”.

### Client detail (keep `51`)

```
← Customer Details
Avatar · name · [Active]
Phone · Email · Profile
Policies List …
```

Family / activity can stay P1 stubs if not fully built.

### Convert moment

Bottom sheet or soft banner after return from tracker / mock approve:

**“May Chan Myae is now a Client”** · [ View client ]

---

## 8. Status language — do not mix

| Context | Allowed pills |
|---------|----------------|
| Leads list / lead detail | Pipeline stages only |
| Clients list / client detail / Home Policy KPIs | Active · Pending · Expired |
| Never | “Active” on a Lead · “Quoted” on a Client row |

Home Policy trio stays **client-policy** metrics — not lead counts.

---

## 9. Data / Flutter map (when implementing)

| Piece | Work |
|-------|------|
| `CustomersPage` | Add `Leads \| Clients` segmented control · scope list |
| Model | `CrmPersonKind { lead, client }` **or** separate `LeadMock` + existing `CustomerMock` with shared list row widget |
| Seed | Move some current customers to leads (no policies) · keep policyholders on Clients |
| `LeadEntity` / `LeadsPage` | Reuse data into hub; stop presenting orphan page as primary |
| Filter sheets | Lead stage sheet + existing client sheet |
| Search | Per-tab controller or clear on tab change (pick one · document) |
| Navigation | `openLeads()` → Customer hub + select Leads tab |
| Quote link picker | Enumerate both lists |
| Convert stub | Button on Lead detail “Mark as Client (mock)” **or** auto when first policy attached |

---

## 10. Phasing

| Phase | Scope |
|-------|-------|
| **P0** | Customer hub tabs · separate lists · search · tab-aware filters · lead stage pills · client status pills · lead detail stub (contact + CTA) · client detail unchanged · convert stub · Home CRM → Leads tab |
| **P1** | Tab counts · quotes/apps on lead profile · family on client · convert animation from e-App Approved · retire `LeadsPage` from IndexedStack |
| **Out** | Manual convert without ops rule · web CRM duplicate · Core sync |

---

## 11. What not to do

- Don’t keep one mixed list with a tiny “Lead/Client” chip per row as the only split  
- Don’t show policy Active/Expired as the Lead list’s primary status  
- Don’t invent a third tab “All” that re-mixes FR-03  
- Don’t create Client by typing only — convert / policy path  
- Don’t put Leads under Profile or only behind Home forever  

---

## 12. Acceptance (brainstorm)

- [x] BRD FR-03 two-list rule cited  
- [x] Lead vs Client object model + convert trigger clarified (BRD insurance · ask condition submit · prototype bridge)  
- [x] Two-tab Customer hub UI specified  
- [x] Filters · pills · empty · detail differences  
- [x] Flutter map + phasing  
- [x] Flutter Leads \| Clients hub shipped (P0)  
- [x] Inventory updated  

---

## 13. Shipped (P0)

| File | What landed |
|------|-------------|
| `customer/pages/index.dart` | Customer hub · Leads/Clients segmented control with counts · per-tab search · tab-aware lists/empty states |
| `lead_filter_sheet.dart` | Lead stage filters: All · New · Contacted · Quoted · Applied |
| `customer_hub_session.dart` | Last selected tab · `openLeads/openClients` · condition-submit conversion |
| `lead.dart` + repository | Phone data · BRD-aligned pipeline stages |
| `lead/pages/detail.dart` | Contact + **Get a quote** / **Start e-App**. Stage + convert are web (`101`) |
| `home/pages/index.dart` | Home/FAB `openLeads` now opens Customer hub on Leads, not the orphan stack |

Conversion removes the lead, creates one Pending policy/client record, switches to Clients, and shows “is now a Client”. A person is never rendered in both lists.

P1 remains: full Add/Edit Lead form · saved quotes/apps blocks · family/activity completion · Core-driven conversion.

---

## 14. Related

BRD §5.3 FR-03 · `05` · `34` §4.3 · `44` · `51` · `02` · FR-04/05/06 · Customer.png · screenshot 2026-08-17
