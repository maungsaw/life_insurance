# Before Login UX Plan (Guest Home)

Source: `15052026 - Agent App Business Requirement Document.pdf`  
Prototype: `KBZ Mobile ProtoType 1/before-login.html`  
Visual base: Partner With Us (screenshot reference)

---

## 1) UX Goal
- Guest ဝင်လာချင်း 5 seconds အတွင်း **Login / browse product** နှစ်ခုထဲက တစ်ခုကို ရွေးနိုင်ရမယ်။
- Fake performance data မပြရ (BRD: dashboard values = API after auth).
- Locked tools မှာ **why locked + Login CTA** ချက်ချင်းပေါ်ရမယ်။
- BRD FR-01 အရ free self-register မရှိ — Register သည် CORE active mobile ရှိမှသာ။

---

## 2) BRD → Guest vs Locked Map

| Screen / Module | BRD | Guest (before login) | After login |
|---|---|---|---|
| Partner / Auth CTA | FR-01 Login, OTP, Forgot Password; Register only if mobile in CORE | **Show** Login or Register | Becomes This month KPIs |
| Product library (read) | FR-04 Product Library | **Open** browse + detail | Same + Save Quote link |
| Premium Calculator | FR-04 Calculator | **Open** estimate only (no Save Quote) | Save Quote → client/lead |
| Online / Resource | FR-10 Resource Library (offline brochures) | **Open** read-only resources | Same + training docs |
| Announcement / Promo | FR-09 / FR-10 Announcements | **Open** carousel (URL + image) | Same + push deep links |
| New Proposal / e-App | FR-05 | **Locked** | Full e-App |
| Proposal Status | FR-05 | **Locked** | Searchable list |
| Commission / Policy / FYP | FR-02 Dashboards | **Locked** (no sample KPIs) | This month card |
| CRM Clients & Leads | FR-03 | **Locked** | Full CRM |
| Task Management | FR-07 | **Locked** (nav / tools) | Calendar + tasks |
| Profile | FR-11 | **Locked** | Profile, language MM/ENG |
| Notifications | FR-08 | Bell → login sheet | Real inbox |
| Customer tab / FAB | FR-03 / FR-05 | → login sheet | Real entry |
| Offline banner | NFR Offline | Optional for cached product/brochure | Client list + leads sync |

Out of scope (do not tease on guest home): group proposal, direct commission payout, client-facing app.

---

## 3) Information Hierarchy (Top → Bottom)
1. **Partner With Us** — single primary CTA (Login or Register)
2. **Available Now** — Product · Calculator · Online
3. **Unlock With Login** — New Proposal · Commission · Proposal Status · CRM
4. **Promotion & Campaign** — announcement carousel (secondary)
5. **Bottom nav** — Home · Customer · FAB · Product · Profile (labels fixed)

---

## 4) Why we removed the old “demo KPI” hero
Old `before-login.html` showed Policies / FYP / Commission as sample numbers.

BRD conflict:
- FR-02: dashboard data (including calculated values) comes from KBZ LIFE APIs after the user is authenticated.
- Showing fake KPIs teaches the wrong mental model and looks like “already logged in.”

Replace with **Partner With Us** (lock icon + one CTA). Real KPIs appear only on after-login home.

---

## 5) Auth microcopy (FR-01 safe)
- Hero: `Login or Register to unlock more features.`
- Primary button: `Login or Register`
- Login sheet note: Register continues only when mobile exists and is **active** in CORE; otherwise route to Application List / Backend Portal handling (per BRD) — do not imply open public signup.
- Prefer not to use “Sign up free” / “Create account now” without CORE check.

Optional A/B later:
- `Login or Register` vs `Unlock agent tools`

---

## 6) Interaction Rules
- Cream page `#F7F3EC`, soft cream cards, **no hard borders**, soft shadow only
- Coolors: Sky `#00A6FB` · Steel `#0582CA` · Baltic `#006494` · Deep `#003554`
- Partner hero: **2-stop linear** Sky → Steel (or Sky → Baltic)
- Locked tiles: muted cream fill + small lock; tap → login sheet (not dead end)
- Available Now: blue under-dot = open without login
- Promo: horizontal carousel + dots + View all
- Tap target ≥ 44px
- Bottom nav never rename / reorder

---

## 7) Guest flows to wire next
1. Home → Product → PA detail → Get a Quote (calculator) — no Buy/submit without login
2. Calculator result → **Login to save quote** (FR-04 Save Quote = authorized)
3. Locked tile / Customer / Profile / FAB → login sheet → `login.html`
4. Promo card → announcement detail (image + URL) or login if action is agent-only
5. Language: MM / ENG switch can live on login or a lightweight guest settings entry (FR-11)

---

## 8) Brainstorm variants (keep same sections)

### A — Partner With Us (recommended · shipped in HTML)
- Screenshot-aligned
- Clearest BRD split: open tools vs locked sales tools
- Best conversion to login without lying about KPIs

### B — Soft teaser strip
- Same layout, but under Partner CTA add one line: `After login: Policy · FYP · Commission`
- No numbers — only labels — still BRD-safe

### C — Promo-first fold (not recommended)
- Carousel above services
- Higher marketing, lower task clarity — use only if campaign season is primary goal

### D — Available Now = Product + Online only
- Calculator behind login (strict FR-04 “Authorized User” reading)
- Safer compliance; worse field demo UX
- Decide with Business Owner before Phase 1 freeze

### E — Single services card + Task Management locked tile
- Add 5th unlock tile: Task Management (FR-07) — may need 2×3 grid
- Aligns with after-login “Our Services” expansion

**Decision for prototype:** ship **Variant A**; keep D as compliance fallback note.

---

## 9) Acceptance checklist (before login)
- [ ] No Policy / FYP / Commission numeric demo on guest home
- [ ] Product + Calculator (+ Online) reachable without session
- [ ] New Proposal, Commission, Proposal Status, CRM → login sheet
- [ ] Register path respects CORE mobile check (FR-01)
- [ ] Announcements support image + URL (FR-09)
- [ ] Bottom nav: Home · Customer · FAB · Product · Profile
- [ ] Dual language ready (copy keys, not hard-locked EN-only)
- [ ] Date/amount formats reserved for later forms: `DD-MMM-YYYY`, 2 decimals + comma

---

## 10) Next iteration
1. Polish `login.html` OTP / Forgot Password to match cream + Coolors
2. Gate `get-quote.html` Buy / Save behind login sheet
3. Align after-login Partner card → This month KPIs (already planned)
4. Confirm with Business Owner: Calculator guest-open vs login-required (Variant A vs D)
