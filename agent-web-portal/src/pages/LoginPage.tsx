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
      subtitle="Same account as the Agent App · mobile + password + SMS OTP"
    >
      <p className="mb-3.5 rounded-xl border border-line bg-soft/70 px-3 py-2.5 text-xs text-muted">
        Session times out after inactivity (same policy as the app). HQ desk has no biometric and no guest
        calculator.
      </p>
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
          This mobile is not active in CORE. Registration is handled on the HQ{' '}
          <b>Application List</b> — it cannot self-register here.
        </p>
      ) : null}
      {gate === 'pending' ? (
        <p className="mb-3 rounded-xl border border-amber-200 bg-amber-50 px-3 py-2.5 text-sm font-semibold text-deep">
          Your request is already on the <b>Application List</b>. The portal stays closed until HQ
          activates the account.
        </p>
      ) : null}
      {gate === 'field' ? (
        <p className="mb-3 rounded-xl border border-line bg-soft px-3 py-2.5 text-sm font-semibold text-deep">
          Field producers use the <b>Agent App</b> to sell. This portal is for managers, FTE, and HQ
          admin.
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
      <p className="mt-4 text-[11px] leading-relaxed text-muted">
        Demo CORE gates: <code className="font-bold">09 000 000 000</code> unknown ·{' '}
        <code className="font-bold">09 111 111 111</code> pending ·{' '}
        <code className="font-bold">09 555 555 555</code> field FA.
      </p>
    </AuthLayout>
  )
}
