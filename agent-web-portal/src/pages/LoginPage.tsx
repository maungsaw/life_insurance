import './auth.css'
import { Link, useNavigate } from 'react-router-dom'

export function LoginPage() {
  const nav = useNavigate()
  return (
    <div className="auth-wrap">
      <div className="auth-card">
        <div className="auth-mark">KL</div>
        <h1>KBZ LIFE Agent Portal</h1>
        <p>Same identity as mobile · mobile number + password + OTP</p>
        <div className="field">
          <label>Mobile number</label>
          <input defaultValue="09 771 234 567" />
        </div>
        <div className="field">
          <label>Password</label>
          <input type="password" defaultValue="••••••••" />
        </div>
        <button className="btn btn-primary" style={{ width: '100%' }} type="button" onClick={() => nav('/otp')}>
          Continue
        </button>
        <div className="auth-links">
          <Link to="/forgot">Forgot password</Link>
        </div>
      </div>
    </div>
  )
}
