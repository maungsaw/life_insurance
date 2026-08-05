import type { ReactNode } from 'react'
import { Link } from 'react-router-dom'

export function AuthLayout({
  children,
  title,
  subtitle,
  backTo,
}: {
  children: ReactNode
  title: string
  subtitle?: string
  backTo?: string
}) {
  return (
    <div className="grid min-h-screen place-items-center p-6">
      <div className="w-full max-w-[420px] rounded-[22px] border border-line bg-white p-7 shadow-[0_18px_50px_rgba(0,53,84,0.1)]">
        {backTo ? (
          <Link to={backTo} className="mb-2 inline-block text-sm font-bold text-steel no-underline">
            ← Back
          </Link>
        ) : (
          <div className="mb-2 grid size-12 place-items-center rounded-2xl bg-gradient-to-br from-sky to-baltic text-sm font-extrabold text-white">
            KL
          </div>
        )}
        <h1 className="font-display mt-2 text-[26px] text-deep">{title}</h1>
        {subtitle ? <p className="mb-4 mt-1.5 text-sm text-muted">{subtitle}</p> : null}
        {children}
      </div>
    </div>
  )
}
