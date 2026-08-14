# 56 — Customer Details: Phone → dialer · Email → mail app

**Source:** Customer Details Phone/Email actions · scrcpy “Phone / OK” dialog  
**Flutter today:** `_phone` / `_email` → `AppStatusDialog` (info + OK). No `url_launcher`.  
**Related:** `51` (explicitly allowed `tel:` / `mailto:` when available)  
**Date:** 2026-08-14

**Ask:** Tap **Phone** should leave the dialog and open the device **Phone** UI with that number. **Email** should do the same for mail. No extra OK step when the OS can handle it.

---

## 1. Target behavior

| Tap | Success | Empty / fail |
|-----|---------|----------------|
| **Phone** | Open system dialer / Phone app with `09 750337968` (normalized) | Dialog only if launch fails |
| **Email** | Open mail composer `to: may@gmail.com` | No address → short dialog. No mail app → fail dialog |
| **Profile** | Unchanged — push Customer Profile Details |

**Drop** the current “Phone / 09… / OK” and “Email / … / OK” happy-path dialogs. They block the job.

---

## 2. Call vs dialer (important)

“တန်းဝင်” = **leave our modal and enter the Phone app**, not necessarily start ringing without a confirm.

| Mode | URI / intent | Permission | UX |
|------|----------------|------------|-----|
| **Dialer (P0)** | `tel:+959750337968` | None | Number filled; user taps Call in the Phone app |
| Direct `CALL` | `tel:` + `CALL_PHONE` | Dangerous permission | Starts ringing immediately — surprising, skip for prototype |

**P0 = dialer.** Matches field-agent “call this client” without a new Android permission prompt. Huawei / Samsung still land in Phone.

Do **not** use in-app `url_launcher` webview. `LaunchMode.externalApplication`.

---

## 3. Number & email normalize

| Input | Launch |
|-------|--------|
| `09 750337968` | `tel:+959750337968` (MM local `09` → `+95` + rest without leading 0) |
| Already `+95…` | Use as-is (digits / `+` only) |
| Email | `mailto:may@gmail.com` · trim · no extra `subject` P0 |

Empty / garbage number → don’t launch; inline-style `AppStatusDialog` “No phone on file”.

---

## 4. Package & OS plumbing

Add **`url_launcher`**. Small helper (e.g. `lib/core/launch/app_external_launch.dart`) so Customer Details doesn’t own `Uri` logic.

**Android 11+** `queries` in `AndroidManifest.xml`:

```xml
<queries>
  <intent>
    <action android:name="android.intent.action.DIAL" />
    <data android:scheme="tel" />
  </intent>
  <intent>
    <action android:name="android.intent.action.SENDTO" />
    <data android:scheme="mailto" />
  </intent>
</queries>
```

**iOS** `LSApplicationQueriesSchemes`: `tel`, `mailto` (needed for `canLaunchUrl`).

`canLaunchUrl` false or `launchUrl` throws → one fail dialog: “Couldn’t open Phone” / “Couldn’t open Mail” + the number/address (copy later P1).

---

## 5. UX details

- No confirmation sheet before dialer (“Call May?”) on P0 — extra tap. Phone app is the confirm.  
- Don’t auto-return a snackbar after coming back.  
- Disable double-tap while launching (`busy` flag).  
- Profile bubble stays in-app.  
- Same helper can serve Lead detail later; don’t wire Leads in this pass unless already identical.

---

## 6. Flutter map

| Piece | Action |
|-------|--------|
| `pubspec.yaml` | `url_launcher` |
| Manifest / Info.plist | `tel` + `mailto` queries |
| New helper | `launchPhone(raw)` · `launchEmail(raw)` |
| `CustomerDetailPage` | `_phone` / `_email` call helper; dialogs only on empty/fail |

---

## 7. What not to do

- Don’t keep OK dialog on the success path  
- Don’t request `CALL_PHONE` / start a call without the dialer  
- Don’t `sms:` on the Phone button  
- Don’t open Gmail in a WebView  

---

## 8. Acceptance

- [x] Brainstorm documented (this file)  
- [x] Phone tap → system Phone/dialer with number  
- [x] Email tap → mail composer when address exists  
- [x] Fail/empty still a short dialog, not a crash  
- [x] No `CALL_PHONE` permission  

---

## 9. Related

`51` Customer Details actions · `CustomerDetailPage` `_phone` / `_email`  
