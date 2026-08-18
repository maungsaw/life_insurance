# 110 — Component action feedback consistency

**Surface:** `AppButton` + `AppSelectChip`  
**Reference:** global motion/overlay tuning (`107` · `108` · `109`)  
**Date:** 2026-08-18

Global theme now provides motion-first press feedback.  
This pass makes reusable components explicitly follow the same rule so they stay consistent even when local styles override theme defaults.

## Applied

- `AppButton` (primary/secondary/text):
  - ripple: `InkRipple`
  - overlay: brand-tint pressed/focused/hovered
  - no transparent slab behavior on long-press
- `AppSelectChip`:
  - ripple: `InkRipple`
  - overlay: same state-layer mapping as buttons

## Result

Common action controls now feel uniform across Product, Customer, Team, and filter sheets, with no sticky hover block on long press.
