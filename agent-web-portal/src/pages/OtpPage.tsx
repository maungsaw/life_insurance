import { useNavigate } from 'react-router-dom'
import { useAuth } from '@/auth/AuthContext'
import { AuthLayout } from '@/layout/AuthLayout'
import { Button, Input } from '@/components/ui'

export function OtpPage() {
  const nav = useNavigate()
  const { login } = useAuth()
  return (
    <AuthLayout
      backTo="/login"
      title="Enter OTP"
      subtitle="We sent a 6-digit code to 09 771 234 567"
    >
      <div className="mb-4 flex gap-2.5">
        {['4', '8', '2', '1', '9', '0'].map((d, i) => (
          <Input
            key={i}
            defaultValue={d}
            maxLength={1}
            inputMode="numeric"
            className="h-14 min-w-0 flex-1 px-0 text-center text-xl font-extrabold"
          />
        ))}
      </div>
      <Button
        className="w-full"
        type="button"
        onClick={() => {
          login()
          nav('/dashboard/overview')
        }}
      >
        Verify & open portal
      </Button>
    </AuthLayout>
  )
}
