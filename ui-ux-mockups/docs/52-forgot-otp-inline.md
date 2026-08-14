# 52 — Forgot Password OTP on one screen (left wireframe)

**Source:** LoginRegister Forgot artboard — **left** layout (inline OTP + GET CODE + CONFIRM)  
**Overrides:** `43` “Forgot = mobile + GET CODE only · push `/otp`” for **Forgot only**  
**Keep:** Register still uses full-screen `OtpVerifyPage` (6 boxes)  
**Related:** `41` · `43` · FR-01 SMS OTP  
**Date:** 2026-08-14

**Ask:** Forgot OTP must stay on **Forgot Password** — no next screen, no OTP Verification modal. Use the **left** PNG only.

---

## 1. Two OTP UIs on the PNG — pick one for Forgot

| Side | UI | Use |
|------|-----|-----|
| **Left** | Same page: Mobile · OTP field + **GET CODE** · Resend · `06:00` · **CONFIRM** | **Forgot happy path** |
| **Right** | Overlay **OTP Verification** · 6 boxes · CONFIRM · Resend | **Do not use** for Forgot |

Current Flutter: GET CODE → `context.push(AppRoute.otp)` (`OtpVerifyPage`). That is the extra screen. Remove that hop for Forgot.

---

## 2. Target layout (one `ForgotPasswordPage`)

```
←
Forgot Password

Enter Your Mobile Number *
[ 09 750337968                    ]

OTP Code *              [ GET CODE ]
Don't get a code? Resend          06:00

[ CONFIRM ]
```

| Piece | Rule |
|-------|------|
| Mobile | Always visible · required · `09…` |
| OTP field | **Single** outlined field (left PNG), not 6 boxes · 6 digits · numeric |
| GET CODE | **Same row** as OTP field (trailing compact button), not a full-width bottom CTA |
| Timer | `06:00` → `00:00` (`otpResendSecondsForgot` = 360) · start on successful GET CODE / Resend |
| Resend | `TextButton` · enabled only when timer hits `00:00` |
| CONFIRM | Full-width primary at bottom · verifies OTP · then **Update Password** (still a new page — password is a different job) |

“Stay on one screen” = **mobile + OTP + confirm** together. After a valid OTP, **Update Password** is still the next step (`42` / `43`). Do not fold password fields onto Forgot.

---

## 3. State machine (same route)

```
idle
  GET CODE (mobile valid)
    → sending (button busy)
    → codeSent: timer 06:00, focus OTP
CONFIRM (6 digits)
  → checking
  → OK → push Update Password
  → fail → field error (prototype: empty / short only; any 6 digits OK)
Resend (timer 0)
  → same as GET CODE, stay on page
Back
  → Login (no OTP page on the stack)
```

| Event | Stay | Leave Forgot |
|-------|------|----------------|
| GET CODE | Yes | No |
| Resend | Yes | No |
| Wrong / short OTP | Yes | No |
| CONFIRM success | — | Update Password only |
| GET CODE | **Must not** `push(AppRoute.otp)` | |

---

## 4. Show / hide vs always on

PNG left shows OTP row **from the start**.

**P0:** Always show Mobile + OTP row + GET CODE + CONFIRM.  
Timer + Resend: show after first successful GET CODE (cleaner) **or** always with timer `00:00` until send — prefer **after first send** so Resend is not a dead control.

CONFIRM before GET CODE: inline error “Get a code first” (or disable until `_codeSent`). Prefer **enabled button + error** so the CTA is visible like the PNG.

---

## 5. GET CODE vs CONFIRM (two jobs)

| Button | Does |
|--------|------|
| GET CODE | Validate mobile · fake SMS delay · start 06:00 · **do not navigate** |
| CONFIRM | Validate 6-digit OTP · fake delay · `push` Update Password |

Do not merge them into one button. Left PNG has both.

---

## 6. Register vs Forgot (do not mix)

| Flow | OTP UI |
|------|--------|
| **Forgot** | Inline on Forgot (this doc) |
| **Register** | Keep `OtpVerifyPage` 6-box full screen |

`AppRoute.otp` stays for Register. Forgot never pushes it.  
`AppOtpVerifyDialog` stays unused for this journey (`43`).

6-box `AppOtpField` is **not** the left Forgot field. Reuse `AppTextField` + `maxLength: 6` + digit formatters.

---

## 7. Flutter map

| File | Change |
|------|--------|
| `forgot_password.dart` | OTP `AppTextField` + compact GET CODE in a `Row` · Resend/timer under it · CONFIRM bottom · delete `context.push(otp)` from GET CODE |
| `otp_verify.dart` | Unchanged (Register) |
| `navigator.dart` | No new route |
| Prototype | Any 6 digits OK · timer 360s · Resend `TextButton` |

---

## 8. What not to do

- Don’t open `OtpVerifyPage` from Forgot  
- Don’t open OTP modal / dialog  
- Don’t put Update Password fields on Forgot  
- Don’t use 6 separate boxes on Forgot (that’s the right PNG)  
- Don’t drop Register’s OTP page  

---

## 9. Acceptance

- [x] Brainstorm documented (this file)  
- [x] Forgot GET CODE stays on the same screen  
- [x] OTP + GET CODE same row · CONFIRM on Forgot  
- [x] Success CONFIRM → Update Password only  
- [x] Register OTP still full-screen 6 boxes  

---

## 10. Related

LoginRegister.png (left Forgot) · `41` · `43` (Forgot hop **superseded here**) · `35` `AppTextField`  
