import { Link, useNavigate } from 'react-router-dom'
import { AuthLayout } from '@/layout/AuthLayout'
import { Button, Field, Input } from '@/components/ui'

export function LoginPage() {
  const nav = useNavigate()
  return (
    <AuthLayout
      title="KBZ LIFE Agent Portal"
      subtitle="Enter your registered mobile number and password. We’ll send an SMS code next."
    >
      <Field label="Mobile number">
        <Input defaultValue="09 771 234 567" />
      </Field>
      <Field label="Password">
        <Input type="password" defaultValue="••••••••" />
      </Field>
      <Button className="mt-1 w-full" type="button" onClick={() => nav('/otp')}>
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
