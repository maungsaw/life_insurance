# 42 — Update Password + OTP Verification (wireframe)

**Source:** `Wireframe/LoginRegister.png` (Update Password + OTP Verification screens)  
**Flutter:** `create_password.dart`, `otp_verify.dart`, `app_password_rules.dart`  
**Date:** 2026-08-13

---

## OTP Verification (full screen)

| Element | Spec |
|---------|------|
| Title | **OTP Verification** |
| Input | 6 square boxes (`AppOtpField`) |
| Timer | Right-aligned **`06:00`** (360s) under boxes |
| Primary | **CONFIRM** |
| Footer | Don't get a code? **Resend** (`TextButton`) |
| After confirm | → **Update Password** (forgot) or **Create Password** (register) |

## Update Password

| Element | Spec |
|---------|------|
| Title | **Update Password** (forgot) / **Create Password** (register) |
| Fields | New Password *, Confirm Password * + eye |
| Rules (5, green ✓ when met) | ≥8 chars · ≥1 number · ≥1 Capital · ≥1 Small · ≥1 Special |
| Primary | **SAVE** → Login |

## Flow

```
Forgot → GET CODE → OTP Verification → CONFIRM → Update Password → SAVE → Login
Register → OTP Verification → CONFIRM → Create Password → SAVE → Login
```

## Decisions

1. Full-screen OTP page matches wireframe (not only modal).
2. Password rules match wireframe wording/checklist.
3. Resend = `TextButton` (primary when timer = 0).
