# e-App Step 1 — Prefill vs manual entry

**Canvas:** `eapp-prefill-manual-brainstorm.canvas.tsx`  
**Screen:** `policyholder-form.html` · Step 1 Customer & product  
**Today:** Always shows “Auto-filled from Core / quote” + filled fields (even when entry is blank-start).

---

## Problem

Screenshot shows **only the happy path**: Core/quote already has customer + product + premium.  
Real sales also need:

| Entry | Prefill? | What agent does |
|---|---|---|
| From **quote / Buy** | Yes · product + premium (+ age inputs) | Confirm / light edit |
| From **client / lead** | Partial · person yes · product/premium often no | Pick product · run calc or enter premium |
| From **product catalog / New Proposal** | Product maybe · person no · premium no | Enter PH · pick/confirm product · calc or type premium |
| From **blank / offline cold start** | No | Full manual · or search CRM first |

UI must **signal which mode** you’re in — not pretend everything is auto-filled.

---

## Goals

1. Two clear Step-1 modes: **Prefill** vs **Manual** (and soft hybrid)  
2. Product & premium never look “locked Core truth” when they aren’t  
3. Fast path when Core *does* exist (keep current banner + read-only-ish product card)  
4. Manual path: empty fields · placeholders · required marks · optional CRM / quote lookup  
5. Same 6-step wizard after Step 1 — don’t fork the whole e-App  
6. Skin: cream · Coolors · soft cards · match Get-a-quote cohesion  

---

## Step 1 layout by mode

### Mode P — Prefill (quote / Core hit)
Keep close to screenshot:

- Banner: **Auto-filled from quote / Core** (mint/steel)  
- Product card: summary rows · “Change product” text link (optional)  
- Policyholder: prefilled · editable  
- CTA: **Next**

### Mode M — Manual (no Core/quote payload)
Replace auto-fill banner with:

- Banner: **Enter details** · “No quote linked — fill product & customer” (neutral Deep/05, not sky “success”)  
- **Product block (editable):**
  - Product picker (sheet or select) · Sum · Term · Premium (or “Open calculator” → return with numbers)  
- **Customer block:**
  - Empty inputs + placeholders  
  - Optional row: **Search CRM** / **Scan NRC** (reuse existing scan sheet)  
- CTA: **Next** (validate required)

### Mode H — Hybrid (client known, no premium)
- Banner: **Customer from CRM · product not priced**  
- Person filled · product card with **Get premium** → calculator · then return  

---

## Options for how to switch modes

| ID | Pattern | Note |
|---|---|---|
| **A (recommend)** | Drive from `?from=` + `?prefill=0\|1` · QA toggle outside phone | Honest demos · matches real entry points |
| **B** | In-step segmented control: Prefill sample \| Manual | Good for stakeholders; less “real” |
| **C** | Always show lookup first: Search quote / CRM / Start blank | Extra gate before Step 1 |

---

## A — recommended entry map

| `from` | Default mode | Source line under title |
|---|---|---|
| `quote` | Prefill | From quote · {product} |
| `client` / `lead` | Hybrid | From client / lead · {name} |
| `product` / `renewal` | Manual or product-only | From catalog · {product} |
| `blank` / missing | Manual | New e-App · manual entry |

QA (outside frame): **Simulate no prefill** toggles Mode M on current entry.

---

## Other Step-1 needs (include in polish)

1. **Required validation** before Next (name · phone · NRC · product · premium)  
2. **Product change** when prefilled → confirm sheet (“Recalculate premium?”)  
3. **Open calculator** deep-link `get-quote.html?auth=1&return=eapp` stub  
4. **CRM search sheet** → pick client → fill PH fields  
5. **Draft save** keeps mode + empty vs filled  
6. Don’t show sky “Auto-filled” banner in Mode M (trust killer)  

---

## Downstream (same wizard — light notes)

- Steps 2–6 stay; Insured “same as PH” still works when PH was manual  
- Confirm step should show **source chip**: Quote-linked · CRM · Manual  
- Tracker list: draft rows created from manual still look the same  

---

## Decision

**A shipped** on `policyholder-form.html`:
- `from=quote` → Prefill · `client`/`lead` → Hybrid · `product`/`renewal`/`blank` → Manual  
- QA: **Simulate no prefill** · links Open blank / Open quote  
- Manual: editable product · empty PH · Search CRM · Scan NRC · premium required  
- Prefill: Auto-filled banner · Change product → switches to editable  
