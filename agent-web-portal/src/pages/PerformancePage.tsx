export function PerformancePage() {
  return (
    <div>
      <h1 className="page-title">Performance</h1>
      <p className="page-sub">Hierarchical filters · FA line production · persistency · Export Excel</p>
      <div className="filters">
        <label>
          Region
          <select defaultValue="Yangon">
            <option>Yangon</option>
            <option>Mandalay</option>
          </select>
        </label>
        <label>
          District
          <select>
            <option>District A</option>
          </select>
        </label>
        <label>
          SAM
          <select>
            <option>All</option>
          </select>
        </label>
        <label>
          AM
          <select>
            <option>All</option>
          </select>
        </label>
        <button className="btn btn-primary" type="button" onClick={() => alert('Export Excel (mock)')}>
          Export Excel
        </button>
      </div>
      <div className="card table-wrap">
        <table className="data">
          <thead>
            <tr>
              <th>FA</th>
              <th>APE</th>
              <th>FYP</th>
              <th>SFYP</th>
              <th>Wtd Freelance FYP</th>
              <th>MDRT</th>
              <th>K1/K2</th>
              <th>Flag</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>Thura Htun</td>
              <td>4,200,000.00</td>
              <td>5,100,000.00</td>
              <td>980,000.00</td>
              <td>3,400,000.00</td>
              <td>41.0M</td>
              <td>90/86</td>
              <td><span className="pill ok">OK</span></td>
            </tr>
            <tr>
              <td>Zaw Ko</td>
              <td>780,000.00</td>
              <td>820,000.00</td>
              <td>90,000.00</td>
              <td>600,000.00</td>
              <td>8.2M</td>
              <td>70/65</td>
              <td><span className="pill danger">Below target</span></td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  )
}
