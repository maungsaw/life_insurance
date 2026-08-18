import { createContext, useContext, useMemo, useState, type ReactNode } from 'react'
import { SegmentedControl } from '@/components/ui'

type WeightMode = 'freelance' | 'internal'

type Ctx = {
  mode: WeightMode
  setMode: (m: WeightMode) => void
  wtdLabel: string
}

const DashboardFilterContext = createContext<Ctx | null>(null)

export function DashboardFilterProvider({ children }: { children: ReactNode }) {
  const [mode, setMode] = useState<WeightMode>('freelance')
  const value = useMemo(
    () => ({
      mode,
      setMode,
      wtdLabel: mode === 'freelance' ? 'Wtd Freelance FYP' : 'Wtd Internal FYP',
    }),
    [mode],
  )
  return <DashboardFilterContext.Provider value={value}>{children}</DashboardFilterContext.Provider>
}

export function useDashboardFilters() {
  const ctx = useContext(DashboardFilterContext)
  if (!ctx) throw new Error('useDashboardFilters needs DashboardFilterProvider')
  return ctx
}

/** Shared weighting + hierarchy — same slice on Overview and Team Performance */
export function DashboardFilterBar({ scopeNote }: { scopeNote?: string }) {
  const { mode, setMode } = useDashboardFilters()

  return (
    <>
      <SegmentedControl
        value={mode}
        onChange={(v) => setMode(v as WeightMode)}
        options={[
          { value: 'freelance', label: 'Freelance FYP (weighted)' },
          { value: 'internal', label: 'Internal FYP (weighted)' },
        ]}
      />
      <div className="mb-5 flex flex-wrap items-end gap-2.5 rounded-2xl border border-line bg-card p-3.5">
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
        {scopeNote ? <p className="w-full text-[11px] text-muted md:w-auto md:flex-1 md:pl-2">{scopeNote}</p> : null}
      </div>
    </>
  )
}
