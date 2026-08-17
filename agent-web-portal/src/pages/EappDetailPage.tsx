import { Link, Navigate, useParams } from 'react-router-dom'
import { Button, Card, PageHeader, Pill } from '@/components/ui'
import { useAuth } from '@/auth/AuthContext'
import { customerById, eappById, inManagerSlice } from '@/data/hqBook'
import { eappTone } from '@/pages/EappsPage'

export function EappDetailPage() {
  const { id } = useParams()
  const { hat } = useAuth()
  const app = id ? eappById(id) : undefined
  if (!app || !inManagerSlice(app.district, hat)) return <Navigate to="/eapps" replace />
  const customer = customerById(app.customerId)

  return (
    <div>
      <PageHeader
        title={app.ref}
        subtitle={`${app.product} · ${app.ownerFa} · read-only dossier`}
        actions={
          <Link to="/eapps">
            <Button variant="secondary" type="button">
              Back to e-Apps
            </Button>
          </Link>
        }
      />

      <div className="grid gap-3.5 lg:grid-cols-2">
        <Card title="Application">
          <dl className="grid gap-2 text-sm">
            <Row label="Party" value={app.party} />
            <Row label="Status" value={app.status} />
            <Row label="Updated" value={app.when} />
            <Row label="District" value={app.district} />
            {app.policyRef ? <Row label="Policy" value={app.policyRef} /> : null}
          </dl>
          <div className="mt-3">
            <Pill tone={eappTone(app.status)}>{app.status}</Pill>
          </div>
          {app.correction ? (
            <p className="mt-3 rounded-xl border border-danger/30 bg-red-50 px-3 py-2 text-sm text-danger">
              {app.correction}
            </p>
          ) : null}
          <div className="mt-4 flex flex-wrap gap-2">
            {app.status === 'Mark for Correction' ? (
              <Link to="/tasks?type=e-App">
                <Button type="button">Open task</Button>
              </Link>
            ) : null}
            {customer ? (
              <Link to={`/crm/customers/${customer.id}`}>
                <Button variant="secondary" type="button">
                  Open CRM record
                </Button>
              </Link>
            ) : null}
          </div>
          <p className="mt-3 text-xs text-muted">The wizard is not on this portal. Drafts stay on the Agent App.</p>
        </Card>

        <Card title="Timeline">
          <ol className="space-y-3">
            {app.timeline.map((t) => (
              <li key={t.at} className="border-l-2 border-sky pl-3 text-sm">
                <div className="text-[11px] font-bold text-muted">{t.at}</div>
                <div className="font-bold text-deep">{t.label}</div>
              </li>
            ))}
          </ol>
        </Card>
      </div>
    </div>
  )
}

function Row({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex justify-between gap-3 border-b border-line/70 pb-2 last:border-0">
      <dt className="text-xs font-bold text-muted">{label}</dt>
      <dd className="text-right font-bold text-deep">{value}</dd>
    </div>
  )
}
