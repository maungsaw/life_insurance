import './auth.css'
import { Link, useNavigate } from 'react-router-dom'
import { useAuth } from '../auth/AuthContext'

export function OtpPage() {
  const nav = useNavigate()
  const { login } = useAuth()
  return (
    <div className="auth-wrap">
      <div className="auth-card">
        <Link className="back" to="/login">
          ← Back
        </Link>
        <h1>Enter OTP</h1>
        <p>Sent to 09 771 234 567 · expires in 5:00</p>
        <div className="otp-row">
          {['4', '8', '2', '1'].map((d, i) => (
            <input key={i} defaultValue={d} maxLength={1} />
          ))}
        </div>
        <button
          className="btn btn-primary"
          style={{ width: '100%' }}
          type="button"
          onClick={() => {
            login()
            nav('/dashboard')
          }}
        >
          Verify & open portal
        </button>
      </div>
    </div>
  )
}
