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

## 5. OTP cell layout (mobile responsive)

**Problem seen:** On phone-width frames (esp. Firefox), six OTP boxes overflow because native `<input>` has a large default `min-width`.

**UX rules**
| Rule | Why |
|------|-----|
| 6 equal cells in one row | Matches SMS OTP length; scannable |
| `grid` + `minmax(0, 1fr)` + `min-width: 0` on inputs | Prevents horizontal clip inside 390px phone |
| `clamp()` gap + font | Comfortable on small vs large phones |
| `maxlength="1"` + `inputmode="numeric"` | Digit-per-cell mental model; mobile keypad |
| Auto-advance (prod) | After digit, focus next cell; paste fills all |
| Resend + timer below cells | Don’t compete with Verify CTA |
| Error: shake row + inline “Invalid or expired OTP” | Keep cells visible; don’t wipe on first fail |

**Don’t:** single wide text field for OTP on mobile (harder to scan); don’t use fixed `px` widths that break at 320–360 CSS px.

---

## 5b. User-facing copy (no architecture jargon)

**Problem:** Labels like “Unified login”, “CORE”, “mobile & web”, “OTP + reason” explain the *system* to stakeholders but confuse field agents.

**Principle:** Auth UI speaks to the FA — what to do next — not how platforms are wired.

| Avoid on screen | Prefer |
|-----------------|--------|
| Unified login / Unified Agent identity | Welcome back · KBZ LIFE Agent |
| Same account on mobile & web | (omit — user doesn’t need this to sign in) |
| Mobile must be active in CORE | Error only if fail: “This number isn’t active. Contact your manager.” |
| OTP / SMS OTP (as primary label) | “SMS code” / “6-digit code” |
| Forgot password (OTP + reason) | Forgot password? |
| Reason / remark * | Why are you resetting? * |

**Where “unified” belongs:** BRD, internal docs, stakeholder decks — not login chrome.

**Error moments (keep helpful):** inactive number, wrong password, expired code, too many attempts — short, action-oriented.

---

## 6. Acceptance

- [ ] Mobile and web share mobile + password + OTP sequence  
- [ ] Web states it is the same Agent identity *(stakeholder/docs — optional one-line on web login only if needed)*  
- [ ] Forgot password requires remark on both  
- [ ] CORE registration gate messaging appears **on error**, not as default login copy  
- [ ] After web OTP, user lands in portal; after mobile OTP, Home  
- [x] Mobile OTP six cells fit inside phone frame (no horizontal overflow)  
- [x] Mobile login removes “Unified login” callout and CORE/web jargon from default copy  
