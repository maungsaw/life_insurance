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
  Textarea,
} from '@/components/ui'
import { cn } from '@/lib/cn'

type DeviceStatus = 'active' | 'offline' | 'pending' | 'wiped' | 'revoked'
type WipeReason = 'loss' | 'theft' | 'compromise' | 'deactivation'

type DeviceRow = {
  id: string
  agentCode: string
  agentName: string
  role: string
  district: string
  deviceName: string
  os: string
  appBuild: string
  deviceId: string
  lastSeen: string
  status: DeviceStatus
}

type WipeLog = {
  id: string
  when: string
  agent: string
  device: string
  reason: string
  by: string
  status: 'Pending' | 'Acked' | 'Failed'
}

const SEED: DeviceRow[] = [
  {
    id: '1',
    agentCode: 'AGT-10284',
    agentName: 'Aye Chan',
    role: 'FA',
    district: 'Yangon A',
    deviceName: 'iPhone 14',
    os: 'iOS 17.5',
    appBuild: '1.4.2',
    deviceId: 'dev-ios-9f2a1c',
    lastSeen: 'Just now',
    status: 'active',
  },
  {
    id: '2',
    agentCode: 'AGT-11002',
    agentName: 'Zaw Ko',
    role: 'FA',
    district: 'Yangon A',
    deviceName: 'Samsung A54',
    os: 'Android 14',
    appBuild: '1.4.1',
    deviceId: 'dev-and-44b8e0',
    lastSeen: '2h ago',
    status: 'offline',
  },
  {
    id: '3',
    agentCode: 'AGT-10881',
    agentName: 'Nwe Nwe',
    role: 'FA',
    district: 'Mandalay B',
    deviceName: 'iPhone 13',
    os: 'iOS 16.7',
    appBuild: '1.4.2',
    deviceId: 'dev-ios-c31d09',
    lastSeen: 'Yesterday',
    status: 'active',
  },
  {
    id: '4',
    agentCode: 'AGT-10011',
    agentName: 'Thura Htun',
    role: 'AM',
    district: 'Yangon A',
    deviceName: 'Pixel 7',
    os: 'Android 15',
    appBuild: '1.4.0',
    deviceId: 'dev-and-aa1192',
    lastSeen: '5d ago',
    status: 'wiped',
  },
]

function statusPill(s: DeviceStatus) {
  if (s === 'active') return <Pill tone="ok">Active</Pill>
  if (s === 'offline') return <Pill tone="warn">Offline</Pill>
  if (s === 'pending') return <Pill tone="warn">Wipe pending</Pill>
  if (s === 'wiped') return <Pill>Wiped</Pill>
  return <Pill tone="danger">Revoked</Pill>
}

