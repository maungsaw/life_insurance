# 51 — Customer tab (Customer.png)

**Source:** `Wireframe/Customer.png` (list · details · profile · policy · filter sheet)  
**BRD:** FR-03 Clients · FR-06 Policy (read) · connects FR-04/05 later  
**Flutter today:** Customer list + details + profile + policy + filter shipped (docs/51)  
**Related:** `05` FR-03 · `44` Customer tab · `50` agent Profile Details (similar form, different object) · `24` Policy  
**Date:** 2026-08-13

**Ask:** Customer tab should match the wireframe family — searchable clients, detail with policies, customer profile edit, policy accordion detail, and status/product filter — without mixing Leads into this tab and without inventing payout / full Core admin.

---

## 1. Screen map (PNG order)

| # | Screen | Job |
|---|--------|-----|
| 1 | **Customer list** | Search · filter · avatar · name · phone · status badge · open detail |
| 2 | **Customer Details** | Identity · Active badge · Phone / Email / Profile · Policies List |
| 3 | **Profile Details** (customer) | Edit customer contact (from Profile action) |
| 4 | **Policy Details** | Accordion: Policy / Insured / Policyholder / Beneficiary · FAB doc |
| 5 | **Filter** sheet | Status · Product chips · Apply · Reset |

```
Customer tab (list)
  ├─ Filter sheet (list scope)
  ├─ Customer Details
  │    ├─ Phone → tel: stub / dialog
  │    ├─ Email → mailto: stub / dialog
  │    ├─ Profile → Customer Profile Details
  │    └─ Policy row → Policy Details
  │         └─ Policies List filter sheet (policy scope)
  └─ (Leads stay off this tab — Home CRM / Leads tile · docs/44)
```

---

## 2. Customer list (tab)

```
Title: Customer
Row: [ Search.. 🔍 ] [ filter icon ]
List:
  avatar(initial) · Name · phone · status pill (Active / …)
pill clearance ~100
```

| PNG | App |
|-----|-----|
| Title **Customer** (not Customers) | Match PNG |
| Search in-body (not AppBar-only) | `TextField` + trailing search icon |
| Filter square | Opens **Filter** sheet (status + product) |
| Avatar | Initial on `AppColors.lightPrimary` — no Unsplash |
| Status | Customer-level badge for list: **Active** · **Expired** (and **All** via filter). Prototype: derive from whether they have ≥1 Active policy, else Expired / Pending if only pending |
| Tap row | `push(customerDetail)` with mock entity |
| Empty | “No customers” + clear filters CTA |

**Do not** put Leads rows here. FR-03 split stays: this tab = **Clients**. Leads = existing off-nav `LeadsPage`.

---

## 3. Filter bottom sheet

Shared chrome for **list** and **Policies List** (same UI; different apply target).

| Section | Chips |
|---------|--------|
| **Status** | All · Active · Expired |
| **Product** | All · Protection · Saving · Travel *(horizontal scroll if needed)* |

| Control | Behavior |
|---------|----------|
| Selected chip | Light primary border + small blue badge top-right (PNG) |
| **Apply** | Close sheet · apply to current scope · refresh list |
| **Reset** | Status=All · Product=All · stay open **or** apply immediately — **P0:** reset selection then user taps Apply |
| Drag handle | `showModalBottomSheet` + `showDragHandle: true` |

### Scope rules

| Opened from | Filters |
|-------------|---------|
| Customer **list** | Customers whose policies match (or customer status). Product = customer has ≥1 policy in that category |
| **Policies List** | Only that customer’s policies by status + product category |

**Pending** on policy rows is **not** on the list Status chips (PNG Status = All / Active / Expired). Policies List still **shows** Pending badges; filter “Active/Expired” hides Pending unless Status=All.

---

## 4. Customer Details

```
AppBar: ← Customer Details
Card: avatar · name · Active badge
Actions: Phone · Email · Profile  (colored outline circles)
Sheet: Policies List  [filter]
  icon · policy id · product type · status badge
```

| Action | Prototype |
|--------|-----------|
| **Phone** | `url_launcher` if available · else `AppStatusDialog` with number |
| **Email** | Same for email |
| **Profile** | Push **Customer Profile Details** (edit form) |
| Policy row | Push **Policy Details** |
| Policies List filter | Same Filter sheet, policy scope |
| Policies List “+” | PNG shows filter icon on header — **not** add policy. New quote stays Product / FAB |

