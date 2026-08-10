# Product detail screen — UI/UX polish brainstorm

**Screen:** Mobile · Sell → Products → **Product detail** (screenshot: Endowment Plan)  
**Parent flow:** `24-product-detail-quote-eapp-split.md`  
**Goal:** Make “read brochure / skim rates → Calculate” feel clear, thumb-first, and not confused with e-App.

---

## 1. What the screenshot is trying to do

| Layer | Intent |
|-------|--------|
| Back | Escape to catalog |
| Code + name | Which Core product am I on? |
| Brochure \| Rates | Two ways to learn before quoting |
| Body | Enough to sell face-to-face |
| **Calculate premium** | Only forward path into calculator |

One job: **understand this product, then calculate.** Not start e-App. Not manage On/Off.

---

## 2. Friction found (from current mock)

| Issue | Why it hurts | Direction |
|-------|--------------|-----------|
| **EN chip looks like language toggle** | ENG/MM lives on Profile — FA may mis-tap | Label as **Core code** · caption `Code · EN` under chip or small “CORE” badge |
| **Big empty space under CTA** | Thumb CTA floats mid-screen · looks unfinished | **Sticky footer** Calculate · content scrolls above |
| **No place-in-journey** | After Products, unclear that Calc → Quote → e-App still ahead | Thin **spine**: `Detail · Calc · Quote · e-App` with Detail on |
| **“e-App” tab active** while reading a brochure | IA mismatch · feels like paperwork already started | Keep tab highlight for sell home, but add eyebrow **Product detail** so the screen job is obvious |
| **Brochure card is thin** | Primary selling asset competes with bullets | Larger brochure tile · **Open brochure** as clear secondary button |
| **Rates feel hidden** | Only a mute tab · FA may never open | Tab stays; Rates body gets **“From ~” sample callout** + disclaimer |
| **Who it’s for / benefits are flat text** | Low scan speed in the field | Small **info cards** / check rows, not long paragraphs |
| **Open** as text link | Easy to miss vs Calculate | Button-style on brochure card |

---

## 3. Options considered

### A · Keep Brochure \| Rates (refine) — ✅ Pick
Least new IA · fixes layout + sticky CTA + code clarity.

### B · Three tabs: Overview \| Brochure \| Rates
Overview = who/benefits; Brochure = PDF only; Rates = table.  
**Pros:** Cleaner. **Cons:** Extra tap before PDF. ❌ for v1.

### C · Single long scroll (no tabs)
Everything visible. **Cons:** Rates buried; long on small phones. ❌

### D · Split “Learn” vs “Quote” as two screens
Over-splits the spine we already have (Detail → Calc). ❌

---

## 4. Target layout (refined Product detail)

```
← Products
Product detail                    ← eyebrow (job label)
[CORE EN]  Endowment Plan
           Savings + protection
Detail · Calc · Quote · e-App     ← spine (Detail = on)

[ Brochure ] [ Rates ]

── Brochure tab ──
┌ PDF cover (taller) ──────────┐
│ Endowment brochure v3        │
│ Cached · Resource library    │
│ [ Open brochure ]            │
└──────────────────────────────┘
Who it’s for  → short card
Key benefits  → 3 check rows

── sticky footer ──
[ Calculate premium ]
```

### Rates tab
- One **highlight strip**: e.g. “Age 30–34 · SI 10M → ~185,000.00 / year (indicative)”
- Full sample table below  
- Footer note: final number only after **Calculate**

### Sticky CTA rules
- Always visible above tab bar (or replace mid-page button)  
- Secondary ghost optional later: “Share brochure” — not v1  
- Never put **Start e-App** here (belongs after Save quote · hub)

---

## 5. Microcopy

| Element | Copy |
|---------|------|
| Eyebrow | Product detail |
| Code | `EN` + small label `Core code` |
| Spine | Detail · Calc · Quote · e-App |
| Brochure CTA | Open brochure |
| Primary | Calculate premium |
| Rates disclaimer | Indicative only · Calculate for Core price |

ENG/MM stays on **More → Profile** — never on this chip.

---

## 6. Motion (light)

- Tab switch: cross-fade content (150ms)  
- Sticky CTA: no bounce — presence only  
- Open brochure: mock sheet or system viewer later  

---

## 7. Acceptance

- [x] Brainstorm documented  
- [x] Core code not confused with language  
- [x] Sell spine visible on detail  
- [x] Sticky Calculate premium  
- [x] Stronger brochure card + Open brochure  
- [x] Rates highlight + disclaimer  
- [ ] Real PDF viewer / Core rate API (later)  

---

## 8. Related

- `24` full sell spine · `23` On/Off · `10` mobile × web · Resource library for brochure source  
