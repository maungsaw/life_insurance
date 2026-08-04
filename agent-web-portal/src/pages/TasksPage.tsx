import { useState } from 'react'
import { Button, Card, DataTable, Field, Input, PageHeader, Pill, Select, Td, Textarea } from '@/components/ui'

export function TasksPage() {
  const [showForm, setShowForm] = useState(true)
  return (
    <div>
      <PageHeader
        title="Task management"
        subtitle="FR-07 · Managers Add / Move / Delete · Agents update status"
        actions={
          <>
            <Button type="button" onClick={() => setShowForm(true)}>+ Add task</Button>
            <Button variant="secondary" type="button">Move / reassign</Button>
            <Button variant="secondary" type="button">Delete</Button>
          </>
        }
      />
      <div className="grid gap-3.5 lg:grid-cols-[1.4fr_1fr]">
        <Card title="Task list">
          <DataTable headers={['Task', 'Assignee', 'Type', 'Due', 'Status']}>
            <tr>
              <Td>Interview · Su Su</Td>
              <Td>Aye Chan</Td>
              <Td>Recruitment</Td>
              <Td>06-Aug-2026</Td>
              <Td><Pill>In Progress</Pill></Td>
            </tr>
            <tr>
              <Td>Premium chase · Daw Hla</Td>
              <Td>Aye Chan</Td>
              <Td>Servicing</Td>
              <Td>10-Aug-2026</Td>
              <Td><Pill tone="warn">Pending</Pill></Td>
            </tr>
            <tr>
              <Td>LC Training follow-up</Td>
              <Td>Nwe Nwe</Td>
              <Td>Recruitment</Td>
              <Td>08-Aug-2026</Td>
              <Td><Pill tone="warn">Pending</Pill></Td>
            </tr>
            <tr>
              <Td>NRC correction</Td>
              <Td>Aye Chan</Td>
              <Td>e-App</Td>
              <Td>02-Aug-2026</Td>
              <Td><Pill tone="ok">Completed</Pill></Td>
            </tr>
          </DataTable>
        </Card>
        {showForm && (
          <Card title="Add / manage task">
            <Field label="Title *"><Input defaultValue="Interview · Su Su" /></Field>
            <Field label="Assignee FA">
              <Select defaultValue="Aye Chan">
                <option>Aye Chan</option>
                <option>Nwe Nwe</option>
              </Select>
            </Field>
            <Field label="Type">
              <Select defaultValue="Recruitment">
                <option>Recruitment</option>
                <option>Servicing</option>
                <option>e-App</option>
                <option>Other</option>
              </Select>
            </Field>
            <Field label="Due date"><Input type="date" defaultValue="2026-08-06" /></Field>
            <Field label="Status">
              <Select defaultValue="In Progress">
                <option>Pending</option>
                <option>In Progress</option>
                <option>Completed</option>
              </Select>
            </Field>
            <Field label="Notes"><Textarea rows={2} defaultValue="Candidate passed screening." /></Field>
            <div className="flex gap-2">
              <Button type="button">Save task</Button>
              <Button variant="ghost" type="button" onClick={() => setShowForm(false)}>Close</Button>
            </div>
          </Card>
        )}
      </div>
    </div>
  )
}
