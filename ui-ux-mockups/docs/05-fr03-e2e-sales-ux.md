# FR-03 — FA End-to-End Sales Process (Client & Lead UX)

**BRD ref:** §5.3 FR-03 Client and Lead Management (Mobile)  
**Also connects:** FR-04 Quote → FR-05 e-App → FR-06 Policy (convert trigger)

---

## 1. What FR-03 really is

FR-03 is not “a CRM list.” It is the **relationship spine** of the entire sales process:

```
Prospect (Lead)
   → nurture (notes, tasks, quotes)
   → e-Application
   → Approved policy issuance
   → Convert Lead → Client
   → Servicing (active/lapsed policies, family, renewals)
```

| BRD item | UX must show |
|----------|--------------|
| Separate searchable **Leads** vs **Clients** | Hard split (tabs), never mix rows without clear type |
| **Add / Edit** lead | Full form + edit from lead profile |
| **Convert** on successful policy issuance | System-driven convert + visible confirmation; manual convert only if ops allows |
| **Client profile** | Contact · Active/Lapsed policies · Family/associated contacts · Notes/activity |

---

## 2. Object model (for UI)

### Lead
- Identity & contact (name, mobile, email, address optional)
- Stage / temperature (New · Contacted · Quoted · Applied · Won/Lost)
- Linked **saved quotes**
- Linked **draft/submitted apps**
- Activity log (calls, visits, notes)
- Owner = FA (hierarchy-scoped)

### Client (after conversion)
- Everything on Lead **plus**
- Active policies + lapsed policies (read-only from Core)
- Family / associated contacts (spouse, children, referrals)
- Servicing alerts (due / renewal) surface here

**Conversion rule (happy path):** App status → **Approved** ⇒ Lead becomes Client; historical quotes/apps remain on profile; policy appears under Active.

---

## 3. Screen set (required)

| Screen | Purpose |
|--------|---------|
| Leads list | Search, filter by stage, add lead |
| Lead profile | Contact, stage, quotes, apps, notes, CTA: Quote / e-App / Edit |
| Add / Edit lead | Validated fields (mobile format, email) |
| Clients list | Search, due badges, policy count |
| Client profile | Contact + tabs: Policies · Family · Activity · Quotes |
| Convert moment | Banner/sheet: “Maung Soe is now a Client” with deep link |
| Empty / offline | Create lead offline; clients read-only if cached |

---

## 4. Concept-specific CRM tone

| Concept | FR-03 expression |
|---------|------------------|
| **A Field Momentum** | Hot/Warm pills, big “Convert / Quote” CTAs, pipeline energy |
| **B Trust & Clarity** | Calm stages, guided “next best action”, family as care network |
| **C Command Center** | Stage funnel counts, dossier density, signal badges on due/lapse |

---

## 5. End-to-end sales path (FA daily)

1. Add Lead (People)  
2. Note + task  
3. Product → Quote → Save to Lead  
4. Start e-App (pre-fill)  
5. Tracker → Approved  
6. Auto-convert → Client profile shows new Active policy  
7. Family contact added for referral / beneficiary awareness  
8. Premium due reminder loops back to Client profile  

---

## 6. Acceptance checklist

- [ ] Leads and Clients are separate searchable lists  
- [ ] Lead can be edited after create  
- [ ] Lead profile shows quotes + apps + notes  
- [ ] Client profile shows active **and** lapsed policies  
- [ ] Family / associated contacts visible on client  
- [ ] Activity/notes timeline present  
- [ ] Conversion from Approved is explicit in UI  
- [ ] Quote / e-App CTAs available from both Lead and Client profiles  
