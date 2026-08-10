# Web Dashboard Overview — executive layout (Baltic theme)

**Screen:** `DashOverviewPage` only  
**Visual ref:** Executive / FTE portfolio dashboards (filters · KPI rings · charts · alerts · FA table · MDRT)  
**Theme accent:** Coolors **#3 Baltic Blue** `#006494`  
**Logo:** existing `PLATFORM_LOGO_URL` (shell already)

---

## 1. Goal

Make Overview feel like the dense manager BI view: hierarchy filters, export, KPI strip with progress, proposal charts, target alerts, FA table, MDRT widget — without rebuilding the whole portal IA.

---

## 2. What we keep vs change

| Keep | Change (Overview only) |
|------|------------------------|
| Dashboard ▾ Overview / Team Performance | Overview content density + layout |
| Coolors full palette | **Baltic** as primary chart/CTA accent on this page |
| Shared filter *context* for weighting | Overview gets richer filter row (District · Manager · SAM · AM · FA · Month) |

Team Performance page stays as-is for this pass.

---

## 3. Layout map (top → bottom)

```
PageHeader · Overview (+ Export · Baltic)
Filter bar · District · Manager · SAM · AM · FA · Month
KPI strip (6) · value / progress ring where useful
Charts row · Proposal donut | Proposal trend | District bars
Target alerts strip · Critical · Warning · On Track
Bottom · FA production table (flex) + MDRT tracker card
```

---

## 4. Color rules (this page)

| Role | Hex |
|------|-----|
| Theme / CTA / rings / bars | `#006494` Baltic |
| Secondary series | `#0582CA` Steel · `#00A6FB` Sky |
| Ink / sidebar (global) | `#003554` Deep |
| Status | ok / warn / danger (unchanged) |

Avoid maroon/crimson from the ref PNGs — stay on Coolors blues; Baltic replaces “brand red” for accents.

---

## 5. Acceptance

- [x] Overview matches executive density (filters · KPIs · 3 charts · alerts · table · MDRT)  
- [x] Baltic `#006494` as Overview theme accent  
- [x] Export on Overview  
- [x] Logo unchanged (shell)  
- [x] Team Performance not redesigned in this pass  
- [x] **Manager View + FTE Employees** tabs on Overview (`31`)  

---

## 6. Related

- `18` Dashboard / Team Performance split · `13` Coolors · `29` branding  
