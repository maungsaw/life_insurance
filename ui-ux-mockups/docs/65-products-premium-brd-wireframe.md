# 65 — Products Premium · BRD FR-04 vs wireframe

**Source:** `Wireframe/Products Premium.png` (+ crop screenshots) · `15052026 - Agent App Business Requirement Document.pdf`  
**Flutter today:** one shared Get A Quote form (`quote.dart`) — UL-style fields for every product  
**Related:** `34` §3/`§4.7` · `59` §C · `60` P2 · `63` type/name chips · e-App Premium step (`59` §F.6)  
**Date:** 2026-08-14

**Ask:** Map **Products Premium** to the BRD, decide what fits better (BRD vs PNG), and brainstorm everything needed so premium entry is complete — including extras we should add to mock/catalog.

---

## 1. BRD sections that this PNG belongs to

| BRD | Requirement | How Products Premium fits |
|-----|-------------|---------------------------|
| **§5.4 FR-04 · Product Library** | Read-only Life & Health library · related products only · Core **code + name** | Catalog/detail already cover library. Premium screens are **not** the library — they run **after** a product is chosen. |
| **§5.4 FR-04 · Premium Calculator** | Step/form for **one** product · client inputs → **accurate premium estimate** · Core pricing | **This is the PNG.** Per-product field sets = calculator inputs. Prototype: mock formula; later Core pricing API. |
| **§5.4 FR-04 · Save Quote** | Save quote · **link Lead or Client** | Bottom of calculator → **Save quote** (not Buy). Link-to stays required (`59`). |
| **§5.4 FR-04 · Integration** | Real-time product + pricing from Core | Prototype: **mock product schemas + mock premium**. No live Core. |
| **§5.5 FR-05 · Start e-App / Pre-fill** | e-App from saved quote · pre-fill product + premium | Quote output feeds e-App. |
| **§5.5 FR-05 · (wizard) Premium Information** | Locked snapshot of quote in e-App | **Different screen** from PNG calculator — same *title* in wireframes, different job. |
| **Cross-cutting (formatting)** | `DD-MMM-YYYY` · amounts with **2 decimals + commas** · mandatory/optional validation | Apply on all premium fields + summary. |

**Not in FR-04 (ignore as Phase 1 jobs even if PNG shows them):**

| Item | Why |
|------|-----|
| **Group Life** (PNG frames) | BRD v2.3 / `34` §4.7 — entity/group proposal **OOS** |
| Multi-product cart | FR-04 = **single** product |
| Live Core pricing | Integration later; mock now |
| Discount engine / commission | Display/history elsewhere; calculator discounts = **stub** only |

---

## 2. Name collision (resolve once)

| Screen | Wireframe label | Real job | Flutter |
|--------|-----------------|----------|---------|
| **A · Calculator** | PNG title **“Premium Information”** | FR-04 enter params → estimate → **Save quote** | `ProductQuotePage` — keep app title **Get A Quote** (sell language) · optional subtitle “Premium parameters” |
| **B · e-App step** | **Premium Information** | FR-05 **locked** quote review → Next/Confirm | `eapp_wizard` step — read-only card |

**Decision:** Layout chrome from PNG applies to **A**. Do **not** merge A and B into one editable screen inside e-App (`59`: change premium = back to calculator).

---

## 3. BRD vs wireframe — what wins

| Topic | BRD | Wireframe PNG | **Decision** |
|-------|-----|---------------|--------------|
| Scope | One product · Life & Health related | Many product skins incl. Group / Education / CI / I-Medical | **BRD scope** · wireframe **field patterns** for products we mock |
| Group Life | OOS | Present | **Hide** from catalog + schemas |
| Pricing | Accurate via Core | Static numbers in art | **Mock formula** per product schema · stamp fee mock · disclaimer *Indicative* |
| CTA | Save quote (implied) | **CONFIRM** on some frames | Calculator CTA = **Save quote**. **CONFIRM** reserved for e-App submit / locked Premium step |
| DOB / amounts | Format rules | Match | Follow BRD formatting |
| Discounts | Not specified in FR-04 | Discount Name + Amount on almost every frame | **P0 UI stub** (optional fields) · do **not** invent a real discount engine · may zero-effect total |
| Bookmark on summary | — | Bookmark icon | **P1** save-to-favorites / pin quote — or hide until Quotes list exists; don’t imply Core bookmark API |
| Optional Bundle / Rider | Single product | I-Medical + rider block | Only if mock product is a **single Core code** that includes optional rider params — else **skip** |
| Per-product fields | “client inputs” for that product | Lock-up · Units · Travel by · Premium Terms · Industry risk · … | **Schema-driven fields** (below) — this is the value of the PNG |

