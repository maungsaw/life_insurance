# Guest ↔ Logged-in Continuity + FR-02 Role-Based Dashboards

## 1) Continuity rule (one shell)
Before Login and After Login share the **same page skeleton**:

| Slot | Before Login (Guest) | After Login (FA) |
|---|---|---|
| Header | Logo · bell | Logo · **username + avatar** · bell |
| Hero card | Partner With Us + Login CTA | **This month** KPIs + See more |
| Soft card A | AVAILABLE NOW (green dots) | AVAILABLE NOW (same) |
| Soft card B | UNLOCK WITH LOGIN (+ locks) | **YOUR TOOLS** (unlocked, no locks) |
| Soft card C | Promotion & Campaign | Same grouped promo |
| Bottom nav | Home · Customer · FAB · Product · Profile | Same labels/order |

Visual tokens stay identical: cream `#F7F3EC`, Coolors sky/steel/baltic/deep, soft shadow cards, same hero gradient.

**Mental model:** Login does not change the app “shape” — it only unlocks data and tools.

---

## 2) FR-02 FA Mobile — what home shows

### Home hero (summary)
- Policies (new + active hint)
- FYP MoM %
- Commission `MMK` + 2 decimals
- Road to MDRT mini progress

### See more (detail overlay) — personal only
API-driven fields (frontend renders payloads):
- Policy Count · Initial / Subsequent FYP · APE/AFYP
- Due vs Collected (count, due amount, collected)
- Commission (+ UL additional when present)
- K1 / K2 persistency · Persistency ratios
- Road to MDRT tracker
- Target variance / **Red Flag** badge when `status: RED_FLAG`

### Offline (FR-02)
- Sticky **Offline Mode** banner
- Show last cached dashboard + last-synced timestamp
- Toggle in prototype for QA

### Out of FA home (other roles)
| Role | Platform | Notes |
|---|---|---|
| Leaders Agents | Mobile + Web | Team aggregate, Personal Team / Total Group toggles, drill-down |
| DM / FTE | Web Portal | Proposal stream, line tables, Excel export (RBAC) |

Mobile after-login prototype = **FA personal dashboard** only.

---

## 3) End-to-end user journey
1. Guest home (before-login)  
2. Login / Register (FR-01) → Biometric offer  
3. After-login FA home (FR-02 summary)  
4. See more → full personal metrics  
5. Profile → Biometric On/Off  

---

## 4) Checklist
- [x] Shared cream + Coolors shell
- [x] Hero slot swap Partner → This month
- [x] Available Now / Tools mirror guest Available / Unlock
- [x] Promo grouped card continuity
- [x] Nav labels unchanged
- [x] Offline banner (FR-02)
- [x] See more keeps Policy/FYP/APE/Due/Commission/K1/MDRT detail
- [ ] Leaders Agent team dashboard screen (next)
- [ ] Red Flag badge styling polish on detail rows
- [ ] Dual language keys
- [x] FR-03 Customer tab (Leads / Clients) wired from Home nav
