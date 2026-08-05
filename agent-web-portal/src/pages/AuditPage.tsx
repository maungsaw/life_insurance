import { useState } from 'react'
import { Card, DataTable, PageHeader, Pill, Td } from '@/components/ui'
import { cn } from '@/lib/cn'

export function AuditPage() {
  const [tab, setTab] = useState<'directory' | 'log'>('directory')

  return (
    <div>
      <PageHeader
        title="Audit"
        subtitle="FR-12 · agent directory · status changes · change history"
      />

      <div className="mb-4 flex flex-wrap gap-2">
        <button
          type="button"
          onClick={() => setTab('directory')}
          className={cn(
            'rounded-full px-3.5 py-1.5 text-xs font-extrabold transition',
            tab === 'directory' ? 'bg-steel text-white' : 'bg-soft text-muted hover:text-deep',
          )}
        >
          Agent directory
        </button>
        <button
          type="button"
          onClick={() => setTab('log')}
          className={cn(
            'rounded-full px-3.5 py-1.5 text-xs font-extrabold transition',
            tab === 'log' ? 'bg-steel text-white' : 'bg-soft text-muted hover:text-deep',
          )}
        >
          Audit log
        </button>
      </div>

      {tab === 'directory' ? (
        <Card title="Agent directory">
          <p className="mb-3 text-xs text-muted">
            Onboarding statuses (e.g. LC Training) live here — leave appointments and follow-ups are managed under Tasks.
          </p>
          <DataTable headers={['Code', 'Name', 'Role', 'Mobile', 'Status', 'District']}>
            <tr>
              <Td>AGT-10284</Td>
              <Td>Aye Chan</Td>
              <Td>FA</Td>
              <Td>09 771 234 567</Td>
              <Td>
                <Pill tone="ok">Active</Pill>
              </Td>
              <Td>Yangon A</Td>
            </tr>
            <tr>
              <Td>AGT-11002</Td>
              <Td>Zaw Ko</Td>
              <Td>FA</Td>
              <Td>09 988 111 222</Td>
              <Td>
                <Pill tone="warn">LC Training</Pill>
              </Td>
              <Td>Yangon A</Td>
            </tr>
          </DataTable>
        </Card>
      ) : (
        <Card title="Audit log">
          <DataTable headers={['Action', 'Previous', 'New', 'User', 'When']}>
            <tr>
              <Td>Update mobile</Td>
              <Td>09 771 234 567</Td>
              <Td>09 988 111 222</Td>
              <Td>Ops May</Td>
              <Td>03-Aug-2026 09:12</Td>
            </tr>
            <tr>
              <Td>Status change</Td>
              <Td>Pre-Contracted</Td>
              <Td>LC Training</Td>
              <Td>Alliance</Td>
              <Td>02-Aug-2026 16:40</Td>
            </tr>
          </DataTable>
        </Card>
      )}
    </div>
  )
}