**Verdict:** **BRD owns jobs and scope**; **Products Premium.png owns visual form + which parameters appear per product family.** Shared UL-only form is **not** enough once we claim FR-04 fidelity.

---

## 4. Shared chrome (every product)

Wireframe consistency → one shell, swap body fields.

```
←  Get A Quote                          (or Premium parameters)
[ Product Type chips ]
[ Product Name tiles ]                  ← from detail: pre-selected

── dynamic field list (schema) ──

[ Discount Name | Discount Amount ]     ← stub row, optional

── Summary card ──
  Product title · (bookmark P1)
  Premium (Frequency):  ##,###.##       ← tinted band
  rows: name · variant · freq · age · SI · extras · stamp
  Total Amount:  ##,###.##

sticky  [ Save quote ]                  ← not CONFIRM
```

| Shared always | Notes |
|---------------|-------|
| DOB * | Calendar · `DD-MMM-YYYY` · age derived |
| Payment frequency * | From product’s allowed list (Monthly / Semi-Annually / Lumpsum / …) |
| Summary card | Live update on field change (mock) |
| Link to Lead/Client * | Keep (`59`) — BRD Save Quote |
| Stamp fee | Mock rule (e.g. % of premium or fixed by line) · show in summary |
| Amounts | Comma + 2 decimals |

---

## 5. Product schemas (PNG → mock catalog)

Use **field keys** driven by `productCode` / line. Only show fields in that product’s schema.

### 5.1 In catalog today → extend schema

| Product (mock) | PNG cues | Fields beyond shared |
|----------------|----------|----------------------|
| **Universal Life** | Saving Plus / DIET · Lock-up · Top-up · SI grey or editable | Variant * · SI * · Monthly premium (computed or editable per mock) · **Top-up** · **Lock-up amount** · **Lock-up period** · Policy terms * |
| **Short Term Endowment** | Simpler | Variant · SI * · Policy terms * · (no lock-up / top-up) |
| **Personal Accident** | Lumpsum · industry risk | SI * · Policy terms * · **Industry risk** (Low/Med/High) |
| **Credit Life** | Lumpsum / short-term SPCL | Variant · SI * · Monthly/Lumpsum premium · Policy terms * |
| **Family Health / Health** | Additional cover | Variant / Basic cover · **Additional cover** (optional) · SI · Premium · Terms |
| **Travel Protect** | Travel by · plate · short days | Variant · SI · Premium · Terms (days) · **Travel by** * · **Plate number** (if Car) |
| **Life Plus Pack** (Bundled single code) | Optional bundle / rider | Variant · Optional bundle checkbox → **Rider plan** · **Rider payment frequency** · rider premium in summary |

### 5.2 PNG products **not** in catalog — add to mock? 

| PNG product | BRD fit | Decision |
|-------------|---------|----------|
| **Group Life** | Entity OOS | **Do not add** |
| **Education Life** | Individual life — related | **P1 add** to Saving/Protection line if we want PNG coverage (Policy terms + **Premium terms**) |
| **Critical Illness** | Health-related | **P1 add** with **Unit(s)** field |
| **Micro Health** | Health | **P1** fold into Health line or alias of Family Health variant |
| **I-Medical** | Often rider/bundle | Only as **rider block** on Life Plus / UL optional bundle — not a second cart product |
| **Short Term Single Premium Credit Life** | Credit family | **Variant** under Credit Life (not separate library card unless Core code differs) |

### 5.3 Field → summary row map

Every input that affects price or identity should appear on the summary card. Examples:

| Input | Summary label |
|-------|---------------|
| Top-up / Lock-up | Top-Up Premium / Lock-up |
| Units | Unit(s) |
| Industry risk | Variant or Risk |
| Rider premium + freq | Rider Premium · Rider Payment Frequency |
| Travel by / plate | Optional detail rows (or omit from total if non-pricing) |
| Stamp fee | Stamp Fee |
| Discount amount | If stub applies: reduce total **or** show “Discount (demo)” with 0 effect — **prefer show amount, 0 effect** until rules exist |

