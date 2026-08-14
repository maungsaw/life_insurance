# Mobile Home (FA) — UI only, no API

**Roles:** Senior Mobile · UI/UX  
**Sources:** `Wireframe/LoginRegister.png` (home board) · BRD FR-02 · `34` IA  
**Code:** `lib/features/dashboard/` + shared `lib/features/components/`  
**Data:** **Mock only** — no Core / commission / KPI API yet

---

## 1. Ask

After auth UI, ship a **Home** that looks production-ready for demos: wireframe layout + BRD FA dashboard jobs, using DRY widgets and mock numbers. API wiring comes later.

---

## 2. Jobs on Home (FR-02 FA)

| Job | UI block | Wireframe cue |
|-----|----------|---------------|
| Orient agent | Header · name · period · bell | Profile row |
| See earnings snapshot | **Commission** card (display only) | “My Balance” → relabel (no payout) |
| Start work fast | Service / quick-action grid | Our Services |
| Track production | KPI chips · MDRT progress | Team / stats area |
| Spot trend | Simple chart (mock) | Performance graph |
| Stay informed | Announcements / promo strip | News & Campaigns |
| Manager path | Soft entry to Team performance | Manager overlay (`32`) |

**Not on Home Phase 1:** withdraw/cash-out · live Core sync · fake underwriting countdown.

---

## 3. Screen composition (top → bottom)

```
AppHomeHeader          greeting · avatar · period chip · notif
AppCommissionCard      MMK · MoM delta · “View details” (stub)
AppServiceGrid         2×3 or 3×2 tiles → tab / stub routes
AppSection · KPIs      new policies · active · FYP% · MDRT bar
AppSection · Trend     mock sparkline / bar (existing chart OK)
AppSection · Alerts    premium due / renewal teaser (mock)
AppPromoCarousel       announce-style cards (mock)
AppSoftBanner          Team performance (managers)
```

Bottom tabs (keep shell; label **More** for profile):  
`Home · Leads · Customers · Tasks · More`  
(e-App as dedicated tab = later IA pass per `34`)

---

## 4. DRY widgets

| Widget | Responsibility |
|--------|----------------|
| `AppHomeHeader` | Greeting + avatar + actions |
| `AppCommissionCard` | Gradient summary · eye toggle · delta |
| `AppServiceTile` / `AppServiceGrid` | Icon + label + onTap |
| `AppSectionHeader` | Title + optional trailing link |
| `AppKpiTile` | Compact metric |
| `AppMdrtBar` | Road to MDRT progress |
| `AppPromoCarousel` | Horizontal promo cards |
| `AppSoftBanner` | Tappable insight / manager entry |

Mock model: `HomeMockData` in dashboard (swap for repository later).

---

## 5. Copy & branding rules

- Primary = `AppColors.lightPrimary`  
- Amounts: `726,080.00 MMK` style (2 decimals + commas)  
- Commission card title: **Commission** (not “Wallet” / “Withdraw”)  
- Empty API: show mock + subtle “Sample data” only in debug if needed — default clean demo  

---

## 6. Acceptance

- [x] Brainstorm documented  
- [x] Home rebuilt with mock data + DRY widgets  
- [x] Login → Home still works  
- [x] Bottom nav Home tab shows new dashboard  
- [ ] Bind FR-02 APIs  
- [ ] Real notif inbox route  
- [x] Team performance Flutter screen (`32` parity) — hub shipped in `71`  

---

## 7. Related

`34` source of truth · `35` auth widgets · `32` team · FR-02 · `Wireframe/LoginRegister.png` · `Wireframe/Comission.png`
