import type { ReactNode } from 'react'
import { cn } from '@/lib/cn'

type Tone = 'default' | 'ok' | 'warn' | 'danger' | 'sky'

const tones: Record<Tone, string> = {
  default: 'bg-soft text-baltic',
  ok: 'bg-emerald-50 text-ok',
  warn: 'bg-amber-50 text-warn',
  danger: 'bg-red-50 text-danger',
  sky: 'bg-sky/15 text-steel',
}

export function Pill({
  children,
  tone = 'default',
  className,
}: {
  children: ReactNode
  tone?: Tone
  className?: string
}) {
  return (
    <span
      className={cn(
        'inline-flex items-center rounded-full px-2 py-0.5 text-[11px] font-bold',
        tones[tone],
        className,
      )}
    >
      {children}
    </span>
  )
}
