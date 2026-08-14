# 66 — Policy List · Details · Filter (FR-06)

**Source:** `Wireframe/Policy.png` (+ crops: list+chart · Policy Details · Filter sheet)  
**BRD:** §5.6 **FR-06 Policy and Servicing (Mobile)** — Policy Search · View Policy Details · Core Integration  
**Flutter today:** Home Policy KPI + stub “See all”; Customer-scoped Policies List + `PolicyDetailsPage` (`51`); **no** agent-wide Policy List / chart / date filter  
**Related:** `34` §3/`§4.6` · `51` CRM · `55`/`58` Home Policy · FR-08 premium/renewal reminders  
**Date:** 2026-08-14

**Ask:** New Policy pack — align with BRD + wireframe, brainstorm everything needed so FR-06 feels complete (list · chart · filter · details), without inventing Core admin edit.

---

## 1. BRD jobs (source of truth)

| BRD item | Meaning |
|----------|---------|
| **Policy Search** | FA finds **any of their clients’ policies** (not the whole company book). |
| **View Policy Details** | **Read-only** active (and related) policy: coverage (SI) · beneficiary · premium · **next due date**. |
| **Integration** | Core policy data later; mock now. |

**Not in FR-06:** edit issued policy fields · payout · claim admin · entity/group policy admin.

**Nearby BRD:** FR-08 recurring premium + annual renewal reminders → Home banners / Notifs deep-link **into** this list (filter Pending / due window) — don’t rebuild reminder logic inside Policy Details.

---

## 2. Wireframe screens (layout source)

| Screen | PNG content |
|--------|-------------|
| **Policy List** | ← Policy List · Search · filter icon · **area chart** Active/Pending/Expired · rows (icon · policy no · product · status pill) |
| **Filter sheet** | Product chips (All / Protection / Saving / Travel …) · Status chips · **Date range** · APPLY / RESET |
| **Policy Details** | Accordions: Policyholder · **Policy Information** (expanded) · Insured · Beneficiary · **Signature** pad (display) · pencil on Policy Information |

---

## 3. BRD vs wireframe — decisions

| Topic | BRD | Wireframe | **Decision** |
|-------|-----|-----------|--------------|
| Scope of list | FA’s clients’ policies | Global-looking list | **Agent book for this FA’s clients** — same mock pool as Customer policies, **deduped by policy id** |
| Search | Required | Search bar | **P0** — policy no · product · client name |
| Chart | Not required | Active/Pending/Expired area chart | **P0 layout** — counts over mock months (display). Not a trading chart; legend matches Home KPI colors |
| Status set | Active implied; servicing | Active · Pending · Expired | **Use wireframe trio** (align Home KPI + CRM pills) |
| Product chips | — | Protection · Saving · Travel (+ All) | Add **Health / Bundled** if in mock catalog; hide empty lines |
| Date range | — | Required `*` on PNG | **P0 filter** on **issue / effective / next-due** (pick one mock field: `effectiveFrom`–`effectiveTo` or next-due window). Soft-required in UI; empty = no date constraint |
| Details read-only | Explicit | Pencil on Policy Information | **No Core field edit** (`34` §4.6). Pencil → stub “Servicing request” **or** hide. Prefer **hide** on P0 to avoid fake edit |
| Signature on details | Not in FR-06 | Signature + refresh | **Display-only** capture from issue/e-App if present; else empty “No signature on file”. **Not** a new signing surface for issued policies (signing stays FR-05) |
| Accordion order | — | PH · Policy · Insured · Beneficiary | Match PNG order; open **Policy Information** by default |
| Age / SI / Premium on Policy card | Coverage · premium · due | Product · age · SI · term · premium | Include **Your Age** (at issue or current — mock **at issue**) · **Next due date** (BRD) · stamp optional |
| Customer CRM list (`51`) | — | Overlaps | **Keep both:** Customer detail = policies **for that client**; Policy List = **all my clients**. Same `PolicyMock` · same Details page |
| Home See all / KPI tap | — | — | **Wire to Policy List** (end stub `55`/`58`) · KPI tap can pre-filter status |

---

## 4. Information architecture

```
Home Policy
  ├─ KPI Active / Pending / Expired  → Policy List (status pre-filter)
  └─ See all >                       → Policy List (All)

Customers → Client detail → Policies List → Policy Details
                              ↑ same detail page
Policy List (new)
  ├─ Search
  ├─ Filter sheet (product · status · date)
  ├─ Chart (counts by status over time)
  └─ Row → Policy Details
```

