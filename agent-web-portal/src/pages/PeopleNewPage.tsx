import { useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { Button, Card, Field, Input, PageHeader, Select } from '@/components/ui'
import { isAccessError, useAccess } from '@/data/AccessContext'
import { activeRoles } from '@/data/hqAccess'
import { classifyMobile } from '@/auth/portalRole'
import type { Channel } from '@/data/hqBook'

export function PeopleNewPage() {
  const nav = useNavigate()
  const { roles, createPerson } = useAccess()
  const live = activeRoles(roles)
  const [name, setName] = useState('')
  const [mobile, setMobile] = useState('')
  const [code, setCode] = useState('')
  const [roleId, setRoleId] = useState(live.find((r) => r.name === 'FA')?.id ?? live[0]?.id ?? '')
  const [channel, setChannel] = useState<Channel>('App')
  const [district, setDistrict] = useState('Yangon A')
  const [err, setErr] = useState('')

  const gate = mobile.trim() ? classifyMobile(mobile) : 'ok'

  const submit = () => {
    if (gate === 'unknown' || gate === 'pending') {
      setErr('This mobile is not CORE-active. Use Audit → Application List.')
      return
    }
    const res = createPerson({ name, mobile, code, roleId, channel, district })
    if (isAccessError(res)) {
      setErr(res.error)
      return
    }
    nav(`/users/${res.id}`, { replace: true })
  }

  return (
    <div>
      <PageHeader
        title="Add person"
        subtitle="CORE-active login only · role from the catalog · unknown stays on Application List"
        actions={
          <Link to="/users/people">
            <Button variant="secondary" type="button">
              Back to people
            </Button>
          </Link>
        }
      />
      {err ? <p className="mb-3 text-xs font-semibold text-danger">{err}</p> : null}
      {gate === 'unknown' || gate === 'pending' ? (
        <p className="mb-3 text-sm text-danger">
          CORE gate blocked.{' '}
          <Link to="/audit?tab=applications" className="font-bold text-steel">
            Open Application List
          </Link>
        </p>
      ) : null}

      <Card className="max-w-xl">
        <Field label="Mobile *">
          <Input value={mobile} onChange={(e) => setMobile(e.target.value)} placeholder="09 …" />
        </Field>
        <Field label="Name *">
          <Input value={name} onChange={(e) => setName(e.target.value)} />
        </Field>
        <Field label="Code">
          <Input value={code} onChange={(e) => setCode(e.target.value)} placeholder="AGT-… or HQ-… (auto if empty)" />
        </Field>
        <Field label="Role *">
          <Select value={roleId} onChange={(e) => setRoleId(e.target.value)}>
            {live.map((r) => (
              <option key={r.id} value={r.id}>
                {r.name}
              </option>
            ))}
          </Select>
        </Field>
        <Field label="Channel">
          <Select value={channel} onChange={(e) => setChannel(e.target.value as Channel)}>
            <option>App</option>
            <option>Portal</option>
            <option>Both</option>
          </Select>
        </Field>
        <Field label="District" className="mb-3">
          <Input value={district} onChange={(e) => setDistrict(e.target.value)} />
        </Field>
        <Button type="button" onClick={submit} disabled={!name.trim() || !mobile.trim() || !roleId}>
          Create login
        </Button>
      </Card>
    </div>
  )
}
