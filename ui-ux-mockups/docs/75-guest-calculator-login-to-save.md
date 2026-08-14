# 75 — Guest calculator · Login to Save Quote (Option B)

**Source:** `Wireframe/Calculator(Before login).png` (7139×3147 collage) · FR-01 · FR-04 · FR-05 · `34` §4.5  
**Flutter today:** Guest Home (`74`) · Calculator / GET A QUOTE **gated** · `ProductQuotePage` = logged-in Get A Quote (`65`) · Login always `go(home)`  
**Related:** `24` `43` `45` `59` `62` `63` `65` `74`  
**Date:** 2026-08-14

**Ask:** Look at the **actual** Before-login collage (not a guessed consumer calculator). Brainstorm everything so Option B matches that board **and** BRD — including extra UI the PNG does not label.

**Rule:** BRD wins *who may act*. PNG wins *guest quote chrome + mid-flow Login*. After login, the existing sell spine continues. **Not** a client-facing app.

---

## 1. What the PNG actually is

Left → right collage. **Two jobs glued on one board:**

| Cluster | Screens on the PNG | Job |
|---------|--------------------|-----|
| **A · Before / at login** | **Get A Quote** · **Compare Details** · **Login Account** | FR-04 estimate + FR-01 door |
| **B · After login** | Life Assured Scanner · Height/Weight wheels · Policyholder · Identification sheet · Beneficiary (+ company) · Health · Confirm accordion · Success + Proposal→UW→Payment→Policy | FR-05 e-App — **already shipped** (`59` `62` `67`) |

### Cluster A — read off the art

**Get A Quote** (same family as logged-in `Calculator.png` / `65`, not a tiny DOB+Gender+Calculate toy):

```
←  Get A Quote
Product Type *     [Protection] [Saving] [Travel] [Health] [Bundle]
Product Name *     [Universal Life] [Short Term Endowment]
Date of Birth (Insured Person) *
Variant / Frequency / Sum Insured / Monthly Premium / Top-up / …
[ cart chips PA + UL with × ]     ← wireframe cart — BRD forbids
[ Buy ]  [swap]
── summary ──
Premium(monthly)  50,000 MMK
Product Name · Age · Sum Insured · Top-up · Policy Term
```

**Compare Details** — feature table · Pin · **BUY** under each column (`59` already: display aid, **Use product** not Buy).

**Login Account** — **Mobile Number** · Password · Forgot Password? · **LOGIN** · Register Now.  
This is the existing Login (`43`). **Not** NRC+password. Earlier notes that said “NRC login on this PNG” were wrong.

### Cluster B — do not rebuild for guests

Scanner, Policyholder, Identification (`62`), Beneficiary (person + **company**), Health, Confirm, Success stepper = **e-App after a saved quote**. Company beneficiary stays OOS (`59`).

---

## 2. BRD vs this PNG

| Topic | PNG | BRD | **Decision** |
|-------|-----|-----|----------------|
| Who quotes | Anyone who can open Get A Quote | Authorized agent; Core pricing | **Option B:** unsigned **agent** may **estimate**. Save / e-App need login |
| Page | Get A Quote (chips + schema fields + sticky summary) | FR-04 one product calculator | **Reuse** `ProductQuotePage`. Title stays **Get A Quote** (not “Calculator”) |
| Cart of 2 + Buy | PA + UL chips · **Buy** | Single product · **Save quote** (`59` `65`) | **No cart.** CTA guest = **Login to save quote**. Signed-in = **Save quote**. Never **Buy** |
| Compare | On this board | P1 sales aid | Guest **may** open Compare; **Use** → Get A Quote (still one product) |
| Login | Mobile + password mid-flow | FR-01 CORE mobile + password | **Existing Login** · `push` from quote so Cancel returns to estimate |
| After LOGIN | Scanner / Policyholder / … | e-App from **saved quote** | Login → **restore Get A Quote** → Link to Lead/Client → Save quote → Quote saved → Start e-App. **Do not** jump to Scanner |
| Group / company beneficiary | Company form on board | Entity OOS | **Don’t build** |
| Guest Home tile “Calculator” | Opens this Get A Quote | Our Services label | Open quote with `lastOrDefaultProduct` |

`34` §4.5: **Pick Option B** for this pass (`74` P0 was A).

```
Guest Home Calculator / Product GET A QUOTE / Compare Use
  └─▶ Get A Quote          ← PNG cluster A, same page as FA
        ├─ Compare         ← allowed
        ├─ Keep editing
        └─ Login to save quote ──▶ Login Account (mobile + password)
              ├─ LOGIN ok + draft ──▶ FA shell + Get A Quote restored
              │                         └─ Link to · Save quote · Quote saved · e-App
              ├─ pending (`45`) ──▶ Registration in progress · draft kept · not FA Home
              └─ back / wrong pw ──▶ guest · draft kept · quote still there
```

