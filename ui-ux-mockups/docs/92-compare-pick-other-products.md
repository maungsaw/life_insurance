# 92 — Compare Details · pick other catalog products

**Surface:** Flutter Product · Compare Details (`compare.dart`)  
**Reference:** Side-by-side sales aid (`59` §I) · P1 polish (`60`) · guest compare (`75`) · dark zebra (`82`) · Product On/Off (`23`)  
**Today:** Opens with the current SKU on the left and a **hard-coded first peer** on the right. Headers are static. Agent cannot swap in PA / Health / Travel without leaving the screen. Pin only toggles which column looks “primary”; both **Use** CTAs still go to Get A Quote.  
**Date:** 2026-08-18

**Ask:** Product တွေ **ရွေးကြည့်** လို့ ရအောင် — ဒီနှစ်ခုပဲ မဟုတ်ဘဲ catalog က တခြား On products ကို Compare table ထဲ ပြောင်းထည့်နိုင်အောင်. လိုအပ်တာအားလုံး ပြည့်အောင် brainstorm ပြီး ship.

**Rule:** Compare is a **display aid**, not a 2-product cart and not two e-Apps. CTA remains **Use [product] → Get A Quote** for **one** code (`59`). Web HQ has no compare/quote wizard (`86`). Group / entity products stay OOS (`65`).

---

## 0. What is actually stuck

| Symptom | Cause |
|---------|--------|
| Always STE vs UL (or current vs first other) | `openCompareFor` picks `products.firstWhere(id !=)` — no picker |
| Cannot try Credit Life / Health / Travel in the grid | Header names are not tappable |
| Same SKU can appear twice if catalog shrinks | `orElse: () => products.first` when no peer |
| Pin vs Use mismatch vs screenshot | Pin is visual only; both Use buttons use the same weight |

Screenshot (field): Feature table · Pin / Pinned · **Use Short** / **Use Universal**. That layout stays. What is missing is **Change** on each product column.

---

## 1. Jobs (keep separate)

| Job | Where | Not |
|-----|--------|-----|
| **Pick a pair to compare** | Compare Details · per-column Change | Catalog multi-select cart |
| **Pin which SKU is the conversation** | Pin / Pinned under the name | Does not start two quotes |
| **Sell one** | Use → Get A Quote | Dual BUY · two e-App drafts |

Agent flow: Detail or Quote → Compare → Change left/right until the pair is useful → Pin the one they will sell → **Use** that SKU.

---

## 2. Options

| Option | Idea | Pros | Cons | Verdict |
|--------|------|------|------|---------|
| **1 · Leave compare, add 3rd from catalog** | Keep static pair | Zero work | Screenshot complaint stands | ❌ |
| **2 · Full catalog multi-select then Compare** | Checkboxes on Product tab | Familiar “compare N” | `59` is **two** On products · table width on phone | ❌ P0 (P2 if tablet) |
| **3 · Per-column picker sheet** | Tap name / Change → On catalog → replace that slot | Matches existing 3-column table · one extra tap | Must block duplicate pair | ✅ **P0** |
| **4 · Swap-only between two** | Swap STE ↔ UL | Fast | Cannot see PA vs UL | ❌ alone |

**Pick: Option 3.** Two columns forever on phone. Any **On** catalog SKU in either slot. If the picked SKU is already in the other column → **swap**, keep Pin on the same SKU.

---

## 3. P0 behaviour (must)

### 3.1 Who can appear

- Source: in-memory `ProductMockData.products` (all mock SKUs are On)  
- **Off** / unpublished / Group-entity: never in the sheet (`59` `23` `65`)  
- Guest: same On catalog as logged-in (`75`) — no extra SKUs  
- Need **two** distinct On products to open Compare; otherwise snackbar, stay on Detail

### 3.2 Default pair

- Left = product you came from (Detail / Quote)  
- Right = first **same line** peer if any, else first other On SKU  
- STE → UL (Saving), PA → Credit Life (Protection), etc.

### 3.3 Change sheet

- Entry: tap **product name** or **Change** under the header (both columns)  
- Title: `Replace [current name]`  
- Search: name / code / line (optional filter; catalog is small)  
- Rows: icon · name · `LINE · CODE`  
- Current slot: check  
- Other column’s SKU: subtitle **On the other side · tap to swap**  
- Tap current: dismiss, no change  
- Tap other-side SKU: swap columns, **Pin follows the SKU**  
- Tap a third SKU: replace this slot only; Pin stays on the same column  
- Cannot build a pair of the same `id`

### 3.4 Pin + Use

- Pin marks the **conversation** product (screenshot Pinned)  
- **Use** on the pinned column = primary (filled); the other = secondary outline  
- Either Use still opens **one** Get A Quote with that `CatalogProduct`  
- Pin does **not** lock the picker

### 3.5 Honesty

- Premium / Coverage rows stay **indicative** (`59`)  
- No Core pricing, no dual save-quote, no start e-App from Compare  
- Web Products CRUD (`89`) is catalog admin — not this screen

---

## 4. P1 (not this pass)

- Three-up compare on tablet  
- Remember last compared pair per agent  
- Highlight differing cells  
- Deep-link `?left=STE&right=UL`  
- HQ portal compare

---

## 5. What not to do

- Don’t add a third product column on phone  
- Don’t allow Off / Group SKUs “just to look”  
- Don’t start two e-Apps or a cart from Use  
- Don’t replace Pin with radio “which to buy” that hides the other Use  
- Don’t invent a Core compare API — mock catalog only

---

## 6. Prototype data (no API)

Same catalog as Product tab: UL · STE · PA · Credit Life · Family Health · Travel Protect · Life Plus Pack.

---

## 7. Test (this pass)

- Open Compare from STE → peer is UL (same line)  
- Change right → Personal Accident → headers + Use labels update; STE stays  
- Change left → Universal Life while right is UL → columns swap; Pin stays on STE  
- One-product catalog (if mocked): Compare icon snackbar, no route  
- Dark: zebra + sheet still readable (`82`)
