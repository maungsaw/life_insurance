# 112 — Stakeholder Meeting Pack (Mobile UI · Three Branches)

**Date:** 2026-08-19  
**Audience:** Product · Agency leadership · UX stakeholders · Engineering  
**Duration:** 45–60 minutes  
**Live review:** PNG packs in `KBZ_UI&UX/Branch1_Atelier/` · `Branch2_Signal/` · `Branch3_Grove/` (same format as Wireframe1/2). Flutter widgets live in `lib/design_mockups/`.  
**Deck:** `ui-ux-mockups/stakeholder-meeting/index.html`  
**Spec:** `docs/113-flutter-png-mockup-pack.md`

---

## 1. Meeting objective

Pick **one primary mobile design direction** (or approve a **hybrid**) that is **visually distinct** from `KBZ_UI&UX/Wireframe1` and `Wireframe2`, while keeping all required agent workflows.

**Success:** Written decision — Branch 1 / 2 / 3 / Hybrid — plus owner for Flutter implementation.

---

## 2. Agenda (50 min)

| Time | Topic | Owner |
|------|-------|-------|
| 0–5 | Context: feedback “looks like wireframes” | Product |
| 5–10 | What stays the same (BRD · flows · scope) | Product |
| 10–15 | Reference vs three new directions | UX / Eng |
| 15–25 | **PNG review:** Overview sheet + per-screen images (each branch) | UX |
| 25–35 | Side-by-side comparison · personas | UX |
| 35–45 | Discussion · risks · MM/ENG · offline | All |
| 45–50 | **Decision** · next steps · timeline | Product |

---

## 3. Opening script (context)

> Stakeholders provided Wireframe1 and Wireframe2 as references. Our first build followed those patterns closely — blue hero, service grid, bottom nav with center FAB. Feedback: **the app still looks like the wireframes**, not a fresh modern product.
>
> We are **not** removing features or changing BRD scope. We are proposing **three genuinely different visual and navigation approaches**, drawn in **Flutter** (same stack as `main`) and exported as **PNG mockups** — the same review format as Wireframe1/2. HTML is not the source of truth.

---

## 4. What does NOT change

- Login · OTP · password rules (FR-01)  
- Guest home with login gate (FR-01 / optional calculator)  
- Commission **display** only — no payout (BRD out-of-scope)  
- Leads \| Clients CRM (FR-03)  
- Product → quote → e-App spine (FR-04 / FR-05)  
- Task calendar / agenda (FR-07)  
- ENG + MM labels · hierarchy-safe data  
- Web portal = separate React app (not in this review)

---

## 5. Options summary

| | **Reference** | **Branch 1 Atelier** | **Branch 2 Signal** | **Branch 3 Grove** |
|--|---------------|----------------------|---------------------|---------------------|
| **Git branch** | `concept-a` / baseline | `design/branch-1-atelier` | `design/branch-2-signal` | `design/branch-3-grove` |
| **Metaphor** | Wireframe-aligned | Daily planner | Performance HUD | Guided partner |
| **Navigation** | Bottom pill + FAB | Top chips | Left icon rail | 3 bottom tabs |
| **Home focus** | Balance card + grid | Today timeline | Bento KPIs | Next best step |
| **Best for** | Comparison only | Field FA speed | Managers / KPI culture | Trust · new agents |
| **Risk** | “Same as wireframe” | Less familiar nav | Dark · dense | Can feel slower |

---

## 6. Live demo script (15 min)

Open gallery: `ui-ux-mockups/index.html` → **Stakeholder deck** or each branch.

For **each** branch, show in order (2–3 min each):

1. **Guest Home** — first impression · login CTA  
2. **Login + OTP** — trust · clarity  
3. **Home (FA)** — daily job-to-be-done  
4. **Customer** — find lead/client  
5. **Tasks** — calendar / work  

**Ask after each branch:** “Does this feel **different** from Wireframe1/2? Could an FA use this in the field?”

---

## 7. Persona fit

| Persona | Strongest fit | Why |
|---------|---------------|-----|
| **P1 Field FA** | Atelier or Grove | Thumb-friendly · clear next action |
| **P2 Team Lead** | Signal or Atelier | KPI visibility · team alerts |
| **P3 Manager (mobile)** | Signal | Density · red flags · export path to web |
| **HOA / brand** | Grove | Calm · institutional trust |

---

## 8. Discussion prompts

1. Which direction best represents **KBZ LIFE** brand for agents?  
2. Is **dark mode default** (Signal) acceptable for Myanmar field use (outdoor glare)?  
3. **Top nav vs bottom nav** — adoption concern for older FAs?  
4. Can we accept **removing center FAB** (Atelier / Signal)?  
5. **Hybrid allowed?** e.g. Grove home + Signal tasks — who owns the cost?  
6. Burmese label length — which layout survives 2-line MM labels best?

---

## 9. Decision worksheet (fill in meeting)

**Primary choice:** ☐ Branch 1 Atelier · ☐ Branch 2 Signal · ☐ Branch 3 Grove · ☐ Hybrid  

**If hybrid, specify:**

| Screen / area | Use branch |
|---------------|------------|
| Navigation shell | |
| Guest home | |
| Auth | |
| Logged-in home | |
| CRM | |
| Tasks | |

**Signed off by:** _______________ **Date:** _______________

**Flutter implementation branch:** `design/branch-N-*` → merge to `main` after P0 shell  

**Out of scope for this phase:** e-App wizard restyle · policy detail · web portal

---

## 10. Technical notes for engineering

- HTML mocks: `ui-ux-mockups/branch-{1,2,3}-*/index.html`  
- Spec: `docs/111-three-mobile-design-branches.md`  
- Baseline reference: `design/baseline-wireframe-aligned`  
- `main` untouched until sign-off  
- Local server: `cd ui-ux-mockups && python3 -m http.server 8080`

**Remote branches (after push):**

```
origin/design/baseline-wireframe-aligned
origin/design/branch-1-atelier
origin/design/branch-2-signal
origin/design/branch-3-grove
```

---

## 11. Next steps after meeting

1. Record decision in this doc (section 9)  
2. Implement theme tokens + `AppShell` on chosen branch  
3. P0 Flutter screens: guest · auth · home · customer · tasks  
4. Second review: P1 product · e-App · profile  
5. Merge to `main` when stakeholders approve visual direction

---

## 12. Checklist

- [ ] Deck opened on projector / shared screen  
- [ ] All three HTML branches tested offline  
- [ ] Wireframe1/2 PNGs available for side-by-side ( `KBZ_UI&UX/` )  
- [ ] Decision captured  
- [ ] Owner assigned for Flutter pass
