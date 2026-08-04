import { Button, Card, DataTable, Field, Input, PageHeader, Pill, Select, Td, Textarea } from '@/components/ui'

/**
 * FR-09 — Notification announcement setup (authorized web).
 * Mobile receives push with Image + URL. Not the header inbox (`/notifications`).
 */
export function MgmtNotificationPage() {
  return (
    <div>
      <PageHeader
        title="Notification"
        subtitle="FR-09 · Notification announcement · Image + URL · push to mobile"
      />
      <p className="mb-3.5 text-sm text-muted">
        This configures <b className="text-deep">push notification announcements</b>. The header bell is the
        personal inbox — different job.
      </p>
      <div className="grid gap-3.5 lg:grid-cols-2">
        <Card title="Create notification announcement" action={<Pill tone="ok">Authorized web</Pill>}>
          <Field label="Title *">
            <Input defaultValue="Q3 Incentive — open now" />
          </Field>
          <Field label="Short message *">
            <Textarea rows={2} defaultValue="Tap to view campaign details and unlock bonus rules." />
          </Field>
          <Field label="Image *">
            <Input type="file" accept="image/*" />
          </Field>
          <div className="mb-3 h-[120px] rounded-xl bg-gradient-to-br from-sky to-baltic" />
          <Field label="URL *">
            <Input defaultValue="https://kbzlife.com/q3-incentive" />
          </Field>
          <Field label="Audience">
            <Select>
              <option>All FAs</option>
              <option>All FAs (Yangon)</option>
              <option>Managers only</option>
            </Select>
          </Field>
          <Field label="Send">
            <Select defaultValue="now">
              <option value="now">Send now</option>
              <option value="schedule">Schedule</option>
              <option value="draft">Save draft only</option>
            </Select>
          </Field>
          <div className="flex gap-2">
            <Button variant="secondary" type="button">
              Save draft
            </Button>
            <Button type="button">Send notification</Button>
          </div>
        </Card>
        <Card title="Send history">
          <DataTable headers={['Title', 'Audience', 'Status', 'When']}>
            <tr>
              <Td className="font-bold">Q3 Incentive — open now</Td>
              <Td>All FAs (Yangon)</Td>
              <Td>
                <Pill tone="ok">Sent</Pill>
              </Td>
              <Td>01-Aug-2026 09:00</Td>
            </tr>
            <tr>
              <Td className="font-bold">NIIM exam reminder</Td>
              <Td>Managers only</Td>
              <Td>
                <Pill tone="warn">Scheduled</Pill>
              </Td>
              <Td>08-Aug-2026 08:00</Td>
            </tr>
            <tr>
              <Td className="font-bold">Form pack update</Td>
              <Td>All FAs</Td>
              <Td>
                <Pill>Draft</Pill>
              </Td>
              <Td>—</Td>
            </tr>
          </DataTable>
        </Card>
      </div>
    </div>
  )
}
