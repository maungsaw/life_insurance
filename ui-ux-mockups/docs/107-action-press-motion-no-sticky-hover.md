# 107 — Action press: motion, no sticky hover slab

**Surface:** Global interaction feedback (`AppTheme`)  
**Reference:** Bottom nav / service tiles / list actions / CTA buttons  
**Today:** Long-press can look like a gray/white static slab (hover-ish) on Dark.  
**Date:** 2026-08-18

**Ask:** Keep action feedback visible, but avoid sticky transparent blocks; use motion.

---

## Pick

- Use motion-first ripple globally: `InkSparkle.splashFactory`.
- Keep press feedback via tinted splash (`primary` alpha), not a static fill.
- Remove sticky layer look:
  - `highlightColor = Colors.transparent`
  - `hoverColor = Colors.transparent`
- Keep keyboard/accessibility feedback with a soft `focusColor`.

## Why this works

- Ripple still shows touch happened.
- No persistent rectangular “hover” panel when pressing longer.
- Applies consistently across `InkWell`, `IconButton`, `TextButton`, list rows, nav items.

## Test

- Long-press any action (nav item, service tile, policy row, CTA): no slab stays behind.
- Tap still shows motion ripple and feels responsive.
