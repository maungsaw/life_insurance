# ProtoType 2 · Commission hero as “agent card”

**Canvas:** `p2-commission-card-brainstorm.canvas.tsx`  
**Screen:** `after-login.html` top block (today: COMMISSION · THIS MONTH panel)  
**Rule:** Ink Desk · **≠** ProtoType 1 “This month” KPI mosaic · **≠** plain bordered stat box  

---

## Job (keep)

Wireframe / FR-02: show **own commission** (hideable) + quick personal health (policies · FYP · MDRT).  
Not a real payment card — **metaphor** for “your earnings wallet.”

---

## Today (problem)

Flat ink panel + big mono number + 3 mini boxes. Reads as a dashboard widget, not a distinctive P2 hero. Soft Desk P1 already owns the colorful “This month” mosaic — P2 needs a different object.

---

## Metaphor: agent credit / membership card

| Credit-card cue | Maps to |
|---|---|
| Card face · aspect ~1.586 | Hero slab under header |
| Bank / network mark | KBZ LIFE wordmark · teal chip |
| Cardholder name | Agent name |
| Card number / masked | FA code or masked wallet id |
| Big balance | Commission MMK (eye toggle) |
| Chip / contactless | Decorative · or MDRT % ring as “chip” |
| Expiry / footer strip | Period · “This month” · MoM |
| Emboss / foil | Hairline teal edge · subtle gradient only (no purple glow) |

---

## Options

### A — **Wallet Card** (recommend)

Physical card silhouette on ink field.

- Aspect-ratio card (~16:10), slight tilt optional (0° for prototype clarity)  
- Top row: KBZ LIFE · contactless glyph · eye  
- Center: mono **726,080** · MMK  
- Bottom emboss row: name · FA-10428  
- Magstripe-thin footer: Policies 20 · FYP 72% · MDRT 65% as **segmented strip** (not 3 boxes)  
- Face: deep panel `#161E27` → `#0E141B` diagonal · teal 1px rim  

**Pros:** Instantly “card,” distinct from P1 mosaic and current box.  
**Cons:** Footer strip can feel tight — keep 3 metrics as mono caps.

### B — **Glass Chip Card**

Same silhouette · frosted panel · large teal “IC chip” square top-left holding MDRT %.  
Number as card PAN style `···· ···· 4080` + clear commission below.  

**Pros:** More playful fintech.  
**Cons:** Risk looking like a bank debit clone; chip must stay metaphor.

### C — **Vertical Pass**

Portrait membership pass (taller than wide) · punch-hole hint · commission as ticket value.  

**Pros:** Very unlike horizontal credit cards and P1.  
**Cons:** Eats vertical space above Launch Pad.

---

## Interaction

| Control | Behavior |
|---|---|
| Eye | Mask amount → `••••••` (keep) |
| Tap card body | Optional → commission detail toast / sheet (P1) |
| Long-press | Optional flip to back: “Road to MDRT” bar only |

No real card number / CVV — never invent payment data.

---

## What not to do

- Don’t paste P1 gradient KPI grid onto a card outline  
- Don’t use skeuomorphic plastic shine / holographic rainbow  
- Don’t show other FAs’ commission  
- Don’t replace Launch Pad  

---

## Decision

Reply:

- **A** — Wallet Card (recommend)  
- **B** — Glass Chip Card  
- **C** — Vertical Pass  

Then implement on `after-login.html` (+ guest teaser optional later).
