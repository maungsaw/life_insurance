import { useMemo, useState } from 'react'
import { Link } from 'react-router-dom'
import {
  Button,
  Card,
  DataTable,
  Dialog,
  Field,
  Input,
  PageHeader,
  Pill,
  Select,
  Td,
} from '@/components/ui'

type ProductStatus = 'on' | 'off'

type Product = {
  id: string
  code: string
  name: string
  blurb: string
  status: ProductStatus
  changedAt: string
  changedBy: string
}

type HistoryRow = {
  id: string
  when: string
  code: string
  action: 'Turned on' | 'Turned off'
  reason: string
  by: string
}

const SEED: Product[] = [
  {
    id: 'p1',
    code: 'EN',
    name: 'Endowment Plan',
    blurb: 'Savings + protection',
    status: 'on',
    changedAt: '01-Aug-2026',
    changedBy: 'Ops May',
  },
  {
    id: 'p2',
    code: 'UL',
    name: 'Universal Life',
    blurb: 'Flexible premium',
    status: 'on',
    changedAt: '12-Jul-2026',
    changedBy: 'Ops May',
  },
  {
    id: 'p3',
    code: 'CI',
    name: 'Critical Illness',
    blurb: 'Health protection',
    status: 'on',
    changedAt: '28-Jun-2026',
    changedBy: 'Product Admin',
  },
  {
    id: 'p4',
    code: 'TL',
    name: 'Term Life',
    blurb: 'Pure protection',
    status: 'off',
    changedAt: '02-Aug-2026',
    changedBy: 'Ops May',
  },
  {
    id: 'p5',
    code: 'WP',
    name: 'Whole Life Plus',
    blurb: 'Lifelong cover',
    status: 'off',
    changedAt: '15-Jul-2026',
    changedBy: 'Product Admin',
  },
]

const SEED_HISTORY: HistoryRow[] = [
  {
    id: 'h1',
    when: '02-Aug-2026 10:14',
    code: 'TL',
    action: 'Turned off',
    reason: 'Pricing update',
    by: 'Ops May',
  },
  {
    id: 'h2',
    when: '15-Jul-2026 16:02',
    code: 'WP',
    action: 'Turned off',
    reason: 'Campaign pause',
    by: 'Product Admin',
  },
  {
    id: 'h3',
    when: '01-Aug-2026 09:00',
    code: 'EN',
    action: 'Turned on',
    reason: '—',
    by: 'Ops May',
  },
]

