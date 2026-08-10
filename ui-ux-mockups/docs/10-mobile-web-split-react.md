# Mobile mockup × React web portal split

**Decision (stakeholder):** Keep **Concept A · Field Momentum** as the mobile HTML mockup only. Retire Concepts B & C. Rebuild the management **web portal** as a separate **React** app. Apply Coolors blue palette across both.

**Palette (Coolors)**  
`#00A6FB` Fresh Sky · `#0582CA` Steel Blue · `#006494` Baltic Blue · `#003554` Deep Space Blue

---

## 1. Why split

| Surface | Audience | Delivery |
|---------|----------|----------|
| **Mobile mockup** | FA field validation (sell / CRM / e-App / tasks) | Static HTML in `ui-ux-mockups/concept-a-field-momentum/` |
| **Web portal** | DM / ADM / managers / ops | React app in `agent-web-portal/` |

Same BRD IA and auth identity model — different codebases so mobile mockups stay fast to review and web can become the real product shell.

---

## 2. Color system (both surfaces)

| Token | Hex | Role |
|-------|-----|------|
| `--sky` | `#00A6FB` | Primary CTA, active tabs, chart series A, links |
| `--steel` | `#0582CA` | Buttons, sidebar active, KPI accents |
| `--baltic` | `#006494` | Headers, secondary buttons, chart series B |
| `--deep` | `#003554` | Text / ink, phone chrome, sidebar base |
| `--surface` | `#F4F8FB` | App background |
| `--card` | `#FFFFFF` | Cards / sheets |
| `--muted` | `#5A7390` | Secondary text |
| `--line` | `#D5E4F0` | Borders |
| `--ok` / `--warn` / `--danger` | green / amber / red | Status only (not brand) |

**Concept tones retired:** emerald×amber (A old), navy×gold (B), charcoal HUD (C).

---

## 3. Mobile mockup scope (HTML)

**Keep**
- Splash → Login → OTP → biometric → forgot
- FA + Manager home
- FR-03 Leads/Clients deep CRM
- Products · **Product detail** (brochure · rates) · Calculator · Save quote · **Start e-App hub** · e-App stepper · Tracker · Policy (see `24`)
- FR-07 Calendar (Day/Week/Month) · create/status · no separate To-Do tab
- Notifications · Announcements · Resources · Profile (ENG/MM)

**Remove from this file**
- Side-by-side web panel (moved to React)

**UX note:** Phone-centered page; gallery points to React portal for web.

---

## 4. React web portal scope

### Shell
- Left sidebar menu
- Header: logo left · profile + sign out right
- Auth gate: login → OTP → forgot (unified with mobile identity)

### Modules (web portal — lean manager IA)
1. **Dashboard** ▾ — **Overview** (KPIs + charts) · **Team Performance** (FA table; was Team line)  
2. **Tasks** — Add / Move / Delete · status (FR-07) · leave appointments   
3. **Management** ▾ — Resource · Notification · Announcement · **Products** (catalog On/Off) · **Devices** (NFR §6 remote wipe)  
4. **Audit** — directory + change log (FR-12)  

*(See `16` / `17` / `18` / `19` / `23` for nav + Management + Dashboard + Devices + Product On/Off UX.)*

### Tech (mock → product path)
- Vite + React + TypeScript  
- CSS variables (palette tokens)  
- React Router for pages  
- Chart.js / react-chartjs-2 for Dashboard  
- Mock data only (no Core API yet)  
- Later: swap mocks for KBZ LIFE APIs; keep shell/layout

### Folder
```
agent-web-portal/          ← NEW (repo root sibling to Flutter + ui-ux-mockups)
  src/
    styles/tokens.css
    layout/AppShell.tsx
    pages/...
    components/...
```

---

## 5. IA continuity (mobile ↔ web)

```
Mobile FA                    Web manager
─────────                    ───────────
Home KPIs (light)     ↔      Dashboard → Overview
Team / FA production  ↔      Dashboard → Team Performance
People CRM            ↔      (field only on mobile · web sees book via Overview)
Sell / e-App          ↔      (field only on mobile · web sees volume via Dashboard)
Work / Tasks          ↔      Task admin Add·Move·Delete
Resources (offline)   ↔      Management → Resource
Push (image + URL)    ↔      Management → Notification
Announce feed         ↔      Management → Announcement (read-only on mobile)
Profile / security    ↔      Header profile + Audit
```

Same login credentials story (mobile number + password + OTP).

---

## 6. Gallery / docs cleanup

- Delete Concept B & C folders  
- Gallery → single mobile concept + link to React portal  
- Docs 06 (3-concept web) superseded by this split + React app  
- Keep FR-03 / FR-07 / unified login / web shell docs as requirements reference  

---

## 7. Acceptance

- [x] Concepts B & C removed  
- [x] Concept A is mobile-only + Coolors blues  
- [x] `agent-web-portal` runs (`npm install && npm run dev`)  
- [x] Web shell: sidebar + header logo/profile  
- [x] Dashboard weighting + bar/line charts  
- [x] Lean nav: Dashboard ▾ · Tasks · Management ▾ · Audit  
- [x] Brainstorm doc published (`10-mobile-web-split-react.md`)  
