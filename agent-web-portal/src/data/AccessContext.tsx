import { createContext, useCallback, useContext, useMemo, useState, type ReactNode } from 'react'
import { useAuth } from '@/auth/AuthContext'
import {
  ACCESS_HISTORY_SEED,
  PEOPLE_SEED,
  PERM_SEED,
  ROLE_SEED,
  adminPeopleCount,
  adminRoleCount,
  mergePack,
  peopleOnRole,
  slugPermKey,
  type AccessHistoryRow,
  type AccessPerson,
  type AccessRole,
  type AccessStatus,
  type PermDef,
  type PermModule,
  type RoleCluster,
} from '@/data/hqAccess'
import type { Channel, PersonStatus } from '@/data/hqBook'

type AccessCtx = {
  roles: AccessRole[]
  perms: PermDef[]
  people: AccessPerson[]
  history: AccessHistoryRow[]
  roleById: (id: string) => AccessRole | undefined
  personById: (id: string) => AccessPerson | undefined
  createRole: (input: { name: string; cluster: RoleCluster; cloneFromId: string; channelDefault: Channel }) => AccessRole | { error: string }
  updateRole: (id: string, patch: Partial<Pick<AccessRole, 'name' | 'cluster' | 'channelDefault'>>) => { error?: string }
  setPackCell: (roleId: string, key: string, on: boolean) => void
  resetRolePack: (roleId: string) => void
  resetSystemPacks: () => void
  archiveRole: (id: string) => { ok: boolean; message?: string }
  unarchiveRole: (id: string) => void
  createPerm: (input: { label: string; module: PermModule; aliasOf: string }) => PermDef | { error: string }
  archivePerm: (key: string) => { ok: boolean; message?: string }
  unarchivePerm: (key: string) => void
  renamePerm: (key: string, label: string) => void
  createPerson: (input: Omit<AccessPerson, 'id' | 'lastLogin' | 'devices' | 'status'> & { status?: PersonStatus }) => AccessPerson | { error: string }
  updatePerson: (id: string, patch: Partial<AccessPerson>) => { error?: string }
  disablePerson: (id: string) => { ok: boolean; message?: string }
}

const Ctx = createContext<AccessCtx | null>(null)

function whenNow() {
  return '18-Aug-2026 09:50'
}

