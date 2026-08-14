# 53 — Forgot GET CODE one line + OTP row UX

**Source:** Forgot Password scrcpy (GET CODE wrapping) · left LoginRegister artboard  
**Related:** `52` inline OTP  
**Date:** 2026-08-14

**Ask:** GET CODE must stay **one line**. OTP stays on the same Forgot screen — tighten the row so it feels like one job, not a squeezed extra button.

---

## 1. Why it wrapped

`AppButton` is full-width with **default** `ElevatedButton` horizontal padding (~24px each side). In a ~118px slot, leftover width is too small for **GET CODE** at 16px bold, so Flutter wraps to two lines.

**Fix shipped:** tighter padding · 13px label · `FittedBox` + `maxLines: 1` · slot ~128px. CONFIRM (full width) unchanged.

---

## 2. Row layout (keep)

```
[ OTP Code field ………… ]  [ GET CODE ]
Don't get a code? Resend              06:00
[ CONFIRM ]
```

Do **not** move GET CODE under the field (that’s a second CTA stack). Do **not** put GET CODE inside the OTP outline as a suffix — PNG is a separate filled chip.

| Piece | UX |
|-------|-----|
| OTP field | Grows (`Expanded`) · 6 digits |
| GET CODE | Fixed chip, **one line**, aligned to the input (not the label) |
| After send | Same label (GET CODE) · timer starts · focus OTP |
| Resend | Text link, not a second blue button |
| CONFIRM | Only primary at the bottom |

---

## 3. Feel “one screen” (P1 polish, not blockers)

| Issue | Do |
|-------|-----|
| GET CODE vs CONFIRM both blue | GET CODE = compact; CONFIRM = wide — already the hierarchy |
| Mobile still editable after send | OK — Resend uses current number |
| Invalid mobile (`123`) | Later: same `09…` gate as Register (`PrototypeConfig.isCoreMobileOk`) |
| GET CODE after code sent | Keep sending again (same as Resend) **or** disable until timer 0 — prefer **timer gates Resend**, GET CODE can stay tappable (restarts 06:00) |
| Keyboard | GET CODE → focus OTP · CONFIRM on keyboard done |

---

## 4. What not to do

- Don’t go back to `/otp` page or modal  
- Don’t use 6 boxes on Forgot  
- Don’t shrink CONFIRM to share the OTP row  

---

## 5. Acceptance

- [x] GET CODE renders on one line  
- [x] Inline Forgot OTP unchanged (`52`)  
- [ ] Optional: `09…` mobile gate on GET CODE (P1)  
