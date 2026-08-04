export function PoliciesPage() {
  return (
    <div>
      <h1 className="page-title">Policies / Sales process</h1>
      <p className="page-sub">FR-03 spine on web: Lead → Quote → e-App → Approved → Client → Active/Lapsed policy</p>
      <div className="pipe">
        <div className="col"><h4>Leads</h4><div className="mini">18 open</div></div>
        <div className="col"><h4>Quoted</h4><div className="mini">6</div></div>
        <div className="col"><h4>e-Apps</h4><div className="mini">11 in flight</div></div>
        <div className="col"><h4>Approved</h4><div className="mini">4 this week</div></div>
        <div className="col"><h4>Policies</h4><div className="mini">Active 4,812</div></div>
      </div>
      <div className="card table-wrap">
        <table className="data">
          <thead>
            <tr>
              <th>Policy</th>
              <th>Client</th>
              <th>Product</th>
              <th>SI</th>
              <th>Premium</th>
              <th>Next due</th>
              <th>Status</th>
              <th>FA</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>POL-88421</td>
              <td>Daw Hla</td>
              <td>Endowment</td>
              <td>10,000,000.00</td>
              <td>185,000.00</td>
              <td>10-Aug-2026</td>
              <td><span className="pill ok">Active</span></td>
              <td>Aye Chan</td>
            </tr>
            <tr>
              <td>POL-70011</td>
              <td>Daw Hla</td>
              <td>Term</td>
              <td>5,000,000.00</td>
              <td>—</td>
              <td>—</td>
              <td><span className="pill danger">Lapsed</span></td>
              <td>Aye Chan</td>
            </tr>
            <tr>
              <td>POL-88499</td>
              <td>Maung Soe</td>
              <td>Endowment</td>
              <td>10,000,000.00</td>
              <td>185,000.00</td>
              <td>03-Sep-2026</td>
              <td><span className="pill ok">Active</span></td>
              <td>Aye Chan</td>
            </tr>
          </tbody>
        </table>
      </div>
      <p className="note" style={{ marginTop: 12 }}>
        Policy detail is read-only from Core (SI, beneficiary, premium, next due). CRM convert history remains on client
        record.
      </p>
    </div>
  )
}
