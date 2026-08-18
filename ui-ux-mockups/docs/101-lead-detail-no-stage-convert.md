# 101 — Lead detail: no stage / no convert on mobile

**Surface:** Lead Details (`lead/presentation/pages/detail.dart`)  
**Reference:** FR-03 hub (`79`) · e-App doors (`81`) · Web CRM (`87`)  
**Today:** FA can tap **Update Stage** (New → Applied) and **Submit condition · Move to Clients**. That is ops/HQ work, not a field job.  
**Date:** 2026-08-18

**Ask:** Update Stage and Submit condition **off** — web will own them. Keep the rest usable.

---

## 0. Split

| Job | Where |
|-----|--------|
| Call · Email · Schedule | Mobile Lead detail (`103` dropped Message) |
| **Get a quote** · **Start e-App** | Mobile (sell spine) |
| Stage New / Contacted / Quoted / Applied | **Web CRM** (`87`) · display-only pill on mobile |
| Convert Lead → Client | **Web** / Core (Approved · policy issued). Tracker mock convert stays (`81`) — not a FA button |

List **filter** by stage stays. FA still *sees* the current stage. FA does **not** edit it.

---

## 1. Lead Details after this pass

1. Identity · **read-only** stage pill · Call / Email / Schedule (`103`)  
2. Equal-width row: **Get a quote** (outline) · **Start e-App** (filled)  
3. Lead Information · Notes  

No pipeline stepper. No teal convert CTA.

---

## 2. What not to do

- Don’t hide the stage **pill** (list + filter still need a label)  
- Don’t convert from this screen  
- Don’t drop Get a quote / Start e-App  
- Don’t duplicate a web kanban on mobile  

---

## 3. Test

- Lead detail has **Get a quote** · **Start e-App**  
- No **Update Stage** · no **Submit condition**  
- Buttons equal width  
- `convertLead()` helper still works for tracker (unit test)
