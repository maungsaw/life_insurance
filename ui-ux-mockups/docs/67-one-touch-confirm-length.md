# 67 — One Touch · Confirm length · FR-05 fit

**Source:** `Wireframe/One Touch.png` (+ crops: product+scan sheet · NRC scanner · Confirm & Submit · Success · Underwrite timer)  
**BRD:** §5.5 **FR-05** — Start e-App · Pre-fill · KYC (OCR **optional**) · E-Signature · Doc scan · Status tracker  
**Flutter today:** One e-App wizard (`59`) · Scanner Skip · Confirm = short ExpansionTiles + 2 signature pads · Success confetti (`64`) · Tracker (`26`/`59`) — **no** fake 03:00 UW timer · **no** separate “One Touch” product entry sheet  
**Related:** `34` One Touch map · `59` merge wizards · `04` stepper · `60` OCR banner  
**Date:** 2026-08-14

**Ask:** One Touch pack — what fits better (BRD vs PNG); Confirm & Submit is too long — keep **all** required data but prefer **one viewport without endless scroll**, or **split** if needed. Brainstorm a complete, usable plan.

---

## 1. What “One Touch” actually is

PNG is **not** a third sales app. It is a **fast-path skin** on FR-05:

| PNG beat | Job | Already in spine? |
|----------|-----|-------------------|
| Filter · Product chips · “Scan NRC to auto-fill” | Pick product + start KYC fast | Partial — quote→e-App; missing this **entry sheet** |
| Insured Scanner (NRC / Old NRC / Passport) | Optional OCR capture · Skip · Save | Yes — wizard step |
| Confirm & Submit (huge PH form in accordion) | Final review + sign + submit | Yes — but PNG packs **edit fields** into Confirm → **too long** |
| Success + TRACKING / HOME / share | Submitted celebration | Yes — Success (`64`); add HOME if missing |
| Underwrite + **03:00** ring | Waiting UX | Tracker exists; **countdown = reject** (`34`/`59`) |

**Decision (locked with `59`):** Keep **one** e-App wizard. One Touch = **entry shortcut + Confirm UX rewrite + Success/Tracker chrome** — not a parallel flow.

---

## 2. BRD vs wireframe — what wins

| Topic | BRD | One Touch PNG | **Decision** |
|-------|-----|---------------|--------------|
| Wizard count | One e-App from quote/client | Looks like own funnel | **One wizard** · One Touch = launch mode |
| OCR | Optional | Scan CTA prominent | **Keep Skip** · Scan never blocks |
| Confirm content | Submit after KYC/sign | Re-opens full PH **editable** form + mid-form CONFIRM | **Confirm = review (read-only)** · edit = Back to earlier steps |
| Mid-accordion CONFIRM | — | Button in middle of PH fields | **Remove** — confusing; only sticky **Submit** |
| Signatures | Client + agent on device | Upload or Signature | **Both pads required** · upload stub optional P1 |
| Success copy | Submitted | “successfully created” | Prefer **submitted** (matches tracker) |
| Underwrite timer | Status tracker | Live 03:00 / 30 min | **No fake countdown** · show status timeline / “In underwriting” |
| Pre-fill | From quote | Scan then form | Quote fields locked in Premium step; OCR fills **party** fields only |

---

## 3. Confirm & Submit is too long — honest constraint

A phone **cannot** show full Policyholder (name · mobiles · gender · ID · DOB · age · email · height · weight · occupation · town · township · state · address) **plus** product · insured · beneficiary · signatures **without scroll** if those sections are expanded and editable.

So “အကုန်ပါ · scroll မဆွဲ” only works if Confirm is **not** a second data-entry form.

### Recommended model (P0 pick): **Review board + sticky submit**

```
← Confirm & Submit

┌ Product / Premium card (collapsed summary · tap to expand) ┐
│ Premium (monthly) · SI · term · top-up                       │
└──────────────────────────────────────────────────────────────┘

┌ Policyholder     ✓  May Chan Myae · NRC · …     ▾ ┐  ← collapsed by default
┌ Insured          ✓  Same as PH / name           ▾ ┐
┌ Beneficiary      ✓  1 person · 100%             ▾ ┐
┌ Health           ✓  High risk No                ▾ ┐

Signature
  [ Client pad ]
  [ Agent pad ]

──────── sticky footer ────────
[ SUBMIT APPLICATION ]
```

