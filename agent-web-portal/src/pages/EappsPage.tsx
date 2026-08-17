import { useMemo, useState } from 'react'
import { Link } from 'react-router-dom'
import { Button, Card, DataTable, EmptyState, Input, PageHeader, Pill, Select, Td } from '@/components/ui'
import { useAuth } from '@/auth/AuthContext'
import { EAPPS, inManagerSlice, type EappStatus } from '@/data/hqBook'

const STATUSES: Array<'all' | EappStatus> = [
  'all',
  'Draft',
  'Submitted',
  'Mark for Correction',
  'Approved',
  'Rejected',
]

export function EappsPage() {
  const { hat, caps } = useAuth()
  const [status, setStatus] = useState<(typeof STATUSES)[number]>('all')
  const [q, setQ] = useState('')
  const [district, setDistrict] = useState('all')
  const [fa, setFa] = useState('all')
  const [product, setProduct] = useState('all')
  const [exported, setExported] = useState(false)

  const slice = useMemo(() => EAPPS.filter((e) => inManagerSlice(e.district, hat)), [hat])
  const districts = useMemo(() => [...new Set(slice.map((e) => e.district))].sort(), [slice])
  const fas = useMemo(() => [...new Set(slice.map((e) => e.ownerFa))].sort(), [slice])
  const products = useMemo(() => [...new Set(slice.map((e) => e.product))].sort(), [slice])

  const rows = useMemo(() => {
    const needle = q.trim().toLowerCase()
    return slice.filter((e) => {
      if (status !== 'all' && e.status !== status) return false
      if (district !== 'all' && e.district !== district) return false
      if (fa !== 'all' && e.ownerFa !== fa) return false
      if (product !== 'all' && e.product !== product) return false
      if (!needle) return true
      return (
        e.ref.toLowerCase().includes(needle) ||
        e.party.toLowerCase().includes(needle) ||
        e.ownerFa.toLowerCase().includes(needle) ||
        e.product.toLowerCase().includes(needle)
      )
    })
  }, [slice, status, q, district, fa, product])

  return (
    <div>
      <PageHeader
        title="e-Apps"
        subtitle="FR-05 · application queue · not the Agent App wizard · not FR-01 Application List"
        actions={
          caps.canExport ? (
            <Button variant="secondary" type="button" onClick={() => setExported(true)}>
              Export Excel
            </Button>
          ) : null
        }
      />

      <p className="mb-3 text-sm text-muted">
        Correction opens a <Link to="/tasks" className="font-bold text-steel">Task</Link>. Agent register /
        CORE invite stays under{' '}
        <Link to="/audit" className="font-bold text-steel">
          Audit → Application List
        </Link>
        .
      </p>

      <div className="mb-3 flex flex-wrap gap-2">
        <Input
          className="max-w-xs"
          value={q}
          onChange={(e) => setQ(e.target.value)}
          placeholder="APP-ref, party, FA…"
        />
        <Select
          className="max-w-[220px]"
          value={status}
          onChange={(e) => setStatus(e.target.value as (typeof STATUSES)[number])}
        >
          {STATUSES.map((s) => (
            <option key={s} value={s}>
              {s === 'all' ? 'All statuses' : s}
            </option>
          ))}
        </Select>
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
        <Select className="max-w-[180px]" value={product} onChange={(e) => setProduct(e.target.value)}>
          <option value="all">All products</option>
          {products.map((p) => (
            <option key={p}>{p}</option>
          ))}
        </Select>
      </div>

      <Card>
        {rows.length === 0 ? (
          <EmptyState title="No applications in this filter" hint="Widen status or switch View as FTE." />
        ) : (
          <DataTable headers={['Ref', 'Party', 'Product', 'FA', 'Status', 'Age', '']}>
            {rows.map((e) => (
              <tr key={e.id}>
                <Td>
                  <Link to={`/eapps/${e.id}`} className="font-bold text-steel">
                    {e.ref}
                  </Link>
                </Td>
                <Td>{e.party}</Td>
                <Td>{e.product}</Td>
                <Td>{e.ownerFa}</Td>
                <Td>
                  <Pill tone={eappTone(e.status)}>{e.status}</Pill>
                </Td>
                <Td className="text-xs text-muted">{e.age}</Td>
                <Td>
                  {e.status === 'Mark for Correction' ? (
                    <Link to="/tasks?type=e-App" className="text-xs font-bold text-steel">
                      Open task
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
      {exported ? (
        <p className="mt-3 text-xs font-semibold text-ok">Export queued for the current filter (mock).</p>
      ) : null}
    </div>
  )
}

export function eappTone(s: EappStatus) {
  if (s === 'Approved') return 'ok' as const
  if (s === 'Submitted') return 'sky' as const
  if (s === 'Mark for Correction' || s === 'Rejected') return 'danger' as const
  if (s === 'Draft') return 'warn' as const
  return 'default' as const
}
