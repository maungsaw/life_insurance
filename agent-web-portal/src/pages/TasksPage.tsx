import { useMemo, useState, type DragEvent } from 'react'
import { useSearchParams } from 'react-router-dom'
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
  Textarea,
} from '@/components/ui'
import { cn } from '@/lib/cn'

type Status = 'pending' | 'progress' | 'completed'
type TaskType = 'Leave appointment' | 'Servicing' | 'e-App' | 'On-Boarding' | 'Other'

type Task = {
  id: string
  title: string
  assignee: string
  type: TaskType
  due: string
  dueIso: string
  status: Status
  notes: string
  agentName?: string
  nrc?: string
  trainingModule?: string
}

const COLUMNS: { id: Status; label: string; hint: string }[] = [
  { id: 'pending', label: 'Pending', hint: 'Not started' },
  { id: 'progress', label: 'In Progress', hint: 'Active work' },
  { id: 'completed', label: 'Completed', hint: 'Done' },
]

const SEED: Task[] = [
  {
    id: 't1',
    title: 'Leave appointment · Su Su',
    assignee: 'Aye Chan',
    type: 'Leave appointment',
    due: '06-Aug-2026',
    dueIso: '2026-08-06',
    status: 'progress',
    notes: 'Home visit confirmed · bring brochure pack.',
  },
  {
    id: 't2',
    title: 'Premium chase · Daw Hla',
    assignee: 'Aye Chan',
    type: 'Servicing',
    due: '10-Aug-2026',
    dueIso: '2026-08-10',
    status: 'pending',
    notes: 'Due in 7 days reminder follow-up.',
  },
  {
    id: 't3',
    title: 'Branch leave · Nwe Nwe',
    assignee: 'Nwe Nwe',
    type: 'Leave appointment',
    due: '08-Aug-2026',
    dueIso: '2026-08-08',
    status: 'pending',
    notes: 'Confirm afternoon slot at branch.',
  },
  {
    id: 't4',
    title: 'NRC correction',
    assignee: 'Aye Chan',
    type: 'e-App',
    due: '02-Aug-2026',
    dueIso: '2026-08-02',
    status: 'completed',
    notes: 'Client resubmitted clear scan.',
  },
  {
    id: 't5',
    title: 'District huddle prep',
    assignee: 'Thura Htun',
    type: 'Other',
    due: '04-Aug-2026',
    dueIso: '2026-08-04',
    status: 'progress',
    notes: 'Prep for district huddle.',
  },
  {
    id: 't6',
    title: 'Client leave · U Min',
    assignee: 'Nwe Nwe',
    type: 'Leave appointment',
    due: '01-Aug-2026',
    dueIso: '2026-08-01',
    status: 'pending',
    notes: 'Overdue — reschedule if no reply.',
  },
  {
    id: 't7',
    title: 'On-Boarding · Zaw Ko',
    assignee: 'Alliance',
    type: 'On-Boarding',
    due: '20-Aug-2026',
    dueIso: '2026-08-20',
    status: 'progress',
    notes: 'LC training pack issued.',
    agentName: 'Zaw Ko',
    nrc: '12/YGN(N)123456',
    trainingModule: 'LC Training · Module 2',
  },
  {
    id: 't8',
    title: 'NRC correction · Daw Hla',
    assignee: 'Aye Chan',
    type: 'e-App',
    due: '17-Aug-2026',
    dueIso: '2026-08-17',
    status: 'pending',
    notes: 'APP-2026-0814 · re-scan NRC front + back.',
  },
]

const TODAY = '2026-08-05'

function isOverdue(t: Task) {
  return t.status !== 'completed' && t.dueIso < TODAY
}

function typeTone(type: TaskType): 'default' | 'sky' | 'warn' | 'ok' {
  if (type === 'Leave appointment') return 'sky'
  if (type === 'Servicing') return 'warn'
  if (type === 'e-App') return 'ok'
  if (type === 'On-Boarding') return 'ok'
  return 'default'
}

function statusPill(s: Status) {
  if (s === 'completed') return <Pill tone="ok">Completed</Pill>
  if (s === 'progress') return <Pill>In Progress</Pill>
  return <Pill tone="warn">Pending</Pill>
}

