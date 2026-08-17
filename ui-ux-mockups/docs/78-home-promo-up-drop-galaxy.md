# 78 — Home · drop Galaxy · lift Promotion & Campaign

**Source:** Live FA Home screenshots (2026-08-17) · ask: remove Galaxy Member · show Promotion & Campaign immediately  
**Flutter today:** `DashboardPage` stack = Header → Commission → **Galaxy** → Services → Policy → Renewal → Team? → **Promotion & Campaign** (below fold)  
**Related:** `46` home stack · `48` Galaxy · `36` home mock · `74` guest home  
**Date:** 2026-08-17

**Ask:** Galaxy Member ကိုဖြုတ်ပြီး၊ အောက်က Promotion & Campaign ကို အပေါ်တင်ပါ — scroll မလုပ်ဘဲ တန်းမြင်ချင်သည်။

---

## 1. What the screenshots show

| Layer | Job | Issue |
|-------|-----|--------|
| Header | Identity + notif | Keep |
| Commission | Earnings snapshot (BRD) | Keep first money signal |
| **Galaxy Member** | Club / VIP art | Occupies the best “above Services” slot; not a campaign; no API this phase |
| Our Services | Daily tools | Still above fold after Galaxy |
| Policy + Renewal | Ops KPIs | Mid stack |
| **Promotion & Campaign** | Campaign offers | Buried under Policy / Renewal — needs scroll |

**Core issue:** Galaxy consumes the premium slot for identity art that is not actionable this phase, while campaign cards that *are* meant to be seen sit at the bottom.

---

## 2. Decision

| Change | Rule |
|--------|------|
| **Remove** | `AppGalaxyMemberBanner` from FA Home scroll |
| **Lift** | `Promotion & Campaign` into the slot Galaxy vacated |
| **Keep** | Commission still above promos (money first, campaign second) |
| **Do not** | Put Galaxy into promo carousel · put promo above Commission · delete the widget file yet (unused OK for now) |

Guest Home (`74`) already has no Galaxy and puts promos after Services. This pass is **signed-in Home only** unless we later align Guest promo height/placement.

---

## 3. Placement options

### A — After Commission, before Services (**recommended**)

```
Header
Commission card
★ Promotion & Campaign     ← Galaxy’s old slot
Our Services
Policy · Renewal · Team
[ clearance ]
```

**Why A wins**

- Matches the ask: promo is visible without scrolling past Services/Policy.
- Reuses the visual “banner band” users already expect under Commission (screenshot mental model).
- Does not demote Commission below fold — still the first content card.
- Services remain one short scroll away; tools stay primary after campaign glance.

### B — After Header, before Commission

Promo first, then earnings.

**Reject for P0:** Commission is the FA’s daily money pulse (`34` / `46`). Pushing it down for campaigns feels like marketing-first, agent-second.

### C — Compact single hero card (no carousel header)

One wide campaign under Commission; more campaigns only via “See all”.

**P1 only:** Current `AppPromoCarousel` already works; keep horizontal cards unless stakeholders want a taller hero.

### D — Keep promo at bottom + pin a mini strip

Duplicates the section. **Reject.**

**Decision: A.**

---

## 4. Above-the-fold budget

Galaxy height today ≈ 88–104. Promo block = section title (~22) + carousel (110) ≈ **132**. Slightly taller than Galaxy.

Mitigation so Services still peek on common phone heights:

| Token | Spec |
|-------|------|
| Section title | Keep **Promotion & Campaign** — short, clear |
| Carousel height | **96–100** (was 110) — still readable title + subtitle |
| Card width | ~220 (unchanged) so peek of next card invites swipe |
| Gap under Commission | **14** (same as Galaxy gap) |
| Gap before Services | **18–20** (don’t crush tools) |
| Page indicators | Optional dots under carousel — **P1**; swipe alone is enough for P0 |

If a device still clips Services, that is acceptable: campaign glance + Commission are the new “first screen”; Services remain one flick away.

---

## 5. Section behavior

| Element | Rule |
|---------|------|
| Header title | **Promotion & Campaign** (same copy as bottom) |
| Cards | Existing `HomeMockData.promos` — Claim commission / Unlock discounts, etc. |
| Tap | Keep stub dialog (or route to Commission for earnings promo if already wired) |
| Swipe | Horizontal · bounce · show partial next card |
| Empty | Hide whole section if promo list empty (don’t leave orphan title) |
| Role | Same for FA / leaders who see Home; Team pulse stays **below** Policy |

**Do not** merge promo into Commission card — different jobs (earnings vs campaign).

---

## 6. Galaxy Member aftermath

| Item | Action |
|------|--------|
| Home insert | Delete from `DashboardPage` |
| `AppGalaxyMemberBanner` | Leave in components for now (dead code OK) or remove in same PR if unused elsewhere |
| Asset `galaxy-member` | Keep in assets; no need to delete PNG this pass |
| Doc `48` | Superseded for Home placement — membership may return later under Profile / rewards |

If product later wants Galaxy back: put it **under Profile**, not between Commission and Services again.

---

## 7. Guest Home note

Guest stack today: Partner banner → Services → Promo.

**No change required for P0.** Optional later: move Guest promo under Partner (already high). Do not add Galaxy to Guest.

---

## 8. What not to do

- Don’t put promo **above** Commission on signed-in Home  
- Don’t keep Galaxy **and** top promo (double banner noise)  
- Don’t add a third “News” strip  
- Don’t auto-play carousel with sound / timer that fights scroll  
- Don’t treat promo as auth gate on signed-in Home (Guest already gates commission-like cards)

---

## 9. Flutter map (when implementing)

| Piece | Work |
|-------|------|
| `DashboardPage` | Remove `AppGalaxyMemberBanner` block |
| Same file | Move `AppSectionHeader` + `AppPromoCarousel` to sit right after `AppCommissionCard` |
| `AppPromoCarousel` | Optional height 100 for tighter fold |
| Inventory | Tick shipped when done |
| `48` | Note superseded by `78` for Home |

---

## 10. Phasing

| Phase | Scope |
|-------|-------|
| **P0** | Drop Galaxy · promo after Commission · keep carousel + stubs · optional height trim |
| **P1** | Page dots · “See all campaigns” · deep-link promo → product/commission · Profile Galaxy badge |
| **Out** | Real campaign CMS · push-triggered home reorder · A/B hide Commission |

---

## 11. Acceptance (brainstorm)

- [x] Screenshot problem named (Galaxy up · promo buried)
- [x] Placement A chosen (after Commission · before Services)
- [x] Fold budget + height trim noted
- [x] Galaxy aftermath + Guest note
- [x] Flutter map + phasing
- [x] Flutter Home reorder shipped (P0)
- [x] Inventory updated

---

## 12. Shipped (P0)

| File | What landed |
|------|-------------|
| `dashboard/presentation/pages/index.dart` | `AppGalaxyMemberBanner` block removed · `Promotion & Campaign` header + carousel moved directly under `AppCommissionCard` (14 gap above, 20 below) |
| `components/app_promo_carousel.dart` | Carousel height 110 → **104** — the floor that still fits a 2-line title with a 2-line subtitle |

Order now: Header → Commission → Promotion & Campaign → Our Services → Policy → Renewal → Team pulse. On a 780pt-tall viewport the promo title sits at ~264 and Our Services at ~444, so both are above the fold with no scroll.

`AppGalaxyMemberBanner` and the Galaxy asset stay in the repo unused, ready for a later Profile / rewards placement. Guest Home keeps its own order and simply inherits the shorter carousel.

---

## 13. Related

`46` · `48` · `36` · `34` · `74` · live Home screenshots 2026-08-17
