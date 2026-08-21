# Wireframe flow × Brainstorm UI skin

**Canvas:** `wireframe-flow-ui-skin-brainstorm.canvas.tsx`  
**Sources:** `KBZ_UI&UX/Wireframe1` · `Wireframe2` · HTML in `KBZ Mobile ProtoType 1/`  
**Rule:** Keep **their journeys / screen order / jobs**. Keep **our cream · Coolors · soft cards · sheets · Phosphor · shared nav**. Do not clone wireframe white/blue Material look.

---

## North star

| Layer | Owner | Do |
|---|---|---|
| **Flow** | Stakeholder wireframes | Same destinations, steps, and business jobs |
| **Skin** | Our brainstorms | Cream `#F7F3EC`, Sky/Steel/Baltic/Deep/Mint, soft cards, sheets, motion |
| **IA** | Negotiated | Bottom nav stays **Home · Customer · FAB · Product · Profile** |

Visual mismatch is expected and OK. Flow mismatch is the gap to close.

---

## What we keep from wireframes (flow only)

1. **Guest → Auth → FA home** (Partner unlock → Login/Register → This month / tools)
2. **Auth branches:** Login · Register · OTP · Forgot → new password
3. **5-tab shell** with center FAB
4. **Home service map:** Proposal · Product · Calculator · Commission · Proposal status · Claim · CRM · Online (or Tools equivalent)
5. **Sell path:** Product library → product info → Calculator / Premium → draft or e-App
6. **e-App / One Touch path:** Product → ID scan (optional/skip) → Policyholder → Insured → Beneficiary → Health → Premium confirm → Submit → Success → Underwrite tracking
7. **Customer path:** List → search/filter → Details → policies → policy detail (accordions)
8. **Policy path:** List (+ status sense) → filter sheet → detail accordions · signature
9. **Profile path:** Identity · Create quote CTA · settings (edit · password · FAQ · language · notifications · logout) · reports/commission as secondary
10. **Task path:** Calendar views + task detail (Agent Info / Training) for FR-07
11. **Offline / drafts** as agent jobs (our Option A notebook is skin; job stays)

---

## What we keep from our UI (skin only)

- Cream field · soft cards · Coolors blues · mint success · warn amber  
- Brand mark flush squircle · username in app bar (no competing avatar)  
- Sheets for hubs (drafts, gates) · toasts · offline strip below chrome  
- Phosphor fill icons · identical bottom nav chrome  
- Product catalog clean; drafts via app-bar notebook + badge (Option A)  
- QA toggles outside the phone  

---

## Gap map (flow coverage)

| Wireframe journey | Prototype today | Gap |
|---|---|---|
| Guest home + services + promo | `before-login.html` | Strong · map icons to wireframe labels if demos need 1:1 names |
| Login / OTP / biometric | `login.html` | Strong · Register + Forgot full branch thin |
| FA home KPIs + tools | `after-login.html` | Strong · Commission / Claim / Proposal status / Online as deep screens missing |
| Product grid + filters | `products.html` | Strong · drafts hub A · Product Info depth = PA only |
| Premium / Calculator | `get-quote.html` | Strong · Compare-plans step missing · multi-product premium variants thin |
| New Proposal / One Touch | `policyholder-form.html` + PA | Partial · **NRC scan · Health · Confirm accordion · UW tracking** missing |
| Customer list → detail | `#customer` | Partial · detail / filter modal / policy-from-customer shallow |
| Policy list → detail | `#policies` | Partial · chart optional · accordion detail + signature thin |
| Agent Profile suite | `#profile` | Partial · settings OK · Create Quote hero + report chart thin |
| Task Management | `#tasks` | Partial · timeline OK · **task detail form** (Agent/Training) not wired |
| Commission / Notification | Wireframe1 | Missing as dedicated screens |
| Success + Underwrite timer | One Touch / Calculator | Missing after submit |

---

## Reconciliation options (pick direction)

### R1 — Flow-first backlog (recommend)
Ship missing **steps** in our skin, not pixel clones. Priority:

1. **Sell spine complete:** Product → Calculator → draft hub → e-App steps → Success → Tracking stub  
2. **Auth complete:** Register + Forgot password screens (same skin as login)  
3. **Customer / Policy depth:** Detail + filter sheet + accordion blocks  
4. **Home tools:** Commission · Proposal status · Claim as real destinations (even stub)  
5. **Task detail:** Open from timeline → Agent Info / Training form  
6. **Optional:** NRC scanner screen (Skip allowed) · Compare plans · Profile report chart  

### R2 — Demo spine only
Only wire what stakeholders walk in one sitting: Guest → Login → Home → Product → PA → Quote → e-App → Success. Defer CRM/Policy/Commission depth.

### R3 — Label alignment pass
No new screens; rename Tools / sections to wireframe names (New Proposal, Proposal Status, etc.) so demos “feel” aligned. Fastest; weakest for real flow gaps.

---

## Skin translation cheat sheet

| Wireframe pattern | Our pattern |
|---|---|
| White bg · bright blue fills | Cream · Deep/Steel text · Sky accents |
| Dense Material forms | Soft-card sections · step fade · one primary CTA |
| Drawer + bottom nav | Bottom nav only (no drawer in phone) |
| Inline draft lists | App-bar notebook · badge · hub sheet |
| “My Balance” hero | **This month** KPI / Partner unlock (FR-aligned) |
| Confetti success | Mint check · soft card · calm motion |
| Filter dialogs | Bottom sheet · cream handle · Apply/Reset |

---

## Decision needed

Reply with a letter:

- **R1** — Full flow-first backlog (skin stays ours)  
- **R2** — Demo spine only  
- **R3** — Labels/names pass only  

Or combine (e.g. **R2 then R1 phase 2**). After you choose, next implement pass starts from that list.

---

## Status · R1 in progress

**Chosen:** R1 (continued from user “ဆက်လုပ်ပေးပါ”)

### Shipped this pass
- **e-App spine** (`policyholder-form.html`): 6 steps — Customer → Insured/Ben → **Health** → Docs (+ optional **NRC scan** Skip) → Signatures → **Confirm accordions** → Success pipeline → **UW tracking** stub  
- **Home tools** (`after-login.html`): Commission · Claim · Online sheets wired; Proposal Status / New Proposal already deep-linked  
- **Auth:** Register + Forgot already present on `login.html` (no change)

### Shipped · R1 slice 2
- **CRM:** Filter sheet (status · product) · Customer details + Phone/Email/Profile · Profile details sheet  
- **Policies:** Filter sheet (status) · Accordion policy detail  
- **Tasks:** Tap → Task detail (Agent Info / Training) · Create · Task filter  
- **Profile:** Create New Quote · premium/commission chips · Commission report chart  
- **Calculator:** Compare details step before quote review  

### Still open (later)
- Deeper Notification settings / Language pickers as full screens  
- Leaders team dashboard  
- Real Core-backed data (prototype remains stubbed)  
