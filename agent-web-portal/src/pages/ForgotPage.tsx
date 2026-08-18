import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { AuthLayout } from '@/layout/AuthLayout'
import { Button, Field, Input, Textarea } from '@/components/ui'
import { classifyMobile } from '@/auth/portalRole'

type Step = 'mobile' | 'otp' | 'reset'

export function ForgotPage() {
  const nav = useNavigate()
  const [step, setStep] = useState<Step>('mobile')
  const [mobile, setMobile] = useState('09 771 234 567')
  const [gate, setGate] = useState<ReturnType<typeof classifyMobile> | null>(null)
  const [remark, setRemark] = useState('')
  const [password, setPassword] = useState('')
  const [confirm, setConfirm] = useState('')

  const onMobile = () => {
    const next = classifyMobile(mobile)
    setGate(next)
    if (next === 'ok') setStep('otp')
  }

  const canReset = remark.trim().length > 0 && password.length >= 8 && password === confirm

  if (step === 'otp') {
    return (
      <AuthLayout backTo="/forgot" title="Enter OTP" subtitle={`Code sent to ${mobile}`}>
        <div className="mb-4 grid grid-cols-6 gap-2">
          {['1', '4', '0', '7', '2', '8'].map((d, i) => (
            <Input
              key={i}
              defaultValue={d}
              maxLength={1}
              inputMode="numeric"
              className="h-14 min-w-0 px-0 text-center text-xl font-extrabold"
            />
          ))}
        </div>
        <Button className="w-full" type="button" onClick={() => setStep('reset')}>
          Verify
        </Button>
      </AuthLayout>
    )
  }

  if (step === 'reset') {
    return (
      <AuthLayout
        backTo="/login"
        title="Reset password"
        subtitle="Add a short remark, then set a new password."
      >
        <Field label="Why are you changing your password? *">
          <Textarea
            rows={2}
            value={remark}
            onChange={(e) => setRemark(e.target.value)}
            placeholder="e.g. I forgot it after switching phones"
          />
        </Field>
        <Field label="New password *">
          <Input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            placeholder="At least 8 characters"
          />
        </Field>
        <Field label="Confirm password *">
          <Input
            type="password"
            value={confirm}
            onChange={(e) => setConfirm(e.target.value)}
          />
        </Field>
        {password && confirm && password !== confirm ? (
          <p className="mb-3 text-sm font-semibold text-danger">Passwords don’t match.</p>
        ) : null}
        <Button className="w-full" type="button" disabled={!canReset} onClick={() => nav('/login')}>
          Save & go to sign in
        </Button>
      </AuthLayout>
    )
  }

  return (
    <AuthLayout
      backTo="/login"
      title="Forgot password"
      subtitle="We’ll verify with SMS OTP, then ask for a short remark."
    >
      <Field label="Mobile number">
        <Input value={mobile} onChange={(e) => { setMobile(e.target.value); setGate(null) }} inputMode="tel" />
      </Field>
      {gate === 'unknown' || gate === 'pending' || gate === 'field' ? (
        <p className="mb-3 rounded-xl border border-danger/30 bg-red-50 px-3 py-2.5 text-sm font-semibold text-danger">
          This number can’t be reset from the portal. HQ will review unknown/pending requests.
        </p>
      ) : null}
      <Button className="w-full" type="button" onClick={onMobile}>
        Send OTP
      </Button>
    </AuthLayout>
  )
}
