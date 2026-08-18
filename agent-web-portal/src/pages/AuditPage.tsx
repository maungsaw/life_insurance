import { useState } from 'react'
import { useSearchParams } from 'react-router-dom'
import { Button, Card, DataTable, Dialog, Field, Input, PageHeader, Pill, Td } from '@/components/ui'
import { cn } from '@/lib/cn'

type Tab = 'directory' | 'pending' | 'applications' | 'log'

type PendingRow = {
  id: string
  agent: string
  field: string
  previous: string
  next: string
  requester: string
  when: string
}

type AppRow = {
  id: string
  name: string
  mobile: string
  status: 'Pending invite' | 'CORE unknown' | 'Activated'
  district: string
  when: string
}

const PENDING_SEED: PendingRow[] = [
  {
    id: 'pc1',
    agent: 'Aye Chan · AGT-10284',
    field: 'Mobile',
    previous: '09 771 234 567',
    next: '09 988 111 222',
    requester: 'Aye Chan',
    when: '16-Aug-2026 09:12',
  },
  {
    id: 'pc2',
    agent: 'Zaw Ko · AGT-11002',
    field: 'Email',
    previous: 'zaw@kbz.example',
    next: 'zawko@kbz.example',
    requester: 'Zaw Ko',
    when: '15-Aug-2026 14:40',
  },
]

const APP_SEED: AppRow[] = [
  {
    id: 'a1',
    name: 'Hnin Hnin',
    mobile: '09 000 000 000',
    status: 'CORE unknown',
    district: '—',
    when: '17-Aug-2026',
  },
  {
    id: 'a2',
    name: 'Min Thu',
    mobile: '09 111 111 111',
    status: 'Pending invite',
    district: 'Yangon A',
    when: '16-Aug-2026',
  },
]

