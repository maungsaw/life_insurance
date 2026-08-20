# FR-04 Single Product & Quoting — UX Plan

Sources: FR-04 spec v1.0 · Agent App BRD · cream + Coolors continuity with Home / FR-01–03.

Prototypes:
- `products.html` — Product Library + My Draft Quotes
- `get-quote.html` — Premium Calculator (guided steps)
- `personal-accident.html` — Product detail (bridge to calculator)

Web Portal (content & setup only) — out of phone prototype scope; rules noted below.

---

## 1) Scope split

| Surface | Role | What |
|---|---|---|
| Mobile | FA | Browse authorized products, calculate premium, draft offline, submit quote |
| Web Portal | Admin / content | Product Active On/Off, brochures/benefits content, `Max_Local_Draft_Quotes_Limit`, quote validity days |

---

## 2) Product Library (Mobile)

### Visibility (two-tier — must both pass)
1. **Global:** Product status = Active in Web Product Setup  
2. **Agent:** Product On for this FA (FR-11 certification / assignment)

If either fails → product is **hidden** from Library and from Calculator product pickers.

### Content (read-only)
- Name, code, short benefit summary  
- Digital brochure / coverage rates (from Core + portal content)  
- Pricing matrices via Core APIs (not editable on mobile)

### Prototype
- Filters: All · Saving · Protection · Health  
- Travel Protect omitted (demo: OFF for this agent)  
- Soft cream cards, Coolors, same bottom nav  

---

## 3) Premium Calculator (guided)

Step 1 — Client inputs (DOB, sum insured, term, risk flags, product-specific fields)  
Step 2 — Quote review (premium from Core tables + fees)  
Actions:
- **Save draft** — always available (incl. offline)  
- **Buy / Submit** — requires login; needs network (or queues)

Guest continuity: Calculator open for estimate; Buy/Submit → login gate (same pattern as before).

---

## 4) Offline & Draft quotes

| Rule | Behavior |
|---|---|
| Create offline | Yes — estimate + Save draft |
| Draft expiry | **None** |
| Capacity | `Max_Local_Draft_Quotes_Limit` (Web) — demo **5** |
| Sync | Auto when connectivity returns → portal backend |
| UI | “My draft quotes” on Products; Local / Queued chips |

---

## 5) Submitted quote validity

- Default **30 days** (admin: 14 / 30 / 60…)  
- On submit → status **ACTIVE** + show valid-until date  
- After period → status **EXPIRED**  
- Drafts are unaffected by this rule  

---

## 6) Continuity with Home

- Same cream page, soft cards, Coolors, nav: Home · Customer · FAB · **Product** · Profile  
- Available Now → Product / Calculator deep-links unchanged  
- Login unlocks submit/buy and agent-filtered catalog (guest may still see public Active products if product policy allows — confirm with BA; prototype shows FA-filtered after login)

---

## 7) Checklist

- [x] Library filters + agent-hidden product demo  
- [x] My draft quotes + limit copy  
- [x] Calculator 2-step flow + Save draft / Buy  
- [x] Offline banner + draft sync messaging  
- [x] Submitted → 30-day validity → EXPIRED copy  
- [x] Theme-align `personal-accident.html` (detail) to cream/Coolors  
- [ ] Multi-product calculator picker  
- [ ] Web Portal setup screens (Active toggle, draft limit, validity days)  
- [ ] Formal quotation PDF / Core document handoff mock  