**Drop from current Flutter detail (comment-out, don’t delete):** more_vert · Call/Email/**Message** trio · Active Policies count cards · Total Premium · Recent Activity. Wireframe wins layout.

---

## 5. Customer Profile Details ≠ Agent Profile Details

Same field set as agent edit (`50`), **different object** (client, not FA).

| Field | Required | Notes |
|-------|----------|-------|
| Name | Yes | PNG shows chevron — treat as **text** first; optional title picker (Daw/U/…) P1. Not a customer picker |
| Mobile* | Yes | MM `09…` feel |
| DOB* | Yes | Calendar · display `dd-MMM-yyyy` or `dd.MM.yyyy` — pick one; prefer wireframe `04-JUN-1999` on this screen |
| Identification* | Yes | NRC string |
| Email | No | Soft validate if filled |
| Gender | Choice | Male / Female chips |
| Photo | Camera badge | Stub dialog |

**Reuse:** `AppTextField` · gender chips · date picker pattern from agent page.  
**Do not** overwrite `ProfileMockData` (agent). Use `CustomerMockData` / mutate the passed customer mock.

SAVE / UPDATE: success dialog → pop to Customer Details (refresh name/avatar).

---

## 6. Policy Details

```
← Policy Details
[ Policy Information ▴ ] Active
    Product Name · Sum Insured · Policy Term · Payment Frequency · Premium
[ Insured Information ▾ ]
[ Policyholder Information ▾ ]
[ Beneficiary Information ▾ ]
FAB (bottom-right): document icon → stub “Policy document later”
```

| Section | Mock content |
|---------|----------------|
| Policy Information | Health Insurance · 1 Unit · 1 Year · Semi-Annual · 5,600 MMK (+ status Active/Pending/Expired) |
| Insured | Name · DOB · NRC · Gender · Relationship |
| Policyholder | Name · Mobile · Email · Address stub |
| Beneficiary | Name · Relationship · Share % |

**UI:** Custom expand cards (not Material `ExpansionTile` defaults if they fight PNG). One section open by default (Policy Information).

**FAB:** Info dialog only — no PDF binary in prototype.

---

## 7. Data model (prototype)

```
CustomerMock
  id, name, phone, email, dob, identification, gender, status
  policies: List<PolicyMock>

PolicyMock
  id (e.g. 187498273098)
  productName, productCategory (protection|saving|travel|health→map)
  status (active|pending|expired)
  sumInsured, term, frequency, premium
  insured / policyholder / beneficiary maps
```

**Product chip mapping:** Health Insurance → treat under **Protection** (or add Health chip later). PNG Product row has no Health — map Health → Protection for filter.

Mock seed: ≥1 May Chan Myae with Active + Pending policies; 1–2 more clients so search/filter are testable.

---

## 8. Flutter map

| Piece | Action |
|-------|--------|
| `CustomersPage` | Rebuild to PNG list + search + filter |
| `CustomerDetailPage` | Rebuild to PNG details + policies |
| New | `CustomerProfileDetailsPage` · `PolicyDetailsPage` · `CustomerFilterSheet` |
| Routes | reuse `customerDetail` · add `customerProfile` · `policyDetail` |
| Entity | Extend `CustomerEntity` **or** parallel mock models (prefer mock models for prototype speed; keep entity fields compatible) |
| DRY | Status pill widget (Active green / Pending amber / Expired grey) shared with Profile portfolio later |
| Bottom pad | Same ~100 as Profile for floating pill |

---

## 9. Conflicts & decisions

| Topic | Decision |
|-------|----------|
| Leads on Customer tab | **No** — Clients only (`44`) |
| List status vs policy status | List = customer rollup; Policies List = per-policy |
| Agent vs customer Profile Details | Separate pages / routes; shared field widgets OK |
| Name dropdown on PNG | Text field P0; salutation dropdown P1 |
| Message action on old detail | Drop — PNG has Phone / Email / Profile |
| Add policy from Policies List | No — Product / FAB |
| Commission / withdraw | Out of scope |
| API / Core | Mock only |

---

## 10. Build order

1. Mock data + status pill + filter sheet widget  
2. Customer list (search + filter apply)  
3. Customer Details + Phone/Email stubs + Policies List  
4. Policy Details accordions + FAB stub  
5. Customer Profile Details (edit)  
6. Wire navigation · pill padding · inventory  

---

## 11. Acceptance

- [x] Brainstorm documented (this file)  
- [x] Customer tab = client list matching PNG chrome  
- [x] Search + Filter sheet work on list  
- [x] Details: Phone · Email · Profile · Policies List  
- [x] Policy Details accordions + doc FAB stub  
- [x] Customer Profile Details edit does not mutate agent profile  
- [x] Leads remain off this tab  
- [x] No hamburger · pill nav unchanged  

---

## 12. Related

`Customer.png` · `05` FR-03 · `24` Policy · `44` tab · `50` agent profile form  
