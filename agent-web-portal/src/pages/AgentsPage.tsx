import { Card, DataTable, PageHeader, Pill, Td } from '@/components/ui'

export function AgentsPage() {
  return (
    <div>
      <PageHeader title="Agents / Audit" subtitle="FR-12 · agent master data · status changes · audit trail" />
      <Card title="Agent directory" className="mb-3.5">
        <DataTable headers={['Code', 'Name', 'Role', 'Mobile', 'Status', 'District']}>
          <tr>
            <Td>AGT-10284</Td>
            <Td>Aye Chan</Td>
            <Td>FA</Td>
            <Td>09 771 234 567</Td>
            <Td><Pill tone="ok">Active</Pill></Td>
            <Td>Yangon A</Td>
          </tr>
          <tr>
            <Td>AGT-11002</Td>
            <Td>Zaw Ko</Td>
            <Td>FA</Td>
            <Td>09 988 111 222</Td>
            <Td><Pill tone="warn">LC Training</Pill></Td>
            <Td>Yangon A</Td>
          </tr>
        </DataTable>
      </Card>
      <Card title="Audit log">
        <DataTable headers={['Action', 'Previous', 'New', 'User', 'When']}>
          <tr>
            <Td>Update mobile</Td>
            <Td>09 771 234 567</Td>
            <Td>09 988 111 222</Td>
            <Td>Ops May</Td>
            <Td>03-Aug-2026 09:12</Td>
          </tr>
          <tr>
            <Td>Status change</Td>
            <Td>Pre-Contracted</Td>
            <Td>LC Training</Td>
            <Td>Alliance</Td>
            <Td>02-Aug-2026 16:40</Td>
          </tr>
        </DataTable>
      </Card>
    </div>
  )
}
