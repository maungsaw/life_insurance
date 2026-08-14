# 61 — Commission history (My Balance wireframe)

**Source:** `Wireframe/Comission.png` · Home Commission crop (balance card + History + filter + wallet FAB)  
**BRD:** Phase 1 **display product commission** only · **direct commission payment / payout out of scope**  
**Flutter today:** Commission history page shipped — Home card / service / Profile chip → history · FAB → Report (`61`).  
**Related:** `34` §4.4 · `46` Home card · `50` Report · `36`  
**Date:** 2026-08-14

**Ask:** Wireframe shows a full **My Balance** screen (hero card + History list). Brainstorm UI/UX so it matches the PNG, stays BRD-honest (no withdraw), and connects cleanly to Home / Profile / Report without inventing a payment wallet.

---

## 1. What the PNG is

| Zone | Content |
|------|---------|
| App bar | ← Back · title **My Balance** |
| Hero card | Wallet icon · **My Balance** · green **↗ 15% up compared with last month** · big **726,000 MMK** · **eye** hide/show |
| History | Title **History** · **filter** (sliders) · rows: coin icon · **Commission** · `18.09.2024 10:11 AM` · **+23,000** (blue) |
| FAB | Bottom-right circle · wallet icon |

One job: **see how much commission I have, and what credits built it.** Not cash out. Not pay.

---

## 2. BRD vs wireframe (locked decisions)

| Wireframe | BRD | Decision |
|-----------|-----|----------|
| Title **My Balance** | Display **product commission** | **Screen title = Commission** (or **Commission history**). Card eyebrow may say **My Balance** *only as layout cue* — prefer **Commission** everywhere so agents don’t think it’s a bank wallet. |
| Wallet icon / FAB | No payout processing | Keep wallet **as illustration** · never label Withdraw / Cash out / Transfer / Top up |
| History all “+Commission” | Commission tracking (display) | Rows = **earned / credited** lines from Core (mock). Optional later: adjustment / clawback as **−** with red — P1 if product supplies types |
| FAB wallet | Unclear | **Do not** open payout. See §6 |
| Amount `726,000` vs Home `726,080.00` | API-supplied later | Prototype: **one mock source**. Prefer Home’s `726,080.00 MMK` (2 decimals + commas) on this screen too |

**Hard rule:** No button, sheet, or empty-state CTA that implies money leaves the app.

---

## 3. Where it lives (IA)

```
Home AppCommissionCard (tap / chevron)
  └─ Commission history          ← this screen (P0)

Home Our Services → Commission
  └─ same screen

Profile → Total Commission chip (optional)
  └─ same screen

Profile → Setting → Report
  └─ Commission Report (bar by line)  ← keep separate (`50`)
```

| Surface | Job |
|---------|-----|
| **Home card** | Glance total + MoM delta · eye · open history |
| **Commission history** (this PNG) | Total + **line-item credits** + filter |
| **Report** | Category breakdown chart (Protection / Saving / …) — analytics, not ledger |

Don’t merge Report into History. Don’t put History inside Profile Settings as the only entry.

---

## 4. Target layout (P0)

```
←  Commission
┌─────────────────────────────┐
│ (wallet) Commission         │
│ ↗ 15% up vs last month      │
│ 726,080.00 MMK         👁   │
└─────────────────────────────┘

History                    [filter]

(●) Commission          +23,000.00
    18-Sep-2024 10:11 AM
───────────────────────────────
…
```

### 4.1 App bar

- Back · title **Commission** (match BRD; PNG “My Balance” = visual reference only)  
- Optional trailing: **Report** icon → `CommissionReportPage` (shortcut) — P1

### 4.2 Hero card

Reuse / extract from `AppCommissionCard` so Home and this screen **don’t drift**:

| Element | Spec |
|---------|------|
| Gradient | Same Coolors blue as Home (`#006494` → `#00A6FB`) |
| Title | **Commission** |
| Delta | Green MoM line (mock). Hide if API sends null later |
| Amount | 2 decimals + `MMK` · eye toggles `••••••` |
| Chevron | **Omit on this screen** (already here). Keep on Home only |

Tap on amount / card on **this** screen: no navigation (or soft scroll to History).

### 4.3 History list

| Slot | Spec |
|------|------|
| Leading | Soft primary circle · coins / `Icons.monetization_on_outlined` |
| Title | **Commission** (or product short name if mock has it — P1) |
| Subtitle | Date-time · prefer app format **`DD-MMM-YYYY`** + time (wireframe `18.09.2024` → `18-Sep-2024 10:11 AM`) |
| Trailing | **+23,000.00** primary blue · always show sign for credit |
| Divider | Hairline between rows |
| Empty | “No commission history yet” · no Withdraw CTA |
| Offline | Honesty banner if stale (later); prototype = mock always “fresh” |

