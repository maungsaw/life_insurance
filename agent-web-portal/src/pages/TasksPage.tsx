import { useState } from 'react'

export function TasksPage() {
  const [showForm, setShowForm] = useState(true)
  return (
    <div>
      <h1 className="page-title">Task management</h1>
      <p className="page-sub">FR-07 · Managers Add / Move / Delete · Agents update Pending · In Progress · Completed</p>
      <div className="row-btns">
        <button className="btn btn-primary" type="button" onClick={() => setShowForm(true)}>
          + Add task
        </button>
        <button className="btn btn-secondary" type="button">
          Move / reassign
        </button>
        <button className="btn btn-secondary" type="button">
          Delete
        </button>
      </div>
      <div className="grid-2">
        <div className="card table-wrap">
          <h3>Task list</h3>
          <table className="data">
            <thead>
              <tr>
                <th>Task</th>
                <th>Assignee</th>
                <th>Type</th>
                <th>Due</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>Interview · Su Su</td>
                <td>Aye Chan</td>
                <td>Recruitment</td>
                <td>06-Aug-2026</td>
                <td><span className="pill">In Progress</span></td>
              </tr>
              <tr>
                <td>Premium chase · Daw Hla</td>
                <td>Aye Chan</td>
                <td>Servicing</td>
                <td>10-Aug-2026</td>
                <td><span className="pill warn">Pending</span></td>
              </tr>
              <tr>
                <td>LC Training follow-up</td>
                <td>Nwe Nwe</td>
                <td>Recruitment</td>
                <td>08-Aug-2026</td>
                <td><span className="pill warn">Pending</span></td>
              </tr>
              <tr>
                <td>NRC correction</td>
                <td>Aye Chan</td>
                <td>e-App</td>
                <td>02-Aug-2026</td>
                <td><span className="pill ok">Completed</span></td>
              </tr>
            </tbody>
          </table>
        </div>
        {showForm && (
          <div className="card">
            <h3>Add / manage task</h3>
            <div className="field">
              <label>Title *</label>
              <input defaultValue="Interview · Su Su" />
            </div>
            <div className="field">
              <label>Assignee FA</label>
              <select defaultValue="Aye Chan">
                <option>Aye Chan</option>
                <option>Nwe Nwe</option>
              </select>
            </div>
            <div className="field">
              <label>Type</label>
              <select defaultValue="Recruitment">
                <option>Recruitment</option>
                <option>Servicing</option>
                <option>e-App</option>
                <option>Other</option>
              </select>
            </div>
            <div className="field">
              <label>Due date</label>
              <input type="date" defaultValue="2026-08-06" />
            </div>
            <div className="field">
              <label>Status</label>
              <select defaultValue="In Progress">
                <option>Pending</option>
                <option>In Progress</option>
                <option>Completed</option>
              </select>
            </div>
            <div className="field">
              <label>Onboarding link (recruitment)</label>
              <select>
                <option>Screening</option>
                <option>LC Training</option>
                <option>Pre-Contracted</option>
                <option>Contracted</option>
              </select>
            </div>
            <div className="row-btns">
              <button className="btn btn-primary" type="button">
                Save task
              </button>
              <button className="btn btn-ghost" type="button" onClick={() => setShowForm(false)}>
                Close
              </button>
            </div>
          </div>
        )}
      </div>
    </div>
  )
}
