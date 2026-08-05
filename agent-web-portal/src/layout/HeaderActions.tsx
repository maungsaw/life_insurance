import { useEffect, useId, useRef, useState, type ReactNode } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { Bell, ChevronDown, Languages, LogOut, UserRound } from 'lucide-react'
import { useAuth } from '@/auth/AuthContext'
import { cn } from '@/lib/cn'

export function HeaderActions({ unread = 3 }: { unread?: number }) {
  const { logout } = useAuth()
  const nav = useNavigate()
  const [open, setOpen] = useState(false)
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
            <div className="text-sm font-bold text-deep">Aye Chan</div>
            <div className="text-[11px] text-muted">DM · Yangon</div>
          </div>
          <div className="grid size-9 place-items-center rounded-full bg-deep text-sm font-extrabold text-white">
            A
          </div>
          <ChevronDown className={cn('size-4 text-muted transition', open && 'rotate-180')} />
        </button>

        {open ? (
          <div
            id={menuId}
            role="menu"
            className="absolute right-0 z-20 mt-2 w-56 overflow-hidden rounded-2xl border border-line bg-white py-1.5 shadow-[0_18px_50px_rgba(0,53,84,0.14)]"
          >
            <div className="border-b border-line px-3.5 py-2.5 sm:hidden">
              <div className="text-sm font-bold">Aye Chan</div>
              <div className="text-[11px] text-muted">DM · Yangon</div>
            </div>
            <MenuItem
              icon={<UserRound className="size-4" />}
              label="Profile"
              onClick={() => {
                setOpen(false)
                alert('Profile settings (mock)')
              }}
            />
            <MenuItem
              icon={<Languages className="size-4" />}
              label="Language · ENG"
              onClick={() => {
                setOpen(false)
                alert('Language toggle (mock)')
              }}
            />
            <div className="my-1.5 border-t border-line" />
            <button
              type="button"
              role="menuitem"
              className="flex w-full items-center gap-2.5 px-3.5 py-2.5 text-left text-sm font-bold text-danger transition hover:bg-red-50"
              onClick={() => {
                setOpen(false)
                logout()
                nav('/login')
              }}
            >
              <LogOut className="size-4" />
              Sign out
            </button>
          </div>
        ) : null}
      </div>
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
