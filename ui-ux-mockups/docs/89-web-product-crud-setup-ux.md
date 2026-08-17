# 89 — Web HQ · Product CRUD + catalog setup

**Surface:** `agent-web-portal/` · Management → Products  
**Reference:** On/Off (`23` `86`) · FR-04 library (`65`) · mobile catalog (`59`) · Resources (`17` `33`) · hats (`86`)  
**Web today:** Products = **On/Off table + history only**. Copy says “master stays in Core.” No Create / Edit / Archive.  
**Date:** 2026-08-17

**Ask:** Product အပိုင်းမှာ **CRUD** ထည့်မယ်။ **Setup** လည်း ထည့်မယ်။ သက်ဆိုင်ရာအားလုံး ပြည့်အောင် brainstorm။

**Rule:** ဒါက `23` Job B (control) ကို **catalog setup** အဖြစ် ချဲ့တာ။ Job A (Sell · quote · e-App wizard) **web မလုပ်ဘူး** (`86`). Core **pricing / UW rules** ကို HQ form ကနေ မရေးဘူး။

---

## 0. CRUD ဆိုတာ ဒီနေရာမှာ ဘာလဲ

| User said | One job? | Why |
|-----------|----------|-----|
| Product CRUD | **Agency Sales catalog row** | HQ adds / edits / archives what FAs can sell |
| Setup | **Same record · detail** | Copy · line · quote schema pack · docs · availability |
| On/Off (`23`) | **Availability gate** on that row | Not a substitute for Create. Not Delete |

Do **not** invent a second sidebar: “Products” + “Product setup” + “Catalog”.  
Do **not** treat CRUD as actuarial product factory (premium tables, UW, claims).

```
Core product (code + pricing)     ← source of truth (later API)
        │  map
Agency Sales catalog SKU          ← this CRUD
        │  On  →  mobile Sell → Products
        │  Off →  hidden after sync
        └─ setup: copy, schema pack, brochure, channel
```

**Prototype (no Core API):** Create **is** allowed — HQ mocks a catalog SKU so demos aren’t stuck on five hardcoded rows. Production: Create = “map an **existing Core code** into Agency Sales”; cannot invent a Core code HQ-only.

---

## 1. Three jobs, one Products group

```
Management ▾
  Resource
  Notification
  Announcement
  Products                          ← keep one nav item
    list  /management/products
    new   /management/products/new     (dialog or page)
    setup /management/products/:id     (CRUD form)
    (history stays on list + on setup)
  Devices
```

| Job | Screen | Who |
|-----|--------|-----|
| **List + gate** | Catalog table (today) + **Add product** | Admin (`canAdmin`) |
| **Setup** | Record form (identity · sell copy · quote pack · docs · availability) | Admin |
| **Toggle** | Turn on / Turn off (existing dialog) | Admin (FTE read-only P2) |

**Must not:** Manager `canViewBook` lands here. FA `canSell` creates products. FTE edits schema packs unless UAT says otherwise.

---

## 2. Naming lock (easy to mix up)

| Label | Means | Lives |
|-------|--------|-------|
| **Catalog / Products** | Agency Sales SKUs FAs can quote | Management → Products |
| **Core product** | Pricing + code in Core | Not edited on this portal |
| **On / Off** | Sell visibility after FA sync (`23`) | Toggle on list + setup |
| **Archive** | Soft-delete catalog row | Setup · not the Off switch |
| **Quote schema pack** | Which calculator fields mobile shows (`65`) | Setup · pick a **named pack**, don’t paint 40 fields ad-hoc |
| **Resource** | Brochure PDF / image (`17`) | Link from setup; files stay in Resource |
| **e-App / quote in flight** | FR-04/05 instances | Keep working if product turns Off (`23` `87`) |

Off ≠ Archive. Off = “don’t start **new** quotes.” Archive = “remove from catalog UI; code still on old policies.”

---

## 3. CRUD matrix (what HQ can actually do)

### Create

| Can | Cannot |
|-----|--------|
| Add SKU: Core **code *** · name * · line * · tagline · channel Agency Sales | Invent Group Life / entity (`65` OOS) |
| Pick **schema pack** (UL / Term / Health / Travel / Credit / Bundled) | Draw a new pricing formula on the desk |
| Default Off until “Turn on” (safer) **or** create as Off with confirm | Auto-On without audit row |
| Duplicate from existing SKU (P1) | Clone issued policy into a new product |

**Code uniqueness:** `EN` / `UL` / … unique in catalog. Clash → inline error, no silent overwrite.

### Read

List columns (extend today):

| Column | Notes |
|--------|--------|
| Code | Core identity |
| Name · tagline | Sell copy |
| Line | Protection · Saving · Travel · Health · Bundled (`59`) |
| Schema pack | Which calculator |
| Status | On · Off · Archived |
| Last change | Who / when |
| Actions | Setup · Turn on/off |

Search: code · name · line. Filters: All \| On \| Off \| Archived.

### Update (Setup)

Tabs / sections on `/management/products/:id` — **one form**, not ten dashboards:

| Section | Fields | Rule |
|---------|--------|------|
| **Identity** | Code (locked after create) · Name * · Line * · Channel | Code change = new SKU, not rename |
| **Sell copy** | Tagline · About · Who should · Why buy · Coverage bullets · Eligible | Feeds mobile detail (`24` `59`). No quote CTA on web |
| **Quote setup** | Schema pack * · variants · frequencies · terms · default SI / top-up | Packs from `65` — toggle which optional keys are on. **Not** live premium calc |
| **Availability** | On/Off · optional effective-from (P1) · Turn-off reason history | Same dialog as list |
| **Documents** | Link Resource titles (brochure, rate card image) | Upload lives in Resource, not a second file store |
| **Commission map** | Display category label for Report (`85`) | Display-only; no payout |

