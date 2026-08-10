import { useState } from 'react'
import { colors } from '@/lib/colors'
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  BarElement,
  PointElement,
  LineElement,
  ArcElement,
  Filler,
  Tooltip,
  Legend,
} from 'chart.js'
import { Bar, Doughnut, Line } from 'react-chartjs-2'
import { Download, TriangleAlert } from 'lucide-react'
import { Button, Card, DataTable, PageHeader, Pill, Td } from '@/components/ui'
import { cn } from '@/lib/cn'

ChartJS.register(
  CategoryScale,
  LinearScale,
  BarElement,
  PointElement,
  LineElement,
  ArcElement,
  Filler,
  Tooltip,
  Legend,
)

/** Coolors #3 Baltic — Overview theme (docs/30 · 31) */
const THEME = colors.baltic
const months = ['Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug']

type OverviewView = 'manager' | 'fte'
type Status = 'ok' | 'warn' | 'danger'
type MdrtTab = 'all' | 'qualified' | 'progress'

const chartOpts = {
  responsive: true,
  maintainAspectRatio: false as const,
  plugins: { legend: { labels: { color: colors.muted, boxWidth: 12, font: { size: 11 } } } },
  scales: {
    x: { ticks: { color: colors.muted, font: { size: 11 } }, grid: { color: 'rgba(0,53,84,.06)' } },
    y: { ticks: { color: colors.muted, font: { size: 11 } }, grid: { color: 'rgba(0,53,84,.06)' } },
  },
}

const MANAGER_FA = [
  { name: 'Aung Aung', district: 'Yangon', ape: '4.2M', fyp: '5.1M', sfyp: '0.98M', wfyp: '3.4M', mdrt: '41.0M', status: 'ok' as Status },
  { name: 'Su Su', district: 'Yangon', ape: '2.8M', fyp: '3.1M', sfyp: '0.52M', wfyp: '2.1M', mdrt: '22.4M', status: 'warn' as Status },
  { name: 'Thura Htun', district: 'Mandalay', ape: '3.6M', fyp: '4.0M', sfyp: '0.71M', wfyp: '2.9M', mdrt: '34.2M', status: 'ok' as Status },
  { name: 'Zaw Ko', district: 'Bago', ape: '0.78M', fyp: '0.82M', sfyp: '0.09M', wfyp: '0.60M', mdrt: '8.2M', status: 'danger' as Status },
  { name: 'Nwe Nwe', district: 'Yangon', ape: '2.1M', fyp: '2.4M', sfyp: '0.41M', wfyp: '1.8M', mdrt: '18.6M', status: 'ok' as Status },
  { name: 'Aye Chan', district: 'Mandalay', ape: '1.9M', fyp: '2.2M', sfyp: '0.33M', wfyp: '1.5M', mdrt: '15.1M', status: 'warn' as Status },
]

const FTE_FA = [
  { no: 1, name: 'Aung Aung', district: 'Yangon', dm: 'Mg Htet', sam: 'SAM-01', am: 'AM-12', ape: '4.2M', fypPct: '92%', wfyp: '3.4M', k1: '90%', k2: '86%', status: 'ok' as Status },
  { no: 2, name: 'Su Su', district: 'Yangon', dm: 'Mg Htet', sam: 'SAM-01', am: 'AM-12', ape: '2.8M', fypPct: '74%', wfyp: '2.1M', k1: '84%', k2: '79%', status: 'warn' as Status },
  { no: 3, name: 'Thura Htun', district: 'Mandalay', dm: 'U Min', sam: 'SAM-03', am: 'AM-08', ape: '3.6M', fypPct: '88%', wfyp: '2.9M', k1: '91%', k2: '87%', status: 'ok' as Status },
  { no: 4, name: 'Zaw Ko', district: 'Bago', dm: 'U Min', sam: 'SAM-02', am: 'AM-05', ape: '0.78M', fypPct: '52%', wfyp: '0.60M', k1: '70%', k2: '65%', status: 'danger' as Status },
  { no: 5, name: 'Nwe Nwe', district: 'Yangon', dm: 'Mg Htet', sam: 'SAM-01', am: 'AM-14', ape: '2.1M', fypPct: '81%', wfyp: '1.8M', k1: '88%', k2: '84%', status: 'ok' as Status },
  { no: 6, name: 'Aye Chan', district: 'Mandalay', dm: 'U Min', sam: 'SAM-03', am: 'AM-08', ape: '1.9M', fypPct: '71%', wfyp: '1.5M', k1: '82%', k2: '78%', status: 'warn' as Status },
]

