# FR-06 Policy and Servicing — UX Plan

Sources: FR-06 spec v1.0 · Agent App BRD · cream + Coolors continuity with Home / FR-03.

Prototype: Policies view inside `after-login.html` (same phone shell as CRM).

---

## 1) Scope

| Surface | Role | Access |
|---|---|---|
| Mobile | FA | **Read-only** Active policies for the authenticated agent |
| Mobile & Web | Leaders (AM, SAM, DM, Branch Manager) | **Read-only** own + downline FA policies (Core hierarchy) |

No create/edit/cancel on this module — servicing mutations stay in Core / ops flows.

---

## 2) Search & filters

**Wildcard / partial match** across one or more of:

- Client name  
- Policy number  
- NRC  
- Phone  
- Product type (Endowment, Health, Universal Life, Protection, …)  
- Policy status — **fixed to Active** (no inactive in list)

UI: single search field + product-type pills. Status chip always shows **Active**.

---

## 3) Active-only rule

List and search return **Active policies only**. Lapsed / cancelled / expired are excluded from this interface.

---

## 4) Role-based scoping (Core JWT)

| Role | Visibility |
|---|---|
| FA | Own book only |
| Leader / Manager | Self + all downline FAs in reporting tree |

Prototype QA: **Role: FA** / **Role: Leader** toggles outside the phone (Leader reveals a sample downline policy + scope note).

Backend: JWT + role mapping validated before policy payloads are returned.

---

## 5) Policy detail (read-only)

From list or Client profile → policy card:

- Coverage (product, sum assured, term)  
- Premium (next due date, amount, frequency, last paid)  
- Beneficiaries (name, relationship, %)  
- For downline (Leader): servicing FA name  

Real-time: status, payment, beneficiary updates come from Core sync APIs when fetched.

---

## 6) Continuity

- Entry: Your Tools → **Policies** · Client profile active-policy rows · `#policies`  
- Same cream cards, Coolors, bottom nav unchanged  
- Aligns with FR-03 Client “active policies” and FR-05 renewal CTA (renewal still starts e-App elsewhere)

---

## 7) Checklist

- [x] Policies list · Active only  
- [x] Wildcard search (name / policy / NRC / phone)  
- [x] Product type filters  
- [x] Read-only detail (coverage, next due, beneficiaries)  
- [x] FA vs Leader scope demo  
- [x] Link from Client profile policies  
- [ ] Web Portal leader policy browser mock  
- [ ] Assigned-agent filter chip for Leaders (explicit FA picker)  
