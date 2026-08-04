import { NavLink, Outlet, useNavigate } from 'react-router-dom'
import { useAuth } from '../auth/AuthContext'
import './shell.css'

const NAV = [
  ['dashboard', 'Dashboard'],
  ['performance', 'Performance'],
  ['crm', 'CRM'],
  ['policies', 'Policies / Sales'],
  ['tasks', 'Tasks'],
  ['recruit', 'Recruitment'],
  ['announce', 'Announcements'],
  ['ops', 'Operations'],
  ['agents', 'Agents / Audit'],
] as const

export function AppShell() {
  const { logout } = useAuth()
  const nav = useNavigate()

  return (
    <div className="shell">
      <aside className="side">
        <div className="brand">
          KBZ LIFE
          <small>Agent Portal</small>
        </div>
        {NAV.map(([to, label]) => (
          <NavLink key={to} to={`/${to}`} className={({ isActive }) => `navbtn${isActive ? ' on' : ''}`}>
            {label}
          </NavLink>
        ))}
      </aside>
      <div className="main">
        <header className="top">
          <div className="logo">
            <div className="mark">KL</div>
            <div>
              KBZ LIFE <span>· Agency</span>
            </div>
          </div>
          <div className="profile">
            <div className="who">
              <b>Aye Chan</b>
              <div>DM · Yangon</div>
            </div>
            <div className="av">A</div>
            <button
              className="btn btn-secondary"
              type="button"
              onClick={() => {
                logout()
                nav('/login')
              }}
            >
              Sign out
            </button>
          </div>
        </header>
        <div className="body">
          <Outlet />
        </div>
      </div>
    </div>
  )
}
