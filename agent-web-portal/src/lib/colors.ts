/** Coolors palette — single source for non-Tailwind usage (charts, inline SVG). */
export const colors = {
  sky: '#00A6FB',
  steel: '#0582CA',
  baltic: '#006494',
  deep: '#003554',
  surface: '#F4F8FB',
  soft: '#E6F6FF',
  muted: '#5A7390',
  line: '#D5E4F0',
  card: '#FFFFFF',
  ok: '#1A9B6C',
  warn: '#D97706',
  danger: '#C0392B',
} as const

export type BrandColor = keyof typeof colors
