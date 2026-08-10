# Web Dashboard Overview — Manager View + FTE Employees View

**Screen:** `DashOverviewPage`  
**Refs:** Executive Oversight (Manager View) · FTE Employees View (5.2.4.2)  
**Theme:** Coolors Baltic `#006494`  
**Related:** `18` Dashboard split · `30` (layout) · `29` branding

---

## 1. Ask

Overview must contain **both** views from the stakeholder mockups — not only one executive layout:

| Tab | BRD / mock label | Who |
|-----|------------------|-----|
| **Manager View** | Executive Oversight · Manager View | DM / manager scope |
| **FTE Employees** | FTE Employees View (5.2.4.2) | FTE / portfolio scope |

Stay **inside Overview** (do not add new sidebar children for this pass). Team Performance remains the FA production deep-dive route.

---

## 2. IA options

| Option | Idea | Verdict |
|--------|------|---------|
| A · Two sidebar items under Dashboard | Mirrors mock “Executive Oversight” children | Expands nav · conflicts with Overview / Team Performance naming |
| **B · Tabs on Overview** | Manager \| FTE on one page | ✅ **Pick** — matches mock tabs · keeps nav lean |
| C · Replace Overview with Executive Oversight group | Big IA change | Later if stakeholders insist |

**Pick B**

```
Dashboard ▾
  Overview          ← tabs: Manager View | FTE Employees
  Team Performance
```

---

## 3. What differs between views

| Element | Manager View | FTE Employees |
|---------|--------------|---------------|
| Scope copy | “Your hierarchy / district” | “Full portfolio / all FTE lines” |
| KPI scale | e.g. FYP 125.4M | e.g. Portfolio FYP 1.25B |
| Middle-right widget | District performance bars | **Portfolio target variance alerts** list |
| Proposal donut | Team/district volume | Global proposal mix |
| Table title | FA production details | Full portfolio performance & persistency |
| Table columns | FA · District · APE · FYP… | + DM · SAM · AM · K1% · K2% |
| MDRT | In progress list | Tabs All / Qualified / In Progress |
| Export | Export Excel | Export Full Dataset |

Shared: filter row (District · Manager · SAM · AM · FA · Month) · Baltic theme · alerts strip · MDRT card.

---

## 4. UX rules

1. Tab switch keeps filters (same slice language) — only metrics/copy/widgets change.  
2. Active tab = Baltic fill (not maroon from PNG).  
3. Page title stays **Overview**; subtitle reflects active view.  
4. Empty/loading later — mock data is fine now.

---

## 5. Acceptance

- [x] Brainstorm: two views on Overview via tabs  
- [x] Manager View content  
- [x] FTE Employees content (global KPIs · variance list · richer table · MDRT tabs)  
- [x] Baltic theme preserved  
- [ ] Optional later: promote to Dashboard ▾ children if nav must match PNG exactly  

---

## 6. Related

- Stakeholder PNGs · `18` · Coolors `#006494`  
