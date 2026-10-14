// @ts-nocheck
// @ts-nocheck
import React from 'react';
import { useModelIndex, useModelStore, useModelUpdate, useModelDelete, useOrganization } from '@rhino-dev/rhino-react';
import AdminUsersVendored from './AdminUsers.vendored';

export default function AdminUsers() {
  const { data: usersData, isPending } = useModelIndex('user');
  const createUser = useModelStore('user');
  const updateUser = useModelUpdate('user');
  const destroyUser = useModelDelete('user');
  const organization = useOrganization();

  if (isPending) return <div className="p-8">Loading users...</div>;

  const uiUsers = (usersData?.data || []).map((u) => ({
    id: u.id.toString(),
    name: u.name || `${u.first_name || ''} ${u.last_name || ''}`.trim() || u.email,
    email: u.email,
    role: u.users_roles?.[0]?.role?.name || "Editor",
    status: u.approved ? "Active" : "Inactive",
    lastActive: "Just now",
    avatar: "https://api.dicebear.com/7.x/avataaars/svg?seed=" + u.email,
  }));

  const handleCreateUser = async (data) => {
    try {
      // Create user requires a password in the backend, we mock it here since UI might not ask for it.
      await createUser.mutateAsync({
        email: data.email,
        first_name: data.name.split(' ')[0],
        last_name: data.name.split(' ').slice(1).join(' '),
        password: "Password123!", 
        organization_id: organization,
        approved: true
      });
    } catch(e) {
      console.error(e);
      throw e;
    }
  };

  const handleUpdateUser = async (id, data) => {
    try {
      await updateUser.mutateAsync({ id, ...data });
    } catch(e) {
      console.error(e);
      throw e;
    }
  };

  const handleDeleteUser = async (id) => {
    try {
      await destroyUser.mutateAsync(id);
    } catch(e) {
      console.error(e);
      throw e;
    }
  };

  return (
    <AdminUsersVendored
      initialUsers={uiUsers}
      onCreateUser={handleCreateUser}
      onUpdateUser={handleUpdateUser}
      onDestroyUser={handleDeleteUser}
    />
  );
}