---

## 6. Mock pricing (prototype)

No Core. Per-schema simple rules so CONFIRM/Save feels real:

| Rule | Spec |
|------|------|
| Base | Existing `monthlyPremiumFor(si)` style · extend by line |
| Frequency | Convert display label (Monthly vs Lumpsum vs Semi) |
| Stamp | Fixed mock by product or `round(premium * rate)` |
| Rider | Add fixed % of base when bundle checked |
| Units | `unitCount * unitRate` |
| Lock-up / top-up | Add into **Total** when present (PNG UL totals) |
| Disclaimer | Under summary: *Indicative · final premium from Core calculator* |

---

## 7. UX polish from PNG (ship with schemas)

| Item | Spec |
|------|------|
| Outlined fields · floating labels · red `*` | Match Get A Quote / AppTextField |
| DOB calendar icon | Required |
| Dropdowns for variant / freq / terms / risk / travel by | Bottom sheets (existing picker pattern) |
| SI grey when **derived** | Only when schema says read-only (some UL frames); else editable |
| Premium field | Prefer **computed read-only** for P0 · editable only if schema `premiumEditable: true` (SPCL-style frames) |
| Summary tinted premium band | Wireframe light-blue row |
| Total Amount | Bold footer |
| Wireframe “CONFIRM” | Map to **Save quote** on calculator; keep e-App Confirm separate |

---

## 8. Flutter / data map (when building)

| Piece | Change |
|-------|--------|
| `product_mock_data.dart` | `PremiumFieldSpec` / `ProductPremiumSchema` per product · optional Education / CI catalog entries |
| `quote.dart` | Render fields from schema · live summary · discount stub row |
| `product_widgets.dart` | Reusable summary card (bookmark optional) |
| e-App Premium step | Still **locked** snapshot of saved quote fields (include new keys in `SavedQuote`) |
| Docs | This file · inventory · tick `34` checklist when shipped |

**Do not:** second calculator route per product PNG; one page + schema switch.

---

## 9. Phasing

| Phase | Scope |
|-------|-------|
| **P0** | Schema engine on **existing** catalog products · UL lock-up · PA industry risk · Travel by/plate · Health additional cover · Credit variant fidelity · discount stub · stamp + total · Save quote unchanged |
| **P1** | Add **Education Life** + **Critical Illness (units)** · Micro Health alias · rider/bundle block for Life Plus · bookmark · SI read-only modes |
| **P2** | Core pricing API · real discount rules · Group/entity if BRD opens |

---

## 10. What we explicitly add (gap fill)

These were missing from a complete plan — **include them**:

1. **Schema model** (not N copy-paste pages)  
2. **Clear A vs B naming** (Get A Quote vs e-App Premium Information)  
3. **Stamp fee + Total** on every summary (PNG)  
4. **Discount stub** row (PNG) with no fake engine  
5. **Group Life stay out**  
6. **Education + CI** as optional catalog adds (P1)  
7. **SavedQuote** must persist all schema values for FR-05 pre-fill  
8. **Indicative disclaimer** (BRD accuracy later via Core)  
9. **CTA label** Save quote (BRD) over CONFIRM (PNG calculator)  
10. **Travel plate** conditional on Travel by = Car  

---

## 11. Acceptance

- [x] BRD §5.4 / §5.5 mapped to Products Premium  
- [x] BRD vs wireframe decisions recorded  
- [x] Shared chrome + per-product schemas listed  
- [x] OOS + P0/P1/P2 clear  
- [x] Gaps to add documented  
- [x] Flutter schema-driven Get A Quote (P0)  
- [x] Inventory updated  

**Shipped P0:** `premium_schema.dart` · schema fields on `quote.dart` · stamp/total summary · discount stub · extras on `SavedQuote` · e-App Premium snapshot. Group Life still OOS. Education/CI catalog = P1.

---

## 12. Related

`Products Premium.png` · BRD FR-04/05 · `59` §C · `34` · `quote.dart` · `product_mock_data.dart`  
