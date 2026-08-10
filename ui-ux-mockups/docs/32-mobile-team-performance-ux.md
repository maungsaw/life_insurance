# Mobile · Team Performance (Manager + FA detail)

**Surface:** `concept-a-field-momentum`  
**Refs:** Stakeholder mobile team / MDRT mockups  
**Theme:** Existing Coolors blues only (`#00A6FB` · `#0582CA` · `#006494` · `#003554`) — **not** mockup PNG red  
**Align with:** Web Overview Manager / FTE (`31`) · FA Home already exists

---

## 1. Ask

Make mobile **team / manager** experience match the dense stakeholder flows:

- Personal Team vs Total Group  
- Team members list → FA detail  
- Group hierarchy (SAM / AM lines)  
- MDRT tracker (All · Qualified · In Progress)  
- Keep FA personal home separate  

---

## 2. Theme rule

| Use | Don’t |
|-----|--------|
| Coolors sky / steel / baltic / deep | PNG maroon / crimson headers |
| Existing `.seg` · `.pill` · `.kpi` patterns | New red design system |

Accent for rings/bars = **Baltic / Steel** (`--brand` / `--brand-deep`).

---

## 3. Screen map

```
FA Home (s-home)
    └── Manager view → Team Performance hub (s-manager)
            ├── Personal Team (default)
            │     ├── ring + APE/FYP/SFYP/WFYP
            │     ├── Top performers → Team members (s-team-members)
            │     └── MDRT teaser → MDRT tracker (s-mdrt)
            ├── Total Group → Group hierarchy (s-team-group)
            │     └── SAM/AM rows → Team members / FA detail
            ├── Team members (s-team-members)
            │     └── FA row → FA performance (s-fa-perf)
            └── MDRT tracker (s-mdrt)
                  └── FA row → FA performance
```

| Screen | Job |
|--------|-----|
| **s-manager** | Hub · Personal / Total toggle · overall % · metric grid · shortcuts |
| **s-team-members** | Direct reports list · open FA |
| **s-fa-perf** | One FA · achievement · MDRT · simple trend |
| **s-team-group** | Total Group · SAM/AM lines + counts |
| **s-mdrt** | Qualification ring · All / Qualified / In Progress |

**FA Home** stays personal KPIs (not replaced by manager hub).

---

## 4. Personal Team vs Total Group

| Mode | Meaning | Primary CTA |
|------|---------|-------------|
| **Personal Team** | 1st-level direct reports | Team members · MDRT |
| **Total Group** | Full downline hierarchy | Open group list |

Toggle uses existing `.seg` control.

---

## 5. Manager vs “FTE view” on mobile

| Role | Primary landing |
|------|-----------------|
| FA | `s-home` · own MDRT bar |
| Manager / TL | `s-manager` (Personal Team) |
| Individual drill | `s-fa-perf` (any FA including self via profile later) |

No separate bottom-tab “FTE” — FTE-style **individual** screen = FA performance detail.

---

## 6. Acceptance

- [x] Brainstorm documented  
- [x] Team hub + members + FA detail + group + MDRT in Concept A  
- [x] Coolors blues only  
- [x] Jump nav wired  
- [ ] Real charts / Core API (later)  

---

## 7. Related

- `01` IA · web `31` Manager/FTE · `11` notifications  