**No new bottom tab.** Entry = Home + optional More later. Route: `AppRoute.policyList`.

---

## 5. Screen specs

### A. Policy List

```
←  Policy List
[ Search..                              🔍 ]  [≡ filter]

┌──────── chart card ────────┐
│  area: Active / Pending / Expired   │
│  legend                             │
└─────────────────────────────────────┘

[ icon ]  23487532096712          [ Active ]
          Personal Accident
…
```

| Rule | Spec |
|------|------|
| Data | Flatten `CustomerMockData` policies (+ owner client name on row subtitle or search index) |
| Empty | “No policies” / “No match” |
| Row tap | `PolicyDetailsPage` |
| Chart | Mock 4–6 month series · three series · soft fills · Y = counts. Recompute from **filtered** list when possible (simple: chart = full book, list = filtered — **P0 OK**; P1 sync chart to filter) |
| Icons | Per product line (reuse catalog / CRM icons) |
| Status pill | Reuse `AppCrmStatusPill` |

### B. Filter sheet

Match crop: chip + top-edge **blue dot** for selected (same language as quote type chips if already patterned).

| Section | Options |
|---------|---------|
| Product | All · Protection · Saving · Travel · Health · Bundled (only lines that appear) |
| Status | All · Active · Pending · Expired |
| Date range | From–To picker · `DD-MMM-YYYY` display (BRD date format) · calendar icon |
| Actions | **APPLY** (primary) · **RESET** (secondary) |

Persist selection for the list session.

### C. Policy Details (polish existing)

| Change | Spec |
|--------|------|
| Section order | Policyholder → Policy Information → Insured → Beneficiary → Signature |
| Policy rows | Product · Age · SI · Term · Premium · Frequency · **Next due** · Status |
| Pencil | **Omit** (read-only) |
| Signature | Read-only pad / image stub · refresh icon disabled or “Clear” N/A |
| FAB doc | Keep stub viewer (`51`) |
| Pending/Expired | Same page; badge in app bar or under title |

---

## 6. Mock data gaps to add

| Field | Why |
|-------|-----|
| `clientId` / `clientName` | Search + “whose policy” |
| `effectiveDate` / `expiryDate` | Date filter · Expired |
| `nextDueDate` | BRD View Policy Details |
| `ageAtIssue` | PNG “Your Age” |
| `signatureAsset` or bool `hasSignature` | Signature section |
| Monthly count series **or** derive chart from dated policies | Chart |

Expand mock so chart isn’t empty (mix Active/Pending/Expired across months).

---

## 7. What not to do

- Edit Core policy fields from mobile  
- Treat Signature as a new e-sign for issued policies  
- Duplicate a third policy model separate from CRM  
- Group/entity policy admin  
- Fake live Core sync  
- Replace Customer Policies List — keep client-scoped view  

---

## 8. Flutter map (when building)

| Piece | Work |
|-------|------|
| `policy_list_page.dart` (customer or new `features/policy`) | List · search · chart · filter entry |
| `policy_filter_sheet.dart` | Product · status · date · APPLY/RESET |
| Chart widget | Simple `CustomPainter` or existing chart dep if already in pubspec — prefer light custom / fl_chart only if present |
| `PolicyMock` + filter helpers | New fields · date filter |
| `PolicyDetailsPage` | Order · next due · signature · drop pencil |
| Routes | `policyList` · Home See all + KPI → list with args |
| Docs | This file · tick `34` filter checklist |

---

## 9. Phasing

| Phase | Scope |
|-------|-------|
| **P0** | Policy List + search + status/product/date filter + chart + wire Home · Details polish (next due · signature display · no pencil) · richer mock |
| **P1** | Chart respects filters · deep-link from FR-08 renewal notifs · Health/Bundled chips polish |
| **P2** | Core policy API · real PDF certificate |

---

## 10. Acceptance

- [x] Brainstorm documented (this file)  
- [x] Policy List route replaces Home stub  
- [x] Search + Filter (product · status · date)  
- [x] Chart Active/Pending/Expired  
- [x] Row → shared Policy Details  
- [x] Details read-only · next due · signature display · no Core edit  
- [x] Inventory updated  

**Shipped P0:** `policy_list_page.dart` · `policy_list_filter_sheet.dart` · richer `PolicyMock` · Home See all / KPI → list · Details order + signature.  

---

## 11. Related

`Policy.png` · BRD FR-06 · `51` · `34` §4.6 · Home `58` · FR-08 reminders  
