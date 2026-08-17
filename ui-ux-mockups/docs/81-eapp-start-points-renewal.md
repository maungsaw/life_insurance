# 81 — e-App start points · Renewal & repurchase

**Source:** Stakeholder start-point list · BRD §5.4 FR-04 · §5.5 FR-05 · §5.6 FR-06 · FR-08 renewal reminders · `02` `04` `24` `59` `66` `79`  
**Flutter today:** One e-App wizard · **Renew** on Policy List/Details (expiry window or Expired) · Client/Lead Start e-App (quote-gated) · Home banner → Policy Details · tracker Renewal pill.  
**Date:** 2026-08-17

**Ask:** e-App ကို အောက်ပါ start points တွေကနေ မြင်ရ၊ ဝင်ရ။ Policy ကုန်ခါနီး / expired မှာ **Renewal** ခလုတ်ပေါ်။ Renewal က **wizard အသစ်မဟုတ်** — ရှိပြီးသား e-App flow · **data ပဲ ပြောင်း**။

---

## 1. BRD jobs (source of truth)

| BRD | Meaning |
|-----|---------|
| **FR-04 Save Quote** | Quote links to **Lead or Client** |
| **FR-05 Start e-App** | New full e-App from **client profile or a saved quote** · pre-fill known data |
| **FR-05 Tracker** | Draft → Submitted → Correction → Approved → Rejected |
| **FR-03 Convert** | Lead → Client on **successful policy insurance** (Core submit / issue) |
| **FR-06** | Policy search + read-only details · **not** a second application form |
| **FR-08** | Premium due + **annual renewal** reminders → deep-link into work |
| **Out of scope** | Group/entity proposal · policy admin edit · payout |

Stakeholder list **extends** FR-05 with extra **doors** into the **same** wizard. It does not create six wizards.

---

## 2. One wizard, three intents

```
Any start point
    ↓
EappLaunch { intent, person, product?, quote?, sourcePolicy? }
    ↓
same e-App wizard (Scanner → … → Confirm)   ← already shipped (`59`)
    ↓
Tracker → Core submit
    ↓
if Lead: convert to Client (`79` / FR-03)
if Renewal: new/continued policy on the book
```

| Intent | When | Prefill source | CTA copy |
|--------|------|----------------|----------|
| **newSale** | First purchase / additional policy | Quote or client/lead contact | **Start e-App** |
| **renewal** | Same product, term ending / expired | **Existing policy** (parties · SI · mode · product) | **Renew** |
| **repurchase** | Extra policy while current one still in force (not the expiry window) | Client + optional last policy as *hint* | **Start e-App** / **Buy additional** |

**Locked:** Calculator still does **not** skip Save Quote on a cold start (`24`). Renewal **may** skip a blank calculator because the policy **is** the quote snapshot — see §6.

---

## 3. Start-point map (today → target)

| # | Start point | Flutter today | Target P0 |
|---|-------------|---------------|-----------|
| 1 | **Product catalog** (active product) | Detail → GET A QUOTE only | Keep GET A QUOTE. Optional secondary **Start e-App** only if this product already has a **saved quote** for a linked person; else prompt “Get a quote first” |
| 2 | **Premium calculator** | Save quote → Quote saved → Start e-App | Keep. After Save, **Start e-App** stays on Quote saved. Do not put Start e-App as equal CTA before save |
| 3 | **Client profile** | Phone / Email / Profile / Policies only | Sticky **Start e-App** · opens quote picker for this client, or “Get a quote” empty |
| 4 | **Lead profile** | Convert-by-condition stub (`79`) | **Get a quote** + **Start e-App** (needs quote). Convert **on Core submit / Approved**, not on the mock “Submit condition” as the long-term rule |
| 5 | **Saved quote** | Quote saved + Quotes list → wizard | Keep. Row trailing **Start e-App**. Hub can stay implicit (list *is* the hub) |
| 6a | **Policy list / details · Renewal** | No Renew · Home banner → Notifs | Dynamic **Renew** inside window or when **Expired** |
| 6b | **Policy / proposal · Repurchase** | None | **Start e-App** (additional) on Client / Policy details — always, not gated by expiry window |
| 6c | **Proposal / Tracker list** | Tracker resume draft | Draft → **Continue e-App**. Approved/issued → treat as policy. No second wizard |

