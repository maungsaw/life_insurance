import { colors } from '@/lib/colors'
import { useState } from 'react'
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  BarElement,
  PointElement,
  LineElement,
  Tooltip,
  Legend,
} from 'chart.js'
import { Bar, Line } from 'react-chartjs-2'
import { Card, KpiCard, PageHeader, SegmentedControl } from '@/components/ui'

ChartJS.register(CategoryScale, LinearScale, BarElement, PointElement, LineElement, Tooltip, Legend)

const labels = ['Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug']
const chartOpts = {
  responsive: true,
  plugins: { legend: { labels: { color: colors.muted } } },
  scales: {
    x: { ticks: { color: colors.muted }, grid: { color: 'rgba(0,53,84,.06)' } },
    y: { ticks: { color: colors.muted }, grid: { color: 'rgba(0,53,84,.06)' } },
  },
}

export function DashboardPage() {
  const [mode, setMode] = useState('freelance')

  return (
    <div>
      <PageHeader
        title="Dashboard"
        subtitle="BRD 5.2.1 metrics · 5.2.2 weighting. Values from Core APIs."
      />

      <SegmentedControl
        value={mode}
        onChange={setMode}
        options={[
          { value: 'freelance', label: 'Freelance FYP (weighted)' },
          { value: 'internal', label: 'Internal FYP (weighted)' },
        ]}
      />
      <p className="mb-4 text-xs text-muted">
        Weighting factors applied by Core for {mode === 'freelance' ? 'Freelance' : 'Internal'} FYP.
        Portal displays API results only.
      </p>

      <div className="mb-4 grid grid-cols-2 gap-3 xl:grid-cols-4">
        <KpiCard label="New policies" value="146" hint="Existing active 4,812" />
        <KpiCard label="FYP (Initial + Sub)" value="82.4M" hint="+12% vs last month" />
        <KpiCard label="APE / AFYP" value="61.2M" hint="Above avg productivity" />
        <KpiCard label="Due vs Collected" value="78%" hint="Due 12.0M · Collected 9.4M" />
        <KpiCard label="Commission" value="9.8M" hint="Product (+ UL note)" />
        <KpiCard label="K1 / K2" value="86% / 81%" hint="Grace period on" />
        <KpiCard label="Persistency (count)" value="60%" hint="600 / 1,000 @ 13th mo" />
        <KpiCard label="Road to MDRT" value="68%" hint="Prem 34.2M / 50M" />
      </div>

      <div className="mb-4 grid gap-3.5 lg:grid-cols-2">
        <Card title="Bar · Monthly FYP vs APE">
          <Bar
            data={{
              labels,
              datasets: [
                { label: 'FYP', data: [52, 58, 61, 70, 74, 82], backgroundColor: colors.sky },
                { label: 'APE', data: [40, 44, 48, 55, 58, 61], backgroundColor: colors.baltic },
              ],
            }}
            options={chartOpts}
          />
        </Card>
        <Card title="Line · FYP & persistency trend">
          <Line
            data={{
              labels,
              datasets: [
                { label: 'FYP (M)', data: [52, 58, 61, 70, 74, 82], borderColor: colors.sky, tension: 0.35, fill: false },
                { label: 'K1 %', data: [82, 83, 84, 85, 86, 86], borderColor: colors.baltic, tension: 0.35, fill: false },
              ],
            }}
            options={chartOpts}
          />
        </Card>
      </div>

      <Card title="Core Data · Weighting legend">
        <p className="text-xs text-muted">
          Freelance and Internal FYP use Core-defined weighting factors so every hierarchy level stays
          consistent. Frontend does not recalculate — it renders API payloads.
        </p>
      </Card>
    </div>
  )
}
