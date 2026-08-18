import { useState } from 'react'
import { Link, Navigate, useParams } from 'react-router-dom'
import { Button, Card, Dialog, Field, PageHeader, Pill, Select, Textarea } from '@/components/ui'
import { useAuth } from '@/auth/AuthContext'
import { customerById, inManagerSlice, PEOPLE } from '@/data/hqBook'

export function CrmCustomerDetailPage() {
  const { id } = useParams()
  const { caps, hat } = useAuth()
  const found = id ? customerById(id) : undefined
  const [owner, setOwner] = useState(found?.ownerFa ?? '')
  const [reassignOpen, setReassignOpen] = useState(false)
  const [nextFa, setNextFa] = useState(found?.ownerFa ?? 'Aye Chan')
  const [reason, setReason] = useState('')
  const [note, setNote] = useState('')
  const [notes, setNotes] = useState(found?.notes ?? [])

  if (!found || !inManagerSlice(found.district, hat)) return <Navigate to="/crm/customers" replace />

  const fas = [...new Set(PEOPLE.filter((p) => p.orgRole === 'FA').map((p) => p.name))]
  const canReassign = caps.canViewAllBooks

  return (
    <div>
      <PageHeader
        title={found.name}
        subtitle={`${found.kind === 'lead' ? 'Lead' : 'Client'} · owner ${owner} · ${found.district}`}
        actions={
          <Link to={`/crm/customers?tab=${found.kind === 'lead' ? 'leads' : 'clients'}`}>
            <Button variant="secondary" type="button">
              Back to list
            </Button>
          </Link>
        }
      />

      <div className="grid gap-3.5 lg:grid-cols-2">
        <Card title="Contact">
          <dl className="grid gap-2 text-sm">
            <Row label="Phone" value={found.phone} />
            <Row label="Email" value={found.email} />
            <Row label="NRC" value={found.nrc} />
            <Row label="Owner FA" value={`${owner} · ${found.ownerCode}`} />
            {found.kind === 'lead' ? <Row label="Stage" value={found.stage ?? '—'} /> : null}
            {found.kind === 'client' ? <Row label="Status" value={found.status ?? '—'} /> : null}
            {found.convertedFrom ? <Row label="Convert history" value={found.convertedFrom} /> : null}
          </dl>
          <p className="mt-3 text-xs text-muted">
            KYC edits go to pending audit changes. This portal won’t overwrite CORE.
          </p>
          {canReassign ? (
            <Button className="mt-3" size="sm" type="button" onClick={() => setReassignOpen(true)}>
              Reassign FA
            </Button>
          ) : (
            <p className="mt-3 text-xs text-muted">Reassign is FTE / Admin only.</p>
          )}
        </Card>

        <Card title={found.kind === 'client' ? 'Policies (read-only)' : 'No issued policy'}>
          {found.policies.length === 0 ? (
            <p className="text-sm text-muted">Leads have zero servicing policies. Quotes / e-Apps may exist.</p>
          ) : (
            <ul className="space-y-2">
              {found.policies.map((p) => (
                <li key={p.ref} className="rounded-xl border border-line px-3 py-2 text-sm">
                  <div className="flex items-center justify-between gap-2">
                    <b className="text-deep">{p.ref}</b>
                    <Pill tone={p.status === 'Active' ? 'ok' : p.status === 'Pending' ? 'warn' : 'danger'}>
                      {p.status}
                    </Pill>
                  </div>
                  <p className="text-xs text-muted">
                    {p.product} · premium {p.premium}
                  </p>
                </li>
              ))}
            </ul>
          )}
        </Card>

        <Card title="Quotes / e-Apps">
          {found.eappIds.length === 0 && found.quotes.length === 0 ? (
            <p className="text-sm text-muted">None linked.</p>
          ) : (
            <ul className="space-y-1 text-sm">
              {found.quotes.map((q) => (
                <li key={q} className="text-muted">
                  Quote {q}
                </li>
              ))}
              {found.eappIds.map((eid) => (
                <li key={eid}>
                  <Link to={`/eapps/${eid}`} className="font-bold text-steel">
                    Open e-App
                  </Link>
                </li>
              ))}
            </ul>
          )}
          <p className="mt-2 text-xs text-muted">Start e-App / Get a quote stay on the Agent App.</p>
        </Card>

        <Card
          title="HQ notes"
          action={
            <Link to="/tasks">
              <Button size="sm" variant="secondary" type="button">
                Create task
              </Button>
            </Link>
          }
        >
          <ul className="mb-3 space-y-1 text-sm text-muted">
            {notes.map((n) => (
              <li key={n}>· {n}</li>
            ))}
          </ul>
          <Field label="Add note (visible to owner FA on next sync)" className="mb-2">
            <Textarea rows={2} value={note} onChange={(e) => setNote(e.target.value)} />
          </Field>
          <Button
            size="sm"
            type="button"
            disabled={!note.trim()}
            onClick={() => {
              setNotes((prev) => [`HQ · ${note.trim()}`, ...prev])
              setNote('')
            }}
          >
            Add note
          </Button>
        </Card>
      </div>

      <Dialog
        open={reassignOpen}
        onClose={() => setReassignOpen(false)}
        title="Reassign owner FA"
        subtitle="Writes an audit row · does not move Core policy ownership until sync"
        footer={
          <>
            <Button variant="secondary" type="button" onClick={() => setReassignOpen(false)}>
              Cancel
            </Button>
            <Button
              type="button"
              disabled={!reason.trim()}
              onClick={() => {
                setOwner(nextFa)
                setReassignOpen(false)
                setReason('')
              }}
            >
              Reassign
            </Button>
          </>
        }
      >
        <Field label="New FA *">
          <Select value={nextFa} onChange={(e) => setNextFa(e.target.value)}>
            {fas.map((n) => (
              <option key={n}>{n}</option>
            ))}
          </Select>
        </Field>
        <Field label="Reason *" className="mb-0">
          <Textarea rows={2} value={reason} onChange={(e) => setReason(e.target.value)} />
        </Field>
      </Dialog>
    </div>
  )
}

function Row({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex justify-between gap-3 border-b border-line/70 pb-2 last:border-0">
      <dt className="text-xs font-bold text-muted">{label}</dt>
      <dd className="text-right font-bold text-deep">{value}</dd>
    </div>
  )
}
