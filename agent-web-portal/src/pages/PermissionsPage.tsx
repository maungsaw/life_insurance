import { useMemo, useState } from 'react'
import { Link } from 'react-router-dom'
import { Button, Card, DataTable, Dialog, EmptyState, Field, Input, PageHeader, Pill, Select, Td } from '@/components/ui'
import { isAccessError, useAccess } from '@/data/AccessContext'
import { PERM_MODULES, type PermModule } from '@/data/hqAccess'

export function PermissionsPage() {
  const { perms, createPerm, archivePerm, unarchivePerm, renamePerm } = useAccess()
  const systemCaps = perms.filter((p) => p.kind === 'system' && p.status === 'active')
  const [q, setQ] = useState('')
  const [open, setOpen] = useState(false)
  const [label, setLabel] = useState('')
  const [module, setModule] = useState<PermModule>('CRM')
  const [aliasOf, setAliasOf] = useState(systemCaps[0]?.key ?? 'crm')
  const [err, setErr] = useState('')
  const [renameKey, setRenameKey] = useState<string | null>(null)
  const [renameLabel, setRenameLabel] = useState('')

  const rows = useMemo(() => {
    const needle = q.trim().toLowerCase()
    return perms.filter(
      (p) =>
        !needle ||
        p.label.toLowerCase().includes(needle) ||
        p.key.toLowerCase().includes(needle) ||
        p.module.toLowerCase().includes(needle),
    )
  }, [perms, q])

  return (
    <div>
      <PageHeader
        title="Permissions"
        actions={
          <div className="flex gap-2">
            <Link to="/users/roles">
              <Button variant="secondary" type="button">
                Roles matrix
              </Button>
            </Link>
            <Button type="button" onClick={() => setOpen(true)}>
              + Add permission
            </Button>
          </div>
        }
      />
      {err ? <p className="mb-3 text-xs font-semibold text-danger">{err}</p> : null}

      <Input className="mb-3 max-w-xs" value={q} onChange={(e) => setQ(e.target.value)} placeholder="Label, key, module…" />

      <Card>
        {rows.length === 0 ? (
          <EmptyState title="No permissions in this filter" />
        ) : (
          <DataTable headers={['Key', 'Label', 'Module', 'Kind', 'Alias', 'Status', '']}>
            {rows.map((p) => (
              <tr key={p.key}>
                <Td className="font-mono text-xs">{p.key}</Td>
                <Td className="font-bold">{p.label}</Td>
                <Td className="text-xs text-muted">{p.module}</Td>
                <Td>{p.kind === 'system' ? <Pill>System</Pill> : <Pill tone="sky">Custom</Pill>}</Td>
                <Td className="text-xs text-muted">{p.aliasOf ?? '—'}</Td>
                <Td>{p.status === 'active' ? <Pill tone="ok">Active</Pill> : <Pill tone="danger">Archived</Pill>}</Td>
                <Td>
                  <div className="flex flex-wrap gap-1">
                    {p.kind === 'custom' ? (
                      <Button
                        variant="ghost"
                        size="sm"
                        type="button"
                        onClick={() => {
                          setRenameKey(p.key)
                          setRenameLabel(p.label)
                        }}
                      >
                        Rename
                      </Button>
                    ) : null}
                    {p.kind === 'custom' && p.status === 'active' ? (
                      <Button
                        variant="ghost"
                        size="sm"
                        type="button"
                        className="text-danger"
                        onClick={() => {
                          const res = archivePerm(p.key)
                          setErr(res.ok ? '' : res.message ?? '')
                        }}
                      >
                        Archive
                      </Button>
                    ) : null}
                    {p.kind === 'custom' && p.status === 'archived' ? (
                      <Button variant="secondary" size="sm" type="button" onClick={() => unarchivePerm(p.key)}>
                        Unarchive
                      </Button>
                    ) : null}
                  </div>
                </Td>
              </tr>
            ))}
          </DataTable>
        )}
      </Card>

      <Dialog
        open={open}
        onClose={() => setOpen(false)}
        title="Add permission"
        subtitle="Must alias a system cap — cannot invent payout or policy-edit"
        footer={
          <>
            <Button variant="secondary" type="button" onClick={() => setOpen(false)}>
              Cancel
            </Button>
            <Button
              type="button"
              disabled={!label.trim()}
              onClick={() => {
                const res = createPerm({ label, module, aliasOf })
                if (isAccessError(res)) {
                  setErr(res.error)
                  return
                }
                setOpen(false)
                setLabel('')
                setErr('')
              }}
            >
              Create
            </Button>
          </>
        }
      >
        <Field label="Label *">
          <Input value={label} onChange={(e) => setLabel(e.target.value)} placeholder="e.g. CRM book (read)" />
        </Field>
        <Field label="Module *">
          <Select value={module} onChange={(e) => setModule(e.target.value as PermModule)}>
            {PERM_MODULES.map((m) => (
              <option key={m}>{m}</option>
            ))}
          </Select>
        </Field>
        <Field label="Alias of system cap *" className="mb-0">
          <Select value={aliasOf} onChange={(e) => setAliasOf(e.target.value)}>
            {systemCaps.map((p) => (
              <option key={p.key} value={p.key}>
                {p.label} ({p.key})
              </option>
            ))}
          </Select>
        </Field>
      </Dialog>

      <Dialog
        open={renameKey !== null}
        onClose={() => setRenameKey(null)}
        title="Rename permission"
        subtitle="Key stays locked"
        footer={
          <>
            <Button variant="secondary" type="button" onClick={() => setRenameKey(null)}>
              Cancel
            </Button>
            <Button
              type="button"
              disabled={!renameLabel.trim() || !renameKey}
              onClick={() => {
                if (renameKey) renamePerm(renameKey, renameLabel)
                setRenameKey(null)
              }}
            >
              Save
            </Button>
          </>
        }
      >
        <Field label="Label *" className="mb-0">
          <Input value={renameLabel} onChange={(e) => setRenameLabel(e.target.value)} />
        </Field>
      </Dialog>
    </div>
  )
}