const VARIANCE_ALERTS = [
  { text: 'Bago District — 62% FYP vs target', tone: 'danger' as const },
  { text: 'Taunggyi District — 65% FYP vs target', tone: 'danger' as const },
  { text: 'SAM-02 line — Weighted FYP lagging 11%', tone: 'warn' as const },
  { text: 'Persistency K2 · 3 FAs below 70%', tone: 'warn' as const },
]

const MDRT_ALL = [
  { name: 'Mg Mg', ape: '28.4M', pct: 57, kind: 'progress' as const },
  { name: 'Kyaw Kyaw', ape: '22.1M', pct: 44, kind: 'progress' as const },
  { name: 'Khin Khin', ape: '18.6M', pct: 37, kind: 'progress' as const },
  { name: 'Thura Htun', ape: '41.0M', pct: 100, kind: 'qualified' as const },
  { name: 'Aung Aung', ape: '38.2M', pct: 100, kind: 'qualified' as const },
]

function ProgressRing({ pct, size = 52, stroke = 5 }: { pct: number; size?: number; stroke?: number }) {
  const r = (size - stroke) / 2
  const c = 2 * Math.PI * r
  const offset = c - (Math.min(100, Math.max(0, pct)) / 100) * c
  return (
    <svg width={size} height={size} className="shrink-0 -rotate-90">
      <circle cx={size / 2} cy={size / 2} r={r} fill="none" stroke={colors.line} strokeWidth={stroke} />
      <circle
        cx={size / 2}
        cy={size / 2}
        r={r}
        fill="none"
        stroke={THEME}
        strokeWidth={stroke}
        strokeLinecap="round"
        strokeDasharray={c}
        strokeDashoffset={offset}
      />
    </svg>
  )
}

function OverviewKpi({
  label,
  value,
  hint,
  pct,
  trend,
}: {
  label: string
  value: string
  hint?: string
  pct?: number
  trend?: string
}) {
  return (
    <div className="rounded-2xl border border-line bg-card p-3.5">
      <div className="flex items-start justify-between gap-2">
        <div className="min-w-0">
          <div className="text-[11px] font-bold tracking-wide text-muted uppercase">{label}</div>
          <div className="font-display mt-1 text-[22px] leading-none text-deep">{value}</div>
          {hint ? <div className="mt-1 text-[11px] text-muted">{hint}</div> : null}
          {trend ? <div className="mt-1 text-[11px] font-bold text-ok">{trend}</div> : null}
        </div>
        {typeof pct === 'number' ? (
          <div className="relative grid place-items-center">
            <ProgressRing pct={pct} />
            <span className="absolute text-[10px] font-extrabold text-baltic">{pct}%</span>
          </div>
        ) : null}
      </div>
    </div>
  )
}

function statusPill(s: Status) {
  if (s === 'ok') return <Pill tone="ok">On Track</Pill>
  if (s === 'warn') return <Pill tone="warn">Warning</Pill>
  return <Pill tone="danger">Red Flag</Pill>
}

function FilterBar() {
  return (
    <div className="mb-4 flex flex-wrap items-end gap-2.5 rounded-2xl border border-line bg-card p-3.5">
      {[
        ['District', ['Yangon District', 'Mandalay', 'Nay Pyi Taw', 'All Districts']],
        ['Manager', ['Mg Htet', 'All DMs']],
        ['SAM', ['All SAM', 'SAM-01']],
        ['AM', ['All AM', 'AM-12']],
        ['FA', ['All FA']],
        ['Month', ['August 2026', 'July 2026']],
      ].map(([label, opts]) => (
        <label key={String(label)} className="flex min-w-[120px] flex-1 flex-col gap-1 text-[11px] font-bold text-muted">
          {label}
          <select className="rounded-[10px] border border-line bg-white px-2.5 py-2 text-sm font-semibold text-deep focus:border-baltic focus:outline-none">
            {(opts as string[]).map((o) => (
              <option key={o}>{o}</option>
            ))}
          </select>
        </label>
      ))}
    </div>
  )
}

