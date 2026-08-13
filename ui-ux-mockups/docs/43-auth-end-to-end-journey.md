# 43 — Auth end-to-end journey (LoginRegister.png)

**Source:** `Wireframe/LoginRegister.png` (all auth + status + Home boards)  
**BRD:** FR-01 (BRD wins product rules) · wireframe wins layout  
**Flutter:** `lib/features/auth/` · `AppStatusDialog` · `AppBusyView`  
**Related:** `37` prototype · `40` register · `41` forgot · `42` OTP / password  
**Date:** 2026-08-13

**Goal:** One connected story from Splash to Home. Drop duplicate OTP doors, drop crossed-out modals, keep self-service confirm on **update** only.

---

## 1. Hub

**Login is the hub.** Every unfinished path returns here. Only a successful login opens FA Home.

```
Splash
  └─▶ Login ──LOGIN ok──▶ Home
         │
         ├─ Forgot Password? ──▶ Forgot ──GET CODE──▶ OTP Verification
         │                                              └─CONFIRM──▶ Update Password
         │                                                              └─SAVE──▶ dialogs ──▶ Login
         │
         └─ Register here ──▶ Register Account
                                 ├─ CORE fail ──▶ warning ──▶ Login
                                 ├─ pending demo ──▶ Registration in progress ──HOME──▶ Login
                                 └─ CORE ok ──busy──▶ OTP Verification
                                                       └─CONFIRM──▶ Create Password
                                                                      └─SAVE──▶ Success ──▶ Login
```

---

## 2. Screen jobs (one job each)

| Screen | Job | Next |
|--------|-----|------|
| Splash | Brand only | Login |
| Login Account | Identity + password | Home · Forgot · Register |
| Forgot Password | Who to send the code to | OTP Verification |
| OTP Verification | Enter 6-digit SMS | Create **or** Update Password |
| Create Password | First password after register | Success → Login |
| Update Password | New password after forgot | Self-service warning → updated → Login |
| Register Account | 5 fields, CORE gate | OTP **or** pending **or** cannot-register |
| Registration in progress | Waiting for KBZ invitation | HOME → Login (not FA Home) |
| Home | Logged-in FA dashboard | App tabs |

---

## 3. Decisions (conflicts in the PNG)

| Topic | Wireframe shows | Decision | Why |
|-------|-----------------|----------|-----|
| OTP UI | Modal **and** full screen | **Full-screen OTP Verification only** | Matches the dedicated artboard; one place to type 6 digits |
| Forgot OTP field | Inline OTP + GET CODE **and** separate OTP page | Forgot = **mobile + GET CODE + timer + Resend**. No inline OTP. CONFIRM on Forgot is not needed | Two OTP doors confuse demo and code |
| OTP modal (`AppOtpVerifyDialog`) | Forgot overlay | **Do not use** in this journey | Keep widget for later; primary path is the page |
| Use Existing Password? | Yes / No, **red X on PNG** | **Drop** | Stakeholder crossed it out; always set password after OTP |
| Password rules on Login (red list) | Login artboard | **Do not show on Login** | Login checks credentials, not composition. Rules live on Create / Update |
| Create vs Update | Two nearly identical screens | Same page, **title + dialogs differ** | Already `AuthPasswordMode` |
| Registration busy vs pending | Spinner **and** invitation screen | **Two states:** short busy (CORE check) vs **terminal pending** (wait for invite) | Different copy, different CTA |
| Pending HOME | HOME button | **→ Login**, never FA Home | BRD: no commission dashboard until approved |
| Self-service Warning / Updated | Two dialogs | **Update Password SAVE only** | Register is a new password, not a change to self-service |
| Create success | “Password has been created successfully” | Success dialog, **OK → Login** | Wireframe Success! |
| Forgot remark | Missing on PNG | Silent `"Password reset (forgot)"` | BRD audit later; don’t add a field now |
| OTP length | 4 in one overlay, 6 on page | **6** | SMS + `PrototypeConfig.otpLength` |
| Timer | `06:00` on OTP page | Forgot **and** OTP page = **360s**. Register OTP page can stay 45s **or** also 360s for visual match → prefer **360s on OTP Verification always** | One OTP screen, one timer look |
| Login fail | Error list / modal | Password `0000` → field error + warning dialog | Prototype demo |
| After login | Home board | `context.go(Home)` | Existing |

---

## 4. Three happy paths (prototype)

### A — Sign in
`Splash → Login → Home`

- Empty fields → inline errors  
- Password `0000` → **Login failed** warning  
- Any other non-empty pair → Home  

### B — Forgot password
`Login → Forgot → GET CODE → OTP Verification → CONFIRM → Update Password → SAVE`

1. **Warning:** “Your password will be updated on self-service. Do you want to proceed?” · **NO** stays · **YES** continues  
2. **Password Updated:** “The password has also changed for self-service. Please log in again.” · **OK → Login**

### C — Register (CORE ok)
`Login → Register (5 fields) → short busy → OTP Verification → CONFIRM → Create Password → SAVE`

