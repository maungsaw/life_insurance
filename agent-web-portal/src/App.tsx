import { Navigate, Route, Routes } from 'react-router-dom'
import type { ReactNode } from 'react'
import { AuthProvider, useAuth } from '@/auth/AuthContext'
import { LoginPage } from '@/pages/LoginPage'
import { OtpPage } from '@/pages/OtpPage'
import { ForgotPage } from '@/pages/ForgotPage'
import { AppShell } from '@/layout/AppShell'
import { DashboardPage } from '@/pages/DashboardPage'
import { PerformancePage } from '@/pages/PerformancePage'
import { CrmPage } from '@/pages/CrmPage'
import { PoliciesPage } from '@/pages/PoliciesPage'
import { TasksPage } from '@/pages/TasksPage'
import { RecruitPage } from '@/pages/RecruitPage'
import { AnnouncePage } from '@/pages/AnnouncePage'
import { OpsPage } from '@/pages/OpsPage'
import { AgentsPage } from '@/pages/AgentsPage'

function Private({ children }: { children: ReactNode }) {
  const { authed } = useAuth()
  if (!authed) return <Navigate to="/login" replace />
  return children
}

export default function App() {
  return (
    <AuthProvider>
      <Routes>
        <Route path="/login" element={<LoginPage />} />
        <Route path="/otp" element={<OtpPage />} />
        <Route path="/forgot" element={<ForgotPage />} />
        <Route
          path="/"
          element={
            <Private>
              <AppShell />
            </Private>
          }
        >
          <Route index element={<Navigate to="/dashboard" replace />} />
          <Route path="dashboard" element={<DashboardPage />} />
          <Route path="performance" element={<PerformancePage />} />
          <Route path="crm" element={<CrmPage />} />
          <Route path="policies" element={<PoliciesPage />} />
          <Route path="tasks" element={<TasksPage />} />
          <Route path="recruit" element={<RecruitPage />} />
          <Route path="announce" element={<AnnouncePage />} />
          <Route path="ops" element={<OpsPage />} />
          <Route path="agents" element={<AgentsPage />} />
        </Route>
        <Route path="*" element={<Navigate to="/dashboard" replace />} />
      </Routes>
    </AuthProvider>
  )
}
