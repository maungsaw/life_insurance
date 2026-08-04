# Dashboard nav — Overview · Team Performance (UI/UX)

## 1. Problem

Dashboard currently stacks **Overview** + **Team line** on one long page with jump chips. That fights the Management pattern managers already learned (group ▾ → children).

Also “Team line” reads like a chart series, not a **people performance** job.

## 2. Decision

Mirror **Management**:

```
Sidebar
├── Dashboard  ▾ / ▴
│   ├── Overview              ← 5.2.1 KPIs + charts
│   └── Team Performance      ← was “Team line” · FA production table
├── Tasks
├── Management  ▾
│   ├── Resource · Notification · Announcement
└── Audit
```

| Choice | Why |
|--------|-----|
| Dashboard is a **group**, not a single leaf | Same expand/collapse mental model as Management |
| Rename **Team line → Team Performance** | Clearer job: how the team (and each FA) is performing |
| **Separate routes** | One job per screen; no long scroll + jump chips |
| Keep **shared filter semantics** | Weighting + hierarchy still mean the same slice on both children |
| `/performance` → Team Performance | Old Performance bookmark lands on the table job |

## 3. Jobs per child

### Overview (`/dashboard/overview`)

- KPI cards (5.2.1): policies, FYP, APE, due/collected, commission, K1/K2, persistency, MDRT  
- Bar + line charts  
- Weighting footnote  
- Export Excel for **this** filtered overview (mock)

### Team Performance (`/dashboard/team-performance`)

- FA line table: APE · FYP · SFYP · Weighted FYP · MDRT · K1/K2 · Flag  
- Same Freelance / Internal weighting mode  
- Same Region · District · SAM · AM hierarchy  
- Export Excel for **this** filtered team table (mock)  
- Flags (“Below target”) are the scan job — managers act via Tasks / Notifications, not inline edit here

## 4. Shared controls (UX rule)

Both children show the same control strip:

1. Freelance FYP (weighted) | Internal FYP (weighted)  
2. Region · District · SAM · AM  

**Rule:** Changing filters on Overview then opening Team Performance should keep the same slice (session context). Mock: React context under Dashboard routes.

**Don’t:** Put different filter sets on each child — that re-creates the old Dashboard ↔ Performance context loss.

## 5. Sidebar interaction

Same as Management:

1. Click **Dashboard** row / chevron → expand ▾ → ▴  
2. Auto-expand when path starts with `/dashboard`  
3. `/dashboard` alone → `/dashboard/overview`  
4. Active child highlighted; parent group soft-highlighted  

## 6. What we reverse from doc 15

| Doc 15 (merge) | Now |
|----------------|-----|
| One scroll page, two zones | Two routes under Dashboard group |
| Jump chips Overview / Team line | Sidebar children |
| Label “Team line” | **Team Performance** |
| Performance removed from sidebar | Still not top-level — lives under Dashboard |

Merge intent (shared weighting + hierarchy) **stays**; only the navigation pattern changes.

## 7. Routing

| Path | Screen |
|------|--------|
| `/dashboard` | → `/dashboard/overview` |
| `/dashboard/overview` | Overview |
| `/dashboard/team-performance` | Team Performance |
| `/performance` | → `/dashboard/team-performance` |

## 8. Acceptance

- [x] Brainstorm documented  
- [x] Dashboard expands like Management  
- [x] Children: Overview · Team Performance  
- [x] Shared weighting + hierarchy context  
- [x] Old `/performance` redirect  
- [x] In-page jump chips removed  

## 9. Out of scope

- Real Core export payloads  
- Drill-down FA profile from table row (later → Audit / CRM mobile)