export function AuditPage() {
  const [params] = useSearchParams()
  const tabFromUrl = params.get('tab')
  const initialTab: Tab =
    tabFromUrl === 'pending' || tabFromUrl === 'applications' || tabFromUrl === 'log'
      ? tabFromUrl
      : 'directory'
  const [tab, setTab] = useState<Tab>(initialTab)
  const [pending, setPending] = useState(PENDING_SEED)
  const [apps, setApps] = useState(APP_SEED)
  const [rejectId, setRejectId] = useState<string | null>(null)
  const [rejectNote, setRejectNote] = useState('')

  const approve = (id: string) => setPending((prev) => prev.filter((r) => r.id !== id))
  const reject = () => {
    if (!rejectId || !rejectNote.trim()) return
    setPending((prev) => prev.filter((r) => r.id !== rejectId))
    setRejectId(null)
    setRejectNote('')
  }

  const activate = (id: string) =>
    setApps((prev) => prev.map((a) => (a.id === id ? { ...a, status: 'Activated' } : a)))

  const tabs: { id: Tab; label: string }[] = [
    { id: 'directory', label: 'Directory' },
    { id: 'pending', label: `Pending (${pending.length})` },
    { id: 'applications', label: 'Application List' },
    { id: 'log', label: 'Log' },
  ]

  return (
    <div>
      <PageHeader
        title="Audit"
      />

      <div className="mb-4 flex flex-wrap gap-2">
        {tabs.map((t) => (
          <button
            key={t.id}
            type="button"
            onClick={() => setTab(t.id)}
            className={cn(
              'rounded-full px-3.5 py-1.5 text-xs font-extrabold transition',
              tab === t.id ? 'bg-steel text-white' : 'bg-soft text-muted hover:text-deep',
            )}
          >
            {t.label}
          </button>
        ))}
      </div>

      {tab === 'directory' ? (
        <Card title="Agent directory">
          <p className="mb-3 text-xs text-muted">
            Approved agent master. On-Boarding follow-ups are under Tasks. Role assignment is under Users.
          </p>
          <DataTable headers={['Code', 'Name', 'Role', 'Mobile', 'Status', 'District']}>
            <tr>
              <Td>AGT-10284</Td>
              <Td>Aye Chan</Td>
              <Td>FA</Td>
              <Td>09 771 234 567</Td>
              <Td>
                <Pill tone="ok">Active</Pill>
              </Td>
              <Td>Yangon A</Td>
            </tr>
            <tr>
              <Td>AGT-11002</Td>
              <Td>Zaw Ko</Td>
              <Td>FA</Td>
              <Td>09 988 111 222</Td>
              <Td>
                <Pill tone="warn">LC Training</Pill>
              </Td>
              <Td>Yangon A</Td>
            </tr>
          </DataTable>
        </Card>
      ) : null}

      {tab === 'pending' ? (
        <Card title="Pending changes">
          <p className="mb-3 text-xs text-muted">
            Agents cannot freely change approved identity. Approve writes the new value; Reject needs a reason.
          </p>
          {pending.length === 0 ? (
            <p className="py-8 text-center text-sm font-semibold text-muted">No pending change requests.</p>
          ) : (
            <DataTable headers={['Agent', 'Field', 'Previous', 'New', 'Requester', 'When', '']}>
              {pending.map((r) => (
                <tr key={r.id}>
                  <Td className="font-bold">{r.agent}</Td>
                  <Td>{r.field}</Td>
                  <Td className="text-muted">{r.previous}</Td>
                  <Td className="font-bold">{r.next}</Td>
                  <Td>{r.requester}</Td>
                  <Td className="text-xs text-muted">{r.when}</Td>
                  <Td>
                    <div className="flex gap-1">
                      <Button size="sm" type="button" onClick={() => approve(r.id)}>
                        Approve
                      </Button>
                      <Button size="sm" variant="danger" type="button" onClick={() => setRejectId(r.id)}>
                        Reject
                      </Button>
                    </div>
                  </Td>
                </tr>
              ))}
            </DataTable>
          )}
        </Card>
      ) : null}

      {tab === 'applications' ? (
        <Card title="Application List · agent register">
          <p className="mb-3 text-xs text-muted">
            CORE-unknown and pending invite from the Agent App. This is <b className="text-deep">not</b> the
            policy e-App queue. Portal login stays closed until Activated.
          </p>
          <DataTable headers={['Name', 'Mobile', 'Status', 'District', 'When', '']}>
            {apps.map((a) => (
              <tr key={a.id}>
                <Td className="font-bold">{a.name}</Td>
                <Td>{a.mobile}</Td>
                <Td>
                  {a.status === 'Activated' ? (
                    <Pill tone="ok">Activated</Pill>
                  ) : a.status === 'Pending invite' ? (
                    <Pill tone="warn">Pending invite</Pill>
                  ) : (
                    <Pill tone="danger">CORE unknown</Pill>
                  )}
                </Td>
                <Td>{a.district}</Td>
                <Td className="text-xs text-muted">{a.when}</Td>
                <Td>
                  {a.status !== 'Activated' ? (
                    <Button size="sm" type="button" onClick={() => activate(a.id)}>
                      Activate
                    </Button>
                  ) : (
                    <span className="text-xs text-muted">—</span>
                  )}
                </Td>
              </tr>
            ))}
          </DataTable>
        </Card>
      ) : null}

      {tab === 'log' ? (
        <Card title="Audit log">
          <DataTable headers={['Action', 'Previous', 'New', 'User', 'When']}>
            <tr>
              <Td>Update mobile</Td>
              <Td>09 771 234 567</Td>
              <Td>09 988 111 222</Td>
              <Td>Ops May</Td>
              <Td>03-Aug-2026 09:12</Td>
            </tr>
            <tr>
              <Td>Status change</Td>
              <Td>Pre-Contracted</Td>
              <Td>LC Training</Td>
              <Td>Alliance</Td>
              <Td>02-Aug-2026 16:40</Td>
            </tr>
            <tr>
              <Td>Reassign CRM owner</Td>
              <Td>Aye Chan</Td>
              <Td>Nwe Nwe</Td>
              <Td>Ops May</Td>
              <Td>17-Aug-2026 15:40</Td>
            </tr>
          </DataTable>
        </Card>
      ) : null}

      <Dialog
        open={rejectId !== null}
        onClose={() => {
          setRejectId(null)
          setRejectNote('')
        }}
        title="Reject change"
        subtitle="Reason is required for the audit log"
        footer={
          <>
            <Button
              variant="secondary"
              type="button"
              onClick={() => {
                setRejectId(null)
                setRejectNote('')
              }}
            >
              Cancel
            </Button>
            <Button variant="danger" type="button" disabled={!rejectNote.trim()} onClick={reject}>
              Reject
            </Button>
          </>
        }
      >
        <Field label="Reason *" className="mb-0">
          <Input
            value={rejectNote}
            onChange={(e) => setRejectNote(e.target.value)}
            placeholder="e.g. NRC mismatch with CORE"
          />
        </Field>
      </Dialog>
    </div>
  )
}
