import { useState } from 'react'
import { Link, Navigate, useLocation, useNavigate, useParams } from 'react-router-dom'
import { Button, Card, Field, Input, PageHeader, Pill, Select } from '@/components/ui'
import { isAccessError, useAccess } from '@/data/AccessContext'
import {
  ROLE_CLUSTERS,
  activePerms,
  activeRoles,
  packFlags,
  peopleOnRole,
  previewModules,
  type RoleCluster,
} from '@/data/hqAccess'
import type { Channel } from '@/data/hqBook'
import { cn } from '@/lib/cn'

export function RoleSetupPage() {
  const { id } = useParams()
  const { pathname } = useLocation()
  const nav = useNavigate()
  const { roles, perms, people, createRole, updateRole, setPackCell, resetRolePack, archiveRole } = useAccess()
  const isNew = pathname.endsWith('/roles/new')
  const found = isNew ? undefined : id ? roles.find((r) => r.id === id) : undefined

  const clones = activeRoles(roles)
  const [name, setName] = useState(found?.name ?? '')
  const [cluster, setCluster] = useState<RoleCluster>(found?.cluster ?? 'Coach')
  const [cloneFromId, setCloneFromId] = useState(clones[1]?.id ?? clones[0]?.id ?? '')
  const [channel, setChannel] = useState<Channel>(found?.channelDefault ?? 'App')
  const [err, setErr] = useState('')
  const [saved, setSaved] = useState(false)

  if (!isNew && !found) return <Navigate to="/users/roles" replace />

  const cols = activePerms(perms)
  const pack = found?.pack ?? clones.find((r) => r.id === cloneFromId)?.pack ?? {}
  const flags = packFlags(pack, perms)
  const modules = previewModules(flags)
  const assigned = found ? peopleOnRole(people, found.id).length : 0

  const save = () => {
    if (isNew) {
      const res = createRole({ name, cluster, cloneFromId, channelDefault: channel })
      if (isAccessError(res)) {
        setErr(res.error)
        return
      }
      nav(`/users/roles/${res.id}`, { replace: true })
      return
    }
    const res = updateRole(found!.id, { name, cluster, channelDefault: channel })
    if (res.error) {
      setErr(res.error)
      return
    }
    setErr('')
    setSaved(true)
    setTimeout(() => setSaved(false), 2000)
  }

  return (
    <div>
      <PageHeader
        title={isNew ? 'Add role' : found?.name ?? 'Role'}
        subtitle={isNew ? 'Clone a pack · cluster decides allowed screens' : `${found?.cluster} · ${assigned} people`}
        actions={
          <div className="flex flex-wrap gap-2">
            <Link to="/users/roles">
              <Button variant="secondary" type="button">
                Back to roles
              </Button>
            </Link>
            <Button type="button" onClick={save} disabled={!name.trim()}>
              {isNew ? 'Create role' : 'Save setup'}
            </Button>
          </div>
        }
      />
      {err ? <p className="mb-3 text-xs font-semibold text-danger">{err}</p> : null}
      {saved ? <p className="mb-3 text-xs font-semibold text-ok">Saved · next session menus.</p> : null}

      <div className="grid gap-3.5 lg:grid-cols-2">
        <Card title="Identity">
          <Field label="Name *">
            <Input value={name} onChange={(e) => setName(e.target.value)} placeholder="e.g. Regional Coach" />
          </Field>
          <Field label="Cluster *">
            <Select value={cluster} onChange={(e) => setCluster(e.target.value as RoleCluster)}>
              {ROLE_CLUSTERS.map((c) => (
                <option key={c}>{c}</option>
              ))}
            </Select>
          </Field>
          {isNew ? (
            <Field label="Clone from *">
              <Select value={cloneFromId} onChange={(e) => setCloneFromId(e.target.value)}>
                {clones.map((r) => (
                  <option key={r.id} value={r.id}>
                    {r.name}
                  </option>
                ))}
              </Select>
            </Field>
          ) : (
            <p className="mb-3 text-xs text-muted">{found?.system ? 'System role · slug locked' : 'Custom role'}</p>
          )}
          <Field label="Default channel" className="mb-0">
            <Select value={channel} onChange={(e) => setChannel(e.target.value as Channel)}>
              <option>App</option>
              <option>Portal</option>
              <option>Both</option>
            </Select>
          </Field>
        </Card>

        <Card title="Nav preview (this pack)">
          <p className="mb-2 text-xs text-muted">Ghost of sidebar modules. Not a page builder.</p>
          <div className="flex flex-wrap gap-1.5">
            {modules.map((m) => (
              <Pill key={m} tone="ok">
                {m}
              </Pill>
            ))}
          </div>
          {found ? (
            <div className="mt-4 flex flex-wrap gap-2">
              <Button variant="secondary" size="sm" type="button" onClick={() => resetRolePack(found.id)}>
                Reset this pack
              </Button>
              <Button
                variant="danger"
                size="sm"
                type="button"
                onClick={() => {
                  const res = archiveRole(found.id)
                  if (!res.ok) setErr(res.message ?? '')
                  else nav('/users/roles')
                }}
              >
                Archive
              </Button>
            </div>
          ) : null}
        </Card>

        {found ? (
          <Card title="Pack" className="lg:col-span-2">
            <div className="flex flex-wrap gap-2">
              {cols.map((c) => {
                const on = Boolean(found.pack[c.key])
                return (
                  <button
                    key={c.key}
                    type="button"
                    onClick={() => setPackCell(found.id, c.key, !on)}
                    className={cn(
                      'rounded-xl border px-3 py-2 text-left text-xs font-bold',
                      on ? 'border-ok bg-emerald-50 text-ok' : 'border-line bg-soft text-muted',
                    )}
                  >
                    {c.label}
                    <span className="mt-0.5 block text-[10px] font-semibold opacity-80">{c.module}</span>
                  </button>
                )
              })}
            </div>
          </Card>
        ) : null}
      </div>
    </div>
  )
}
