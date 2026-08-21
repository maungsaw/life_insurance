# Get a Quote — visual cohesion brainstorm

**Canvas:** `get-quote-cohesion-brainstorm.canvas.tsx`  
**Screen:** `get-quote.html` · Steps 1→2→3 (screenshots Aug 21)  
**Problem:** Flow jobs are right (inputs → compare → review), but the three screens feel like **three different UIs** — not one calculator journey.

---

## What’s off (from screenshots)

| Step | Feels wrong |
|---|---|
| **1 Inputs** | Form is bare on cream · no soft-card shell · product line (“Personal Accident”) reads as a random accent · step = tiny dots only |
| **2 Compare** | Spreadsheet table fights soft-card language · selected = full-column paint · category chips OK but heavy vs home tools |
| **3 Review** | Flat key-value list · premium not hero · CTAs (“Save draft / Buy”) don’t rhyme with Compare “Edit / Buy” · step dots can look incomplete |

Also: offline strip is fine (QA pattern), but it sits between title and form and makes Step 1 feel “alert-first.”

---

## North star

One **Premium Calculator** composition across all 3 steps:

1. Same app-bar rhythm (back · title · product chip)  
2. Same **labeled stepper** (not dots alone)  
3. Soft-card surfaces for the main job of each step  
4. One primary CTA language: **Continue / Edit / Buy** family  
5. Premium always the loudest number when money appears  

Skin stays cream · Coolors · soft cards · sheets — match Products / PA detail / Home.

---

## Options

### A — Unify chrome + premium hero (recommend)
Keep 3 steps & compare matrix job. Polish only:

- **App bar:** product as mint/steel **pill** (not red/pink subtitle)  
- **Stepper:** `1 Inputs · 2 Compare · 3 Quote` text labels under 3 segments  
- **Step 1:** wrap fields in one soft-card · sticky `Calculate`  
- **Step 2:** matrix inside soft-card · select = thin Steel ring + check on header only (not whole column flood) · footer `Edit` / `Buy`  
- **Step 3:** large **Total premium** hero at top of card · details as quiet rows · `Save draft` secondary · `Buy / e-App` primary  

Fastest path to “same app.”

### B — Quote sheet pattern
After Calculate, Compare becomes a **bottom sheet** over a dimmed inputs screen; Buy opens review as full screen. More motion; harder for stakeholders to screenshot step-by-step.

### C — Single scroll wizard
All three blocks stacked on one scroll with sticky step header. Fewer “page jumps,” longer scroll; compare matrix may feel cramped.

---

## Step-by-step polish checklist (if A)

**Shared**
- [ ] Title: always “Get a quote” · product pill right of title or under  
- [ ] Stepper: 3 equal segments · active = Deep fill · done = mint check  
- [ ] Primary button height/radius match Products / e-App  

**Step 1**
- [ ] Soft-card form group  
- [ ] Risk toggle already OK — keep  
- [ ] Live “Est. from last calc” optional muted line (optional)  

**Step 2**
- [ ] Soften table: zebra none · hairline only · selected column header badge  
- [ ] Category chips = same `.pol-type` language as Policies  
- [ ] Illustrative disclaimer stays one line  

**Step 3**
- [ ] Hero total `7,100 MMK`  
- [ ] Stamp as footnote under total  
- [ ] Referral inside card or under  
- [ ] Align CTA labels with Compare (`Edit` back link optional above)  

---

## Decision

**A shipped** on `get-quote.html` — labeled stepper · product pill · soft-card inputs · softer compare select · premium hero · Edit / Buy / Save draft CTA family.
