# 71 — Role-based dashboards (FR-02) · UI/UX

**Source:** BRD §4.2 User Roles · §5.2 FR-02 · §5.2.1–5.2.4 · §16 Reporting · §17 Acceptance  
**Wireframe:** `LoginRegister.png` home board = **FA personal** layout only  
**Flutter today:** Preview role + Team pulse + Team hub (members · FA card · group · MDRT) · FA Home unchanged (`71`)  
**Web today:** Overview **Manager View | FTE Employees** (`31`) · Team Performance (`18`) · weighting + hierarchy (`09` `15`)  
**Related:** `01` personas · `02` flows 4–5 · `32` mobile team (HTML) · `34` · `36` `46` Home · `58` Policy KPIs  
**Date:** 2026-08-14

**Ask:** Role-based dashboard. **New UI/UX must be added** (not on Agent Home PNG). Brainstorm everything needed so Flutter (and web gaps) can ship against **BRD**, not a single FA mock.

**Rule:** BRD wins *what* exists and *who* sees it. Wireframe wins *how* the personal Home looks. Frontend **displays API-supplied numbers** — do not invent FYP / weighting / persistency math.

---

## 1. BRD jobs

| BRD | Meaning for UX |
|-----|----------------|
| **§4.2 Dynamic roles** | Menus, KPIs, data, actions follow **assigned role + hierarchy + permissions** — not a static profile. Role change → same account, new visibility |
| **FR-02 header** | Vendor builds **frontend shells**. All calculated values come from KBZ LIFE APIs |
| **§5.2.1 Dashboards** | Shared metric catalog (every level that is allowed to see them) |
| **§5.2.2 Weighting** | Freelance FYP vs Internal FYP — Core applies factors; UI only **toggles the slice** and shows API results |
| **§5.2.3 Freelance Management (Mobile)** | Team Sales Performance: summary Actual vs Target · **Personal Team / Total Group** · MDRT table · drill to FA card |
| **§5.2.4.1 Manager View (Web)** | DM district: proposals · hierarchy filters · FA line table · red flags · Export Excel |
| **§5.2.4.2 FTE Employees (Web)** | Full portfolio: global proposals · full drill-down · K1/K2 persistency · underperformers · full export |
| **§17** | Role-based access works · **correct KPIs for the correct user level** |
| **Mobile vs web** | Field FA / TL / Manager roles → **app**. AM→HOA + Super Admin → **portal**. **Manager roles use both** |

**Not FR-02:** commission **payout** · inventing weighting tables · showing another FA’s personal book to a peer · Super Admin “sales” Home (ops/config, not MDRT).

---

## 2. Roles we actually design for (clusters, not 10 Homes)

BRD titles: FA · Team Lead · AM · SAM · DM · AADM · ADM · SADM · RADM · HOA · Super Admin.

**Do not** ship ten different dashboards. Cluster by **job + data scope**:

| Cluster | Typical titles | Mobile Home | Web landing |
|---------|----------------|-------------|-------------|
| **A · Producer** | FA · producing TL with **no** downline | Personal Home only | Rare; if they open portal → own slice or deny with “Use the Agent App” |
| **B · Coach** | TL / AM / SAM with downline | Personal Home **+** Team pulse + Team hub (`5.2.3`) | Overview **Manager View** scoped to their line |
| **C · District** | DM / AADM / ADM | Same as B (field still sells/coaches) | Manager View · district filters · red flags · export |
| **D · FTE / HOA** | SADM · RADM · HOA · FTE exec | Light personal + team **if** they have a downline; dense BI is **web** | **FTE Employees** view (`5.2.4.2`) |
| **E · Super Admin** | Ops | Not a KPI Home — Profile / config | Devices · announce · product on/off · audit |

**Capability flags** (session, from Core later; mock now):

| Flag | Unlocks |
|------|---------|
| `canSell` | Our Services · quote · e-App (almost all field roles) |
| `canViewOwnKpis` | Commission · own Policy trio · own FYP/APE/MDRT |
| `canViewTeam` | Team pulse · Personal/Total · MDRT table · FA cards |
| `canViewDistrict` | Web Manager View · district proposal pulse |
| `canViewPortfolio` | Web FTE tab · K1/K2 line table · full export |
| `canExport` | Export Excel (web; mobile = later share-sheet) |
| `canAdmin` | Product control, announce setup — **not** on Home |

