import { Card, DataTable, PageHeader, Pill, Td } from '@/components/ui'

export function PoliciesPage() {
  return (
    <div>
      <PageHeader
        title="Policies / Sales process"
        subtitle="FR-03 spine: Lead → Quote → e-App → Approved → Client → Active/Lapsed"
      />
      <div className="mb-4 grid grid-cols-2 gap-2 md:grid-cols-5">
        {[
          ['Leads', '18 open'],
          ['Quoted', '6'],
          ['e-Apps', '11 in flight'],
          ['Approved', '4 this week'],
          ['Policies', 'Active 4,812'],
        ].map(([h, v]) => (
          <div key={h} className="rounded-xl bg-soft p-3">
            <div className="text-xs font-bold text-muted">{h}</div>
            <div className="font-display mt-1 text-xl text-deep">{v}</div>
          </div>
        ))}
      </div>
      <Card>
        <DataTable headers={['Policy', 'Client', 'Product', 'SI', 'Premium', 'Next due', 'Status', 'FA']}>
          <tr>
            <Td>POL-88421</Td>
            <Td>Daw Hla</Td>
            <Td>Endowment</Td>
            <Td>10,000,000.00</Td>
            <Td>185,000.00</Td>
            <Td>10-Aug-2026</Td>
            <Td><Pill tone="ok">Active</Pill></Td>
            <Td>Aye Chan</Td>
          </tr>
          <tr>
            <Td>POL-70011</Td>
            <Td>Daw Hla</Td>
            <Td>Term</Td>
            <Td>5,000,000.00</Td>
            <Td>—</Td>
            <Td>—</Td>
            <Td><Pill tone="danger">Lapsed</Pill></Td>
            <Td>Aye Chan</Td>
          </tr>
          <tr>
            <Td>POL-88499</Td>
            <Td>Maung Soe</Td>
            <Td>Endowment</Td>
            <Td>10,000,000.00</Td>
            <Td>185,000.00</Td>
            <Td>03-Sep-2026</Td>
            <Td><Pill tone="ok">Active</Pill></Td>
            <Td>Aye Chan</Td>
          </tr>
        </DataTable>
      </Card>
      <p className="mt-3 text-xs text-muted">
        Policy detail is read-only from Core. CRM convert history remains on client record.
      </p>
    </div>
  )
}
