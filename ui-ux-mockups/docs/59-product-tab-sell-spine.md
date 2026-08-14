# 59 — Product tab sell spine (catalog → quote → e-App)

**Source:** `Wireframe/Product Info.png` · `Calculator.png` · `New Proposal.png` · `One Touch.png` · `Products Premium.png` · crops (catalog · detail · Get A Quote · Compare · Policyholder · Scanner · Beneficiary · Health · Premium · Confirm · Success · Underwrite · pickers · search)  
**BRD:** FR-04 Single Product & Quoting · FR-05 Single Product Sales & e-Application  
**Flutter today:** Product tab = catalog → detail → Get A Quote → Save quote → e-App wizard → tracker (`59` shipped).  
**Related:** `24` spine · `25` detail · `04` wizard · `26` tracker · `23` On/Off (not FA catalog) · `34` conflicts  
**Date:** 2026-08-14

**Ask:** Product tab is the sell home. Replace the stub with the wireframe catalog + detail + quote, then one e-App wizard + tracker — **BRD scope**, **wireframe layout**. Add every missing FR-04/05 job so the tab is complete to prototype (no APIs).

---

## 1. What exists vs what the tab must be

| Today | Must become |
|-------|-------------|
| Stub copy + 3 dialogs | Real **catalog** (On products only) |
| No detail | **Product Details** → GET A QUOTE |
| No calculator | **Get A Quote** (FR-04) → **Save quote** |
| No e-App | **One** wizard (FR-05) from saved quote / client |
| No tracker | **App tracker** after submit (not a fake 30‑min clock) |

**Product tab job:** pick a Core product → understand it → get a premium → save it on a Lead/Client.  
**e-App job:** paperwork after a saved quote. Hide the pill nav on quote + wizard (`04`, `44`).

```
Product tab (catalog)
  ├─ Search (in-tab) → optional full search screen
  ├─ Category chips → filtered / grouped cards
  └─ Product card → Product Details
         └─ GET A QUOTE → Get A Quote (calculator)
                └─ Save quote → Quote saved
                       ├─ Start e-App → wizard (hide nav)
                       │     └─ Success → App tracker
                       └─ View quotes / back to catalog
```

---

## 2. BRD jobs that this tab must cover

### FR-04 — lives **in** Product tab

| BRD item | Meaning for UX |
|----------|----------------|
| **Product Library** | Read-only Life & Health catalog. Benefit summary · brochures · rates. **Only related products.** Core **code + name**. |
| **Premium Calculator** | Step/form for **one** product. Client inputs → indicative premium. Core pricing later; mock formula now. |
| **Save Quote** | Persist quote and **link to a Lead or Client**. |
| **Integration** | Prototype: mock catalog + mock premium. No Core API. |

### FR-05 — starts **from** Product (or Customer), not a second Product home

| BRD item | Meaning for UX |
|----------|----------------|
| **Start e-App** | From **saved quote** or **client profile**. Not from a blank calculator. |
| **Pre-fill** | Name · product · premium (and quote fields) locked/shown. |
| **KYC** | Scan/upload NRC for **policyholder · insured · beneficiary**. OCR **optional** — Skip + manual always work. |
| **E-signature** | Client + agent on device. |
| **Document scan/upload** | Camera · National ID · medical if the product needs it. |
| **Status tracker** | Draft · Submitted · Mark for Correction · Approved · Rejected. Searchable list. |

### Out of scope (never as P0)

- Group / **entity** proposal · entity / **company** beneficiary (BRD v2.3)  
- Multi-product basket (wireframe cart with PA **and** UL) — BRD is **single product**  
- Guest calculator before login (`34` Option A)  
- Product **On/Off** control (`23`) — manager/web, not this tab  
- Full policy admin · commission payout · fake UW SLA countdown (`34` §4.8)  
- Three separate proposal wizards (`Calculator.png` + `New Proposal.png` + `One Touch.png`) — **merge into one**

---

## 3. Wireframe → decision (conflicts)

