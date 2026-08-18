import { useLocation, useNavigate } from 'react-router-dom'
import { useAuth } from '@/auth/AuthContext'
import { AuthLayout } from '@/layout/AuthLayout'
import { Button, Input } from '@/components/ui'

export function OtpPage() {
  const nav = useNavigate()
  const { login, landing } = useAuth()
  const loc = useLocation()
  const mobile =
    (loc.state as { mobile?: string } | null)?.mobile ?? '09 771 234 567'

  return (
    <AuthLayout
      backTo="/login"
      title="Enter OTP"
      subtitle={`Enter the 6-digit code sent to ${mobile}.`}
    >
      <div className="mb-4 grid grid-cols-6 gap-2">
        {['4', '8', '2', '1', '9', '0'].map((d, i) => (
          <Input
            key={i}
            defaultValue={d}
            maxLength={1}
            inputMode="numeric"
            className="h-14 min-w-0 px-0 text-center text-xl font-extrabold"
          />
        ))}
      </div>
      <Button
        className="w-full"
        type="button"
        onClick={() => {
          login()
          nav(landing, { replace: true })
        }}
      >
        Continue to portal
      </Button>
      <p className="mt-3 text-center text-xs text-muted">Resend in 0:28. Same OTP as the Agent App.</p>
    </AuthLayout>
  )
}
