import { cn } from '@/lib/cn'

export function SegmentedControl({
  options,
  value,
  onChange,
  className,
}: {
  options: { value: string; label: string }[]
  value: string
  onChange: (value: string) => void
  className?: string
}) {
  return (
    <div className={cn('mb-3 inline-flex rounded-full bg-soft p-1', className)}>
      {options.map((o) => (
        <button
          key={o.value}
          type="button"
          onClick={() => onChange(o.value)}
          className={cn(
            'rounded-full px-3.5 py-2 text-sm font-bold transition',
            value === o.value ? 'bg-steel text-white shadow-sm' : 'text-muted hover:text-deep',
          )}
        >
          {o.label}
        </button>
      ))}
    </div>
  )
}
