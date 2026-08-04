export function AnnouncePage() {
  return (
    <div>
      <h1 className="page-title">Announcements</h1>
      <p className="page-sub">FR-09 · title · image · URL · audience · publish history</p>
      <div className="grid-2">
        <div className="card">
          <h3>Create announcement</h3>
          <div className="field">
            <label>Title *</label>
            <input defaultValue="Q3 Incentive Push" />
          </div>
          <div className="field">
            <label>Image</label>
            <input type="file" accept="image/*" />
          </div>
          <div
            style={{
              height: 120,
              borderRadius: 12,
              background: 'linear-gradient(135deg,#00A6FB,#003554)',
              marginBottom: 12,
            }}
          />
          <div className="field">
            <label>URL</label>
            <input defaultValue="https://kbzlife.com/q3-incentive" />
          </div>
          <div className="field">
            <label>Audience</label>
            <select>
              <option>All FAs (Yangon)</option>
              <option>Managers only</option>
              <option>District A</option>
            </select>
          </div>
          <div className="row-btns">
            <button className="btn btn-secondary" type="button">
              Save draft
            </button>
            <button className="btn btn-primary" type="button">
              Publish
            </button>
          </div>
        </div>
        <div className="card table-wrap">
          <h3>History</h3>
          <table className="data">
            <thead>
              <tr>
                <th>Title</th>
                <th>Status</th>
                <th>Published</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>Q3 Incentive Push</td>
                <td><span className="pill ok">Live</span></td>
                <td>01-Aug-2026</td>
              </tr>
              <tr>
                <td>NIIM exam reminder</td>
                <td><span className="pill">Draft</span></td>
                <td>—</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  )
}
