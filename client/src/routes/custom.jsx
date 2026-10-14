import React from 'react';
import { Route, Navigate, Outlet } from 'react-router-dom';
import { AppOwnerProvider } from '../contexts/AppOwnerProvider';
import Layout from '../components/Layout';

const AuthenticatedRoute = ({ children }) => <>{children}</>;

import Landing from '../pages/Landing';
import Login from '../pages/Login';
import CreatePost from '../pages/CreatePost';
import MediaLibrary from '../pages/MediaLibrary';
import Analytics from '../pages/Analytics';
import Admin from '../pages/Admin';
import AdminUsers from '../pages/AdminUsers';
import AdminApiIntegrations from '../pages/AdminApiIntegrations';
import AdminSystemSettings from '../pages/AdminSystemSettings';
import AdminSystemReports from '../pages/AdminSystemReports';

export const customRoutes = () => [
  <Route key="layout" element={<AppOwnerProvider><Layout /></AppOwnerProvider>}>
    <Route path="/" element={<Landing />} />
    <Route path="/login" element={<Login />} />
    <Route element={<AuthenticatedRoute><Outlet /></AuthenticatedRoute>}>
      <Route path="/create-post" element={<CreatePost />} />
      <Route path="/media-library" element={<MediaLibrary />} />
      <Route path="/analytics" element={<Analytics />} />
      <Route path="/admin" element={<Admin />} />
      <Route path="/admin/users" element={<AdminUsers />} />
      <Route path="/admin/api-integrations" element={<AdminApiIntegrations />} />
      <Route path="/admin/system-settings" element={<AdminSystemSettings />} />
      <Route path="/admin/system-reports" element={<AdminSystemReports />} />
    </Route>
    <Route path="*" element={<Navigate to="/" replace />} />
  </Route>,
];