function AlertsStrip() {
  return (
    <div className="mb-4 flex flex-wrap items-center gap-3 rounded-2xl border border-line bg-card px-4 py-3">
      <span className="text-xs font-extrabold tracking-wide text-deep uppercase">Target alerts</span>
      <span className="rounded-full bg-danger/10 px-2.5 py-1 text-xs font-bold text-danger">12 Critical</span>
      <span className="rounded-full bg-warn/10 px-2.5 py-1 text-xs font-bold text-warn">18 Warning</span>
      <span className="rounded-full bg-ok/10 px-2.5 py-1 text-xs font-bold text-ok">46 On Track</span>
      <Button
        type="button"
        size="sm"
        className="ml-auto !bg-baltic hover:!bg-deep"
        onClick={() => alert('Critical issues (mock)')}
      >
        View critical issues
      </Button>
    </div>
  )
}

function ProposalDonut({ total, data }: { total: string; data: number[] }) {
  return (
    <Card title="New proposal tracking">
      <div className="mx-auto h-[200px] max-w-[220px]">
        <Doughnut
          data={{
            labels: ['Submitted', 'Pending', 'Approved', 'Rejected'],
            datasets: [
              {
                data,
                backgroundColor: [THEME, colors.steel, colors.sky, colors.danger],
                borderWidth: 0,
              },
            ],
          }}
          options={{
            responsive: true,
            maintainAspectRatio: false,
            cutout: '62%',
            plugins: {
              legend: { position: 'bottom', labels: { color: colors.muted, boxWidth: 10, font: { size: 10 } } },
            },
          }}
        />
      </div>
      <p className="mt-1 text-center text-xs font-bold text-muted">
        Total <span className="text-baltic">{total}</span>
      </p>
    </Card>
  )
}

function ProposalTrend({ series }: { series: number[] }) {
  return (
    <Card title="Proposal trend">
      <div className="h-[220px]">
        <Line
          data={{
            labels: months,
            datasets: [
              {
                label: 'Proposals',
                data: series,
                borderColor: THEME,
                backgroundColor: 'rgba(0,100,148,0.12)',
                fill: true,
                tension: 0.35,
                pointBackgroundColor: THEME,
              },
            ],
          }}
          options={chartOpts}
        />
      </div>
    </Card>
  )
}

function MdrtCard({
  tab,
  onTab,
  showTabs,
}: {
  tab: MdrtTab
  onTab: (t: MdrtTab) => void
  showTabs: boolean
}) {
  const rows = showTabs
    ? MDRT_ALL.filter((m) => (tab === 'all' ? true : tab === 'qualified' ? m.kind === 'qualified' : m.kind === 'progress'))
    : MDRT_ALL.filter((m) => m.kind === 'progress')

  return (
    <Card title="MDRT tracker">
      <div className="mb-4 flex flex-col items-center">
        <div className="relative grid place-items-center">
          <ProgressRing pct={33} size={112} stroke={8} />
          <div className="absolute text-center">
            <div className="font-display text-2xl font-bold text-baltic">33%</div>
            <div className="text-[10px] font-bold text-muted">Qualified</div>
          </div>
        </div>
        <p className="mt-2 text-xs font-semibold text-muted">8 / 24 FAs qualified</p>
      </div>
      {showTabs ? (
        <div className="mb-3 flex gap-1 rounded-xl bg-soft p-1">
          {(
            [
              ['all', 'All'],
              ['qualified', 'Qualified'],
              ['progress', 'In Progress'],
            ] as const
          ).map(([v, label]) => (
            <button
              key={v}
              type="button"
              onClick={() => onTab(v)}
              className={cn(
                'flex-1 rounded-lg px-2 py-1.5 text-[11px] font-bold transition',
                tab === v ? 'bg-baltic text-white' : 'text-muted hover:text-deep',
              )}
            >
              {label}
            </button>
          ))}
        </div>
      ) : (
        <p className="mb-2 text-[11px] font-extrabold tracking-wide text-muted uppercase">In progress</p>
      )}
      <ul className="space-y-3">
        {rows.map((m) => (
          <li key={m.name}>
            <div className="mb-1 flex items-center justify-between text-sm">
              <span className="font-bold text-deep">{m.name}</span>
              <span className="text-xs text-muted">APE {m.ape}</span>
            </div>
            <div className="h-2 overflow-hidden rounded-full bg-line">
              <div className="h-full rounded-full bg-baltic" style={{ width: `${m.pct}%` }} />
            </div>
          </li>
        ))}
      </ul>
      <button
        type="button"
        className="mt-4 w-full text-center text-xs font-bold text-baltic underline-offset-2 hover:underline"
        onClick={() => alert('View all MDRT (mock)')}
      >
        {showTabs ? 'View all portfolio members' : 'View all MDRT members'}
      </button>
    </Card>
  )
}

