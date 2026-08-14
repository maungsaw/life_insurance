# 70 — Biometric login · Profile control (FR-01 / NFR)

**Source:** BRD §5.1 FR-01 · §6 Biometric Login/Authentication · HTML `s-bio` · docs `02` `07` `28` `50`  
**Flutter today:** Profile **Security** switch + Login Unlock CTA · persist `bio_metric` · simulator mock On (`70`)  
**Related:** FR-11 Profile settings · Change Password · Logout `28`  
**Date:** 2026-08-14

**Ask:** Add biometric. Home for the setting is **Profile**. Brainstorm everything needed — including extra UI/UX not on Agent Profile.png.

---

## 1. BRD jobs

| BRD | Meaning |
|-----|---------|
| **§6 Biometric Login/Authentication** | Fingerprint **or** Face ID on **supported devices** · convenience / faster access |
| **FR-01 Unified Login** | Password + SMS OTP remain the **identity** path. Biometric is **optional unlock**, not a replacement for CORE mobile + OTP on first enroll |
| **FR-01 Session timeout** | After inactivity, re-auth. If biometric enrolled → prompt bio first; else password |
| **FR-11 Change Password** | Separate. Changing password does **not** auto-disable bio; next unlock still needs a valid session/token |
| **Web** | No Face ID on portal (`07`) |

**Not biometric:** e-App signatures · policy signature display · remote wipe (`19`) · PIN-as-password.

**Language:** BRD “can support” = **optional**. Never block login if hardware missing or user skips.

---

## 2. Two surfaces (both needed)

| Surface | Job |
|---------|-----|
| **A · Profile (source of truth)** | Turn **on/off** after login. User asked for this. HTML: *“You can change this in Profile.”* |
| **B · Login (consume)** | If on + hardware ready → **Unlock with Face ID / fingerprint** · fallback **Use password** |
| **C · Post-OTP enroll (optional)** | First-time *Enable biometric / Skip* (`s-bio`). P1 if Profile toggle ships first |

**P0:** A + B.  
**P1:** C after OTP (don’t force; Skip → Home).  
**P2:** App resume / session timeout lock screen (same prompt as B).

---

## 3. Profile UI (add — not on PNG)

PNG Settings has Edit Profile · Change Password · FAQ · Language · Notification · Report. **Insert a Security block** so bio isn’t lost next to FAQ.

```
Setting
  Edit Profile >
  Change Password >

Security                         ← new section header
  [ fingerprint icon ]
  Biometric login          [ switch ]
  Face ID / fingerprint to open the app
  (or) Not available on this device

  FAQ >
  …
```

### Toggle row spec

| State | UI |
|-------|----|
| **Off · hardware OK** | Switch off · subtitle “Use Face ID or fingerprint next time you open the app.” |
| **On** | Switch on · subtitle names detected type: “Face ID” / “Fingerprint” / “Biometric” |
| **No hardware / simulator** | Switch **disabled** · subtitle “Not available on this device.” · no crash |
| **Busy** | Switch doesn’t flip until native prompt succeeds |

**Do not** use `ProfileSettingTile` chevron-only — this is a **preference**, like Notification prefs Switch.

### Extra UI (needed for a complete story)

| Extra | Why |
|-------|-----|
| **Enable sheet** | “Turn on biometric login?” · OS will ask Face ID / fingerprint · **Continue** / Cancel |
| **Native prompt** | `local_auth` · reason: “Confirm it’s you to enable biometric login.” |
| **Success toast/dialog** | “Biometric login is on.” |
| **Disable confirm** | “Turn off biometric login? You’ll use mobile number and password.” · Turn off / Cancel — **no** OS bio required to disable (user may have broken sensor) |
| **Failed enroll** | Stay Off · “Couldn’t verify. Try again or use password.” |
| **Login unlock button** | Fingerprint / Face icon under Sign in when enrolled |
| **Login fallback** | Always show password fields · “Use password instead” |
| **Lock screen (P1)** | Same copy when session times out — not a third design |

---

## 4. Flows

### Enable (Profile)

```
Switch Off → Continue
  → native biometric
       ├─ OK → persist flag true → Switch On
       └─ fail / cancel → stay Off
```

