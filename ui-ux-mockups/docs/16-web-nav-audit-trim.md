# Web IA trim — lean manager portal

## Current sidebar

```
Dashboard ▾
  Overview
  Team Performance
Tasks
Management ▾
  Resource · Notification · Announcement · Devices
Audit
```

| Keep | Owns |
|------|------|
| **Dashboard** ▾ | **Overview** (5.2.1) · **Team Performance** (FA table) — see `18` |
| **Tasks** | Work queue · recruitment follow-ups · app correction follow-ups |
| **Management** ▾ | **Resource** · **Notification** · **Announcement** · **Devices** (NFR §6 remote wipe) — see `17` / `19` |
| **Audit** | Agent directory + change log (FR-12) |

## Removed from nav

| Module | Redirect | Where the job goes now |
|--------|----------|------------------------|
| ~~Recruitment~~ | `/recruit` → `/tasks` | Tasks (type: Recruitment) · Audit status |
| ~~Announcements~~ (standalone) | `/announce` → `/management/announcements` | Nested under **Management** |
| ~~Operations~~ | `/ops` → `/management/resources` | Management → Resource |
| ~~CRM~~ | `/crm` → `/dashboard` | Field CRM stays on **mobile** |
| ~~Policies / Sales~~ | `/policies` → `/dashboard` | Sell / e-App stays on **mobile** |
| ~~Performance~~ | `/performance` → `/dashboard/team-performance` | Under Dashboard → Team Performance |
| ~~Agents / Audit~~ (label) | `/agents` → `/audit` | Renamed **Audit** |

See also: `17-web-management-resources-announce.md` for Library + Announcements UX.

## Why drop CRM + Policies on web

- Web portal audience here is **manager oversight**, not FA field selling.  
- Lead → Client → e-App depth already lives on the **mobile** Field Momentum mockup.  
- Keeping duplicate CRM / sales spine on web bloated the sidebar without a distinct manager job.  
- Dashboard already surfaces new policies, APE, and team flags.

### Notification deep links (after trim)

| Type | Goes to |
|------|---------|
| Task | `/tasks` |
| App correction | `/tasks` |
| Premium due | `/dashboard/overview` |
| News | `/management/announcements` |
| System / audit | `/audit` or `/dashboard/team-performance` |

## Acceptance

- [x] Sidebar: Dashboard · Tasks · Management · Audit  
- [x] CRM / Policies / Ops / Recruit / standalone Announce removed from surface  
- [x] Old paths redirect  
- [x] Notification links don’t point at removed modules  
