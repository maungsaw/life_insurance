# FR-08 Notification Setup · FR-09 Announcement Setup (clear split)

## 1. BRD (source of truth)

### FR-08 — Notification Management

| Item | Platform | Job |
|------|----------|-----|
| Recurring premium reminders | Mobile (receive) | Auto alert when premium due soon (e.g. 7 days) |
| Annual renewal reminders | Mobile (receive) | Auto alert well before renewal (e.g. 60 days) |
| **Notification Setup** | **Web** | Authorized user configures notification rules from backend |
| Delivery + Core integration | API | Push / triggers from Core |

### FR-09 — Announcement Management

| Item | Platform | Job |
|------|----------|-----|
| **Announcement Setup** | **Web** | Authorized user creates / publishes announcements |
| Notification announcement (URL + Image) | **Mobile** | FAs can receive a push that carries image + deep URL |
| (FR-10) Company Announcements | Mobile | **Read-only** broadcast feed |

### Not the same as header bell

| Surface | Job |
|---------|-----|
| Header → `/notifications` | **Inbox** — read alerts already delivered to *me* |
| Management → Notification | **Setup** — FR-08 rules (when/what fires) |
| Management → Announcement | **Setup** — FR-09 compose feed (+ optional push) |

---

## 2. Problem

Earlier mock put an “image + URL push composer” under **Notification** and labeled it FR-09. That:

1. Hid FR-08’s real job (**configure premium / renewal / alert rules**).  
2. Made Notification and Announcement feel like two almost-identical composers.  
3. Blurred inbox (bell) vs setup (Management).

---

## 3. Decision

```
Management ▾
  ├── Resource        ← FR-10 library
  ├── Notification    ← FR-08 Notification Setup (rules)
  ├── Announcement    ← FR-09 Announcement Setup (feed + optional push)
  └── Devices         ← NFR remote wipe
```

| Screen | Owns | Does not own |
|--------|------|--------------|
| **Notification** | Rule cards: enable · lead time · audience · Core trigger label · last run | Composing marketing feed cards |
| **Announcement** | Title · image · URL · audience · Publish to feed · optional “Also push notification” | Automated premium/renewal timing |
| **Bell inbox** | Personal list · filters · deep links | Any setup |

### Mental model (one sentence each)

- **Notification setup** = “Which **automatic alerts** should fire, and when?”  
- **Announcement setup** = “What **company message** should FAs see in the feed (and optionally as a push)?”  
- **Inbox** = “What came **to me**?”

---

## 4. Notification screen UX (FR-08)

### Layout

1. Page header: **Notification setup** · FR-08  
2. Short honesty line: “Rules drive mobile alerts. Header bell is the inbox.”  
3. **Rules** table/cards (primary)  
4. Optional **Recent automated sends** (read-only mock)

### Rule row (simplified)

| Field | Example |
|-------|---------|
| Rule | Recurring premium due |
| Trigger | Core premium schedule |
| Lead time | 7 days before due |
| Status | On / Off (table only) |
| Actions | Edit · Turn off/on |

**Removed from dialog:** Audience · Channel · Status on save — Core owns who gets what channel; managers only tune **when** (trigger + lead time).

### Add / Edit dialog (3 fields)

1. Rule name *  
2. Trigger * — prefills suggested lead time  
3. Lead time *  

New rules default **On** in the table. Pause with **Turn off** — no “status on save” in the dialog.

### Add new rule flow

1. **+ Add rule** → dialog (3 fields).  
2. **Create rule** → row at top · **On** by default.  
3. **Edit** same dialog · **Turn off/on** in table without reopening.

| Step | UX |
|------|-----|
| Add | Dialog · name + trigger + lead time |
| Edit | Same dialog · Save · optional Remove |
| Pause | Turn off/on in table |

---

## 5. Announcement screen UX (FR-09)

### Layout

1. Header: **Announcement setup** · FR-09  
2. Honesty: “Publishes to mobile **read-only feed** (FR-10). Optional push = notification announcement with image + URL.”  
3. Create card + Feed history  

### Composer

- Title * · Image * · URL · Audience · Save draft · **Publish to feed**  
- Checkbox: **Also send as push notification** (delivers FR-09 “notification announcement with URL and Image” without stealing FR-08’s rules screen)

### History

Live · Draft · Expired · whether push was sent.

---

## 6. Cross-links (clarity, not clutter)

| From | Cue |
|------|-----|
| Notification page | Link text: “Personal inbox →” header bell / `/notifications` |
| Announcement page | “Automatic premium/renewal timing → Notification setup” |
| Inbox News item | Deep link → mobile announce feed / web announce history (not rules) |

---

## 7. Acceptance

- [x] Brainstorm separates FR-08 vs FR-09 vs inbox  
- [x] Notification page = rules setup (not duplicate announce composer)  
- [x] Announcement page = feed setup + optional push  
- [x] Copy / subtitles match BRD  

---

## 8. Out of scope

- Real Core trigger wiring  
- FCM payloads  
- Per-FA mute preferences (later)
