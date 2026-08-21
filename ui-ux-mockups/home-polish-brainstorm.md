# Home polish — name, mark, KPIs

**Canvas:** `home-polish-brainstorm.canvas.tsx`  
**Screen:** `after-login.html`

## Problems
1. Two names — app bar `Myat Moe Pyae` vs greeting `Mr Chit`
2. Brand mark looks boxed (white tile + square PNG); circle crop cuts geometry
3. FYP looks finished; Policies / Commission / MDRT need equal care

## Decisions
| Topic | Choice |
|---|---|
| Name | One string everywhere: **Myat Moe Pyae** |
| Mark | **Flush squircle** (rounded-2xl, full-bleed, no white pad / no circle) |
| Policies | Sky accent bar + sky chip |
| FYP | Keep mint MoM chip |
| Commission | Soft gold MMK chip + clearer money |
| MDRT | Mint % badge + thicker glow bar |

## Optional later
- Time-based greeting
- Shared `agentName` for role demos
- Mirror flush mark in Flutter `AppHomeHeader`
