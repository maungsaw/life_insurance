# 80 — Commission hub · History + Report clarity

**Source:** Live Commission history screenshot (2026-08-17) · `Wireframe/Comission.png` · Commission Report PNG · BRD §3.2 / §5.2.1 / §7  
**Flutter today:** Two disconnected screens — `CommissionHistoryPage` (hero + generic ledger + FAB) and a thin `CommissionReportPage` (one untitled bar chart)  
**Related:** `34` §4.4 · `50` Report · `61` history · `46` Home card · FR-02 Commission display  
**Date:** 2026-08-17

**Ask:** Commission ထဲမှာ UI/UX ကို ပြန်အဆင်ပြေအောင်။ History နဲ့ Report နှစ်ခုလုံး မြင်ရ၊ နားလည်ရ၊ BRD နဲ့ မကွဲအောင်။

---

## 1. BRD source of truth

| BRD | Meaning for this screen |
|-----|-------------------------|
| **§5.2.1 Commission** | Phase 1 **display product commission**. UL may later show extra agent commission |
| **§3.2 Out of scope** | **Direct commission payment processing** — no withdraw / cash-out / transfer |
| **§7 Commission Tracking** | Agents track what they earned — ledger + report, not a wallet |
| **Amount format** | 2 decimals + comma separator · dates `DD-MMM-YYYY` |
| **FR-02** | Dashboard values come from Core APIs later — prototype = mock display |

**Hard rule (unchanged from `61`):** no button, sheet, or empty-state CTA that implies money leaves the app.

---

## 2. What the two screenshots show vs Flutter today

### History (live app)

| Layer | Job | Issue |
|-------|-----|--------|
| AppBar **Commission** | Correct BRD title | Keep |
| Blue hero card | Total + MoM + eye | Keep · same as Home |
| “Product commission · display only” | Trust copy | Keep, but quieter |
| History rows | All titled **Commission** · same coin icon · date only | Agent cannot tell *which product / client / policy* earned it |
| Filter | Period list tiles | Works, but not the chip family used on Customer / My work |
| FAB bar-chart | Hidden path to Report | Easy to miss · Report feels like a different product |

### Report (PNG)

| Layer | Job | Flutter today |
|-------|-----|----------------|
| Hero “Commission Report” + month | Context + period | Missing — title is a small card header |
| Bars with **count inside** + **MMK above** | Dual signal (volume + money) | Bars are unit-less 24 / 8 / 13 / 33 |
| Category icons | Protection · Saving · Health · Travel | Text labels only |
| This Month dropdown | Period on the chart | Missing |
| Top Performing Category | “Travel won this month” | Missing |
| Summary 4-up | Total · vs last month · categories · policies | Missing |

**Core issue:** History is a **ledger without identity**. Report is a **chart without a dashboard**. They don’t share period, totals, or navigation language.

---

## 3. Do not put Leads | Clients on Commission

FR-03 split stays on the **Customer** hub (`79`).

| Object | Commission? |
|--------|-------------|
| **Lead** | No purchase yet → **no earned commission** |
| **Client / policyholder** | Product commission after issuance (and Pending only if Core already created a credit) |

A “potential commission from leads” tab would invent pipeline $ that BRD does not give Phase 1. Quotes and e-Apps stay on Lead/Client profiles.

If product later wants pipeline value, that is a **P2 quote-pipeline report**, not this screen.

---

## 4. Decision — one Commission hub, two jobs

Two jobs, one pushed route (Home card / Services / Profile still land here):

```
←  Commission

[ History ] [ Report ]

── History ────────────────────────────
Hero total card (shared)
History list (identity rows)     [Filter]

── Report ─────────────────────────────
Period chip (This month / May 2026)
Category bar chart (count + MMK)
Top performing category
Summary 4-up
```

| Option | Verdict |
|--------|---------|
| **A · Hub tabs History \| Report** | **P0 pick.** Same pattern as Customer Leads\|Clients and My work Day\|Week\|Month. Report is no longer a secret FAB |
| B · Keep two routes + FAB | Status quo. Report stays undiscoverable |
| C · Chart stacked above the list | One long scroll; Report PNG cannot breathe; History buried |
| D · Leads \| Clients tabs | **Reject** — §3 |

