import { useNavigate } from 'react-router-dom'
import { AuthLayout } from '@/layout/AuthLayout'
import { Button, Field, Input, Textarea } from '@/components/ui'

export function ForgotPage() {
  const nav = useNavigate()
  return (
    <AuthLayout
      backTo="/login"
      title="Reset password"
      subtitle="We’ll verify with an SMS code. Please add a short note for security."
    >
      <Field label="Why are you resetting? *">
        <Textarea rows={2} defaultValue="Forgot password after device change" />
      </Field>
      <Field label="New password">
        <Input type="password" defaultValue="••••••••" />
      </Field>
      <Button className="w-full" type="button" onClick={() => nav('/login')}>
        Update & return
      </Button>
    </AuthLayout>
  )
}