A producing AM = `canSell` + `canViewOwnKpis` + `canViewTeam`. Hierarchy depth decides whether Total Group shows SAM→AM→FA or only direct FAs.

---

## 3. Two surfaces (both required by BRD)

| Surface | Job | Status |
|---------|-----|--------|
| **A · Mobile personal Home** | Wireframe board · own book · start work | Shipped (`46`) — **role-blind** |
| **B · Mobile Freelance Management** | `5.2.3` team overlay | Spec’d in HTML `32` · **not in Flutter** |
| **C · Web Executive Oversight** | `5.2.4` Manager / FTE | Largely shipped (`31` `18`) — keep; don’t clone onto phone |

**P0 (this Flutter pass):** A stays · **B is new UI** · prototype **role switch** so demos aren’t stuck on FA.  
**P1:** Restore missing **§5.2.1** chips on personal Home without breaking Policy trio (`58`).  
**Web P1:** only if UAT finds Manager/FTE gaps (filters empty, persistency copy, red-flag jump).

---

## 4. What to add (not on LoginRegister Home PNG)

PNG is one FA: greeting · commission · 8 services · Policy Active/Pending/Expired · renewal · promos.

| Extra | Why |
|-------|-----|
| **Role chip** | Header or Profile: `FA` / `AM` / `DM` — user knows which lens is on |
| **Demo role switcher** | Prototype has no Core role API (`37`). Profile → **Preview as** FA / TL / AM / DM so stakeholders can flip Homes |
| **Team pulse card** | Coach+ only · Actual vs Target (APE · FYP · SFYP · Wtd Freelance FYP) · tap → hub |
| **Personal Team \| Total Group** | BRD `5.2.3.1` 1st vs 2nd level — extra UI, required |
| **Team hub screens** | Members list · FA performance card · group hierarchy · MDRT tracker (`32` map) |
| **Red-flag chips** | Below setup % of monthly FYP target — list + FA card (mobile teaser; web table) |
| **Freelance \| Internal** | Weighting mode (`5.2.2`) on **team/web**, footnote “Core applies weighting” |
| **Performance strip** | Own FYP · APE · MoM % · MDRT — BRD catalog; not a 4th Policy tile (`58`) |
| **Empty team** | Producer: no toggle, no pulse. Copy: “Team view appears when you have downline.” |
| **Scope honesty** | Subtitle “Your book” vs “Personal team · 8 FAs” vs “Total group · 42 FAs” |
| **Offline stale** | KPI shells + “Last updated” — never fake live Core (`34`) |

---

## 5. Home composition (pick)

### Options

| Option | Idea | Verdict |
|--------|------|---------|
| A · Swap entire Home by role | Manager never sees services | ❌ BRD: managers still operate in the field |
| B · Two tabs on Home: My work \| My team | Clear jobs | ⚠️ Extra chrome; easy to miss sell grid |
| **C · One Home + modules** | Wireframe stack **always**; Team pulse **if** `canViewTeam` | ✅ **Pick** |
| D · Manager lands on Team hub | Matches `32` “primary landing” | ❌ Fights wireframe + daily sell; hub is a **push**, not a replace |

**Pick C**

```
AppHomeHeader          mark · Welcome · role chip · bell
AppCommissionCard      own commission (hide if !canViewOwnKpis — rare)
Galaxy / services      unchanged if canSell
Policy trio            own book (`46` `58`)
Renewal + promos       own / broadcast

── only if canViewTeam ──
Team pulse             Actual vs Target · Personal | Total · See team >
```

**Do not** add a 5th bottom-nav tab for Team. Entry = pulse card (and optional Profile shortcut).

Producer Home = today’s Flutter. Coach Home = today **plus** pulse. Same pills: Home · Customer · Product · Profile.

---

## 6. Metric catalog — where each number lives

Frontend **displays**. Mock values must look like API fields (2 decimals, commas, `DD-MMM-YYYY`).