| Wireframe | BRD | Decision |
|-----------|-----|----------|
| Catalog 2-col cards · chips All / Protection / Saving / Travel / Health / Bundled | Library of related Life & Health | **P0 layout = catalog.** Categories = Core lines that exist in mock. **Bundled** only if it is a **single Core product code**. No multi-plan bundle proposal. Hide Group Life. |
| Detail tabs **About · Coverage & Benefit · Eligible** | Brochures + rates + benefit summaries | **Use wireframe tabs** (visual). Put brochure/rates *inside* those tabs — do not ship a second Brochure\|Rates chrome (`25` refined later if needed). CTA = **GET A QUOTE**. |
| GET A QUOTE | Calculator, not e-App | Opens **Get A Quote**. Does **not** open Policyholder. |
| Get A Quote **cart** of 2 products + **Buy** + swap | Single product quote | **No cart.** One product locked from detail. Sticky summary + **Save quote**. Swap icon = **Change product** (back to catalog) — not Compare. **Buy** is not a Core checkout; don’t use that label. |
| **Compare Details** | Not in FR-04/05 | **P1 optional** sales aid (two On products, display-only). Cannot start two e-Apps. No Pin/BUY dual path on P0. |
| Policyholder / Scanner / Beneficiary / Health / Premium / Confirm | FR-05 e-App | **After Save quote.** One wizard, wireframe **forms**. |
| Company beneficiary (Company Name · Address) | Entity OOS | **Do not build.** Person beneficiary only; % must total **100**. |
| Success stepper Proposal → Underwrite → Payment → Policy | Tracker statuses Draft → … → Approved | Success = **Submitted**. Stepper on success = **marketing timeline** only if it maps to tracker; **do not** invent Payment/Policy as e-App steps. Underwrite screen = **tracker status detail**, not a 03:00 timer. |
| Search blue AppBar (“Per” → Personal Accident) | Library search | **P0:** search icon on catalog. **P1:** dedicated search results (blue bar + category heading). |
| Selected card = blue border + top-right dot | — | On **Get A Quote** product chips, yes. On catalog, tap = open detail (dot optional). |
| `Calculator(Before login).png` | Authorized quoting | **Not in this tab.** Logged-in only. |

---

## 4. Screen map (P0 unless marked)

### A. Product tab — Catalog

Match crop: title **Product** · search icon · chips · grouped 2-col cards · pill clearance (`57`).

```
Product                         🔍
[ All ] Protection  Saving  Travel  Health  Bundled

Saving Product
  [ Universal Life ] [ Short Term Endowment ]

Protection Product
  [ Personal Accident ] [ Credit Life ]
```

| Rule | Spec |
|------|------|
| Data | Mock Core list: code · name · line · one-line benefit · icon. **On only.** |
| All | Grouped by line (Saving / Protection / …) |
| One chip | That line only + heading e.g. **Protection Product** |
| Card | Light-blue icon circle · **title** · grey description · white + shadow · radius ~14 |
| Tap | Product Details |
| Empty | “No products” / “No match” — Off products are not listed (`23`) |
| FAB / Profile quote / Home Product tile | Land **here**, not a dialog |

Placeholder copy (“Protects you with coverage for medical expenses” on a Saving card) is wireframe noise — **unique one-liners per product** in mock.

### B. Product Details

```
←  Product Details
[icon]  Universal Life
        one-line benefit

[ About ] [ Coverage & Benefit ] [ Eligible ]

…tab body…

sticky  [ GET A QUOTE ]
```

| Tab | Content (BRD) |
|-----|----------------|
| **About** | Short brochure paragraph · **Who should take** (person / family / employer rows) · **Why buy** (check rows). Employer = *group sales talk*, not entity proposal. |
| **Coverage & Benefit** | Benefit bullets · indicative rate callout · disclaimer *Indicative · final from calculator* |
| **Eligible** | Age band · residency · who can be insured · exclusions teaser |

Hide pill nav **or** keep it — P0: **keep tab** on detail (browse), **hide** from Get A Quote onward.

### C. Get A Quote (FR-04 calculator)

```
←  Get A Quote
Product type   Protection | Saving | Travel | Health | Bundle   ← Saving selected
Product name   Universal Life | Short Term Endowment            ← locked if arrived from detail

DOB * · Variant * · Payment frequency *
Sum Insured * · Monthly Premium · Top-up · Policy term *
Link to *  Lead / Client picker (required to save)

[ summary: Premium (monthly) · product · age · SI · term ]

sticky  [ Save quote ]
```

