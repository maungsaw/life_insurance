import { Button, Card, DataTable, PageHeader, Pill, Td } from '@/components/ui'

export function PerformancePage() {
  return (
    <div>
      <PageHeader
        title="Performance"
        subtitle="Hierarchical filters · FA line production · persistency · Export Excel"
        actions={<Button type="button" onClick={() => alert('Export Excel (mock)')}>Export Excel</Button>}
      />
      <div className="mb-4 flex flex-wrap items-end gap-2.5">
        {[
          ['Region', ['Yangon', 'Mandalay']],
          ['District', ['District A']],
          ['SAM', ['All']],
          ['AM', ['All']],
        ].map(([label, opts]) => (
          <label key={String(label)} className="flex flex-col gap-1 text-[11px] font-bold text-muted">
            {label}
            <select className="min-w-[140px] rounded-[10px] border border-line bg-white px-2.5 py-2 text-sm text-deep">
              {(opts as string[]).map((o) => (
                <option key={o}>{o}</option>
              ))}
            </select>
          </label>
        ))}
      </div>
      <Card>
        <DataTable headers={['FA', 'APE', 'FYP', 'SFYP', 'Wtd Freelance FYP', 'MDRT', 'K1/K2', 'Flag']}>
          <tr>
            <Td>Thura Htun</Td>
            <Td>4,200,000.00</Td>
            <Td>5,100,000.00</Td>
            <Td>980,000.00</Td>
            <Td>3,400,000.00</Td>
            <Td>41.0M</Td>
            <Td>90/86</Td>
            <Td><Pill tone="ok">OK</Pill></Td>
          </tr>
          <tr>
            <Td>Zaw Ko</Td>
            <Td>780,000.00</Td>
            <Td>820,000.00</Td>
            <Td>90,000.00</Td>
            <Td>600,000.00</Td>
            <Td>8.2M</Td>
            <Td>70/65</Td>
            <Td><Pill tone="danger">Below target</Pill></Td>
          </tr>
        </DataTable>
      </Card>
    </div>
  )
}
