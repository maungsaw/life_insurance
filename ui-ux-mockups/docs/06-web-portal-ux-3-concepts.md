# Web Portal UI/UX — Three Concept Directions

**BRD refs:** FR-02.4 Executive Oversight · FR-07 task admin · FR-08/09 notification & announcement setup · FR-10 resource config · FR-12 agent data change · Proposed Solution modules

---

## 1. Portal jobs (who / what)

| Role | Primary portal jobs |
|------|---------------------|
| Manager (DM-level) | District proposals, hierarchy filters, FA line production, red flags, export |
| FTE / executive | Multi-district drill-down, K1/K2 persistency, portfolio underperformers, export |
| Manager / Alliance | Recruitment tasks Add/Move/Delete + onboarding status pipeline |
| Ops / Admin | Announcement (image+URL), notification rules, resource sections, agent data + audit |

**IA (shared across concepts)**

1. **Overview** — KPIs, proposal pulse, red-flag strip  
2. **Performance** — filters + FA table (+ persistency for FTE) + Export Excel  
3. **Recruitment** — dynamic agent statuses (Screening → … → Final Contracted / Rejected)  
4. **Operations** — Tasks admin · Announcements · Notification setup · Resources config  
5. **Agents / Audit** — approved agent data, pending changes, audit trail  

---

## 2. Concept A — Field Momentum (Web)

**Metaphor:** Sales war-room for coaches  
**Visual:** Emerald/amber, rounded cards, bold actual-vs-target  
**Patterns**
- Overview: amber “Red flag” chips that jump to filtered Performance  
- Performance: sticky filter bar (Region → District → SAM → AM → FA), green/amber variance  
- Recruitment: kanban with hot counts  
- Operations: large Create Task / Publish Announcement buttons  
- Audit: simple timeline, not legalistic  

**Best for:** Agency managers who still think like sellers  

---

## 3. Concept B — Trust & Clarity (Web)

**Metaphor:** Institutional oversight desk  
**Visual:** Navy/gold, airy tables, explanatory filter labels  
**Patterns**
- Overview: calm KPI band + “What needs attention” guided list  
- Performance: clear column defs, persistency with grace-period note  
- Recruitment: status board with department ownership hints (Alliance / L&D)  
- Operations: form-first announcement builder (image preview + URL)  
- Audit: previous → new value comparison, who/when emphasis  

**Best for:** Compliance-friendly default / mixed HOA audience  

---

## 4. Concept C — Command Center (Web)

**Metaphor:** Control room / trading desk  
**Visual:** Dark HUD, dense grids, signal colors  
**Patterns**
- Overview: live proposal ticker + heat map of under-target nodes  
- Performance: compact grid, sparklines, one-click Export  
- Recruitment: funnel metrics + status lanes  
- Operations: rule editor feel for notifications; task bulk actions  
- Audit: immutable log table, filter by actor/date/field  

**Best for:** DM/ADM/SADM power users  

---

## 5. Cross-cutting UX rules (all concepts)

1. Hierarchy filter always visible before heavy tables  
2. Export Excel is first-class (not buried)  
3. Red flag = below configured % of monthly FYP target  
4. Recruitment statuses are **dynamic** (configurable), mock shows BRD set  
5. Announcement requires image + URL fields  
6. Agent data shows **Approved** vs **Pending change** clearly  
7. Audit: action · previous · new · user · timestamp  
8. Role-based: user only sees permitted portfolio slice  

---

## 6. Mock coverage in this pack

Each concept’s HTML portal now switches across Overview · Performance · Recruitment · Operations · Audit with concept-specific styling.
