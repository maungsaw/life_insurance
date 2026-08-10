import { cn } from '@/lib/cn'
import { PLATFORM_LOGO_ALT, PLATFORM_LOGO_URL, PLATFORM_NAME } from '@/lib/brand'

type BrandLogoProps = {
  className?: string
  /** Image height class — default h-10 */
  imgClassName?: string
}

/** Official KBZ LIFE mark (shared with mobile mockup). */
export function BrandLogo({ className, imgClassName }: BrandLogoProps) {
  return (
    <div className={cn('flex items-center justify-center', className)} title={PLATFORM_NAME}>
      <img
        src={PLATFORM_LOGO_URL}
        alt={PLATFORM_LOGO_ALT}
        className={cn('h-10 w-auto max-w-full object-contain', imgClassName)}
      />
    </div>
  )
}
