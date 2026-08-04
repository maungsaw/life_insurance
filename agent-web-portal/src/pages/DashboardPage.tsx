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

ChartJS.register(CategoryScale, LinearScale, BarElement, PointElement, LineElement, Tooltip, Legend)

const labels = ['Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug']

export function DashboardPage() {
  const [mode, setMode] = useState<'freelance' | 'internal'>('freelance')

  const barData = {
    labels,
    datasets: [
      { label: 'FYP', data: [52, 58, 61, 70, 74, 82], backgroundColor: '#00A6FB' },
      { label: 'APE', data: [40, 44, 48, 55, 58, 61], backgroundColor: '#006494' },
    ],
  }
  const lineData = {
    labels,
    datasets: [
      { label: 'FYP (M)', data: [52, 58, 61, 70, 74, 82], borderColor: '#00A6FB', tension: 0.35, fill: false },
      { label: 'K1 %', data: [82, 83, 84, 85, 86, 86], borderColor: '#006494', tension: 0.35, fill: false },
    ],
  }
  const chartOpts = {
    responsive: true,
    plugins: { legend: { labels: { color: '#5A7390' } } },
    scales: {
      x: { ticks: { color: '#5A7390' }, grid: { color: 'rgba(0,0,0,.06)' } },
      y: { ticks: { color: '#5A7390' }, grid: { color: 'rgba(0,0,0,.06)' } },
    },
  }

  return (
    <div>
      <h1 className="page-title">Dashboard</h1>
      <p className="page-sub">BRD 5.2.1 metrics · 5.2.2 weighting (Freelance FYP / Internal FYP). Values from Core APIs.</p>

      <div className="seg">
        <button type="button" className={mode === 'freelance' ? 'on' : ''} onClick={() => setMode('freelance')}>
          Freelance FYP (weighted)
        </button>
        <button type="button" className={mode === 'internal' ? 'on' : ''} onClick={() => setMode('internal')}>
          Internal FYP (weighted)
        </button>
      </div>
      <p className="note">
        Weighting factors applied by Core for {mode === 'freelance' ? 'Freelance' : 'Internal'} FYP. Portal displays API
        results only.
      </p>

      <div className="kpis">
        <div className="kpi"><div className="l">New policies</div><div className="v">146</div><div className="d">Existing active 4,812</div></div>
        <div className="kpi"><div className="l">FYP (Initial + Sub)</div><div className="v">82.4M</div><div className="d">+12% vs last month</div></div>
        <div className="kpi"><div className="l">APE / AFYP</div><div className="v">61.2M</div><div className="d">Above avg productivity</div></div>
        <div className="kpi"><div className="l">Due vs Collected</div><div className="v">78%</div><div className="d">Due 12.0M · Collected 9.4M</div></div>
        <div className="kpi"><div className="l">Commission</div><div className="v">9.8M</div><div className="d">Product (+ UL note)</div></div>
        <div className="kpi"><div className="l">K1 / K2</div><div className="v">86% / 81%</div><div className="d">Grace period on</div></div>
        <div className="kpi"><div className="l">Persistency (count)</div><div className="v">60%</div><div className="d">600 / 1,000 @ 13th mo</div></div>
        <div className="kpi"><div className="l">Road to MDRT</div><div className="v">68%</div><div className="d">Prem 34.2M / 50M</div></div>
      </div>

      <div className="charts">
        <div className="card">
          <h3>Bar · Monthly FYP vs APE</h3>
          <Bar data={barData} options={chartOpts} />
        </div>
        <div className="card">
          <h3>Line · FYP & persistency trend</h3>
          <Line data={lineData} options={chartOpts} />
        </div>
      </div>

      <div className="card">
        <h3>Core Data · Weighting legend</h3>
        <p className="note" style={{ margin: 0 }}>
          Freelance and Internal FYP use Core-defined weighting factors so every hierarchy level stays consistent.
          Frontend does not recalculate — it renders API payloads.
        </p>
      </div>
    </div>
  )
}
