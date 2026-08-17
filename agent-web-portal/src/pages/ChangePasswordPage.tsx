import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { Button, Card, Field, Input, PageHeader } from '@/components/ui'

export function ChangePasswordPage() {
  const nav = useNavigate()
  const [step, setStep] = useState<'form' | 'otp'>('form')
  const [current, setCurrent] = useState('')
  const [next, setNext] = useState('')
  const [confirm, setConfirm] = useState('')

  const canSend = current.length > 0 && next.length >= 8 && next === confirm

  return (
    <div>
      <PageHeader
        title="Change password"
        subtitle="Same OTP story as the Agent App · no biometric on web"
      />
      <Card className="max-w-lg">
        {step === 'form' ? (
          <>
            <Field label="Current password *">
              <Input type="password" value={current} onChange={(e) => setCurrent(e.target.value)} />
            </Field>
            <Field label="New password *">
              <Input type="password" value={next} onChange={(e) => setNext(e.target.value)} />
            </Field>
            <Field label="Confirm new password *">
              <Input type="password" value={confirm} onChange={(e) => setConfirm(e.target.value)} />
            </Field>
            {next && confirm && next !== confirm ? (
              <p className="mb-3 text-sm font-semibold text-danger">Passwords do not match.</p>
            ) : null}
            <div className="flex gap-2">
              <Button variant="secondary" type="button" onClick={() => nav('/profile')}>
                Cancel
              </Button>
              <Button type="button" disabled={!canSend} onClick={() => setStep('otp')}>
                Send OTP
              </Button>
            </div>
          </>
        ) : (
          <>
            <p className="mb-3 text-sm text-muted">Enter the 6-digit SMS code to confirm the password change.</p>
            <div className="mb-4 grid grid-cols-6 gap-2">
              {['3', '1', '9', '0', '4', '6'].map((d, i) => (
                <Input
                  key={i}
                  defaultValue={d}
                  maxLength={1}
                  inputMode="numeric"
                  className="h-12 min-w-0 px-0 text-center text-lg font-extrabold"
                />
              ))}
            </div>
            <div className="flex gap-2">
              <Button variant="secondary" type="button" onClick={() => setStep('form')}>
                Back
              </Button>
              <Button type="button" onClick={() => nav('/profile')}>
                Update password
              </Button>
            </div>
          </>
        )}
      </Card>
    </div>
  )
}
