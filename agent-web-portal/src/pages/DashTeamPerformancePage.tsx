import { useState } from 'react'
import { Link } from 'react-router-dom'
import { Button, Card, DataTable, Dialog, EmptyState, PageHeader, Pill, Td } from '@/components/ui'
import { DashboardFilterBar, useDashboardFilters } from '@/dashboard/DashboardFilters'
import { useAuth } from '@/auth/AuthContext'

type Flag = 'ok' | 'warn' | 'danger'

type FaRow = {
  name: string
  code: string
  district: string
  ape: string
  fyp: string
  sfyp: string
  mdrt: string
  k1: string
  k2: string
  flag: Flag
}

type OwnPerformance = {
  name: string
  code: string
  roleLine: string
  district: string
  ape: string
  fyp: string
  sfyp: string
  mdrt: string
  k1: string
  k2: string
  weightedFreelance: string
  weightedInternal: string
  flag: Flag
}

const ROWS: FaRow[] = [
  {
    name: 'Thura Htun',
    code: 'AGT-10811',
    district: 'Mandalay',
    ape: '4,200,000.00',
    fyp: '5,100,000.00',
    sfyp: '980,000.00',
    mdrt: '41.0M',
    k1: '90%',
    k2: '86%',
    flag: 'ok',
  },
  {
    name: 'Zaw Ko',
    code: 'AGT-11002',
    district: 'Bago',
    ape: '780,000.00',
    fyp: '820,000.00',
    sfyp: '90,000.00',
    mdrt: '8.2M',
    k1: '70%',
    k2: '65%',
    flag: 'danger',
  },
  {
    name: 'Aye Chan',
    code: 'AGT-10284',
    district: 'Yangon',
    ape: '2,100,000.00',
    fyp: '2,450,000.00',
    sfyp: '410,000.00',
    mdrt: '22.4M',
    k1: '88%',
    k2: '84%',
    flag: 'ok',
  },
]

const OWN_BY_HAT: Record<'manager' | 'fte' | 'admin', OwnPerformance> = {
  manager: {
    name: 'Aye Chan',
    code: 'AGT-10284',
    roleLine: 'DM · Yangon',
    district: 'Yangon',
    ape: '2,100,000.00',
    fyp: '2,450,000.00',
    sfyp: '410,000.00',
    mdrt: '22.4M',
    k1: '88%',
    k2: '84%',
    weightedFreelance: '1,820,000.00',
    weightedInternal: '1,650,000.00',
    flag: 'ok',
  },
  fte: {
    name: 'Khin Htet',
    code: 'HQ-2201',
    roleLine: 'HOA · Portfolio',
    district: 'All districts',
    ape: '6,300,000.00',
    fyp: '7,480,000.00',
    sfyp: '1,230,000.00',
    mdrt: '48.0M',
    k1: '91%',
    k2: '87%',
    weightedFreelance: '5,100,000.00',
    weightedInternal: '4,650,000.00',
    flag: 'ok',
  },
  admin: {
    name: 'Ops May',
    code: 'HQ-0001',
    roleLine: 'Super Admin · HQ',
    district: 'HQ',
    ape: '5,800,000.00',
    fyp: '6,900,000.00',
    sfyp: '1,020,000.00',
    mdrt: '44.0M',
    k1: '89%',
    k2: '86%',
    weightedFreelance: '4,400,000.00',
    weightedInternal: '4,000,000.00',
    flag: 'warn',
  },
}

function flagPill(f: Flag) {
  if (f === 'ok') return <Pill tone="ok">OK</Pill>
  if (f === 'warn') return <Pill tone="warn">Watch</Pill>
  return <Pill tone="danger">Below target</Pill>
}

