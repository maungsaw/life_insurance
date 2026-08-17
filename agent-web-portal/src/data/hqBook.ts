import type { PortalHat } from '@/auth/portalRole'

export type LeadStage = 'New' | 'Contacted' | 'Quoted' | 'Applied'
export type ClientStatus = 'Active' | 'Pending' | 'Expired'
export type EappStatus = 'Draft' | 'Submitted' | 'Mark for Correction' | 'Approved' | 'Rejected'
export type PersonStatus = 'Active' | 'Disabled' | 'Pending invite'
export type OrgRole = 'FA' | 'TL' | 'DM' | 'HOA' | 'Super Admin'
export type Channel = 'App' | 'Portal' | 'Both'

export type PolicyPeek = {
  ref: string
  product: string
  status: ClientStatus
  premium: string
}

export type CustomerRecord = {
  id: string
  kind: 'lead' | 'client'
  name: string
  phone: string
  email: string
  nrc: string
  ownerFa: string
  ownerCode: string
  district: string
  stage?: LeadStage
  status?: ClientStatus
  lastActivity: string
  notes: string[]
  quotes: string[]
  eappIds: string[]
  policies: PolicyPeek[]
  convertedFrom?: string
}

export type EappRecord = {
  id: string
  ref: string
  customerId: string
  party: string
  product: string
  ownerFa: string
  district: string
  status: EappStatus
  when: string
  age: string
  policyRef?: string
  correction?: string
  timeline: { at: string; label: string }[]
}

export type PersonRecord = {
  id: string
  code: string
  name: string
  mobile: string
  orgRole: OrgRole
  channel: Channel
  status: PersonStatus
  district: string
  lastLogin: string
  devices: number
}

export const CUSTOMERS: CustomerRecord[] = [
  {
    id: 'c-may',
    kind: 'client',
    name: 'May Chan Myae',
    phone: '09 421 880 112',
    email: 'may@example.com',
    nrc: '12/YGN(N)223344',
    ownerFa: 'Aye Chan',
    ownerCode: 'AGT-10284',
    district: 'Yangon A',
    status: 'Active',
    lastActivity: '14-Aug-2026',
    notes: ['Prefers evening calls.'],
    quotes: ['QT-2026-0810'],
    eappIds: ['e2'],
    policies: [
      { ref: 'POL-2026-0814', product: 'Universal Life', status: 'Active', premium: '45,000.00' },
      { ref: 'POL-2026-0805', product: 'Family Health', status: 'Active', premium: '89,000.00' },
    ],
    convertedFrom: 'Lead · 05-Aug-2026',
  },
  {
    id: 'c-hla',
    kind: 'lead',
    name: 'Daw Hla',
    phone: '09 250 334 221',
    email: 'hla@example.com',
    nrc: '12/YGN(N)998877',
    ownerFa: 'Aye Chan',
    ownerCode: 'AGT-10284',
    district: 'Yangon A',
    stage: 'Applied',
    lastActivity: '17-Aug-2026',
    notes: ['NRC scan unclear — correction open.'],
    quotes: ['QT-2026-0814'],
    eappIds: ['e1'],
    policies: [],
  },
  {
    id: 'c-umin',
    kind: 'client',
    name: 'U Min',
    phone: '09 777 101 202',
    email: 'umin@example.com',
    nrc: '9/MDY(N)112233',
    ownerFa: 'Nwe Nwe',
    ownerCode: 'AGT-10901',
    district: 'Mandalay',
    status: 'Pending',
    lastActivity: '16-Aug-2026',
    notes: [],
    quotes: [],
    eappIds: ['e3'],
    policies: [{ ref: 'POL-PEND-0812', product: 'Universal Life', status: 'Pending', premium: '—' }],
    convertedFrom: 'Condition submitted · 16-Aug-2026',
  },
  {
    id: 'c-ko',
    kind: 'lead',
    name: 'Ko Ko',
    phone: '09 988 440 110',
    email: 'koko@example.com',
    nrc: '5/BGO(N)445566',
    ownerFa: 'Zaw Ko',
    ownerCode: 'AGT-11002',
    district: 'Bago',
    stage: 'Quoted',
    lastActivity: '12-Aug-2026',
    notes: ['Waiting on spouse NRC.'],
    quotes: ['QT-2026-0811'],
    eappIds: ['e4'],
    policies: [],
  },
  {
    id: 'c-su',
    kind: 'client',
    name: 'Su Su',
    phone: '09 430 220 118',
    email: 'susu@example.com',
    nrc: '12/YGN(N)556677',
    ownerFa: 'Aye Chan',
    ownerCode: 'AGT-10284',
    district: 'Yangon A',
    status: 'Expired',
    lastActivity: '18-Jul-2026',
    notes: ['Renewal window on mobile.'],
    quotes: [],
    eappIds: [],
    policies: [{ ref: 'POL-2026-0718', product: 'Travel Protect', status: 'Expired', premium: '27,500.00' }],
  },
]

