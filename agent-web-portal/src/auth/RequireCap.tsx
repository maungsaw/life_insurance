import type { ReactNode } from 'react'
import { Navigate } from 'react-router-dom'
import { useAuth } from '@/auth/AuthContext'

export function RequireAdmin({ children }: { children: ReactNode }) {
  const { authed, caps, landing } = useAuth()
  if (!authed) return <Navigate to="/login" replace />
  if (!caps.canAdmin) return <Navigate to={landing} replace />
  return children
}

export function RequireWipe({ children }: { children: ReactNode }) {
  const { authed, caps, landing } = useAuth()
  if (!authed) return <Navigate to="/login" replace />
  if (!caps.canWipe) return <Navigate to={landing} replace />
  return children
}

export function HomeRedirect() {
  const { landing } = useAuth()
  return <Navigate to={landing} replace />
}