/** Control panel — enable / disable Agency Sales catalog (Core codes). */
export function MgmtProductsPage() {
  const [products, setProducts] = useState(SEED)
  const [history, setHistory] = useState(SEED_HISTORY)
  const [q, setQ] = useState('')
  const [statusFilter, setStatusFilter] = useState<'all' | ProductStatus>('all')

  const [pendingId, setPendingId] = useState<string | null>(null)
  const [reason, setReason] = useState('Campaign pause')
  const [note, setNote] = useState('')

  const pending = pendingId ? products.find((p) => p.id === pendingId) : null
  const turningOff = pending?.status === 'on'

  const visible = useMemo(() => {
    const query = q.trim().toLowerCase()
    return products.filter((p) => {
      const statusOk = statusFilter === 'all' || p.status === statusFilter
      const textOk =
        !query ||
        p.code.toLowerCase().includes(query) ||
        p.name.toLowerCase().includes(query) ||
        p.blurb.toLowerCase().includes(query)
      return statusOk && textOk
    })
  }, [products, q, statusFilter])

  const onCount = products.filter((p) => p.status === 'on').length
  const offCount = products.length - onCount

  const closeDialog = () => {
    setPendingId(null)
    setReason('Campaign pause')
    setNote('')
  }

  const requestToggle = (p: Product) => {
    if (p.status === 'on') {
      setPendingId(p.id)
      return
    }
    // Turn on — light path
    applyToggle(p.id, 'on', '—')
  }

  const applyToggle = (id: string, next: ProductStatus, reasonLabel: string) => {
    const target = products.find((p) => p.id === id)
    if (!target) return
    const when = '06-Aug-2026 11:20'
    const by = 'Aye Chan'
    setProducts((prev) =>
      prev.map((p) =>
        p.id === id
          ? { ...p, status: next, changedAt: '06-Aug-2026', changedBy: by }
          : p,
      ),
    )
    setHistory((prev) => [
      {
        id: `h-${Date.now()}`,
        when,
        code: target.code,
        action: next === 'on' ? 'Turned on' : 'Turned off',
        reason: reasonLabel,
        by,
      },
      ...prev,
    ])
    closeDialog()
  }

  const confirmTurnOff = () => {
    if (!pendingId || !turningOff) return
    const label = note.trim() ? `${reason} · ${note.trim()}` : reason
    applyToggle(pendingId, 'off', label)
  }

  return (
    <div>
      <PageHeader
        title="Products"
        subtitle="Control panel · enable / disable Agency Sales catalog · Core codes"
        actions={
          <Pill tone="ok">
            {onCount} On · {offCount} Off
          </Pill>
        }
      />

      <p className="mb-3.5 text-sm text-muted">
        Master product data stays in <b className="text-deep">Core</b>. This page only gates what mobile{' '}
        <b className="text-deep">Sell → Products</b> can quote. Off products disappear on next FA sync. See{' '}
        <Link to="/management/resources" className="font-bold text-steel underline-offset-2 hover:underline">
          Resource
        </Link>{' '}
        for brochures.
      </p>

      <Card className="mb-3.5">
        <div className="flex flex-wrap items-end gap-2.5">
          <Field label="Search" className="mb-0 min-w-[220px] flex-1">
            <Input
              value={q}
              onChange={(e) => setQ(e.target.value)}
              placeholder="Code, name…"
            />
          </Field>
          <Field label="Status" className="mb-0 min-w-[160px]">
            <Select
              value={statusFilter}
              onChange={(e) => setStatusFilter(e.target.value as 'all' | ProductStatus)}
            >
              <option value="all">All</option>
              <option value="on">On</option>
              <option value="off">Off</option>
            </Select>
          </Field>
        </div>
      </Card>

      <Card title="Agency Sales catalog" className="mb-3.5">
        {visible.length === 0 ? (
          <p className="py-8 text-center text-sm font-semibold text-muted">
            No products in this filter.
          </p>
        ) : (
          <DataTable headers={['Code', 'Product', 'Channel', 'Status', 'Last changed', '']}>
            {visible.map((p) => (
              <tr key={p.id}>
                <Td className="font-bold">{p.code}</Td>
                <Td>
                  <div className="font-bold">{p.name}</div>
                  <div className="text-xs text-muted">{p.blurb}</div>
                </Td>
                <Td className="text-xs text-muted">Agency Sales app</Td>
                <Td>{p.status === 'on' ? <Pill tone="ok">On</Pill> : <Pill>Off</Pill>}</Td>
                <Td className="text-xs text-muted">
                  {p.changedAt}
                  <br />
                  {p.changedBy}
                </Td>
                <Td>
                  <Button
                    variant={p.status === 'on' ? 'danger' : 'secondary'}
                    size="sm"
                    type="button"
                    onClick={() => requestToggle(p)}
                  >
                    {p.status === 'on' ? 'Turn off' : 'Turn on'}
                  </Button>
                </Td>
              </tr>
            ))}
          </DataTable>
        )}
      </Card>

      <Card title="Catalog change history">
        <DataTable headers={['When', 'Code', 'Action', 'Reason', 'By']}>
          {history.map((h) => (
            <tr key={h.id}>
              <Td>{h.when}</Td>
              <Td className="font-bold">{h.code}</Td>
              <Td>{h.action}</Td>
              <Td className="text-muted">{h.reason}</Td>
              <Td>{h.by}</Td>
            </tr>
          ))}
        </DataTable>
      </Card>

      <Dialog
        open={Boolean(pending) && turningOff}
        onClose={closeDialog}
        title={`Turn off · ${pending?.name ?? 'product'}`}
        subtitle={`${pending?.code ?? ''} · mobile Sell will hide this product`}
        footer={
          <>
            <Button variant="secondary" type="button" onClick={closeDialog}>
              Cancel
            </Button>
            <Button variant="danger" type="button" onClick={confirmTurnOff}>
              Turn off
            </Button>
          </>
        }
      >
        <p className="mb-3 text-sm text-muted">
          FAs cannot start <b className="text-deep">new quotes</b> for this product after sync. In-flight drafts
          can still submit. Pricing and Core records stay unchanged.
        </p>
        <Field label="Reason *">
          <Select value={reason} onChange={(e) => setReason(e.target.value)}>
            <option>Campaign pause</option>
            <option>Regulatory</option>
            <option>Pricing update</option>
            <option>Other</option>
          </Select>
        </Field>
        <Field label="Note" className="mb-0">
          <Input
            value={note}
            onChange={(e) => setNote(e.target.value)}
            placeholder="Optional detail for audit"
          />
        </Field>
      </Dialog>
    </div>
  )
}
