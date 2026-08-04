import { useState } from 'react'
import { Button, Card, DataTable, PageHeader, Pill, SegmentedControl, Td } from '@/components/ui'

export function CrmPage() {
  const [tab, setTab] = useState('leads')
  return (
    <div>
      <PageHeader
        title="CRM"
        subtitle="FR-03 · portfolio Leads vs Clients · owner FA · convert after policy issuance"
      />
      <SegmentedControl
        value={tab}
        onChange={setTab}
        options={[
          { value: 'leads', label: 'Leads' },
          { value: 'clients', label: 'Clients' },
        ]}
      />
      {tab === 'leads' ? (
        <Card>
          <div className="mb-3">
            <Button type="button">+ Add lead</Button>
          </div>
          <DataTable headers={['Lead', 'Mobile', 'Stage', 'Owner FA', 'Quotes/Apps', '']}>
            <tr>
              <Td>Maung Soe</Td>
              <Td>09 771 888 999</Td>
              <Td><Pill tone="warn">Quoted</Pill></Td>
              <Td>Aye Chan</Td>
              <Td>1 quote · draft app</Td>
              <Td><button type="button" className="font-bold text-steel">Open</button></Td>
            </tr>
            <tr>
              <Td>Yu Hlaing</Td>
              <Td>09 250 444 555</Td>
              <Td><Pill>Contacted</Pill></Td>
              <Td>Nwe Nwe</Td>
              <Td>—</Td>
              <Td><button type="button" className="font-bold text-steel">Open</button></Td>
            </tr>
          </DataTable>
        </Card>
      ) : (
        <Card>
          <DataTable headers={['Client', 'Policies', 'Next due', 'Owner FA', 'Family', '']}>
            <tr>
              <Td>Daw Hla</Td>
              <Td>2 active · 1 lapsed</Td>
              <Td>10-Aug-2026</Td>
              <Td>Aye Chan</Td>
              <Td>2 contacts</Td>
              <Td><button type="button" className="font-bold text-steel">Open</button></Td>
            </tr>
            <tr>
              <Td>Maung Soe</Td>
              <Td>1 active (new)</Td>
              <Td>03-Sep-2026</Td>
              <Td>Aye Chan</Td>
              <Td>—</Td>
              <Td><button type="button" className="font-bold text-steel">Converted</button></Td>
            </tr>
          </DataTable>
        </Card>
      )}
    </div>
  )
}