function ManagerView({ mdrtTab, setMdrtTab }: { mdrtTab: MdrtTab; setMdrtTab: (t: MdrtTab) => void }) {
  return (
    <>
      <div className="mb-4 grid grid-cols-2 gap-3 xl:grid-cols-6">
        <OverviewKpi label="New proposals" value="128" trend="+12.5% vs Jul" />
        <OverviewKpi label="FYP" value="125.4M" hint="Target 152M" pct={82} />
        <OverviewKpi label="APE" value="83.2M" hint="Target 96M" pct={86} />
        <OverviewKpi label="Subsequent FYP" value="54.2M" hint="Target 71M" pct={76} />
        <OverviewKpi label="Weighted FYP" value="32.6M" hint="Target 47M" pct={69} />
        <OverviewKpi label="MDRT premium" value="64" trend="+8% vs Jul" />
      </div>

      <div className="mb-4 grid gap-3.5 lg:grid-cols-3">
        <ProposalDonut total="128" data={[48, 32, 36, 12]} />
        <ProposalTrend series={[56, 62, 71, 88, 102, 128]} />
        <Card title="District performance">
          <div className="h-[220px]">
            <Bar
              data={{
                labels: ['Yangon', 'Mandalay', 'Nay Pyi Taw', 'Taunggyi', 'Bago'],
                datasets: [
                  {
                    label: '% of target',
                    data: [86, 78, 91, 68, 80],
                    backgroundColor: THEME,
                    borderRadius: 6,
                  },
                ],
              }}
              options={{
                ...chartOpts,
                indexAxis: 'y' as const,
                plugins: { legend: { display: false } },
              }}
            />
          </div>
        </Card>
      </div>

      <AlertsStrip />

      <div className="grid gap-3.5 xl:grid-cols-[1fr_280px]">
        <Card
          title="FA production details"
          action={<span className="text-xs font-semibold text-muted">24 FAs · manager hierarchy</span>}
        >
          <div className="mb-3 flex flex-wrap gap-2">
            <input
              className="min-w-[180px] flex-1 rounded-[10px] border border-line px-3 py-2 text-sm"
              placeholder="Search FA…"
            />
            <Button type="button" variant="secondary" size="sm" onClick={() => alert('Export table (mock)')}>
              Export table
            </Button>
          </div>
          <DataTable headers={['FA', 'District', 'APE', 'FYP', 'SFYP', 'WFYP', 'MDRT', 'Status']}>
            {MANAGER_FA.map((r) => (
              <tr key={r.name}>
                <Td className="font-bold">{r.name}</Td>
                <Td className="text-muted">{r.district}</Td>
                <Td>{r.ape}</Td>
                <Td>{r.fyp}</Td>
                <Td>{r.sfyp}</Td>
                <Td>{r.wfyp}</Td>
                <Td>{r.mdrt}</Td>
                <Td>{statusPill(r.status)}</Td>
              </tr>
            ))}
          </DataTable>
        </Card>
        <MdrtCard tab={mdrtTab} onTab={setMdrtTab} showTabs={false} />
      </div>
    </>
  )
}

