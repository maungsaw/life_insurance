# ProtoType 2 — alternate UI/UX (vs ProtoType 1)

**Status:** ✅ Option **A · Ink Desk** P0 + **P1** shipped (`KBZ Mobile ProtoType 2/`)  
**Canvas:** `prototype-2-alt-ux-brainstorm.canvas.tsx`  
**Flow reference:** `KBZ_UI&UX/Wireframe1` · `Wireframe2` (jobs only)  
**Skin:** Ink `#0E141B` · teal `#2DD4BF` · IBM Plex · outline Phosphor · hairline panels · diamond FAB · push gates  

---

## Shipped

| Phase | Files |
|---|---|
| **P0** | `tokens.css` · guest · login · desk shell · products stub |
| **P1** | `personal-accident.html` · `get-quote.html` (3-step) · `policyholder-form.html` (6-step + tracker) · desk: CRM · Policies · Tasks · Inbox · Team · wired tools |
| **P1.5** | `after-login.html`: Announcements (FR-09) + Resource Center (FR-10) — reachable from Profile row-links and `#announce` / `#resources` QA chips |

Gallery: ProtoType 2 cards **01–08**. ProtoType 1 untouched.

## Still optional P2

SAM/DM tree depth · drafts hub sheet · offline CRM sync polish · MM copy

---

## Decision

**A** — Ink Desk ✅


---

## Why a second line

| Line | Role in demos |
|---|---|
| **ProtoType 1** | Cream · Coolors · soft cards · sheets · Phosphor fill — current “brainstorm skin” |
| **Wireframe PNG** | Stakeholder board — white/light-blue Material, My Balance, icon grids |
| **ProtoType 2 (new)** | A **third visual language** so reviewers aren’t stuck choosing only “cream vs PNG clone” |

ProtoType 1 stays untouched. ProtoType 2 lives in a **new folder**.

---

## Layers (locked)

| Layer | Owner | ProtoType 2 rule |
|---|---|---|
| **Flow / jobs** | Wireframe1 + Wireframe2 | Same destinations & order |
| **IA labels** | Negotiated | Bottom labels stay **Home · Customer · FAB · Product · Profile** (BRD shell) unless Option B opts into wireframe alt nav for a **demo-only** branch |
| **Skin + chrome** | This brainstorm | **Must feel alien** next to ProtoType 1 |

### Wireframe jobs to keep (not their pixels)

1. Guest → Login/Register → OTP / Forgot → Home  
2. Home tools: Proposal · Product · Calculator · Commission · Status · Claim · CRM · Online  
3. Sell: Library → Product info → Calculator → draft / e-App  
4. One Touch / e-App steps → Success → UW track  
5. Customer · Policy · Profile · Tasks · Notifications · Commission  
6. Guest locks → login gate  
7. FA vs Leader modules (pulse / team) — same flags as ProtoType 1, restyled  

### ProtoType 1 traits to **forbid** in ProtoType 2

- Cream field `#F7F3EC` / soft-card `#FFFcf7`  
- Coolors Sky→Steel→Baltic→Deep as the **primary** family  
- Rounded floating soft cards + bottom sheets with pill handle as default  
- Phosphor **fill** as the only icon style  
- Same “This month” KPI mosaic + MDRT pill panel chrome  
- Same phone-frame QA chrome copy/layout (can share idea; not twin UI)

### Wireframe traits to **forbid** as the whole skin

- Pure white + Material outlined fields as the default app  
- Multi-color illustrative service icons on white tiles  
- Cloning My Balance blue card 1:1  

---

## Three skin options (pick one)

### A — **Ink Desk** (recommend)

**Feel:** Agent cockpit / field ledger. Dense, calm, high-contrast. Not banking cream, not Material white.

