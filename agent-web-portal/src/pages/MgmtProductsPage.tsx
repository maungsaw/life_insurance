import { useMemo, useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import {
  Button,
  Card,
  DataTable,
  Dialog,
  EmptyState,
  Field,
  Input,
  PageHeader,
  Pill,
  Select,
  Td,
} from '@/components/ui'
import { useCatalog } from '@/data/CatalogContext'
import { inFlight, OFF_REASONS, type CatalogProduct, type ProductGate } from '@/data/hqCatalog'

type ListFilter = 'all' | ProductGate

function gatePill(s: ProductGate) {
  if (s === 'on') return <Pill tone="ok">On</Pill>
  if (s === 'off') return <Pill>Off</Pill>
  return <Pill tone="danger">Archived</Pill>
}

export function MgmtProductsPage() {
  const nav = useNavigate()
  const { products, history, setGate, archive, unarchive, duplicate } = useCatalog()
  const [q, setQ] = useState('')
  const [statusFilter, setStatusFilter] = useState<ListFilter>('all')
  const [pendingOff, setPendingOff] = useState<CatalogProduct | null>(null)
  const [pendingArchive, setPendingArchive] = useState<CatalogProduct | null>(null)
  const [reason, setReason] = useState<string>(OFF_REASONS[0])
  const [note, setNote] = useState('')
  const [guard, setGuard] = useState('')

  const visible = useMemo(() => {
    const query = q.trim().toLowerCase()
    return products.filter((p) => {
      const statusOk =
        statusFilter === 'all' ? p.status !== 'archived' : p.status === statusFilter
      const textOk =
        !query ||
        p.code.toLowerCase().includes(query) ||
        p.name.toLowerCase().includes(query) ||
        p.tagline.toLowerCase().includes(query) ||
        p.line.toLowerCase().includes(query)
      return statusOk && textOk
    })
  }, [products, q, statusFilter])

  const onCount = products.filter((p) => p.status === 'on').length
  const offCount = products.filter((p) => p.status === 'off').length
  const archivedCount = products.filter((p) => p.status === 'archived').length

  const closeDialogs = () => {
    setPendingOff(null)
    setPendingArchive(null)
    setReason(OFF_REASONS[0])
    setNote('')
  }

  const requestToggle = (p: CatalogProduct) => {
    setGuard('')
    if (p.status === 'archived') {
      setGuard('Unarchive first. SKU returns as Off.')
      return
    }
    if (p.status === 'on') {
      setPendingOff(p)
      return
    }
    setGate(p.id, 'on', '—')
  }

  const requestArchive = (p: CatalogProduct) => {
    setGuard('')
    if (p.status === 'on') {
      setGuard('Turn off before archive. Off hides new quotes; archive removes the SKU from the live catalog.')
      return
    }
    setPendingArchive(p)
  }

  const confirmTurnOff = () => {
    if (!pendingOff) return
    const label = note.trim() ? `${reason} · ${note.trim()}` : reason
    setGate(pendingOff.id, 'off', label)
    closeDialogs()
  }

  const confirmArchive = () => {
    if (!pendingArchive) return
    const label = note.trim() ? `${reason} · ${note.trim()}` : reason
    const result = archive(pendingArchive.id, label)
    if (!result.ok) setGuard(result.message ?? 'Cannot archive')
    closeDialogs()
  }

  return (
    <div>
      <PageHeader
        title="Products"
        subtitle="Agency Sales catalog · CRUD setup · On/Off gate · Core codes"
        actions={
          <div className="flex flex-wrap items-center gap-2">
            <Pill tone="ok">
              {onCount} On · {offCount} Off · {archivedCount} Archived
            </Pill>
            <Link to="/management/products/new">
              <Button type="button">+ Add product</Button>
            </Link>
          </div>
        }
      />

      <p className="mb-3.5 text-sm text-muted">
        Setup writes the <b className="text-deep">Agency Sales SKU</b> (copy, schema pack, brochure link). Pricing stays
        in Core. Off hides <b className="text-deep">new</b> quotes on mobile Sell after sync; in-flight e-Apps still
        submit. Archive is soft-delete — not the Off switch. Brochures live in{' '}
        <Link to="/management/resources" className="font-bold text-steel underline-offset-2 hover:underline">
          Resource
        </Link>
        . No quote calculator on this desk.
      </p>

      {guard ? <p className="mb-3 text-xs font-semibold text-danger">{guard}</p> : null}

      <Card className="mb-3.5">
        <div className="flex flex-wrap items-end gap-2.5">
          <Field label="Search" className="mb-0 min-w-[220px] flex-1">
            <Input value={q} onChange={(e) => setQ(e.target.value)} placeholder="Code, name, line…" />
          </Field>
          <Field label="Status" className="mb-0 min-w-[160px]">
            <Select value={statusFilter} onChange={(e) => setStatusFilter(e.target.value as ListFilter)}>
              <option value="all">Live (On + Off)</option>
              <option value="on">On</option>
              <option value="off">Off</option>
              <option value="archived">Archived</option>
            </Select>
          </Field>
        </div>
      </Card>

      <Card title="Agency Sales catalog" className="mb-3.5">
        {visible.length === 0 ? (
          <EmptyState
            title="No products in this filter"
            hint="Add a catalog SKU or clear search. Archived rows live under the Archived filter."
            action={
              <Link to="/management/products/new">
                <Button type="button">+ Add product</Button>
              </Link>
            }
          />
        ) : (
          <DataTable headers={['Code', 'Product', 'Line', 'Pack', 'Status', 'Last changed', '']}>
            {visible.map((p) => (
              <tr key={p.id}>
                <Td className="font-bold">{p.code}</Td>
                <Td>
                  <Link to={`/management/products/${p.id}`} className="font-bold text-steel hover:underline">
                    {p.name}
                  </Link>
                  <div className="text-xs text-muted">{p.tagline}</div>
                  {p.effectiveFrom ? (
                    <div className="text-[11px] text-muted">Effective {p.effectiveFrom}</div>
                  ) : null}
                </Td>
                <Td className="text-xs text-muted">{p.line}</Td>
                <Td className="text-xs text-muted">{p.schemaPack}</Td>
                <Td>{gatePill(p.status)}</Td>
                <Td className="text-xs text-muted">
                  {p.changedAt}
                  <br />
                  {p.changedBy}
                </Td>
                <Td>
                  <div className="flex flex-wrap gap-1">
                    <Link to={`/management/products/${p.id}`}>
                      <Button variant="ghost" size="sm" type="button">
                        Setup
                      </Button>
                    </Link>
                    {p.status === 'archived' ? (
                      <Button size="sm" variant="secondary" type="button" onClick={() => unarchive(p.id)}>
                        Unarchive
                      </Button>
                    ) : (
                      <Button
                        variant={p.status === 'on' ? 'danger' : 'secondary'}
                        size="sm"
                        type="button"
                        onClick={() => requestToggle(p)}
                      >
                        {p.status === 'on' ? 'Turn off' : 'Turn on'}
                      </Button>
                    )}
                    {p.status !== 'archived' ? (
                      <Button variant="ghost" size="sm" type="button" className="text-danger" onClick={() => requestArchive(p)}>
                        Archive
                      </Button>
                    ) : null}
                    <Button
                      variant="ghost"
                      size="sm"
                      type="button"
                      onClick={() => {
                        const copy = duplicate(p.id)
                        if (copy) nav(`/management/products/${copy.id}`)
                      }}
                    >
                      Duplicate
                    </Button>
                  </div>
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
              <Td className="text-xs">{h.when}</Td>
              <Td className="font-bold">{h.code}</Td>
              <Td>{h.action}</Td>
              <Td className="text-muted">{h.reason}</Td>
              <Td>{h.by}</Td>
            </tr>
          ))}
        </DataTable>
      </Card>

      <Dialog
        open={pendingOff !== null}
        onClose={closeDialogs}
        title={`Turn off · ${pendingOff?.name ?? 'product'}`}
        subtitle={`${pendingOff?.code ?? ''} · mobile Sell will hide new quotes`}
        footer={
          <>
            <Button variant="secondary" type="button" onClick={closeDialogs}>
              Cancel
            </Button>
            <Button variant="danger" type="button" onClick={confirmTurnOff}>
              Turn off
            </Button>
          </>
        }
      >
        <p className="mb-3 text-sm text-muted">
          FAs cannot start <b className="text-deep">new quotes</b> after sync. In-flight drafts can still submit. Pricing
          and issued policies stay unchanged.
        </p>
        <Field label="Reason *">
          <Select value={reason} onChange={(e) => setReason(e.target.value)}>
            {OFF_REASONS.map((r) => (
              <option key={r}>{r}</option>
            ))}
          </Select>
        </Field>
        <Field label="Note" className="mb-0">
          <Input value={note} onChange={(e) => setNote(e.target.value)} placeholder="Optional detail for audit" />
        </Field>
      </Dialog>

      <Dialog
        open={pendingArchive !== null}
        onClose={closeDialogs}
        title={`Archive · ${pendingArchive?.name ?? 'product'}`}
        subtitle={`${pendingArchive?.code ?? ''} · soft-delete from the live catalog`}
        footer={
          <>
            <Button variant="secondary" type="button" onClick={closeDialogs}>
              Cancel
            </Button>
            <Button variant="danger" type="button" onClick={confirmArchive}>
              Archive
            </Button>
          </>
        }
      >
        {pendingArchive && inFlight(pendingArchive) ? (
          <p className="mb-3 rounded-xl border border-danger/30 bg-red-50 px-3 py-2 text-sm text-danger">
            In-flight: {pendingArchive.inFlightQuotes} quote(s) · {pendingArchive.inFlightEapps} e-App(s). Archive hides
            the SKU from HQ live list; old policies keep this product name.
          </p>
        ) : (
          <p className="mb-3 text-sm text-muted">
            Not a hard delete. Unarchive returns the SKU as <b className="text-deep">Off</b>. Issued policies keep the
            name.
          </p>
        )}
        <Field label="Reason *">
          <Select value={reason} onChange={(e) => setReason(e.target.value)}>
            {OFF_REASONS.map((r) => (
              <option key={r}>{r}</option>
            ))}
          </Select>
        </Field>
        <Field label="Note" className="mb-0">
          <Input value={note} onChange={(e) => setNote(e.target.value)} placeholder="Optional detail for audit" />
        </Field>
      </Dialog>
    </div>
  )
}
