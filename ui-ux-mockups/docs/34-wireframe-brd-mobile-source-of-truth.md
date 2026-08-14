# Wireframe × BRD — Mobile Source of Truth

**Roles for this pack:** Senior Mobile Developer (~10y field apps) + Professional UI/UX Designer  
**Sources (priority order):**
1. **BRD** — `15052026 - Agent App Business Requirement Document.pdf` (v2.3)  
2. **Wireframes** — `/Wireframe/*.png` (visual / interaction reference)  
3. **Existing UX docs** — `ui-ux-mockups/docs/01` … `33` (decisions already shipped in mockups)

**Surfaces:** Mobile = `concept-a-field-momentum` · Web = `agent-web-portal`  
**Theme:** Coolors blues only — `#00A6FB` · `#0582CA` · `#006494` · `#003554` (wireframes are blue-aligned; do **not** adopt external red PNG themes)

---

## 1. How we use these sources

| Source | Authority | Use for |
|--------|-----------|---------|
| **BRD** | **Must** | Scope, FR IDs, roles, out-of-scope, NFRs, metrics, workflows |
| **Wireframe/** | **Should** (visual) | Layout density, form patterns, steppers, list/detail, status language, thumb-first CTAs |
| **Mockup docs 01–33** | **Have** | What’s already decided in Concept A / React portal |

**Rule:** If Wireframe and BRD conflict → **BRD wins**. Wireframe shapes *how* we present BRD jobs, not *whether* a feature exists.

**Rule:** If Wireframe shows client-facing / payout / group-entity / full policy admin → **exclude** (BRD §3.2 Out of Scope).

---

## 2. Product frame (BRD)

| Item | Decision |
|------|----------|
| Product name | **KBZ LIFE Agency Sales Digital Platform** |
| Mobile users | FA · Team Lead · Manager roles (field) |
| Web users | AM → HOA hierarchy · Super Admin / ops |
| Languages | **ENG + MM** labels |
| Dates / money | `DD-MMM-YYYY` · amounts 2 decimals + commas |
| Dashboards | Frontend displays **API-supplied** metrics (vendor does not invent calc) |
| Offline | Key mobile actions + encrypted local store + sync honesty |
| Security | OTP · session · device registration · encrypted SQLite/docs · remote wipe · no jailbreak/root |

### Out of scope (never design as Phase 1 primary)

- Full policy admin / financial processing  
- Non-life / health-as-separate-line beyond BRD product set (follow Core product library)  
- Client-facing consumer app  
- Direct commission **payment** processing  
- Group / entity proposal & entity beneficiaries (removed in BRD v2.3)

---

## 3. Wireframe catalog → BRD map

| Wireframe file | Primary BRD | UX job | Mockup / doc status |
|----------------|-------------|--------|---------------------|
| `LoginRegister.png` | FR-01 | Splash · login · OTP · forgot · password rules · error states | Strong in Concept A (`07` `27` `28`) |
| `Calculator(Before login).png` | FR-04 / FR-01 | Guest-ish quote → login gate mid-flow | **Decide** — BRD quoting = authorized; treat as optional “try calculator → sign in to save” |
| `Calculator.png` | FR-04 · FR-05 | Quote inputs · compare · KYC scan · parties · health · confirm · success | Align with sell spine `24` `25` `26` |
| `New Proposal.png` | FR-05 | Product pick · NRC · forms · beneficiary · health · premium · review · success | Same spine; prefer **one** wizard model |
| `One Touch.png` | FR-05 | NRC OCR (optional) · accordion submit · signature · underwriting track | OCR = optional per BRD; keep Skip |
| `Product Info.png` | FR-04 | Catalog categories · detail · Get Quote · apply path | Product detail `24` `25` |
| `Products Premium.png` | FR-04 | Per-product premium parameter screens | Calculator variants by product code — brainstorm `65` |
| `Customer.png` | FR-03 · FR-06 | Customer list · detail · edit · policy accordion · filters | Concept A: **Leads \| Clients** (BRD), not single “Customer” bag |
| `Policy.png` | FR-06 | Policy list · chart · detail · filter sheet | Read-only policy; no admin edit — brainstorm `66` |
| `Task Management.png` | FR-07 | Task create/edit · dates · type · priority · status · attach · complete | Docs `08` `21` |
| `Notification.png` | FR-08 consume · FR-09 | Inbox list by day · detail / deep link | Docs `11` `22` |
| `Agent Profile.png` | FR-11 | Profile · settings · password · FAQ · language · notif toggles · reports | More tab `28` |
| `Comission.png` | FR-02 (display) | Balance / commission history UI | **Phase 1 = product commission display only** — not payout wallet |
| *(implied home in LoginRegister)* | FR-02 | Home KPIs · quick grid · team teaser · campaigns | FA Home + Manager hub `32` |

---

## 4. Conflicts we resolve (professional decisions)

### 4.1 Registration

| Wireframe | BRD | Decision |
|-----------|-----|----------|
| Full self-register form (name, phone, email, NRC) | Mobile number must exist & be active in CORE; else **no** self-register — handle via backend Application List | **Gate first:** check CORE → then set password / OTP. Never open free public signup. |

### 4.2 Primary navigation

| Wireframe pattern | Concept A today | Decision |
|-------------------|-----------------|----------|
| Bottom: Home · Customer · Center FAB · Product · Profile (+ hamburger) | Home · Customers · e-App · Tasks · More | **Keep 5-tab Concept A** (thumb reach + BRD modules). Center FAB optional later for “New quote / New lead”. Hamburger content → **More**. |

Rationale (mobile senior): field agents one-hand; five clear jobs beat sidebar + FAB ambiguity.

### 4.3 Customers vs Leads / Clients

| Wireframe | BRD | Decision |
|-----------|-----|----------|
| Single “Customer” list | Separate **Leads** and **Clients** | Wireframe **list/detail/filter/accordion** patterns apply to both lists; IA stays Leads \| Clients (`05`). |

### 4.4 Commission / “My Balance”

| Wireframe | BRD | Decision |
|-----------|-----|----------|
| Wallet balance + history FAB | Phase 1 **display product commission**; payout processing out of scope | UI = **Commission summary + history** (read-only). Avoid withdraw/cash-out affordances. Label carefully (not “wallet payout”). |

### 4.5 Pre-login calculator

| Wireframe | BRD | Decision |
|-----------|-----|----------|
| Calculate before login | Quoting for authorized users; Core pricing API | **Option A (preferred Phase 1):** calculator only after auth. **Option B (later):** public estimate → Login to Save Quote / Start e-App. Document choice in implementation ticket. |

### 4.6 Policy detail edit pencil

| Wireframe | BRD | Decision |
|-----------|-----|----------|
| Edit icon on policy info | Policy view **read-only** | **No edit** of Core policy fields on mobile. Signature on policy wireframe = e-App / proposal context, not issued-policy mutation. |

### 4.7 Group Life / Entity in premium sheets

| Wireframe | BRD v2.3 | Decision |
|-----------|----------|----------|
| Group Life product cards appear in premium set | Group / entity proposal **out of Phase 1** | Hide Group/entity proposal flows; individual Life & Health products from Core library only. |

### 4.8 Underwriting “30 min / countdown”

| Wireframe | BRD | Decision |
|-----------|-----|----------|
| Live countdown timer | Status tracker: Draft → Submitted → Correction → Approved → Rejected | Show **status timeline** (`26`); avoid fake SLA countdown unless Core provides real ETA. |

---

## 5. Mobile IA (locked for mockups)

```
Bottom tabs
├── Home          FA KPIs · alerts · Manager view entry (FR-02)
├── Customers     Leads | Clients (FR-03) → Policy (FR-06)
├── e-App         Products → Detail → Calculator → Quote → e-App → Tracker (FR-04/05)
├── Tasks         Calendar · To-Do · task detail (FR-07)
└── More          Profile · Notifs · Announce · Resources · Commission display · Log out
                  (FR-08/09/10/11 · commission display)
```

Manager overlay (FR-02.3): Home → **Team performance** (`32`) — Personal Team / Total Group · members · FA card · MDRT.

Web overlay: Overview Manager | FTE (`30` `31`) — not duplicated as mobile-first.

---

## 6. Design system extracted from Wireframes (apply with Coolors)

| Pattern | Wireframe cue | Implementation note |
|---------|---------------|---------------------|
| Primary CTA | Full-width blue bottom button | Sticky footer on forms / wizards |
| Lists | Avatar · title · meta · status pill | Leads, clients, policies, team, MDRT |
| Filters | Bottom sheet · chips · Apply / Reset | Status · product · date |
| Detail | Accordion sections | Policy · e-App review · FA metrics |
| Wizard | Top stepper or spine + sticky Next | Prefer **one** e-App model (`24`–`26`) |
| Capture | Camera frame · Skip · Save | NRC/Passport; OCR optional |
| Status | Color pills (Active / Pending / Expired / Rejected) | Align tokens with Concept A pills |
| Empty / error | Inline field errors · modal success/warn | LoginRegister patterns |
| Profile | Settings rows + Log out confirm | Already `28` |

**Motion:** 2–3 purposeful transitions (screen enter, sheet rise, success check) — no noise.

**Cards:** Use for interactive list rows and KPI clusters; avoid card soup on auth/splash.

---

## 7. FR checklist — design completeness

| FR | Must-have UX | Wireframe refs | Gaps to close next |
|----|--------------|----------------|--------------------|
| **01** Auth | CORE gate · login · OTP · forgot+remark · timeout messaging | LoginRegister | Registration gate copy audit |
| **02** Dashboards | FA metrics · MDRT bar · Personal/Total · MDRT tracker · FA drill | LoginRegister home · team docs | Persistency K1/K2 on mobile (if API) |
| **03** CRM | Leads \| Clients · add/edit · convert · notes | Customer | Family members / activity polish |
| **04** Quote | Library · Core codes · calculator · save · link lead/client | Product Info · Calculator · Products Premium | Per-product param screens fidelity |
| **05** e-App | Prefill · KYC · sign · docs · tracker statuses | New Proposal · One Touch · Calculator | OCR optional path; correction reopen |
| **06** Policy | Search · read-only detail · next due | Policy · Customer | Chart optional; honesty if offline |
| **07** Tasks | Calendar D/W/M · To-Do · assign notifs | Task Management | Calendar density vs list |
| **08** Notifs | Inbox · deep links · types | Notification | Premium due / renewal templates |
| **09** Announce | Read-only feed · optional push image+URL | Notification detail style | Keep separate from FR-08 rules |
| **10** Resources | Sections from web · offline-capable consume | — | Mobile Resources chips; web Offline column hidden (`33`) |
| **11** Profile | Edit · photo · password · legal · help · ENG/MM · product On/Off entry | Agent Profile | FAQ content; language toggle live |
| **12** Agent data | Web audit / sync — mobile reflects approved data | — | Read-only reflection on profile |

---

## 8. Engineering notes (senior mobile)

1. **Single sell spine** — Product → Detail → Calculator → Save quote → Start e-App hub → Wizard → Tracker → Workflow status. Merge overlapping wireframe flows; don’t ship three proposal wizards.  
2. **Offline honesty** — badge + queue; never fake live KPIs/commission when stale.  
3. **Security NFRs** — encrypted DB/files · device bind · remote wipe (web Devices) · TLS · inactivity logout (BRD: 7 days).  
4. **Performance** — screen useful paint &lt; 2s; list virtualization for clients/policies.  
5. **API-bound dashboards** — UI shells only; weighting logic stays server/Core.  
6. **Role dynamism** — menus/KPIs from role+hierarchy at session start; Manager sees Team hub entry.  
7. **i18n** — all chrome strings ENG/MM from day one in production; mockups may stay ENG.  
8. **Accessibility** — 44pt targets · contrast on blue buttons · status not color-only.

---

## 9. Gap backlog (prioritized)

### P0 — Align mockup to BRD + best of Wireframe

- [ ] Auth: CORE-exists gate messaging (no open register)  
- [ ] Commission **display** screen (read-only history) from `Comission.png` patterns — not payout  
- [x] Policy list filters sheet (status · product · date) per `Policy.png` — shipped (`66`)
- [ ] Task create form fields parity with `Task Management.png` (type · priority · attach)  
- [ ] Notification day grouping (“Today / Yesterday / date”)  

### P1 — Sell fidelity

- [x] Per-product premium parameter layouts (`Products Premium.png`) driven by Core product code — P0 schema on existing catalog (`65`); Education/CI catalog P1
- [ ] NRC capture Skip/Save · optional OCR  
- [ ] e-App accordion review + signature canvas polish  

### P2 — Nice / later

- [ ] Pre-login calculator (Option B)  
- [ ] Home campaign carousel (if announce feed covers it, skip duplicate)  
- [ ] Center FAB for New Quote  

---

## 10. Working agreement going forward

When changing mobile UX:

1. Cite **FR-xx** + **Wireframe file** in the new/updated `docs/NN-*.md`.  
2. Prefer Coolors tokens already in Concept A.  
3. Comment-out (don’t delete) when temporarily hiding UI (pattern from `33`).  
4. Update `03-screen-inventory.md` checklist.  
5. Gallery link for any new numbered doc.

---

## 11. Acceptance for this brainstorm

- [x] Dual-role lens stated  
- [x] BRD as primary · Wireframe as visual reference · conflict table  
- [x] Full `/Wireframe` catalog mapped to FRs  
- [x] IA + design patterns + engineering notes + gap backlog  
- [ ] P0 items implemented in Concept A (next build pass)

---

## 12. Related docs

`01` IA · `02` flows · `03` inventory · `05` FR-03 · `07` auth · `08`/`21` tasks · `11`/`22` notifs · `24`–`26` sell/e-App · `27`–`28` splash/logout · `32` team · `33` resource Offline hide · **`35` LoginRegister DRY widgets** · web `10`/`30`/`31`
