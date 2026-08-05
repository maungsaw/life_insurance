import { useState } from 'react'
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

type Rule = {
  id: string
  name: string
  trigger: string
  leadTime: string
  enabled: boolean
}

const TRIGGER_PRESETS: Record<string, { trigger: string; leadTime: string }> = {
  premium: {
    trigger: 'Core · premium due date',
    leadTime: '7 days before',
  },
  renewal: {
    trigger: 'Core · policy renewal',
    leadTime: '60 days before',
  },
  task: {
    trigger: 'Tasks module',
    leadTime: 'Immediate',
  },
  eapp: {
    trigger: 'Core · application status',
    leadTime: 'Immediate',
  },
  performance: {
    trigger: 'Dashboard performance',
    leadTime: 'Daily digest',
  },
  custom: {
    trigger: 'Custom · manual trigger',
    leadTime: 'Immediate',
  },
}

const SEED: Rule[] = [
  {
    id: 'r1',
    name: 'Recurring premium reminder',
    trigger: 'Core · premium due date',
    leadTime: '7 days before',
    enabled: true,
  },
  {
    id: 'r2',
    name: 'Annual renewal reminder',
    trigger: 'Core · policy renewal',
    leadTime: '60 days before',
    enabled: true,
  },
  {
    id: 'r3',
    name: 'Task assigned / updated',
    trigger: 'Tasks module',
    leadTime: 'Immediate',
    enabled: true,
  },
  {
    id: 'r4',
    name: 'e-App mark for correction',
    trigger: 'Core · application status',
    leadTime: 'Immediate',
    enabled: true,
  },
  {
    id: 'r5',
    name: 'Team flag · below target',
    trigger: 'Dashboard performance',
    leadTime: 'Daily digest',
    enabled: false,
  },
]

type FormMode = 'closed' | 'add' | 'edit'

