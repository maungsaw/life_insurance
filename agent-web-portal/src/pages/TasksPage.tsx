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
type TaskSubstatus =
  | 'New'
  | 'Assigned'
  | 'In Progress'
  | 'Follow-up Required'
  | 'Scheduled'
  | 'Waiting for Customer'
  | 'Waiting for Payment'
  | 'Waiting for Internal Team'
  | 'Submitted'
  | 'Completed'
  | 'Issued'
  | 'Delivered'
  | 'Closed'
  | 'Cancelled'
  | 'Re-opened'

type Task = {
  id: string
  title: string
  assignee: string
  type: TaskType
  due: string
  dueIso: string
  status: Status
  substatus: TaskSubstatus
  notes: string
  lastTransitionReason?: string
  agentName?: string
  nrc?: string
  trainingModule?: string
}

const COLUMNS: { id: Status; label: string; hint: string }[] = [
  { id: 'pending', label: 'Pending', hint: 'Not started' },
  { id: 'progress', label: 'In Progress', hint: 'Active work' },
  { id: 'completed', label: 'Completed', hint: 'Done' },
]

const SUBSTATUS_META: Record<TaskSubstatus, { stage: Status; tone: 'default' | 'ok' | 'warn' | 'danger' | 'sky' }> = {
  New: { stage: 'pending', tone: 'warn' },
  Assigned: { stage: 'pending', tone: 'sky' },
  'In Progress': { stage: 'progress', tone: 'default' },
  'Follow-up Required': { stage: 'progress', tone: 'warn' },
  Scheduled: { stage: 'progress', tone: 'sky' },
  'Waiting for Customer': { stage: 'progress', tone: 'warn' },
  'Waiting for Payment': { stage: 'progress', tone: 'warn' },
  'Waiting for Internal Team': { stage: 'progress', tone: 'sky' },
  Submitted: { stage: 'progress', tone: 'sky' },
  Completed: { stage: 'completed', tone: 'ok' },
  Issued: { stage: 'completed', tone: 'ok' },
  Delivered: { stage: 'completed', tone: 'ok' },
  Closed: { stage: 'completed', tone: 'default' },
  Cancelled: { stage: 'completed', tone: 'danger' },
  'Re-opened': { stage: 'pending', tone: 'danger' },
}

const SUBSTATUSES_BY_TYPE: Record<TaskType, TaskSubstatus[]> = {
  'Leave appointment': ['New', 'Assigned', 'In Progress', 'Follow-up Required', 'Scheduled', 'Completed', 'Closed'],
  Servicing: ['Assigned', 'In Progress', 'Follow-up Required', 'Waiting for Customer', 'Completed', 'Closed'],
  'e-App': ['Assigned', 'In Progress', 'Waiting for Customer', 'Submitted', 'Completed', 'Closed', 'Re-opened'],
  'On-Boarding': ['New', 'Assigned', 'In Progress', 'Waiting for Internal Team', 'Completed', 'Closed'],
  Other: ['New', 'Assigned', 'In Progress', 'Follow-up Required', 'Completed', 'Closed', 'Cancelled', 'Re-opened'],
}

const DEFAULT_SUBSTATUS_BY_STAGE: Record<Status, TaskSubstatus> = {
  pending: 'Assigned',
  progress: 'In Progress',
  completed: 'Completed',
}

function allowedSubstatuses(type: TaskType, stage: Status) {
  return SUBSTATUSES_BY_TYPE[type].filter((s) => SUBSTATUS_META[s].stage === stage)
}

function firstAllowedSubstatus(type: TaskType, stage: Status) {
  return allowedSubstatuses(type, stage)[0] ?? DEFAULT_SUBSTATUS_BY_STAGE[stage]
}

const SEED: Task[] = [
  {
    id: 't1',
    title: 'Leave appointment · Su Su',
    assignee: 'Aye Chan',
    type: 'Leave appointment',
    due: '06-Aug-2026',
    dueIso: '2026-08-06',
    status: 'progress',
    substatus: 'In Progress',
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
    substatus: 'Assigned',
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
    substatus: 'Scheduled',
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
    substatus: 'Completed',
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
    substatus: 'In Progress',
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
    substatus: 'Follow-up Required',
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
    substatus: 'Waiting for Internal Team',
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
    substatus: 'Re-opened',
    notes: 'APP-2026-0814 · re-scan NRC front + back.',
  },
]

const TODAY = '2026-08-05'
const REASON_REQUIRED_SUBSTATUSES: TaskSubstatus[] = ['Cancelled', 'Re-opened']

function isOverdue(t: Task) {
  return t.status !== 'completed' && t.dueIso < TODAY
}

function overdueDays(iso: string) {
  const due = new Date(`${iso}T00:00:00Z`).getTime()
  const today = new Date(`${TODAY}T00:00:00Z`).getTime()
  return Math.floor((today - due) / (1000 * 60 * 60 * 24))
}

