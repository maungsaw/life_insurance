# 105 — Product search stays on the same screen

**Surface:** Product tab header/search (`product_hub.dart`)  
**Reference:** Product tab spine (`59`) · Search AppBar polish (`96` · `97`)  
**Today:** Search icon pushes to `ProductSearchPage` even though it shows the same catalog cards.  
**Date:** 2026-08-18

**Ask:** Search icon tap should **not** navigate. Search in the current Product screen.

---

## 0. Pick

- Keep user on `ProductHubPage`.
- Tap search icon => header swaps to inline search pill.
- Query filters the same catalog list immediately.
- Close icon exits search and clears query.

## 1. UX rules

- No route push for search from Product tab.
- While searching, hide line chips (focus on query results).
- Cards/tap behavior stay exactly the same.
- Saved quotes / Tracker icons still available before entering search.

## 2. Test

- Tapping search shows `Search products` field on the same page.
- Typing query filters cards (e.g. `Universal Life` present, `Credit Life` absent).
- Closing search restores `Product` title and chips.
