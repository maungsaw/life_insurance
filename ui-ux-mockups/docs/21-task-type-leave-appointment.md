# Task type rename — Leave appointment (replaces Recruitment)

## 1. Problem

Web Tasks board used **Recruitment** as a task type chip/filter. Product direction: drop that label and use **Leave appointment** instead for appointment / leave-related field work.

Recruitment **pipeline / agent status** (Screening → Contracted) stays under **Audit** directory — not a Tasks type. Onboarding follow-ups can still be tasks, but the type vocabulary for this portal mock is no longer “Recruitment”.

## 2. Decision

| Before | After |
|--------|--------|
| Task type `Recruitment` | Task type **`Leave appointment`** |
| Filter option Recruitment | Filter option Leave appointment |
| Example cards (interview / NIIM / LC) typed Recruitment | Example cards reframed as leave / client appointment work |

**Type set (web + dialog):**

`Leave appointment` · `Servicing` · `e-App` · `Other`

## 3. UX rules

| Rule | Why |
|------|-----|
| Chip label = exact type string | Filter and card stay 1:1 |
| Don’t invent “Leave” vs “Appointment” split yet | One clear type for managers |
| Seed titles match the type | Avoid “LC Training” tagged Leave appointment |
| Notifications copy follows type | Inbox meta shouldn’t say Recruitment interview |

## 4. Surfaces updated

- Web `TasksPage` — type union, filter, dialog, seeds, tone map  
- Web Notifications / Audit helper copy  
- Docs `08`, `20`, nav trim notes  

Mobile My work may still show calendar tasks; type option aligned where present.

## 5. Acceptance

- [x] No Recruitment task type in web Tasks UI  
- [x] Leave appointment in filter + dialog + cards  
- [x] Brainstorm documented  