| Token | Value |
|---|---|
| Field | Ink `#0E141B` · panels `#161E27` |
| Text | Paper `#E8EDF2` · muted `#8B9AAB` |
| Accent | Signal teal `#2DD4BF` (CTAs, active, success edge) |
| Warn | Amber `#F5A524` · danger rose `#F43F5E` |
| Type | **Instrument Sans** or **IBM Plex Sans** + **IBM Plex Mono** for money/KPIs |
| Icons | Phosphor **regular/bold outline** (not fill) |
| Radius | 6–10px (sharp-ish) · almost no “pillow” cards |
| Elevation | Hairline `1px` borders · no multi-layer shadows |
| Motion | Fast 180ms fades · list slide; **no** slow sheet rise |

**Chrome differences**

- App bar: wordmark text + mono agent code · bell as outline  
- Home hero: **full-bleed ink band** with mono “726,080 MMK” (commission/balance job from wireframe) — not ProtoType 1 three-tile mosaic  
- Tools: **horizontal chip rail** or **list with left accent bar**, not 3+2 soft tiles  
- Nav: flat ink bar · FAB = square/diamond teal (wireframe diamond nod) · active = teal underline, not filled pill  
- Forms: underline / flush fields on dark panels  
- Overlays: **full-screen push** or edge drawer (not cream bottom sheet)  
- Empty: mono “—” + one line copy  

**Why distinct:** Dark ↔ cream · outline ↔ fill · list/rail ↔ soft grid · push ↔ sheet.

---

### B — **Board Studio** (wireframe-near · still not ProtoType 1)

**Feel:** Light studio that **honors Wireframe1/2 density** for stakeholders who want “looks like the board,” but cleaned (one blue, no random icon rainbow).

| Token | Value |
|---|---|
| Field | `#F4F7FA` (cool grey-white — **not** cream) |
| Surface | Pure `#FFFFFF` with **flat** borders |
| Brand | Wire-adjacent `#1B6BFF` (or KBZ LIFE blue from PNG) · Deep navy text `#0B1F3A` |
| Type | **Plus Jakarta Sans** |
| Icons | Duotone / two-tone line icons (fixed palette only) |
| Radius | 12px consistent  
| Nav | Closer to wireframe: white bar · round FAB  

**Chrome differences**

- Home: **My Balance**-style primary number (wireframe job) + 2×4 service grid (labels match Wireframe2)  
- Promo: large horizontal cards with real illustration slots  
- Sheets OK, but **white** panels + blue primary (not cream soft)  

**Why distinct from P1:** Cool grey-white ↔ cream · Balance hero ↔ This-month mosaic · 8-up grid ↔ Available/Tools split.  
**Risk:** Closest to PNG — use only if demos need “board familiarity.”

---

### C — **Split Day** (editorial dual-tone)

**Feel:** Morning field kit. Split composition — warm paper content + deep header band (not full dark app).

| Token | Value |
|---|---|
| Header band | Deep forest `#12352B` (not Coolors Deep blue) |
| Body | Warm paper `#F3EDE3` — **different hex & role** from P1 cream (only under header; cards are **flush rows**, not soft-card shadows) |
| Accent | Coral `#E85D4C` CTAs (not sky blue) |
| Type | **Fraunces** display (sparse) + **Source Sans 3** UI — display only on guest/hero |
| Icons | Custom simple line · 1.5px stroke |
| Pattern | Top 38% immersive band · bottom scroll is **sectioned lists with rules** |

**Chrome differences**

- Guest: full-bleed partner band + single Login CTA (hero budget: brand + one line + CTA)  
- Home: forest KPI band · then rule-separated tool list  
- Nav: floating capsule **above** content edge (not ProtoType 1 inset bar)  

**Why distinct:** Forest/coral ↔ Coolors blue · editorial split ↔ uniform cream phone.  
**Risk:** Display serif must stay sparse (hero only) or it drifts “AI brochure.”

---

## Comparison matrix

