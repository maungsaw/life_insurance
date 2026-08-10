# KBZ LIFE Agency Sales Digital Platform — Web Portal

React management portal mock — Vite · React · TypeScript · **Tailwind CSS** · shared UI components.

Branding: official logo + product name (see `../ui-ux-mockups/docs/29-web-portal-branding.md`).

## Palette

`#00A6FB` · `#0582CA` · `#006494` · `#003554`

## Run

```bash
cd agent-web-portal
npm install
npm run dev
```

## Stack

| Piece | Choice |
|-------|--------|
| Styling | Tailwind v4 (`@tailwindcss/vite`) |
| Icons | `lucide-react` |
| Class merge | `clsx` + `tailwind-merge` (`cn`) |
| Charts | Chart.js + react-chartjs-2 |
| Routing | react-router-dom |

## Structure

```
src/
  components/ui/   ← Button, Card, Field, Pill, PageHeader, …
  layout/          ← AppShell, AuthLayout
  pages/           ← Overview, Team Performance, Tasks, Management, Audit, …
  lib/cn.ts
```

UX brainstorm: `../ui-ux-mockups/docs/12-web-portal-tailwind-ux.md`
