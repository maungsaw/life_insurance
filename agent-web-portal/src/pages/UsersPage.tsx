import { useMemo, useState } from 'react'
import { Link } from 'react-router-dom'
import { Button, Card, DataTable, Dialog, EmptyState, Input, PageHeader, Pill, Select, Td } from '@/components/ui'
import { PEOPLE, type OrgRole, type PersonStatus } from '@/data/hqBook'

export function UsersPage() {
  const [q, setQ] = useState('')
  const [role, setRole] = useState<'all' | OrgRole>('all')
  const [inviteOpen, setInviteOpen] = useState(false)

  const rows = useMemo(() => {
    const needle = q.trim().toLowerCase()
    return PEOPLE.filter((p) => {
      if (role !== 'all' && p.orgRole !== role) return false
      if (!needle) return true
      return (
        p.name.toLowerCase().includes(needle) ||
        p.code.toLowerCase().includes(needle) ||
        p.mobile.includes(needle)
      )
    })
  }, [q, role])

  return (
    <div>
      <PageHeader
        title="People"
        subtitle="Who can sign in · assign role here · CORE-unknown stays on Audit Application List"
        actions={
          <div className="flex gap-2">
            <Button type="button" onClick={() => setInviteOpen(true)}>
              Invite
            </Button>
            <Link to="/users/roles">
              <Button variant="secondary" type="button">
                Roles & permissions
              </Button>
            </Link>
          </div>
        }
      />

      <div className="mb-3 flex flex-wrap gap-2">
        <Input className="max-w-xs" value={q} onChange={(e) => setQ(e.target.value)} placeholder="Name, code, mobile…" />
        <Select className="max-w-[180px]" value={role} onChange={(e) => setRole(e.target.value as 'all' | OrgRole)}>
          <option value="all">All roles</option>
          <option>FA</option>
          <option>TL</option>
          <option>DM</option>
          <option>HOA</option>
          <option>Super Admin</option>
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
                <Td>{p.orgRole}</Td>
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

      <Dialog
        open={inviteOpen}
        onClose={() => setInviteOpen(false)}
        title="Invite a login"
        subtitle="Only CORE-active identities. Unknown / pending stay on Application List."
        footer={
          <>
            <Button variant="secondary" type="button" onClick={() => setInviteOpen(false)}>
              Close
            </Button>
            <Link to="/audit?tab=applications">
              <Button type="button">Open Application List</Button>
            </Link>
          </>
        }
      >
        <p className="text-sm text-muted">
          People here are already activated or Disabled. If the mobile is not in CORE, do not invite from this
          desk — activate from Audit → Application List first.
        </p>
      </Dialog>
    </div>
  )
}

function personTone(s: PersonStatus) {
  if (s === 'Active') return 'ok' as const
  if (s === 'Pending invite') return 'warn' as const
  return 'danger' as const
}