Save → Audit log: field · previous · new · user · when.

### Delete (Archive)

| Rule | Why |
|------|-----|
| **Soft archive** only | Hard delete breaks policies · quotes · e-Apps · commission grain |
| Block archive if **in-flight** Draft/Submitted e-App or open quotes (warn + force Off first) | `23` in-flight still submit |
| Archived rows hidden from FA forever; HQ filter **Archived** still lists them | Support lookup |
| Unarchive = back to **Off** (must Turn on explicitly) | Don’t surprise the field |

**Must not:** trash icon that drops `UL` while `POL-2026-0814` still exists.

---

## 4. Setup vs On/Off vs Resource vs e-Apps

```
Setup save ──► catalog SKU
Turn Off  ──► FA Sell hides · in-flight e-App stays (`23`)
Archive   ──► HQ-only · still on issued policy product name
Resource  ──► brochure files; Products only **links**
e-Apps    ──► product name/code on row; no wizard (`87`)
Commission Report ──► category grain (`85`) from line / map
CRM / quote ──► mobile only
```

Notification (optional P1): “Product turned off” → FA inbox consume; setup stays Management.

---

## 5. Who sees what

Reuse `86` hats. **No new cap** unless UAT wants FTE catalog edit.

| Hat | List | Setup CRUD | On/Off | Archive |
|-----|------|------------|--------|---------|
| **Manager** | Hidden | — | — | — |
| **FTE** | Hidden (P0) / read P2 | No | No | No |
| **Admin** | Full | Full | Full | Full |

**Must:** Admin default home stays Management (`86`).  
**Must not:** Put Products under Users. Don’t give `canViewBook` write here.

---

## 6. Screen inventory (this pack)

| Route | Screen | P0 |
|-------|--------|-----|
| `/management/products` | Catalog list + On/Off + **Add** + history | Yes |
| `/management/products/new` | Create (or dialog on list) | Yes |
| `/management/products/:id` | Setup (sections above) | Yes |
| Turn off dialog | Keep (`23`) | Yes |
| Archive confirm | Reason * · in-flight warning | Yes |
| Duplicate SKU | Prefill create | P1 |
| Effective-dated On/Off | Schedule | P1 |
| Schema pack editor (new pack) | Custom field builder | **P2** — pick packs only on P0 |
| Live Core code picker | API | Later |
| Mobile Product control CRUD | Phone form | **No** — mobile stays On/Off (`23`) |

---

## 7. Flutter / mock reuse

| Mobile | Web setup writes |
|--------|------------------|
| `CatalogProduct` code · name · line · tagline · about · whoShould · coverage | Same fields on setup |
| `premium_schema.dart` packs | Dropdown of pack ids, not a form-builder |
| Sell list On-only | Status On |
| Product control (`23`) | Same status; **no** create on phone |

Prototype: in-memory list (extend `SEED` on Products page). No Core. Create appears on list immediately; mobile catalog stays Flutter seed until a later shared mock.

---

## 8. Validation & audit (so CRUD doesn’t rot)

- Code: required · unique · short (2–8) · uppercase  
- Name: required  
- Line: required enum  
- Schema pack: required on Create  
- Turn off / Archive: reason * (reuse Campaign pause · Regulatory · Pricing · Other)  
- Sell copy bullets: optional but empty About → warn “FA detail will look thin”  
- Cannot Turn on Archived — Unarchive first  

History table **extends** today’s On/Off log:

| Action |
|--------|
| Created · Updated (section) · Turned on/off · Archived · Unarchived |

---

## 9. What not to do

- Quote calculator · Compare · NRC · Start e-App on Products  
- Hard-delete SKU with policies  
- Merge Resource file upload into Products  
- Per-field Core pricing / stamp fee editor  
- Group Life / multi-product cart (`65`)  
- Ten schema builders = ten dashboards — **named packs** only (`71` spirit)  
- Second nav item “Setup” beside Products  
- Let Off mean Delete  
- Mobile CRUD clone of the desk form  

---

## 10. Suggested ship order (when you say ဟုတ်ကဲ့)

| Slice | What |
|-------|------|
| **P0a** | List: Add · row → Setup · Archive filter · keep On/Off | shipped |
| **P0b** | Create + Setup Identity / Sell copy / schema pack pick / docs link | shipped |
| **P0c** | Archive / Unarchive guards · history actions · unique code | shipped |
| **P1** | Duplicate · effective dates · FTE read · “product off” inbox | Duplicate · effective from · inbox shipped · FTE read later |
| **P2** | Custom schema pack editor · Core code lookup API | later |

---

## 11. Acceptance (brainstorm)

- [x] CRUD = Agency Sales catalog SKU, not Core actuarial factory  
- [x] Setup is the product **record**, not a fifth Management child  
- [x] On/Off stays the sell gate; Archive is soft-delete  
- [x] Schema = pick pack (`65`), not web calculator  
- [x] Resource / e-Apps / in-flight / commission cross-links  
- [x] Hats: Admin write; Manager/FA out  
- [x] Inventory  
- [x] Implement — P0 + P1 shipped 2026-08-17 (`agent-web-portal` Management → Products) 
