# Sell spine — Product detail · Calculator · Save quote · Start e-App (split)

**Surfaces:** Mobile Concept A (`concept-a-field-momentum`)  
**BRD spine:** Product library → Quote (FR-04) → e-App (FR-05) → App tracker  
**Related:** `04` e-App stepper · `05` FR-03 · `23` Product On/Off

---

## 1. Problem (what stakeholders asked)

Today **e-App tab → Products** jumps almost straight to a thin calculator. Missing:

1. **Product detail** per product (brochure + rate snapshot) before calculating  
2. Explicit **Calculate → result → Save quote**  
3. **Start e-App** as its **own screen** (not glued to the calculator)  
4. After starting, **review again** via App tracker / resume draft  

---

## 2. Job map (one job per screen)

```
Products (On catalog)
    ↓ tap product
Product detail          ← read brochure · skim rates
    ↓ Calculate premium
Premium calculator      ← inputs · Calculate · result
    ↓ Save quote
Quote saved             ← confirmation · quote id
    ↓ Start e-App  (or later from hub)
Start e-App (hub)       ← pick saved quote · open wizard   ← SEPARATE
    ↓
e-App wizard 1…6
    ↓
Success → App tracker   ← review / resume anytime
```

| Screen | Job | Primary CTA |
|--------|-----|-------------|
| **Products** | Pick what to sell | Open detail |
| **Product detail** | Understand product (brochure + rates) | Calculate premium |
| **Calculator** | Get a premium result | Save quote |
| **Quote saved** | Confirm quote is stored on Lead/Client | Start e-App · View quotes |
| **Start e-App** | Choose which saved quote to apply | Continue to wizard |
| **Wizard** | Fill application | Submit |
| **App tracker** | Review status / resume | Open draft or fix |

**Hard rule:** Calculator does **not** open the wizard. Only **Start e-App** hub (or Quote saved CTA that lands on that hub) starts the wizard.

---

## 3. Product detail UX

### Layout
- Back → Products  
- Hero: code chip · name · one-line benefit  
- **Segment:** Brochure | Rates  
- Sticky bottom: **Calculate premium**

### Brochure tab
- Cover card (mock PDF / image) · “Open brochure”  
- Short bullets (who it’s for · key benefits)  
- Link tone: “Same docs as Resource · Product brochures” (read-only here)

### Rates tab
- Sample rate table (age band × SI band → indicative annual premium)  
- Disclaimer: *Indicative · final premium from Core calculator*  
- Payment mode note

**Why rates on detail?** FA can answer “roughly how much?” before entering full calc. Calc still owns official estimate.

---

## 4. Calculator UX

1. Context chip — product locked from detail (change = back to Products)  
2. Fields — Linked Lead/Client · DOB · Sum assured · Payment mode · (term if needed)  
3. **Calculate** — reveals / refreshes KPI result (not auto-only)  
4. Result KPI — premium · mode · “From Core pricing API”  
5. Actions after result  
   - **Save quote** (primary path)  
   - Recalculate if inputs change  

Do **not** put **Start e-App** as equal primary next to Save on first paint — Save first, then Start from saved state / hub.

---

## 5. Save quote → Quote saved

- Quote ref (e.g. `QT-2026-1108`)  
- Snapshot: person · product · SI · premium · mode · date  
- CTAs:  
  - **Start e-App** → `Start e-App` hub with this quote pre-selected  
  - **View saved quotes** → quotes list (on Lead/Client or sell quotes strip)  
  - Back to Products  

Saved quotes also appear on Lead/Client profile (existing FR-03).

---

## 6. Start e-App (separate hub)

**Why split:** Field mental model = “I finished quoting” vs “I start paperwork.” Mixing both on calculator causes accidental wizard entry and unclear review path.

### Hub content
- Title: `Start e-App`  
- Sub: `Pick a saved quote · pre-fills the application`  
- List of **saved quotes ready to apply** (person · product · premium · date)  
- Empty: “Save a quote from the calculator first” → link Products  
- Tap row / Continue → Wizard step 1  
- Secondary: **App tracker** (review in-progress / submitted)

After submit → Success → **View in App Tracker**. Drafts resume from tracker (existing).

---

## 7. Sell tab discoverability

On **Products** top (optional chips / soft links):

| Chip | Goes to |
|------|---------|
| Products | (current) |
| Quotes | Saved quotes strip / quote saved list |
| Start e-App | Hub |
| Tracker | App tracker |

Keeps e-App tab as sell home without stuffing every job on one list.

---

## 8. Acceptance

- [x] Brainstorm documented  
- [x] Product detail with Brochure + Rates  
- [x] Calculator Calculate → result → Save quote  
- [x] Quote saved screen  
- [x] Start e-App hub separate from calculator  
- [x] App tracker remains review/resume path  
- [ ] Core pricing / brochure APIs (later)  

---

## 9. Out of scope here

- Multi-product / entity proposals (BRD OOS)  
- Editing Core rate cards (HQ)  
- Full PDF brochure viewer (mock open is enough)  
