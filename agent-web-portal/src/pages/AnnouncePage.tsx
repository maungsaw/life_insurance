import { Button, Card, DataTable, Field, Input, PageHeader, Pill, Select, Td } from '@/components/ui'

export function AnnouncePage() {
  return (
    <div>
      <PageHeader title="Announcements" subtitle="FR-09 · title · image · URL · audience · publish" />
      <div className="grid gap-3.5 lg:grid-cols-2">
        <Card title="Create announcement">
          <Field label="Title *"><Input defaultValue="Q3 Incentive Push" /></Field>
          <Field label="Image"><Input type="file" accept="image/*" /></Field>
          <div className="mb-3 h-[120px] rounded-xl bg-gradient-to-br from-sky to-deep" />
          <Field label="URL"><Input defaultValue="https://kbzlife.com/q3-incentive" /></Field>
          <Field label="Audience">
            <Select>
              <option>All FAs (Yangon)</option>
              <option>Managers only</option>
              <option>District A</option>
            </Select>
          </Field>
          <div className="flex gap-2">
            <Button variant="secondary" type="button">Save draft</Button>
            <Button type="button">Publish</Button>
          </div>
        </Card>
        <Card title="History">
          <DataTable headers={['Title', 'Status', 'Published']}>
            <tr>
              <Td>Q3 Incentive Push</Td>
              <Td><Pill tone="ok">Live</Pill></Td>
              <Td>01-Aug-2026</Td>
            </tr>
            <tr>
              <Td>NIIM exam reminder</Td>
              <Td><Pill>Draft</Pill></Td>
              <Td>—</Td>
            </tr>
          </DataTable>
        </Card>
      </div>
    </div>
  )
}
