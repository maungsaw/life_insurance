# Agent Web Portal — UI/UX + component system brainstorm

**Stack direction:** Vite · React · TypeScript · **Tailwind CSS** · shared UI components · Chart.js · Lucide icons · Coolors palette.

---

## 1. Why Tailwind + components (now)

| Before | After |
|--------|--------|
| One-off CSS per page | Design tokens in `@theme` |
| Duplicated buttons/tables | `Button`, `Card`, `DataTable`, `Pill`, `PageHeader` |
| Hard to keep mobile mock parity | Same Coolors tokens as mobile |
| Slow visual iteration | Utility-first polish with reusable primitives |

**10-year product rule:** managers skim tables for exceptions. Hierarchy filters, density, and clear primary actions beat decorative chrome.

---

## 2. Design tokens (Coolors) — web application map

| Token | Coolors name | Hex | Web surfaces |
|-------|--------------|-----|--------------|
| `sky` | Fresh Sky | `#00A6FB` | Active sidebar item · chart series A · focus rings · selection tint · logo gradient start |
| `steel` | Steel Blue | `#0582CA` | **Primary buttons** · links · segmented “on” · header accents |
| `baltic` | Baltic Blue | `#006494` | Button hover · chart series B · pill default text · secondary brand |
| `deep` | Deep Space | `#003554` | Sidebar base · body ink · headings · avatar fallback |
| `surface` / `soft` | derived | `#F4F8FB` / `#E6F6FF` | Page bg · chip rails · KPI soft panels |
| `ok` / `warn` / `danger` | semantic | green / amber / red | Status only (Active, Pending, Fix) — **never** replace brand blues |

### Usage rules (UX)
1. **One brand ramp** — don’t invent fifth blues; mix with `color-mix` / opacity.  
2. **Primary CTA = steel**, not sky (sky is signal/active; steel is “do the action”).  
3. **Deep for reading**, sky for “you are here”.  
4. **Charts:** FYP = sky, APE/K1 = baltic — matches mobile mock.  
5. **Mobile parity:** same four hex codes as `concept-a-field-momentum` CSS variables.  
6. **Source of truth:** Tailwind `@theme` + `src/lib/colors.ts` for Chart.js.  

### Shell mapping
```
Sidebar: deep → baltic gradient
Active nav: sky fill
Header logo mark: sky → baltic
Primary button: steel → hover baltic
Page wash: soft sky/steel radial on surface
```

---

## 3. Information architecture (unchanged)

```
Auth → Shell
  Dashboard ▾ · Tasks · Management ▾ · Audit
```

| Module | UX job |
|--------|--------|
| Dashboard ▾ | **Overview** · **Team Performance** (shared weighting & hierarchy) — see `18` |
| Tasks | Add/Move/Delete · status · leave appointments & app-correction follow-ups |
| Management ▾ | Resource · Notification · Announcement · Devices (remote wipe · see `19`) |
| Audit | Agent directory + audit log (FR-12) |

*(CRM · Policies removed from web nav. Management UX: `17` · Dashboard UX: `18`.)*

---

## 4. Component library map

| Component | Responsibility |
|-----------|----------------|
| `Button` | primary / secondary / ghost / danger |
| `Input` · `Select` · `Textarea` · `Field` | Form primitives |
| `Card` | Surface container |
| `Pill` | Status chips |
| `PageHeader` | Title + subtitle + actions |
| `SegmentedControl` | Weighting / page tabs |
| `DataTable` | Consistent th/td density |
| `KpiCard` | Dashboard metrics |
| `EmptyState` | Zero results |
| `AppShell` | Sidebar + header (logo left · profile right) |
| `AuthCard` | Login / OTP / Forgot frame |

**Libraries**
- `tailwindcss` + `@tailwindcss/vite`
- `lucide-react` — icons
- `clsx` + `tailwind-merge` — `cn()` helper
- `react-router-dom` — routes
- `chart.js` / `react-chartjs-2` — dashboard charts

---

## 5. UX principles (portal)

1. **One primary action per view** (Export, Add task, Publish).  
2. **Filters above data** — never bury hierarchy.  
3. **Status language shared with mobile** — Pending / In Progress / Completed; Draft / Waiting / Submitted…  
4. **Weighting is a mode, not a math toy** — explain Core owns factors.  
5. **Auth copy stays human** — no “unified login” jargon on screen.  
6. **Sidebar = wayfinding** — active = sky fill on deep rail.  
7. **Tables beat cards** for manager oversight.  
8. **Empty & loading** reserved (mock shows empty when filtered to zero later).

---

## 6. Acceptance

- [x] Tailwind configured with Coolors `@theme`  
- [x] Shared `components/ui` primitives  
- [x] Shell + all routes restyled  
- [x] Charts keep bar + line on Dashboard  
- [x] This brainstorm doc published  
