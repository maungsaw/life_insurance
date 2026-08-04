export function RecruitPage() {
  return (
    <div>
      <h1 className="page-title">Recruitment</h1>
      <p className="page-sub">Candidate pipeline · onboarding status · tasks linked to FR-07</p>
      <div className="pipe">
        <div className="col"><h4>Screening</h4><div className="mini">7</div></div>
        <div className="col"><h4>LC Training</h4><div className="mini">4</div></div>
        <div className="col"><h4>Pre-Contracted</h4><div className="mini">3</div></div>
        <div className="col"><h4>Contracted</h4><div className="mini">2</div></div>
        <div className="col"><h4>Active FA</h4><div className="mini">1</div></div>
      </div>
      <div className="card table-wrap">
        <table className="data">
          <thead>
            <tr>
              <th>Candidate</th>
              <th>Mobile</th>
              <th>Sponsor</th>
              <th>Stage</th>
              <th>Next task</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>Su Su</td>
              <td>09 250 111 222</td>
              <td>Aye Chan</td>
              <td><span className="pill">LC Training</span></td>
              <td>Interview · 06-Aug</td>
            </tr>
            <tr>
              <td>Ko Min</td>
              <td>09 777 333 111</td>
              <td>Nwe Nwe</td>
              <td><span className="pill warn">Screening</span></td>
              <td>Docs check</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  )
}