**Row tap (P0):** optional bottom sheet — amount · date · product · policy/ref stub · “Display only · paid via company process outside this app.”  
Avoid a fake “transaction detail” that looks like a bank receipt with status Paid/Pending unless Core defines statuses.

### 4.4 Filter sheet (History filter icon)

Same chrome family as Customer filter (`51`):

| Section | Chips / fields |
|---------|----------------|
| **Period** | This month · Last month · Last 90 days · Custom (date range) |
| **Type** | All · Credit · Adjustment *(hide Adjustment until mock has − rows)* |
| **Product line** | All · Protection · Saving · Travel · Health *(optional P1)* |

Apply / Reset. Default: **This month** or **All** — pick **All** for prototype so the list isn’t empty.

### 4.5 FAB (wallet)

Wireframe FAB is ambiguous. Options:

| Option | Behavior | Verdict |
|--------|----------|---------|
| A · Scroll to top / focus card | Weak | ❌ |
| B · Open **Report** chart | Useful · no payout | ✅ **P0 pick** |
| C · Share / export PDF | Nice later | P2 |
| D · Withdraw | Violates BRD | ❌ never |

**P0:** FAB → `CommissionReportPage`. Tooltip / semantics: **Report**. Icon may stay wallet for PNG parity **or** switch to `Icons.bar_chart_rounded` for honesty — prefer **bar chart** if stakeholders accept; else wallet icon + Report destination.

If shell already has center shield FAB, this screen’s FAB is **page-local** (`Scaffold.floatingActionButton`) — fine; pill nav is under Home shell, this is a pushed route (no pill).

---

## 5. Copy & trust

| Do | Don’t |
|----|-------|
| “Product commission · display only” once (subtitle under History or first-open tip) | “Withdraw”, “Cash out”, “Transfer to KBZPay” |
| “Paid outside the app per company schedule” in FAQ / row sheet | Green “Available to withdraw” badge |
| MoM % from API / mock | Invent “interest” or “wallet growth” metaphors beyond MoM |

FAQ (`50`) already says display-only — keep aligned.

---

## 6. Data model (prototype)

```
CommissionLedgerMock
  totalLabel: '726,080.00 MMK'
  deltaLabel: '↗ 15% up compared with last month'
  entries: [
    { id, title: 'Commission', at: DateTime, amount: 23000, productName?, policyRef? }
  ]
```

Single source shared by Home card amount + this screen (avoid 726,000 vs 726,080 drift).

Session hide-eye can be **per screen** or shared via a tiny `CommissionUiPrefs.hidden` — P0 per-screen is enough.

---

## 7. Flutter map (when building)

| Piece | Change |
|-------|--------|
| New page | `lib/features/…/commission_history_page.dart` (or under `profile` / `dashboard`) |
| Route | `AppRoute.commissionHistory` |
| Entries | Home card `onDetails` · Home service Commission · Profile chip optional |
| Filter | `showCommissionFilterSheet` |
| FAB | → existing `CommissionReportPage` |
| Stub dialogs | Remove info dialogs for Commission once page ships |

Comment-out stubs; don’t delete until wired.

---

## 8. What not to do

- Don’t build payout / withdraw / top-up / KBZPay transfer  
- Don’t title the app bar **Wallet**  
- Don’t replace Profile **Report** with this list (different job)  
- Don’t put this as a 5th bottom tab  
- Don’t use fake “pending settlement” countdown without Core fields  
- Don’t show entity / group commission special cases beyond Core product lines  

---

## 9. Build order

| Pass | Ship |
|------|------|
| **P0** | History page · hero card · list · eye · wire Home card + service tile · FAB → Report |
| **P1** | Filter sheet · row detail sheet · product name on rows · Report shortcut in app bar · shared hide pref |
| **P2** | Export / share · real Core ledger · adjustment (−) types |

---

## 10. Acceptance

- [x] Brainstorm documented (this file)  
- [x] Commission history screen matches PNG layout (card + History + filter)  
- [x] Title / copy = display commission · **no** withdraw  
- [x] Home Commission card / service open this screen (not stub dialog)  
- [x] FAB → Report (or documented equivalent) · never payout  
- [x] Amounts use shared mock · `DD-MMM-YYYY` dates  
- [x] Inventory updated  

---

## 11. Related

`Comission.png` · `34` · `46` · `50` · `AppCommissionCard` · `CommissionReportPage` · HomeMockData  
