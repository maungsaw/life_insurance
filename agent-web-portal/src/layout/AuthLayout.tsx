import type { ReactNode } from 'react'
import { Link } from 'react-router-dom'
import { BrandLogo } from '@/components/BrandLogo'
import { PLATFORM_NAME } from '@/lib/brand'

export function AuthLayout({
  children,
  title,
  subtitle,
  backTo,
  showBrand = false,
}: {
  children: ReactNode
  title: string
  subtitle?: string
  backTo?: string
  /** Show full platform name under the logo (login). */
  showBrand?: boolean
}) {
  return (
    <div className="grid min-h-screen place-items-center p-6">
      <div className="w-full max-w-[420px] rounded-[22px] border border-line bg-white p-7 shadow-[0_18px_50px_rgba(0,53,84,0.1)]">
        {backTo ? (
          <Link to={backTo} className="mb-3 inline-block text-sm font-bold text-steel no-underline">
            ← Back
          </Link>
        ) : null}

        <div className={showBrand ? 'mb-4 text-center' : 'mb-3'} title={PLATFORM_NAME}>
          <BrandLogo className={showBrand ? 'mb-3' : 'mb-0 justify-start'} imgClassName={showBrand ? 'h-14' : 'h-10'} />
          {showBrand ? (
            <p className="font-display text-[17px] leading-snug font-semibold text-deep">
              KBZ LIFE Agency Sales
              <br />
              Digital Platform
            </p>
          ) : null}
        </div>

        <h1 className="font-display mt-2 text-[26px] text-deep">{title}</h1>
        {subtitle ? <p className="mb-4 mt-1.5 text-sm text-muted">{subtitle}</p> : null}
        {children}
      </div>
    </div>
  )
}
