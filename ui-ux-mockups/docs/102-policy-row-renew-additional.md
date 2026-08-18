# 102 — Customer policy row: Renew vs buy additional

**Surface:** Customer Details · Policies List (`detail.dart`) · Policy List (`81`)  
**Reference:** e-App doors (`81`) · FR-05 · FR-06 read-only issued policy  
**Today:** Eligible rows show a **12px “Renew” text** under the status pill. Easy to miss. FA language “ထပ်ဝယ်” is being mapped onto **Renew**, which is the **expiry** path.  
**Date:** 2026-08-18

**Ask:** Renew ကို ပြသပြီး **ထပ်ဝယ်** လို့ရအောင် UI/UX.

---

## 0. Two jobs (do not merge)

| Verb | Meaning | When it shows | Opens |
|------|---------|---------------|--------|
| **Renew** | Same policy, stay covered | Expired **or** inside Web window (30d mock) | e-App `intent: renewal` · product **locked** |
| **Buy additional** | ထပ်ဝယ် · another policy | Active (in-force) · not Pending | e-App `intent: repurchase` · product **not** locked |

**Start e-App** on the profile stays — quote picker for this client. Row actions are *this policy* shortcuts.

May Chan Myae mock: PA / Health expiry **Mar / Jun 2026** (prototype today **17-Aug-2026**) → those two *are* renewal-eligible even while the pill says Active. UL **Pending** → no Renew, no additional on that row.

---

## 1. Why the current control fails

- Text link under the pill looks like a caption, not a tap target  
- One word **Renew** for both “expiry” and “buy again”  
- Pending rows look dead (correct for Renew; wrong if FA expected ထပ်ဝယ် *on that row*)  
- Policy Details already has **Buy additional policy** as a text link — Customer list does not

---

## 2. Pick — chip on the row, not a tiny link

Trailing stack (right of the row):

```
[Active]
[ Renew ]              ← only if isRenewalEligible · filled or cyan outline
[ Buy additional ]     ← if status == Active (in-force). Hide on Pending
```

If **both** fit, stack two **equal-width** chips (same language as Quote saved 50/50). If only one, still a chip — never 12px text.

**Copy (list):** `Renew` · `Buy additional`  
**Copy (Policy Details sticky):** keep `Renew policy` · `Buy additional policy`

Expired row: **Renew** required · **Buy additional** still OK (new sale on the same client).

Pending: neither chip · row tap → Policy Details · **View tracker** if a draft exists (`81`).

---

## 3. Layout (so it doesn’t fight the pill)

- Status pill stays on top of the trailing column  
- Chips **below** the pill, min height 32, cyan outline (Buy additional) / filled cyan (Renew — urgency)  
- Row tap still opens Policy Details; chip tap does **not** open details  
- Same pattern on **Policy List** (FR-06), not only Customer Details  

Do **not** add a second FAB. Do **not** rename profile **Start e-App**.

---

## 4. What not to do

- Don’t show **Renew** on every Active row outside the window  
- Don’t use **Renew** as the ထပ်ဝယ် label  
- Don’t lock product on Buy additional  
- Don’t convert / edit the issued policy in place (`66`)

---

## 5. Test (when shipping)

- PA / Health (past expiry): **Renew** chip  
- In-force Active far from expiry: **Buy additional** only, no Renew  
- Pending: neither  
- Chip tap starts the matching intent