function FteView({ mdrtTab, setMdrtTab }: { mdrtTab: MdrtTab; setMdrtTab: (t: MdrtTab) => void }) {
  return (
    <>
      <div className="mb-4 grid grid-cols-2 gap-3 xl:grid-cols-6">
        <OverviewKpi label="Global new proposals" value="1,280" trend="+12.8% vs Jul" />
        <OverviewKpi label="Portfolio FYP" value="1.25B" hint="Target 1.50B" pct={72} />
        <OverviewKpi label="Portfolio APE" value="830M" hint="Target 960M" pct={86} />
        <OverviewKpi label="Persistency K1" value="88.5%" hint="Target 85%" />
        <OverviewKpi label="Persistency K2" value="82.1%" hint="Target 80%" />
        <OverviewKpi label="MDRT premium" value="640" trend="+6% vs Jul" />
      </div>

      <div className="mb-4 grid gap-3.5 lg:grid-cols-3">
        <ProposalDonut total="1,280" data={[480, 320, 360, 120]} />
        <ProposalTrend series={[420, 510, 640, 820, 1010, 1280]} />
        <Card title="Portfolio target variance alerts">
          <ul className="space-y-2.5">
            {VARIANCE_ALERTS.map((a) => (
              <li
                key={a.text}
                className="flex items-start gap-2 rounded-xl border border-line bg-soft/60 px-3 py-2.5 text-sm"
              >
                <TriangleAlert
                  className={cn('mt-0.5 size-4 shrink-0', a.tone === 'danger' ? 'text-danger' : 'text-warn')}
                />
                <span className="font-semibold text-deep">{a.text}</span>
              </li>
            ))}
          </ul>
        </Card>
      </div>

      <AlertsStrip />

      <div className="grid gap-3.5 xl:grid-cols-[1fr_280px]">
        <Card
          title="Full portfolio performance & persistency"
          action={<span className="text-xs font-semibold text-muted">24 FAs · FTE portfolio</span>}
        >
          <div className="mb-3 flex flex-wrap gap-2">
            <input
              className="min-w-[180px] flex-1 rounded-[10px] border border-line px-3 py-2 text-sm"
              placeholder="Search FA…"
            />
            <Button type="button" variant="secondary" size="sm" onClick={() => alert('Export full dataset (mock)')}>
              Export full dataset
            </Button>
          </div>
          <DataTable headers={['No.', 'FA', 'District', 'DM', 'SAM', 'AM', 'APE', 'FYP %', 'WFYP', 'K1%', 'K2%', 'Status']}>
            {FTE_FA.map((r) => (
              <tr key={r.name}>
                <Td>{r.no}</Td>
                <Td className="font-bold">{r.name}</Td>
                <Td className="text-muted">{r.district}</Td>
                <Td>{r.dm}</Td>
                <Td>{r.sam}</Td>
                <Td>{r.am}</Td>
                <Td>{r.ape}</Td>
                <Td>{r.fypPct}</Td>
                <Td>{r.wfyp}</Td>
                <Td>{r.k1}</Td>
                <Td>{r.k2}</Td>
                <Td>{statusPill(r.status)}</Td>
              </tr>
            ))}
          </DataTable>
        </Card>
        <MdrtCard tab={mdrtTab} onTab={setMdrtTab} showTabs />
      </div>
    </>
  )
}

/** Overview · Manager View + FTE Employees (docs/31) */
export function DashOverviewPage() {
  const [view, setView] = useState<OverviewView>('manager')
  const [mdrtTab, setMdrtTab] = useState<MdrtTab>('progress')

  return (
    <div>
      <PageHeader
        title="Overview"
        subtitle={
          view === 'manager'
            ? 'Manager View · hierarchy pulse · proposals · FA production · MDRT'
            : 'FTE Employees View (5.2.4.2) · full portfolio · persistency · variance alerts'
        }
        actions={
          <Button
            type="button"
            className="!bg-baltic shadow-baltic/25 hover:!bg-deep"
            onClick={() => alert(view === 'manager' ? 'Export Excel (mock)' : 'Export Full Dataset (mock)')}
          >
            <Download className="size-4" />
            {view === 'manager' ? 'Export Excel' : 'Export Full Dataset'}
          </Button>
        }
      />

      {/* View tabs — both live on Overview */}
      <div className="mb-4 inline-flex rounded-xl border border-line bg-soft p-1">
        <button
          type="button"
          onClick={() => setView('manager')}
          className={cn(
            'rounded-lg px-4 py-2 text-sm font-bold transition',
            view === 'manager' ? 'bg-baltic text-white shadow-sm' : 'text-muted hover:text-deep',
          )}
        >
          Manager View
        </button>
        <button
          type="button"
          onClick={() => setView('fte')}
          className={cn(
            'rounded-lg px-4 py-2 text-sm font-bold transition',
            view === 'fte' ? 'bg-baltic text-white shadow-sm' : 'text-muted hover:text-deep',
          )}
        >
          FTE Employees
        </button>
      </div>

      <FilterBar />

      {view === 'manager' ? (
        <ManagerView mdrtTab={mdrtTab} setMdrtTab={setMdrtTab} />
      ) : (
        <FteView mdrtTab={mdrtTab} setMdrtTab={setMdrtTab} />
      )}
    </div>
  )
}
