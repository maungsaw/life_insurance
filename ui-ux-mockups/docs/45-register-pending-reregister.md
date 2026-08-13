# 45 — Register again → Registration In Progress

**Source:** `Wireframe/LoginRegister.png` (Registration Inprogress artboard)  
**Gap:** First Register path exists (OTP → Create Password). **Re-register** does not show the pending invitation screen.  
**Flutter today:** pending only if mobile = `09999999999`  
**Related:** `40` fields · `43` journey · `37` prototype  
**Date:** 2026-08-13

---

## 1. What’s missing

First REGISTER (CORE-shaped `09…`) works:

```
Register → busy spinner → OTP → Create Password → Success → Login
```

If the **same person taps Register again** (same mobile), the app currently **repeats OTP / Create Password**.  
Wireframe leftover: **Registration Inprogress** — wait for KBZ invitation · **HOME**.

That screen is a **terminal status**, not the short spinner.

| Widget | Job | CTA |
|--------|-----|-----|
| `AppBusyView` | Few hundred ms “checking…” | none |
| `RegistrationPendingPage` | Already submitted · waiting invite | **HOME → Login** (not FA Home) |

---

## 2. Agent states (one mobile = one story)

| State | Meaning | Register again | Login |
|-------|---------|----------------|-------|
| **Unknown** | Never submitted | First-time path | Fail / empty |
| **Pending invite** | Application in Application List | **Same pending screen** (no new OTP) | Show pending · **do not** open Home |
| **Active** | Password created (or already in CORE) | “Already have an account” → Login | Password OK → Home |
| **Not in CORE** | Cannot self-register | Warning dialog | n/a |

BRD: no commission Home until the agent is invited / active.

---

## 3. Prototype decisions (no API)

Session memory on `PrototypeConfig` (static set — enough for demo; lost on restart):

| Event | Remember |
|-------|----------|
| REGISTER tap, CORE ok, first time | After OTP + SAVE success → mark mobile **active** |
| REGISTER tap, pending demo **or** already pending | Stay / go **pending** |
| Optional: first REGISTER for a “apply” demo number | Mark **pending** immediately (no OTP) |

**Demo numbers (keep simple):**

| Mobile | First REGISTER | Second REGISTER | Login |
|--------|----------------|-----------------|-------|
| `09123456789` (any other `09…` ≥9) | OTP → Create Password → **active** | Dialog: already registered → Login | Home |
| `09999999999` | **Pending** screen | **Pending** again | **Pending** (not Home) |
| `123` / not `09…` | Cannot self-register | Same warning | n/a |

**Re-register of a pending number** = skip form success path; `go` pending page. Do not send OTP again.

**Already active** = do **not** use the pending artboard (they are invited). Use:

> Title: Already registered  
> Message: This mobile already has an account. Please log in.  
> CTA: Login Now  

---

## 4. Screen copy (match PNG)

| Element | Copy |
|---------|------|
| Title | **Registration Inprogress** (wireframe spelling) |
| Body | Your registration is in pending stage and please kindly wait invitation from KBZLIFE Insurance. |
| Icon | Teal/primary **circle + three dots** (in-progress), not chat bubble |
| Button | **HOME** |

HOME = `context.go(Login)`. Never `Home` dashboard.

No back into Register with a dirty stack — `go` pending so Back does not resubmit.

---

## 5. Flow (connected)

```
Login → Register here
          │
          ├─ invalid / empty fields → stay
          ├─ not CORE → Cannot self-register → Login
          ├─ mobile already pending → Registration Inprogress → HOME → Login
          ├─ mobile already active → Already registered dialog → Login
          └─ new CORE ok → busy → OTP → Create Password → Success → Login
                              (mark active)

Login with pending mobile → Registration Inprogress (same page)
Login with active + good password → Home
Login with 0000 → fail (unchanged)
```

---

## 6. What not to mix

- Busy spinner ≠ pending invitation  
- Pending HOME ≠ FA Home (pill nav)  
- Re-register ≠ second password  
- Active agent ≠ pending artboard  
- No duplicate Application List rows in prototype (idempotent)  

---

## 7. Flutter follow-up (when implementing)

1. `PrototypeConfig`: `Set` of pending mobiles + active mobiles; helpers `markPending` / `markActive` / `isPending` / `isActive`.  
2. Keep `09999999999` as **always pending** (first and later).  
3. After Create Password SAVE success → `markActive(mobile)`.  
4. Register submit: check pending → pending page; check active → dialog; else OTP.  
5. Login: if pending mobile → pending page before Home.  
6. Polish `RegistrationPendingPage` icon (ellipsis in circle) + centered layout like PNG.  
7. Busy copy: “Please wait…” only — do not reuse “Registration Inprogress” on the spinner.  

---

## 8. Acceptance

- [x] Brainstorm documented (this file)  
- [x] First CORE register still OTP → password → Login  
- [x] Same mobile pending → Inprogress screen (no second OTP)  
- [x] Same mobile active → already-registered → Login  
- [x] Login while pending → Inprogress, not Home  
- [x] HOME on pending → Login  
- [x] Spinner and pending page are visually different  

---

## 9. Related

`40` · `43` · FR-01 Application List · LoginRegister.png  
