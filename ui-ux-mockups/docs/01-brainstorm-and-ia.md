# KBZ LIFE Agent App — UI/UX Brainstorm & Information Architecture

**Source:** Business Requirement Document v2.3 (Agency Sales Digital Platform)  
**Wireframes:** `/Wireframe/` — visual reference (see governing pack **`34-wireframe-brd-mobile-source-of-truth.md`**)  
**Scope of this pack:** End-to-end UI/UX exploration — 3 distinct design directions  
**Audience:** Stakeholders, product, design, engineering

> **Governing update:** For mobile work that must satisfy both BRD and stakeholder wireframes, use **`docs/34`** as the source of truth (BRD wins conflicts; Coolors blues; gap backlog P0–P2).  
> **Prototype (no API):** clickable Splash → Auth → Home demo rules live in **`docs/37`**.

---

## 1. Product understanding (from BRD)

KBZ LIFE Agency Sales Digital Platform has **two connected surfaces**:

| Surface | Primary users | Job to be done |
|--------|---------------|----------------|
| **Native Mobile App** (iOS/Android) | Financial Advisors, Team Leads, Manager roles in the field | Sell, serve, follow up, stay productive offline |
| **Responsive Web Portal** | AM → HOA hierarchy, Super Admin | Monitor hierarchy performance, recruitment, persistency, ops |

**Business goals that must show in UX**
1. Increase sales via fast quoting + e-application  
2. Raise FA productivity via CRM + daily tasks  
3. Drive performance via real-time hierarchical KPIs  
4. Improve retention via premium due / renewal reminders  
5. Boost recruitment via pipeline tracking  

**Hard constraints that shape design**
- Dual language: **ENG + MM**
- Role + hierarchy based visibility (dynamic, not static profiles)
- Offline for key mobile actions (clients, brochures, leads, tasks + sync)
- Security: OTP, biometric optional, device registration, encrypted local DB, remote wipe
- Performance: mobile < 2s, web reports < 5s
- Date: `DD-MMM-YYYY`; amounts with 2 decimals + comma separators
- Out of scope: full policy admin, commission payout, client-facing app, group/entity proposal

---

## 2. Personas & mental models

### P1 — Field FA (primary mobile)
- On the road, intermittent network, sells face-to-face
- Needs: find client fast → quote in < 2 min → start e-app → capture signature/docs
- Anxiety: missing premium dues, incomplete apps, unclear next action
- Success feel: “I closed today” + clear pipeline

### P2 — Team Lead / Manager (mobile + web)
- Coaches team, tracks MDRT, assigns recruitment/tasks
- Needs: Personal vs Total Group toggle, drill to agent card, red-flag underperformers
- Success feel: “I know who needs help before month-end”

### P3 — District / Area / Regional leadership (web-first)
- Multi-level filters, line-by-line FA production, export Excel
- Needs: proposal tracking, persistency K1/K2, target variance alerts
- Success feel: “One screen tells the story of my portfolio”

### P4 — Super Admin / Ops (web)
- Announcements, notification setup, task templates, agent data change audit
- Needs: control + audit trail clarity, not sales chrome

---

## 3. End-to-end journey map (happy path)

```
Register / Login (OTP ± biometric)
        ↓
Home Dashboard (role-aware KPIs + alerts)
        ↓
┌───────────────┬───────────────┬────────────────┐
│ Lead/Client   │ Product &     │ Tasks /        │
│ CRM           │ Quote → eApp  │ Notifications  │
└───────┬───────┴───────┬───────┴────────┬───────┘
        ↓               ↓                ↓
   Client profile   Save quote      Premium due
   activity notes   Start e-App     Renewal 60d
        ↓               ↓                ↓
   Convert lead     KYC / OCR?      Calendar To-Do
   → Client         Signature/Docs       ↓
        ↓               ↓           Complete task
   Policy search    Status tracker
   Policy details   Draft→Submit→…
        ↓
Resource Center / Announcements / Profile (MM⇄ENG)
```

**Manager overlay:** Dashboard → Personal Team / Total Group → MDRT table → Agent card drill-down → Web deep analytics & export.

---

## 4. Information architecture

### 4.1 Mobile primary navigation (5 tabs + overflow)

| Tab | Contains |
|-----|----------|
| **Home** | KPI strip, Road to MDRT, due/renewal alerts, announcements teaser, quick actions |
| **People** | Leads \| Clients (searchable), add lead, convert, profile |
| **Sell** | Product library → Premium calculator → Saved quotes → Start e-App → Application tracker |
| **Work** | Calendar (D/W/M), To-Do, assigned tasks, recruitment tasks |
| **More** | Policies, Resources, Announcements, Notifications center, Profile, Language, Help |

