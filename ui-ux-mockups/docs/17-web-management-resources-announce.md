# Management nav — Resource · Notification · Announcement (FR-09 / FR-10)

## 1. BRD jobs (source of truth)

### FR-09 — Announcement Management

| Need | Role | Platform |
|------|------|----------|
| **Setup** announcements (compose / publish) | Authorized user | **Web** (+ backend) |
| Announcement system supports **notification announcement** with **URL + Image** | Authorized user | **Mobile** (receive / open) |

### FR-10 — Resource Center and Communication

| Need | Notes |
|------|--------|
| **Resource Library** (Mobile & Web) | Brochures · training · company forms. Mobile **offline-capable**. **All sections configurable from web.** |
| **Company Announcements** | **Read-only** broadcast feed pushed to all users (mobile consume). |
| Integration | Backend / Core content + push pipeline (out of UI mock scope). |

---

## 2. Problem with previous UX

- Management was a **flat page** with in-page tabs (Library | Announcements).  
- FR-09’s **notification announcement** (image + URL push) had no dedicated web surface — it was mixed into “compose announcement”.  
- User expectation: **Management** expands with **↓ / ↑**, revealing three clear children — not buried tabs.

---

## 3. Decision

```
Sidebar
├── Dashboard
├── Tasks
├── Management  ▾ / ▴     ← group only (click label or chevron to expand)
│   ├── Resource          ← FR-10 library config
│   ├── Notification      ← FR-09 notification announcement setup
│   ├── Announcement      ← FR-09 announce setup + FR-10 company broadcast source
│   └── Devices           ← NFR §6 remote data wipe (see `19-web-devices-remote-wipe.md`)
└── Audit
```

| Choice | Why |
|--------|-----|
| **Dropdown group, not top-level sprawl** | Keeps lean primary nav; FR-09/10 + device security stay one Management family. |
| **Chevron up/down** | Affordance for expand/collapse; open when any child route is active. |
| **Separate routes per child** | One job per screen — scan/configure without tab hunting. |
| **Notification ≠ header bell inbox** | Header `/notifications` = FA/manager **inbox**. Management → Notification = **authorized setup** of push/notification announcements (image + URL). |
| **Announcement = compose source** | Web creates company announcements; mobile feed is **read-only** (FR-10). |

---

## 4. Who does what

| Surface | Resource | Notification (setup) | Announcement | Inbox bell |
|---------|----------|----------------------|--------------|------------|
| **Web authorized** | Configure sections · upload docs · offline priority | Define notification announcements (title · image · URL · audience · schedule/send) | Create / publish company announcements | Read own alerts |
| **Mobile** | Browse · cache offline | Receives push → opens image/URL payload | Read-only company feed | Same inbox |

---

## 5. Screen UX

### 5.1 Resource (`/management/resources`) — FR-10

- Left: **Sections** (visible · order · offline default) — web-only config of what mobile shows.  
- Main: **Documents** in selected section (version · offline Priority / On demand / Online only · Live/Draft).  
- Actions: Configure sections · Upload / replace.  
- Honesty: Web configures offline; mobile shows “Offline ready · N cached”.

### 5.2 Notification (`/management/notifications`) — FR-09 notification announcement

**Job:** Push a **notification announcement** that carries **image + URL** to mobile users.

Composer fields:

1. Title *  
2. Body / short message  
3. Image * (required for this type)  
4. URL * (tap target on mobile)  
5. Audience (All FAs / role / district)  
6. Send now · Schedule · Save draft  

History: Title · Audience · Status (Sent / Scheduled / Draft) · When.

**Don’t confuse with:** Header Notifications page (consume). Deep link from a sent item → mobile opens image + URL (mock: history row).

### 5.3 Announcement (`/management/announcements`) — FR-09 setup + FR-10 company feed source

**Job:** Company broadcast **feed** content (richer / longer-lived than a push toast).

Composer: Title · Image · URL · Audience · Save draft · Publish (existing FR-09 pattern).

History: Live / Draft / Expired — what appears in mobile **read-only** Announcements feed.

**Split from Notification:**

| | Notification announcement | Company Announcement |
|--|---------------------------|----------------------|
| Feel | Push / alert · time-sensitive | Feed card · browse later |
| Must have | Image + URL (FR-09) | Image + URL supported |
| Mobile | Notification tray → open | Announcements screen (read-only) |

Managers can publish **both** when a campaign needs a push **and** a lasting feed card (optional “also send as notification” later — not required in first mock).

---

## 6. Sidebar interaction

1. **Collapsed (default on desktop if not under Management):** show only “Management” + **▾**.  
2. Click row or chevron → expand children; chevron becomes **▴**.  
3. Active child: highlight child; parent stays visually “in group” (soft bg).  
4. Narrow rail (`max-lg`): icon-only parent; expand shows icon children or flyout — prefer expand below with truncated labels.  
5. Navigating to `/management` alone → redirect to `/management/resources` (first child).

---

## 7. Routing

| Path | Screen |
|------|--------|
| `/management` | → `/management/resources` |
| `/management/resources` | Resource Library |
| `/management/notifications` | Notification announcement setup |
| `/management/announcements` | Company Announcement setup |
| `/announce` | → announcements |
| `/ops` | → resources |
| `/notifications` | **Unchanged** — personal inbox (header bell) |

---

## 8. Acceptance

- [x] Brainstorm updated for FR-09 / FR-10 split  
- [x] Management expands with up/down chevron  
- [x] Children: Resource · Notification · Announcement  
- [x] Three dedicated screens + redirects  
- [x] Header inbox remains separate from Management → Notification  

---

## 9. Out of scope

- Real push gateway / FCM  
- Auto “publish announce → also notify” toggle (nice-to-have)  
- Virus scan / CDN for files  
