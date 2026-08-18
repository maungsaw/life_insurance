import { useMemo, useState } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import { Button, Card, DataTable, EmptyState, Input, PageHeader, Pill, Select, Td } from '@/components/ui'
import { useAccess } from '@/data/AccessContext'
import { activeRoles, roleName } from '@/data/hqAccess'
import type { PersonStatus } from '@/data/hqBook'

export function UsersPage() {
  const { people, roles } = useAccess()
  const [params] = useSearchParams()
  const roleFromUrl = params.get('role') ?? 'all'
  const [q, setQ] = useState('')
  const [role, setRole] = useState(roleFromUrl)

  const live = activeRoles(roles)
  const rows = useMemo(() => {
    const needle = q.trim().toLowerCase()
    return people.filter((p) => {
      if (role !== 'all' && p.roleId !== role) return false
      if (!needle) return true
      return (
        p.name.toLowerCase().includes(needle) ||
        p.code.toLowerCase().includes(needle) ||
        p.mobile.includes(needle)
      )
    })
  }, [people, q, role])

  return (
    <div>
      <PageHeader
        title="People"
        subtitle="Who can sign in · role from the catalog · CORE-unknown stays on Audit Application List"
        actions={
          <div className="flex gap-2">
            <Link to="/users/people/new">
              <Button type="button">+ Add person</Button>
            </Link>
            <Link to="/users/roles">
              <Button variant="secondary" type="button">
                Roles
              </Button>
            </Link>
          </div>
        }
      />

      <div className="mb-3 flex flex-wrap gap-2">
        <Input className="max-w-xs" value={q} onChange={(e) => setQ(e.target.value)} placeholder="Name, code, mobile…" />
        <Select className="max-w-[200px]" value={role} onChange={(e) => setRole(e.target.value)}>
          <option value="all">All roles</option>
          {live.map((r) => (
            <option key={r.id} value={r.id}>
              {r.name}
            </option>
          ))}
        </Select>
      </div>

      <Card>
        {rows.length === 0 ? (
          <EmptyState title="No people in this filter" />
        ) : (
          <DataTable headers={['Code', 'Name', 'Role', 'Channel', 'Status', 'District', 'Last login', '']}>
            {rows.map((p) => (
              <tr key={p.id}>
                <Td className="font-bold">{p.code}</Td>
                <Td>
                  <Link to={`/users/${p.id}`} className="font-bold text-steel">
                    {p.name}
                  </Link>
                </Td>
                <Td>{roleName(roles, p.roleId)}</Td>
                <Td className="text-xs text-muted">{p.channel}</Td>
                <Td>
                  <Pill tone={personTone(p.status)}>{p.status}</Pill>
                </Td>
                <Td className="text-muted">{p.district}</Td>
                <Td className="text-xs text-muted">{p.lastLogin}</Td>
                <Td>
                  {p.devices > 0 ? (
                    <Link to="/management/devices" className="text-xs font-bold text-steel">
                      {p.devices} device{p.devices === 1 ? '' : 's'}
                    </Link>
                  ) : (
                    <span className="text-xs text-muted">—</span>
                  )}
                </Td>
              </tr>
            ))}
          </DataTable>
        )}
      </Card>
    </div>
  )
}

function personTone(s: PersonStatus) {
  if (s === 'Active') return 'ok' as const
  if (s === 'Pending invite') return 'warn' as const
  return 'danger' as const
}
