# 72 — Team Sales Performance · two roles (FR-02 3.1 / 3.2)

**Source:** FR02_Business Requirement Detail **§3.1 FA** · **§3.2 Leaders Agents** · stakeholder 6-up *Team Sales Performance* (Viber 2026-08-14) · BRD §5.2.3  
**Layout:** 6-up mockups win density / drill-down / gauges  
**Theme:** `AppColors.lightPrimary` (`#00adee`) — **not** mockup red (`32` `34`)  
**Flutter today:** Team hub restyled to 6-up (ring · counts · KPI bars · drill · MDRT Not Yet · My performance) (`72`)  
**Related:** `71` role clusters · `32` HTML team · `46` FA Home · `58` Policy  
**Date:** 2026-08-14

**Ask:** Make **Team Performance** UI/UX *feel like the 6-up*. Cover **both roles** in FR-02 detail. Keep what `71` already shipped; list every extra piece so the next build isn’t a second guess.

---

## 1. Two roles (locked)

FR-02 detail is **not** ten dashboards. It is **two mobile products**:

| | **Role A — FA** | **Role B — Leaders** |
|--|-----------------|----------------------|
| **Who** | Financial Advisor (no downline) | Leaders with hierarchy: **SAM → AM → FA**, plus **DM** (sees SAM and AM teams) |
| **FR-02** | §3.1 Mobile App | §3.2 Mobile **and** Web · Freelance Management Dashboard |
| **Scope** | **Personal performance only** | **Own personal** + **downline** (direct **and** indirect) |
| **Team UI** | **None** — no Personal/Total, no org, no FA list | Full 6-up Team Sales Performance |
| **Home** | Wireframe board (`46`) + §3.1 metric cards | Same personal Home **plus** Team pulse → Team hub (`71` pick C) |

**Same Team chrome for AM / SAM / DM** — only **depth of tree** and **which toggle is useful** change. Do not design a separate “DM app” vs “AM app”.

| Logged-in | Personal Team (1st) | Total Group (2nd) |
|-----------|---------------------|-------------------|
| **AM / TL** | Direct-report **FAs** | Hide Total Group if no indirect line |
| **SAM** | Direct **AMs** | AMs + their FAs |
| **DM** | Direct **SAMs** | SAMs + AMs + FAs |

Tapping a row = **next level**, not “log in as them”. Pagination per level (API later; mock: full list).

---

## 2. Theme + nav (conflicts we already resolved)

| Mockup | App decision | Why |
|--------|--------------|-----|
| Red headers / red bars | **Primary cyan** + green for +MoM | Brand in Flutter is `#00adee`; `32` forbids PNG red |
| Bottom nav: Home · **Team** · Sales · **MDRT** · More | **Keep** Home · Customer · Product · Profile + FAB | `44` `71` — Team is **not** a 5th tab |
| Hamburger on Team | Back + title on stack pages | App already uses stack, not a second drawer |
| Date “30 Aug 2025” | Period chip on Team hub | Needed for Actual vs Target slice |

**Entry (leaders only):** Home **Team pulse** → **Team Sales Performance** (mockup screen 1). FA never sees the pulse.

---

## 3. Screen map (6-up → Flutter)

```
FA Home                         ← Role A only (no Team)
Leader Home + Team pulse        ← Role B
    └── s-team                  Team Sales Performance   (mockup 1)
          ├── Personal | Total
          ├── Overall ring + Actual / Target + MoM
          ├── Hierarchy counts (SAM / AM / FA / MDRT)
          ├── KPI bars APE · FYP · SFYP · Wtd FYP
          ├── View org / Total Group ──────────► s-group     (mockup 2)
          ├── Team members / AM line ──────────► s-line      (mockup 3)
          ├── MDRT ────────────────────────────► s-mdrt      (mockup 4)
          ├── FA row ──────────────────────────► s-fa        (mockup 5)
          └── Analytics (P1) ──────────────────► s-analytics (mockup 6)
```

| ID | Mockup title | Job | Role |
|----|--------------|-----|------|
| **s-team** | Team Sales Performance | Hub · toggle · ring · counts · 4 KPIs | Leaders |
| **s-group** | Total Group | Next-level **lines** (SAM/AM) · trend | SAM / DM (and AM if Total exists) |
| **s-line** | AM 01 – Yangon | One unit · **FA list** · badges · sort by achievement | Any leader who opened a line |
| **s-mdrt** | MDRT Tracker | Ring · All / Qualified / In Progress / **Not Yet** · coach banner | Leaders |
| **s-fa** | FA Performance Detail | One FA · ring · APE/FYP/SFYP/WFYP bars · MDRT card · trend | Leaders (read-only) |
| **s-analytics** | Team Analytics | Sales by level · composition · insights | DM / SAM P1; AM optional |

