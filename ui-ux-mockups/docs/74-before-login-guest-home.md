# 74 — Before login · Guest Home (Partner With Us)

**Source:** Stakeholder **Before Login** PNG · `Wireframe/Calculator(Before login).png` · FR-01 · FR-04 · `34` §4.5  
**Flutter today:** Splash → **Guest Home** (`/welcome`) · Login success → FA Home · Logout → Guest Home  
**Related:** `37` `43` auth hub · `44` pill+FAB · `46` logged-in Home · `59` sell spine · `73` My work FAB (different job)  
**Date:** 2026-08-14

**Ask:** Before-login must feel like the PNG and still obey BRD. Brainstorm **everything** needed — including extra UI not on the PNG.

**Rule:** BRD wins *who may act*. PNG wins *guest layout*. Logged-in Home (`46`) stays the agent board after LOGIN.

---

## 1. BRD jobs vs PNG

| BRD | Meaning for guests |
|-----|-------------------|
| **FR-01** | Identity = CORE mobile + password + OTP. No free public signup if mobile not in CORE |
| **FR-04 / quoting** | Premium calc / save quote / e-App = **authorized**. `34` preferred **Option A**: calculator after auth |
| **FR-02 / FR-03 / FR-06 / FR-07** | KPIs, CRM, policies, tasks = agent session |
| **Out of scope** | Client-facing app · commission **payout** · claims admin |
| **PNG** | Marketing Home: Partner banner · 8 services · promos · same pill nav |

**Not a second product.** Guest Home is a **teaser + door**. It must not look like the user already has a book (no “Welcome Mr Chit”, no commission 726k, no Policy 20/10/5, no Team pulse, no unread inbox).

---

## 2. Entry flow (pick)

| Option | Path | Verdict |
|--------|------|---------|
| A · Keep Splash → Login only | PNG unused | ❌ Stakeholder asked for this board |
| **B · Splash → Guest Home** | Banner / gates → Login / Register | ✅ **Pick** |
| C · Login with “Skip” | Easy to miss Partner story | ⚠️ Skip as secondary only |

**Pick B**

```
Splash (~1.2s)
  └─▶ Guest Home          ← Before Login PNG
        ├─ Login or Register (banner · Profile · FAB)
        ├─ Product (browse catalog only)
        ├─ Promos (public)
        └─ Locked tiles → gate sheet → Login / Register
              Login ok ──▶ FA Home (`46`)  [never Guest Home]
```

Logout (`28`) → **Guest Home** (not a blank Login-only stack). Login remains reachable in one tap.

Pending registration HOME stays **Login** (`45`) — not Guest Home, not FA Home.

---

## 3. Guest Home stack (PNG)

```
Header              brand mark (left) · NO greeting · bell without fake unread
Partner banner      “To unlock more opportunities” · Partner With Us · [ Login or Register ]
Our Services        8 tiles, 4×2 (same chrome as logged-in)
Promotion & Campaign  carousel (public copy)
pill nav            Home · Customer · shield FAB · Product · Profile
                    + scroll clearance
```

**Drop vs logged-in Home:** Commission card · Galaxy · Policy trio · Renewal · Team pulse · role chip.

**Copy:** PNG “Easily Claim **Comission**” → app **Commission** (`34` `61`).

---

## 4. What each control does (guest)

### Header

| Control | PNG | Decision |
|---------|-----|----------|
| Brand mark | Yes | Same `AppAssets.brandMark` as FA Home |
| Bell + red dot | Yes | **No red dot** (no FR-08 inbox). Tap → gate “Sign in to see notifications” |
| Greeting / name | No | Don’t invent a guest name |

### Partner banner (required extra vs FA Home)

| Slot | Spec |
|------|------|
| Title | Partner With Us |
| Sub | To unlock more opportunities |
| CTA | **Login or Register** → Login (`43` hub). Register link still on Login |
| Look | Primary gradient card · white pill button · reuse `AppColors.lightPrimary` |

Don’t put password fields on Guest Home.

### Our Services — lock map

PNG tiles ≠ logged-in tiles (Claim vs Task). Guest grid follows **PNG labels**; taps follow **BRD**.

| Tile | Guest tap | After login |
|------|-----------|-------------|
| **Product** | Open Product **catalog** (browse / detail). Quote / e-App gated on those screens | Same catalog, unlocked CTAs |
| **Online** | Public resources stub (or gate if content is agent-only) | Resources |
| **Calculator** | **Gate** (`34` A) · sheet: “Sign in to calculate a premium” | Quote |
| **New Proposal** | Gate | Product / e-App |
| **Commission** | Gate | Commission history |
| **Proposal Status** | Gate | Tracker |
| **CRM** | Gate | Customer tab |
| **Claim** | **Not a claims product.** Gate or info: “Commission and servicing after you sign in.” Don’t build a claim wizard | Logged-in Home keeps **Task Management** (`46`) — Claim is guest-only label |