/** FR-08 — Notification Setup (authorized web). Not the header inbox. */
export function MgmtNotificationPage() {
  const [rules, setRules] = useState(SEED)
  const [formMode, setFormMode] = useState<FormMode>('closed')
  const [editId, setEditId] = useState<string | null>(null)

  const [name, setName] = useState('')
  const [triggerKey, setTriggerKey] = useState<keyof typeof TRIGGER_PRESETS>('premium')
  const [leadTime, setLeadTime] = useState('7 days before')

  const editing = editId ? rules.find((r) => r.id === editId) : null
  const dialogOpen = formMode !== 'closed'

  const resetForm = () => {
    setName('')
    setTriggerKey('premium')
    setLeadTime('7 days before')
    setEditId(null)
  }

  const openAdd = () => {
    resetForm()
    setFormMode('add')
  }

  const openEdit = (r: Rule) => {
    setEditId(r.id)
    setName(r.name)
    setLeadTime(r.leadTime)
    const key =
      (Object.entries(TRIGGER_PRESETS).find(([, v]) => v.trigger === r.trigger)?.[0] as
        | keyof typeof TRIGGER_PRESETS
        | undefined) ?? 'custom'
    setTriggerKey(key)
    setFormMode('edit')
  }

  const closeForm = () => {
    setFormMode('closed')
    resetForm()
  }

  const onTriggerChange = (key: keyof typeof TRIGGER_PRESETS) => {
    setTriggerKey(key)
    setLeadTime(TRIGGER_PRESETS[key].leadTime)
  }

  const triggerLabel = TRIGGER_PRESETS[triggerKey].trigger
  const canSave = name.trim().length > 0 && leadTime.trim().length > 0

  const saveRule = () => {
    if (!canSave) return
    const payload = {
      name: name.trim(),
      trigger: triggerLabel,
      leadTime: leadTime.trim(),
    }
    if (formMode === 'edit' && editId) {
      setRules((prev) => prev.map((r) => (r.id === editId ? { ...r, ...payload } : r)))
    } else {
      setRules((prev) => [{ id: `r-${Date.now()}`, ...payload, enabled: true }, ...prev])
    }
    closeForm()
  }

  const toggle = (id: string) => {
    setRules((prev) => prev.map((r) => (r.id === id ? { ...r, enabled: !r.enabled } : r)))
  }

  const deleteRule = (id: string) => {
    if (!confirm('Remove this notification rule?')) return
    setRules((prev) => prev.filter((r) => r.id !== id))
    if (editId === id) closeForm()
  }

  return (
    <div>
      <PageHeader
        title="Notification setup"
        subtitle="FR-08 · configure when automatic alerts fire · Core + Tasks triggers"
        actions={
          <Button type="button" onClick={openAdd}>
            + Add rule
          </Button>
        }
      />

      <p className="mb-3.5 text-sm text-muted">
        This screen is <b className="text-deep">rule setup</b> (backend). Each rule = trigger + lead time.
        Audience and channel follow Core defaults. Turn rules on/off from the table. Personal inbox →{' '}
        <Link to="/notifications" className="font-bold text-steel underline-offset-2 hover:underline">
          open inbox
        </Link>
        . Company messages →{' '}
        <Link
          to="/management/announcements"
          className="font-bold text-steel underline-offset-2 hover:underline"
        >
          Announcement setup
        </Link>
        .
      </p>

      <Card
        title="Notification rules"
        className="mb-3.5"
        action={
          <div className="flex items-center gap-2">
            <Pill tone="ok">Authorized web</Pill>
            <Button variant="secondary" size="sm" type="button" onClick={openAdd}>
              + Add rule
            </Button>
          </div>
        }
      >
        {rules.length === 0 ? (
          <div className="py-10 text-center">
            <p className="text-sm font-semibold text-muted">No notification rules yet.</p>
            <Button className="mt-3" type="button" onClick={openAdd}>
              Add first rule
            </Button>
          </div>
        ) : (
          <DataTable headers={['Rule', 'Trigger', 'Lead time', 'Status', '']}>
            {rules.map((r) => (
              <tr key={r.id}>
                <Td className="font-bold">{r.name}</Td>
                <Td className="text-xs text-muted">{r.trigger}</Td>
                <Td>{r.leadTime}</Td>
                <Td>{r.enabled ? <Pill tone="ok">On</Pill> : <Pill>Off</Pill>}</Td>
                <Td>
                  <div className="flex flex-wrap gap-1">
                    <Button variant="ghost" size="sm" type="button" onClick={() => openEdit(r)}>
                      Edit
                    </Button>
                    <Button variant="secondary" size="sm" type="button" onClick={() => toggle(r.id)}>
                      {r.enabled ? 'Turn off' : 'Turn on'}
                    </Button>
                  </div>
                </Td>
              </tr>
            ))}
          </DataTable>
        )}
      </Card>

      <Card title="Recent automated sends (mock)">
        <DataTable headers={['When', 'Rule', 'Sample', 'Status']}>
          <tr>
            <Td>05-Aug-2026 07:00</Td>
            <Td className="font-bold">Recurring premium reminder</Td>
            <Td>3 FAs · Yangon A</Td>
            <Td>
              <Pill tone="ok">Delivered</Pill>
            </Td>
          </tr>
          <tr>
            <Td>04-Aug-2026 18:10</Td>
            <Td className="font-bold">Task assigned / updated</Td>
            <Td>Aye Chan</Td>
            <Td>
              <Pill tone="ok">Delivered</Pill>
            </Td>
          </tr>
          <tr>
            <Td>01-Aug-2026 07:00</Td>
            <Td className="font-bold">Annual renewal reminder</Td>
            <Td>12 FAs</Td>
            <Td>
              <Pill tone="ok">Delivered</Pill>
            </Td>
          </tr>
        </DataTable>
      </Card>

      <Dialog
        open={dialogOpen}
        onClose={closeForm}
        title={formMode === 'add' ? 'Add notification rule' : `Edit · ${editing?.name ?? 'rule'}`}
        subtitle="FR-08 · name · trigger · lead time only"
        footer={
          <>
            <Button variant="secondary" type="button" onClick={closeForm}>
              Cancel
            </Button>
            {formMode === 'edit' && editId ? (
              <Button variant="danger" type="button" onClick={() => deleteRule(editId)}>
                Remove
              </Button>
            ) : null}
            <Button type="button" onClick={saveRule} disabled={!canSave}>
              {formMode === 'add' ? 'Create rule' : 'Save changes'}
            </Button>
          </>
        }
      >
        <Field label="Rule name *">
          <Input
            autoFocus
            value={name}
            onChange={(e) => setName(e.target.value)}
            placeholder="e.g. Premium due · 7 days"
          />
        </Field>
        <Field label="Trigger *">
          <Select
            value={triggerKey}
            onChange={(e) => onTriggerChange(e.target.value as keyof typeof TRIGGER_PRESETS)}
          >
            <option value="premium">Core · premium due date</option>
            <option value="renewal">Core · policy renewal</option>
            <option value="task">Tasks module · assign / update</option>
            <option value="eapp">Core · e-App status change</option>
            <option value="performance">Dashboard · team performance flag</option>
            <option value="custom">Custom trigger</option>
          </Select>
        </Field>
        <Field label="Lead time *" className="mb-2">
          <Input
            value={leadTime}
            onChange={(e) => setLeadTime(e.target.value)}
            placeholder="e.g. 7 days before · Immediate"
          />
        </Field>
        <p className="mb-0 text-xs text-muted">
          New rules start <b className="text-deep">On</b>. Use Turn off in the table to pause. Audience and
          delivery channel are set by Core for each trigger.
        </p>
      </Dialog>
    </div>
  )
}