export function TasksPage() {
  const [params] = useSearchParams()
  const typeFromUrl = params.get('type')
  const [tasks, setTasks] = useState(SEED)
  const [view, setView] = useState<'board' | 'list'>('board')
  const [q, setQ] = useState('')
  const [typeFilter, setTypeFilter] = useState(typeFromUrl === 'e-App' ? 'e-App' : 'all')
  const [assigneeFilter, setAssigneeFilter] = useState('all')
  const [showForm, setShowForm] = useState(false)
  const [editingId, setEditingId] = useState<string | null>(null)
  const [deleteId, setDeleteId] = useState<string | null>(null)
  const [dragId, setDragId] = useState<string | null>(null)
  const [draft, setDraft] = useState({
    title: '',
    assignee: 'Aye Chan',
    type: 'Leave appointment' as TaskType,
    dueIso: '2026-08-06',
    notes: '',
    agentName: '',
    nrc: '',
    trainingModule: 'LC Training · Module 1',
  })

  const assignees = useMemo(
    () => [...new Set(tasks.map((t) => t.assignee))].sort(),
    [tasks],
  )

  const filtered = useMemo(() => {
    const needle = q.trim().toLowerCase()
    return tasks.filter((t) => {
      const matchQ =
        !needle ||
        t.title.toLowerCase().includes(needle) ||
        t.assignee.toLowerCase().includes(needle)
      const matchType = typeFilter === 'all' || t.type === typeFilter
      const matchA = assigneeFilter === 'all' || t.assignee === assigneeFilter
      return matchQ && matchType && matchA
    })
  }, [tasks, q, typeFilter, assigneeFilter])

  const byStatus = (s: Status) => filtered.filter((t) => t.status === s)

  const [createStatus, setCreateStatus] = useState<Status>('pending')

  const startCreate = (status: Status = 'pending') => {
    setEditingId(null)
    setCreateStatus(status)
    setDraft({
      title: '',
      assignee: 'Aye Chan',
      type: 'Leave appointment',
      dueIso: '2026-08-06',
      notes: '',
      agentName: '',
      nrc: '',
      trainingModule: 'LC Training · Module 1',
    })
    setShowForm(true)
  }

  const startEdit = (t: Task) => {
    setEditingId(t.id)
    setCreateStatus(t.status)
    setDraft({
      title: t.title,
      assignee: t.assignee,
      type: t.type,
      dueIso: t.dueIso,
      notes: t.notes,
      agentName: t.agentName ?? '',
      nrc: t.nrc ?? '',
      trainingModule: t.trainingModule ?? 'LC Training · Module 1',
    })
    setShowForm(true)
  }

  const formatDue = (iso: string) => {
    const [y, m, d] = iso.split('-').map(Number)
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
    return `${String(d).padStart(2, '0')}-${months[m - 1]}-${y}`
  }

  const saveTask = () => {
    const title = draft.title.trim()
    if (!title) return
    const onboarding =
      draft.type === 'On-Boarding'
        ? {
            agentName: draft.agentName.trim(),
            nrc: draft.nrc.trim(),
            trainingModule: draft.trainingModule,
          }
        : {}
    if (editingId) {
      setTasks((prev) =>
        prev.map((t) =>
          t.id === editingId
            ? {
                ...t,
                title,
                assignee: draft.assignee,
                type: draft.type,
                dueIso: draft.dueIso,
                due: formatDue(draft.dueIso),
                notes: draft.notes,
                status: createStatus,
                ...onboarding,
              }
            : t,
        ),
      )
    } else {
      setTasks((prev) => [
        {
          id: `t-${Date.now()}`,
          title,
          assignee: draft.assignee,
          type: draft.type,
          dueIso: draft.dueIso,
          due: formatDue(draft.dueIso),
          status: createStatus,
          notes: draft.notes,
          ...onboarding,
        },
        ...prev,
      ])
    }
    setShowForm(false)
    setEditingId(null)
  }

  const deleteTask = (id: string) => {
    setTasks((prev) => prev.filter((t) => t.id !== id))
    if (editingId === id) {
      setShowForm(false)
      setEditingId(null)
    }
    setDeleteId(null)
  }

  const moveTask = (id: string, status: Status) => {
    setTasks((prev) => prev.map((t) => (t.id === id ? { ...t, status } : t)))
  }

  const onDragStart = (e: DragEvent, id: string) => {
    setDragId(id)
    e.dataTransfer.setData('text/plain', id)
    e.dataTransfer.effectAllowed = 'move'
  }

  const onDropColumn = (e: DragEvent, status: Status) => {
    e.preventDefault()
    const id = e.dataTransfer.getData('text/plain') || dragId
    if (id) moveTask(id, status)
    setDragId(null)
  }

  return (
    <div>
      <PageHeader
        title="Tasks"
        subtitle="FR-07 · Board for Add / Move / Delete · Pending · In Progress · Completed"
        actions={
          <Button type="button" onClick={() => startCreate('pending')}>
            + Add task
          </Button>
        }
      />

      <div className="mb-3 flex flex-wrap items-center gap-2">
        <div className="inline-flex rounded-full bg-soft p-1">
          {(
            [
              ['board', 'Board'],
              ['list', 'List'],
            ] as const
          ).map(([id, label]) => (
            <button
              key={id}
              type="button"
              onClick={() => setView(id)}
              className={cn(
                'rounded-full px-3.5 py-1.5 text-xs font-extrabold transition',
                view === id ? 'bg-steel text-white' : 'text-muted hover:text-deep',
              )}
            >
              {label}
            </button>
          ))}
        </div>
        <Input
          className="max-w-xs"
          value={q}
          onChange={(e) => setQ(e.target.value)}
          placeholder="Search title or assignee…"
        />
        <Select
          className="max-w-[160px]"
          value={typeFilter}
          onChange={(e) => setTypeFilter(e.target.value)}
        >
          <option value="all">All types</option>
          <option>Leave appointment</option>
          <option>Servicing</option>
          <option>e-App</option>
          <option>On-Boarding</option>
          <option>Other</option>
        </Select>
        <Select
          className="max-w-[160px]"
          value={assigneeFilter}
          onChange={(e) => setAssigneeFilter(e.target.value)}
        >
          <option value="all">All assignees</option>
          {assignees.map((a) => (
            <option key={a}>{a}</option>
          ))}
        </Select>
      </div>

      <div>
          {view === 'board' ? (
            <div className="grid gap-3 md:grid-cols-3">
              {COLUMNS.map((col) => {
                const items = byStatus(col.id)
                return (
                  <section
                    key={col.id}
                    onDragOver={(e) => e.preventDefault()}
                    onDrop={(e) => onDropColumn(e, col.id)}
                    className={cn(
                      'flex min-h-[420px] flex-col rounded-2xl border border-line bg-surface/80 p-3',
                      dragId && 'ring-1 ring-sky/30',
                    )}
                  >
                    <header className="mb-3 flex items-center justify-between gap-2 px-1">
                      <div>
                        <h3 className="text-sm font-extrabold text-deep">{col.label}</h3>
                        <p className="text-[11px] text-muted">{col.hint}</p>
                      </div>
                      <span className="grid min-w-7 place-items-center rounded-full bg-white px-2 py-0.5 text-xs font-extrabold text-baltic shadow-sm">
                        {items.length}
                      </span>
                    </header>

                    <div className="flex flex-1 flex-col gap-2.5">
                      {items.length === 0 ? (
                        <p className="rounded-xl border border-dashed border-line bg-white/60 px-3 py-6 text-center text-xs font-semibold text-muted">
                          No tasks
                        </p>
                      ) : (
                        items.map((t) => (
                          <article
                            key={t.id}
                            draggable
                            onDragStart={(e) => onDragStart(e, t.id)}
                            onDragEnd={() => setDragId(null)}
                            className={cn(
                              'cursor-grab rounded-2xl border border-line bg-card p-3 shadow-[0_10px_28px_rgba(0,53,84,0.06)] active:cursor-grabbing',
                              dragId === t.id && 'opacity-60',
                              isOverdue(t) && 'border-l-4 border-l-danger',
                            )}
                          >
                            <div className="mb-2 flex items-start justify-between gap-2">
                              <button
                                type="button"
                                className="text-left text-sm font-bold text-deep hover:text-steel"
                                onClick={() => startEdit(t)}
                              >
                                {t.title}
                              </button>
                              <button
                                type="button"
                                className="text-xs font-bold text-muted hover:text-danger"
                                title="Delete"
                                onClick={() => setDeleteId(t.id)}
                              >
                                ✕
                              </button>
                            </div>
                            <div className="mb-2.5 flex flex-wrap gap-1.5">
                              <Pill tone={typeTone(t.type)}>{t.type}</Pill>
                              {isOverdue(t) ? <Pill tone="danger">Overdue</Pill> : null}
                            </div>
                            <div className="flex items-center justify-between gap-2 text-[11px] font-semibold text-muted">
                              <span>Due {t.due}</span>
                              <span className="inline-flex items-center gap-1.5 text-deep">
                                <span className="grid size-6 place-items-center rounded-full bg-gradient-to-br from-sky to-baltic text-[10px] font-extrabold text-white">
                                  {t.assignee.charAt(0)}
                                </span>
                                {t.assignee}
                              </span>
                            </div>
                            <div className="mt-2.5 flex flex-wrap gap-1">
                              {COLUMNS.filter((c) => c.id !== t.status).map((c) => (
                                <button
                                  key={c.id}
                                  type="button"
                                  onClick={() => moveTask(t.id, c.id)}
                                  className="rounded-lg bg-soft px-2 py-1 text-[10px] font-bold text-baltic hover:bg-sky/15"
                                >
                                  → {c.label}
                                </button>
                              ))}
                            </div>
                          </article>
                        ))
                      )}
                    </div>

                    <button
                      type="button"
                      onClick={() => startCreate(col.id)}
                      className="mt-3 rounded-xl border border-dashed border-line bg-white/70 py-2.5 text-xs font-extrabold text-steel hover:border-steel/40 hover:bg-soft"
                    >
                      + Add task
                    </button>
                  </section>
                )
              })}
            </div>
          ) : (
            <Card title="Task list">
              {filtered.length === 0 ? (
                <EmptyState
                  title="No tasks in this filter"
                  hint="Clear search or type / assignee, or add a task to this board."
                  action={
                    <Button type="button" onClick={() => startCreate('pending')}>
                      + Add task
                    </Button>
                  }
                />
              ) : (
                <DataTable headers={['Task', 'Assignee', 'Type', 'Due', 'Status', '']}>
                {filtered.map((t) => (
                  <tr key={t.id}>
                    <Td>
                      <button
                        type="button"
                        className="font-bold text-deep hover:text-steel"
                        onClick={() => startEdit(t)}
                      >
                        {t.title}
                      </button>
                      {isOverdue(t) ? (
                        <div className="mt-0.5">
                          <Pill tone="danger">Overdue</Pill>
                        </div>
                      ) : null}
                    </Td>
                    <Td>{t.assignee}</Td>
                    <Td>
                      <Pill tone={typeTone(t.type)}>{t.type}</Pill>
                    </Td>
                    <Td>{t.due}</Td>
                    <Td>{statusPill(t.status)}</Td>
                    <Td>
                      <div className="flex gap-1">
                        <Button variant="ghost" size="sm" type="button" onClick={() => startEdit(t)}>
                          Edit
                        </Button>
                        <Button
                          variant="ghost"
                          size="sm"
                          type="button"
                          className="text-danger"
                          onClick={() => setDeleteId(t.id)}
                        >
                          Delete
                        </Button>
                      </div>
                    </Td>
                  </tr>
                ))}
              </DataTable>
              )}
            </Card>
          )}
      </div>

      <Dialog
        open={showForm}
        onClose={() => {
          setShowForm(false)
          setEditingId(null)
        }}
        title={editingId ? 'Edit task' : 'Add task'}
        subtitle="FR-07 · assign FA · type · due · status"
        footer={
          <>
            <Button
              variant="secondary"
              type="button"
              onClick={() => {
                setShowForm(false)
                setEditingId(null)
              }}
            >
              Cancel
            </Button>
            {editingId ? (
              <Button variant="danger" type="button" onClick={() => setDeleteId(editingId)}>
                Delete
              </Button>
            ) : null}
            <Button type="button" onClick={saveTask} disabled={!draft.title.trim()}>
              {editingId ? 'Save changes' : 'Create task'}
            </Button>
          </>
        }
      >
        <Field label="Title *">
          <Input
            autoFocus
            value={draft.title}
            onChange={(e) => setDraft((d) => ({ ...d, title: e.target.value }))}
            placeholder="e.g. Leave appointment · Su Su"
          />
        </Field>
        <div className="grid gap-0 sm:grid-cols-2 sm:gap-3">
          <Field label="Assignee FA">
            <Select
              value={draft.assignee}
              onChange={(e) => setDraft((d) => ({ ...d, assignee: e.target.value }))}
            >
              {['Aye Chan', 'Nwe Nwe', 'Thura Htun', 'Zaw Ko'].map((a) => (
                <option key={a}>{a}</option>
              ))}
            </Select>
          </Field>
          <Field label="Type">
            <Select
              value={draft.type}
              onChange={(e) => setDraft((d) => ({ ...d, type: e.target.value as TaskType }))}
            >
              <option>Leave appointment</option>
              <option>Servicing</option>
              <option>e-App</option>
              <option>On-Boarding</option>
              <option>Other</option>
            </Select>
          </Field>
          <Field label="Due date">
            <Input
              type="date"
              value={draft.dueIso}
              onChange={(e) => setDraft((d) => ({ ...d, dueIso: e.target.value }))}
            />
          </Field>
          <Field label="Status">
            <Select
              value={createStatus}
              onChange={(e) => setCreateStatus(e.target.value as Status)}
            >
              <option value="pending">Pending</option>
              <option value="progress">In Progress</option>
              <option value="completed">Completed</option>
            </Select>
          </Field>
        </div>
        {draft.type === 'On-Boarding' ? (
          <div className="mb-3 rounded-xl border border-line bg-soft/50 p-3">
            <p className="mb-2 text-xs font-extrabold text-muted uppercase">Agent Info · Training (docs/76)</p>
            <div className="grid gap-0 sm:grid-cols-2 sm:gap-3">
              <Field label="Agent name *">
                <Input
                  value={draft.agentName}
                  onChange={(e) => setDraft((d) => ({ ...d, agentName: e.target.value }))}
                />
              </Field>
              <Field label="NRC / Passport">
                <Input
                  value={draft.nrc}
                  onChange={(e) => setDraft((d) => ({ ...d, nrc: e.target.value }))}
                  placeholder="12/YGN(N)123456"
                />
              </Field>
              <Field label="Training module" className="sm:col-span-2">
                <Select
                  value={draft.trainingModule}
                  onChange={(e) => setDraft((d) => ({ ...d, trainingModule: e.target.value }))}
                >
                  <option>LC Training · Module 1</option>
                  <option>LC Training · Module 2</option>
                  <option>Structure interview</option>
                </Select>
              </Field>
            </div>
          </div>
        ) : null}
        <Field label="Notes" className="mb-0">
          <Textarea
            rows={3}
            value={draft.notes}
            onChange={(e) => setDraft((d) => ({ ...d, notes: e.target.value }))}
            placeholder="Optional context for the FA"
          />
        </Field>
      </Dialog>

      <Dialog
        open={deleteId !== null}
        onClose={() => setDeleteId(null)}
        title="Delete task?"
        subtitle="FR-07 · this cannot be undone in the prototype"
        footer={
          <>
            <Button variant="secondary" type="button" onClick={() => setDeleteId(null)}>
              Cancel
            </Button>
            <Button variant="danger" type="button" onClick={() => deleteId && deleteTask(deleteId)}>
              Delete
            </Button>
          </>
        }
      >
        <p className="text-sm text-muted">
          The FA will no longer see this assignment on My work after the next sync.
        </p>
      </Dialog>
    </div>
  )
}
