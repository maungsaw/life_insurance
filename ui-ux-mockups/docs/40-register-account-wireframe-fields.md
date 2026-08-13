# Register Account — wireframe field set (Flutter prototype)

**Surface:** Flutter `lib/` · no API  
**Wireframe:** Register Account screen (LoginRegister set / stakeholder PNG)  
**BRD:** FR-01 CORE-gated register · `34` · `38` prototype  
**Gap:** Current form had **3** fields; wireframe needs **5**

---

## 1. Ask

Match Register Account UI to wireframe:

| # | Field | Required | Example |
|---|--------|----------|---------|
| 1 | **Name** | Yes | May Chan Myae |
| 2 | **Identification** | Yes | 12/KaMaNa(N)127487 (NRC) |
| 3 | **Mobile Number** | Yes | 09 750337968 |
| 4 | **License No.** | No | LA-IO-09834 |
| 5 | **Email** | No | maychan@gmail.com |

CTA: **REGISTER** · Footer: Already have an account? **Login Now**

---

## 2. Decisions

| Topic | Decision |
|-------|----------|
| Missing fields | Add Identification + License No. |
| Validation (prototype) | Name · Identification · Mobile non-empty; CORE mock still on mobile `09…` |
| Identification format | Soft check only later; prototype = non-empty |
| Layout | Title “Register Account” · outlined fields via `AppTextField` · required `*` in label |
| Brand logo on register | Optional compact mark; wireframe shows title-first — keep small logo or drop for fidelity → **title-first** like PNG |
| After submit | Same prototype: busy → OTP → create password (no API) |

---

## 3. Acceptance

- [x] Brainstorm documented  
- [x] Five fields on `RegisterPage`  
- [x] Required vs optional validation  
- [x] REGISTER + Login Now footer  
- [ ] Real CORE / NRC format API (later)  

---

## 4. Related

`35` widgets · `38` prototype · FR-01 · LoginRegister.png  
