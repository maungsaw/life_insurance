# Forgot Password + OTP (wireframe) — Flutter prototype

**Surface:** Flutter `lib/` · no API  
**Wireframe:** Forgot Password screen + OTP Verification modal (LoginRegister set)  
**BRD:** FR-01 SMS OTP · password reset remark (audit)  
**Related:** `35` widgets · `38` prototype · `40` register  

---

## 1. Ask

Match stakeholder Forgot / OTP UI:

### Forgot Password (full screen)
- Back · title **Forgot Password**
- **Enter Your Mobile Number ***
- **OTP Code** field + **GET CODE** (same row)
- **Don't get a code? Resend** · timer **`06:00`**
- **CONFIRM**

### OTP Verification (modal)
- Title **OTP Verification** · close **X**
- “Please Enter the code sent to +95…”
- **6** digit boxes
- Timer **06:00** · **CONFIRM** · Resend link

---

## 2. Gap vs current app

| Current | Wireframe |
|---------|-----------|
| Mobile + Remark → push `/otp` page | Mobile + GET CODE on **same** screen |
| Separate OTP route | OTP as **modal** (6 cells) |
| 45s resend | **06:00** (6 min) countdown |
| Send OTP primary CTA | GET CODE then CONFIRM |

---

## 3. Decisions

| Topic | Decision |
|-------|----------|
| Primary flow | GET CODE → open OTP modal → CONFIRM → Create/Update password |
| Inline OTP field | Shows code after modal confirm (or typing sync); optional paste |
| Timer | `PrototypeConfig.otpResendSeconds = 360` for forgot (06:00) |
| Remark (BRD) | Not on wireframe — pass prototype default `"Password reset (forgot)"` until API; document for later audit field |
| Register OTP | Keep existing `/otp` page **or** reuse modal later (P1) |
| No API | Fake send + any 6 digits OK |

---

## 4. Widgets

| Piece | Implementation |
|-------|----------------|
| GET CODE row | Forgot page composition + compact primary button |
| 6-box OTP | Existing `AppOtpField` |
| Modal | New `AppOtpVerifyDialog.show(...)` |
| Timer text | `mm:ss` from remaining seconds |

---

## 5. Acceptance

- [x] Brainstorm documented  
- [x] Forgot UI matches wireframe structure  
- [x] GET CODE + 06:00 timer + Resend  
- [x] OTP modal with 6 cells + CONFIRM → password  
- [ ] Real SMS API · mandatory remark UI when product requires  

---

## 6. Related

FR-01 · LoginRegister.png · `OtpVerifyPage` (still used by Register)  