**FAB:** remove from History once Report is a tab. App bar trailing **optional** filter stays on History only.

Profile → Settings → Report still opens the **Report tab** of the same hub (don’t maintain a second chart page).

---

## 5. Shared chrome

```
← Commission                              [bell? no — this is not inbox]
```

| Piece | Spec |
|-------|------|
| Title | **Commission** (never Wallet / My Balance as app bar — `61`) |
| Segmented control | Filled primary selected · labels **History** · **Report** |
| Period | **One period** drives both tabs when possible (This month default on Report; History may be All until user filters) |
| Display-only | One quiet line under the hero on History; Report subtitle already says “performance by product category” |
| Amounts | Shared `CommissionMockData` · 2 decimals · `MMK` |
| Eye | History hero only (Report shows public dashboard numbers) |

Switching tabs **keeps** the selected period if both understand it.

---

## 6. History tab — ledger with identity

Keep the PNG structure (hero + History + filter). Upgrade the **row**, not the chrome.

```
(● UL)  Universal Life · May Chan Myae          +23,000.00
        18-Sep-2024 10:11 AM · POL-2024-0918
```

| Slot | Rule |
|------|------|
| Leading | Soft category icon (Protection shield · Saving globe · Health heart · Travel bag) — not a generic $ on every row |
| Title | **Product name** (mock already has it) · never repeat the word “Commission” as the only title |
| Subtitle | `DD-MMM-YYYY hh:mm AM/PM` · client name if known · policy ref |
| Trailing | `+23,000.00` primary · 2 decimals |
| Tap | Bottom sheet: product · client · policy · amount · date · “Display only · paid via company process outside this app.” Deep-link **View policy** if `policyRef` exists (`66`) |
| Empty | “No commission in this period” + Reset filters — no Withdraw |
| Filter | Chip sheet: Period (All · This month · Last month · Last 90 days) · Product line (All · Protection · Saving · Health · Travel) |

Duplicate timestamps in today’s mock (two rows both 18-Sep 10:11) should be **distinct** so the list doesn’t look broken.

Group by day headers (**P1**): `18 Sep 2024` then rows — optional; P0 can stay a flat list if rows carry enough identity.

---

## 7. Report tab — match the PNG dashboard

Do **not** paste the stock-photo banner as a full-bleed magazine header (it fights Home/Profile language and eats fold). Translate the PNG **jobs** into app chrome:

```
Commission Report
Overview of your commission by product category.
[ This month ▾ ]

Commission Overview
  MMK 24.8m     8.75m     13.65m     32.25m
     ██           ▆         ██         ███
     24           8         13         32
  Protection   Saving    Health     Travel
     (icon)     (icon)    (icon)     (icon)

┌ Top performing ─────────────────────┐
│ Travel Insurance                    │
│ MMK 32,250,000 · 32 commissions     │
│ Highest this month                  │
└─────────────────────────────────────┘

Summary
[ 77  Total ] [ ↗12% vs last ] [ 4 cats ] [ 36 policies ]
```

| Element | Spec |
|---------|------|
| Period | This month · Last month · Last 90 days · pick month (P1 calendar). Default **This month** |
| Bars | Four product lines. **Y-axis = MMK** (or normalized). **Count** as a caption on/under the bar. Color per line (blue / amber / rose / violet) — text labels still required (a11y) |
| Icons | Same set as History row leading |
| Top performing | Highest MMK category this period · amount · count · no trophy animation |
| Summary | Total commissions (count + MMK) · vs last period % (green up / red down) · category count · **policy count** (issued policies that generated the credits — not lead count) |
| Empty period | “No commission this month” |
| Tap a bar | Filters History to that product line and switches tab (**P1**). P0 = display only |

**UL extra commission** (BRD): if a mock row is UL override, show a small “UL extra” caption on the bar or in the row sheet — P1.

