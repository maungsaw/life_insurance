# My draft quotes — UX (separate from Product list)

**Canvas:** `draft-quotes-ux-brainstorm.canvas.tsx`  
**Screen:** `products.html` · FR-04.4

## Problem
Full draft list under the product grid mixes “browse products” with “resume drafts”. Not a filter tab — needs an icon-led entry and a clear “exists” signal.

## Goals
- Product grid = catalog only  
- Drafts = secondary · icon + badge when count &gt; 0  
- No bottom-nav item · no All/Saving chip  

## Options
| ID | Pattern |
|---|---|
| **A (recommend)** | App-bar draft icon + badge → sheet (list · 2/5 · Calculator) |
| **B** | One compact row under filters → same sheet |
| **C** | Floating “Drafts · 2” chip above nav |
| **D** | Icon → dedicated drafts screen |

## Empty
Muted icon / no badge · or hide until first draft. Move 30-day validity note into the drafts sheet.

## Status
**A shipped** on `products.html` — app-bar notebook icon + badge → drafts hub sheet; product grid catalog-only.