---

## 3. Control map

| Control | `74` P0 | This pass |
|---------|---------|-----------|
| Guest Home **Calculator** | Gate “Sign in to calculate” | **Open Get A Quote** |
| Product **GET A QUOTE** | Gate | **Open Get A Quote** |
| Compare **Use {product}** | Gate | **Open Get A Quote** |
| Quote **Compare** icon | — | Allowed while guest |
| Quote **Buy** (PNG) | — | Map to **Login to save quote** / **Save quote** |
| Quote **Link to** | — | Hide while guest · required after login |
| Guest Home **New Proposal** | Gate | **Still gate** (e-App, not estimate) |
| Saved quotes / Tracker icons | Hidden | Stay hidden |
| FAB / Customer / Commission / Claim / bell | Gate | Unchanged |

---

## 4. Extra UI (needed; PNG doesn’t name them)

| Extra | Why |
|-------|-----|
| **`GuestQuoteDraft`** | Snapshot of product + field values + premium label. Memory only. |
| **Login-to-save sheet** | PNG has no “save” label on guest quote — **Buy** is the door. Sheet = estimate snapshot + Login / Register / Keep editing |
| **Guest strip** | “You’re not signed in. Estimates aren’t saved until you log in.” Quote page otherwise looks like an FA book |
| **Resume after login** | `go(home)` then `push(quote)` + hydrate. Back from quote = **FA Home**, not Guest Home |
| **Banner / Profile / FAB login** | No draft → FA Home only (unchanged) |
| **Pending register** | Keep draft · do **not** resume quote · not FA (`45`) |
| **Biometric Unlock** | Same resume as password (`70`) |
| **Logout** | `signOut` + **clear draft** → Guest Home |
| **Indicative line** | Keep · don’t look like a bound policy |

Resume pick: **B** (`go(home)` + `push(quote)`). Clear draft **after hydrate**.

---

## 5. Copy (ENG)

| Place | Copy |
|-------|------|
| Guest strip | You’re not signed in. Estimates aren’t saved until you log in. |
| Sheet title | Save this estimate |
| Sheet body | Sign in to save the quote and link a Lead or Client. |
| Sheet primary | Login |
| Sheet secondary | Register |
| Sheet dismiss | Keep editing |
| Quote CTA (guest) | Login to save quote |
| Quote CTA (signed-in) | Save quote |

Do not keep Option A copy “Sign in to calculate a premium” on Calculator / GET A QUOTE.

---

## 6. What not to do

- Don’t fork `guest_quote.dart` or retitle the page **Calculator**  
- Don’t ship PNG **cart** or **Buy**  
- Don’t let guests Save quote / Tracker / e-App / Link to the mock book  
- Don’t jump Login → Scanner / Policyholder  
- Don’t add NRC login (this PNG’s Login is **mobile**)  
- Don’t build company beneficiary or Group Life  
- Don’t resume quote on pending registration  
- Don’t persist draft to disk for this P0  
- Don’t land Guest Home after calculator-origin login success  

---

## 7. Flutter map

| Piece | Work |
|-------|------|
| Unlock | Guest Home Calculator · GET A QUOTE · Compare Use |
| `quote.dart` | Guest strip · hide Link to · CTA Login to save · capture draft · sheet → `push(login)` |
| `GuestQuoteDraft` | Next to `GuestSession` |
| Login / Unlock | If draft → `pendingResume` · `go(home)` · shell `push(quote)` + hydrate |
| `LifeInsurancePage` | Post-frame resume |
| Logout | `GuestQuoteDraft.clear()` |
| New Proposal | Still `showAuthGate` |

---

## 8. Phasing

| Phase | Scope |
|-------|-------|
| **P0** | Unlock estimate · hide Link to · Login to save sheet · draft · resume onto Get A Quote · logout clears · New Proposal gated |
| **P1** | Richer summary sheet (PNG Premium(monthly) table) · generic `74` resume |
| **Out** | Guest e-App · Buy · cart · NRC login · company beneficiary |

---

## 9. Acceptance (brainstorm)

- [x] Collage split A (quote/compare/login) vs B (e-App) from the real PNG  
- [x] Login = mobile+password (existing) · Buy → Login to save quote  
- [x] Same `ProductQuotePage` · no cart  
- [x] Extra UI (draft, sheet, resume, pending, logout)  
- [x] Flutter Option B P0  
- [x] Inventory updated  

---

## 10. Related

`Calculator(Before login).png` · `Calculator.png` · FR-01 · FR-04 · FR-05 · `24` `34` §4.5 · `43` `45` `59` `62` `63` `65` `70` `74`
