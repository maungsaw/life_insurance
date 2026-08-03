# FR-07 Task Management UX (Mobile + Web)

**BRD §5.7**

| Requirement | Channel | UX |
|-------------|---------|-----|
| Assigned tasks in **calendar** | Mobile (+ view on portal) | Day / Week / Month |
| Notifications on assign/update | Mobile | Push + in-app Work badge |
| **To-Do** create / view / complete | Mobile | Linked to client/lead/recruit when relevant |
| Managers **Add / Move / Delete** | Web | Task admin + recruitment example |
| Status: Pending · In Progress · Completed | Mobile + Web | Explicit status control |
| Recruitment onboarding tracking | Web (+ mobile view) | Task linked to candidate status |

---

## 1. Mental model

```
Manager (Web) creates / assigns / moves / deletes
        ↓ push
FA (Mobile) sees Calendar + To-Do + notification
        ↓ updates status
Manager sees completion on portal
```

---

## 2. Mobile screens

1. **Work hub** — toggle Calendar | To-Do  
2. **Calendar** — Day / Week / Month chips; dots on days with tasks  
3. **To-Do** — checklist; create task; filter Mine / Assigned  
4. **Task detail** — title, due, assignee source, link (client/lead/recruit), status control, complete  
5. **Create task** — title, due date `DD-MMM-YYYY`, optional link, notes  

---

## 3. Web screens (Operations → Tasks)

1. Task table: title, assignee FA, type (Follow-up / Premium / Recruitment), status, due  
2. **Add task** drawer/form  
3. **Move** (reassign / reschedule) · **Delete** with confirm  
4. Recruitment board linkage (candidate + onboarding status)  
5. Bulk status visibility for managers  

---

## 4. Concept tones

| Concept | Task UX |
|---------|---------|
| **A** | Amber due chips, big Complete CTA, coaching energy |
| **B** | Guided “why this task”, calm calendar, clear ownership |
| **C** | Signal queue, status chips PENDING/RUN/DONE, dense admin grid |

---

## 5. Acceptance

- [ ] Calendar supports Day / Week / Month  
- [ ] To-Do create + complete  
- [ ] Status Pending / In Progress / Completed on detail  
- [ ] Web Add / Move / Delete  
- [ ] Recruitment task example present  
- [ ] Notification entry point from Work / Notifs  