FA **does not** get s-team…s-analytics. FA **does** get personal MDRT **on Home** (§3.1).

---

## 4. Role A — FA Home (§3.1) vs wireframe

Team Performance mockups **do not** replace FA Home. §3.1 cards still belong on **Home** (and Commission). Gap vs Flutter today:

| §3.1 field | Flutter now | Put it |
|------------|-------------|--------|
| Personal Policy Count **New + Active** | Active / Pending / Expired (`58`) | Keep trio (wireframe). **New** → Performance strip, not a 4th status tile |
| Personal FYP Initial + Subsequent | Missing | Home Performance strip |
| Personal APE / AFYP + % comparison | Missing | Same strip |
| Due vs Collected (count + amounts) | Renewal banner only | Compact Due card or Policy path |
| Product commission | Commission card (`61`) | Keep |
| K1 / K2 persistency (policy count) | Missing | Home persistency pair P1 |
| Road to MDRT progress | Missing | Home MDRT bar P1 |
| Offline cached + **Offline Mode** banner | Not wired | Shared banner (both roles) P1 |

**Interactive:** single-agent view only. No drill to other FAs.

---

## 5. Role B — Leader hub anatomy (mockup 1)

Rebuild `TeamHubPage` to match this stack (cyan, not red):

```
AppBar          Team Sales Performance · bell optional (reuse Home bell — skip 2nd bell)
Identity row    Avatar · name · role (Sales Manager · DM) · period chip
Segment         Personal Team | Total Group     ← hide Total if no indirect
Overall card    Circular % · Actual · Target · +MoM vs last month (API field)
Hierarchy 2×2   SAM n · AM n · FA n · MDRT Qualified n  + “View org chart”
KPI 2×2         APE · FYP · Subsequent FYP · Weighted FYP
                each: amount + % bar (Actual/Target from API)
Shortcuts       Total Group · Team members · MDRT · Analytics (P1)
```

### Own personal card (§3.2)

Leaders still have **personal** metrics. Do **not** dump a second FA Home inside s-team.

| Option | Verdict |
|--------|---------|
| Duplicate all §3.1 cards on s-team | ❌ Heavy |
| **Chip “My performance”** → scroll Home / compact sheet with own FYP·APE·MDRT | ✅ **Pick** |
| Ignore personal on Team | ❌ Violates §3.2 “Manager's Own Personal Performance Card” |

**Pick:** small **My performance** card under identity (own overall % + FYP) · tap pops a sheet of §3.1 fields for **self only**.

### Hierarchy counts

Show **only levels that exist under this user**.

| Viewer | Show |
|--------|------|
| AM | FAs · MDRT Qualified (no SAM/AM cards) |
| SAM | AMs · FAs · MDRT |
| DM | SAMs · AMs · FAs · MDRT |

Caption: Direct vs Direct+Indirect as on mockup.

---

## 6. Drill-down (mockup 2 → 3 → 5)

```
s-team (Total Group)
  → s-group  list of SAM/AM lines
       row: name · region · FA count · Actual/Target · % bar · chevron
       footer: Total Team Trend (Feb–Aug area)  — mock path P0, chart P1
  → s-line   AM/SAM unit
       ring 83% · FA count
       Direct reports sorted by achievement
       row: avatar · name · code · Actual/Target · % · badge
       badges: MDRT Qualified (gold) · MDRT In Progress (primary) · On Track (grey)
       sticky: View FA Performance Trend → s-fa of top FA or trend sheet
  → s-fa     one agent
       ring · 4 metric bars with Actual/Target
       MDRT status card (Qualified 108% / In progress)
       monthly trend (P1)
       Assign task stub (already)
```

**Personal Team** skips s-group: s-team → s-line (this user’s directs) → s-fa.

**API note:** “per-level pagination” — UI: list + load-more later; prototype shows full mock page.

---

## 7. MDRT Tracker (mockup 4)

Upgrade `TeamMdrtPage`:

| Mockup | Spec |
|--------|------|
| Semi-ring | Qualified / total FAs in **current scope** (Personal vs Total) |
| Filters | **All · Qualified · In Progress · Not Yet** (`71` missed Not Yet) |
| Overview 3-up | Counts + MoM on each lane |
| In-progress list | APE vs MDRT goal bar (API fields, not client math) |
| Banner | “Drive More MDRT!” · tap → same list filtered In Progress |

Scope follows the hub toggle. Opening MDRT from Personal Team does **not** mix Total Group FAs.

---

## 8. Analytics (mockup 6) — P1

