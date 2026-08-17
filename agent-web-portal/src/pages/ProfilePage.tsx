import { Link } from 'react-router-dom'
import { Button, Card, PageHeader, Pill } from '@/components/ui'
import { useAuth } from '@/auth/AuthContext'

export function ProfilePage() {
  const { profile, hat, lang, caps } = useAuth()

  return (
    <div>
      <PageHeader
        title="Profile"
        subtitle="Account on this portal · biometric stays on the Agent App"
        actions={
          <Link to="/profile/password">
            <Button type="button">Change password</Button>
          </Link>
        }
      />

      <div className="grid gap-3.5 lg:grid-cols-2">
        <Card title="Identity">
          <dl className="grid gap-3 text-sm">
            <Row label="Name" value={profile.name} />
            <Row label="Role" value={profile.roleLine} />
            <Row label="Portal hat" value={profile.label} />
            <Row label="Mobile" value={profile.mobile} />
            <Row label="District" value={profile.district} />
            <Row label="Language" value={lang === 'en' ? 'English' : 'မြန်မာ'} />
          </dl>
        </Card>
        <Card title="Capabilities (this session)">
          <div className="flex flex-wrap gap-1.5">
            {caps.canViewDistrict ? <Pill tone="ok">District view</Pill> : null}
            {caps.canViewPortfolio ? <Pill tone="ok">Portfolio</Pill> : null}
            {caps.canExport ? <Pill>Export</Pill> : null}
            {caps.canViewBook ? <Pill tone="ok">CRM book</Pill> : null}
            {caps.canViewAllBooks ? <Pill>All books</Pill> : null}
            {caps.canManageUsers ? <Pill tone="ok">Users</Pill> : null}
            {caps.canAdmin ? <Pill tone="ok">Admin setup</Pill> : <Pill>No admin write</Pill>}
            {caps.canWipe ? <Pill tone="warn">Remote wipe</Pill> : null}
          </div>
          <p className="mt-3 text-xs text-muted">
            Prototype: use <b className="text-deep">View as</b> in the header to switch Manager / FTE / Admin.
            {hat === 'admin'
              ? ' Admin lands on Management — CRM / e-Apps / Users are extra HQ desks.'
              : ' Field selling stays on the Agent App. This portal CRM is the book, not the wizard.'}
          </p>
        </Card>
      </div>
    </div>
  )
}

function Row({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex items-baseline justify-between gap-3 border-b border-line/80 pb-2 last:border-0 last:pb-0">
      <dt className="text-xs font-bold text-muted">{label}</dt>
      <dd className="font-bold text-deep">{value}</dd>
    </div>
  )
}
