# Prototype mode — LoginRegister → Home (no API)

**Roles:** Senior Mobile · UI/UX  
**Wireframe:** `/Wireframe/LoginRegister.png`  
**BRD still guides scope:** FR-01 / FR-02 · `34` (BRD wins conflicts)  
**Code today:** Flutter `lib/` auth + Home mock (`35` · `36`)  
**Hard rule:** **Zero network / Core / OTP / commission APIs** in this phase — local UI + fake delays only

---

## 1. What “prototype” means here

| Prototype **is** | Prototype **is not** |
|------------------|----------------------|
| Clickable path Splash → Auth → Home | Production security / real OTP |
| Wireframe-faithful screens + states | Backend integration |
| Local validation + mock success/error | Real CORE agent lookup |
| Stakeholder demo on device / emulator | Release candidate |
| DRY widgets reused everywhere | Duplicate one-off UIs |

**Demo goal:** Anyone can walk LoginRegister.png left→right without waiting on APIs.

---

## 2. Source priority (prototype)

1. **Wireframe** `LoginRegister.png` → layout, copy tone, modals, home board  
2. **BRD** → what must exist later (don’t invent payout / open signup)  
3. **Docs `35`/`36`** → widgets + Home blocks already defined  

If wireframe shows wallet payout or open public register → **prototype may show the screen**, but label/copy stays BRD-honest (commission display · CORE-gated register).

---

## 3. End-to-end prototype map (LoginRegister.png)

```
┌─────────┐   ┌─────────┐   ┌──────────────┐
│ Splash  │──▶│ Login   │──▶│ Home (FA)    │
└─────────┘   └────┬────┘   └──────────────┘
                   │
     ┌─────────────┼─────────────┐
     ▼             ▼             ▼
 Forgot        Register       (invalid → error UI)
     │             │
     ▼             ▼
   OTP           Busy / pending
     │             │
     ▼             ▼
 Create/Update   OTP → Create password
 Password            │
     │               ▼
     └──── Success modal ──▶ Login
```

### Screen checklist (prototype)

| # | Screen | Wireframe | Status in app | Prototype behavior |
|---|--------|-----------|---------------|--------------------|
| 1 | Splash | Logo center | Done | Auto → Login (~1.2s) |
| 2 | Login | Mobile + password · Forgot · Register | Done | Local validate · any non-empty → Home |
| 3 | Login error | Red under fields | Partial | Empty / demo “wrong password” path |
| 4 | Forgot | Mobile + remark (BRD) | Done | Fake send → OTP |
| 5 | OTP | 6 cells · Resend | Done | Any 6 digits → password |
| 6 | Create / Update password | Rules checklist | Done | Rules must pass · Success → Login |
| 7 | Register | Name · mobile · email | Done | Mock CORE: `09…` len≥9 OK · else warn dialog |
| 8 | Registration in progress | Busy | Done | `AppBusyView` then OTP |
| 9 | Success / Warn / Info modals | Center cards | Done | `AppStatusDialog` |
| 10 | Home | Commission · services · promos | Done (mock) | Stub taps → info dialogs |
| 11 | Side drawer | Blue menu | **Gap** | Optional P1 — IA prefers bottom tabs (`34`) |
| 12 | Home bottom nav (wireframe 4–5 items) | Mixed | Partial | Keep app tabs: Home · Leads · Customers · Tasks · More |

---

## 4. Mock rules (no API contract)

Keep in one place later: `lib/.../prototype_config.dart` (optional).

| Rule | Value | Why |
|------|-------|-----|
| Login success | Non-empty mobile + password | Fast demo |
| Login fail (optional demo) | password `0000` → Warn dialog “Incorrect password” | Show error modal from wireframe |
| Forgot remark | Required | BRD FR-01 audit |
| OTP | Length 6, any digits | No SMS |
| Resend | Local 45–60s timer UI (optional polish) | Wireframe timer |
| Register CORE OK | Mobile starts with `09` and length ≥ 9 | Honest gate without API |
| Register CORE fail | Else → Warning + “backend Application List” | BRD |
| Password | Wireframe rules via `AppPasswordRules` | Shared |
| Home numbers | `HomeMockData` | FR-02 shell |
| Delays | 400–900 ms | Feel of network without network |

**Never in prototype:** Dio calls for auth · real Talsec block on debug that stops demo · remote wipe triggers that wipe the device during UX review.

---

## 5. UX fidelity backlog (wireframe polish)

### P0 — Demo-ready (must feel complete)

- [x] Splash · Login · Forgot · OTP · Password · Register · Home mock  
- [x] Login **explicit error state** (password `0000` → warn modal + field error) — `lib/` `38`  
- [x] OTP resend countdown 45s — `lib/`  
- [x] Home service tiles switch tabs (Leads · Customers · Tasks · More) — `MainTabScope`  
- [x] Flutter-only pass documented (`38`); HTML skipped  

### P1 — Closer to PNG

- [ ] Register pending **full screen** copy variant  
- [ ] Commission **history** stub page  
- [ ] Notification inbox stub from header bell  

### P2 — Defer / don’t block demo

- [ ] Hamburger drawer (wireframe) — conflicts with bottom-tab IA; skip or Put under More  
- [ ] Center FAB / QR from alternate home variants  
- [ ] Guest / pre-login calculator (`Calculator(Before login).png`)  

---

## 6. Engineering rules while prototyping

1. **No repository network** for auth/home — if a repo exists, return `Future.value(mock)`.  
2. **Feature flags:** `kPrototypeMode = true` (or `--dart-define=PROTOTYPE=true`) to skip freerasp hard-stop in debug demos if needed.  
3. **DRY only** — new screens compose `App*` widgets (`35`).  
4. **Comment, don’t delete** when hiding API hooks.  
5. Document every new screen in `03` + gallery when added.

---

## 7. Stakeholder demo script (5 minutes)

1. Cold start → Splash logo → Login  
2. Empty Login → field errors  
3. Login with any ID → Home (commission · services · MDRT · promos)  
4. Back / More not required — from Login: Forgot → OTP `123456` → Update password (meet rules) → Success → Login  
5. Register with `09123456789` → Busy → OTP → Create password → Success  
6. Register with `123` → CORE warning dialog  
7. Home: tap Commission · Team · bell → stub explanations  

---

## 8. Acceptance (prototype phase)

- [x] Brainstorm documented (this file)  
- [x] Auth + Home runnable **without** API  
- [ ] P0 polish items closed  
- [ ] Demo script walked on device once  
- [ ] Explicit “Prototype / sample data” only if stakeholders ask — default clean UI  

---

## 9. Related

`34` Wireframe×BRD · `35` DRY auth widgets · `36` Home mock · `Wireframe/LoginRegister.png` · FR-01 · FR-02  
