import { useState } from 'react'
import { Link, Navigate, useParams } from 'react-router-dom'
import { Button, Card, Dialog, Field, PageHeader, Select } from '@/components/ui'
import { personById, type Channel, type OrgRole, type PersonStatus } from '@/data/hqBook'

export function UserDetailPage() {
  const { id } = useParams()
  const found = id ? personById(id) : undefined
  const [role, setRole] = useState<OrgRole>(found?.orgRole ?? 'FA')
  const [channel, setChannel] = useState<Channel>(found?.channel ?? 'App')
  const [status, setStatus] = useState<PersonStatus>(found?.status ?? 'Active')
  const [disableOpen, setDisableOpen] = useState(false)
  const [saved, setSaved] = useState(false)

  if (!found) return <Navigate to="/users" replace />

  return (
    <div>
      <PageHeader
        title={found.name}
        subtitle={`${found.code} · role change applies on next session`}
        actions={
          <Link to="/users/people">
            <Button variant="secondary" type="button">
              Back to people
            </Button>
          </Link>
        }
      />

      <div className="grid gap-3.5 lg:grid-cols-2">
        <Card title="Identity (CORE)">
          <dl className="grid gap-2 text-sm">
            <Row label="Mobile" value={found.mobile} />
            <Row label="District" value={found.district} />
            <Row label="Last login" value={found.lastLogin} />
            <Row label="Devices" value={String(found.devices)} />
          </dl>
          <div className="mt-3 flex flex-wrap gap-2">
            <Link to="/audit">
              <Button size="sm" variant="secondary" type="button">
                Audit directory
              </Button>
            </Link>
            {found.devices > 0 ? (
              <Link to="/management/devices">
                <Button size="sm" variant="secondary" type="button">
                  Devices
                </Button>
              </Link>
            ) : null}
          </div>
        </Card>

        <Card title="Access">
          <Field label="Role *">
            <Select value={role} onChange={(e) => setRole(e.target.value as OrgRole)}>
              <option>FA</option>
              <option>TL</option>
              <option>DM</option>
              <option>HOA</option>
              <option>Super Admin</option>
            </Select>
          </Field>
          <Field label="Channel">
            <Select value={channel} onChange={(e) => setChannel(e.target.value as Channel)}>
              <option>App</option>
              <option>Portal</option>
              <option>Both</option>
            </Select>
          </Field>
          <Field label="Status">
            <Select value={status} onChange={(e) => setStatus(e.target.value as PersonStatus)}>
              <option>Active</option>
              <option>Disabled</option>
              <option>Pending invite</option>
            </Select>
          </Field>
          <p className="mb-3 text-xs text-muted">
            Pack of permissions for this role is on{' '}
            <Link to="/users/roles" className="font-bold text-steel">
              Roles & permissions
            </Link>
            . Per-user overrides are not in this prototype.
          </p>
          <div className="flex flex-wrap gap-2">
            <Button
              type="button"
              onClick={() => {
                setSaved(true)
                setTimeout(() => setSaved(false), 2500)
              }}
            >
              Save
            </Button>
            {status !== 'Disabled' ? (
              <Button variant="danger" type="button" onClick={() => setDisableOpen(true)}>
                Disable
              </Button>
            ) : null}
          </div>
          {saved ? (
            <p className="mt-2 text-xs font-semibold text-ok">Saved · audit log would record previous → new role.</p>
          ) : null}
        </Card>
      </div>

      <Dialog
        open={disableOpen}
        onClose={() => setDisableOpen(false)}
        title={`Disable ${found.name}?`}
        subtitle="App + portal sessions end on next check"
        footer={
          <>
            <Button variant="secondary" type="button" onClick={() => setDisableOpen(false)}>
              Cancel
            </Button>
            <Button
              variant="danger"
              type="button"
              onClick={() => {
                setStatus('Disabled')
                setDisableOpen(false)
              }}
            >
              Disable
            </Button>
          </>
        }
      >
        <p className="text-sm text-muted">
          Devices are not wiped from here. Use Management → Devices if you need an app-data wipe.
        </p>
      </Dialog>
    </div>
  )
}

function Row({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex justify-between gap-3 border-b border-line/70 pb-2 last:border-0">
      <dt className="text-xs font-bold text-muted">{label}</dt>
      <dd className="font-bold text-deep">{value}</dd>
    </div>
  )
}
