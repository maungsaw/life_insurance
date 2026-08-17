# 88 — Task status model (Global stage + Substatus)

**Surface:** `agent-web-portal` Tasks (`FR-07`)  
**Date:** 2026-08-17

---

## Why this change

Task types need different lifecycle wording, but reporting still needs one shared pipeline.
This pass keeps both by using:

- `Global stage`: Pending / In Progress / Completed
- `Substatus`: task-type specific states (e.g. Waiting for Payment, Issued, Re-opened)

---

## Model

### 1) Global stage (shared)

- `pending`
- `progress`
- `completed`

### 2) Substatus catalog

| Substatus | Stage |
|---|---|
| New | pending |
| Assigned | pending |
| Re-opened | pending |
| In Progress | progress |
| Follow-up Required | progress |
| Scheduled | progress |
| Waiting for Customer | progress |
| Waiting for Payment | progress |
| Waiting for Internal Team | progress |
| Submitted | progress |
| Completed | completed |
| Issued | completed |
| Delivered | completed |
| Closed | completed |
| Cancelled | completed |

---

## Type templates

- **Leave appointment:** New, Assigned, In Progress, Follow-up Required, Scheduled, Completed, Closed
- **Servicing:** Assigned, In Progress, Follow-up Required, Waiting for Customer, Completed, Closed
- **e-App:** Assigned, In Progress, Waiting for Customer, Submitted, Completed, Closed, Re-opened
- **On-Boarding:** New, Assigned, In Progress, Waiting for Internal Team, Completed, Closed
- **Other:** New, Assigned, In Progress, Follow-up Required, Completed, Closed, Cancelled, Re-opened

---

## UX behavior

- Board columns use **Global stage**
- Task card shows **Type pill + Substatus pill**
- Task card shows **SLA badge** when overdue (`24h / 48h / 72h+`)
- Form enforces valid combinations:
  - Change stage → invalid substatus is auto-corrected to first valid option
  - Change type → invalid substatus is auto-corrected
- List view adds a separate **Substatus** column
- Filters include **Substatus**
- Quick actions on cards: `Waiting`, `Done`, `Re-open`

---

## Notes

- Hardening shipped in this pass:
  - mandatory reason on `Cancelled` and `Re-opened`
  - transition guardrails (e.g. no `pending -> completed` jump)
  - SLA/aging indicator on overdue tasks
- This is still a prototype logic pass, not final policy governance.
