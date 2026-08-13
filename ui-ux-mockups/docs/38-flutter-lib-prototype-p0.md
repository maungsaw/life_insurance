# Flutter `lib/` prototype — LoginRegister → Home (no HTML, no API)

**Scope this pass:** **Flutter only** (`lib/`) · **no** `ui-ux-mockups` HTML changes · **no** API  
**Wireframe:** `/Wireframe/LoginRegister.png`  
**Parent:** `37` prototype rules · `35` widgets · `36` Home  

---

## 1. Ask

Make the **running Flutter app** feel like a clickable prototype of LoginRegister.png: polish P0 gaps in `lib/` only.

---

## 2. Decisions

| Topic | Decision |
|-------|----------|
| Surface | Flutter `lib/` exclusively |
| HTML mockups | Skip this pass |
| API | None — `PrototypeConfig` delays + local rules |
| Wrong password | Password `0000` → warning modal + field error |
| OTP resend | 45s countdown before Resend enabled |
| Home services | Leads / Customers / Tasks / More → **switch bottom tab**; others → stub dialog |
| Tab bridge | `MainTabScope` InheritedWidget around shell |

---

## 3. Files touched

| File | Change |
|------|--------|
| `lib/core/prototype/prototype_config.dart` | Mock rules + delays |
| `lib/features/home/.../main_tab_scope.dart` | `goToTab(index)` |
| `lib/features/home/.../index.dart` | Wrap with scope; IndexedStack |
| `lib/features/auth/.../login.dart` | Wrong-password path |
| `lib/features/auth/.../otp_verify.dart` | Resend timer |
| `lib/features/dashboard/.../index.dart` | Tab switches |
| Register / forgot / password | Use shared delays from config |

---

## 4. Acceptance

- [x] Brainstorm (this doc)  
- [x] `PrototypeConfig` in lib  
- [x] Login wrong-password prototype path  
- [x] OTP 45s resend timer  
- [x] Home tiles switch real tabs where available  
- [x] No HTML edits this pass  

---

## 5. Related

`37` · `35` · `36` · `34` · LoginRegister.png  
