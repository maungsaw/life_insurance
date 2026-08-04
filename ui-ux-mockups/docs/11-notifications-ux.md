# Notifications UX (Mobile) — FR-08 / FR-09

**Home chrome**
| Left | Center | Right |
|------|--------|-------|
| Profile avatar → Profile | Greeting + headline | Bell → Notifications (badge = unread count) |

**Why this layout**
- Avatar left = identity / “who I am” (common mobile pattern with greeting)
- Bell right = interrupt channel; thumb reach + badge glanceable
- Don’t hide notifications only under More — FAs miss Fix / due / new task

---

## Notification screen

1. **Header** — title + Mark all read  
2. **Category banner** (horizontal chips) — All · Tasks · Premium · Apps · News  
3. **List** — newest first · unread pill · tap deep-links  

| Type | Example | Deep link |
|------|---------|-----------|
| Task | Assigned / updated / due | Task detail / My work |
| Premium | Due in 7 days · amount | Policy / client |
| Apps | Mark for Correction | e-App step / App tracker |
| News | Announcement image + URL | Announcement detail |

**Rules**
- Badge on Home bell = unread count (cap at 9+)  
- Home premium alert banner can stay as *action strip*; inbox is the full history  
- Announcements appear in News filter and open image + URL detail  
- Empty filter state when chip has no items  
- Push (prod) mirrors same types; in-app list is source of truth when online  

---

## Acceptance

- [x] Home: avatar left · notification icon right with badge  
- [x] Bell opens Notifications screen  
- [x] Category banner filters notification types  
- [x] Rows deep-link to task / correction / policy / announcement  