1. **Success!** “The password has been created successfully.” · **OK → Login**  
2. Then path A to Home  

### C2 — Register pending (demo)
Mobile that fails CORE (not `09…` len≥9) keeps the **Cannot self-register** warning.

Optional later: a dedicated demo number (e.g. `09999999999`) opens **Registration in progress** full screen (invitation copy + HOME → Login). Until then, CORE-fail warning is enough.

---

## 5. Password rules (one catalog)

Shown **only** under Create / Update. Green ✓ when met. SAVE blocked until all five + confirm match.

1. Must be at least 8 Characters!  
2. Must contain at least 1 number!  
3. Must contain at least 1 Capital Case!  
4. Must contain at least 1 Small Case!  
5. Must contain at least 1 Special Characters!  

---

## 6. Dialog family (wireframe)

| When | Type | Title | Message | Actions |
|------|------|-------|---------|---------|
| Login `0000` | Warning | Login failed | Incorrect password | Try again |
| Register not in CORE | Warning | Cannot self-register | Contact manager / Application List | Back to Login |
| Update SAVE | Warning | Warning Message | Password will be updated on self-service. Proceed? | **NO** / **YES** |
| After YES | Success | Password Updated | Also changed for self-service. Please log in again. | OK → Login |
| Create SAVE | Success | Success! | Password has been created successfully. | OK → Login |

**Code gap:** `AppStatusDialog` is single-CTA today. Self-service warning needs **NO + YES**.

---

## 7. What not to wire

- Use Existing Password?  
- OTP overlay modal as the main forgot path  
- Password-rule checklist on Login  
- Pending HOME → FA dashboard  
- Real SMS / CORE / self-service APIs (prototype delays only)  
- Hamburger drawer vs bottom tabs (Home IA already decided in `34`)

---

## 8. Implementation brainstorm (make `43` shippable)

### Already OK
- Routes: Login · Forgot · OTP · CreatePassword · Register · Home  
- OTP page → Create vs Update by `AuthOtpPurpose`  
- Password rules catalog (5) + SAVE gate  
- Register 5 fields · CORE mock · short busy  
- Login fail demo (`0000`) · success → Home  

### Gaps vs this map

| Gap | Current | Target |
|-----|---------|--------|
| Forgot UI | Mobile + **inline OTP** + GET CODE + CONFIRM | Mobile + GET CODE (+ Resend/timer optional) only |
| OTP door | Forgot can still confirm inline | **Only** `OtpVerifyPage` confirms |
| Update SAVE | One success dialog | **Warning NO/YES** → then **Password Updated** |
| Create SAVE | Generic success copy | **Success!** + wireframe sentence · OK → Login |
| `AppStatusDialog` | One primary button | Optional **secondary** (NO) |
| OTP timer look | Forgot 360s · Register 45s | OTP Verification page always **06:00** |
| Pending screen | Busy spinner only | P1: invitation full screen (HOME → Login) |
| Login chrome | “Login to your account” | Optional: **Login Account** / **LOGIN** |

### Build order (P0 — one PR / one pass)

1. **`AppStatusDialog`** — add `secondaryLabel` + `onSecondary` (NO). Primary = YES/OK.  
2. **`CreatePasswordPage`**  
   - Create → Success! → Login  
   - Update → Warning (NO closes, YES continues) → Password Updated → Login  
3. **`ForgotPasswordPage`** — remove inline OTP + CONFIRM; GET CODE (and Resend) → push OTP. Back from OTP returns to Forgot.  
4. **`OtpVerifyPage`** — timer always `otpResendSecondsForgot` (06:00); keep CONFIRM → password.  
5. **Smoke** doc §9 paths A–C on device.  

### P1 (after P0 demo works)
- Registration **in progress** invitation page (not spinner) · HOME → Login  
- Login title/button copy polish  
- Comment-out / stop calling `AppOtpVerifyDialog` in auth journey (keep file)  

### Rules while coding
- No new screens except pending invitation (P1).  
- No API. Fake delays only.  
- Don’t reintroduce OTP modal as the happy path.  
- Don’t put password-rule list on Login.  
- After password success always `context.go(Login)` (clear stack).  

### Acceptance (P0)
- [x] Forgot has no second OTP door  
- [x] Update: SAVE → NO stays · YES → Updated → Login  
- [x] Create: SAVE → Success! → Login  
- [x] OTP page shows 06:00 · Resend `TextButton`  
- [ ] Demo script §9 walks clean on device  

### P1 done in same pass
- [x] Registration pending invitation page · HOME → Login (`09999999999`)  
- [x] Login chrome: **Login Account** · **LOGIN** · Register here  
- [x] `AppOtpVerifyDialog` unused in happy path (file kept)  

---

## 9. Demo script (one pass)

1. Splash → Login → `0000` → warning → correct password → Home  
2. Logout / back to Login → Forgot → GET CODE → 6 digits → CONFIRM → Update Password (meet 5 rules) → SAVE → NO (stay) → SAVE → YES → OK → Login  
3. Register `09123456789` → OTP → Create Password → Success → Login  
4. Register `123` → Cannot self-register → Login  

