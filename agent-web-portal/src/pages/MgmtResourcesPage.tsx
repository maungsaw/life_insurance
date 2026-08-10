import { useMemo, useState } from 'react'
import {
  Button,
  Card,
  DataTable,
  Field,
  Input,
  PageHeader,
  Pill,
  Select,
  Td,
} from '@/components/ui'
import { cn } from '@/lib/cn'

type OfflinePri = 'priority' | 'ondemand' | 'online'
type DocStatus = 'live' | 'draft' | 'archived'

type Section = {
  id: string
  name: string
  visible: boolean
  offlineDefault: OfflinePri
}

type Doc = {
  id: string
  title: string
  sectionId: string
  file: string
  version: string
  offline: OfflinePri
  status: DocStatus
  updated: string
}

const SEED_SECTIONS: Section[] = [
  { id: 'brochures', name: 'Product brochures', visible: true, offlineDefault: 'priority' },
  { id: 'training', name: 'Training documents', visible: true, offlineDefault: 'ondemand' },
  { id: 'forms', name: 'Company forms', visible: true, offlineDefault: 'priority' },
]

const SEED_DOCS: Doc[] = [
  {
    id: 'd1',
    title: 'Endowment brochure',
    sectionId: 'brochures',
    file: 'endowment-mm.pdf',
    version: 'v3',
    offline: 'priority',
    status: 'live',
    updated: '28-Jul-2026',
  },
  {
    id: 'd2',
    title: 'Term life one-pager',
    sectionId: 'brochures',
    file: 'term-life.pdf',
    version: 'v1',
    offline: 'ondemand',
    status: 'live',
    updated: '12-Jul-2026',
  },
  {
    id: 'd3',
    title: 'LC Training pack',
    sectionId: 'training',
    file: 'lc-training-pack.pdf',
    version: 'v2',
    offline: 'ondemand',
    status: 'live',
    updated: '01-Aug-2026',
  },
  {
    id: 'd4',
    title: 'Claim form (blank)',
    sectionId: 'forms',
    file: 'claim-form.pdf',
    version: 'v4',
    offline: 'priority',
    status: 'live',
    updated: '20-Jul-2026',
  },
  {
    id: 'd5',
    title: 'KYC checklist',
    sectionId: 'forms',
    file: 'kyc-checklist.pdf',
    version: 'v1',
    offline: 'online',
    status: 'draft',
    updated: '03-Aug-2026',
  },
]

/* Offline column UI hidden (docs/33) — restore with table Offline Td
function offlinePill(v: OfflinePri) {
  if (v === 'priority') return <Pill tone="ok">Priority</Pill>
  if (v === 'ondemand') return <Pill>On demand</Pill>
  return <Pill tone="warn">Online only</Pill>
}
*/

function statusPill(v: DocStatus) {
  if (v === 'live') return <Pill tone="ok">Live</Pill>
  if (v === 'draft') return <Pill>Draft</Pill>
  return <Pill tone="danger">Archived</Pill>
}

