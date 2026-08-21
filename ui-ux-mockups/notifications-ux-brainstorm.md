# Notifications — list + detail (wireframe flow · our skin)

**Status:** ✅ Option **A** shipped in `after-login.html` (`#notifications`)  
**Canvas:** `notifications-ux-brainstorm.canvas.tsx`  
**Reference:** `KBZ_UI&UX/Wireframe1/Notification.png`  
**Rule:** Keep wireframe **jobs** (grouped inbox → open detail). Keep **cream · Coolors · soft cards · Phosphor** — do not clone white/blue Material.

---

## Wireframe jobs (keep)

1. **List** — back · title “Notifications” · rows grouped by **Today / Yesterday / date**  
2. **Row** — type icon · title · short body · relative time (`2 hr`)  
3. **Detail** — for promo/product: hero title · short pitch · body · who it’s for · why buy · CTA  
4. Other types deep-link elsewhere (renewal → policy/e-App · claim → claim sheet · status → tracker)

---

## Shipped (Option A)

- Bell → `#notifications` · badge when unread &gt; 0  
- List: Today / Yesterday / date · soft-card rows · unread sky inset + dot  
- Product launch → rich detail (About · Who · Why · View product / Get quote)  
- Renewal → e-App · Claim → claim sheet · UW → tracker · Commission → sheet  
- Empty state · Mark all read · QA: Toggle empty notifs / Mark notifs read (outside frame)  
- Guest: before-login bell still login-gated  
- Profile Notifications settings unchanged (push on/off)

---

## Notification types (prototype set)

| Type | List icon | Tap goes to |
|---|---|---|
| Policy renewal | shield / calendar | Policy detail or Start e-App renewal |
| Claim status | clipboard-check | Claim sheet / status |
| Product launch | megaphone / sparkle | **Rich detail** (wireframe screen 2) |
| App / UW status | file-text | Proposal tracker |
| Commission / incentive | chart | Commission sheet |

Unread: soft sky tint on row · small steel dot. Read: cream card, no dot.

---

## Decision

**A** — after-login `#notifications` + list/detail ✅
