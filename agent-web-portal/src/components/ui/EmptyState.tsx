import type { ReactNode } from 'react'
import { cn } from '@/lib/cn'

export function EmptyState({
  title,
  hint,
  action,
  className,
}: {
  title: string
  hint?: string
  action?: ReactNode
  className?: string
}) {
  return (
    <div className={cn('px-4 py-10 text-center', className)}>
      <p className="text-sm font-extrabold text-deep">{title}</p>
      {hint ? <p className="mx-auto mt-1 max-w-sm text-xs text-muted">{hint}</p> : null}
      {action ? <div className="mt-3">{action}</div> : null}
    </div>
  )
}