| Field | Notes |
|-------|-------|
| Type / name chips | Changing type filters names. Changing name = this product (still **one**). If user arrived from detail, pre-select and allow change. |
| DOB | `DD-MMM-YYYY` picker → age derived (read-only) |
| Variant / frequency / term | Dropdowns from mock product params (`Products Premium.png` fidelity = **P1** per code) |
| SI / premium / top-up | Mock: SI editable; premium **computed** (grey if read-only). Don’t live-call Core. |
| Link to | Bottom sheet: search Lead **or** Client. BRD: quote must attach. |
| CTA | **Save quote** (primary). Not Buy. Not Start e-App on first paint (`24`). |

Per-product extra fields (riders, travel dates, health SI bands) = **P1** by product code; P0 uses the UL-style field set as the default template.

### D. Quote saved

- Ref `QT-2026-0814` · person · product · SI · premium · mode · date  
- Primary: **Start e-App** (hub with this quote selected → wizard step 1)  
- Secondary: View quotes · Back to Products  

### E. Saved quotes list (Product overflow)

Chip/row from catalog header (optional P0 strip): **Quotes**. Same list as Lead/Client quotes later. Empty: “Save a quote from GET A QUOTE.”

### F. e-App wizard (FR-05) — hide pill nav

**One** model. Wireframe **screens** = steps (clearer for this pack than abstract 1–6 labels). Save draft every step.

| Step | Screen | Job |
|------|--------|-----|
| 1 | **Policyholder** | Full PH form (name · mobiles · ID type NRC/Passport · NRC parts · email · father · DOB · age calc · height · weight · occupation · town / township / state · address). **Same as Life Assured** checkbox. Secondary ID optional. |
| 2 | **Life Assured** | If not same as PH: same field pattern. Else skip to scanner. |
| 3 | **Life Assured Scanner** | NRC \| Passport · viewfinder · shutter · **Skip** · **Save**. OCR optional — never block. |
| 4 | **Beneficiary** | Person fields · relationship · % · ADD MORE. Summary cards Edit / Delete. Total **= 100%** before Next. **No company form.** Guardian ID if age &lt; 18. |
| 5 | **Health Declaration** | High-risk Yes/No · Remark if Yes. Extra medical questions = P1. |
| 6 | **Premium Information** | Quote snapshot **locked** (change = back to calculator). Discounts stub optional. CONFIRM. |
| 7 | **Confirm & Submit** | Accordions: PH · Insured · Beneficiary · Health · Policy. **Upload or Signature** (client + agent). Submit. |

Reuse: outlined `AppTextField` · gender/ID segmented control with blue corner dot · grey disabled Age.

**Pickers (sheets, reusable):**

| Sheet | Columns |
|-------|---------|
| Height | ft · in · unit `ft-in` |
| Weight | whole · decimal · unit `lb-oz` (or kg if product later says so — mock follows PNG) |
| Identification | NRC / Old NRC / Passport / No ID · then NRC State · Township · Type · number |

### G. Success

- Confetti + green check · “Your proposal has been successfully submitted.”  
- Status **Submitted** · app ref  
- **PROPOSAL** → quotes / catalog · **TRACKING** → App tracker row  
- Share = stub  
- Fix wireframe typo **PROPOASAL** → **PROPOSAL**  
- Do **not** show a live 03:00 underwriting timer

### H. App tracker (FR-05)

- Searchable list · chips All / Draft / Submitted / Correction / Approved / Rejected  
- Draft subtitle: step name (`04`)  
- Submitted/Approved/Rejected → status detail **timeline** (`26`)  
- Correction → reopen failing step  
- Entry: Success · catalog chip **Tracker** · Home service if already linked  

Underwriting Stage PNG = this **status detail**, copy about “review in working hours” without a fake countdown.

### I. Compare Details — P1 only

Side-by-side Feature table · Pin · **no** dual BUY. Optional “Use this product” → Get A Quote for **one** code.