/** FR-10 — Resource Library config (authorized web) */
export function MgmtResourcesPage() {
  const [sections, setSections] = useState(SEED_SECTIONS)
  const [docs, setDocs] = useState(SEED_DOCS)
  const [activeSection, setActiveSection] = useState('brochures')
  const [showSectionEditor, setShowSectionEditor] = useState(false)
  const [showUpload, setShowUpload] = useState(false)
  const [newSectionName, setNewSectionName] = useState('')

  const filteredDocs = useMemo(
    () => docs.filter((d) => d.sectionId === activeSection && d.status !== 'archived'),
    [docs, activeSection],
  )
  const activeMeta = sections.find((s) => s.id === activeSection)

  const moveSection = (id: string, dir: -1 | 1) => {
    setSections((prev) => {
      const i = prev.findIndex((s) => s.id === id)
      const j = i + dir
      if (i < 0 || j < 0 || j >= prev.length) return prev
      const copy = [...prev]
      ;[copy[i], copy[j]] = [copy[j], copy[i]]
      return copy
    })
  }

  const addSection = () => {
    const name = newSectionName.trim()
    if (!name) return
    const id = `s-${Date.now()}`
    setSections((prev) => [...prev, { id, name, visible: true, offlineDefault: 'ondemand' }])
    setNewSectionName('')
    setActiveSection(id)
  }

  return (
    <div>
      <PageHeader
        title="Resource"
        subtitle="FR-10 · Configure library sections · brochures · training · forms"
        actions={
          <>
            <Button variant="secondary" type="button" onClick={() => setShowSectionEditor((v) => !v)}>
              {showSectionEditor ? 'Hide sections' : 'Configure sections'}
            </Button>
            <Button type="button" onClick={() => setShowUpload(true)}>
              Upload document
            </Button>
          </>
        }
      />

      <div className="grid gap-3.5 lg:grid-cols-[240px_1fr]">
        <Card title="Sections" className="h-fit">
          <p className="mb-3 text-xs text-muted">
            Mobile chips follow <b className="text-deep">visible</b> order.
            {/* Offline default seeds new uploads. — hidden with Offline column (docs/33) */}
          </p>
          <ul className="space-y-1">
            {sections.map((s) => (
              <li key={s.id}>
                <button
                  type="button"
                  onClick={() => setActiveSection(s.id)}
                  className={cn(
                    'flex w-full items-center justify-between gap-2 rounded-xl px-3 py-2.5 text-left text-sm font-bold transition',
                    activeSection === s.id ? 'bg-sky/15 text-deep' : 'text-muted hover:bg-soft hover:text-deep',
                    !s.visible && 'opacity-50',
                  )}
                >
                  <span className="truncate">{s.name}</span>
                  {!s.visible ? <Pill>Hidden</Pill> : null}
                </button>
              </li>
            ))}
          </ul>
        </Card>

        <div className="min-w-0 space-y-3.5">
          {showSectionEditor ? (
            <Card
              title="Configure sections"
              action={<span className="text-xs font-semibold text-muted">Web → mobile sync</span>}
            >
              {/* Offline default column hidden for now — restore header + Td below when needed */}
              <DataTable headers={['Order', 'Name', 'Visible', /* 'Offline default', */ 'Actions']}>
                {sections.map((s, idx) => (
                  <tr key={s.id}>
                    <Td>{idx + 1}</Td>
                    <Td>
                      <Input
                        className="min-w-[160px]"
                        value={s.name}
                        onChange={(e) =>
                          setSections((prev) =>
                            prev.map((x) => (x.id === s.id ? { ...x, name: e.target.value } : x)),
                          )
                        }
                      />
                    </Td>
                    <Td>
                      <button
                        type="button"
                        className="text-sm font-bold text-steel underline-offset-2 hover:underline"
                        onClick={() =>
                          setSections((prev) =>
                            prev.map((x) => (x.id === s.id ? { ...x, visible: !x.visible } : x)),
                          )
                        }
                      >
                        {s.visible ? 'On' : 'Off'}
                      </button>
                    </Td>
                    {/* <Td>
                      <Select
                        value={s.offlineDefault}
                        onChange={(e) =>
                          setSections((prev) =>
                            prev.map((x) =>
                              x.id === s.id
                                ? { ...x, offlineDefault: e.target.value as OfflinePri }
                                : x,
                            ),
                          )
                        }
                      >
                        <option value="priority">Priority cache</option>
                        <option value="ondemand">On demand</option>
                        <option value="online">Online only</option>
                      </Select>
                    </Td> */}
                    <Td>
                      <div className="flex gap-1">
                        <Button variant="ghost" type="button" onClick={() => moveSection(s.id, -1)}>
                          ↑
                        </Button>
                        <Button variant="ghost" type="button" onClick={() => moveSection(s.id, 1)}>
                          ↓
                        </Button>
                      </div>
                    </Td>
                  </tr>
                ))}
              </DataTable>
              <div className="mt-3 flex flex-wrap items-end gap-2">
                <Field label="New section" className="mb-0 min-w-[200px] flex-1">
                  <Input
                    value={newSectionName}
                    onChange={(e) => setNewSectionName(e.target.value)}
                    placeholder="e.g. Compliance packs"
                  />
                </Field>
                <Button type="button" onClick={addSection}>
                  Add section
                </Button>
              </div>
            </Card>
          ) : null}

          <Card
            title={activeMeta ? activeMeta.name : 'Documents'}
            /* action count + offline hint hidden (docs/33)
            action={
              <span className="text-xs font-semibold text-muted">
                {filteredDocs.length} live/draft · FA offline uses Priority first
              </span>
            }
            */
          >
            {filteredDocs.length === 0 ? (
              <p className="py-8 text-center text-sm font-semibold text-muted">
                No documents in this section yet. Upload a brochure, training pack, or form.
              </p>
            ) : (
              /* Offline column hidden for now — restore header + Td when needed (docs/33) */
              <DataTable headers={['Title', 'File', 'Version', /* 'Offline', */ 'Status', 'Updated']}>
                {filteredDocs.map((d) => (
                  <tr key={d.id}>
                    <Td className="font-bold">{d.title}</Td>
                    <Td className="text-muted">{d.file}</Td>
                    <Td>{d.version}</Td>
                    {/* <Td>{offlinePill(d.offline)}</Td> */}
                    <Td>{statusPill(d.status)}</Td>
                    <Td>{d.updated}</Td>
                  </tr>
                ))}
              </DataTable>
            )}
          </Card>

          {showUpload ? (
            <Card
              title="Upload / replace document"
              action={
                <Button variant="ghost" type="button" onClick={() => setShowUpload(false)}>
                  Close
                </Button>
              }
            >
              <div className="grid gap-3 md:grid-cols-2">
                <Field label="Title *">
                  <Input defaultValue="New brochure" />
                </Field>
                <Field label="Section *">
                  <Select defaultValue={activeSection} onChange={(e) => setActiveSection(e.target.value)}>
                    {sections.map((s) => (
                      <option key={s.id} value={s.id}>
                        {s.name}
                      </option>
                    ))}
                  </Select>
                </Field>
                <Field label="File *">
                  <Input type="file" accept=".pdf,image/*" />
                </Field>
                {/* Offline priority field hidden with Offline column (docs/33)
                <Field label="Offline priority">
                  <Select defaultValue={activeMeta?.offlineDefault ?? 'ondemand'}>
                    <option value="priority">Priority (prefetch on Wi‑Fi)</option>
                    <option value="ondemand">On demand</option>
                    <option value="online">Online only</option>
                  </Select>
                </Field>
                */}
                <Field label="Status">
                  <Select defaultValue="draft">
                    <option value="draft">Draft</option>
                    <option value="live">Live</option>
                  </Select>
                </Field>
                <Field label="Audience">
                  <Select>
                    <option>All FAs</option>
                    <option>Managers only</option>
                    <option>Yangon district</option>
                  </Select>
                </Field>
              </div>
              <div className="mt-1 flex gap-2">
                <Button
                  type="button"
                  onClick={() => {
                    setDocs((prev) => [
                      {
                        id: `d-${Date.now()}`,
                        title: 'New brochure',
                        sectionId: activeSection,
                        file: 'upload.pdf',
                        version: 'v1',
                        offline: activeMeta?.offlineDefault ?? 'ondemand',
                        status: 'draft',
                        updated: '04-Aug-2026',
                      },
                      ...prev,
                    ])
                    setShowUpload(false)
                  }}
                >
                  Save document
                </Button>
                <Button variant="secondary" type="button" onClick={() => setShowUpload(false)}>
                  Cancel
                </Button>
              </div>
            </Card>
          ) : null}
        </div>
      </div>
    </div>
  )
}
