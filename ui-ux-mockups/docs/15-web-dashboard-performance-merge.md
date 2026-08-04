# Merge intent → Dashboard group (superseded navigation)

> **Nav pattern update:** see `18-web-dashboard-team-performance.md`.  
> Overview and Team Performance are now **sidebar children** under Dashboard ▾ (like Management).  
> Shared weighting + hierarchy still apply via session context.

## Original problem
Two sidebar items for the same job: **see how the book is doing**. Managers jump Dashboard ↔ Performance and lose filter/weighting context.

## Kept from the merge
| Rule | Why |
|------|-----|
| Shared weighting toggle | Table “Wtd Freelance FYP” matches Overview mode |
| Shared hierarchy filters | Charts + table answer the same slice |
| Export on each child header | Excel for the filtered view (mock) |
| No top-level Performance item | Lives under Dashboard → Team Performance |
| `/performance` → `/dashboard/team-performance` | Bookmarks don’t 404 |

## Changed
| Before (doc 15) | After (doc 18) |
|-----------------|----------------|
| One scroll page, jump chips | Two routes under Dashboard group |
| Label “Team line” | **Team Performance** |

---

## Acceptance
- [x] Shared weighting + hierarchy across Overview + Team Performance  
- [x] Performance not a top-level sidebar item  
- [x] `/performance` redirects to Team Performance  
- [x] Dashboard ▾ pattern (see doc 18)  
