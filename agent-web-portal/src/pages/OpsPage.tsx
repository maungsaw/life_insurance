import { Button, Card, Field, PageHeader, Select } from '@/components/ui'

export function OpsPage() {
  return (
    <div>
      <PageHeader title="Operations" subtitle="Notification rules · resource library · broadcasts" />
      <div className="grid gap-3.5 lg:grid-cols-2">
        <Card title="Notification rules">
          <Field label="Premium due reminder">
            <Select defaultValue="7 days before">
              <option>3 days before</option>
              <option>7 days before</option>
              <option>14 days before</option>
            </Select>
          </Field>
          <Field label="e-App correction ping">
            <Select defaultValue="Immediate">
              <option>Immediate</option>
              <option>Daily digest</option>
            </Select>
          </Field>
          <Button type="button">Save rules</Button>
        </Card>
        <Card title="Resources">
          <p className="mb-3 text-xs text-muted">Upload product sheets / training PDFs for mobile offline cache.</p>
          <Button variant="secondary" type="button" className="mb-3">+ Upload file</Button>
          <ul className="list-disc space-y-1 pl-4 text-sm text-muted">
            <li>Endowment brochure.pdf</li>
            <li>NIIM study guide.pdf</li>
            <li>Agency code of conduct.pdf</li>
          </ul>
        </Card>
      </div>
    </div>
  )
}
