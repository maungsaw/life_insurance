export type ProductLine = 'Protection' | 'Saving' | 'Travel' | 'Health' | 'Bundled'
export type ProductGate = 'on' | 'off' | 'archived'
export type SchemaPack = 'Endowment' | 'Universal Life' | 'Term' | 'Health' | 'Travel' | 'Credit' | 'Bundled'

export const PRODUCT_LINES: ProductLine[] = ['Protection', 'Saving', 'Travel', 'Health', 'Bundled']
export const SCHEMA_PACKS: SchemaPack[] = [
  'Endowment',
  'Universal Life',
  'Term',
  'Health',
  'Travel',
  'Credit',
  'Bundled',
]
export const OFF_REASONS = ['Campaign pause', 'Regulatory', 'Pricing update', 'Other'] as const

export const CATALOG_DOCS = [
  { id: 'd1', title: 'Endowment brochure' },
  { id: 'd2', title: 'Term life one-pager' },
  { id: 'd3', title: 'LC Training pack' },
  { id: 'd4', title: 'Claim form (blank)' },
] as const

export type CatalogHistoryAction =
  | 'Created'
  | 'Updated'
  | 'Turned on'
  | 'Turned off'
  | 'Archived'
  | 'Unarchived'
  | 'Duplicated'

export type CatalogProduct = {
  id: string
  code: string
  name: string
  tagline: string
  line: ProductLine
  schemaPack: SchemaPack
  status: ProductGate
  about: string
  whoShould: string
  whyBuy: string
  coverage: string
  eligible: string
  variants: string
  frequencies: string
  terms: string
  defaultSi: string
  defaultTopup: string
  resourceIds: string[]
  commissionCategory: string
  effectiveFrom: string
  inFlightQuotes: number
  inFlightEapps: number
  changedAt: string
  changedBy: string
}

export type CatalogHistoryRow = {
  id: string
  when: string
  code: string
  action: CatalogHistoryAction
  reason: string
  by: string
}

export function normalizeCode(raw: string) {
  return raw.replace(/[^a-zA-Z0-9]/g, '').toUpperCase().slice(0, 8)
}

export function codeError(code: string, products: CatalogProduct[], exceptId?: string) {
  if (code.length < 2) return 'Code must be 2–8 letters or digits.'
  if (products.some((p) => p.code === code && p.id !== exceptId)) return 'Code already in the catalog.'
  return null
}

export function uniqueCode(base: string, products: CatalogProduct[]) {
  const root = normalizeCode(base || 'NEW') || 'NEW'
  if (!products.some((p) => p.code === root)) return root
  for (let i = 2; i < 99; i++) {
    const c = normalizeCode(`${root.slice(0, 6)}${i}`)
    if (c && !products.some((p) => p.code === c)) return c
  }
  return normalizeCode(`N${Date.now()}`)
}

export function inFlight(p: CatalogProduct) {
  return p.inFlightQuotes + p.inFlightEapps
}

export function emptyDraft(): CatalogProduct {
  return {
    id: '',
    code: '',
    name: '',
    tagline: '',
    line: 'Protection',
    schemaPack: 'Term',
    status: 'off',
    about: '',
    whoShould: '',
    whyBuy: '',
    coverage: '',
    eligible: '',
    variants: 'Standard',
    frequencies: 'Monthly · Annual',
    terms: '10 · 15 · 20',
    defaultSi: '30,000,000',
    defaultTopup: '0',
    resourceIds: [],
    commissionCategory: 'Protection',
    effectiveFrom: '',
    inFlightQuotes: 0,
    inFlightEapps: 0,
    changedAt: '',
    changedBy: '',
  }
}

export function duplicateFrom(src: CatalogProduct): CatalogProduct {
  return {
    ...src,
    id: '',
    code: '',
    name: `${src.name} (copy)`,
    status: 'off',
    effectiveFrom: '',
    inFlightQuotes: 0,
    inFlightEapps: 0,
    changedAt: '',
    changedBy: '',
  }
}

