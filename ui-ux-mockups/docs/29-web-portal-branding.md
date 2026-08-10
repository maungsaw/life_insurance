# Web portal branding — name + logo

**Surface:** `agent-web-portal/`  
**Align with:** Mobile splash (`27`) · BRD *KBZ LIFE Agency Sales Digital Platform*

---

## 1. Ask

1. Use product name **KBZ LIFE Agency Sales Digital Platform** on web  
2. Use official logo:  
   `https://kbzlife.com/frontend/assets/logo/main-logo.png`  
3. Brainstorm UI/UX so long name + logo don’t break the manager shell

---

## 2. Name hierarchy (don’t put the full string everywhere)

| Layer | Copy | Where |
|-------|------|--------|
| **Legal / product** | KBZ LIFE Agency Sales Digital Platform | `<title>` · login brand · `title` tooltip |
| **Shell short** | Agency Sales | Sidebar subtitle · header beside logo |
| **Channel cue** | Web portal | Optional muted line under short name (auth only) |

**Why:** Full name in a 220px sidebar or sticky header wraps into 3–4 lines and fights nav density. Same rule as mobile splash type scale.

---

## 3. Logo usage

| Surface | Treatment |
|---------|-----------|
| **Auth (login / OTP / forgot)** | Logo image centered/left · replaces “KL” tile |
| **App header** | Logo image (~36px tall) · short name beside |
| **Sidebar** | Logo on dark gradient · white-friendly; compact rail shows logo only |
| **Favicon** | Keep existing for now (remote PNG as favicon is flaky) |

**A11y:** `alt="KBZ LIFE"` (brand); full product name lives in adjacent text / `title`.

**Risk:** Hotlink to kbzlife.com — mock OK; production should host a local asset if CDN blocks hotlinking.

---

## 4. Layout picks

### Auth card
```
[ logo img ]
KBZ LIFE Agency Sales
Digital Platform          ← 2-line product name
Sign in                   ← page job (or keep as LoginPage title)
subtitle…
```
**Pick:** Logo + full product name as brand block; page title can stay action-led (“Sign in”) *or* product name as H1.  
**Decision:** H1 = product name (stakeholder ask) · subtitle = login instruction.

### Shell header
```
[logo]  Agency Sales
```
`title` attribute = full platform name.

### Sidebar
```
[logo]
Agency Sales
Digital Platform   ← 2 lines · 11–12px · max-lg: logo only
```

---

## 5. Retire

- Text “KL” gradient badge (header + auth)  
- “Agent Portal” / “KBZ LIFE · Agency” as primary labels  

---

## 6. Acceptance

- [x] Brainstorm documented  
- [x] Shared brand constants + logo component  
- [x] Auth + shell + document title updated  
- [ ] Local logo file in `public/` if hotlink fails (later)  

---

## 7. Related

- `27` mobile splash name · `07` unified login · `10` mobile × web split  
