import type { HTMLAttributes, ReactNode } from 'react'
import { cn } from '@/lib/cn'

export function Card({
  children,
  className,
  title,
  action,
  ...props
}: HTMLAttributes<HTMLDivElement> & {
  title?: string
  action?: ReactNode
}) {
  return (
    <div
      className={cn(
        'rounded-2xl border border-line bg-card p-4 shadow-[0_18px_50px_rgba(0,53,84,0.08)]',
        className,
      )}
      {...props}
    >
      {(title || action) && (
        <div className="mb-3 flex items-center justify-between gap-3">
          {title ? <h3 className="text-sm font-bold text-deep">{title}</h3> : <span />}
          {action}
        </div>
      )}
      {children}
    </div>
  )
}