export const CATALOG_SEED: CatalogProduct[] = [
  {
    id: 'p1',
    code: 'EN',
    name: 'Endowment Plan',
    tagline: 'Savings + protection',
    line: 'Saving',
    schemaPack: 'Endowment',
    status: 'on',
    about: 'Savings with a protection wrapper for family goals.',
    whoShould: 'Savers who want a maturity benefit',
    whyBuy: 'Forced saving · life cover',
    coverage: 'Death benefit · maturity payout',
    eligible: 'Age 18–55',
    variants: '10yr · 15yr',
    frequencies: 'Monthly · Annual',
    terms: '10 · 15 · 20',
    defaultSi: '20,000,000',
    defaultTopup: '0',
    resourceIds: ['d1'],
    commissionCategory: 'Saving',
    effectiveFrom: '',
    inFlightQuotes: 1,
    inFlightEapps: 0,
    changedAt: '01-Aug-2026',
    changedBy: 'Ops May',
  },
  {
    id: 'p2',
    code: 'UL',
    name: 'Universal Life',
    tagline: 'Flexible premium',
    line: 'Protection',
    schemaPack: 'Universal Life',
    status: 'on',
    about: 'Flexible premium life cover with optional top-up.',
    whoShould: 'Clients who want premium flexibility',
    whyBuy: 'Adjustable SI · top-up',
    coverage: 'Life cover · optional rider if in pack',
    eligible: 'Age 18–65',
    variants: 'Standard · Plus',
    frequencies: 'Monthly · Quarterly · Annual',
    terms: 'To 99',
    defaultSi: '30,000,000',
    defaultTopup: '0',
    resourceIds: [],
    commissionCategory: 'Protection',
    effectiveFrom: '',
    inFlightQuotes: 2,
    inFlightEapps: 1,
    changedAt: '12-Jul-2026',
    changedBy: 'Ops May',
  },
  {
    id: 'p3',
    code: 'CI',
    name: 'Critical Illness',
    tagline: 'Health protection',
    line: 'Health',
    schemaPack: 'Health',
    status: 'on',
    about: 'Lump-sum on listed critical illnesses.',
    whoShould: 'Income earners with family dependents',
    whyBuy: 'Cash at diagnosis',
    coverage: 'CI list · death benefit rider optional',
    eligible: 'Age 18–60',
    variants: 'Core · Extended',
    frequencies: 'Annual',
    terms: '10 · 20',
    defaultSi: '15,000,000',
    defaultTopup: '0',
    resourceIds: [],
    commissionCategory: 'Health',
    effectiveFrom: '',
    inFlightQuotes: 0,
    inFlightEapps: 1,
    changedAt: '28-Jun-2026',
    changedBy: 'Product Admin',
  },
  {
    id: 'p4',
    code: 'TL',
    name: 'Term Life',
    tagline: 'Pure protection',
    line: 'Protection',
    schemaPack: 'Term',
    status: 'off',
    about: 'Level term cover. Pricing update in progress.',
    whoShould: 'Mortgage and income replacement',
    whyBuy: 'High SI · lower premium',
    coverage: 'Death benefit only',
    eligible: 'Age 18–65',
    variants: 'Level',
    frequencies: 'Monthly · Annual',
    terms: '10 · 20 · 30',
    defaultSi: '50,000,000',
    defaultTopup: '0',
    resourceIds: ['d2'],
    commissionCategory: 'Protection',
    effectiveFrom: '01-Sep-2026',
    inFlightQuotes: 1,
    inFlightEapps: 1,
    changedAt: '02-Aug-2026',
    changedBy: 'Ops May',
  },
  {
    id: 'p5',
    code: 'WP',
    name: 'Whole Life Plus',
    tagline: 'Lifelong cover',
    line: 'Protection',
    schemaPack: 'Term',
    status: 'off',
    about: 'Lifelong cover paused for campaign.',
    whoShould: 'Estate planning',
    whyBuy: 'Cover that does not expire',
    coverage: 'Whole of life',
    eligible: 'Age 18–50',
    variants: 'Plus',
    frequencies: 'Annual',
    terms: 'Whole life',
    defaultSi: '25,000,000',
    defaultTopup: '0',
    resourceIds: [],
    commissionCategory: 'Protection',
    effectiveFrom: '',
    inFlightQuotes: 0,
    inFlightEapps: 0,
    changedAt: '15-Jul-2026',
    changedBy: 'Product Admin',
  },
]

export const CATALOG_HISTORY_SEED: CatalogHistoryRow[] = [
  {
    id: 'h1',
    when: '02-Aug-2026 10:14',
    code: 'TL',
    action: 'Turned off',
    reason: 'Pricing update',
    by: 'Ops May',
  },
  {
    id: 'h2',
    when: '15-Jul-2026 16:02',
    code: 'WP',
    action: 'Turned off',
    reason: 'Campaign pause',
    by: 'Product Admin',
  },
  {
    id: 'h3',
    when: '01-Aug-2026 09:00',
    code: 'EN',
    action: 'Turned on',
    reason: '—',
    by: 'Ops May',
  },
]