**Visibility rule:** every door shows a verb (**Start e-App** / **Renew** / **Continue**) — never hide e-App behind Product-tab icons only.

---

## 4. Renewal window (configurable)

Stakeholder: button shows **2 weeks or 1 month before expiry**. Exact window from **Web Portal system settings**.

| Token | Prototype |
|-------|-----------|
| Setting | `EappRenewalSettings.window` = `14 days` **or** `30 days` (mock; later Core/Web) |
| Anchor date | Policy **`expiryDate`** (annual renewal), not next premium due |
| Show **Renew** | `today >= expiry − window` **OR** `status == Expired` (user: ကုန်ခါနီး **နှင့်** expired) |
| Hide **Renew** | Active/Pending and still **outside** the window |
| Pending (in-flight app) | No Renew — show **View tracker** instead |
| Multiple policies | Each row decides independently |

```
today = 2026-08-17 (prototype)
window = 30 days

Policy expiry 2026-03-01  → Expired     → Renew
Policy expiry 2026-06-04  → Expired     → Renew
Policy expiry 2026-09-01  → 15 days out → Renew (if window=30)
Policy expiry 2046-07-01  → far         → no Renew (Start e-App / additional only)
```

Home **Policy Renewal** banner and FR-08 notif **deep-link the same policy** → Policy Details with Renew focused. Do not open a different form.

Web Portal UI for the window is **web-only**. Mobile only **consumes** the number (mock constant P0).

---

## 5. Where the buttons sit

### Policy List row

```
(icon)  234875…     Personal Accident     [Active]
        May Chan Myae · expires 01-Mar-2026
                                      [ Renew ]   ← if in window / expired
```

Tap row still opens **Policy Details**. Renew is a **trailing action** (or a small text button under the pill) so it is visible in the list without opening the accordion.

Too many trailing widgets: if Renew is present, keep chevron; Renew is the colored text button. Don’t add a second FAB on the list.

### Policy Details

```
Accordions (read-only) …

sticky bottom (only when eligible):
  [ Renew policy ]
```

Copy: **Renew policy** — not Start e-App — so FA knows this is the expiry path.

If eligible for additional sale too, a text link **Buy additional policy** under the sticky button (repurchase · newSale).

### Client profile

```
[ Start e-App ]     always (new / additional)
Policies list: same Renew chip on eligible rows
```

### Lead profile

```
[ Get a quote ]  [ Start e-App ]
```

Start e-App disabled/empty → “Save a quote for this lead first.”  
Do **not** show Renew on a Lead (no policy).

### Catalog / Calculator / Saved quote

Unchanged verbs from `24`/`59`. Catalog does **not** show Renew (no policy context).

### Home renewal banner

Tap → **Policy Details** of that policy (or Policy List filtered Expired / due), not the notification inbox.

---

## 6. Renewal data rules (“data ပဲ ပြောင်း”)

Renewal **reuses the e-App wizard**. It does **not** invent Policy-edit (`34` §4.6 still: issued policy remains read-only).

On **Renew**:

1. Build a **draft quote** (or `EappDraft`) from the policy snapshot: product · SI · term · frequency · premium (indicative) · PH / insured / beneficiary.  
2. Open wizard at **Premium Information** *or* Policyholder with fields **pre-filled**.  
3. Chrome chip: **Renewal · POL-…** so the FA never thinks this is a blank sale.  
4. FA changes only what must change (term, SI, beneficiary %, health yes/no).  
5. Submit → **new** tracker row · `intent: renewal` · `sourcePolicyId`.  
6. After Core issue: book shows the new/continued policy; old one stays Expired / replaced per Core. Prototype: add a new Active policy on the client; keep the expired one.

| Field | Prefill | Editable in renewal e-App? |
|-------|---------|------------------------------|
| Product | Locked from source policy | No (change product = new sale, not Renew) |
| Client / PH identity | Yes | Fix-ups allowed (KYC) |
| Insured / Beneficiary | Yes | Yes |
| SI / term / frequency | Yes | Yes (recalc stub) |
| Health declaration | Empty / last answers stub | Yes — must confirm |
| Signatures | Empty | Yes (FR-05) |
| Quote link | Auto draft quote `QT-REN-…` | Hidden |