| §5.2.1 component | FA Home | Team hub / FA card | Web Manager | Web FTE |
|------------------|---------|--------------------|-------------|---------|
| Policy Count (new + existing active) | Policy row = **status** (Active/Pending/Expired per wireframe). **New** count → Performance strip, not a 4th tile | Team aggregates optional P1 | KPI strip | KPI strip |
| FYP (initial + subsequent, MoM %, vs avg) | Performance strip P1 | Summary card | Charts + table | Charts + table |
| APE / AFYP + MoM | Performance strip P1 | Summary card | Table | Table |
| Due vs Collected (count + amounts) | P1 compact bar or omit if space; **must exist somewhere** — prefer Home alert + Policy due | — | Dual metric | Dual metric |
| Commission (product; UL note) | Commission card (`34` `61`) | Not others’ commission on team list | Optional | Optional |
| K1 / K2 + grace period | Own persistency P2 chip | FA card P1 | — | **Required** line table |
| Persistency count / premium (num/den) | — | — | — | Helper under K1/K2 |
| Road to MDRT (premium / commission) | Own bar P1 below fold | **MDRT tracker table** P0 for coach | MDRT widget | MDRT tabs All / Qualified / In progress |

**K1 vs K2:** BRD body text is duplicated. UX still shows **two** KPIs + “Grace period” cue. Do **not** invent distinct formulas in the app.

**Weighting:** one session mode (Freelance vs Internal) shared by Overview + Team Performance on web (`15`). Mobile team hub uses the **same two labels**. Never a third “vendor weighted” number.

---

## 7. Mobile Team hub (new screens)

Reuse IA from `32`; Flutter-new. Theme = `AppColors.lightPrimary`, not HTML Coolors maroon.

```
Home Team pulse
  └── Team Performance hub
        ├── Segment: Personal Team | Total Group
        ├── Summary card: APE · FYP · SFYP · Wtd Freelance FYP (Actual / Target / %)
        ├── Weighting: Freelance | Internal
        ├── Red flags strip (below target %)
        ├── Team members → FA performance card
        ├── Total Group → SAM / AM lines → members
        └── MDRT tracker → FA row → same FA card
```

| Screen | Job | Primary CTA |
|--------|-----|-------------|
| **Hub** | Scope + health of the line | Open members / MDRT |
| **Members** | Direct (or filtered) FAs · flag · MDRT pill | Open FA |
| **FA card** | One agent: achievement, MDRT, simple trend, persistency P1 | Call / assign task (stub) |
| **Group** | Indirect hierarchy counts | Open a line |
| **MDRT** | All / Qualified / In progress | Open FA |

**Personal Team** = 1st-level direct reports.  
**Total Group** = full downline (SAM sees AMs + their FAs; DM sees SAM/AM/FA). If user has no indirect line, hide Total Group (don’t show a dead toggle).

**Drill-down:** tap name → FA card. That card is **read-only performance**, not “log in as them”.

---

## 8. Flows

### Login → Home (role-aware)

```
OTP / biometric success
  → session.role + hierarchy + flags (prototype: last Preview-as / default FA)
  → DashboardPage rebuilds modules
       ├─ Producer: wireframe Home
       └─ Coach+: Home + Team pulse
```

Never skip personal Home for managers (`§4.2` both operational + supervisory).

### Coach daily (`02` flow 4)

```
Home → Team pulse → Hub
  → Personal Team | Total Group
  → Red flag FA → FA card → task stub
  → MDRT table → FA card
```

### Web executive (`02` flow 5) — already specified

```
Portal login → Overview (role tab default)
  Manager cluster → Manager View
  FTE/HOA → FTE Employees
  → filters → FA table → Export
```

Mobile does **not** recreate Excel or 12-column FA tables.

### Role change (same account)

```
Core updates role
  → next session (or pull-to-refresh) reloads flags
Prototype: Profile Preview-as → immediate Home rebuild · persist in memory (and optional cache)
```

### Logout

Keep Preview-as for demo convenience **or** reset to FA — **Pick: reset to FA** so next tester isn’t stuck as DM. Document on the switcher: “Resets on logout.”

---

## 9. Prototype role switcher (extra, required for demo)

No Core role API (`37`). Without a switcher, FR-02 cannot be reviewed.