Prototype: if `local_auth` unavailable (simulator), **still allow mock On** with dialog *“Prototype: biometric mocked — no sensor.”* so UX review isn’t blocked (`37` Talsec/debug note). Label mock clearly.

### Disable (Profile)

```
Switch On → confirm sheet → flag false → Switch Off
```

Do **not** wipe refresh token. Next login = password + OTP as today.

### Login unlock (B)

```
Open Login
  if flag + hardware (or prototype mock)
    show secondary CTA: Unlock with Face ID
    on success → Home (same as password success)
    on fail → stay on Login · password still works
```

**Never** skip OTP on **first** device enroll. Bio only after a successful password/OTP session stored a token (`retrieveSessionWithBiometrics` already assumes refresh token).

Prototype P0: mock success → `context.go(Home)` like password `0000` path — don’t require real Keychain token if prototype mode skips APIs.

### Logout (`28`)

| Keep | Don’t |
|------|--------|
| Biometric **preference** can stay (faster next login on same device) | Don’t delete Face ID from the **phone** OS |
| Confirm logout still required | Don’t treat logout as remote wipe |

**Decision:** Logout clears session tokens; **keep** `bioMetric` flag so next visit can offer Unlock. If token gone, Unlock fails gracefully → password. Optional P1: “Log out on this device” vs “Log out and turn off biometric.”

### Change password

Keep bio on. Next Unlock uses new session after they log in with the new password once.

---

## 5. Copy (ENG)

| Place | Copy |
|-------|------|
| Section | Security |
| Title | Biometric login |
| Sub (generic) | Face ID or fingerprint to open the app |
| Enable title | Turn on biometric login? |
| Enable body | You’ll confirm with Face ID or fingerprint. You can turn this off anytime in Profile. |
| Disable title | Turn off biometric login? |
| Disable body | You’ll sign in with mobile number and password. |
| Login CTA | Unlock with Face ID · or Unlock with fingerprint · fallback **Unlock with biometric** |
| Login alt | Use password |
| Skip enroll | Skip for now |
| Unavailable | Not available on this device |

Myanmar: later with Language page — P1 strings in `AppLocalizations` if already wired; P0 English OK.

---

## 6. What not to do

- Don’t replace password/OTP as the only login  
- Don’t put biometric on web  
- Don’t use bio to sign e-App / policy  
- Don’t crash on simulator  
- Don’t hide password when bio is on  
- Don’t add a 6-digit app PIN unless product asks (BRD didn’t)  
- Don’t enroll from Login **before** first successful auth  

---

## 7. Flutter map (when building)

| Piece | Work |
|-------|------|
| Profile Setting | New **Security** section + switch row |
| `ProfileMockData` or cache | `biometricEnabled` bool · persist `CacheConstants.bioMetric` |
| Enable/disable | `BiometricService.authenticate` · then `write('true'/'false')` |
| Login | If enabled → Unlock CTA + `retrieveSessionWithBiometrics` / prototype shortcut |
| Optional `biometric_enroll.dart` | Post-OTP screen (P1) |
| Unavailable | Disable switch · subtitle |

Reuse Notification prefs Switch styling (primary track).

---

## 8. Phasing

| Phase | Scope |
|-------|-------|
| **P0** | Profile Security toggle · enable prompt · disable confirm · Login Unlock CTA (prototype mock OK) · unavailable state |
| **P1** | Post-OTP enroll Skip · session timeout lock · Face vs fingerprint label from `getAvailableBiometrics` |
| **P2** | Real token in Keychain · failed-attempt lockout copy from OS |

---

## 9. Acceptance

- [x] BRD §6 + FR-01 mapped · Profile is the control surface  
- [x] Extra UI listed (enable/disable sheets · Login unlock · unavailable)  
- [x] Optional vs password/OTP locked  
- [x] Flutter Profile toggle + Login consume (await implement)
- [x] Inventory updated

---

## 10. Related

BRD §6 · FR-01 · FR-11 · `07` · `02` flow 1.4 · `28` · `50` · `BiometricService` · HTML `s-bio`  
