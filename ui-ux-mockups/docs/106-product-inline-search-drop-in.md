# 106 — Product search drops in under header

**Surface:** Product tab header (`product_hub.dart`)  
**Reference:** Inline search (`105`)  
**Today:** Search mode replaced the whole header row.  
**Date:** 2026-08-18

**Ask:** Search icon tap => search box “drops down” and starts filtering.

---

## Pick

- Keep `Product` title + top actions visible.
- Search icon toggles to close icon.
- Field appears **under** the header row with `AnimatedSize`.
- Typing filters same-page cards.
- Close clears query and hides the field.
