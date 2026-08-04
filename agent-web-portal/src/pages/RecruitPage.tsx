import { Card, DataTable, PageHeader, Pill, Td } from '@/components/ui'

export function RecruitPage() {
  return (
    <div>
      <PageHeader title="Recruitment" subtitle="Candidate pipeline · onboarding · FR-07 task links" />
      <div className="mb-4 grid grid-cols-2 gap-2 md:grid-cols-5">
        {[
          ['Screening', '7'],
          ['LC Training', '4'],
          ['Pre-Contracted', '3'],
          ['Contracted', '2'],
          ['Active FA', '1'],
        ].map(([h, v]) => (
          <div key={h} className="rounded-xl bg-soft p-3">
            <div className="text-xs font-bold text-muted">{h}</div>
            <div className="font-display mt-1 text-xl">{v}</div>
          </div>
        ))}
      </div>
      <Card>
        <DataTable headers={['Candidate', 'Mobile', 'Sponsor', 'Stage', 'Next task']}>
          <tr>
            <Td>Su Su</Td>
            <Td>09 250 111 222</Td>
            <Td>Aye Chan</Td>
            <Td><Pill>LC Training</Pill></Td>
            <Td>Interview · 06-Aug</Td>
          </tr>
          <tr>
            <Td>Ko Min</Td>
            <Td>09 777 333 111</Td>
            <Td>Nwe Nwe</Td>
            <Td><Pill tone="warn">Screening</Pill></Td>
            <Td>Docs check</Td>
          </tr>
        </DataTable>
      </Card>
    </div>
  )
}
