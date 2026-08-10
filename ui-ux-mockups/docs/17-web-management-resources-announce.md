# Management nav — Resource · Notification · Announcement · Products · Devices

## 1. BRD jobs (source of truth)

See also **`22-fr08-fr09-notification-vs-announcement.md`** for the FR-08 vs FR-09 clarity pass.

### FR-08 — Notification Management (web = **Setup**)

Configure automated alert **rules** (premium due, renewal, task assign, corrections). Mobile receives; Core/API delivers.

### FR-09 — Announcement Management (web = **Setup**)

Compose / publish company announcements. Mobile supports **notification announcement with URL + Image** (optional push from announce composer). Feed consume = FR-10 read-only.

### FR-10 — Resource + Company Announcements feed

Library sections from web; announcements feed is read-only on mobile.

**Resource list UX (`33`):** documents table shows Title · File · Version · Status · Updated. **Offline** column and “FA offline uses Priority first” hint are hidden until mobile cache policy is productized.

---

## 2. Decision

```
Sidebar
├── Dashboard
├── Tasks
├── Management  ▾ / ▴
│   ├── Resource          ← FR-10 library config
│   ├── Notification      ← FR-08 Notification Setup (rules)
│   ├── Announcement      ← FR-09 Announcement Setup (feed + optional push)
│   ├── Products          ← catalog On/Off control panel (see `23`)
│   └── Devices           ← NFR §6 remote wipe
└── Audit
```

| Choice | Why |
|--------|-----|
| **Notification ≠ Announcement composers** | FR-08 = rules; FR-09 = messages |
| **Notification ≠ header bell** | Bell = inbox; Management = setup |
| **Optional push on Announcement** | Covers FR-09 “notification announcement with URL + Image” without stealing FR-08 |
| **Products = availability gate** | Core owns product master; web toggles On/Off for mobile Sell |

---

## 3. Who does what

| Surface | Notification (FR-08) | Announcement (FR-09) | Inbox bell |
|---------|----------------------|----------------------|------------|
| **Web authorized** | Enable rules · lead time · audience | Publish feed · optional push | Read own alerts |
| **Mobile** | Receives auto alerts | Read-only feed · may get push | Same inbox |

---

## 4. Routing

| Path | Screen |
|------|--------|
| `/management/notifications` | FR-08 Notification setup |
| `/management/announcements` | FR-09 Announcement setup |
| `/management/products` | Product catalog On/Off (see `23`) |
| `/notifications` | Personal inbox (header bell) |

---

## 5. Acceptance

- [x] Management children include Notification + Announcement + Products  
- [x] FR-08 page = rules (not duplicate announce form)  
- [x] FR-09 page = feed setup + optional push  
- [x] Products page = On/Off control panel (`23`)  
- [x] Clarity doc `22` published  
