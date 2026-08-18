const MONTHS = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
] as const

const MONTH_INDEX: Record<string, string> = {
  Jan: '01',
  Feb: '02',
  Mar: '03',
  Apr: '04',
  May: '05',
  Jun: '06',
  Jul: '07',
  Aug: '08',
  Sep: '09',
  Oct: '10',
  Nov: '11',
  Dec: '12',
}

/** Canonical HQ display date — `04-Jun-1999` (matches Flutter `AppDate`). */
export function formatDate(d: Date): string {
  const dd = String(d.getDate()).padStart(2, '0')
  return `${dd}-${MONTHS[d.getMonth()]}-${d.getFullYear()}`
}

export function formatDateTime(d: Date): string {
  const h24 = d.getHours()
  const h = h24 % 12 === 0 ? 12 : h24 % 12
  const hh = String(h).padStart(2, '0')
  const mm = String(d.getMinutes()).padStart(2, '0')
  const ap = h24 >= 12 ? 'PM' : 'AM'
  return `${formatDate(d)} ${hh}:${mm} ${ap}`
}

/** `04-Jun-1999` → `1999-06-04` for `<input type="date">`. */
export function toDateInput(display: string) {
  if (!display) return ''
  const m = display.match(/^(\d{2})-([A-Za-z]{3})-(\d{4})$/)
  if (!m) return ''
  const mm = MONTH_INDEX[m[2]]
  if (!mm) return ''
  return `${m[3]}-${mm}-${m[1]}`
}

/** `1999-06-04` → `04-Jun-1999`. */
export function fromDateInput(iso: string) {
  if (!iso) return ''
  const [y, m, d] = iso.split('-')
  const dt = new Date(Number(y), Number(m) - 1, Number(d))
  if (Number.isNaN(dt.getTime())) return ''
  return formatDate(dt)
}
