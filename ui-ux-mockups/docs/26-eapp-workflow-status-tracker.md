# e-App workflow status — after Submit (App Tracker)

**BRD statuses:** Draft · Submitted · Mark for Correction · Approved · Rejected  
**Surfaces:** Mobile App tracker (+ status detail) · Notifications deep-link  
**Related:** `04` stepper · `24` sell spine · `11` notifications

---

## 1. Problem to solve

FA finishes wizard steps 1–6 and taps **Submit**. That only means *“form is complete and sent.”*  
They still need a **separate place** to know: *where is this application in the company process now?*

Without that, Submit feels like a dead end — no proof of progress until someone asks.

---

## 2. Two layers (never mix on one chrome)

| Layer | Name | Lives where | Answers |
|-------|------|-------------|---------|
| **A** | Wizard steps 1–6 | e-App wizard | “How far did I fill?” |
| **B** | **Workflow status** | **App tracker** + **status detail** | “What did Core / UW do with it?” |

```
Fill wizard (A) ──Submit──► Status = Submitted (B)
                              │
         ┌────────────────────┼────────────────────┐
         ▼                    ▼                    ▼
   Mark for Correction     Approved            Rejected
         │                    │
         └── fix → re-Submit  └── Convert / Policy
```

**Draft** is special: still Layer A (incomplete or left mid-wizard). Subtitle shows step.  
After **Submit**, step numbers leave the list — Layer B owns the story.

---

## 3. Status dictionary (FA language)

| Status | Meaning | FA can… | Primary CTA |
|--------|---------|---------|-------------|
| **Draft** | Not submitted · on device / saved | Resume wizard at step | Continue e-App |
| **Submitted** | Received by Core / underwriting | Wait · view timeline · remind self via notif | View status |
| **Mark for Correction** | UW needs FA/client fix | Open failing step with reason | Fix now |
| **Approved** | Underwriting accepted | Convert lead → client / view policy path | View / Convert |
| **Rejected** | Closed with reason | Read reason · optionally new quote | View reason |

**Waiting** (amber) is a *Draft sub-state* (e.g. client signature), not a 6th BRD status.

---

## 4. Where FA learns “process is moving”

### 4.1 Success screen (right after Submit)
- App ref + **Status · Submitted**
- One line: *“e-App steps are done. Track underwriting on App tracker.”*
- Primary: **View in App Tracker** (opens that row’s status detail ideally)
- Secondary: Home

### 4.2 App tracker (list home for Layer B)
- Chips: All · Draft · Submitted · Correction · Approved · Rejected  
- Row = person · ref · status pill · one-line “what’s next”  
- Tap:
  - Draft / Correction → wizard (Layer A)
  - Submitted / Approved / Rejected → **Status detail** (Layer B)

### 4.3 Status detail (new — the “process view”)
Read-only pipeline for one application:

1. Header: name · product · ref · big status pill  
2. **Timeline** (vertical): Draft → Submitted → Correction? → Approved | Rejected  
   - Done steps checked · current highlighted · future mute  
3. Latest event card: date/time · actor (Core / UW) · note  
4. CTAs by status:
   - Submitted → passive + “You’ll get a notification on change”
   - Correction → Fix now  
   - Approved → Go to client / convert  
   - Rejected → reason only  

This is how FA **knows the process finished or is progressing** without reopening the wizard.

### 4.4 Notifications (push / inbox)
| Event | Notif | Deep link |
|-------|-------|-----------|
| Mark for Correction | Apps · Fix needed | Status detail or KYC step |
| Approved | Apps · Approved | Status detail |
| Rejected | Apps · Rejected | Status detail |

---

## 5. Timeline UX rules

| Rule | Why |
|------|-----|
| Always show full spine of BRD statuses | FA sees the whole journey, not only current pill |
| Correction is a **branch**, then returns to Submitted after re-submit | Don’t invent extra statuses |
| Timestamps from Core | Builds trust (“process happened”) |
| No fake “Under review 47%” progress bars | Insurance UW isn’t a percent — use events |

---

## 6. Naming

| UI label | BRD |
|----------|-----|
| App tracker | Application status tracker |
| Status detail | Single-app workflow view |
| Correction (chip) | Mark for Correction |
| Live / Submitted (pill) | Submitted |

Nav chip on Sell: **Tracker** (already).

---

## 7. Acceptance

- [x] Brainstorm: Layer A vs B · status dictionary · status detail  
- [x] Success copy clarifies “steps done · track status next”  
- [x] Tracker rows open status detail for Submitted / Approved / Rejected  
- [x] Status detail shows timeline + next action  
- [ ] Core status webhooks / push wiring (later)  

---

## 8. Related

- `04` stepper + tracker chips · `11` notif types · `05` Approved → convert  
