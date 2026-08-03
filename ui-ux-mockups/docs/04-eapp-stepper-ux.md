# e-Application Stepper UX — Concept A (Field Momentum)

**Goal:** Replace the single overview e-App screen with a real multi-step wizard between **Start e-App** and **App Tracker**, so FAs can complete applications in the field without getting lost.

---

## 1. Why a stepper (not one long form)

| Problem in field | Stepper answer |
|------------------|----------------|
| Face-to-face with client, intermittent focus | One job per screen |
| Fear of losing work if call drops / app backgrounds | **Save draft** on every step |
| Correction loops from underwriting | Resume at failed step + show correction reason |
| Burmese labels are longer | Short step titles + progress bar, not crowded 6-tab chrome |
| Thumb use while standing | Sticky **Back / Continue** footer; hide main tab bar during wizard |

---

## 2. Step model (aligned to BRD FR-05)

```
Quote / Client profile
        ↓
┌───────────────────────────────────────────────┐
│  e-App Wizard (focused, no bottom tabs)       │
│  1 Details → 2 Parties → 3 KYC →              │
│  4 Docs → 5 Sign → 6 Review                   │
└───────────────────────┬───────────────────────┘
                        ↓ Submit
              Success confirmation
                        ↓
              Application Tracker (Draft / Submitted /…)
```

| # | Step ID | Screen job | Primary CTA |
|---|---------|------------|-------------|
| 1 | Details | Confirm pre-filled PH + product/premium from quote | Continue |
| 2 | Parties | Insured person + beneficiary (single product) | Continue |
| 3 | KYC | NRC scan/upload for PH · Insured · Beneficiary | Continue |
| 4 | Docs | Camera capture / upload required docs | Continue |
| 5 | Sign | Client signature + Agent signature on device | Continue |
| 6 | Review | Read-only checklist → Submit / Save draft | Submit |
| — | Success | Confirmation + app ref | Go to tracker |

**App Tracker** stays the post-submit home for status (Draft, Submitted, Mark for Correction, Approved, Rejected). From **Mark for Correction**, deep-link back into the wizard at the failing step.

---

## 3. Persistent chrome (every wizard step)

1. **Top bar:** Close (✕ → confirm leave) · “e-App” · Save draft  
2. **Progress:** numbered step dots + thin bar · “Step 3 of 6 · KYC”  
3. **Context chip:** Client name · Product · Premium (always visible, collapses anxiety)  
4. **Footer (sticky):** Back · Continue (or Submit on Review)  
5. **Hide** main app tab bar while wizard is open (reduces accidental exit)

---

## 4. Step-level UX rules

### Step 1 — Details
- Show “Pre-filled from quote” badge  
- Editable fields with validation (mobile format, email, DOB `DD-MMM-YYYY`)  
- Product / SI / premium / mode as locked summary cards (change = go back to quote)

### Step 2 — Parties
- Toggle: Insured same as policyholder?  
- Beneficiary: name, relationship, % (must total 100)  
- Keep single-product / no entity (BRD out of scope)

### Step 3 — KYC
- Three cards: Policyholder / Insured / Beneficiary  
- Each: Scan NRC · Upload · Manual entry fallback  
- Status pills: Missing / Captured / Needs review  
- OCR optional — never block if OCR fails; allow manual confirm

### Step 4 — Documents
- Checklist of required docs (ID, medical if needed)  
- Large camera CTA (field-friendly)  
- Thumbnail strip + retake  
- Offline: queue uploads, show “Will sync when online”

### Step 5 — Signatures
- Full-width signature pads  
- Clear / Redo  
- Order: Client first, then Agent (agent cannot skip client)

### Step 6 — Review
- Collapsed sections with Edit → jumps to that step  
- Legal confirmation checkbox  
- Submit disabled until all required steps complete  
- On submit: loading → Success

### Success
- App reference number  
- Status = Submitted  
- Primary: View in tracker · Secondary: Back to Home

---

## 5. Correction resume (Mark for Correction)

1. Tracker row shows reason (“NRC unclear”)  
2. Tap → wizard opens at **KYC** with amber banner: “Fix requested · NRC page unclear”  
3. Other steps remain completed (green)  
4. Re-submit returns to Tracker as Submitted again

---

## 6. Microcopy (Field Momentum tone)

- Progress: “Almost there — signatures next”  
- Save draft: “Saved · resume anytime”  
- Submit: “Send application”  
- Success: “You’re in — underwriting received it”

---

## 7. Acceptance for this mockup

- [x] Six real step screens + success between e-App entry and Tracker  
- [x] Shared progress header + sticky footer  
- [x] Tab bar hidden during wizard  
- [x] Jump nav lists each step for stakeholder walkthrough  
- [x] Tracker links into correction path (KYC)
