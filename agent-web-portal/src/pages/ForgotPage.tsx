import './auth.css'
import { Link, useNavigate } from 'react-router-dom'

export function ForgotPage() {
  const nav = useNavigate()
  return (
    <div className="auth-wrap">
      <div className="auth-card">
        <Link className="back" to="/login">
          ← Back
        </Link>
        <h1>Reset password</h1>
        <p>OTP + remark required (aligned with mobile)</p>
        <div className="field">
          <label>Reason / remark *</label>
          <textarea rows={2} defaultValue="Forgot after device change" />
        </div>
        <div className="field">
          <label>New password</label>
          <input type="password" defaultValue="••••••••" />
        </div>
        <button className="btn btn-primary" style={{ width: '100%' }} type="button" onClick={() => nav('/login')}>
          Update & return
        </button>
      </div>
    </div>
  )
}
