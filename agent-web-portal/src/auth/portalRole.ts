export type PortalHat = 'manager' | 'fte' | 'admin'
export type PortalLang = 'en' | 'mm'

export type Caps = {
  canViewDistrict: boolean
  canViewPortfolio: boolean
  canExport: boolean
  canAdmin: boolean
  canWipe: boolean
  canViewBook: boolean
  canViewAllBooks: boolean
  canManageUsers: boolean
}

export type HatProfile = {
  hat: PortalHat
  label: string
  name: string
  roleLine: string
  initial: string
  landing: string
  mobile: string
  district: string
}

export const HAT_PROFILES: Record<PortalHat, HatProfile> = {
  manager: {
    hat: 'manager',
    label: 'Manager',
    name: 'Aye Chan',
    roleLine: 'DM · Yangon',
    initial: 'A',
    landing: '/dashboard/overview',
    mobile: '09 771 234 567',
    district: 'Yangon A',
  },
  fte: {
    hat: 'fte',
    label: 'FTE',
    name: 'Khin Htet',
    roleLine: 'HOA · Portfolio',
    initial: 'K',
    landing: '/dashboard/overview',
    mobile: '09 880 112 233',
    district: 'All districts',
  },
  admin: {
    hat: 'admin',
    label: 'Admin',
    name: 'Ops May',
    roleLine: 'Super Admin · HQ',
    initial: 'O',
    landing: '/management/resources',
    mobile: '09 250 000 111',
    district: 'HQ',
  },
}

export function capsFor(hat: PortalHat): Caps {
  if (hat === 'admin') {
    return {
      canViewDistrict: true,
      canViewPortfolio: true,
      canExport: true,
      canAdmin: true,
      canWipe: true,
      canViewBook: true,
      canViewAllBooks: true,
      canManageUsers: true,
    }
  }
  if (hat === 'fte') {
    return {
      canViewDistrict: true,
      canViewPortfolio: true,
      canExport: true,
      canAdmin: false,
      canWipe: false,
      canViewBook: true,
      canViewAllBooks: true,
      canManageUsers: false,
    }
  }
  return {
    canViewDistrict: true,
    canViewPortfolio: false,
    canExport: true,
    canAdmin: false,
    canWipe: false,
    canViewBook: true,
    canViewAllBooks: false,
    canManageUsers: false,
  }
}

export function digitsOnly(raw: string) {
  return raw.replace(/\D/g, '')
}

/** Prototype CORE gate — special numbers on Login (docs/86). */
export type MobileGate = 'ok' | 'unknown' | 'pending' | 'field'

export function classifyMobile(raw: string): MobileGate {
  const d = digitsOnly(raw)
  if (d === '09000000000' || d === '9000000000') return 'unknown'
  if (d === '09111111111' || d === '9111111111') return 'pending'
  if (d === '09555555555' || d === '9555555555') return 'field'
  return 'ok'
}

export const HAT_STORAGE_KEY = 'kbz-portal-hat'
export const LANG_STORAGE_KEY = 'kbz-portal-lang'
