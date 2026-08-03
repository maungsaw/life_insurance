# Unified Login UX (Mobile + Web) — FR-01

**BRD:** *Unified Login: A secure login mechanism with a unified login experience across both mobile and web platforms.*  
Also: App registration gate · SMS OTP · Session timeout · Forgot password (OTP + mandatory remark) · Biometric (mobile optional)

---

## 1. What “unified” means in UX

| Unified | Not the same as |
|---------|-----------------|
| Same **identity** (CORE-registered mobile) | Same visual skin pixel-for-pixel |
| Same **auth steps**: Mobile → Password → SMS OTP | Copy-pasting mobile chrome onto web |
| Same **recovery**: Forgot password + OTP + **reason/remark** | Separate password products per channel |
| Same **session policy language** (inactivity / 7-day logout) | Identical biometric on web (web may use remember-device differently) |
| Shared branding + field labels (ENG/MM) | Blocking managers from web if they only use portal |

**Principle:** A user who learns login on mobile can complete web login without re-learning — same mental model, same errors, same support story.

---

## 2. Shared auth flow

```
Enter mobile (CORE check)
   ├─ Not in CORE / inactive → stop + Backend Application List message
   └─ Active → Password
         → SMS OTP (internal KBZ API)
              ├─ Mobile: optional biometric enroll → Home
              └─ Web: enter portal Overview (role-aware)
```

**Forgot password (both channels)**  
1. Enter mobile → OTP  
2. Mandatory **remark/reason**  
3. Set new password → confirm → back to login  

---

## 3. Screen set

### Mobile
- Splash · Login · OTP · Biometric (optional) · Forgot (OTP + reason + new password)

### Web
- Web Login (same fields + “Same account as the Agent App”)  
- Web OTP  
- Web Forgot (parity)  
- Then role-based portal  

---

## 4. Concept tones

| Concept | Unified login expression |
|---------|--------------------------|
| **A Field Momentum** | Energetic “One account. Field or desk.” amber trust strip |
| **B Trust & Clarity** | Institutional seal, security microcopy, calm OTP |
| **C Command Center** | “AUTH GATE / SESSION LATCH”, device trust language |

---

## 5. Acceptance

- [ ] Mobile and web share mobile + password + OTP sequence  
- [ ] Web states it is the same Agent identity  
- [ ] Forgot password requires remark on both  
- [ ] CORE registration gate messaging appears where relevant  
- [ ] After web OTP, user lands in portal; after mobile OTP, Home  