| Dimension | ProtoType 1 | Wireframe PNG | **A Ink Desk** | B Board Studio | C Split Day |
|---|---|---|---|---|---|
| Field | Cream | White | Ink dark | Cool grey-white | Paper + forest band |
| Primary accent | Coolors blue | Light blue | Teal | Board blue | Coral |
| Cards | Soft float | Material tiles | Hairline panels | Flat white | Flush rows |
| Home KPI | This month mosaic | My Balance | Mono big number | My Balance-like | Forest band stats |
| Tools | Available + Tools | 8-up icons | Chip rail / list | 8-up cleaned | Rule list |
| Overlay | Cream sheet | Dialogs | Full push / drawer | White sheet | Push + band |
| Icons | Phosphor fill | Mixed color | Outline | Duotone fixed | Line |
| Closest risk | — | — | “Too fintech dark” | “Too PNG” | “Too brochure” |

---

## Screen map (same flow · new chrome)

Ship ProtoType 2 as parallel files (names can match for mental map):

```
KBZ Mobile ProtoType 2/
  before-login.html
  login.html
  after-login.html      ← home · CRM · policies · profile · tasks · notifs · team
  products.html
  personal-accident.html
  get-quote.html
  policyholder-form.html
  tokens.css            ← shared A/B/C tokens for that pick
```

| Wireframe journey | ProtoType 2 expression (any option) |
|---|---|
| Before login | Guest locks · partner CTA · same 8 jobs (layout per skin) |
| Login / Register / OTP | Full auth branch · skin-native fields |
| Home | Balance/commission job + tools + promo · role chip · team pulse if Leader |
| Product → PA → Quote → e-App | Same spine · wizard chrome matches skin |
| Customer / Policy | List → filter → detail |
| Profile / Tasks / Notifs / Team | Same modules ProtoType 1 already proved · restyle only |

**Do not** invent new FR jobs in v1 of ProtoType 2 — parity first, then polish.

---

## UX grammar differences (beyond color)

| Pattern | ProtoType 1 | ProtoType 2 (esp. A) |
|---|---|---|
| Hierarchy | Soft card stacks | Type scale + rules / accent bars |
| Primary action | Deep filled pill button | Teal block / square CTA |
| Secondary | Ghost on cream | Outline on ink |
| Feedback | Toast bottom | Toast top edge **or** inline banner |
| Offline | Strip under header | Corner “OFFLINE” mono badge |
| Drafts | Notebook badge | “DRAFTS” text chip in app bar |
| Empty | Soft empty-state card | Centered mono empty |
| Leader team | Soft pulse card | Ink pulse with teal ring |

Nav **labels** stay fixed for Option A & C.  
Option B may add a **QA toggle**: “Wireframe nav labels” (Task / Notification) for PNG walkthroughs — default still BRD five.

---

## What not to do

- Don’t fork ProtoType 1 and only recolor variables — structure must change (hero, tools, overlays, type)  
- Don’t mix cream soft-cards into Ink Desk  
- Don’t use purple glow / glassmorphism / emoji decoration  
- Don’t ship ten Homes — FA / Leader flags same as ProtoType 1  
- Don’t rename bottom-nav for production path (A/C)  
- Don’t make ProtoType 2 block ProtoType 1 demos — gallery lists **both**  

---

## Gallery & docs

- Gallery section: **ProtoType 1** · **ProtoType 2** (clear A/B)  
- Doc: this file + canvas  
- Later: short `prototype-2-ux-plan.md` after decision  

---

## Phasing (after pick)

| Phase | Scope |
|---|---|
| **P0** | tokens + before-login · login · after-login Home (+ nav) · products stub — enough to flip vs P1 |
| **P1** | Calculator · e-App · CRM/Policy · Profile · Tasks |
| **P2** | Notifications · Team/Leader · drafts · offline parity |

---

## Decision

Reply with a letter:

- **A** — **Ink Desk** (dark ledger · teal · outline · push) — recommend · max distance from ProtoType 1  
- **B** — **Board Studio** (wireframe-near light · cleaned) — for PNG-familiar demos  
- **C** — **Split Day** (forest band · coral · editorial)

Then scaffold `KBZ Mobile ProtoType 2/` and ship P0 in that skin.