export function AccessProvider({ children }: { children: ReactNode }) {
  const { profile } = useAuth()
  const [roles, setRoles] = useState(ROLE_SEED)
  const [perms, setPerms] = useState(PERM_SEED)
  const [people, setPeople] = useState(PEOPLE_SEED)
  const [history, setHistory] = useState(ACCESS_HISTORY_SEED)
  const by = profile.name

  const stamp = useCallback(
    (action: string, target: string, reason: string) => {
      setHistory((prev) => [
        { id: `ah-${Date.now()}`, when: whenNow(), action, target, reason, by },
        ...prev,
      ])
    },
    [by],
  )

  const value = useMemo<AccessCtx>(() => {
    const roleById = (id: string) => roles.find((r) => r.id === id)
    const personById = (id: string) => people.find((p) => p.id === id)

    return {
      roles,
      perms,
      people,
      history,
      roleById,
      personById,
      createRole: ({ name, cluster, cloneFromId, channelDefault }) => {
        const label = name.trim()
        if (!label) return { error: 'Name is required.' }
        if (roles.some((r) => r.name.toLowerCase() === label.toLowerCase() && r.status === 'active')) {
          return { error: 'A role with this name already exists.' }
        }
        const src = roles.find((r) => r.id === cloneFromId)
        if (!src) return { error: 'Clone-from role is required.' }
        const pack = mergePack(src.pack, perms)
        const created: AccessRole = {
          id: `r-${Date.now()}`,
          name: label,
          cluster,
          system: false,
          status: 'active',
          channelDefault,
          cloneFromId,
          pack,
          seedPack: { ...pack },
        }
        setRoles((prev) => [...prev, created])
        stamp('Created role', label, `Cloned ${src.name} · ${cluster}`)
        return created
      },
      updateRole: (id, patch) => {
        const current = roles.find((r) => r.id === id)
        if (!current) return { error: 'Not found' }
        if (patch.name) {
          const label = patch.name.trim()
          if (roles.some((r) => r.id !== id && r.name.toLowerCase() === label.toLowerCase() && r.status === 'active')) {
            return { error: 'Name already in use.' }
          }
        }
        setRoles((prev) => prev.map((r) => (r.id === id ? { ...r, ...patch, name: patch.name?.trim() ?? r.name } : r)))
        stamp('Updated role', current.name, 'Setup saved')
        return {}
      },
      setPackCell: (roleId, key, on) => {
        setRoles((prev) =>
          prev.map((r) => (r.id === roleId ? { ...r, pack: { ...r.pack, [key]: on } } : r)),
        )
      },
      resetRolePack: (roleId) => {
        const current = roles.find((r) => r.id === roleId)
        if (!current) return
        setRoles((prev) => prev.map((r) => (r.id === roleId ? { ...r, pack: { ...r.seedPack } } : r)))
        stamp('Reset pack', current.name, 'Clone/seed defaults')
      },
      resetSystemPacks: () => {
        setRoles((prev) => prev.map((r) => (r.system ? { ...r, pack: { ...r.seedPack }, status: 'active' } : r)))
        stamp('Reset packs', 'System roles', 'BRD defaults')
      },
      archiveRole: (id) => {
        const current = roles.find((r) => r.id === id)
        if (!current) return { ok: false, message: 'Not found' }
        if (peopleOnRole(people, id).some((p) => p.status !== 'Disabled')) {
          return { ok: false, message: 'Reassign people first.' }
        }
        if (current.pack.users && adminRoleCount(roles) <= 1) {
          return { ok: false, message: 'Cannot archive the last Admin pack with Users.' }
        }
        setRoles((prev) => prev.map((r) => (r.id === id ? { ...r, status: 'archived' as AccessStatus } : r)))
        stamp('Archived role', current.name, current.system ? 'System role hidden' : 'Custom role archived')
        return { ok: true }
      },
      unarchiveRole: (id) => {
        const current = roles.find((r) => r.id === id)
        if (!current) return
        setRoles((prev) => prev.map((r) => (r.id === id ? { ...r, status: 'active' } : r)))
        stamp('Unarchived role', current.name, 'Back to catalog')
      },
      createPerm: ({ label, module, aliasOf }) => {
        const name = label.trim()
        if (!name) return { error: 'Label is required.' }
        if (!aliasOf) return { error: 'Alias a system cap — custom flags cannot invent new powers.' }
        const key = slugPermKey(name)
        if (perms.some((p) => p.key === key || p.label.toLowerCase() === name.toLowerCase())) {
          return { error: 'Label or key already exists.' }
        }
        const created: PermDef = { key, label: name, module, kind: 'custom', status: 'active', aliasOf }
        setPerms((prev) => [...prev, created])
        setRoles((prev) => prev.map((r) => ({ ...r, pack: { ...r.pack, [key]: false } })))
        stamp('Created permission', name, `Alias of ${aliasOf} · ${module}`)
        return created
      },
      archivePerm: (key) => {
        const current = perms.find((p) => p.key === key)
        if (!current) return { ok: false, message: 'Not found' }
        if (current.kind === 'system') return { ok: false, message: 'System caps cannot be archived.' }
        setPerms((prev) => prev.map((p) => (p.key === key ? { ...p, status: 'archived' } : p)))
        stamp('Archived permission', current.label, key)
        return { ok: true }
      },
      unarchivePerm: (key) => {
        const current = perms.find((p) => p.key === key)
        if (!current) return
        setPerms((prev) => prev.map((p) => (p.key === key ? { ...p, status: 'active' } : p)))
        stamp('Unarchived permission', current.label, key)
      },
      renamePerm: (key, label) => {
        const name = label.trim()
        if (!name) return
        setPerms((prev) => prev.map((p) => (p.key === key ? { ...p, label: name } : p)))
      },
      createPerson: (input) => {
        if (!input.name.trim() || !input.mobile.trim()) return { error: 'Name and mobile are required.' }
        if (!roles.some((r) => r.id === input.roleId && r.status === 'active')) return { error: 'Pick an active role.' }
        const created: AccessPerson = {
          ...input,
          id: `u-${Date.now()}`,
          name: input.name.trim(),
          mobile: input.mobile.trim(),
          code: input.code.trim() || `HQ-${Math.floor(1000 + Math.random() * 8000)}`,
          status: input.status ?? 'Active',
          lastLogin: '—',
          devices: 0,
        }
        setPeople((prev) => [created, ...prev])
        stamp('Created login', created.name, `${created.code} · ${roleById(created.roleId)?.name ?? ''}`)
        return created
      },
      updatePerson: (id, patch) => {
        const current = people.find((p) => p.id === id)
        if (!current) return { error: 'Not found' }
        if (patch.roleId && !roles.some((r) => r.id === patch.roleId && r.status === 'active')) {
          return { error: 'Role is archived.' }
        }
        setPeople((prev) => prev.map((p) => (p.id === id ? { ...p, ...patch } : p)))
        stamp('Updated person', current.name, patch.roleId ? `Role → ${roleById(patch.roleId)?.name}` : 'Access saved')
        return {}
      },
      disablePerson: (id) => {
        const current = people.find((p) => p.id === id)
        if (!current) return { ok: false, message: 'Not found' }
        const role = roleById(current.roleId)
        if (role?.pack.users && current.status === 'Active' && adminPeopleCount(people, roles) <= 1) {
          return { ok: false, message: 'Cannot disable the last active Users admin.' }
        }
        setPeople((prev) => prev.map((p) => (p.id === id ? { ...p, status: 'Disabled' } : p)))
        stamp('Disabled person', current.name, 'Sessions end on next check')
        return { ok: true }
      },
    }
  }, [roles, perms, people, history, stamp])

  return <Ctx.Provider value={value}>{children}</Ctx.Provider>
}

export function useAccess() {
  const ctx = useContext(Ctx)
  if (!ctx) throw new Error('useAccess needs AccessProvider')
  return ctx
}

export function isAccessError<T extends object>(v: T | { error: string }): v is { error: string } {
  return 'error' in v
}
