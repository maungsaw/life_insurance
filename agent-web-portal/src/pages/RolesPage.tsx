import { useMemo, useState } from 'react'
import { Link } from 'react-router-dom'
import { Button, Card, DataTable, EmptyState, Input, PageHeader, Pill, Select, Td } from '@/components/ui'
import { useAccess } from '@/data/AccessContext'
import { activePerms, activeRoles, peopleOnRole, type AccessStatus } from '@/data/hqAccess'
import { cn } from '@/lib/cn'

export function RolesPage() {
  const { roles, perms, people, history, setPackCell, resetSystemPacks, archiveRole, unarchiveRole } = useAccess()
  const [q, setQ] = useState('')
  const [filter, setFilter] = useState<'live' | AccessStatus>('live')
  const [guard, setGuard] = useState('')
  const [saved, setSaved] = useState(false)

  const cols = activePerms(perms)
  const visible = useMemo(() => {
    const needle = q.trim().toLowerCase()
    return roles.filter((r) => {
      const statusOk = filter === 'live' ? r.status === 'active' : r.status === filter
      const textOk = !needle || r.name.toLowerCase().includes(needle) || r.cluster.toLowerCase().includes(needle)
      return statusOk && textOk
    })
  }, [roles, q, filter])

  const matrixRoles = activeRoles(roles)

  return (
    <div>
      <PageHeader
        title="Roles"
        actions={
          <div className="flex flex-wrap gap-2">
            <Link to="/users/permissions">
              <Button variant="secondary" type="button">
                Permissions
              </Button>
            </Link>
            <Button
              variant="secondary"
              type="button"
              onClick={() => {
                resetSystemPacks()
                setSaved(true)
                setTimeout(() => setSaved(false), 2000)
              }}
            >
              Reset BRD packs
            </Button>
            <Link to="/users/roles/new">
              <Button type="button">+ Add role</Button>
            </Link>
          </div>
        }
      />
      {guard ? <p className="mb-3 text-xs font-semibold text-danger">{guard}</p> : null}
      {saved ? <p className="mb-3 text-xs font-semibold text-ok">Packs saved (in this session).</p> : null}

      <div className="mb-3 flex flex-wrap gap-2">
        <Input className="max-w-xs" value={q} onChange={(e) => setQ(e.target.value)} placeholder="Name or cluster…" />
        <Select className="max-w-[160px]" value={filter} onChange={(e) => setFilter(e.target.value as 'live' | AccessStatus)}>
          <option value="live">Active</option>
          <option value="archived">Archived</option>
        </Select>
      </div>

      <Card title="Role catalog" className="mb-3.5">
        {visible.length === 0 ? (
          <EmptyState title="No roles in this filter" />
        ) : (
          <DataTable headers={['Role', 'Cluster', 'People', 'Caps', 'Status', '']}>
            {visible.map((r) => {
              const count = peopleOnRole(people, r.id).length
              const onCaps = cols.filter((c) => r.pack[c.key]).length
              return (
                <tr key={r.id}>
                  <Td>
                    <Link to={`/users/roles/${r.id}`} className="font-bold text-steel hover:underline">
                      {r.name}
                    </Link>
                    {r.system ? <span className="ml-2 text-[10px] font-extrabold text-muted">SYSTEM</span> : null}
                  </Td>
                  <Td className="text-xs text-muted">{r.cluster}</Td>
                  <Td>
                    <Link to={`/users/people?role=${r.id}`} className="text-xs font-bold text-steel">
                      {count}
                    </Link>
                  </Td>
                  <Td className="text-xs text-muted">{onCaps} / {cols.length}</Td>
                  <Td>
                    {r.status === 'active' ? <Pill tone="ok">Active</Pill> : <Pill tone="danger">Archived</Pill>}
                  </Td>
                  <Td>
                    <div className="flex flex-wrap gap-1">
                      <Link to={`/users/roles/${r.id}`}>
                        <Button variant="ghost" size="sm" type="button">
                          Setup
                        </Button>
                      </Link>
                      {r.status === 'active' ? (
                        <Button
                          variant="ghost"
                          size="sm"
                          type="button"
                          className="text-danger"
                          onClick={() => {
                            const res = archiveRole(r.id)
                            setGuard(res.ok ? '' : res.message ?? '')
                          }}
                        >
                          Archive
                        </Button>
                      ) : (
                        <Button variant="secondary" size="sm" type="button" onClick={() => unarchiveRole(r.id)}>
                          Unarchive
                        </Button>
                      )}
                    </div>
                  </Td>
                </tr>
              )
            })}
          </DataTable>
        )}
      </Card>

      <Card title="Permission matrix" className="mb-3.5 overflow-auto">
        <table className="w-full min-w-[720px] border-collapse text-center text-xs">
          <thead>
            <tr>
              <th className="sticky left-0 bg-card px-2 py-2 text-left font-extrabold text-muted">Role</th>
              {cols.map((c) => (
                <th key={c.key} className="px-1 py-2 font-extrabold text-muted">
                  {c.label}
                  {c.kind === 'custom' ? <span className="block text-[9px] font-bold text-sky">alias</span> : null}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {matrixRoles.map((role) => (
              <tr key={role.id} className="border-t border-line">
                <td className="sticky left-0 bg-card px-2 py-2 text-left font-extrabold text-deep">{role.name}</td>
                {cols.map((c) => {
                  const on = Boolean(role.pack[c.key])
                  return (
                    <td key={c.key} className="px-1 py-1.5">
                      <button
                        type="button"
                        title={`${role.name} · ${c.label}`}
                        onClick={() => {
                          setPackCell(role.id, c.key, !on)
                          setSaved(true)
                        }}
                        className={cn(
                          'inline-grid size-7 place-items-center rounded-lg border text-[11px] font-extrabold',
                          on ? 'border-ok bg-emerald-50 text-ok' : 'border-line bg-soft text-muted',
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

      <Card title="Access history">
        <DataTable headers={['When', 'Action', 'Target', 'Reason', 'By']}>
          {history.map((h) => (
            <tr key={h.id}>
              <Td className="text-xs">{h.when}</Td>
              <Td>{h.action}</Td>
              <Td className="font-bold">{h.target}</Td>
              <Td className="text-muted">{h.reason}</Td>
              <Td>{h.by}</Td>
            </tr>
          ))}
        </DataTable>
      </Card>
    </div>
  )
}
