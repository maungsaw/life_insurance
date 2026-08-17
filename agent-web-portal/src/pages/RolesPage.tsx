import { useState } from 'react'
import { Link } from 'react-router-dom'
import { Button, Card, PageHeader } from '@/components/ui'
import { PERM_COLS, ROLE_PACKS, type OrgRole, type PermKey } from '@/data/hqBook'
import { cn } from '@/lib/cn'

const ROLES: OrgRole[] = ['FA', 'TL', 'DM', 'HOA', 'Super Admin']

export function RolesPage() {
  const [packs, setPacks] = useState(() => structuredClone(ROLE_PACKS))
  const [saved, setSaved] = useState(false)

  const toggle = (role: OrgRole, key: PermKey) => {
    setPacks((prev) => ({
      ...prev,
      [role]: { ...prev[role], [key]: !prev[role][key] },
    }))
  }

  return (
    <div>
      <PageHeader
        title="Roles & permissions"
        subtitle="Packs of caps · not ten dashboards · Super Admin has no sell requirement"
        actions={
          <div className="flex gap-2">
            <Link to="/users/people">
              <Button variant="secondary" type="button">
                People
              </Button>
            </Link>
            <Button
              variant="secondary"
              type="button"
              onClick={() => {
                setPacks(structuredClone(ROLE_PACKS))
                setSaved(false)
              }}
            >
              Reset to BRD defaults
            </Button>
            <Button
              type="button"
              onClick={() => {
                setSaved(true)
                setTimeout(() => setSaved(false), 2500)
              }}
            >
              Save packs
            </Button>
          </div>
        }
      />

      <p className="mb-3 text-sm text-muted">
        Changing a pack updates menus on the <b className="text-deep">next session</b>. Header View as remains a
        demo switcher. Do not add payout or policy-edit caps.
      </p>

      <Card className="overflow-auto">
        <table className="w-full min-w-[720px] border-collapse text-center text-xs">
          <thead>
            <tr>
              <th className="sticky left-0 bg-card px-2 py-2 text-left font-extrabold text-muted">Role</th>
              {PERM_COLS.map((c) => (
                <th key={c.key} className="px-1 py-2 font-extrabold text-muted">
                  {c.label}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {ROLES.map((role) => (
              <tr key={role} className="border-t border-line">
                <td className="sticky left-0 bg-card px-2 py-2 text-left font-extrabold text-deep">{role}</td>
                {PERM_COLS.map((c) => {
                  const on = packs[role][c.key]
                  return (
                    <td key={c.key} className="px-1 py-1.5">
                      <button
                        type="button"
                        title={`${role} · ${c.label}`}
                        onClick={() => toggle(role, c.key)}
                        className={cn(
                          'inline-grid size-7 place-items-center rounded-lg border text-[11px] font-extrabold',
                          on
                            ? 'border-ok bg-emerald-50 text-ok'
                            : 'border-line bg-soft text-muted',
                        )}
                      >
                        {on ? '●' : '·'}
                      </button>
                    </td>
                  )
                })}
              </tr>
            ))}
          </tbody>
        </table>
      </Card>
      {saved ? <p className="mt-3 text-xs font-semibold text-ok">Packs saved (mock session).</p> : null}
    </div>
  )
}
