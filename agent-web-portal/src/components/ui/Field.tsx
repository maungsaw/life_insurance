import type { InputHTMLAttributes, SelectHTMLAttributes, TextareaHTMLAttributes, ReactNode } from 'react'
import { cn } from '@/lib/cn'

export function Field({
  label,
  children,
  className,
}: {
  label: string
  children: ReactNode
  className?: string
}) {
  return (
    <label className={cn('mb-3.5 flex flex-col gap-1.5', className)}>
      <span className="text-xs font-bold text-muted">{label}</span>
      {children}
    </label>
  )
}

const control =
  'w-full rounded-xl border border-line bg-white px-3 py-2.5 text-deep outline-none transition focus:border-sky focus:ring-2 focus:ring-sky/25'

export function Input({ className, ...props }: InputHTMLAttributes<HTMLInputElement>) {
  return <input className={cn(control, className)} {...props} />
}

export function Select({ className, children, ...props }: SelectHTMLAttributes<HTMLSelectElement>) {
  return (
    <select className={cn(control, className)} {...props}>
      {children}
    </select>
  )
}

export function Textarea({ className, ...props }: TextareaHTMLAttributes<HTMLTextAreaElement>) {
  return <textarea className={cn(control, 'min-h-20 resize-y', className)} {...props} />
}
