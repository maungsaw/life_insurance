import { NavLink, Outlet, useNavigate } from 'react-router-dom'
import {
  LayoutDashboard,
  LineChart,
  Users,
  FileText,
  CheckSquare,
  UserPlus,
  Megaphone,
  Settings2,
  Shield,
  LogOut,
} from 'lucide-react'
import { useAuth } from '@/auth/AuthContext'
import { Button } from '@/components/ui'
import { cn } from '@/lib/cn'

const NAV = [
  { to: 'dashboard', label: 'Dashboard', icon: LayoutDashboard },
  { to: 'performance', label: 'Performance', icon: LineChart },
  { to: 'crm', label: 'CRM', icon: Users },
  { to: 'policies', label: 'Policies / Sales', icon: FileText },
  { to: 'tasks', label: 'Tasks', icon: CheckSquare },
  { to: 'recruit', label: 'Recruitment', icon: UserPlus },
  { to: 'announce', label: 'Announcements', icon: Megaphone },
  { to: 'ops', label: 'Operations', icon: Settings2 },
  { to: 'agents', label: 'Agents / Audit', icon: Shield },
] as const

export function AppShell() {
  const { logout } = useAuth()
  const nav = useNavigate()

  return (
    <div className="grid min-h-screen lg:grid-cols-[220px_1fr] grid-cols-[72px_1fr]">
      <aside className="flex flex-col gap-1 bg-gradient-to-b from-deep to-baltic p-3 text-white">
        <div className="mb-3 px-2 pt-1 font-display text-xl leading-tight lg:text-left text-center">
          KBZ LIFE
          <small className="mt-1 block font-sans text-[11px] font-semibold opacity-70 max-lg:hidden">
            Agent Portal
          </small>
        </div>
        {NAV.map(({ to, label, icon: Icon }) => (
          <NavLink
            key={to}
            to={`/${to}`}
            className={({ isActive }) =>
              cn(
                'flex items-center gap-2.5 rounded-xl px-3 py-2.5 text-[13px] font-bold transition max-lg:justify-center max-lg:px-2',
                isActive ? 'bg-sky text-white' : 'text-white/75 hover:bg-white/10 hover:text-white',
              )
            }
            title={label}
          >
            <Icon className="size-4 shrink-0" />
            <span className="max-lg:hidden">{label}</span>
          </NavLink>
        ))}
      </aside>

      <div className="flex min-w-0 flex-col">
        <header className="sticky top-0 z-10 flex items-center justify-between gap-4 border-b border-line bg-white/90 px-5 py-3.5 backdrop-blur-md">
          <div className="flex items-center gap-2.5 font-extrabold text-deep">
            <div className="grid size-9 place-items-center rounded-xl bg-gradient-to-br from-sky to-baltic text-xs font-extrabold text-white">
              KL
            </div>
            <div>
              KBZ LIFE <span className="font-semibold text-muted">· Agency</span>
            </div>
          </div>
          <div className="flex items-center gap-2.5">
            <div className="hidden text-right sm:block">
              <div className="text-sm font-bold">Aye Chan</div>
              <div className="text-[11px] text-muted">DM · Yangon</div>
            </div>
            <div className="grid size-9 place-items-center rounded-full bg-deep text-sm font-extrabold text-white">
              A
            </div>
            <Button
              variant="secondary"
              size="sm"
              type="button"
              onClick={() => {
                logout()
                nav('/login')
              }}
            >
              <LogOut className="size-3.5" />
              Sign out
            </Button>
          </div>
        </header>
        <main className="p-5 md:p-6">
          <Outlet />
        </main>
      </div>
    </div>
  )
}