**Pick for Calculator:** stay **Option A** (gate). Option B (estimate then login-to-save) = P2; `Calculator(Before login).png` documents that later path, not P0.

### Promos

Tappable; if the promo implies claim/wallet → gate. Otherwise info dialog / announce-style stub.

### Bottom nav (guest)

Same **chrome** as logged-in (`44`) so the app feels one product.

| Slot | Guest |
|------|--------|
| **Home** | Guest Home (active) |
| **Customer** | Gate |
| **Product** | Catalog browse (same as Product tile) |
| **Profile** | Gate · or a thin “You’re not signed in” card with Login / Register (better) |
| **Center FAB** | **Not** Quick actions (quote/lead/task). **Login or Register** — same as banner |

Do **not** strip the shield FAB on guest to “match `73`”. `73` is My work page FAB. Guest PNG **includes** the shell FAB; here it is the **auth door**, not Create task.

---

## 5. Extra UI (needed, not all on PNG)

| Extra | Why |
|-------|-----|
| **Gate sheet** | “Sign in to continue” · short why · **Login** · **Register** · Cancel |
| **Resume after login** | P1: return to Product/Calculator. P0: always land FA Home |
| **Profile unsigned** | Empty identity + Login / Register — PNG Profile tab otherwise dead |
| **Session flag** | `PrototypeConfig` / `GuestSession` so shell knows guest vs agent |
| **Back from Login** | `pop` to Guest Home (not Splash) |
| **Register CORE fail** | Existing warning (`40`) · stay guest |
| **Offline** | Guest catalog from bundle; no fake KPIs |
| **Language** | P1 from Profile unsigned or Login |

---

## 6. Gate sheet copy (ENG)

| Place | Copy |
|-------|------|
| Title | Sign in to continue |
| Body (generic) | Partner tools — quotes, customers, and commission — need your agent login. |
| Body (calculator) | Sign in to calculate a premium. |
| Body (bell) | Sign in to see notifications. |
| Primary | Login |
| Secondary | Register |
| Dismiss | Cancel |
| Banner CTA | Login or Register |
| Banner title | Partner With Us |
| Banner sub | To unlock more opportunities |
| Profile unsigned | You’re not signed in |

---

## 7. What not to do

- Don’t show another agent’s commission, policies, or team on Guest Home  
- Don’t put a fake unread badge on the bell  
- Don’t allow e-App / save quote / CRM / tasks / team while guest  
- Don’t open public self-register that skips CORE (`34` `40`)  
- Don’t build a **Claim** module from the guest tile  
- Don’t use guest Home as FA Home after login (swap the body, keep the shell)  
- Don’t remove pill FAB on guest “because `73` removed a FAB”  
- Don’t run biometric unlock on Guest Home (`70` is Login)  

---

## 8. Flutter map (when building)

| Piece | Work |
|-------|------|
| Route | `AppRoute.guestHome` · Splash `go` here instead of Login |
| Page | `GuestHomePage` — banner + services + promos · **reuse** `AppServiceGrid` / `AppPromoCarousel` / `AppHomeHeader` (no name) |
| Shell | Guest uses **no** `LifeInsurancePage` agent tabs **or** a `GuestShell` with same pill, gated tabs |
| Gate | Shared `showAuthGate(context, reason)` → Login / Register |
| Logout | `go(guestHome)` |
| Login success | `go(home)` as today |
| Calculator | Keep behind gate until Option B is scheduled |

**Shell pick:** **GuestShell** (same pill chrome, four destinations + FAB) is closer to the PNG than a header-only page without nav.

---

## 9. Phasing

| Phase | Scope |
|-------|-------|
| **P0** | Splash → Guest Home · Partner banner · lock map · gate sheet · Product browse · Profile unsigned · FAB/nav gates · Logout → guest · no fake bell badge |
| **P1** | Resume destination after login · Language on unsigned Profile · Online = real resources |
| **P2** | Option B guest calculator (`Calculator(Before login).png`) · Login to Save Quote |

---

## 10. Acceptance (brainstorm)

- [x] PNG vs BRD mapped · Guest ≠ FA Home  
- [x] Service lock map · Calculator stays Option A  
- [x] Extra UI listed (gate sheet, unsigned Profile, FAB = auth)  
- [x] Logout / pending / biometric boundaries  
- [x] Flutter Guest Home (await implement)  
- [x] Inventory updated  

---

## 11. Related

Before Login PNG · `Calculator(Before login).png` · FR-01 · FR-04 · `34` §4.5 · `37` `43` `44` `45` `46` `59` `70` `73`
