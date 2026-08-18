# 97 — Product Search AppBar · drop the cyan bar

**Surface:** Flutter Product Search (`ProductSearchPage`)  
**Reference:** `ProductSubAppBar` (detail · quote · compare · tracker) · Search inset (`96`) · Dark (`82`)  
**Today:** Search is the **only** Product stack screen with a **cyan** AppBar. Detail / Get A Quote / Compare use `ProductSubAppBar`: `surface` canvas + `onSurface` back/title. User: ရှေ့က screens နဲ့ **တူအောင်** အရောင် ဖြုတ်.  
**Date:** 2026-08-18

**Ask:** AppBar color ဖြုတ် · ရှေ့က Product မျက်နှာပြင်တွေနဲ့ တူအောင်.

**Rule:** Keep back + pill search (`59` §J · `96` insets). Do not paint a second brand bar. Catalog tab search icon still opens this page.

---

## 0. Why cyan looks “other”

`ProductSubAppBar` is surface-on-surface (no stripe). Search was `lightPrimary` so the jump Catalog → Search is a **different chrome family**. That’s the mismatch.

---

## 1. Options

| Option | Idea | Verdict |
|--------|------|---------|
| Keep cyan, only insets (`96`) | Distinct Search | ❌ asked to drop color |
| **Surface AppBar = rest of Product** | Same back treatment as Compare | ✅ **P0** |
| Cyan only on the pill, bar surface | Brand still screams Search | Extra language; skip |

**Pick: surface AppBar.** Insets from `96` stay.

---

## 2. Pill after the bar is no longer cyan

White pill on white/surface **disappears**. So:

| | Light | Dark |
|--|--------|------|
| AppBar / page | `surface` | `surface` |
| Back / typed text | `onSurface` | `onSurface` |
| Pill fill | `mutedFill` | `mutedFill` |
| Pill stroke | `border` | `border` |
| Search / clear icon | brand cyan | brand cyan |
| Hint | `hint` | `hint` |

Focused: 1.6px cyan stroke (same as `AppTextField`).

---

## 3. What not to do

- Don’t leave a cyan strip “just for Search”  
- Don’t flatten the pill into a naked underline (harder to tap)  
- Don’t restyle `ProductSubAppBar` titles in this pass  

---

## 4. Test

- AppBar `backgroundColor` is surface, not `lightPrimary`  
- Hint `Search products` + back still present · 64px insets kept
