# FR-03 Client and Lead Management — UX Plan

Sources: FR-03 spec v1.0 · Agent App BRD · cream + Coolors continuity with Home.

Prototype: Customer tab inside `after-login.html` (same phone shell).

---

## 1) Roles

| Role | Platform | Scope | Can create / edit? |
|---|---|---|---|
| FA Agent | Mobile | Own Leads & Clients only | Yes — create/edit Lead, activity notes |
| Leaders | Mobile | Self + team hierarchy | View/search team profiles |
| Leaders | Web | Downline list/monitor | **Read-only** — no registration/create |

---

## 2) Mobile IA (FA) — Customer tab

Same bottom nav: Home · **Customer** · FAB · Product · Profile

### Top
- Title: Customer  
- Search (Name / Phone)  
- Segmented tabs: **Leads** | **Clients** (two distinct lists)

### Leads list
- Prospect cards: name, phone, status chip, last activity  
- FAB / primary: **New Lead**  
- Offline: create → local queue → sync when online (banner)

### Clients list
- Policyholder cards: name, phone, active policy count  
- Tap → Client profile

### Client profile
- Personal & contact  
- Active policies  
- Associated contacts / family  
- History & notes  

### Lead profile
- Details + Edit  
- Activity log (meeting / follow-up) — **send to server immediately**, not kept permanently on device  

### Conversion
- **Not a manual button**  
- After Core Policy Submit → Conversion API → Lead becomes Client automatically  
- UI: status updates on refresh/sync (toast optional: “Lead converted to Client”)

---

## 3) Offline & security
- Offline banner when disconnected  
- New Leads: encrypted local store → auto sync on reconnect  
- Activity logs: online-first; if offline, queue securely and flush ASAP (never long-term local archive of notes)  
- E2E / TLS for log payloads in transit  

---

## 4) Continuity with Home
- Same cream page, soft cards, Coolors, bottom nav  
- Guest: Customer tab → login sheet (already)  
- Logged-in: Customer tab → FR-03 lists  

---

## 5) Checklist
- [x] Leads / Clients segmented lists  
- [x] Search field  
- [x] New Lead sheet (end-user copy)  
- [x] Client profile sheet  
- [x] Offline queue hint  
- [x] No manual “Convert to Client” CTA  
- [ ] Leader team filter (Assigned Agent)  
- [ ] Web Portal read-only list mock (separate)  