### J. Search screen — P1

Blue AppBar · pill search · results grouped by line. P0 can filter the in-tab catalog instead.

---

## 5. Cross-app entries (must not stay as dialogs)

| From | After this pass |
|------|-----------------|
| Product tab | Catalog |
| Home Our Services **Product** / **Calculator** | Catalog / Get A Quote (if last product known, else catalog) |
| Profile **Create New Quote** | Catalog |
| FAB **New Proposal / Quote** | Catalog (or last product’s Get A Quote) |
| Customer / Lead **Quote** later | Get A Quote with person pre-linked |
| Customer / Lead **e-App** later | Start e-App hub (need a saved quote) |

---

## 6. What not to do

- Don’t leave the three stub tiles as the Product tab  
- Don’t put Policyholder before Save quote  
- Don’t ship a 2-product cart or company beneficiary  
- Don’t use **Buy** as if Core takes payment here  
- Don’t start e-App from detail GET A QUOTE  
- Don’t show Off / Group-entity products  
- Don’t duplicate three wizards  
- Don’t put Product On/Off switches on this tab  
- Don’t fake Core pricing or UW ETA  

---

## 7. Prototype data (no API)

| Mock | Example |
|------|---------|
| Catalog | Universal Life (Saving) · Short Term Endowment (Saving) · Personal Accident (Protection) · Credit Life (Protection) · one Health · one Travel |
| Counts | Independent of Home Policy 20/10/5 |
| Quote | UL · DOB 04-Jun-1999 · age 26 · SI 30,000,000.00 · monthly 50,000.00 · term 5 years · variant 5 Plus 100 |
| Person | May Chan Myae · 09 750337968 · 12/KaMaNa(N)… — **link to an existing Customer mock**, don’t invent a second CRM |
| Dates / money | `DD-MMM-YYYY` · 2 decimals + commas |

Validation: required `*` · local only · fake short delay on Calculate/Save/Submit (`37`).

---

## 8. Flutter map (when building)

| Piece | Where |
|-------|--------|
| Replace stub | `lib/features/home/presentation/pages/product_hub.dart` → catalog |
| New feature folder | `lib/features/product/…` (catalog · detail · quote · quotes list · tracker) |
| Wizard pages | `lib/features/product/presentation/pages/eapp/…` or `eapp/` — hide `AppBottomNavBar` |
| Mock | `product_mock_data.dart` |
| Pickers | Shared sheets next to `AppTextField` |
| Routes | `go_router` pushes from Product tab; don’t add extra bottom-nav indices |
| Entries | Profile / FAB / Home tiles → catalog route, drop info dialogs |
| i18n | ENG strings first; MM keys when wiring `AppLocalizations` (parity P1) |

Comment-out stub tiles; don’t delete until catalog ships.

---

## 9. Build order (so the tab feels complete)

| Pass | Ship |
|------|------|
| **P0a** | Catalog + Details + GET A QUOTE → Get A Quote + Save quote + Quote saved |
| **P0b** | Wire FAB / Profile / Home tiles to catalog; quotes list chip |
| **P0c** | e-App steps 1–7 + Skip scanner + % = 100 + Confirm & Submit + Success + Tracker list |
| **P1** | Search screen · Compare · per-product calc fields · signature canvas polish · OCR stub banner · height/weight sheets (if P0 used simple text) — **shipped** `60` |
| **P2** | Pre-login calculator · brochure PDF viewer · real Core |

---

## 10. Acceptance

- [x] Brainstorm documented (this file)  
- [x] Product tab = catalog (not stub tiles)  
- [x] Details tabs + GET A QUOTE  
- [x] Single-product calculator + Save quote linked to Lead/Client  
- [x] One e-App wizard from saved quote; OCR Skip; person beneficiaries 100%  
- [x] Tracker with five BRD statuses; no fake UW timer  
- [x] No cart · no entity beneficiary · no Buy checkout  
- [x] Pill nav hidden on quote + wizard  
- [x] Inventory updated  

---

## 11. Related

`24` `25` `04` `26` `23` `34` · FR-04 · FR-05 · Product Info · Calculator · New Proposal · One Touch  
