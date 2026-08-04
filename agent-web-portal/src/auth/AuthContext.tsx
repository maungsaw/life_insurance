import { createContext, useContext, useMemo, useState, type ReactNode } from 'react'

type AuthCtx = {
  authed: boolean
  login: () => void
  logout: () => void
}

const Ctx = createContext<AuthCtx | null>(null)

export function AuthProvider({ children }: { children: ReactNode }) {
  const [authed, setAuthed] = useState(false)
  const value = useMemo(
    () => ({
      authed,
      login: () => setAuthed(true),
      logout: () => setAuthed(false),
    }),
    [authed],
  )
  return <Ctx.Provider value={value}>{children}</Ctx.Provider>
}

export function useAuth() {
  const v = useContext(Ctx)
  if (!v) throw new Error('useAuth outside provider')
  return v
}