| Place | Spec |
|-------|------|
| **Profile → Setting** | Tile **Preview role** (prototype only) · subtitle current `FA` |
| **Sheet** | FA · Team Lead · AM · SAM · DM  (enough to hit Producer / Coach / District). Skip HOA/Admin on mobile P0 |
| **Confirm** | “Home will show this role’s dashboard. Logout resets to FA.” |
| **Home header** | Small chip `AM` so reviewers see the lens |

Not a production settings item — hide or keep behind `PrototypeConfig.enabled`.

**Mock downlines:** each preview role ships a tiny tree in `HomeMockData` / `TeamMockData` so Total Group isn’t empty.

---

## 10. Copy (ENG · P0)

| Place | Copy |
|-------|------|
| Role chip | `FA` · `TL` · `AM` · `SAM` · `DM` |
| Pulse title | Team performance |
| Pulse sub | Personal team · 8 FAs  /  Total group · 42 FAs |
| Toggle | Personal Team · Total Group |
| Weighting | Freelance FYP · Internal FYP |
| Weighting footnote | Weighting is applied by Core. This app displays the result. |
| Summary | Actual vs target |
| MDRT | Road to MDRT |
| Red flag | Below monthly FYP target |
| Empty team | Team view appears when you have a downline. |
| FA card | Individual performance · not their login |
| Switcher | Preview role |
| Switcher body | For prototype review only. Logout returns to FA. |
| Export (web) | Export to Excel · Export full dataset (FTE) |
| FTE tab | FTE Employees |
| Manager tab | Manager View |

Myanmar: P1 with Language page — same keys as other chrome.

---

## 11. What not to do

- Don’t invent FYP / APE / persistency / weighting formulas in the client  
- Don’t replace FA Home with a BI table on a phone  
- Don’t add Team as a 6th tab  
- Don’t show peer FAs’ commission or another agent’s CRM book  
- Don’t give Super Admin an MDRT Home  
- Don’t clone web Excel + 8 hierarchy filters onto mobile  
- Don’t show Personal/Total if there is no downline  
- Don’t treat wireframe Policy trio as the **entire** FR-02 catalog — add Performance/MDRT, don’t smash a 4th Policy card (`58`)  
- Don’t use HTML Concept A maroon (`32`) — Flutter `lightPrimary`  
- Don’t make Preview role a production CORE setting  

---

## 12. Flutter map (when building)

| Piece | Work |
|-------|------|
| `PrototypeRole` / session flags | `canViewTeam` etc. · default FA · persist until logout |
| `DashboardPage` | Insert Team pulse **after** Policy/renewal (or after services) if flag |
| `TeamPulseCard` | Actual vs target · toggle teaser · See team |
| Team routes | Hub · members · FA card · group · MDRT |
| `TeamMockData` | Trees per preview role · red flags · MDRT rows |
| Profile | Preview role tile + identity **role** under agent code |
| Header | Optional role chip next to greeting |
| P1 Performance strip | FYP · APE · MoM · own MDRT bar on Home |
| Web | No Flutter work; note UAT against `31` |

Comment-out unused FA-only bits; don’t delete (`34`).

---

## 13. Phasing

| Phase | Scope |
|-------|-------|
| **P0** | Role flags + Preview switcher · role on Profile · Team pulse · Team hub (Personal/Total, summary, members, FA card, MDRT) · empty producer state · mock data |
| **P1** | Home Performance strip + own MDRT · weighting toggle on hub · red-flag strip · group hierarchy · Due vs Collected teaser |
| **P2** | Bind FR-02 APIs · stale/offline · K1/K2 on FA card · web filter/export polish · MM strings · HOA-only mobile |

---

## 14. Acceptance (brainstorm)

- [x] BRD §4.2 + FR-02.1–02.4 mapped to clusters and surfaces  
- [x] Extra UI listed (pulse, toggles, hub, switcher, red flags, weighting, empty)  
- [x] Wireframe Home kept for everyone who sells; team is overlay not a replacement  
- [x] API-display-only + no 4th Policy tile locked  
- [x] Flutter P0 (await implement)
- [x] Inventory updated

---

## 15. Related

BRD §4.2 · FR-02 · §16–17 · `01` `02` `09` `15` `18` `31` `32` `34` `36` `37` `46` `58` `61` · `DashboardPage` · web `DashOverviewPage`
