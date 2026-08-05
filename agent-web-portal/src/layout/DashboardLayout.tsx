import { Outlet } from 'react-router-dom'
import { DashboardFilterProvider } from '@/dashboard/DashboardFilters'

/** Keeps weighting/hierarchy context when switching Overview ↔ Team Performance */
export function DashboardLayout() {
  return (
    <DashboardFilterProvider>
      <Outlet />
    </DashboardFilterProvider>
  )
}