export const EAPPS: EappRecord[] = [
  {
    id: 'e1',
    ref: 'APP-2026-0814',
    customerId: 'c-hla',
    party: 'Daw Hla',
    product: 'Family Health',
    ownerFa: 'Aye Chan',
    district: 'Yangon A',
    status: 'Mark for Correction',
    when: '17-Aug-2026 13:10',
    age: '2h',
    correction: 'NRC image unclear · re-scan front + back.',
    timeline: [
      { at: '14-Aug-2026 10:00', label: 'Draft started on Agent App' },
      { at: '16-Aug-2026 18:22', label: 'Submitted' },
      { at: '17-Aug-2026 13:10', label: 'Mark for Correction' },
    ],
  },
  {
    id: 'e2',
    ref: 'APP-2026-0810',
    customerId: 'c-may',
    party: 'May Chan Myae',
    product: 'Universal Life',
    ownerFa: 'Aye Chan',
    district: 'Yangon A',
    status: 'Approved',
    when: '14-Aug-2026 11:40',
    age: '3d',
    policyRef: 'POL-2026-0814',
    timeline: [
      { at: '10-Aug-2026', label: 'Draft' },
      { at: '12-Aug-2026', label: 'Submitted' },
      { at: '14-Aug-2026', label: 'Approved · policy issued' },
    ],
  },
  {
    id: 'e3',
    ref: 'APP-2026-0812',
    customerId: 'c-umin',
    party: 'U Min',
    product: 'Universal Life',
    ownerFa: 'Nwe Nwe',
    district: 'Mandalay',
    status: 'Submitted',
    when: '16-Aug-2026 11:02',
    age: '1d',
    timeline: [
      { at: '15-Aug-2026', label: 'Draft' },
      { at: '16-Aug-2026 11:02', label: 'Submitted · waiting UW' },
    ],
  },
  {
    id: 'e4',
    ref: 'APP-2026-0811',
    customerId: 'c-ko',
    party: 'Ko Ko',
    product: 'Credit Life',
    ownerFa: 'Zaw Ko',
    district: 'Bago',
    status: 'Draft',
    when: '12-Aug-2026 09:00',
    age: '5d',
    timeline: [{ at: '12-Aug-2026', label: 'Draft on Agent App · not submitted' }],
  },
  {
    id: 'e5',
    ref: 'APP-2026-0722',
    customerId: 'c-su',
    party: 'Su Su',
    product: 'Term Life',
    ownerFa: 'Aye Chan',
    district: 'Yangon A',
    status: 'Rejected',
    when: '22-Jul-2026 16:00',
    age: '26d',
    correction: 'Health declaration incomplete.',
    timeline: [
      { at: '20-Jul-2026', label: 'Submitted' },
      { at: '22-Jul-2026', label: 'Rejected' },
    ],
  },
]

