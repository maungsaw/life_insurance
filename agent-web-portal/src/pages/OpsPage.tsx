export function OpsPage() {
  return (
    <div>
      <h1 className="page-title">Operations</h1>
      <p className="page-sub">Notification rules · resource library · broadcast helpers</p>
      <div className="grid-2">
        <div className="card">
          <h3>Notification rules</h3>
          <div className="field">
            <label>Premium due reminder</label>
            <select defaultValue="7 days before">
              <option>3 days before</option>
              <option>7 days before</option>
              <option>14 days before</option>
            </select>
          </div>
          <div className="field">
            <label>e-App correction ping</label>
            <select defaultValue="Immediate">
              <option>Immediate</option>
              <option>Daily digest</option>
            </select>
          </div>
          <button className="btn btn-primary" type="button">
            Save rules
          </button>
        </div>
        <div className="card">
          <h3>Resources</h3>
          <p className="note">Upload product sheets / training PDFs for mobile offline cache.</p>
          <div className="row-btns">
            <button className="btn btn-secondary" type="button">
              + Upload file
            </button>
          </div>
          <ul style={{ fontSize: 13, color: 'var(--muted)', paddingLeft: 18, lineHeight: 1.8 }}>
            <li>Endowment brochure.pdf</li>
            <li>NIIM study guide.pdf</li>
            <li>Agency code of conduct.pdf</li>
          </ul>
        </div>
      </div>
    </div>
  )
}
