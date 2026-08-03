# Web App Shell + Dashboard Metrics UX (All Concepts)

**BRD:** §5.2.1 Dashboards · §5.2.2 Core Data (weighting for Freelance FYP / Internal FYP) · FR-03 · FR-07 · FR-09

---

## 1. Web app chrome (required)

```
┌──────────────────────────────────────────────────────────┐
│  [Logo KBZ LIFE]              Search?     🔔   [Profile] │  ← Header
├────────────┬─────────────────────────────────────────────┤
│ Dashboard  │                                             │
│ Performance│              Main content                    │
│ CRM        │                                             │
│ Policies   │                                             │
│ Tasks      │                                             │
│ Recruit    │                                             │
│ Announce   │                                             │
│ Ops        │                                             │
│ Agents     │                                             │
└────────────┴─────────────────────────────────────────────┘
     ↑ Left menu
```

| Zone | Content |
|------|---------|
| **Logo (header left)** | KBZ LIFE Agent Portal mark |
| **Profile (header right)** | Avatar, name, role, language, sign out |
| **Left menu** | Persistent IA; active state; collapses on narrow screens |

### Concept tones for shell
| A Field Momentum | B Trust & Clarity | C Command Center |
|--|--|--|
| Emerald sidebar, amber active | Navy sidebar, gold active rail | Charcoal rail, signal-green active |

---

## 2. Dashboard · 5.2.1 metrics

All values via KBZ LIFE APIs (frontend displays only).

| Metric | UI treatment |
|--------|----------------|
| Policy Count | New vs Existing Active (split KPI or stacked bar) |
| FYP | Initial + Subsequent · MoM % · vs avg productivity |
| APE / AFYP | KPI + MoM comparison |
| Due vs Collected | Dual metric + collection % bar |
| Commission | Product commission (+ UL note) |
| K1 / K2 Persistency | Pair KPIs + grace period cue |
| Persistency (count / premium) | Ratio cards with numerator/denominator helper |
| Road to MDRT | Progress + premium/commission toggle |

### 5.2.2 Core Data · Weighting
- Toggle or segmented control: **Freelance FYP** vs **Internal FYP**
- Short explainer: “Weighting factors applied by Core — portal displays API results”
- Optional footnote table: weighting factor legend (placeholder until Core defines numbers)

### Charts (must have)
1. **Bar chart** — Monthly FYP / APE (or Due vs Collected by week)  
2. **Line chart** — Trend: FYP + Persistency or MDRT progress over months  

**UX rules**
- Filters above charts: Period · Hierarchy (role-scoped) · Freelance/Internal weighting mode  
- Empty/loading skeletons; export from Performance, not necessarily Dashboard  
- Mobile FA dashboard stays light; **web** is the dense analytics surface  

---

## 3. Web CRM (extends FR-03)

Managers/ops need portfolio visibility, not only personal FA book.

| View | Purpose |
|------|---------|
| Leads | Searchable team/portfolio leads · stage · owner FA |
| Clients | Policyholders · due badges · owner FA |
| Record detail | Contact, quotes/apps summary, convert history, activity |

**Convert** still driven by policy approval; web shows status + deep link to policy.

---

## 4. Policies / Sales process (FR-03 spine on web)

Web “Policies” module surfaces the end-to-end sales chain for oversight:

`Lead → Quote → e-App → Approved → Client → Active/Lapsed Policy`

| Screen | Content |
|--------|---------|
| Pipeline board | Counts by stage |
| Policy list | Search SI, due, status, FA owner |
| Policy detail | Read-only Core fields · beneficiary · next due |
| Linked CRM | Jump to client/lead |

---

## 5. Task Management (FR-07 web)

| Capability | UI |
|------------|-----|
| Add | Form: title, assignee FA, type (Recruitment/Servicing/Other), due, link to candidate/client |
| Move | Reassign FA / reschedule / change type |
| Delete | Confirm destructive |
| Status | Pending · In Progress · Completed (permission-aware) |
| Recruitment | Task tied to onboarding status (Screening → Contracted…) |

Table + side drawer for create/edit. Calendar optional on web (list-first for managers).

---

## 6. Announcements (FR-09)

| Field | UI |
|-------|-----|
| Title | Required |
| Image | Upload + preview |
| URL | Validated link |
| Audience | Role/hierarchy scope (placeholder) |
| Schedule / Publish | Draft → Published |
| History | List with status |

Mobile receives image + URL feed (already mocked).

---

## 7. Acceptance (web)

- [x] Left menu + header logo/profile on all concepts  
- [x] Dashboard shows 5.2.1 KPIs + Freelance/Internal weighting control  
- [x] Bar chart + line chart present  
- [x] CRM Leads/Clients lists  
- [x] Policies module linked to FR-03 spine  
- [x] Tasks Add/Move/Delete + status  
- [x] Announcement builder with image + URL  

## 8. How to try the mock

1. Open any concept HTML → right panel starts at **web login**  
2. Continue → OTP → **Verify & open portal**  
3. Use **left menu**: Dashboard (weighting + charts) → CRM → Policies → Tasks → Announcements  

