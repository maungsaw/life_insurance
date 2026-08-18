import { Link, useNavigate } from 'react-router-dom'
import { useState } from 'react'
import { AuthLayout } from '@/layout/AuthLayout'
import { Button, Field, Input } from '@/components/ui'
import { classifyMobile } from '@/auth/portalRole'

export function LoginPage() {
  const nav = useNavigate()
  const [mobile, setMobile] = useState('09 771 234 567')
  const [gate, setGate] = useState<ReturnType<typeof classifyMobile> | null>(null)

  const onContinue = () => {
    const next = classifyMobile(mobile)
    setGate(next)
    if (next === 'ok') nav('/otp', { state: { mobile } })
  }

  return (
    <AuthLayout
      showBrand
      title="Sign in"
      subtitle="Use your mobile number and password."
    >
      <Field label="Mobile number">
        <Input
          value={mobile}
          onChange={(e) => {
            setMobile(e.target.value)
            setGate(null)
          }}
          inputMode="tel"
        />
      </Field>
      <Field label="Password">
        <Input type="password" defaultValue="••••••••" />
      </Field>

      {gate === 'unknown' ? (
        <p className="mb-3 rounded-xl border border-danger/30 bg-red-50 px-3 py-2.5 text-sm font-semibold text-danger">
          This mobile isn’t active in CORE yet. Registration is handled by HQ on the{' '}
          <b>Application List</b>.
        </p>
      ) : null}
      {gate === 'pending' ? (
        <p className="mb-3 rounded-xl border border-amber-200 bg-amber-50 px-3 py-2.5 text-sm font-semibold text-deep">
          Your request is already on the <b>Application List</b>. The portal will open once HQ activates your account.
        </p>
      ) : null}
      {gate === 'field' ? (
        <p className="mb-3 rounded-xl border border-line bg-soft px-3 py-2.5 text-sm font-semibold text-deep">
          This portal is for managers, FTE, and HQ admin. For selling, use the <b>Agent App</b>.
        </p>
      ) : null}

      <Button className="mt-1 w-full" type="button" onClick={onContinue}>
        Continue
      </Button>
      <div className="mt-3.5 text-center text-sm font-bold">
        <Link to="/forgot" className="text-steel">
          Forgot password?
        </Link>
      </div>
    </AuthLayout>
  )
}