export const PEOPLE: PersonRecord[] = [
  {
    id: 'u-aye',
    code: 'AGT-10284',
    name: 'Aye Chan',
    mobile: '09 771 234 567',
    orgRole: 'FA',
    channel: 'App',
    status: 'Active',
    district: 'Yangon A',
    lastLogin: '17-Aug-2026 08:12',
    devices: 1,
  },
  {
    id: 'u-zaw',
    code: 'AGT-11002',
    name: 'Zaw Ko',
    mobile: '09 988 111 222',
    orgRole: 'FA',
    channel: 'App',
    status: 'Active',
    district: 'Yangon A',
    lastLogin: '16-Aug-2026 19:40',
    devices: 1,
  },
  {
    id: 'u-nwe',
    code: 'AGT-10901',
    name: 'Nwe Nwe',
    mobile: '09 250 667 889',
    orgRole: 'FA',
    channel: 'App',
    status: 'Active',
    district: 'Mandalay',
    lastLogin: '17-Aug-2026 07:55',
    devices: 2,
  },
  {
    id: 'u-dm',
    code: 'AGT-10001',
    name: 'Mg Htet',
    mobile: '09 770 100 001',
    orgRole: 'DM',
    channel: 'Both',
    status: 'Active',
    district: 'Yangon A',
    lastLogin: '17-Aug-2026 14:02',
    devices: 1,
  },
  {
    id: 'u-khin',
    code: 'HQ-2201',
    name: 'Khin Htet',
    mobile: '09 880 112 233',
    orgRole: 'HOA',
    channel: 'Portal',
    status: 'Active',
    district: 'All districts',
    lastLogin: '17-Aug-2026 09:10',
    devices: 0,
  },
  {
    id: 'u-ops',
    code: 'HQ-0001',
    name: 'Ops May',
    mobile: '09 250 000 111',
    orgRole: 'Super Admin',
    channel: 'Portal',
    status: 'Active',
    district: 'HQ',
    lastLogin: '17-Aug-2026 15:01',
    devices: 0,
  },
  {
    id: 'u-off',
    code: 'AGT-10800',
    name: 'Lin Lin',
    mobile: '09 430 880 001',
    orgRole: 'FA',
    channel: 'App',
    status: 'Disabled',
    district: 'Yangon A',
    lastLogin: '01-Jul-2026 11:00',
    devices: 0,
  },
]

export type PermKey =
  | 'sell'
  | 'ownKpi'
  | 'team'
  | 'district'
  | 'portfolio'
  | 'export'
  | 'crm'
  | 'eapps'
  | 'tasksAdmin'
  | 'mgmt'
  | 'users'
  | 'wipe'

export const PERM_COLS: { key: PermKey; label: string }[] = [
  { key: 'sell', label: 'Sell' },
  { key: 'ownKpi', label: 'Own KPI' },
  { key: 'team', label: 'Team' },
  { key: 'district', label: 'District' },
  { key: 'portfolio', label: 'Portfolio' },
  { key: 'export', label: 'Export' },
  { key: 'crm', label: 'CRM book' },
  { key: 'eapps', label: 'e-Apps' },
  { key: 'tasksAdmin', label: 'Tasks admin' },
  { key: 'mgmt', label: 'Mgmt' },
  { key: 'users', label: 'Users' },
  { key: 'wipe', label: 'Wipe' },
]

export const ROLE_PACKS: Record<OrgRole, Record<PermKey, boolean>> = {
  FA: {
    sell: true,
    ownKpi: true,
    team: false,
    district: false,
    portfolio: false,
    export: false,
    crm: false,
    eapps: false,
    tasksAdmin: false,
    mgmt: false,
    users: false,
    wipe: false,
  },
  TL: {
    sell: true,
    ownKpi: true,
    team: true,
    district: false,
    portfolio: false,
    export: true,
    crm: true,
    eapps: true,
    tasksAdmin: false,
    mgmt: false,
    users: false,
    wipe: false,
  },
  DM: {
    sell: true,
    ownKpi: true,
    team: true,
    district: true,
    portfolio: false,
    export: true,
    crm: true,
    eapps: true,
    tasksAdmin: true,
    mgmt: false,
    users: false,
    wipe: false,
  },
  HOA: {
    sell: false,
    ownKpi: false,
    team: true,
    district: true,
    portfolio: true,
    export: true,
    crm: true,
    eapps: true,
    tasksAdmin: true,
    mgmt: false,
    users: false,
    wipe: false,
  },
  'Super Admin': {
    sell: false,
    ownKpi: false,
    team: false,
    district: true,
    portfolio: true,
    export: true,
    crm: true,
    eapps: true,
    tasksAdmin: true,
    mgmt: true,
    users: true,
    wipe: true,
  },
}

export function inManagerSlice(district: string, hat: PortalHat) {
  if (hat !== 'manager') return true
  return district.startsWith('Yangon')
}

export function customerById(id: string) {
  return CUSTOMERS.find((c) => c.id === id)
}

export function eappById(id: string) {
  return EAPPS.find((e) => e.id === id)
}

export function personById(id: string) {
  return PEOPLE.find((p) => p.id === id)
}
