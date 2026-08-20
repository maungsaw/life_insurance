# FR-05 Single Product Sales & e-Application — UX Plan

Sources: FR-05 spec v1.0 · Agent App BRD · cream + Coolors continuity with FR-01–04.

Prototype: `policyholder-form.html` (e-App wizard + Application tracker).

---

## 1) Scope

| Surface | Role | What |
|---|---|---|
| Mobile | FA | End-to-end e-App: prefill → docs → e-sign → submit → track |
| Web Portal | Admin | Renewal “Start e-App” window (2 weeks / 1 month), content/setup adjacent modules |

---

## 2) Supported start points

| Entry | Prefill source | Prototype link |
|---|---|---|
| Product catalog | Product code/name | Your Tools → New Proposal · `?from=product` |
| Premium calculator | Quote session | Buy / e-App · `?from=quote` |
| Client profile | Client KYC + policies | Client sheet → Start e-App · `?from=client` |
| Lead profile | Lead details | Lead sheet → Start e-App · `?from=lead` (→ Client on Core submit) |
| Saved / active quote | Quote payload | Products draft sheet → Convert to e-App |
| Policy / proposal (renewal · repurchase) | Existing policy | Client sheet renewal card when inside portal window · `?from=renewal` |

**Renewal CTA rule:** “Start e-App” shows only within configurable lead time before expiry (default options: 2 weeks or 1 month — Web Portal).

---

## 3) Auto-population

From Core / saved context into e-App:

- **Customer:** name, phone, email, NRC, gender, DOB, address  
- **Product / plan:** name, code, sum assured, coverage options  
- **Pricing:** base premium, payment frequency, total payable  

UI: banner “Auto-filled from Core / quote” + editable fields where BA allows overrides.

---

## 4) Wizard steps (Mobile)

1. **Customer & product** — prefilled PH + readonly premium summary  
2. **Insured & beneficiary** — “Same as policyholder” toggle  
3. **Documents** — mandatory NRC Front & Back for Policyholder, Insured, Beneficiary  
4. **E-Signatures** — Client + Agent signature pads (mandatory)  
5. **Review & submit** — declaration → Submit to Core → status **Submitted**

Also: **Save draft** anytime → status **Draft** (local and/or backend).

### Document rules
- Formats: JPEG, JPG, PNG, PDF  
- Max **12 MB** / file  
- Compress for readability; camera or gallery  

### Signatures
- Touch pad on device  
- Embedded securely into e-App PDF payload → Core  

---

## 5) Application status tracker

Searchable list + status filters. Real-time sync from Core API.

```
Draft → Submitted → Mark for Correction → Approved
                                      ↘ Rejected
```

| Status | Agent action |
|---|---|
| Draft | Continue wizard |
| Submitted | Monitor |
| Mark for Correction | Edit & resubmit |
| Approved | Policy issued (read) |
| Rejected | Read reason |

Entry: Your Tools → **Proposal Status** → `?view=tracker`

---

## 6) Continuity

- Same cream / Coolors / soft cards as Home  
- Login required for e-App (guest Buy still gates via FR-04)  
- Lead → Client conversion happens on Core policy submit (no manual convert — aligns FR-03)  

---

## 7) Checklist

- [x] Multi-step e-App with prefill banner  
- [x] NRC F/B for PH / Insured / Beneficiary + format/size copy  
- [x] Client + Agent signature pads  
- [x] Save draft + Submit → Submitted  
- [x] Tracker with search + status filters + lifecycle  
- [x] Start points: product, quote, client, lead, renewal  
- [ ] Multi-beneficiary percentage validation UX  
- [ ] Camera capture native sheet (prototype uses tap-to-attach)  
- [ ] Web Portal renewal-window setting screen  
