# Web header chrome — Notifications + Profile menu

**Parity with mobile:** Bell for interrupt inbox · identity for account actions. On web, identity opens a **menu** (not a full profile page by default).

---

## 1. Header layout (right cluster)

```
[ Logo · Agency ]                    [ 🔔 badge ]  [ Name / role ]  [ Avatar ▾ ]
                                              │                         │
                                              └─ /notifications          └─ menu
```

| Control | Behavior |
|---------|----------|
| **Bell** | Goes to Notifications inbox · badge = unread (cap `9+`) |
| **Avatar / name** | Opens profile menu (click outside / Esc closes) |
| **Sign out** | Inside menu only · **danger** styling · confirms mental “destructive” |

**Why Sign out is not a header button**
- Reduces accidental logout while scanning KPIs  
- Groups account actions in one place  
- Danger color reserved for leave-session — not competing with primary steel CTAs  

---

## 2. Profile menu IA

| Item | Tone | Action |
|------|------|--------|
| Profile / account | default | Placeholder → future profile settings |
| Language ENG / MM | default | Placeholder toggle |
| Divider | — | — |
| **Sign out** | **danger** (text + hover soft red) | `logout()` → `/login` |

Optional later: Change password, Help — still above Sign out.

---

## 3. Notifications (web)

Same mental model as mobile FR-08, denser for desk:

1. `PageHeader` — Notifications · Mark all read  
2. `SegmentedControl` / chip banner — All · Tasks · Premium · Apps · News · System  
3. List/table hybrid — title · meta · time · status pill · click → deep link  

| Type | Deep link |
|------|-----------|
| Task assigned/updated | `/tasks` |
| Premium due | `/dashboard/overview` |
| App correction | `/tasks` |
| News / announcement | `/management/announcements` |
| System / audit | `/dashboard/team-performance` or `/audit` |

**Manager nuance:** Web users may see team-scoped alerts (below-target FA, recruitment overdue) — still filtered by type chips.

**Don’t:** Bury notifications under a removed module; badge on header is the cue.

---

## 4. Acceptance

- [x] Header bell with unread badge → Notifications page  
- [x] Notifications filters + deep links (mock)  
- [x] Profile menu (avatar)  
- [x] Sign out only in menu · danger color  
- [x] Brainstorm documented  
