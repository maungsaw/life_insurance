import { Button, Card, DataTable, PageHeader, Pill, Td } from '@/components/ui'
import { DashboardFilterBar, useDashboardFilters } from '@/dashboard/DashboardFilters'

export function DashTeamPerformancePage() {
  const { mode, wtdLabel } = useDashboardFilters()

  return (
    <div>
      <PageHeader
        title="Team Performance"
        subtitle="FA production · persistency · flags for the filtered hierarchy"
        actions={
          <Button type="button" onClick={() => alert('Export Excel (mock)')}>
            Export Excel
          </Button>
        }
      />

      <DashboardFilterBar scopeNote="Hierarchy filters scope this Team Performance table. Same slice as Overview." />

      <Card>
        <DataTable headers={['FA', 'APE', 'FYP', 'SFYP', wtdLabel, 'MDRT', 'K1/K2', 'Flag']}>
          <tr>
            <Td>Thura Htun</Td>
            <Td>4,200,000.00</Td>
            <Td>5,100,000.00</Td>
            <Td>980,000.00</Td>
            <Td>{mode === 'freelance' ? '3,400,000.00' : '3,120,000.00'}</Td>
            <Td>41.0M</Td>
            <Td>90/86</Td>
            <Td>
              <Pill tone="ok">OK</Pill>
            </Td>
          </tr>
          <tr>
            <Td>Zaw Ko</Td>
            <Td>780,000.00</Td>
            <Td>820,000.00</Td>
            <Td>90,000.00</Td>
            <Td>{mode === 'freelance' ? '600,000.00' : '540,000.00'}</Td>
            <Td>8.2M</Td>
            <Td>70/65</Td>
            <Td>
              <Pill tone="danger">Below target</Pill>
            </Td>
          </tr>
          <tr>
            <Td>Aye Chan</Td>
            <Td>2,100,000.00</Td>
            <Td>2,450,000.00</Td>
            <Td>410,000.00</Td>
            <Td>{mode === 'freelance' ? '1,820,000.00' : '1,650,000.00'}</Td>
            <Td>22.4M</Td>
            <Td>88/84</Td>
            <Td>
              <Pill tone="ok">OK</Pill>
            </Td>
          </tr>
        </DataTable>
      </Card>
    </div>
  )
}
