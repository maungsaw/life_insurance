# 111 — Three Mobile Design Branches (HTML wireframe backup)

**Date:** 2026-08-19  
**Scope:** Mobile Flutter app only · **not** agent-web-portal  
**Goal:** Three **completely different** UI/UX directions from `KBZ_UI&UX/Wireframe1`, `Wireframe2`, and today's Concept A / Flutter shell  
**Deliverable:** Clickable HTML phone mockups per branch (backup / stakeholder review)  
**Git:** `design/baseline-wireframe-aligned` · `design/branch-1-atelier` · `design/branch-2-signal` · `design/branch-3-grove`  
**Main branch:** untouched — work lives on design branches only

---

## 1. Why stakeholders say it looks the same

| Pattern | Wireframe1/2 | Concept A / Flutter today |
|---------|--------------|---------------------------|
| Coolors blue + white cards | ✓ | ✓ |
| Partner banner → 4×2 services → promo carousel | Wireframe2 | Guest + logged-in home |
| Bottom pill nav + center FAB | Wireframe2 | `AppBottomNav` |
| Blue gradient commission hero | Wireframe1 | `AppCommissionCard` |
| Form-stack auth + OTP boxes | Wireframe1 | Auth pages |

**Fix:** Change **navigation paradigm**, **home information architecture**, and **visual metaphor** — not just hue.

---

## 2. Branch map

| Git branch | Design name | Metaphor | Open mockup |
|------------|-------------|----------|-------------|
| `design/baseline-wireframe-aligned` | Reference | Current wireframe-aligned flow | `concept-a-field-momentum/index.html` |
| `design/branch-1-atelier` | **Atelier** | Daily planner / editorial | `branch-1-atelier/index.html` |
| `design/branch-2-signal` | **Signal** | Performance HUD / cockpit | `branch-2-signal/index.html` |
| `design/branch-3-grove` | **Grove** | Guided trust / wizard | `branch-3-grove/index.html` |

---

## 3. P0 screens (all branches)

Same **jobs**, different **presentation**:

1. **Guest Home** — before login (`docs/74`)
2. **Login** — Agent ID + password (`docs/07`, `35`)
3. **OTP** — SMS verify (`docs/41`)
4. **Home (logged-in FA)** — commission display, alerts, quick paths (`docs/36`, `46`)
5. **Customer** — Leads \| Clients list + detail stub (`docs/51`, `79`)
6. **Task Management** — calendar / agenda (`docs/68`, `77`)

BRD flows unchanged · out-of-scope unchanged (`docs/34`).

---

## 4. Branch 1 — Atelier

**Avoid:** blue gradient hero · 4×2 grid · center FAB · promo piggy bank carousel

| Token | Value |
|-------|-------|
| Background | `#F4F0EA` warm stone |
| Primary | `#1B4332` forest |
| Accent | `#E07A5F` terracotta |
| Type | Plus Jakarta Sans |

| Area | Pattern |
|------|---------|
| Nav | **Top chips:** Today · People · Sell · Me — **no bottom bar** |
| Guest | Editorial photo band + **horizontal scroll** service chips |
| Home | **Timeline** “Today · N items need you” — premium due, follow-up, task |
| Auth | Bottom sheet form · OTP **4 large circles** |
| Customer | Alphabet rail · story-style profile sections |
| Tasks | Week strip + **timeline slots** (not flat list first) |
| CTA | Sticky single bar: “Start quote” / “Add lead” |

**Best for:** FA adoption, human feel, field speed

---

## 5. Branch 2 — Signal

**Avoid:** white-on-white cards · friendly promo · labeled bottom nav · long form stacks

| Token | Value |
|-------|-------|
| Background | `#0D1117` |
| Surface | `#161B22` |
| Signal | `#2DD4BF` cyan |
| Alert | `#FBBF24` amber |
| Type | Inter + tabular nums for KPIs |

| Area | Pattern |
|------|---------|
| Nav | **Left icon rail** (5 icons) + ⌘ search entry in header |
| Guest | Dark · calculator live · rest **glass blur lock** |
| Home | **Bento grid** — FYP % · MDRT % · sparkline · red-flag strip |
| Auth | Agent ID only → **pin pad OTP** |
| Customer | Split list/detail feel · header filter pills |
| Tasks | **Kanban lanes:** Today · This week · Done |
| CTA | Long-press action wheel (quote / lead / task) |

**Best for:** Team Lead, Manager, KPI-heavy users

---

## 6. Branch 3 — Grove

**Avoid:** dense dashboard · dark mode · icon-only nav · sales pressure visuals

| Token | Value |
|-------|-------|
| Background | `#E8E4F3` soft lilac |
| Primary | `#4A3267` plum |
| Trust | `#C9A227` gold |
| Type | DM Sans · MM-safe 2-line labels |

| Area | Pattern |
|------|---------|
| Nav | **3 bottom tabs:** Home · Work · Account |
| Guest | 3-card onboarding story → explore as guest |
| Home | **Next best step** hero card · 2-col large service tiles with subtitles |
| Auth | Step wizard + “Why we need this” under fields |
| Customer | Lead → qualify checklist · plain-language tabs |
| Tasks | Month grid + selected-day agenda · filter sheet |
| CTA | “Help me sell” guided launcher |

**Best for:** Brand trust, new agents, compliance-calm HOA

---

## 7. Side-by-side differentiation

| | Atelier | Signal | Grove | Wireframe1/2 |
|--|---------|--------|-------|----------------|
| Nav position | Top chips | Left rail | 3 bottom tabs | Bottom pill + FAB |
| Home hero | Timeline | Bento KPIs | Next step card | Balance gradient |
| Services | Horizontal scroll | Compact icon row | 2-col large tiles | 4×2 grid |
| Guest CTA | Editorial band | Glass lock overlay | Onboarding story | Partner banner |
| Theme | Warm light | Dark HUD | Soft light | Corporate blue |

---

## 8. HTML wireframe usage

1. Open `ui-ux-mockups/index.html` → pick branch card  
2. Use **screen picker** (left on desktop) to jump P0 screens  
3. Tap in-phone controls to simulate nav (guest → login → home)  
4. Stakeholder review: pick one branch or mix (e.g. Atelier home + Signal tasks)  
5. Flutter implementation **only on chosen branch** — not on `main`

**Local serve (optional):**

```bash
cd ui-ux-mockups && python3 -m http.server 8080
# open http://localhost:8080/index.html
```

---

## 9. Next steps (after pick)

1. Theme tokens → `lib/core/themes/` on chosen `design/branch-N-*`  
2. Shell widgets: `AppShell`, nav replacement for `AppBottomNav`  
3. P0 Flutter screens restyle · P1 e-App / product / profile  
4. Merge to `main` only after stakeholder sign-off  

---

## 10. Checklist

- [x] Brainstorm + branch naming  
- [x] P0 HTML wireframes (guest · auth · home · customer · tasks)  
- [x] Git branches from `origin/main`  
- [ ] Stakeholder review session  
- [ ] Flutter theme + shell on selected branch  
