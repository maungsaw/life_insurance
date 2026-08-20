# FR-01 Secure Login & Authentication — UX / Prototype Plan

Sources:
- User FR-01 functional specification (v1.0)
- `15052026 - Agent App Business Requirement Document.pdf`
- Wireframe: `KBZ_UI&UX/Wireframe1/LoginRegister.png`
- Prototype: `KBZ Mobile ProtoType 1/login.html` (interactive multi-screen)

Design language: cream `#F7F3EC` · Coolors sky/steel/baltic/deep · soft cards · wireframe IA preserved.

---

## End-user vs team (confirmed)

**Phone frame = agent-facing only.** No “simulate”, no JWT jargon, no Path A/B labels.

| Layer | What agents see | What team uses for QA |
|---|---|---|
| Happy login | LOGIN → Biometric offer → Home | — |
| Register OK | CONTINUE → OTP → Create PW → Login | — |
| Register pending | System modal “pending review” | QA chip: Path B modal |
| Session conflict | Modal “already logged in…” | QA chip: Session block |
| Locked | Locked screen + support copy | QA chip: Locked |
| Screen jump chips | Hidden under “Team preview” | Open `<details>` |

### Copy rules
- Prefer plain language (“sign in again on all devices”) over “JWT revoked”
- Path A/B naming stays in BRD docs only, not in UI
- Edge states appear only when backend returns that status — never as a menu of simulations

---

## 1) Screen map (shipped in prototype)


| Screen | Purpose |
|---|---|
| Splash | Brand entry |
| Login Account | Phone + Password, Forgot, Register |
| Register Account | Name, Mobile, NRC, Email?, Referral? |
| OTP Verification | 6-digit SMS OTP (reg / MFA / forgot) |
| Create Password | Policy checklist |
| Forgot Password | Mobile lookup |
| Reset Password | **Mandatory Remark** + new password |
| Account Locked | After 5 failed attempts |
| Biometric prompt | Post first successful password login |
| Modals | Path B, concurrent session, success |

---

## 2) Registration

### Path A — Mobile exists & ACTIVE in Core
1. Details → Submit  
2. Core lookup OK  
3. SMS OTP (internal API)  
4. Create password → onboarding complete → Login  

### Path B — Mobile NOT in Core
1. Details → Submit  
2. **No self-register on app**  
3. Save to Web Portal **Application List**  
4. Admin verifies → creates in Core → approve SMS  
5. User reopens app → completes **Path A**  

Copy (Path B modal): explain Application List + SMS + return to Path A. Never imply open public signup.

---

## 3) Login & MFA
- Credentials: **Phone Number + Password / OTP** (Mobile = Web)
- MFA OTP via KBZ Life SMS API when required
- After first password success → optional Biometric enable (Fingerprint / Face ID)
- Biometric On/Off in Settings later

---

## 4) Session rules (must show in UI)
| Rule | UX |
|---|---|
| 1 Mobile + 1 Web concurrent | Allowed (no alert) |
| 2nd Mobile or 2nd Web | Block login + alert: *already logged in on another … device* |
| Password change / reset | Revoke all JWT + refresh · force logout all platforms |
| Silent refresh | Background renew while active |
| Absolute / inactivity | **7 days** → re-auth |

---

## 5) Lockout & OTP limits
- Failed password: **5** (admin-configurable) → status LOCKED  
- Unlock: **Web Portal admin only** (no auto unlock)  
- OTP requests: **max 3** per session/onboarding attempt  
- UI: countdown Resend, disable after 3, clear error copy  

---

## 6) Forgot Password
1. Forgot link → enter mobile  
2. Exists → OTP  
3. Remark/Reason **required**  
4. New + confirm password (policy)  
5. Audit log (reason + timestamp)  
6. Force terminate all sessions  

---

## 7) Wireframe → design decisions
- Keep wireframe fields & order (Name from ID, Mobile, NRC, Email optional, Referral optional)
- Replace generic blue with Coolors deep CTA / steel links
- Lock + eye icons **inside** input padding (no overflow)
- OTP as discrete boxes (**6 digits — confirmed**)
- Success / warning modals centered over dimmed phone content

---

## 8) Out of scope on mobile auth
- Creating Sales Agents from Web “direct create” (internal roles only on portal)
- Client-facing app
- Auto-unlock after lockout

---

## 9) Acceptance checklist
- [x] Path A happy path clickable in prototype  
- [x] Path B modal + Application List messaging  
- [x] Concurrent same-platform alert copy exact  
- [x] Locked state after 5 fails  
- [x] Forgot → OTP → Remark required → revoke note  
- [x] Biometric only after primary auth  
- [ ] Dual language keys ready (MM / ENG)  
- [x] Phone format mobile; password policy visible  
- [x] **OTP digit count = 6 (confirmed)**  

---

## 10) Next
1. Wire `before-login` CTA → this `login.html` (already linked)  
2. ~~Match `after-login.html` theme after biometric skip~~ **done**  
3. ~~Add Settings → Biometric On/Off mock~~ **done** (Profile sheet on after-login)  
