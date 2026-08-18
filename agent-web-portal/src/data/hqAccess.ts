import { PEOPLE, PERM_COLS, ROLE_PACKS, type Channel, type PersonStatus } from '@/data/hqBook'

export type RoleCluster = 'Producer' | 'Coach' | 'District' | 'FTE' | 'Admin'
export type PermKind = 'system' | 'custom'
export type PermModule = 'Sell' | 'Dashboard' | 'CRM' | 'e-Apps' | 'Tasks' | 'Mgmt' | 'Users' | 'Audit' | 'Export' | 'Wipe'
export type AccessStatus = 'active' | 'archived'

export const ROLE_CLUSTERS: RoleCluster[] = ['Producer', 'Coach', 'District', 'FTE', 'Admin']
export const PERM_MODULES: PermModule[] = [
  'Sell',
  'Dashboard',
  'CRM',
  'e-Apps',
  'Tasks',
  'Mgmt',
  'Users',
  'Audit',
  'Export',
  'Wipe',
]

export type PermDef = {
  key: string
  label: string
  module: PermModule
  kind: PermKind
  status: AccessStatus
  aliasOf?: string
}

export type AccessRole = {
  id: string
  name: string
  cluster: RoleCluster
  system: boolean
  status: AccessStatus
  channelDefault: Channel
  cloneFromId: string
  pack: Record<string, boolean>
  seedPack: Record<string, boolean>
}

export type AccessPerson = {
  id: string
  code: string
  name: string
  mobile: string
  roleId: string
  channel: Channel
  status: PersonStatus
  district: string
  lastLogin: string
  devices: number
}

export type AccessHistoryRow = {
  id: string
  when: string
  action: string
  target: string
  reason: string
  by: string
}

const MODULE_BY_KEY: Record<string, PermModule> = {
  sell: 'Sell',
  ownKpi: 'Dashboard',
  team: 'Dashboard',
  district: 'Dashboard',
  portfolio: 'Dashboard',
  export: 'Export',
  crm: 'CRM',
  eapps: 'e-Apps',
  tasksAdmin: 'Tasks',
  mgmt: 'Mgmt',
  users: 'Users',
  wipe: 'Wipe',
}

const CLUSTER_BY_NAME: Record<string, RoleCluster> = {
  FA: 'Producer',
  TL: 'Coach',
  DM: 'District',
  HOA: 'FTE',
  'Super Admin': 'Admin',
}

const CHANNEL_BY_NAME: Record<string, Channel> = {
  FA: 'App',
  TL: 'App',
  DM: 'Both',
  HOA: 'Portal',
  'Super Admin': 'Portal',
}

export const PERM_SEED: PermDef[] = PERM_COLS.map((c) => ({
  key: c.key,
  label: c.label,
  module: MODULE_BY_KEY[c.key] ?? 'Dashboard',
  kind: 'system',
  status: 'active',
}))

function packFrom(name: keyof typeof ROLE_PACKS): Record<string, boolean> {
  return { ...ROLE_PACKS[name] }
}

export const ROLE_SEED: AccessRole[] = (Object.keys(ROLE_PACKS) as (keyof typeof ROLE_PACKS)[]).map((name, i) => {
  const pack = packFrom(name)
  return {
    id: `r-${i + 1}`,
    name,
    cluster: CLUSTER_BY_NAME[name] ?? 'Coach',
    system: true,
    status: 'active',
    channelDefault: CHANNEL_BY_NAME[name] ?? 'App',
    cloneFromId: `r-${i + 1}`,
    pack,
    seedPack: { ...pack },
  }
})

const ROLE_ID_BY_NAME = Object.fromEntries(ROLE_SEED.map((r) => [r.name, r.id])) as Record<string, string>

export const PEOPLE_SEED: AccessPerson[] = PEOPLE.map((p) => ({
  id: p.id,
  code: p.code,
  name: p.name,
  mobile: p.mobile,
  roleId: ROLE_ID_BY_NAME[p.orgRole] ?? ROLE_SEED[0].id,
  channel: p.channel,
  status: p.status,
  district: p.district,
  lastLogin: p.lastLogin,
  devices: p.devices,
}))

export const ACCESS_HISTORY_SEED: AccessHistoryRow[] = [
  {
    id: 'ah1',
    when: '17-Aug-2026 15:01',
    action: 'Seeded',
    target: 'BRD packs',
    reason: 'FA · TL · DM · HOA · Super Admin',
    by: 'Ops May',
  },
]

export function slugPermKey(label: string) {
  const s = label
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '_')
    .replace(/^_|_$/g, '')
    .slice(0, 24)
  return s ? `x_${s}` : `x_${Date.now().toString(16).slice(-6)}`
}

export function emptyPack(perms: PermDef[]): Record<string, boolean> {
  return Object.fromEntries(perms.map((p) => [p.key, false]))
}

export function mergePack(base: Record<string, boolean>, perms: PermDef[]): Record<string, boolean> {
  const next = emptyPack(perms)
  for (const key of Object.keys(next)) {
    next[key] = Boolean(base[key])
  }
  return next
}

export function roleName(roles: AccessRole[], id: string) {
  return roles.find((r) => r.id === id)?.name ?? '—'
}

export function activePerms(perms: PermDef[]) {
  return perms.filter((p) => p.status === 'active')
}

export function activeRoles(roles: AccessRole[]) {
  return roles.filter((r) => r.status === 'active')
}

export function peopleOnRole(people: AccessPerson[], roleId: string) {
  return people.filter((p) => p.roleId === roleId)
}

export function adminPeopleCount(people: AccessPerson[], roles: AccessRole[]) {
  const adminIds = new Set(roles.filter((r) => r.pack.users && r.status === 'active').map((r) => r.id))
  return people.filter((p) => p.status === 'Active' && adminIds.has(p.roleId)).length
}

export function adminRoleCount(roles: AccessRole[]) {
  return roles.filter((r) => r.status === 'active' && r.pack.users).length
}

export function packFlags(pack: Record<string, boolean>, perms: PermDef[]) {
  const flags: Record<string, boolean> = {}
  for (const p of activePerms(perms)) {
    if (p.kind === 'system') flags[p.key] = Boolean(pack[p.key])
  }
  for (const p of activePerms(perms)) {
    if (p.kind === 'custom' && p.aliasOf && pack[p.key]) {
      flags[p.aliasOf] = true
    }
  }
  return flags
}

export function previewModules(flags: Record<string, boolean>) {
  const items: string[] = ['Dashboard', 'Tasks']
  if (flags.crm || flags.eapps) {
    if (flags.crm) items.push('CRM')
    if (flags.eapps) items.push('e-Apps')
  }
  if (flags.mgmt) items.push('Management')
  if (flags.users) items.push('Users')
  if (flags.mgmt) items.push('Audit')
  if (flags.wipe) items.push('Devices')
  if (flags.sell) items.push('Sell (mobile)')
  return items
}