| Tab | Content |
|-----|---------|
| Sales Performance | Horizontal Actual vs Target by **visible** levels (DM/SAM/AM/FA as applicable) |
| Team Composition | Metric mix + MDRT distribution donuts |
| Key Insights | Bullet copy from API/mock (“APE +8% vs last month”) — **not** a model we invent |

AM with only FAs: skip “Sales by level” DM/SAM bars; show FA vs target only.

---

## 9. Extra UI (needed for a complete story)

| Extra | Why |
|-------|-----|
| Period chip | Mockup date control · slice language |
| Overall ring + MoM | Mockup 1 hero — `71` hub is list-only |
| Hierarchy 2×2 | DM/SAM need SAM/AM/FA counts at a glance |
| Gold / primary / grey badges | Scan MDRT without opening FA |
| Not Yet filter | FR + mockup 4 |
| My performance card | §3.2 own metrics on leader dashboard |
| Breadcrumb / “DM Mg Htet” | Know which level you’re inside after drill |
| Empty Total Group | Hide toggle (already `71`) |
| Offline Mode banner | §3.1 and §3.2 — both roles |
| Org chart | Mockup “View Org Chart” — P1 simple indented list, not a graph lib |
| Sort by achievement | Mockup 3 |
| Red-flag / below target | BRD Manager View; map to grey “On Track” vs amber “Below target” (`71`) |

---

## 10. Flutter now vs this pass

| Piece | `71` P0 | This visual pass |
|-------|---------|------------------|
| Preview role FA/TL/AM/SAM/DM | ✅ | Keep |
| Team pulse on Home | ✅ | Keep; optional mini-ring later |
| Hub toggle + 4 KPI rows | Thin list | **Ring + hierarchy + bars** like mockup 1 |
| Members list | Flat FAs | **Line page** with badges + Actual/Target |
| Group list | Name + FA count | Amount / target / % / trend |
| FA card | Numbers + MDRT bar | **Ring + 4 bars + MDRT card** |
| MDRT | All / Qualified / In progress | Add **Not Yet** + 3-up + banner |
| Analytics | — | P1 |
| FA §3.1 strip | — | P1 on Home |
| Offline banner | — | P1 |

Do **not** throw away routes (`teamHub` · `teamMembers` · `teamGroup` · `teamFa` · `teamMdrt`). Restyle and fill.

---

## 11. Copy (ENG)

| Place | Copy |
|-------|------|
| Hub title | Team Sales Performance |
| Toggle | Personal Team · Total Group |
| Hero | Overall · Actual · Target · vs last month |
| Counts | SAM · AM · FA · MDRT Qualified |
| Org | View org chart |
| Line header | Direct reports (FAs) |
| Badges | MDRT Qualified · MDRT In Progress · On Track · Below target |
| MDRT filters | All · Qualified · In Progress · Not Yet |
| Banner | Drive More MDRT! |
| Analytics tabs | Sales Performance · Team Composition |
| Insights | Key Insights |
| Self | My performance |
| Offline | Offline mode · showing last saved figures |
| FA empty team | (no Team UI) |

---

## 12. What not to do

- Don’t paint the Team module **red**  
- Don’t add a **Team** or **MDRT** bottom tab  
- Don’t give FA the 6-up  
- Don’t let a leader open another person’s CRM / commission wallet  
- Don’t compute Overall % / weighting / MDRT % in the client — display API (mock fields shaped like API)  
- Don’t require a chart library for P0 — rings + linear bars first; area/bar charts P1  
- Don’t replace FA Home services with BI  
- Don’t show SAM/AM count cards to an AM with only FAs  

---

## 13. Phasing

| Phase | Scope |
|-------|-------|
| **P0** | Restyle s-team to mockup 1 (identity · period · ring · counts · KPI bars) · s-group rows with % · s-line FA list + badges · s-fa ring + bars · MDRT + **Not Yet** · breadcrumb · My performance sheet · keep Preview role |
| **P1** | Trend / analytics · org list · FA §3.1 Home strip · Due vs Collected · K1/K2 · Offline banner · period changes mock slice |
| **P2** | Per-level pagination · real FR-02 APIs · MM strings |

---

## 14. Acceptance (brainstorm)

- [x] Two roles: FA §3.1 vs Leaders §3.2  
- [x] 6-up mapped to Flutter screens; layout from mockup, color from app  
- [x] Drill-down DM → SAM → AM → FA  
- [x] Gap vs `71` listed · extra UI listed  
- [x] Flutter visual pass (await implement)
- [x] Inventory updated

---

## 15. Related

FR02 §3.1–3.2 · BRD §5.2.3 · stakeholder 6-up · `71` `32` `34` `46` · `TeamHubPage` · `PrototypeRole`
