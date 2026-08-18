import { useState } from 'react'
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

type FeedStatus = 'live' | 'draft' | 'scheduled' | 'unpublished'

type FeedRow = {
  id: string
  title: string
  audience: string
  feed: FeedStatus
  push: 'Sent' | 'Skipped' | '—'
  published: string
  schedule?: string
}

const SEED: FeedRow[] = [
  {
    id: 'f1',
    title: 'Q3 Incentive Push',
    audience: 'All FAs (Yangon)',
    feed: 'live',
    push: 'Sent',
    published: '01-Aug-2026',
  },
  {
    id: 'f2',
    title: 'NIIM exam reminder',
    audience: 'Managers only',
    feed: 'draft',
    push: '—',
    published: '—',
  },
  {
    id: 'f3',
    title: 'Compliance refresh',
    audience: 'All FAs',
    feed: 'scheduled',
    push: 'Skipped',
    published: '—',
    schedule: '20-Aug-2026 09:00',
  },
]

function feedPill(s: FeedStatus) {
  if (s === 'live') return <Pill tone="ok">Live</Pill>
  if (s === 'scheduled') return <Pill tone="warn">Scheduled</Pill>
  if (s === 'unpublished') return <Pill>Unpublished</Pill>
  return <Pill>Draft</Pill>
}

/**
 * FR-09 Announcement Setup + FR-10 company feed source.
 */
export function MgmtAnnouncementPage() {
  const [rows, setRows] = useState(SEED)
  const [alsoPush, setAlsoPush] = useState(true)
  const [schedule, setSchedule] = useState('')
  const [title, setTitle] = useState('Q3 Incentive Push')
  const [unpublishId, setUnpublishId] = useState<string | null>(null)

  const publish = () => {
    const id = `f-${Date.now()}`
    setRows((prev) => [
      {
        id,
        title: title.trim() || 'Untitled',
        audience: 'All FAs (Yangon)',
        feed: schedule ? 'scheduled' : 'live',
        push: alsoPush ? 'Sent' : 'Skipped',
        published: schedule ? '—' : '17-Aug-2026',
        schedule: schedule || undefined,
      },
      ...prev,
    ])
    setTitle('')
    setSchedule('')
  }

  const unpublish = () => {
    if (!unpublishId) return
    setRows((prev) =>
      prev.map((r) => (r.id === unpublishId ? { ...r, feed: 'unpublished' as const } : r)),
    )
    setUnpublishId(null)
  }

  const target = unpublishId ? rows.find((r) => r.id === unpublishId) : null

  return (
    <div>
      <PageHeader
        title="Announcement setup"
      />

      <div className="grid gap-3.5 lg:grid-cols-2">
        <Card title="Create announcement" action={<Pill tone="ok">Authorized web</Pill>}>
          <Field label="Title *">
            <Input value={title} onChange={(e) => setTitle(e.target.value)} />
          </Field>
          <Field label="Image *">
            <Input type="file" accept="image/*" />
          </Field>
          <div className="mb-3 h-[120px] rounded-xl bg-gradient-to-br from-sky to-deep" />
          <Field label="URL">
            <Input defaultValue="https://kbzlife.com/q3-incentive" />
          </Field>
          <Field label="Audience">
            <Select defaultValue="yangon">
              <option value="yangon">All FAs (Yangon)</option>
              <option>Managers only</option>
              <option>District A</option>
            </Select>
          </Field>
          <Field label="Schedule (optional)">
            <Input
              type="datetime-local"
              value={schedule}
              onChange={(e) => setSchedule(e.target.value)}
            />
          </Field>

          <label className="mb-3.5 flex cursor-pointer items-start gap-2.5 rounded-xl border border-line bg-soft/60 px-3 py-2.5">
            <input
              type="checkbox"
              className="mt-1"
              checked={alsoPush}
              onChange={(e) => setAlsoPush(e.target.checked)}
            />
            <span className="text-sm">
              <b className="text-deep">Also send as push notification</b>
              <span className="mt-0.5 block text-xs text-muted">
                Delivers image + URL to the mobile tray. Does not change FR-08 automated rules.
              </span>
            </span>
          </label>

          <div className="flex gap-2">
            <Button variant="secondary" type="button">
              Save draft
            </Button>
            <Button type="button" onClick={publish}>
              {schedule ? 'Schedule' : alsoPush ? 'Publish + push' : 'Publish to feed'}
            </Button>
          </div>
        </Card>

        <Card title="Feed history">
          <DataTable headers={['Title', 'Audience', 'Feed', 'Push', 'When', '']}>
            {rows.map((r) => (
              <tr key={r.id}>
                <Td className="font-bold">{r.title}</Td>
                <Td>{r.audience}</Td>
                <Td>{feedPill(r.feed)}</Td>
                <Td>
                  <Pill>{r.push}</Pill>
                </Td>
                <Td className="text-xs text-muted">
                  {r.feed === 'scheduled' && r.schedule ? r.schedule : r.published}
                </Td>
                <Td>
                  {r.feed === 'live' || r.feed === 'scheduled' ? (
                    <Button variant="ghost" size="sm" type="button" onClick={() => setUnpublishId(r.id)}>
                      Unpublish
                    </Button>
                  ) : (
                    <span className="text-xs text-muted">—</span>
                  )}
                </Td>
              </tr>
            ))}
          </DataTable>
        </Card>
      </div>

      <Dialog
        open={target !== null && target !== undefined}
        onClose={() => setUnpublishId(null)}
        title={`Unpublish · ${target?.title ?? ''}`}
        subtitle="Feed card disappears on the next mobile sync"
        footer={
          <>
            <Button variant="secondary" type="button" onClick={() => setUnpublishId(null)}>
              Cancel
            </Button>
            <Button variant="danger" type="button" onClick={unpublish}>
              Unpublish
            </Button>
          </>
        }
      >
        <p className="text-sm text-muted">
          FAs will no longer see this card under Announcements. Push messages already delivered stay in their
          inbox history.
        </p>
      </Dialog>
    </div>
  )
}
