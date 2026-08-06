# Product On/Off Control — Control panel + mobile catalog

**Requirement:** *Ability to enable/disable specific products from the control panel.*

Stakeholders need to **see and set** which products are **On** vs **Off** — not only the FA sell list that hides Off products.

---

## 1. Two jobs (do not mix on one screen)

| Job | Who | Surface | Purpose |
|-----|-----|---------|---------|
| **A · Sell catalog** | FA / TL | Mobile · Sell → Products | Quote / e-App from **On** products only |
| **B · Product control** | Authorized ops / manager | Mobile · Product control **and** Web · Management → Products | Decide **which** products are On / Off |

Job B is the BRD “control panel” capability. Job A is the field consequence.

```
Product control (On/Off)  ──sync──►  Sell → Products (On only)
```

---

## 2. Mobile UX brainstorm — how to show On vs Off

### Options considered

| Option | Idea | Pros | Cons | Verdict |
|--------|------|------|------|---------|
| **1 · Sell list hides Off** | Only On rows | Clean for FA | Stakeholders never see Off · control job invisible | ❌ alone |
| **2 · Sell list shows Off greyed** | All products · Off not tappable | One screen | FA clutter · toggle temptation | ❌ |
| **3 · Separate Product control screen** | All products · status + switch · filters | Clear job · matches web | Extra screen | ✅ **Pick** |
| **4 · Profile toggle only** | Buried under More | Easy to miss | Weak for demos | ❌ primary |

**Pick: Option 3** — dedicated **Product control** on mobile (authorized), plus keep **Sell → Products** as On-only for selling.

### Mobile Product control — screen UX

**Entry (authorized):**
- Manager home → **Product control**
- More / Profile → **Product control** (ops / manager roles)
- Sell Products banner link → **Manage On/Off** (demo path)

**Header**
- Title: `Product control`
- Sub: `Choose which products FAs can sell · Core codes`
- Summary chips: `3 On` · `2 Off`

**Filters (cat-banner)**  
`All` · `On` · `Off` — so reviewers can answer “ဘယ်ဟာ On / ဘယ်ဟာ Off” in one tap.

**Row**
| Element | Behavior |
|---------|----------|
| Code chip (EN / UL / …) | Identity |
| Name + short line | From Core |
| Status pill | On (green) / Off (muted) |
| Switch | Toggle · Off requires confirm |

**Turn Off confirm (sheet / inline)**
1. Impact: “FAs will not see this in Sell → Products after sync.”
2. Reason * — Campaign pause · Regulatory · Pricing update · Other
3. Confirm / Cancel

**Turn On** — switch + short toast (no heavy dialog).

**FA without permission** — no entry to Product control; Sell shows On only.

---

## 3. Web (unchanged intent)

**Management → Products** = same Job B on desktop (table · filters · Turn off dialog · history).  
Mobile control and web control write the **same catalog state**.

---

## 4. Name / IA

| Place | Label |
|-------|-------|
| Web nav | **Products** |
| Mobile Sell tab | **Products** (sell) |
| Mobile control screen | **Product control** |

```
Mobile
├── Sell → Products              ← Job A · On only
├── Manager / More
│     └── Product control        ← Job B · On/Off switches · All|On|Off
└── (sync same catalog as Web Management → Products)
```

---

## 5. Who can toggle (mobile + web)

| Role | Sell catalog | Product control |
|------|--------------|-----------------|
| FA | On products only | No |
| Team Lead | On products only | No (v1) |
| Authorized manager / ops | On products only when selling | **Yes** — On/Off |
| Web HQ admin | — | **Yes** |

Mock: Product control is reachable from Manager + Profile for review.

---

## 6. Sync rules (short)

| Action | Result |
|--------|--------|
| Turn **Off** | Status Off · Sell list drops product on sync · in-flight drafts can still submit |
| Turn **On** | Status On · Sell list gains product on sync |
| Offline control | Queue toggle · apply when online (mock: instant) |

---

## 7. Acceptance

- [x] Brainstorm separates Sell vs Control  
- [x] Mobile **Product control** shows every product · On/Off · filter · switch + Off confirm  
- [x] Mobile Sell → Products stays On-only with link to control  
- [x] Web Management → Products control panel  
- [ ] Core API wiring (later)  

---

## 8. Related

- `17` Management nav · `05` FR-03 sell · `10` mobile × web split  
