import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { Button, Card, EmptyState, PageHeader, Pill, SegmentedControl } from '@/components/ui'
import { cn } from '@/lib/cn'
import { useAuth } from '@/auth/AuthContext'

type NType = 'all' | 'task' | 'premium' | 'app' | 'news' | 'system'

type Item = {
  id: string
  type: Exclude<NType, 'all'>
  title: string
  meta: string
  time: string
  unread?: boolean
  tone?: 'default' | 'ok' | 'warn' | 'danger'
  pill?: string
  to: string
}

const ITEMS: Item[] = [
  {
    id: '1',
    type: 'task',
    title: 'New task assigned',
    meta: 'Leave appointment · Su Su · assigned by you to Aye Chan',
    time: 'Just now',
    unread: true,
    tone: 'warn',
    pill: 'New',
    to: '/tasks',
  },
  {
    id: '2',
    type: 'app',
    title: 'Mark for Correction',
    meta: 'Daw Hla · NRC unclear · e-App needs fix',
    time: '1h ago',
    unread: true,
    tone: 'danger',
    pill: 'Fix',
    to: '/tasks',
  },
  {
    id: '3',
    type: 'premium',
    title: 'Premium due in 7 days',
    meta: 'Team · 3 clients · 1,250,000.00 MMK',
    time: 'Today',
    unread: true,
    tone: 'warn',
    pill: 'Due',
    to: '/dashboard/overview',
  },
  {
    id: '4',
    type: 'system',
    title: 'FA below target',
    meta: 'Zaw Ko · APE flag on Performance grid',
    time: 'Yesterday',
    pill: 'Flag',
    to: '/dashboard/team-performance',
  },
  {
    id: '5',
    type: 'news',
    title: 'Q3 Incentive Push',
    meta: 'Announcement published · image + URL',
    time: '2d ago',
    pill: 'News',
    to: '/management/announcements',
  },
  {
    id: '6',
    type: 'task',
    title: 'Task completed',
    meta: 'NRC correction · Aye Chan',
    time: '3d ago',
    tone: 'ok',
    pill: 'Done',
    to: '/tasks',
  },
]

export function NotificationsPage() {
  const [filter, setFilter] = useState<NType>('all')
  const [items, setItems] = useState(ITEMS)
  const nav = useNavigate()
  const { caps } = useAuth()

  const visible = items.filter((i) => filter === 'all' || i.type === filter)
  const unread = items.filter((i) => i.unread).length

  const openItem = (item: Item) => {
    setItems((prev) => prev.map((i) => (i.id === item.id ? { ...i, unread: false } : i)))
    if (item.to.startsWith('/management') && !caps.canAdmin) {
      nav('/notifications')
      return
    }
    nav(item.to)
  }

  return (
    <div>
      <PageHeader
        title="Notifications"
        subtitle="Tasks · premiums · apps · news · team flags"
        actions={
          <Button
            variant="secondary"
            type="button"
            disabled={unread === 0}
            onClick={() => setItems((prev) => prev.map((i) => ({ ...i, unread: false })))}
          >
            Mark all read
          </Button>
        }
      />

      <SegmentedControl
        value={filter}
        onChange={(v) => setFilter(v as NType)}
        options={[
          { value: 'all', label: `All (${items.length})` },
          { value: 'task', label: 'Tasks' },
          { value: 'premium', label: 'Premium' },
          { value: 'app', label: 'Apps' },
          { value: 'news', label: 'News' },
          { value: 'system', label: 'System' },
        ]}
      />

      <Card className="mt-1 p-0 overflow-hidden">
        {visible.length === 0 ? (
          <EmptyState
            title="No notifications in this filter"
            hint="HQ inbox is consume-only. Setup lives under Management → Notification (Admin)."
          />
        ) : (
          <ul className="divide-y divide-line">
            {visible.map((item) => (
              <li key={item.id}>
                <button
                  type="button"
                  onClick={() => openItem(item)}
                  className={cn(
                    'flex w-full items-start gap-3 px-4 py-3.5 text-left transition hover:bg-soft',
                    item.unread && 'bg-sky/5',
                  )}
                >
                  <span
                    className={cn(
                      'mt-1.5 size-2 shrink-0 rounded-full',
                      item.unread ? 'bg-sky' : 'bg-transparent',
                    )}
                  />
                  <div className="min-w-0 flex-1">
                    <div className="flex flex-wrap items-center gap-2">
                      <b className="text-sm text-deep">{item.title}</b>
                      {item.pill ? <Pill tone={item.tone}>{item.pill}</Pill> : null}
                    </div>
                    <p className="mt-0.5 text-xs text-muted">{item.meta}</p>
                  </div>
                  <span className="shrink-0 text-[11px] font-bold text-muted">{item.time}</span>
                </button>
              </li>
            ))}
          </ul>
        )}
      </Card>
    </div>
  )
}
