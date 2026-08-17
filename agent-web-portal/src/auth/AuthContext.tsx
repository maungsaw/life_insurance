import { createContext, useContext, useMemo, useState, type ReactNode } from 'react'
import {
  HAT_PROFILES,
  HAT_STORAGE_KEY,
  LANG_STORAGE_KEY,
  capsFor,
  type Caps,
  type HatProfile,
  type PortalHat,
  type PortalLang,
} from '@/auth/portalRole'

type AuthCtx = {
  authed: boolean
  hat: PortalHat
  lang: PortalLang
  caps: Caps
  profile: HatProfile
  landing: string
  login: () => void
  logout: () => void
  setHat: (hat: PortalHat) => void
  setLang: (lang: PortalLang) => void
}

const Ctx = createContext<AuthCtx | null>(null)

function readHat(): PortalHat {
  try {
    const v = sessionStorage.getItem(HAT_STORAGE_KEY)
    if (v === 'fte' || v === 'admin' || v === 'manager') return v
  } catch {
    /* ignore */
  }
  return 'manager'
}

function readLang(): PortalLang {
  try {
    const v = sessionStorage.getItem(LANG_STORAGE_KEY)
    if (v === 'mm' || v === 'en') return v
  } catch {
    /* ignore */
  }
  return 'en'
}

export function AuthProvider({ children }: { children: ReactNode }) {
  const [authed, setAuthed] = useState(false)
  const [hat, setHatState] = useState<PortalHat>(readHat)
  const [lang, setLangState] = useState<PortalLang>(readLang)

  const value = useMemo(() => {
    const profile = HAT_PROFILES[hat]
    return {
      authed,
      hat,
      lang,
      caps: capsFor(hat),
      profile,
      landing: profile.landing,
      login: () => setAuthed(true),
      logout: () => setAuthed(false),
      setHat: (next: PortalHat) => {
        setHatState(next)
        try {
          sessionStorage.setItem(HAT_STORAGE_KEY, next)
        } catch {
          /* ignore */
        }
      },
      setLang: (next: PortalLang) => {
        setLangState(next)
        try {
          sessionStorage.setItem(LANG_STORAGE_KEY, next)
        } catch {
          /* ignore */
        }
      },
    }
  }, [authed, hat, lang])

  return <Ctx.Provider value={value}>{children}</Ctx.Provider>
}

export function useAuth() {
  const v = useContext(Ctx)
  if (!v) throw new Error('useAuth outside provider')
  return v
}