*Rationale:* Separating **People / Sell / Work** matches how FAs think in the field and reduces cognitive load vs stuffing CRM + quoting into one “Sales” blob.

### 4.2 Web portal IA

| Area | Contains |
|------|----------|
| **Overview** | Portfolio summary, red flags, proposal funnel |
| **Performance** | Hierarchical filters, FA line table, APE/FYP/SFYP/Weighted FYP, MDRT, persistency |
| **Recruitment** | Candidate pipeline by dynamic agent statuses |
| **Operations** | Applications, overdue tasks, announcement/notification setup |
| **Admin** | Users/roles visibility, agent data change + audit trail |
| **Resources** | Configurable library sections |

---

## 5. Key screen inventory (must exist in all 3 concepts)

### Mobile
1. Splash / Landing  
2. Registration gate (CORE mobile check messaging)  
3. Login + SMS OTP  
4. Biometric prompt (optional)  
5. Home dashboard (FA)  
6. Home dashboard (Manager — Personal/Total Group)  
7. Leads list + Add/Edit lead  
8. Clients list + Client profile  
9. Product library  
10. Premium calculator (stepper)  
11. Quote summary + Save  
12. e-Application wizard (pre-fill, KYC, beneficiaries, docs, e-sign)  
13. Application status tracker  
14. Policy search + Policy detail  
15. Task calendar + To-Do  
16. Notifications center  
17. Announcement feed (image + URL)  
18. Resource center (offline badge)  
19. Agent profile / language / password / legal / feedback  
20. Offline / sync status states  
21. Empty / error / permission states  

### Web
1. Login / OTP  
2. Executive / Manager dashboard  
3. Hierarchical performance table + filters + export  
4. Target variance red-flag panel  
5. Recruitment pipeline board  
6. Announcement & notification setup  
7. Task management (add/move/delete)  
8. Agent data change + audit trail  

---

## 6. UX principles (shared across concepts)

1. **One primary action per screen** — especially e-App steps  
2. **Hierarchy-safe data** — never show numbers outside role scope  
3. **Field thumb zone** — primary CTAs bottom-safe; search sticky  
4. **Offline honesty** — always show sync state; never fake live KPIs offline  
5. **Alert → action** — premium due taps into client + call/WhatsApp path  
6. **MM/ENG parity** — layout must survive longer Burmese labels  
7. **Trust cues** — encryption/device status visible in Profile, not noisy on Home  
8. **Progressive disclosure** — FA sees sell tools; managers get toggles & drill-downs  

---

## 7. Three concept directions (why they differ)

| | **A — Field Momentum** | **B — Trust & Clarity** | **C — Command Center** |
|--|------------------------|-------------------------|-------------------------|
| **Metaphor** | Sales coach in your pocket | Institutional insurance partner | Performance cockpit |
| **Best for** | High FA adoption, speed of sale | Brand trust, compliance calm | Power managers, KPI culture |
| **Visual** | Emerald + amber energy, bold type, large quick actions | Deep navy + soft gold, airy layout, editorial calm | Charcoal + electric lime accents, dense charts |
| **IA emphasis** | Sell tab + quick actions dominate | Guided flows, clear labels, reassurance | Dashboard density + MDRT race |
| **Risk** | Can feel “salesy” for HOA | Can feel slow for power FAs | Can overwhelm new agents |
| **Recommendation use** | Phase-1 FA pilot | Brand-safe default / mixed roles | Manager web + advanced FA mode |

---

## 8. Success metrics → UX instrumentation ideas

| BRD metric | UX implication |
|------------|----------------|
| 90% weekly mobile active | Home must feel indispensable on day 1 (dues + tasks + quote) |
| 30% less paper apps | e-App completion funnel + draft resume must be frictionless |
| 10% on-time premium | Due alerts with one-tap client contact |
| 100% candidates tracked | Recruitment statuses as visual pipeline, not buried lists |

---

## 9. Recommendation for stakeholder review

1. Walk **Concept A** with field FAs (speed of quote → e-App).  
2. Walk **Concept B** with Agency Sales + Compliance (trust, bilingual, clarity).  
3. Walk **Concept C** with DMs/ADMs on **web** performance & export.  
4. Hybrid likely winner: **B visual system + A mobile IA + C manager analytics patterns**.

Open `../index.html` in a browser to compare all three end-to-end mockups.