**Skip blank GET A QUOTE** on renewal: the policy *is* the completed calculation session. If premium must refresh, wizard Premium step has **Recalculate** stub — not a detour through catalog.

**Repurchase / additional:** do **not** lock product. Path = Client **Start e-App** → quote picker / GET A QUOTE with client pre-linked (`59` §5).

---

## 7. Lead conversion (align `79` with FR-03)

| Event | Result |
|-------|--------|
| Lead **Start e-App** | Draft stays a **Lead** |
| e-App **Submitted** | Still Lead · stage Applied |
| **Core policy submission / Approved** | Convert Lead → Client · policy on Clients tab |

`79` P0 “Submit condition · Move to Clients” remains a **prototype shortcut**. This pass: Lead e-App submit should set stage **Applied**; convert banner when tracker hits Approved (P0 can still mock-approve from tracker).

A person is never in both lists.

---

## 8. App bar / tracker chrome

Renewal drafts in App tracker:

| Chip / subtitle | Example |
|-----------------|---------|
| Type | `Renewal` pill (cyan outline) vs default sale |
| Title | `Personal Accident · May Chan Myae` |
| Sub | `Renews POL-2348… · Draft` |

Filter chips stay status-based (`59` H). Optional P1 filter **Renewals**.

---

## 9. Empty / blocked states

| Situation | UI |
|-----------|-----|
| Start e-App, no quotes for this person | “No saved quote yet” · **Get a quote** |
| Product Off (`23`) | Cannot start / renew that code — message “Product unavailable” |
| Guest | All start points gated (`74`) |
| Draft already open for that policy renewal | **Continue e-App** instead of a second Renew |
| Window not open | Hide Renew; additional Start e-App still OK on Client |

---

## 10. What not to do

- Don’t build a second “Renewal form” besides the e-App wizard  
- Don’t edit the issued policy in place (`34` §4.6)  
- Don’t show Renew on Leads, Catalog, or Commission  
- Don’t use next **premium due** as the Renew trigger (that’s FR-08 servicing, different CTA: pay/remind)  
- Don’t hard-code 14 vs 30 without a single mock setting object  
- Don’t auto-start the wizard from the Home banner (land on Policy Details so the FA can read first)  
- Don’t treat Group Life / entity repurchase (OOS)

---

## 11. Flutter map (when implementing)

| Piece | Work |
|-------|------|
| `EappLaunchIntent` | `newSale` · `renewal` · `repurchase` on `EappDraft` |
| `EappRenewalSettings.windowDays` | `30` default (toggle 14 in prototype comment / debug) |
| `PolicyMock.isRenewalEligible` | expiry vs `TaskSession.today` / `CommissionMockData.now` — use **one** prototype today (`2026-08-17`) |
| Policy List row + Details sticky | **Renew** |
| `CustomerDetailPage` | **Start e-App** |
| `LeadDetailPage` | **Get a quote** · **Start e-App** |
| `ProductSession.startEappFromPolicy` | Clone parties + product into draft quote + wizard |
| Home `AppSoftBanner` | Push Policy Details / list, not inbox |
| Tracker | Renewal pill · Continue |
| Convert | Approved → `CustomerHubSession.convertLead` |

---

## 12. Phasing

| Phase | Scope |
|-------|-------|
| **P0** | Intent + renewal eligibility helper · Renew on Policy List/Details · Client/Lead Start e-App (quote-gated) · Home banner → policy · clone-prefill wizard · tracker pill · window mock 30 days |
| **P1** | 14/30 setting from a Profile/debug stub or future Web API · Recalculate on renewal Premium step · Continue-if-draft · Catalog secondary Start e-App when quote exists |
| **Out** | Web Portal settings UI (web) · Core live window · in-place policy mutate · separate renewal PDF pack |

---

## 13. Acceptance (brainstorm)

- [x] Six start points mapped vs Flutter today  
- [x] One wizard · three intents  
- [x] Renewal window + Expired rule  
- [x] Button placement (list · details · profiles · Home)  
- [x] Prefill / data-change rules (not a new form)  
- [x] Lead convert = Core submit  
- [x] Flutter map + phasing  
- [x] Flutter start-point + Renew shipped  
- [x] Inventory updated  

---

## 14. Related

BRD FR-04/05/06/08 · `02` · `04` · `24` · `26` · `59` · `66` · `79` · Policy.png · live Policy / Product screens
