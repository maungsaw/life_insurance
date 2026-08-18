# 109 — Action overlay unify (all buttons)

**Surface:** `AppTheme` button/icon state layers  
**Reference:** `107` + `108`  
**Date:** 2026-08-18

Long-press feedback is now unified across action surfaces:

- `ElevatedButton`, `FilledButton`, `OutlinedButton`, `TextButton`, `IconButton`
- same motion engine: `InkRipple`
- same state-layer policy:
  - pressed: brand tint
  - focused/hovered: softer tint
  - idle: transparent

This removes random gray material overlays and keeps one predictable press language app-wide.
