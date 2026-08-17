import { useMemo, useState } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import {
  Button,
  Card,
  DataTable,
  EmptyState,
  Input,
  PageHeader,
  Pill,
  Select,
  Td,
} from '@/components/ui'
import { useAuth } from '@/auth/AuthContext'
import { CUSTOMERS, inManagerSlice, type ClientStatus, type LeadStage } from '@/data/hqBook'
import { cn } from '@/lib/cn'

export function CrmCustomersPage() {
  const { hat, caps } = useAuth()
  const [params, setParams] = useSearchParams()
  const tab = params.get('tab') === 'leads' ? 'leads' : 'clients'
  const [q, setQ] = useState(params.get('q') ?? '')
  const [stage, setStage] = useState<'all' | LeadStage>('all')
  const [status, setStatus] = useState<'all' | ClientStatus>('all')
  const [district, setDistrict] = useState('all')
  const [fa, setFa] = useState('all')
  const [exported, setExported] = useState(false)

  const slice = useMemo(
    () => CUSTOMERS.filter((c) => inManagerSlice(c.district, hat)),
    [hat],
  )
  const districts = useMemo(
    () => [...new Set(slice.map((c) => c.district))].sort(),
    [slice],
  )
  const fas = useMemo(() => [...new Set(slice.map((c) => c.ownerFa))].sort(), [slice])

  const rows = useMemo(() => {
    const kind = tab === 'leads' ? 'lead' : 'client'
    const needle = q.trim().toLowerCase()
    const nrcTail = needle.replace(/\D/g, '')
    return slice.filter((c) => {
      if (c.kind !== kind) return false
      if (district !== 'all' && c.district !== district) return false
      if (fa !== 'all' && c.ownerFa !== fa) return false
      if (kind === 'lead' && stage !== 'all' && c.stage !== stage) return false
      if (kind === 'client' && status !== 'all' && c.status !== status) return false
      if (!needle) return true
      const nrcDigits = c.nrc.replace(/\D/g, '')
      return (
        c.name.toLowerCase().includes(needle) ||
        c.phone.includes(needle) ||
        c.ownerFa.toLowerCase().includes(needle) ||
        c.ownerCode.toLowerCase().includes(needle) ||
        (nrcTail.length >= 4 && nrcDigits.endsWith(nrcTail)) ||
        c.policies.some((p) => p.ref.toLowerCase().includes(needle))
      )
    })
  }, [tab, q, slice, district, fa, stage, status])

  const setTab = (next: 'leads' | 'clients') => {
    const nextParams = new URLSearchParams(params)
    nextParams.set('tab', next)
    setParams(nextParams)
  }

  return (
    <div>
      <PageHeader
        title="Customers"
        subtitle="FR-03 · HQ book · Leads vs Clients · owner FA · no sell wizard"
        actions={
          caps.canExport ? (
            <Button type="button" variant="secondary" onClick={() => setExported(true)}>
              Export Excel
            </Button>
          ) : null
        }
      />

      <p className="mb-3 text-sm text-muted">
        Same split as the Agent App. Convert happens when Core issues a policy — this desk does not “Make
        client”. Quote / Start e-App stay on mobile.
      </p>

      <div className="mb-3 inline-flex rounded-xl border border-line bg-soft p-1">
        {(
          [
            ['clients', 'Clients'],
            ['leads', 'Leads'],
          ] as const
        ).map(([id, label]) => (
          <button
            key={id}
            type="button"
            onClick={() => setTab(id)}
            className={cn(
              'rounded-lg px-4 py-2 text-sm font-bold transition',
              tab === id ? 'bg-steel text-white' : 'text-muted hover:text-deep',
            )}
          >
            {label}
          </button>
        ))}
      </div>

      <Card>
        <div className="mb-3 flex flex-wrap gap-2">
          <Input
            className="max-w-md"
            value={q}
            onChange={(e) => setQ(e.target.value)}
            placeholder={
              tab === 'leads' ? 'Name, phone, NRC last 6, FA…' : 'Name, phone, POL-, NRC last 6, FA'
            }
          />
          {tab === 'leads' ? (
            <Select className="max-w-[160px]" value={stage} onChange={(e) => setStage(e.target.value as 'all' | LeadStage)}>
              <option value="all">All stages</option>
              <option>New</option>
              <option>Contacted</option>
              <option>Quoted</option>
              <option>Applied</option>
            </Select>
          ) : (
            <Select
              className="max-w-[160px]"
              value={status}
              onChange={(e) => setStatus(e.target.value as 'all' | ClientStatus)}
            >
              <option value="all">All statuses</option>
              <option>Active</option>
              <option>Pending</option>
              <option>Expired</option>
            </Select>
          )}
          <Select className="max-w-[160px]" value={district} onChange={(e) => setDistrict(e.target.value)}>
            <option value="all">All districts</option>
            {districts.map((d) => (
              <option key={d}>{d}</option>
            ))}
          </Select>
          <Select className="max-w-[160px]" value={fa} onChange={(e) => setFa(e.target.value)}>
            <option value="all">All FAs</option>
            {fas.map((n) => (
              <option key={n}>{n}</option>
            ))}
          </Select>
        </div>
        {rows.length === 0 ? (
          <EmptyState
            title={tab === 'leads' ? 'No leads in this slice' : 'No clients in this slice'}
            hint={
              hat === 'manager'
                ? 'Manager view is Yangon line only. Switch View as FTE for portfolio.'
                : 'Clear search or change tab.'
            }
          />
        ) : tab === 'leads' ? (
          <DataTable headers={['Name', 'Phone', 'Stage', 'Owner FA', 'District', 'Last activity']}>
            {rows.map((c) => (
              <tr key={c.id}>
                <Td>
                  <Link to={`/crm/customers/${c.id}`} className="font-bold text-steel hover:underline">
                    {c.name}
                  </Link>
                </Td>
                <Td>{c.phone}</Td>
                <Td>
                  <Pill tone={stageTone(c.stage)}>{c.stage}</Pill>
                </Td>
                <Td>{c.ownerFa}</Td>
                <Td className="text-muted">{c.district}</Td>
                <Td className="text-xs text-muted">{c.lastActivity}</Td>
              </tr>
            ))}
          </DataTable>
        ) : (
          <DataTable headers={['Name', 'Phone', 'Status', 'Owner FA', 'Policies', 'District']}>
            {rows.map((c) => (
              <tr key={c.id}>
                <Td>
                  <Link to={`/crm/customers/${c.id}`} className="font-bold text-steel hover:underline">
                    {c.name}
                  </Link>
                  {c.status === 'Expired' ? (
                    <span className="ml-2 text-[10px] font-extrabold text-danger">DUE</span>
                  ) : null}
                </Td>
                <Td>{c.phone}</Td>
                <Td>
                  <Pill tone={statusTone(c.status)}>{c.status}</Pill>
                </Td>
                <Td>{c.ownerFa}</Td>
                <Td className="text-xs text-muted">{c.policies.map((p) => p.ref).join(' · ') || '—'}</Td>
                <Td className="text-muted">{c.district}</Td>
              </tr>
            ))}
          </DataTable>
        )}
      </Card>

      {exported ? (
        <p className="mt-3 text-xs font-semibold text-ok">Export queued for the current tab + filter (mock).</p>
      ) : null}
    </div>
  )
}

function stageTone(s?: LeadStage) {
  if (s === 'Applied') return 'warn' as const
  if (s === 'Quoted') return 'ok' as const
  return 'default' as const
}

function statusTone(s?: ClientStatus) {
  if (s === 'Active') return 'ok' as const
  if (s === 'Pending') return 'warn' as const
  return 'danger' as const
}
