import { createContext, useCallback, useContext, useMemo, useState, type ReactNode } from 'react'
import {
  CATALOG_HISTORY_SEED,
  CATALOG_SEED,
  duplicateFrom,
  emptyDraft,
  inFlight,
  uniqueCode,
  type CatalogHistoryAction,
  type CatalogHistoryRow,
  type CatalogProduct,
  type ProductGate,
} from '@/data/hqCatalog'
import { useAuth } from '@/auth/AuthContext'

type CatalogCtx = {
  products: CatalogProduct[]
  history: CatalogHistoryRow[]
  byId: (id: string) => CatalogProduct | undefined
  stamp: (action: CatalogHistoryAction, code: string, reason: string) => void
  create: (draft: CatalogProduct) => CatalogProduct
  update: (id: string, patch: Partial<CatalogProduct>, reason?: string) => void
  setGate: (id: string, next: Exclude<ProductGate, 'archived'>, reason: string) => void
  archive: (id: string, reason: string) => { ok: boolean; message?: string }
  unarchive: (id: string) => void
  duplicate: (id: string) => CatalogProduct | undefined
}

const Ctx = createContext<CatalogCtx | null>(null)

function nowStamp() {
  return { when: '17-Aug-2026 17:10', day: '17-Aug-2026' }
}

export function CatalogProvider({ children }: { children: ReactNode }) {
  const { profile } = useAuth()
  const [products, setProducts] = useState(CATALOG_SEED)
  const [history, setHistory] = useState(CATALOG_HISTORY_SEED)
  const by = profile.name

  const stamp = useCallback(
    (action: CatalogHistoryAction, code: string, reason: string) => {
      const { when } = nowStamp()
      setHistory((prev) => [
        { id: `h-${Date.now()}-${Math.random().toString(16).slice(2, 6)}`, when, code, action, reason, by },
        ...prev,
      ])
    },
    [by],
  )

  const value = useMemo<CatalogCtx>(() => {
    const byId = (id: string) => products.find((p) => p.id === id)

    return {
      products,
      history,
      byId,
      stamp,
      create: (draft) => {
        const { day } = nowStamp()
        const created: CatalogProduct = {
          ...emptyDraft(),
          ...draft,
          id: `p-${Date.now()}`,
          status: 'off',
          inFlightQuotes: 0,
          inFlightEapps: 0,
          changedAt: day,
          changedBy: by,
        }
        setProducts((prev) => [created, ...prev])
        stamp('Created', created.code, 'Catalog SKU · starts Off')
        return created
      },
      update: (id, patch, reason = 'Setup saved') => {
        const current = products.find((p) => p.id === id)
        if (!current) return
        const { day } = nowStamp()
        setProducts((prev) =>
          prev.map((p) => (p.id === id ? { ...p, ...patch, id, code: current.code, changedAt: day, changedBy: by } : p)),
        )
        stamp('Updated', current.code, reason)
      },
      setGate: (id, next, reason) => {
        const current = products.find((p) => p.id === id)
        if (!current || current.status === 'archived') return
        const { day } = nowStamp()
        setProducts((prev) =>
          prev.map((p) => (p.id === id ? { ...p, status: next, changedAt: day, changedBy: by } : p)),
        )
        stamp(next === 'on' ? 'Turned on' : 'Turned off', current.code, reason)
      },
      archive: (id, reason) => {
        const current = products.find((p) => p.id === id)
        if (!current) return { ok: false, message: 'Not found' }
        if (current.status === 'on') return { ok: false, message: 'Turn off before archive.' }
        if (current.status === 'archived') return { ok: false, message: 'Already archived.' }
        const { day } = nowStamp()
        setProducts((prev) =>
          prev.map((p) => (p.id === id ? { ...p, status: 'archived', changedAt: day, changedBy: by } : p)),
        )
        const extra = inFlight(current) ? ` · in-flight quotes ${current.inFlightQuotes} / e-Apps ${current.inFlightEapps}` : ''
        stamp('Archived', current.code, `${reason}${extra}`)
        return { ok: true }
      },
      unarchive: (id) => {
        const current = products.find((p) => p.id === id)
        if (!current || current.status !== 'archived') return
        const { day } = nowStamp()
        setProducts((prev) =>
          prev.map((p) => (p.id === id ? { ...p, status: 'off', changedAt: day, changedBy: by } : p)),
        )
        stamp('Unarchived', current.code, 'Back to Off · Turn on separately')
      },
      duplicate: (id) => {
        const current = products.find((p) => p.id === id)
        if (!current) return undefined
        const { day } = nowStamp()
        const copy: CatalogProduct = {
          ...duplicateFrom(current),
          id: `p-${Date.now()}`,
          code: uniqueCode(current.code, products),
          changedAt: day,
          changedBy: by,
        }
        setProducts((prev) => [copy, ...prev])
        stamp('Duplicated', copy.code, `From ${current.code} · starts Off`)
        return copy
      },
    }
  }, [products, history, by, stamp])

  return <Ctx.Provider value={value}>{children}</Ctx.Provider>
}

export function useCatalog() {
  const ctx = useContext(Ctx)
  if (!ctx) throw new Error('useCatalog needs CatalogProvider')
  return ctx
}