export function DashTeamPerformancePage() {
  const { mode, wtdLabel } = useDashboardFilters()
  const { caps, hat, profile } = useAuth()
  const [open, setOpen] = useState<FaRow | null>(null)
  const [exported, setExported] = useState(false)
  const [district, setDistrict] = useState('all')
  const [panel, setPanel] = useState<'team' | 'own'>('team')

  const visible = ROWS.filter((r) => district === 'all' || r.district === district)
  const own = OWN_BY_HAT[hat]

  const wtd = (row: FaRow) =>
    mode === 'freelance'
      ? row.name === 'Zaw Ko'
        ? '600,000.00'
        : row.name === 'Aye Chan'
          ? '1,820,000.00'
          : '3,400,000.00'
      : row.name === 'Zaw Ko'
        ? '540,000.00'
        : row.name === 'Aye Chan'
          ? '1,650,000.00'
          : '3,120,000.00'

  const ownWtd =
    mode === 'freelance' ? own.weightedFreelance : own.weightedInternal

  return (
    <div>
      <PageHeader
        title="Team Performance"
        actions={
          caps.canExport ? (
            <Button type="button" onClick={() => setExported(true)}>
              Export Excel
            </Button>
          ) : null
        }
      />

      <DashboardFilterBar />
      <div className="mb-3 inline-flex rounded-full bg-soft p-1">
        <button
          type="button"
          onClick={() => setPanel('team')}
          className={`rounded-full px-3.5 py-1.5 text-xs font-extrabold transition ${
            panel === 'team' ? 'bg-steel text-white' : 'text-muted hover:text-deep'
          }`}
        >
          Team performance
        </button>
        <button
          type="button"
          onClick={() => setPanel('own')}
          className={`rounded-full px-3.5 py-1.5 text-xs font-extrabold transition ${
            panel === 'own' ? 'bg-steel text-white' : 'text-muted hover:text-deep'
          }`}
        >
          Own performance
        </button>
      </div>

      <label className="mb-3 flex max-w-xs flex-col gap-1 text-[11px] font-bold text-muted">
        District (this table)
        <select
          className="rounded-[10px] border border-line bg-white px-2.5 py-2 text-sm font-semibold text-deep"
          value={district}
          onChange={(e) => setDistrict(e.target.value)}
        >
          <option value="all">All in slice</option>
          <option value="Yangon">Yangon</option>
          <option value="Mandalay">Mandalay</option>
          <option value="Bago">Bago</option>
          <option value="Taunggyi">Taunggyi</option>
        </select>
      </label>

      {panel === 'own' ? (
        <Card className="mb-3.5">
          <div className="grid gap-3 md:grid-cols-2">
            <div>
              <h3 className="text-base font-extrabold text-deep">Own performance</h3>
              <p className="text-xs text-muted">
                {profile.label} · {own.roleLine}
              </p>
              <div className="mt-2 text-sm text-muted">
                {own.name} · {own.code} · {own.district}
              </div>
            </div>
            <div className="grid grid-cols-2 gap-2 text-sm">
              <Metric label="APE" value={own.ape} />
              <Metric label="FYP" value={own.fyp} />
              <Metric label="SFYP" value={own.sfyp} />
              <Metric label={wtdLabel} value={ownWtd} />
              <Metric label="MDRT" value={own.mdrt} />
              <Metric label="K1 / K2" value={`${own.k1} / ${own.k2}`} />
            </div>
          </div>
          <div className="mt-3">{flagPill(own.flag)}</div>
        </Card>
      ) : null}

      <Card>
        {panel === 'own' ? (
          <p className="mb-3 text-xs font-bold text-muted uppercase">Team under you</p>
        ) : null}
        {visible.length === 0 ? (
          <EmptyState
            title="No FAs in this filter"
            hint="Widen District, or switch Freelance vs Internal weighting. Taunggyi has no production in this mock."
          />
        ) : (
          <DataTable headers={['FA', 'APE', 'FYP', 'SFYP', wtdLabel, 'MDRT', 'K1/K2', 'Flag']}>
            {visible.map((r) => (
              <tr key={r.code}>
                <Td>
                  <button
                    type="button"
                    className="font-bold text-steel hover:underline"
                    onClick={() => setOpen(r)}
                  >
                    {r.name}
                  </button>
                  <div className="text-[11px] text-muted">{r.code}</div>
                </Td>
                <Td>{r.ape}</Td>
                <Td>{r.fyp}</Td>
                <Td>{r.sfyp}</Td>
                <Td>{wtd(r)}</Td>
                <Td>{r.mdrt}</Td>
                <Td>
                  {r.k1}/{r.k2}
                </Td>
                <Td>{flagPill(r.flag)}</Td>
              </tr>
            ))}
          </DataTable>
        )}
      </Card>

      <Dialog
        open={open !== null}
        onClose={() => setOpen(null)}
        title={open?.name ?? 'FA'}
        subtitle={`${open?.code ?? ''} · production card — not the personal book`}
        footer={
          <>
            <Button variant="secondary" type="button" onClick={() => setOpen(null)}>
              Close
            </Button>
            <Link to="/tasks">
              <Button type="button">Open tasks</Button>
            </Link>
          </>
        }
      >
        {open ? (
          <dl className="grid gap-2 text-sm">
            <Row label="District" value={open.district} />
            <Row label="APE" value={open.ape} />
            <Row label="FYP" value={open.fyp} />
            <Row label="MDRT" value={open.mdrt} />
            <Row label="K1 / K2" value={`${open.k1} / ${open.k2}`} />
            <Row label="Flag" value={open.flag === 'danger' ? 'Below monthly FYP target' : 'On track'} />
          </dl>
        ) : null}
      </Dialog>

      <Dialog
        open={exported}
        onClose={() => setExported(false)}
        title="Export Excel"
        subtitle="Workbook uses the current hierarchy + weighting slice"
        footer={
          <Button type="button" onClick={() => setExported(false)}>
            Done
          </Button>
        }
      >
        <p className="text-sm text-muted">
          Dates are DD-MMM-YYYY. Amounts use 2 decimals and commas. Commission payout is not included.
        </p>
      </Dialog>
    </div>
  )
}

function Metric({ label, value }: { label: string; value: string }) {
  return (
    <div className="rounded-xl border border-line bg-soft/40 px-3 py-2">
      <div className="text-[11px] font-bold text-muted">{label}</div>
      <div className="text-sm font-extrabold text-deep">{value}</div>
    </div>
  )
}

function Row({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex justify-between gap-3 border-b border-line/70 pb-2 last:border-0">
      <dt className="text-xs font-bold text-muted">{label}</dt>
      <dd className="font-bold text-deep">{value}</dd>
    </div>
  )
}
