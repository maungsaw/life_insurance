import { Button, Card, DataTable, Field, Input, PageHeader, Pill, Select, Td } from '@/components/ui'

/**
 * FR-09 setup + FR-10 company announcements source.
 * Mobile company feed is read-only.
 */
export function MgmtAnnouncementPage() {
  return (
    <div>
      <PageHeader
        title="Announcement"
        subtitle="FR-09 / FR-10 · Company broadcast · mobile feed is read-only"
      />
      <p className="mb-3.5 text-sm text-muted">
        Publish lasting <b className="text-deep">feed cards</b> FAs browse in Announcements. For a time-sensitive
        push with Image + URL, use <b className="text-deep">Management → Notification</b>.
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
          <div className="flex gap-2">
            <Button variant="secondary" type="button">
              Save draft
            </Button>
            <Button type="button">Publish to feed</Button>
          </div>
        </Card>
        <Card title="Feed history">
          <DataTable headers={['Title', 'Audience', 'Status', 'Published']}>
            <tr>
              <Td className="font-bold">Q3 Incentive Push</Td>
              <Td>All FAs (Yangon)</Td>
              <Td>
                <Pill tone="ok">Live</Pill>
              </Td>
              <Td>01-Aug-2026</Td>
            </tr>
            <tr>
              <Td className="font-bold">NIIM exam reminder</Td>
              <Td>Managers only</Td>
              <Td>
                <Pill>Draft</Pill>
              </Td>
              <Td>—</Td>
            </tr>
            <tr>
              <Td className="font-bold">Compliance refresh</Td>
              <Td>All FAs</Td>
              <Td>
                <Pill tone="warn">Expired</Pill>
              </Td>
              <Td>15-Jun-2026</Td>
            </tr>
          </DataTable>
        </Card>
      </div>
    </div>
  )
}
