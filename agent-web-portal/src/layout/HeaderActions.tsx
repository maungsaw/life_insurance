import { useEffect, useId, useRef, useState, type ReactNode } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { Bell, ChevronDown, KeyRound, Languages, LogOut, UserRound } from 'lucide-react'
import { useAuth } from '@/auth/AuthContext'
import { HAT_PROFILES, type PortalHat } from '@/auth/portalRole'
import { cn } from '@/lib/cn'
import { Button, Dialog } from '@/components/ui'

const HATS: PortalHat[] = ['manager', 'fte', 'admin']

export function HeaderActions({ unread = 3 }: { unread?: number }) {
  const { logout, profile, hat, setHat, lang, setLang } = useAuth()
  const nav = useNavigate()
  const [open, setOpen] = useState(false)
  const [signOutOpen, setSignOutOpen] = useState(false)
  const menuRef = useRef<HTMLDivElement>(null)
  const menuId = useId()

  useEffect(() => {
    if (!open) return
    const onDoc = (e: MouseEvent) => {
      if (!menuRef.current?.contains(e.target as Node)) setOpen(false)
    }
    const onKey = (e: KeyboardEvent) => {
      if (e.key === 'Escape') setOpen(false)
    }
    document.addEventListener('mousedown', onDoc)
    document.addEventListener('keydown', onKey)
    return () => {
      document.removeEventListener('mousedown', onDoc)
      document.removeEventListener('keydown', onKey)
    }
  }, [open])

  const badge = unread > 9 ? '9+' : String(unread)

  return (
    <div className="flex items-center gap-2 sm:gap-3">
      <div className="hidden items-center rounded-xl border border-line bg-white p-0.5 md:flex">
        {HATS.map((h) => (
          <button
            key={h}
            type="button"
            onClick={() => {
              setHat(h)
              nav(HAT_PROFILES[h].landing)
            }}
            className={cn(
              'rounded-lg px-2.5 py-1.5 text-[11px] font-extrabold transition',
              hat === h ? 'bg-steel text-white' : 'text-muted hover:text-deep',
            )}
          >
            {HAT_PROFILES[h].label}
          </button>
        ))}
      </div>

      <Link
        to="/notifications"
        aria-label={`Notifications, ${unread} unread`}
        className="relative grid size-10 place-items-center rounded-xl border border-line bg-white text-deep transition hover:border-steel/40 hover:bg-soft"
      >
        <Bell className="size-[18px]" />
        {unread > 0 ? (
          <span className="absolute top-1.5 right-1.5 grid min-w-4 place-items-center rounded-full border-2 border-white bg-danger px-1 text-[10px] font-extrabold leading-none text-white">
            {badge}
          </span>
        ) : null}
      </Link>

      <div className="relative" ref={menuRef}>
        <button
          type="button"
          aria-haspopup="menu"
          aria-expanded={open}
          aria-controls={menuId}
          onClick={() => setOpen((v) => !v)}
          className="flex items-center gap-2 rounded-xl border border-transparent px-1.5 py-1 transition hover:border-line hover:bg-soft"
        >
          <div className="hidden text-right sm:block">
            <div className="text-sm font-bold text-deep">{profile.name}</div>
            <div className="text-[11px] text-muted">{profile.roleLine}</div>
          </div>
          <div className="grid size-9 place-items-center rounded-full bg-deep text-sm font-extrabold text-white">
            {profile.initial}
          </div>
          <ChevronDown className={cn('size-4 text-muted transition', open && 'rotate-180')} />
        </button>

        {open ? (
          <div
            id={menuId}
            role="menu"
            className="absolute right-0 z-20 mt-2 w-60 overflow-hidden rounded-2xl border border-line bg-white py-1.5 shadow-[0_18px_50px_rgba(0,53,84,0.14)]"
          >
            <div className="border-b border-line px-3.5 py-2.5 sm:hidden">
              <div className="text-sm font-bold">{profile.name}</div>
              <div className="text-[11px] text-muted">{profile.roleLine}</div>
            </div>
            <p className="px-3.5 pt-2 text-[10px] font-extrabold tracking-wide text-muted uppercase">
              {lang === 'mm' ? 'ကြည့်ရှုမည့်အမြင်' : 'View as'}
            </p>
            <div className="flex gap-1 px-3 pb-2 md:hidden">
              {HATS.map((h) => (
                <button
                  key={h}
                  type="button"
                  className={cn(
                    'flex-1 rounded-lg px-2 py-1.5 text-[10px] font-extrabold',
                    hat === h ? 'bg-steel text-white' : 'bg-soft text-muted',
                  )}
                  onClick={() => {
                    setHat(h)
                    setOpen(false)
                    nav(HAT_PROFILES[h].landing)
                  }}
                >
                  {HAT_PROFILES[h].label}
                </button>
              ))}
            </div>
            <MenuItem
              icon={<UserRound className="size-4" />}
              label={lang === 'mm' ? 'ပရိုဖိုင်' : 'Profile'}
              onClick={() => {
                setOpen(false)
                nav('/profile')
              }}
            />
            <MenuItem
              icon={<KeyRound className="size-4" />}
              label={lang === 'mm' ? 'စကားဝှက်ပြောင်း' : 'Change password'}
              onClick={() => {
                setOpen(false)
                nav('/profile/password')
              }}
            />
            <MenuItem
              icon={<Languages className="size-4" />}
              label={lang === 'en' ? 'Language · ENG' : 'ဘာသာ · MM'}
              onClick={() => setLang(lang === 'en' ? 'mm' : 'en')}
            />
            <div className="my-1.5 border-t border-line" />
            <button
              type="button"
              role="menuitem"
              className="flex w-full items-center gap-2.5 px-3.5 py-2.5 text-left text-sm font-bold text-danger transition hover:bg-red-50"
              onClick={() => {
                setOpen(false)
                setSignOutOpen(true)
              }}
            >
              <LogOut className="size-4" />
              {lang === 'mm' ? 'ထွက်မည်' : 'Sign out'}
            </button>
          </div>
        ) : null}
      </div>

      <Dialog
        open={signOutOpen}
        onClose={() => setSignOutOpen(false)}
        title={lang === 'mm' ? 'ထွက်မည်လား။' : 'Sign out?'}
        subtitle={lang === 'mm' ? 'ဤစက်တွင် session ပိတ်မည်' : 'Ends this desk session on this browser'}
        footer={
          <>
            <Button variant="secondary" type="button" onClick={() => setSignOutOpen(false)}>
              {lang === 'mm' ? 'မလုပ်တော့' : 'Cancel'}
            </Button>
            <Button
              variant="danger"
              type="button"
              onClick={() => {
                setSignOutOpen(false)
                logout()
                nav('/login')
              }}
            >
              {lang === 'mm' ? 'ထွက်မည်' : 'Sign out'}
            </Button>
          </>
        }
      >
        <p className="text-sm text-muted">
          {lang === 'mm'
            ? 'Agent App ရှိ biometric ကို မထိပါ။ ပြန်ဝင်ရန် OTP လိုအပ်နိုင်သည်။'
            : 'Does not clear Agent App biometric. You may need SMS OTP to sign in again.'}
        </p>
      </Dialog>
    </div>
  )
}

function MenuItem({
  icon,
  label,
  onClick,
}: {
  icon: ReactNode
  label: string
  onClick: () => void
}) {
  return (
    <button
      type="button"
      role="menuitem"
      onClick={onClick}
      className="flex w-full items-center gap-2.5 px-3.5 py-2.5 text-left text-sm font-bold text-deep transition hover:bg-soft"
    >
      <span className="text-muted">{icon}</span>
      {label}
    </button>
  )
}
