# 49 — Home bell → Notification inbox (wireframe)

**Source:** `Wireframe/Notification.png` (list + Universal Life detail)  
**Entry:** Home header bell (`AppHomeHeader.onNotifTap`) · also Policy Renewal card  
**BRD:** FR-08 *consume* inbox · FR-09 product/announce detail  
**Not:** Web Notification **Setup** (`22`)  
**Flutter today:** Bell → stub dialog only. No `/notifications` route.  
**Related:** `11` · `34` day grouping · `46` header · Huawei FCM hang (`main.dart`)  
**Date:** 2026-08-13

**Ask:** Tapping the dashboard bell must open a real inbox that matches the PNG, then a detail screen — without blocking Home on devices with no Play Services.

---

## 1. Job

Bell = **my inbox** (alerts already “delivered”).  
Not rule setup. Not a tab on the pill nav.

```
Home (bell + unread badge)
  └─ push /notifications          ← full screen, no pill
        ├─ tap Policy Renewal     → Policy / renewal stub (or policy detail later)
        ├─ tap New Product        → Product info page (Universal Life artboard)
        └─ tap Claim Status       → Claim stub
```

Back on list → Home (shell + pill still underneath).

---

## 2. List screen (PNG)

| Piece | Spec |
|-------|------|
| AppBar | Back · title **Notification** |
| Groups | **Today** · **Yesterday** · **dd-MMM-yyyy** (e.g. 20-Sep-2024) (`94`) |
| Row | Pale-blue circle + bell · **title** · relative time (`2 hr` · `1d`) · 2-line body |
| Unread | Slightly stronger title weight; optional unread dot. Badge on Home = unread count (cap `9+`) |
| Empty | “No notifications yet” |
| Pull-to-refresh | Prototype no-op |

**Doc `11` chips (All · Tasks · Premium…):** PNG has **no chips**. Prototype = **day groups only**. Chips = P1.

**Mark all read:** not on PNG. Skip P0; optional AppBar action P1.

---

## 3. Row types (mock)

| Title | Body cue | Time | Opens |
|-------|----------|------|--------|
| Policy Renewal | Policy no **23471239074138** expiring… | `2 hr` | Renewal / policy stub |
| New Product Launching | New product available… | `5 hr` | **Universal Life** detail (right PNG) |
| Claim Status Update | Claim update copy | `1d` | Claim stub |

Reuse Home renewal copy so bell and Home banner tell the same story.

---

## 4. Detail screens

### A — Product / announce (PNG right)

Header still **Notification** + back.  
Body: product name · short pitch · illustration placeholder · **Who should take** · **Why buy** (blue ticks).  
CTA later: Get quote → Product hub. P0 = scroll + back.

### B — Operational (renewal / claim / task)

Same chrome. Short title + body + **OK / See policy** stub. Don’t fake a full policy module.

**Don’t** open a browser. **Don’t** require FCM for in-app list.

---

## 5. Prototype data (no API, no FCM)

Static list in `NotificationMockData` (same pattern as `HomeMockData`).

| Rule | Why |
|------|-----|
| Any 6–8 rows across 3 day buckets | Demo scroll + grouping |
| Huawei / no GMS | Inbox still works; push is optional later |
| Tap marks read locally (session) | Badge can drop |
| `context.push(AppRoute.notifications)` from Home | Keeps `LifeInsurancePage` under the stack |

---

## 6. Flutter map (when implementing)

| Piece | Where |
|-------|--------|
| Route | `AppRoute.notifications` + `notifications/:id` **or** extra args |
| Pages | `lib/features/notification/presentation/pages/` |
| Row widget | `AppNotificationTile` (icon circle + title + time + body) — DRY with Policy Renewal card later if needed |
| Home | `onNotifTap` → `context.push` (need `GoRouter` on Dashboard) |
| Renewal banner | Same route **or** open matching item — prefer **inbox**, not a second UI |

Hide pill: this is a **pushed** route, not a shell tab — automatic.

---

## 7. Badge

Home bell `hasUnread` = mock `unreadCount > 0`.  
After opening list (or mark read), session flag can clear badge. P0: always show badge until first visit this session.

---

## 8. What not to do

- Don’t wait on FCM `getToken` to show the list  
- Don’t put inbox as a 5th bottom tab  
- Don’t build web FR-08 setup on mobile  
- Don’t mix Announcement **feed** (FR-09/10) as a separate tab this pass — product-launch row is enough  
- Don’t deep-link to missing Product Info module except the Universal Life **mock page**

---

## 9. Build order

1. Mock model + `/notifications` list (groups + tiles).  
2. Wire Home bell (+ optional renewal card → same list or that item).  
3. Detail: product page from PNG; others = simple stub.  
4. Unread badge tied to mock.  

---

## 10. Acceptance

- [x] Brainstorm documented (this file)  
- [x] Bell → Notification list (Today / Yesterday / date)  
- [x] Row layout matches PNG (bell circle · title · time · body)  
- [x] Product row → Universal Life-style detail  
- [x] Back returns to Home; pill nav not on inbox  
- [x] Works with Firebase skipped (no GMS) — mock only  

---

## 11. Related

`11` · `22` · `34` · `46` · `Wireframe/Notification.png`  
