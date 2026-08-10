# Web Resource · Hide Offline column + FA offline hint

**Surface:** `agent-web-portal` → Management → Resource (`MgmtResourcesPage`)  
**Theme:** Existing Coolors blues (unchanged)  
**Related:** `17` Management Resource · Configure sections Offline default already hidden

---

## 1. Ask

Simplify the documents table for operators:

1. Remove the **Offline** column (Priority / On demand / Online only pills).
2. Remove the card action copy **“N live/draft · FA offline uses Priority first”**.

Keep section order / visibility config; do not introduce a new red/PNG theme.

---

## 2. Why

| Before | Problem |
|--------|---------|
| Offline column on every doc row | Premature / noisy for current FR-10 scope; operators care about title · file · version · live status |
| “FA offline uses Priority first” | Jargon · mobile cache policy not ready to expose on web list |
| Offline default on Configure sections | Already hidden earlier — same product decision |

**Job of this page now:** curate library sections + publish documents (Live / Draft). Offline prefetch policy = later / backend seed, not a first-class UI column.

---

## 3. Decision

| Element | Action |
|---------|--------|
| Documents table **Offline** column | **Hide** (commented — restore when product needs it) |
| Card action “live/draft · FA offline…” | **Hide** |
| Upload **Offline priority** field | **Hide** (same pass — avoid orphan control) |
| Sections helper “Offline default seeds…” | **Hide** |
| Page subtitle “…mobile offline” | Softened (library focus only) |
| Seed data `offline` / `offlineDefault` | **Keep** in model so restore is one uncomment |

Table headers after change:

`Title · File · Version · Status · Updated`

---

## 4. What stays

- Sections list + Configure sections (Order · Name · Visible · Actions)
- Upload document (Title · Section · File · Status · Audience)
- Coolors blues · existing Card / DataTable / Pill patterns

---

## 5. Acceptance

- [x] Offline column not shown on Resource documents table  
- [x] “live/draft · FA offline uses Priority first” removed from UI  
- [x] Related Offline priority upload field + helper copy aligned  
- [x] Brainstorm documented  
- [ ] Re-enable Offline column when mobile cache policy ships  

---

## 6. Related

- `17` Resource nav · `10` mobile × web Resources parity · Configure sections Offline default hide (prior)  
