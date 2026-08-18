import { Navigate, Route, Routes } from 'react-router-dom'
import type { ReactNode } from 'react'
import { AuthProvider, useAuth } from '@/auth/AuthContext'
import { HomeRedirect, RequireAdmin, RequireBook, RequireUsers, RequireWipe } from '@/auth/RequireCap'
import { LoginPage } from '@/pages/LoginPage'
import { OtpPage } from '@/pages/OtpPage'
import { ForgotPage } from '@/pages/ForgotPage'
import { AppShell } from '@/layout/AppShell'
import { DashboardLayout } from '@/layout/DashboardLayout'
import { DashOverviewPage } from '@/pages/DashOverviewPage'
import { DashTeamPerformancePage } from '@/pages/DashTeamPerformancePage'
import { TasksPage } from '@/pages/TasksPage'
import { MgmtResourcesPage } from '@/pages/MgmtResourcesPage'
import { MgmtNotificationPage } from '@/pages/MgmtNotificationPage'
import { MgmtAnnouncementPage } from '@/pages/MgmtAnnouncementPage'
import { MgmtDevicesPage } from '@/pages/MgmtDevicesPage'
import { CatalogProvider } from '@/data/CatalogContext'
import { AccessProvider } from '@/data/AccessContext'
import { RoleSetupPage } from '@/pages/RoleSetupPage'
import { PermissionsPage } from '@/pages/PermissionsPage'
import { PeopleNewPage } from '@/pages/PeopleNewPage'
import { MgmtProductsPage } from '@/pages/MgmtProductsPage'
import { MgmtProductSetupPage } from '@/pages/MgmtProductSetupPage'
import { AuditPage } from '@/pages/AuditPage'
import { NotificationsPage } from '@/pages/NotificationsPage'
import { ProfilePage } from '@/pages/ProfilePage'
import { ChangePasswordPage } from '@/pages/ChangePasswordPage'
import { CrmCustomersPage } from '@/pages/CrmCustomersPage'
import { CrmCustomerDetailPage } from '@/pages/CrmCustomerDetailPage'
import { EappsPage } from '@/pages/EappsPage'
import { EappDetailPage } from '@/pages/EappDetailPage'
import { UsersPage } from '@/pages/UsersPage'
import { UserDetailPage } from '@/pages/UserDetailPage'
import { RolesPage } from '@/pages/RolesPage'

function Private({ children }: { children: ReactNode }) {
  const { authed } = useAuth()
  if (!authed) return <Navigate to="/login" replace />
  return children
}

export default function App() {
  return (
    <AuthProvider>
      <CatalogProvider>
      <AccessProvider>
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
          <Route index element={<HomeRedirect />} />
          <Route path="dashboard" element={<DashboardLayout />}>
            <Route index element={<Navigate to="overview" replace />} />
            <Route path="overview" element={<DashOverviewPage />} />
            <Route path="team-performance" element={<DashTeamPerformancePage />} />
          </Route>
          <Route path="performance" element={<Navigate to="/dashboard/team-performance" replace />} />
          <Route path="crm" element={<Navigate to="/crm/customers" replace />} />
          <Route
            path="crm/customers"
            element={
              <RequireBook>
                <CrmCustomersPage />
              </RequireBook>
            }
          />
          <Route
            path="crm/customers/:id"
            element={
              <RequireBook>
                <CrmCustomerDetailPage />
              </RequireBook>
            }
          />
          <Route
            path="eapps"
            element={
              <RequireBook>
                <EappsPage />
              </RequireBook>
            }
          />
          <Route
            path="eapps/:id"
            element={
              <RequireBook>
                <EappDetailPage />
              </RequireBook>
            }
          />
          <Route path="policies" element={<Navigate to="/crm/customers" replace />} />
          <Route path="tasks" element={<TasksPage />} />
          <Route path="recruit" element={<Navigate to="/tasks" replace />} />
          <Route path="management" element={<Navigate to="/management/resources" replace />} />
          <Route
            path="management/resources"
            element={
              <RequireAdmin>
                <MgmtResourcesPage />
              </RequireAdmin>
            }
          />
          <Route
            path="management/notifications"
            element={
              <RequireAdmin>
                <MgmtNotificationPage />
              </RequireAdmin>
            }
          />
          <Route
            path="management/announcements"
            element={
              <RequireAdmin>
                <MgmtAnnouncementPage />
              </RequireAdmin>
            }
          />
          <Route
            path="management/products"
            element={
              <RequireAdmin>
                <MgmtProductsPage />
              </RequireAdmin>
            }
          />
          <Route
            path="management/products/new"
            element={
              <RequireAdmin>
                <MgmtProductSetupPage />
              </RequireAdmin>
            }
          />
          <Route
            path="management/products/:id"
            element={
              <RequireAdmin>
                <MgmtProductSetupPage />
              </RequireAdmin>
            }
          />
          <Route
            path="management/devices"
            element={
              <RequireWipe>
                <MgmtDevicesPage />
              </RequireWipe>
            }
          />
          <Route path="announce" element={<Navigate to="/management/announcements" replace />} />
          <Route path="ops" element={<Navigate to="/management/resources" replace />} />
          <Route
            path="audit"
            element={
              <RequireAdmin>
                <AuditPage />
              </RequireAdmin>
            }
          />
          <Route path="agents" element={<Navigate to="/audit" replace />} />
          <Route path="audit/lookup" element={<Navigate to="/crm/customers" replace />} />
          <Route path="audit/queue" element={<Navigate to="/eapps" replace />} />
          <Route path="users" element={<Navigate to="/users/people" replace />} />
          <Route
            path="users/people"
            element={
              <RequireUsers>
                <UsersPage />
              </RequireUsers>
            }
          />
          <Route
            path="users/people/new"
            element={
              <RequireUsers>
                <PeopleNewPage />
              </RequireUsers>
            }
          />
          <Route
            path="users/roles/new"
            element={
              <RequireUsers>
                <RoleSetupPage />
              </RequireUsers>
            }
          />
          <Route
            path="users/roles/:id"
            element={
              <RequireUsers>
                <RoleSetupPage />
              </RequireUsers>
            }
          />
          <Route
            path="users/roles"
            element={
              <RequireUsers>
                <RolesPage />
              </RequireUsers>
            }
          />
          <Route
            path="users/permissions"
            element={
              <RequireUsers>
                <PermissionsPage />
              </RequireUsers>
            }
          />
          <Route
            path="users/:id"
            element={
              <RequireUsers>
                <UserDetailPage />
              </RequireUsers>
            }
          />
          <Route path="notifications" element={<NotificationsPage />} />
          <Route path="profile" element={<ProfilePage />} />
          <Route path="profile/password" element={<ChangePasswordPage />} />
        </Route>
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
      </AccessProvider>
      </CatalogProvider>
    </AuthProvider>
  )
}
