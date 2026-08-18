import { useState } from 'react'
import { Link, Navigate, useLocation, useNavigate, useParams } from 'react-router-dom'
import { Button, Card, Dialog, Field, Input, PageHeader, Pill, Select, Textarea } from '@/components/ui'
import { useCatalog } from '@/data/CatalogContext'
import {
  CATALOG_DOCS,
  codeError,
  emptyDraft,
  inFlight,
  normalizeCode,
  OFF_REASONS,
  PRODUCT_LINES,
  SCHEMA_PACKS,
  type CatalogProduct,
  type ProductLine,
  type SchemaPack,
} from '@/data/hqCatalog'
import { fromDateInput, toDateInput } from '@/lib/formatDate'

export function MgmtProductSetupPage() {
  const { id } = useParams()
  const { pathname } = useLocation()
  const nav = useNavigate()
  const { products, byId, create, update, setGate, archive, unarchive, duplicate } = useCatalog()
  const isNew = pathname.endsWith('/products/new') || id === 'new'
  const found = isNew ? undefined : id ? byId(id) : undefined

  const [draft, setDraft] = useState<CatalogProduct>(() => found ?? emptyDraft())
  const [saved, setSaved] = useState(false)
  const [err, setErr] = useState('')
  const [archiveOpen, setArchiveOpen] = useState(false)
  const [offOpen, setOffOpen] = useState(false)
  const [reason, setReason] = useState<string>(OFF_REASONS[0])
  const [note, setNote] = useState('')

  if (!isNew && !found) return <Navigate to="/management/products" replace />

  const codeLocked = !isNew
  const codeIssue = codeError(normalizeCode(draft.code), products, found?.id)

  const toggleDoc = (docId: string) => {
    setDraft((d) => ({
      ...d,
      resourceIds: d.resourceIds.includes(docId)
        ? d.resourceIds.filter((x) => x !== docId)
        : [...d.resourceIds, docId],
    }))
  }

  const persist = () => {
    const code = normalizeCode(draft.code)
    const issue = codeError(code, products, found?.id)
    if (issue) {
      setErr(issue)
      return
    }
    if (!draft.name.trim()) {
      setErr('Name is required.')
      return
    }
    const payload: CatalogProduct = {
      ...draft,
      code,
      name: draft.name.trim(),
      tagline: draft.tagline.trim(),
      commissionCategory: draft.commissionCategory.trim() || draft.line,
    }
    if (isNew) {
      const created = create(payload)
      nav(`/management/products/${created.id}`, { replace: true })
      return
    }
    update(found!.id, payload, 'Setup saved')
    setSaved(true)
    setErr('')
    setTimeout(() => setSaved(false), 2500)
  }

  const thinCopy = !draft.about.trim()

  return (
    <div>
      <PageHeader
        title={isNew ? 'Add product' : draft.name || found?.name || 'Setup'}
        subtitle={
          isNew
            ? 'New Agency Sales SKU · starts Off · pick a schema pack · no calculator here'
            : `${found?.code} · setup · ${found?.status}`
        }
        actions={
          <div className="flex flex-wrap gap-2">
            <Link to="/management/products">
              <Button variant="secondary" type="button">
                Back to catalog
              </Button>
            </Link>
            {!isNew && found ? (
              <Button
                variant="secondary"
                type="button"
                onClick={() => {
                  const copy = duplicate(found.id)
                  if (copy) nav(`/management/products/${copy.id}`)
                }}
              >
                Duplicate
              </Button>
            ) : null}
            <Button type="button" onClick={persist} disabled={Boolean(codeIssue) || !draft.name.trim()}>
              {isNew ? 'Create SKU' : 'Save setup'}
            </Button>
          </div>
        }
      />

      {err ? <p className="mb-3 text-xs font-semibold text-danger">{err}</p> : null}
      {saved ? <p className="mb-3 text-xs font-semibold text-ok">Setup saved · audit row written.</p> : null}
      {thinCopy ? (
        <p className="mb-3 text-xs font-semibold text-muted">About is empty — FA product detail will look thin.</p>
      ) : null}

      <div className="grid gap-3.5 lg:grid-cols-2">
        <Card title="Identity">
          <Field label="Core code *">
            <Input
              value={draft.code}
              disabled={codeLocked}
              onChange={(e) => setDraft((d) => ({ ...d, code: normalizeCode(e.target.value) }))}
              placeholder="UL"
            />
          </Field>
          {codeLocked ? <p className="mb-3 text-xs text-muted">Code is locked after create. New SKU if Core code changes.</p> : null}
          {codeIssue && isNew ? <p className="mb-3 text-xs font-semibold text-danger">{codeIssue}</p> : null}
          <Field label="Name *">
            <Input value={draft.name} onChange={(e) => setDraft((d) => ({ ...d, name: e.target.value }))} />
          </Field>
          <Field label="Line *">
            <Select
              value={draft.line}
              onChange={(e) => {
                const line = e.target.value as ProductLine
                setDraft((d) => ({
                  ...d,
                  line,
                  commissionCategory: d.commissionCategory === d.line ? line : d.commissionCategory,
                }))
              }}
            >
              {PRODUCT_LINES.map((l) => (
                <option key={l}>{l}</option>
              ))}
            </Select>
          </Field>
          <Field label="Channel" className="mb-0">
            <Input value="Agency Sales app" disabled />
          </Field>
        </Card>

        <Card
          title="Availability"
          action={
            found ? (
              found.status === 'on' ? (
                <Pill tone="ok">On</Pill>
              ) : found.status === 'off' ? (
                <Pill>Off</Pill>
              ) : (
                <Pill tone="danger">Archived</Pill>
              )
            ) : (
              <Pill>Off on create</Pill>
            )
          }
        >
          <Field label="Effective from (optional)">
            <Input
              type="date"
              value={toDateInput(draft.effectiveFrom)}
              onChange={(e) => setDraft((d) => ({ ...d, effectiveFrom: fromDateInput(e.target.value) }))}
            />
          </Field>
          <p className="mb-3 text-xs text-muted">
            In-flight quotes {found?.inFlightQuotes ?? 0} · e-Apps {found?.inFlightEapps ?? 0}. Off does not cancel them.
          </p>
          {found && found.status !== 'archived' ? (
            <div className="flex flex-wrap gap-2">
              {found.status === 'on' ? (
                <Button variant="danger" size="sm" type="button" onClick={() => setOffOpen(true)}>
                  Turn off
                </Button>
              ) : (
                <Button size="sm" type="button" onClick={() => setGate(found.id, 'on', '—')}>
                  Turn on
                </Button>
              )}
              <Button variant="secondary" size="sm" type="button" className="text-danger" onClick={() => setArchiveOpen(true)}>
                Archive
              </Button>
            </div>
          ) : null}
          {found?.status === 'archived' ? (
            <Button size="sm" type="button" onClick={() => unarchive(found.id)}>
              Unarchive to Off
            </Button>
          ) : null}
          {isNew ? <p className="text-xs text-muted">New SKUs start Off. Turn on from the catalog after review.</p> : null}
        </Card>

        <Card title="Sell copy" className="lg:col-span-2">
          <Field label="Tagline">
            <Input value={draft.tagline} onChange={(e) => setDraft((d) => ({ ...d, tagline: e.target.value }))} />
          </Field>
          <Field label="About">
            <Textarea rows={3} value={draft.about} onChange={(e) => setDraft((d) => ({ ...d, about: e.target.value }))} />
          </Field>
          <div className="grid gap-0 sm:grid-cols-2 sm:gap-3">
            <Field label="Who should">
              <Textarea rows={2} value={draft.whoShould} onChange={(e) => setDraft((d) => ({ ...d, whoShould: e.target.value }))} />
            </Field>
            <Field label="Why buy">
              <Textarea rows={2} value={draft.whyBuy} onChange={(e) => setDraft((d) => ({ ...d, whyBuy: e.target.value }))} />
            </Field>
            <Field label="Coverage">
              <Textarea rows={2} value={draft.coverage} onChange={(e) => setDraft((d) => ({ ...d, coverage: e.target.value }))} />
            </Field>
            <Field label="Eligible">
              <Textarea rows={2} value={draft.eligible} onChange={(e) => setDraft((d) => ({ ...d, eligible: e.target.value }))} />
            </Field>
          </div>
        </Card>

        <Card title="Quote setup">
          <p className="mb-3 text-xs text-muted">Named pack from FR-04 (`65`). This is not a live premium calculator.</p>
          <Field label="Schema pack *">
            <Select
              value={draft.schemaPack}
              onChange={(e) => setDraft((d) => ({ ...d, schemaPack: e.target.value as SchemaPack }))}
            >
              {SCHEMA_PACKS.map((s) => (
                <option key={s}>{s}</option>
              ))}
            </Select>
          </Field>
          <Field label="Variants">
            <Input value={draft.variants} onChange={(e) => setDraft((d) => ({ ...d, variants: e.target.value }))} />
          </Field>
          <Field label="Frequencies">
            <Input value={draft.frequencies} onChange={(e) => setDraft((d) => ({ ...d, frequencies: e.target.value }))} />
          </Field>
          <Field label="Terms">
            <Input value={draft.terms} onChange={(e) => setDraft((d) => ({ ...d, terms: e.target.value }))} />
          </Field>
          <div className="grid gap-0 sm:grid-cols-2 sm:gap-3">
            <Field label="Default SI">
              <Input value={draft.defaultSi} onChange={(e) => setDraft((d) => ({ ...d, defaultSi: e.target.value }))} />
            </Field>
            <Field label="Default top-up" className="mb-0">
              <Input value={draft.defaultTopup} onChange={(e) => setDraft((d) => ({ ...d, defaultTopup: e.target.value }))} />
            </Field>
          </div>
        </Card>

        <Card title="Documents + commission">
          <p className="mb-2 text-xs text-muted">
            Files stay in{' '}
            <Link to="/management/resources" className="font-bold text-steel">
              Resource
            </Link>
            . Link titles only.
          </p>
          <ul className="mb-3 space-y-1.5">
            {CATALOG_DOCS.map((doc) => (
              <li key={doc.id}>
                <label className="flex items-center gap-2 text-sm font-semibold text-deep">
                  <input
                    type="checkbox"
                    checked={draft.resourceIds.includes(doc.id)}
                    onChange={() => toggleDoc(doc.id)}
                  />
                  {doc.title}
                </label>
              </li>
            ))}
          </ul>
          <Field label="Commission report category" className="mb-0">
            <Input
              value={draft.commissionCategory}
              onChange={(e) => setDraft((d) => ({ ...d, commissionCategory: e.target.value }))}
              placeholder="Same as line unless mapped"
            />
          </Field>
        </Card>
      </div>

      <Dialog
        open={offOpen}
        onClose={() => setOffOpen(false)}
        title={`Turn off · ${found?.name ?? ''}`}
        subtitle="Mobile Sell hides new quotes after sync"
        footer={
          <>
            <Button variant="secondary" type="button" onClick={() => setOffOpen(false)}>
              Cancel
            </Button>
            <Button
              variant="danger"
              type="button"
              onClick={() => {
                if (!found) return
                setGate(found.id, 'off', note.trim() ? `${reason} · ${note.trim()}` : reason)
                setOffOpen(false)
              }}
            >
              Turn off
            </Button>
          </>
        }
      >
        <Field label="Reason *">
          <Select value={reason} onChange={(e) => setReason(e.target.value)}>
            {OFF_REASONS.map((r) => (
              <option key={r}>{r}</option>
            ))}
          </Select>
        </Field>
        <Field label="Note" className="mb-0">
          <Input value={note} onChange={(e) => setNote(e.target.value)} />
        </Field>
      </Dialog>

      <Dialog
        open={archiveOpen}
        onClose={() => setArchiveOpen(false)}
        title={`Archive · ${found?.name ?? ''}`}
        subtitle="Soft-delete · unarchive returns Off"
        footer={
          <>
            <Button variant="secondary" type="button" onClick={() => setArchiveOpen(false)}>
              Cancel
            </Button>
            <Button
              variant="danger"
              type="button"
              disabled={found?.status === 'on'}
              onClick={() => {
                if (!found) return
                const result = archive(found.id, note.trim() ? `${reason} · ${note.trim()}` : reason)
                setArchiveOpen(false)
                if (result.ok) nav('/management/products')
                else setErr(result.message ?? 'Cannot archive')
              }}
            >
              Archive
            </Button>
          </>
        }
      >
        {found?.status === 'on' ? (
          <p className="text-sm text-danger">Turn off first, then archive.</p>
        ) : found && inFlight(found) ? (
          <p className="mb-3 text-sm text-danger">
            In-flight quotes {found.inFlightQuotes} · e-Apps {found.inFlightEapps}. Policies keep this name.
          </p>
        ) : (
          <p className="mb-3 text-sm text-muted">Not a hard delete.</p>
        )}
        {found?.status !== 'on' ? (
          <Field label="Reason *" className="mb-0">
            <Select value={reason} onChange={(e) => setReason(e.target.value)}>
              {OFF_REASONS.map((r) => (
                <option key={r}>{r}</option>
              ))}
            </Select>
          </Field>
        ) : null}
      </Dialog>
    </div>
  )
}