---

## 8. Numbers must agree

Today History total is **726,080.00 MMK** and Report bars sum toward **~77m** in the PNG. That drift destroys trust.

| Rule | Prototype |
|------|-----------|
| One mock source | `CommissionMockData.entries` is the ledger |
| Report bars | **Sum of entries** in the selected period, grouped by product line |
| Hero total | Sum of **All** (or selected History period) — same formatter |
| PNG 77m / 32 Travel | Treat as **visual reference** for layout density, not a second dataset. Either rescale mock entries to look like the PNG **or** keep 726k and draw honest short bars. **Prefer honest 726k** so Home card, History, and Report never disagree |

If stakeholders insist on PNG-scale millions, update **Home + History + Report together**.

---

## 9. Navigation map

```
Home Commission card / Services → Commission hub (last tab or History)
Profile Total Commission chip  → Commission hub · History
Profile Settings → Report      → Commission hub · Report
History row → policy detail    → PolicyDetailsPage (optional P0 if ref exists)
```

Do not add a 5th bottom tab. Do not keep `CommissionReportPage` as a separate visual once the hub ships — route it into the hub Report tab.

---

## 10. What not to do

- Don’t add Withdraw / Cash out / KBZPay / “Available balance”  
- Don’t title the screen Wallet  
- Don’t mix Lead pipeline $ into Report  
- Don’t show a second total that disagrees with the Home card  
- Don’t use the PNG desk photo as a required asset (optional muted illustration, not P0)  
- Don’t auto-play chart animations that delay first paint  
- Don’t put Report behind only a FAB  

---

## 11. Flutter map (when implementing)

| Piece | Work |
|-------|------|
| `CommissionHistoryPage` | Become hub: segmented **History \| Report** · drop FAB |
| History list | Title = product · subtitle = date · client · ref · category icon |
| Filter sheet | Period + product line chips (Customer-family) |
| `CommissionReportPage` | Either fold into hub or become the Report body widget |
| `CommissionReportMock` | Derive from `CommissionMockData.entries` (count + MMK per line) |
| `CommissionEntry` | Add `category` + optional `clientName` |
| Distinct timestamps | Fix duplicate 18-Sep 10:11 twins |
| Profile Report route | `extra` or query to open Report tab |
| Inventory | Tick shipped when done |

---

## 12. Phasing

| Phase | Scope |
|-------|-------|
| **P0** | Hub tabs · richer History rows · Report dashboard (bars with MMK + count, top category, summary) · shared mock totals · drop FAB · display-only copy · period on Report |
| **P1** | Bar tap → History filter · month picker · day-grouped History · UL extra caption · View policy from row |
| **Out** | Payout · Lead potential commission · PDF export · Core live API |

---

## 13. Acceptance (brainstorm)

- [x] Live History clutter / generic rows diagnosed  
- [x] Report PNG jobs mapped (not a naked chart)  
- [x] Leads\|Clients on Commission rejected (BRD)  
- [x] History \| Report hub chosen  
- [x] Totals must agree across Home / History / Report  
- [x] Flutter map + phasing  
- [x] Flutter Commission hub shipped (P0)  
- [x] Inventory updated  

---

## 15. Shipped (P0)

| File | What landed |
|------|-------------|
| `commission_mock_data.dart` | One ledger · `CommissionLine` · client/policy identity · Report stats derived from entries · total **726,080.00 MMK** agrees with Home |
| `commission_history_page.dart` | Hub tabs **History \| Report** · richer rows · chip filter (period + product line) · FAB removed |
| `commission_report_body.dart` | Category bars (count + MMK) · top performing · summary 4-up · period menu |
| `commission_report_page.dart` | Folded into hub · Settings → Report opens Report tab |
| Profile/Home routes | Unchanged paths; `profileReport` → `CommissionHistoryPage(initialReport: true)` |

---

## 16. Related

BRD §5.2.1 · §3.2 · `34` §4.4 · `50` · `61` · `46` · `Comission.png` · Commission Report PNG · live screenshot 2026-08-17
