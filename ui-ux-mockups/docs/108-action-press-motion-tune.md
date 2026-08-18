# 108 — Action press motion tune

**Surface:** Global touch feedback (`AppTheme`)  
**Reference:** `107` motion/no-sticky-hover pass  
**Today:** Motion works, but sparkle + tint can still read strong on some dark surfaces.  
**Date:** 2026-08-18

**Pick:**
- Keep motion ripple, but make it softer:
  - `splashFactory`: `InkRipple` (cleaner than sparkle)
  - `splashColor`: lighter alpha (`0.10` light, `0.16` dark)
- Keep `highlightColor` and `hoverColor` transparent to avoid sticky slabs.

Result: press feedback still obvious, but calmer and more native across button-heavy screens.