export function MgmtDevicesPage() {
  const [rows, setRows] = useState(SEED)
  const [selected, setSelected] = useState<string[]>([])
  const [q, setQ] = useState('')
  const [statusFilter, setStatusFilter] = useState<string>('all')
  const [confirmIds, setConfirmIds] = useState<string[] | null>(null)
  const [reason, setReason] = useState<WipeReason>('loss')
  const [note, setNote] = useState('')
  const [confirmText, setConfirmText] = useState('')
  const [logs, setLogs] = useState<WipeLog[]>([
    {
      id: 'l1',
      when: '28-Jul-2026 14:22',
      agent: 'Thura Htun · AGT-10011',
      device: 'Pixel 7 · dev-and-aa1192',
      reason: 'Deactivation',
      by: 'Ops May',
      status: 'Acked',
    },
  ])

  const visible = useMemo(() => {
    const needle = q.trim().toLowerCase()
    return rows.filter((r) => {
      const matchQ =
        !needle ||
        r.agentName.toLowerCase().includes(needle) ||
        r.agentCode.toLowerCase().includes(needle) ||
        r.deviceId.toLowerCase().includes(needle) ||
        r.deviceName.toLowerCase().includes(needle)
      const matchS = statusFilter === 'all' || r.status === statusFilter
      return matchQ && matchS
    })
  }, [rows, q, statusFilter])

  const confirmRows = confirmIds
    ? rows.filter((r) => confirmIds.includes(r.id) && r.status !== 'wiped')
    : []

  const canSubmit = confirmText.trim().toUpperCase() === 'WIPE' && confirmRows.length > 0

  const toggle = (id: string) => {
    setSelected((prev) => (prev.includes(id) ? prev.filter((x) => x !== id) : [...prev, id]))
  }

  const toggleAllVisible = () => {
    const ids = visible.filter((r) => r.status !== 'wiped').map((r) => r.id)
    const allOn = ids.every((id) => selected.includes(id))
    setSelected((prev) => (allOn ? prev.filter((id) => !ids.includes(id)) : [...new Set([...prev, ...ids])]))
  }

  const openWipe = (ids: string[]) => {
    const usable = ids.filter((id) => rows.find((r) => r.id === id)?.status !== 'wiped')
    if (usable.length === 0) return
    setConfirmIds(usable)
    setReason('loss')
    setNote('')
    setConfirmText('')
  }

  const submitWipe = () => {
    if (!canSubmit || !confirmIds) return
    const reasonLabel =
      reason === 'loss'
        ? 'Loss'
        : reason === 'theft'
          ? 'Theft'
          : reason === 'compromise'
            ? 'Compromise'
            : 'Deactivation'

    setRows((prev) =>
      prev.map((r) => (confirmIds.includes(r.id) ? { ...r, status: 'pending' as const } : r)),
    )

    const newLogs: WipeLog[] = confirmRows.map((r) => ({
      id: `l-${r.id}-${Date.now()}`,
      when: '05-Aug-2026 · queued',
      agent: `${r.agentName} · ${r.agentCode}`,
      device: `${r.deviceName} · ${r.deviceId}`,
      reason: reasonLabel + (note.trim() ? ` · ${note.trim()}` : ''),
      by: 'Aye Chan',
      status: 'Pending' as const,
    }))
    setLogs((prev) => [...newLogs, ...prev])
    setSelected((prev) => prev.filter((id) => !confirmIds.includes(id)))
    setConfirmIds(null)
  }

  return (
    <div>
      <PageHeader
        title="Devices"
        subtitle="NFR §6 · registered devices · remote data wipe (loss · theft · compromise · deactivation)"
        actions={
          <Button
            variant="danger"
            type="button"
            disabled={selected.length === 0}
            onClick={() => openWipe(selected)}
          >
            Wipe selected ({selected.length})
          </Button>
        }
      />

      <p className="mb-3.5 text-sm text-muted">
        Wipe removes <b className="text-deep">local app data</b> on the device (encrypted SQLite + cached docs).
        Core / server records stay. Offline devices stay <b className="text-deep">Wipe pending</b> until they
        connect.
      </p>

      <Card className="mb-3.5">
        <div className="flex flex-wrap items-end gap-2.5">
          <Field label="Search agent / device" className="mb-0 min-w-[220px] flex-1">
            <Input
              value={q}
              onChange={(e) => setQ(e.target.value)}
              placeholder="Name, code, device ID…"
            />
          </Field>
          <Field label="Status" className="mb-0 min-w-[160px]">
            <Select value={statusFilter} onChange={(e) => setStatusFilter(e.target.value)}>
              <option value="all">All</option>
              <option value="active">Active</option>
              <option value="offline">Offline</option>
              <option value="pending">Wipe pending</option>
              <option value="wiped">Wiped</option>
              <option value="revoked">Revoked</option>
            </Select>
          </Field>
        </div>
      </Card>

      <Card title="Registered devices" className="mb-3.5">
        {visible.length === 0 ? (
          <p className="py-8 text-center text-sm font-semibold text-muted">
            No registered devices in this filter.
          </p>
        ) : (
          <>
            <div className="mb-2 flex items-center gap-2 text-xs font-bold text-muted">
              <input
                type="checkbox"
                aria-label="Select all visible"
                checked={
                  visible.filter((r) => r.status !== 'wiped').length > 0 &&
                  visible.filter((r) => r.status !== 'wiped').every((r) => selected.includes(r.id))
                }
                onChange={toggleAllVisible}
              />
              Select all wipeable in this filter
            </div>
            <DataTable
              headers={['', 'Agent', 'Device', 'OS / App', 'Device ID', 'Last seen', 'Status', '']}
            >
              {visible.map((r) => (
                <tr key={r.id} className={cn(selected.includes(r.id) && 'bg-sky/5')}>
                  <Td>
                    <input
                      type="checkbox"
                      aria-label={`Select ${r.agentName}`}
                      disabled={r.status === 'wiped'}
                      checked={selected.includes(r.id)}
                      onChange={() => toggle(r.id)}
                    />
                  </Td>
                  <Td>
                    <div className="font-bold">{r.agentName}</div>
                    <div className="text-xs text-muted">
                      {r.agentCode} · {r.role} · {r.district}
                    </div>
                  </Td>
                  <Td>{r.deviceName}</Td>
                  <Td>
                    {r.os}
                    <div className="text-xs text-muted">App {r.appBuild}</div>
                  </Td>
                  <Td className="font-mono text-xs">{r.deviceId}</Td>
                  <Td>{r.lastSeen}</Td>
                  <Td>{statusPill(r.status)}</Td>
                  <Td>
                    <Button
                      variant="danger"
                      size="sm"
                      type="button"
                      disabled={r.status === 'wiped' || r.status === 'pending'}
                      onClick={() => openWipe([r.id])}
                    >
                      Wipe
                    </Button>
                  </Td>
                </tr>
              ))}
            </DataTable>
          </>
        )}
      </Card>

      {confirmIds ? (
        <Card
          title="Confirm remote data wipe"
          action={<Pill tone="danger">Irreversible on device</Pill>}
          className="mb-3.5 border-danger/30"
        >
          <p className="mb-3 text-sm text-muted">
            You are about to wipe <b className="text-deep">{confirmRows.length}</b> device
            {confirmRows.length === 1 ? '' : 's'}. Local leads, tasks, brochures cache, and session on those
            devices will be removed.
          </p>
          <ul className="mb-4 space-y-2 rounded-xl bg-soft p-3 text-sm">
            {confirmRows.map((r) => (
              <li key={r.id} className="flex flex-wrap justify-between gap-2">
                <span className="font-bold text-deep">
                  {r.agentName} · {r.deviceName}
                </span>
                <span className="text-xs text-muted">
                  {r.deviceId} · {r.os} · {r.lastSeen}
                </span>
              </li>
            ))}
          </ul>
          <div className="grid gap-3 md:grid-cols-2">
            <Field label="Reason *">
              <Select value={reason} onChange={(e) => setReason(e.target.value as WipeReason)}>
                <option value="loss">Loss</option>
                <option value="theft">Theft</option>
                <option value="compromise">Compromise</option>
                <option value="deactivation">Deactivation</option>
              </Select>
            </Field>
            <Field label='Type WIPE to confirm *'>
              <Input
                value={confirmText}
                onChange={(e) => setConfirmText(e.target.value)}
                placeholder="WIPE"
                autoComplete="off"
              />
            </Field>
            <Field label="Note (optional)" className="md:col-span-2">
              <Textarea
                rows={2}
                value={note}
                onChange={(e) => setNote(e.target.value)}
                placeholder="e.g. Phone reported stolen at branch visit"
              />
            </Field>
          </div>
          <div className="mt-1 flex flex-wrap gap-2">
            <Button variant="danger" type="button" disabled={!canSubmit} onClick={submitWipe}>
              Send wipe command
            </Button>
            <Button variant="secondary" type="button" onClick={() => setConfirmIds(null)}>
              Cancel
            </Button>
          </div>
        </Card>
      ) : null}

      <Card title="Wipe history">
        <DataTable headers={['When', 'Agent', 'Device', 'Reason', 'By', 'Status']}>
          {logs.map((l) => (
            <tr key={l.id}>
              <Td>{l.when}</Td>
              <Td className="font-bold">{l.agent}</Td>
              <Td className="text-xs">{l.device}</Td>
              <Td>{l.reason}</Td>
              <Td>{l.by}</Td>
              <Td>
                {l.status === 'Acked' ? (
                  <Pill tone="ok">Acked</Pill>
                ) : l.status === 'Failed' ? (
                  <Pill tone="danger">Failed</Pill>
                ) : (
                  <Pill tone="warn">Pending</Pill>
                )}
              </Td>
            </tr>
          ))}
        </DataTable>
      </Card>
    </div>
  )
}
