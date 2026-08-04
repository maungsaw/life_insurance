import { useState } from 'react'

export function CrmPage() {
  const [tab, setTab] = useState<'leads' | 'clients'>('leads')
  return (
    <div>
      <h1 className="page-title">CRM</h1>
      <p className="page-sub">FR-03 on web · portfolio Leads vs Clients · owner FA · convert after policy issuance</p>
      <div className="seg">
        <button type="button" className={tab === 'leads' ? 'on' : ''} onClick={() => setTab('leads')}>
          Leads
        </button>
        <button type="button" className={tab === 'clients' ? 'on' : ''} onClick={() => setTab('clients')}>
          Clients
        </button>
      </div>

      {tab === 'leads' ? (
        <div className="card table-wrap">
          <div className="row-btns">
            <button className="btn btn-primary" type="button">
              + Add lead
            </button>
          </div>
          <table className="data">
            <thead>
              <tr>
                <th>Lead</th>
                <th>Mobile</th>
                <th>Stage</th>
                <th>Owner FA</th>
                <th>Quotes/Apps</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>Maung Soe</td>
                <td>09 771 888 999</td>
                <td><span className="pill warn">Quoted</span></td>
                <td>Aye Chan</td>
                <td>1 quote · draft app</td>
                <td><button className="linkish" type="button">Open</button></td>
              </tr>
              <tr>
                <td>Yu Hlaing</td>
                <td>09 250 444 555</td>
                <td><span className="pill">Contacted</span></td>
                <td>Nwe Nwe</td>
                <td>—</td>
                <td><button className="linkish" type="button">Open</button></td>
              </tr>
            </tbody>
          </table>
        </div>
      ) : (
        <div className="card table-wrap">
          <table className="data">
            <thead>
              <tr>
                <th>Client</th>
                <th>Policies</th>
                <th>Next due</th>
                <th>Owner FA</th>
                <th>Family</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>Daw Hla</td>
                <td>2 active · 1 lapsed</td>
                <td>10-Aug-2026</td>
                <td>Aye Chan</td>
                <td>2 contacts</td>
                <td><button className="linkish" type="button">Open</button></td>
              </tr>
              <tr>
                <td>Maung Soe</td>
                <td>1 active (new)</td>
                <td>03-Sep-2026</td>
                <td>Aye Chan</td>
                <td>—</td>
                <td><button className="linkish" type="button">Converted</button></td>
              </tr>
            </tbody>
          </table>
        </div>
      )}
    </div>
  )
}
