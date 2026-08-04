import type { ReactNode } from 'react'
import { cn } from '@/lib/cn'

export function KpiCard({
  label,
  value,
  hint,
  className,
}: {
  label: string
  value: string
  hint?: string
  className?: string
}) {
  return (
    <div className={cn('rounded-2xl border border-line bg-card p-3.5', className)}>
      <div className="text-[11px] font-bold uppercase tracking-wide text-muted">{label}</div>
      <div className="font-display mt-1 text-[26px] leading-none text-deep">{value}</div>
      {hint ? <div className="mt-1 text-xs text-muted">{hint}</div> : null}
    </div>
  )
}

export function DataTable({
  headers,
  children,
  className,
}: {
  headers: string[]
  children: ReactNode
  className?: string
}) {
  return (
    <div className={cn('overflow-auto', className)}>
      <table className="w-full border-collapse text-sm">
        <thead>
          <tr>
            {headers.map((h) => (
              <th
                key={h}
                className="whitespace-nowrap border-b border-line px-2 py-2.5 text-left text-[11px] font-bold uppercase tracking-wide text-muted"
              >
                {h}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>{children}</tbody>
      </table>
    </div>
  )
}

export function Td({ children, className }: { children: ReactNode; className?: string }) {
  return (
    <td className={cn('whitespace-nowrap border-b border-line px-2 py-2.5 text-deep', className)}>
      {children}
    </td>
  )
}
