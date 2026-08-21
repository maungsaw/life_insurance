# This Month Card — Attractiveness Brainstorm

**Canvas:** `this-month-card-brainstorm.canvas.tsx`  
**Screen:** FA Home · `after-login.html` hero

---

## Problem
Current card is clear but flat: equal KPIs, thin MDRT, awkward Commission wrap, See more can get lost.

## Goals
- Attractive without becoming a dense dashboard
- Clear 3-second hierarchy: greeting → KPIs → MDRT
- Small, meaningful color (Mint ↑, stronger glass, white CTA)

## Concepts

| ID | Idea | When |
|---|---|---|
| **A (recommend)** | Glass KPI strip + mint MDRT / FYP ↑ · Commission one-line money | Default polish |
| **B** | Split band: Baltic greeting + cream metric inset | Bigger visual jump |
| **C** | Hero one metric (Commission or FYP) + secondary chips | Needs BA pick of “the” KPI |

## Accent map
- Base: Sky → Steel → Baltic (keep)
- FYP MoM ↑: Mint
- MDRT fill: Mint or bright Sky
- See more: white pill + Deep text

## App bar (done)
- Left: brand mark (robust `/assets/` + fallback)
- Center/flex: **username only** (tap → Profile) — avatar removed
- Right: bell

## Status
**Concept A shipped** on `after-login.html` (glass KPIs, mint FYP/MDRT, one-line Commission, white See more).
