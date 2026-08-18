# 50 — Profile tab (Agent Profile.png)

**Source:** `Wireframe/Agent Profile.png` (hub · settings · details · password · FAQ · notif prefs · language · report)  
**BRD:** FR-11 Profile · FR-01 password rules · ENG/MM  
**Flutter today:** Settings hub + sub-screens shipped (docs/50)  
**Related:** `28` logout · `44` Profile tab · `49` inbox bell · `42` password rules  
**Date:** 2026-08-13

**Ask:** Profile tab should match the wireframe family — identity, quote shortcut, settings rows, and pushed sub-screens — without a hamburger drawer and without mixing inbox vs notification *preferences*.

---

## 1. Two hubs on the PNG — pick one for the tab

| Variant | Contents |
|---------|----------|
| **A · Portfolio** | Avatar · ID · Create New Quote · Total Premium / Commission · tabs All / Proposals / Policies / Commission / Reports · status list |
| **B · Settings** | Same identity + Create New Quote · **Setting** list · Logout |

**Decision:** Profile **tab = B (Settings hub)**.  
FR-11 is account/settings. Portfolio (A) is a **work ledger** — don’t steal the tab.

**Where A goes (prototype):**
- **Reports** row on Settings → Commission Report screen (last PNG)  
- Proposals / Policies lists → later under Product / Policy (`24`), not as Profile home  
- Total Premium / Commission **summary chips** may sit **on Settings hub** under the quote button (PNG A metrics) — display only, no payout (`34`)

---

## 2. Settings hub layout (tab)

```
AppBar:  (no hamburger)  Profile              [bell + badge]
Identity card:  avatar · May Chan Myae · YGN/IA/(O)/2021/0009
AppButton:  shield+  Create New Quote
Optional: Total Premium | Total Commission  (read-only mock)
Section: Setting
  Edit Profile >
  Change Password >
  Security · Biometric login switch (`70`)
  FAQ >
  Language >
  Notification >
Logout  (filled light-blue / primary outline — PNG)
pill clearance
```

| PNG | App |
|-----|-----|
| Hamburger | **Drop** — pill nav is primary (`34` `44`) |
| AppBar bell | Same `AppRoute.notifications` as Home (`49`) |
| Create New Quote | `goToTab(Product)` **or** FAB sheet — same job as center shield+ |
| Logout | Confirm then `context.go(Login)` (`28`) |

---

## 3. Sub-screens (push, no pill)

| Screen | Fields / UI | Save / back |
|--------|-------------|-------------|
| **Profile Details** | Avatar + camera stub · Name* · Mobile* · DOB* + picker · Identification* · Email · Gender Male/Female · **UPDATE** | Success stub → pop |
| **Change Password** | Current* · New* · Confirm* · eye · **SAVE** | Reuse `AppPasswordRules` + `AppStatusDialog`. Not Forgot OTP. Prototype: any current ≠ empty; `0000` can fail like login |
| **FAQ** | Cards → answer page or expand. Copy **fix typos**: claim · commission. No withdraw/payout FAQ that implies cash-out | Back |
| **Language** | English (UK) · Myanmar · check on current. Wire `AppearanceBloc` / existing `LanguagePage` restyle | Instant apply · pop optional |
| **Notification (prefs)** | Toggles — **not** inbox | Local bools / cache later |
| **Report** | Commission Report dashboard (Protection · Saving · Health · Travel) — layout + jobs in `80`; Settings row opens the **Report** tab of the Commission hub | Back |

### Notification prefs (PNG has duplicate “Push Notification”)

| Row | Default | Meaning |
|-----|---------|---------|
| Push Notification | On | OS / in-app push preference (stub) |
| Message Notification | Off | In-app message / SMS-style (stub) |
| Email Notification | On | Email alerts (maps third duplicate) |

Inbox stays Home/Profile **bell** → `/notifications`. Prefs never open the list.

---

## 4. Profile Details rules

| Field | Required | Prototype |
|-------|----------|-----------|
| Name | Yes | Non-empty |
| Mobile | Yes | Same `09…` feel as register |
| DOB | Yes | `showDatePicker` · display `dd.MM.yyyy` |
| Identification | Yes | Non-empty (NRC format later) |
| Email | No | Soft email check if filled |
| Gender | Choice | Female selected in PNG mock |
| Photo | Camera badge | Stub dialog — no gallery API required |

Pre-fill mock: May Chan Myae · 09 8800 8834 · 04-Jun-1999 · 12/KaMaNa(N)127645 · may@gmail.com · Female.  (`94`) 
ID on hub `YGN/IA/(O)/2021/0009` is **agent code** — not the same as NRC; show on hub only.

---

## 5. Change Password vs Forgot / Update

| Flow | When | Fields |
|------|------|--------|
| Forgot → OTP → Update Password | Logged **out** | New + Confirm |
| **Change Password** | Logged **in** | Current + New + Confirm |

Same 5 rules catalog. After SAVE: success dialog · stay in Profile (don’t force Login unless we want session refresh — **P0 stay**; P1 “log in again” if product asks).

---

## 6. Logout (`28`)

1. Tap Logout  
2. Sheet: **Log out?** · Cancel · Log out  
3. `context.go(AppRoute.login)` — clear stack  
4. No Core delete · no remote wipe  

---

## 7. Flutter map

| Piece | Action |
|-------|--------|
| `ProfilePage` | Rebuild as Settings hub (keep widgets file; comment-out old cards) |
| Routes | `profile/details` · `profile/password` · `profile/faq` · `profile/faq/:id` · reuse `/language` · `profile/notification-prefs` · `profile/report` |
| DRY | `AppTextField` · `AppButton` · `AppPasswordRules` · `AppStatusDialog` |
| Language | Restyle existing `LanguagePage` flags + check; don’t duplicate bloc |
| Report | Small `fl_chart` bar (already in pubspec) |
| Bottom padding | Same ~72px as Home for floating pill |

---

## 8. What not to do

- Don’t add a drawer for hamburger  
- Don’t make Profile tab the proposal/policy ledger (variant A home)  
- Don’t open inbox from Settings → Notification (prefs only)  
- Don’t imply commission **withdraw** in FAQ  
- Don’t duplicate Create Password screen — new page with **current** password  
- Don’t block on photo picker / API  

---

## 9. Build order

1. Settings hub chrome (identity · quote · rows · logout confirm).  
2. Profile Details form.  
3. Change Password + rules.  
4. FAQ list + answer.  
5. Language restyle (existing bloc).  
6. Notification prefs toggles.  
7. Report chart mock.  
8. Bell → existing inbox.  

---

## 10. Acceptance

- [x] Brainstorm documented (this file)  
- [x] Profile tab = settings hub, not portfolio list  
- [x] Sub-screens match PNG jobs  
- [x] Bell = inbox (`49`) · Notification row = prefs  
- [x] Logout confirm → Login  
- [x] Quote CTA → Product / FAB job  
- [x] Pill nav unchanged; no hamburger  

---

## 11. Related

`Agent Profile.png` · `28` · `34` FR-11 · `42` rules · `44` tab · `49` inbox  
