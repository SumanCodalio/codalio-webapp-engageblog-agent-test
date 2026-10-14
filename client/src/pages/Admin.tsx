// @ts-nocheck
// @ts-nocheck
import React from 'react';
import { useQuery } from '@tanstack/react-query';
import { api, useOrganization } from '@rhino-dev/rhino-react';
import AdminVendored from './Admin.vendored';

export default function Admin() {
  const organization = useOrganization();

  const { data, isLoading } = useQuery({
    queryKey: ['system_summary', organization],
    queryFn: async () => {
      const res = await api.get('/api/admin/system_summary');
      return res.data;
    }
  });

  if (isLoading) return <div className="p-8">Loading admin dashboard...</div>;

  return (
    <AdminVendored systemSummary={data} />
  );
}
