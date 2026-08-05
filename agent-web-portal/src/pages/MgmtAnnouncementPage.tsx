import { useState } from 'react'
import { Link } from 'react-router-dom'
import { Button, Card, DataTable, Field, Input, PageHeader, Pill, Select, Td } from '@/components/ui'

/**
 * FR-09 Announcement Setup + FR-10 company feed source.
 * Optional push = FR-09 “notification announcement with URL and Image”.
 */
export function MgmtAnnouncementPage() {
  const [alsoPush, setAlsoPush] = useState(true)

  return (
    <div>
      <PageHeader
        title="Announcement setup"
        subtitle="FR-09 · publish company messages · mobile feed is read-only (FR-10)"
      />

      <p className="mb-3.5 text-sm text-muted">
        Create lasting <b className="text-deep">feed cards</b> FAs browse under Announcements. Optional push
        sends a <b className="text-deep">notification announcement</b> with image + URL (FR-09 mobile). For
        automatic premium / renewal timing, use{' '}
        <Link
          to="/management/notifications"
          className="font-bold text-steel underline-offset-2 hover:underline"
        >
          Notification setup
        </Link>{' '}
        (FR-08).
      </p>

      <div className="grid gap-3.5 lg:grid-cols-2">
        <Card title="Create announcement" action={<Pill tone="ok">Authorized web</Pill>}>
          <Field label="Title *">
            <Input defaultValue="Q3 Incentive Push" />
          </Field>
          <Field label="Image *">
            <Input type="file" accept="image/*" />
          </Field>
          <div className="mb-3 h-[120px] rounded-xl bg-gradient-to-br from-sky to-deep" />
          <Field label="URL">
            <Input defaultValue="https://kbzlife.com/q3-incentive" />
          </Field>
          <Field label="Audience">
            <Select>
              <option>All FAs (Yangon)</option>
              <option>Managers only</option>
              <option>District A</option>
            </Select>
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
                Delivers image + URL to the mobile tray (FR-09 notification announcement). Does not change
                FR-08 automated rules.
              </span>
            </span>
          </label>

          <div className="flex gap-2">
            <Button variant="secondary" type="button">
              Save draft
            </Button>
            <Button type="button">{alsoPush ? 'Publish + push' : 'Publish to feed'}</Button>
          </div>
        </Card>

        <Card title="Feed history">
          <DataTable headers={['Title', 'Audience', 'Feed', 'Push', 'Published']}>
            <tr>
              <Td className="font-bold">Q3 Incentive Push</Td>
              <Td>All FAs (Yangon)</Td>
              <Td>
                <Pill tone="ok">Live</Pill>
              </Td>
              <Td>
                <Pill tone="ok">Sent</Pill>
              </Td>
              <Td>01-Aug-2026</Td>
            </tr>
            <tr>
              <Td className="font-bold">NIIM exam reminder</Td>
              <Td>Managers only</Td>
              <Td>
                <Pill>Draft</Pill>
              </Td>
              <Td>
                <Pill>—</Pill>
              </Td>
              <Td>—</Td>
            </tr>
            <tr>
              <Td className="font-bold">Compliance refresh</Td>
              <Td>All FAs</Td>
              <Td>
                <Pill tone="warn">Expired</Pill>
              </Td>
              <Td>
                <Pill>Skipped</Pill>
              </Td>
              <Td>15-Jun-2026</Td>
            </tr>
          </DataTable>
        </Card>
      </div>
    </div>
  )
}