function agingLabel(t: Task) {
  if (!isOverdue(t)) return null
  const days = overdueDays(t.dueIso)
  if (days >= 3) return 'SLA 72h+'
  if (days >= 2) return 'SLA 48h'
  return 'SLA 24h'
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

function substatusPill(s: TaskSubstatus) {
  return <Pill tone={SUBSTATUS_META[s].tone}>{s}</Pill>
}

function canMoveStage(task: Task, next: Status) {
  if (task.status === next) return true
  if (task.status === 'pending' && next === 'completed') return false
  if (task.substatus === 'Cancelled' && next !== 'completed') return false
  return true
}

function canApplySubstatus(task: Task, next: TaskSubstatus) {
  if (!SUBSTATUSES_BY_TYPE[task.type].includes(next)) return false
  if (next === 'Re-opened' && task.status !== 'completed') return false
  if ((next === 'Closed' || next === 'Cancelled') && (task.substatus === 'New' || task.substatus === 'Assigned')) {
    return false
  }
  return true
}

export function TasksPage() {
  const [params] = useSearchParams()
  const typeFromUrl = params.get('type')
  const [tasks, setTasks] = useState(SEED)
  const [view, setView] = useState<'board' | 'list'>('board')
  const [q, setQ] = useState('')
  const [typeFilter, setTypeFilter] = useState(typeFromUrl === 'e-App' ? 'e-App' : 'all')
  const [assigneeFilter, setAssigneeFilter] = useState('all')
  const [substatusFilter, setSubstatusFilter] = useState<'all' | TaskSubstatus>('all')
  const [showForm, setShowForm] = useState(false)
  const [editingId, setEditingId] = useState<string | null>(null)
  const [deleteId, setDeleteId] = useState<string | null>(null)
  const [dragId, setDragId] = useState<string | null>(null)
  const [guardMsg, setGuardMsg] = useState('')
  const [reasonDialog, setReasonDialog] = useState<{ taskId: string; next: TaskSubstatus } | null>(null)
  const [transitionReason, setTransitionReason] = useState('')
  const [draft, setDraft] = useState({
    title: '',
    assignee: 'Aye Chan',
    type: 'Leave appointment' as TaskType,
    dueIso: '2026-08-06',
    notes: '',
    substatus: 'Assigned' as TaskSubstatus,
    transitionReason: '',
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
      const matchSubstatus = substatusFilter === 'all' || t.substatus === substatusFilter
      return matchQ && matchType && matchA && matchSubstatus
    })
  }, [tasks, q, typeFilter, assigneeFilter, substatusFilter])

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
      substatus: firstAllowedSubstatus('Leave appointment', status),
      transitionReason: '',
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
      substatus: t.substatus,
      transitionReason: t.lastTransitionReason ?? '',
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
    if (REASON_REQUIRED_SUBSTATUSES.includes(draft.substatus) && !draft.transitionReason.trim()) return
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
                substatus: draft.substatus,
                lastTransitionReason: draft.transitionReason.trim() || undefined,
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
          substatus: draft.substatus,
          lastTransitionReason: draft.transitionReason.trim() || undefined,
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
    setTasks((prev) =>
      prev.map((t) =>
        t.id === id
          ? canMoveStage(t, status)
            ? {
                ...t,
                status,
                substatus:
                  SUBSTATUS_META[t.substatus].stage === status ? t.substatus : firstAllowedSubstatus(t.type, status),
              }
            : t
          : t,
      ),
    )
    const current = tasks.find((t) => t.id === id)
    if (current && !canMoveStage(current, status)) {
      setGuardMsg('Transition blocked: move to In Progress first before Completed.')
    } else {
      setGuardMsg('')
    }
  }

  const applySubstatus = (id: string, next: TaskSubstatus, reason?: string) => {
    setTasks((prev) =>
      prev.map((t) => {
        if (t.id !== id) return t
        if (!canApplySubstatus(t, next)) return t
        return {
          ...t,
          status: SUBSTATUS_META[next].stage,
          substatus: next,
          lastTransitionReason: reason?.trim() || t.lastTransitionReason,
        }
      }),
    )
  }

  const requestSubstatus = (task: Task, next: TaskSubstatus) => {
    if (!canApplySubstatus(task, next)) {
      setGuardMsg('Invalid transition for current task state.')
      return
    }
    if (REASON_REQUIRED_SUBSTATUSES.includes(next)) {
      setReasonDialog({ taskId: task.id, next })
      setTransitionReason('')
      return
    }
    applySubstatus(task.id, next)
    setGuardMsg('')
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
        <Select
          className="max-w-[220px]"
          value={substatusFilter}
          onChange={(e) => setSubstatusFilter(e.target.value as 'all' | TaskSubstatus)}
        >
          <option value="all">All substatus</option>
          {Object.keys(SUBSTATUS_META).map((s) => (
            <option key={s}>{s}</option>
          ))}
        </Select>
      </div>
      {guardMsg ? <p className="mb-3 text-xs font-semibold text-danger">{guardMsg}</p> : null}

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
                              {substatusPill(t.substatus)}
                              {isOverdue(t) ? <Pill tone="danger">Overdue</Pill> : null}
                              {agingLabel(t) ? <Pill tone="danger">{agingLabel(t)}</Pill> : null}
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
                            {t.lastTransitionReason ? (
                              <p className="mt-2 text-[11px] text-muted">Reason: {t.lastTransitionReason}</p>
                            ) : null}
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
                              {SUBSTATUSES_BY_TYPE[t.type].includes('Waiting for Customer') ? (
                                <button
                                  type="button"
                                  onClick={() => requestSubstatus(t, 'Waiting for Customer')}
                                  className="rounded-lg bg-soft px-2 py-1 text-[10px] font-bold text-baltic hover:bg-sky/15"
                                >
                                  Waiting
                                </button>
                              ) : null}
                              <button
                                type="button"
                                onClick={() => requestSubstatus(t, 'Completed')}
                                className="rounded-lg bg-soft px-2 py-1 text-[10px] font-bold text-baltic hover:bg-sky/15"
                              >
                                Done
                              </button>
                              {t.status === 'completed' && SUBSTATUSES_BY_TYPE[t.type].includes('Re-opened') ? (
                                <button
                                  type="button"
                                  onClick={() => requestSubstatus(t, 'Re-opened')}
                                  className="rounded-lg bg-soft px-2 py-1 text-[10px] font-bold text-baltic hover:bg-sky/15"
                                >
                                  Re-open
                                </button>
                              ) : null}
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
                <DataTable headers={['Task', 'Assignee', 'Type', 'Due', 'Stage', 'Substatus', '']}>
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
                    <Td>{substatusPill(t.substatus)}</Td>
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
        subtitle="FR-07 · global stage + type substatus · transition-ready"
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
            <Button
              type="button"
              onClick={saveTask}
              disabled={
                !draft.title.trim() ||
                (REASON_REQUIRED_SUBSTATUSES.includes(draft.substatus) && !draft.transitionReason.trim())
              }
            >
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
              onChange={(e) =>
                setDraft((d) => {
                  const nextType = e.target.value as TaskType
                  const nextSubstatus = allowedSubstatuses(nextType, createStatus).includes(d.substatus)
                    ? d.substatus
                    : firstAllowedSubstatus(nextType, createStatus)
                  return { ...d, type: nextType, substatus: nextSubstatus }
                })
              }
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
          <Field label="Global stage">
            <Select
              value={createStatus}
              onChange={(e) => {
                const nextStage = e.target.value as Status
                setCreateStatus(nextStage)
                setDraft((d) => ({
                  ...d,
                  substatus: allowedSubstatuses(d.type, nextStage).includes(d.substatus)
                    ? d.substatus
                    : firstAllowedSubstatus(d.type, nextStage),
                }))
              }}
            >
              <option value="pending">Pending</option>
              <option value="progress">In Progress</option>
              <option value="completed">Completed</option>
            </Select>
          </Field>
          <Field label="Substatus">
            <Select
              value={draft.substatus}
              onChange={(e) => setDraft((d) => ({ ...d, substatus: e.target.value as TaskSubstatus }))}
            >
              {allowedSubstatuses(draft.type, createStatus).map((s) => (
                <option key={s}>{s}</option>
              ))}
            </Select>
          </Field>
          {REASON_REQUIRED_SUBSTATUSES.includes(draft.substatus) ? (
            <Field label="Transition reason *" className="sm:col-span-2">
              <Input
                value={draft.transitionReason}
                onChange={(e) => setDraft((d) => ({ ...d, transitionReason: e.target.value }))}
                placeholder="Required for Cancelled / Re-opened"
              />
            </Field>
          ) : null}
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
        open={reasonDialog !== null}
        onClose={() => {
          setReasonDialog(null)
          setTransitionReason('')
        }}
        title={reasonDialog ? `${reasonDialog.next} reason` : 'Transition reason'}
        subtitle="Reason is required for auditability"
        footer={
          <>
            <Button
              variant="secondary"
              type="button"
              onClick={() => {
                setReasonDialog(null)
                setTransitionReason('')
              }}
            >
              Cancel
            </Button>
            <Button
              type="button"
              disabled={!transitionReason.trim() || !reasonDialog}
              onClick={() => {
                if (!reasonDialog) return
                applySubstatus(reasonDialog.taskId, reasonDialog.next, transitionReason)
                setReasonDialog(null)
                setTransitionReason('')
              }}
            >
              Confirm
            </Button>
          </>
        }
      >
        <Field label="Reason *" className="mb-0">
          <Input
            value={transitionReason}
            onChange={(e) => setTransitionReason(e.target.value)}
            placeholder="e.g. Customer asked to restart documents"
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
