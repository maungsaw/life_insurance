export function AgentsPage() {
  return (
    <div>
      <h1 className="page-title">Agents / Audit</h1>
      <p className="page-sub">FR-12 · agent master data · status changes · audit trail</p>
      <div className="card table-wrap" style={{ marginBottom: 14 }}>
        <h3>Agent directory</h3>
        <table className="data">
          <thead>
            <tr>
              <th>Code</th>
              <th>Name</th>
              <th>Role</th>
              <th>Mobile</th>
              <th>Status</th>
              <th>District</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>AGT-10284</td>
              <td>Aye Chan</td>
              <td>FA</td>
              <td>09 771 234 567</td>
              <td><span className="pill ok">Active</span></td>
              <td>Yangon A</td>
            </tr>
            <tr>
              <td>AGT-11002</td>
              <td>Zaw Ko</td>
              <td>FA</td>
              <td>09 988 111 222</td>
              <td><span className="pill warn">LC Training</span></td>
              <td>Yangon A</td>
            </tr>
          </tbody>
        </table>
      </div>
      <div className="card table-wrap">
        <h3>Audit log</h3>
        <table className="data">
          <thead>
            <tr>
              <th>Action</th>
              <th>Previous</th>
              <th>New</th>
              <th>User</th>
              <th>When</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>Update mobile</td>
              <td>09 771 234 567</td>
              <td>09 988 111 222</td>
              <td>Ops May</td>
              <td>03-Aug-2026 09:12</td>
            </tr>
            <tr>
              <td>Status change</td>
              <td>Pre-Contracted</td>
              <td>LC Training</td>
              <td>Alliance</td>
              <td>02-Aug-2026 16:40</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  )
}
