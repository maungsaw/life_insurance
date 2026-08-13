# LoginRegister wireframe → DRY Flutter widgets

**Roles:** Senior Mobile · UI/UX  
**Wireframe:** `/Wireframe/LoginRegister.png`  
**BRD:** FR-01 Secure Login & Authentication · `34` source-of-truth  
**Code home:** `lib/features/components/` (shared) · composed on `lib/features/auth/`  
**Theme:** Existing `AppColors.lightPrimary` (`#00adee`) — matches wireframe blue

---

## 1. Ask

From LoginRegister wireframe, extract **reusable widgets** (DRY) so login / register / OTP / forgot / password screens never re-implement the same field, button, modal, or checklist.

---

## 2. DRY principle (how we apply it)

| Do | Don’t |
|----|--------|
| One `AppTextField` for all auth inputs | Copy `TextField` + decoration on every page |
| One `AppButton` (primary / secondary) | Inline `SizedBox` + `ElevatedButton` everywhere |
| One `AppOtpField` (6 cells) | Hand-rolled OTP boxes per screen |
| One `AppStatusDialog` (success / warn / info) | Three one-off dialog UIs |
| One `AppPasswordRules` + shared evaluator | Duplicate checklist UI + regex in two password screens |
| Shared `AppBrandMark` for splash/login header | Hardcoded Chinese / wrong brand on login |

**Composition:** Pages own layout + navigation; widgets own look + a11y + validation display.

---

## 3. Widget inventory (LoginRegister → code)

| Wireframe piece | Widget | File |
|-----------------|--------|------|
| Logo header (splash / login) | `AppBrandMark` | `app_brand_mark.dart` |
| Outlined inputs + error text | `AppTextField` | `app_text_field.dart` |
| Password + eye toggle | `AppTextField(obscureable: true)` | same |
| Full-width blue CTA | `AppButton` | `app_button.dart` |
| Outline / secondary CTA | `AppButton(variant: secondary)` | same |
| Forgot / Register text links | `AppTextLink` | `app_text_link.dart` |
| 6-digit OTP boxes | `AppOtpField` | `app_otp_field.dart` |
| Password rule checklist | `AppPasswordRules` | `app_password_rules.dart` |
| Success / Warning / Info modal | `AppStatusDialog` | `app_status_dialog.dart` |
| Full-screen wait / progress | `AppBusyView` | `app_busy_view.dart` |
| Auth scroll padding shell | `AppAuthShell` | `app_auth_shell.dart` |

Barrel: `lib/features/components/components.dart`

---

## 4. Screens that consume these widgets

| Screen | Widgets used | BRD note |
|--------|--------------|----------|
| Splash | `AppBrandMark` | Product name per `27` / `34` |
| Login | Brand · fields · link · primary button | Agent ID / mobile + password |
| Forgot phone | Field · button | OTP via SMS API |
| OTP | `AppOtpField` · button · resend link | 6-digit |
| Create / Update password | Fields · `AppPasswordRules` · button | Forgot requires remark/reason (page-level field) |
| Register (gated) | Fields · button · busy view | **CORE mobile must exist** — no open signup (`34`) |
| Feedback | `AppStatusDialog` | Success / warn / error |

---

## 5. API shape (stable contracts)

```dart
AppButton(label: 'Login', onPressed: ..., isLoading: false)
AppTextField(label: '...', controller: ..., errorText: ..., obscureable: true)
AppOtpField(length: 6, onCompleted: (code) {})
AppPasswordRules(password: value) // live checklist
AppStatusDialog.show(context, type: AppStatusType.success, title: '...', message: '...')
AppBrandMark(title: 'KBZ LIFE', subtitle: 'Agency Sales Digital Platform')
```

Password default rules (wireframe):

1. Length 8–16  
2. ≥1 uppercase  
3. ≥1 number  
4. ≥1 special character  

(Adjust via `PasswordRule` list if Core policy differs.)

---

## 6. Out of this pass

- Full auth bloc / API wiring (structure only)  
- Side drawer from wireframe (IA uses bottom tabs — `34`)  
- Home “My Balance” dashboard widgets (separate wireframe / FR-02)  
- Changing `AppColors` to Coolors hex set (optional follow-up; primary already sky blue)

---

## 7. Acceptance

- [x] Brainstorm documented  
- [x] Shared widgets under `lib/features/components/`  
- [x] Barrel export  
- [x] Login page refactored to compose widgets (KBZ branding)  
- [x] Forgot · OTP · Create/Update password · Register gate pages  
- [x] Routes wired (`/forgot-password` · `/otp` · `/create-password` · `/register`)  
- [ ] Widget golden / pump tests (later)  
- [ ] Real SMS OTP + CORE API (later)  

### Auth flow (mock)

```
Splash → Login
 Login → Forgot → OTP → Update password → Login
 Login → Register (CORE gate) → Busy → OTP → Create password → Login
```

Register mock: mobile starting with `09` and length ≥ 9 = CORE OK.
---

## 8. Related

`34` Wireframe×BRD · `07` unified login UX · FR-01 · `Wireframe/LoginRegister.png`
