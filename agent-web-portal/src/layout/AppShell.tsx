import { useEffect, useState, type ReactNode } from 'react'
import { NavLink, Outlet, useLocation } from 'react-router-dom'
import {
  LayoutDashboard,
  CheckSquare,
  FolderCog,
  Shield,
  ChevronDown,
  ChevronUp,
  Library,
  BellRing,
  Megaphone,
  Smartphone,
  PieChart,
  UsersRound,
  // Package, // Products tab — restore with nav child below when needed
} from 'lucide-react'
import { HeaderActions } from '@/layout/HeaderActions'
import { BrandLogo } from '@/components/BrandLogo'
import { PLATFORM_NAME, PLATFORM_SHORT } from '@/lib/brand'
import { cn } from '@/lib/cn'

const DASH_CHILDREN = [
  { to: 'overview', label: 'Overview', icon: PieChart },
  { to: 'team-performance', label: 'Team Performance', icon: UsersRound },
] as const

const MGMT_CHILDREN = [
  { to: 'resources', label: 'Resource', icon: Library },
  { to: 'notifications', label: 'Notification', icon: BellRing },
  { to: 'announcements', label: 'Announcement', icon: Megaphone },
  // { to: 'products', label: 'Products', icon: Package }, // hidden for now
  { to: 'devices', label: 'Remote data wipe', icon: Smartphone },
] as const

function linkClass(active: boolean, compact?: boolean) {
  return cn(
    'flex items-center gap-2.5 rounded-xl px-3 py-2.5 text-[13px] font-bold transition max-lg:justify-center max-lg:px-2',
    compact && 'py-2 pl-3 text-[12px] max-lg:pl-2',
    active ? 'bg-sky text-white' : 'text-white/75 hover:bg-white/10 hover:text-white',
  )
}

function NavGroup({
  label,
  icon: Icon,
  active,
  open,
  onToggle,
  children,
}: {
  label: string
  icon: typeof LayoutDashboard
  active: boolean
  open: boolean
  onToggle: () => void
  children: ReactNode
}) {
  return (
    <div className={cn('rounded-xl', active && 'bg-white/5')}>
      <button
        type="button"
        title={label}
        onClick={onToggle}
        className={cn(
          'flex w-full items-center gap-2.5 rounded-xl px-3 py-2.5 text-[13px] font-bold transition max-lg:justify-center max-lg:px-2',
          active ? 'text-white' : 'text-white/75 hover:bg-white/10 hover:text-white',
        )}
        aria-expanded={open}
      >
        <Icon className="size-4 shrink-0" />
        <span className="max-lg:hidden flex-1 text-left">{label}</span>
        {open ? (
          <ChevronUp className="size-4 shrink-0 opacity-80 max-lg:hidden" />
        ) : (
          <ChevronDown className="size-4 shrink-0 opacity-80 max-lg:hidden" />
        )}
      </button>
      {open ? <div className="mb-1 space-y-0.5 pb-1 max-lg:px-0 lg:pl-2">{children}</div> : null}
    </div>
  )
}

export function AppShell() {
  const { pathname } = useLocation()
  const onDashboard = pathname.startsWith('/dashboard')
  const onManagement = pathname.startsWith('/management')
  const [dashOpen, setDashOpen] = useState(onDashboard)
  const [mgmtOpen, setMgmtOpen] = useState(onManagement)

  useEffect(() => {
    if (onDashboard) setDashOpen(true)
  }, [onDashboard])

  useEffect(() => {
    if (onManagement) setMgmtOpen(true)
  }, [onManagement])

  return (
    <div className="grid min-h-screen grid-cols-[72px_1fr] lg:grid-cols-[220px_1fr]">
      <aside className="flex flex-col gap-1 bg-gradient-to-b from-deep to-baltic p-3 text-white">
        <div className="mb-3 px-1 pt-1 text-center lg:px-2 lg:text-left" title={PLATFORM_NAME}>
          <BrandLogo
            className="mb-2 justify-center rounded-xl bg-white/95 px-2 py-1.5 lg:justify-start"
            imgClassName="h-8 max-lg:h-7"
          />
          <div className="hidden font-display text-[13px] font-semibold leading-snug lg:block">
            {PLATFORM_SHORT}
            <small className="mt-0.5 block font-sans text-[10px] font-semibold tracking-wide text-white/65 uppercase">
              Digital Platform
            </small>
          </div>
        </div>

        <NavGroup
          label="Dashboard"
          icon={LayoutDashboard}
          active={onDashboard}
          open={dashOpen}
          onToggle={() => setDashOpen((v) => !v)}
        >
          {DASH_CHILDREN.map(({ to, label, icon: ChildIcon }) => (
            <NavLink
              key={to}
              to={`/dashboard/${to}`}
              title={label}
              className={({ isActive }) => linkClass(isActive, true)}
            >
              <ChildIcon className="size-3.5 shrink-0" />
              <span className="max-lg:hidden">{label}</span>
            </NavLink>
          ))}
        </NavGroup>

        <NavLink to="/tasks" title="Tasks" className={({ isActive }) => linkClass(isActive)}>
          <CheckSquare className="size-4 shrink-0" />
          <span className="max-lg:hidden">Tasks</span>
        </NavLink>

        <NavGroup
          label="Management"
          icon={FolderCog}
          active={onManagement}
          open={mgmtOpen}
          onToggle={() => setMgmtOpen((v) => !v)}
        >
          {MGMT_CHILDREN.map(({ to, label, icon: ChildIcon }) => (
            <NavLink
              key={to}
              to={`/management/${to}`}
              title={label}
              className={({ isActive }) => linkClass(isActive, true)}
            >
              <ChildIcon className="size-3.5 shrink-0" />
              <span className="max-lg:hidden">{label}</span>
            </NavLink>
          ))}
        </NavGroup>

        <NavLink to="/audit" title="Audit" className={({ isActive }) => linkClass(isActive)}>
          <Shield className="size-4 shrink-0" />
          <span className="max-lg:hidden">Audit</span>
        </NavLink>
      </aside>

      <div className="flex min-w-0 flex-col">
        <header className="sticky top-0 z-10 flex items-center justify-between gap-4 border-b border-line bg-white/90 px-5 py-3.5 backdrop-blur-md">
          <div className="flex min-w-0 items-center gap-2.5 font-extrabold text-deep" title={PLATFORM_NAME}>
            <BrandLogo className="shrink-0" imgClassName="h-9" />
            <div className="min-w-0 leading-tight">
              <span className="block truncate text-sm sm:text-[15px]">{PLATFORM_SHORT}</span>
              <span className="hidden text-xs font-semibold text-muted sm:block">Digital Platform · Web</span>
            </div>
          </div>
          <HeaderActions unread={3} />
        </header>
        <main className="p-5 md:p-6">
          <Outlet />
        </main>
      </div>
    </div>
  )
}