| Rule | Spec |
|------|------|
| First viewport | All section **headers collapsed** + signature area + sticky Submit — **no scroll required to act** on typical phones |
| Expand a section | Short **read-only** KV list (or 2-col denser). Scroll **only while reviewing** that section — OK |
| Edit | Chevron / “Edit” → `pop` or jump to wizard step (PH / Insured / Beneficiary / Health / Premium) |
| No mid-form CONFIRM | Gone |
| No re-typing address on Confirm | Data already collected in steps 1–5 |

This keeps **all** data available (expand) without a marathon first paint.

### Split option (if review still feels heavy): **Confirm as 2 screens**

| Screen | Fits one viewport? | Content |
|--------|--------------------|---------|
| **Confirm · Review** | Yes (collapsed) | Product + 4 accordion summaries · Next |
| **Confirm · Sign & Submit** | Yes | Client + agent pads · Submit |

Prefer **single Confirm with sticky Submit** first; split only if QA finds first paint still cramped.

### What **not** to do

- Cram editable PH fields onto one screen with tiny fonts  
- Keep PNG’s mid-list CONFIRM  
- Duplicate Premium Information editable on Confirm (already locked earlier)  
- Infinite nested scroll of full forms inside every accordion  

---

## 4. One Touch entry (optional P0/P1)

Sheet / modal (PNG “Filter”):

```
Filter
Product Name   [ Universal Life ] [ … ]   ← chips · one selected
[ ⬚ Scan the NRC card to auto-fill data ]
```

| Rule | Spec |
|------|------|
| Product | Must be an **On** catalog product (same as Product tab) |
| After scan / Skip | Land in e-App with product (+ draft quote stub if no saved quote) **or** require Save quote first |
| BRD-safe P0 | One Touch entry **requires a saved quote** (or auto-creates minimal quote mock) then opens wizard at Scanner or Policyholder |
| FAB / Home | Optional “One Touch” tile → this sheet |

**P0 recommendation:** Wire sheet → existing catalog product → if no quote, prompt “Get A Quote first” **or** create draft quote mock then e-App. Don’t invent a second calculator.

---

## 5. Scanner (keep)

Already aligned: NRC | Old NRC | Passport · viewfinder · shutter · **SKIP** · **SAVE** · OCR optional banner (`60`).

One Touch Scan CTA → same step (or start wizard at Scanner if PH pre-filled from client).

---

## 6. Success + Tracking (polish)

| PNG | Decision |
|-----|----------|
| Confetti · Success · HOME · stepper · TRACKING · share | Reuse `eapp_success` · add **HOME** (pop to shell Home tab) beside / instead of only PROPOSAL |
| Underwrite 03:00 | **Do not ship** · TRACKING → App tracker detail with status copy (“In underwriting — Core will update status”) |

---

## 7. Flutter map (when building)

| Piece | Change |
|-------|--------|
| `eapp_wizard.dart` `_confirm()` | Collapsed review cards · dense KV · Edit → jump step · sticky Submit · remove any mid CONFIRM |
| Optional `one_touch_sheet.dart` | Product chips + Scan CTA |
| `eapp_success.dart` | HOME action |
| Tracker detail | Soft “underwriting” copy — no timer |
| Docs | This file · inventory |

---

## 8. Phasing

| Phase | Scope |
|-------|-------|
| **P0** | Confirm rewrite (collapsed review + sticky Submit + edit-back) · Success HOME · no UW timer |
| **P1** | One Touch entry sheet · Scan deep-link into wizard · Confirm split into Review \| Sign if needed |
| **P2** | Real OCR · real doc upload |

---

## 9. Acceptance

- [x] One Touch mapped to FR-05 (not a third wizard)  
- [x] Confirm length strategy: review-first · no endless entry scroll · split allowed  
- [x] Mid-form CONFIRM rejected · UW countdown rejected  
- [x] Flutter Confirm rewrite (collapsed review · Edit → step · sticky SUBMIT)  
- [x] Success HOME + TRACKING  
- [x] Inventory updated  

**Shipped P0:** Confirm review board · SUBMIT APPLICATION sticky · Success HOME. One Touch entry sheet = P1.  

---

## 10. Related

`One Touch.png` · BRD FR-05 · `59` · `34` · `64` Success · `eapp_wizard` Confirm  
