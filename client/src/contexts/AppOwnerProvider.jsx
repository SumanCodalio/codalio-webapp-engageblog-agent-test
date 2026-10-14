import React, { useEffect, useState, createContext } from 'react';
import { useModelShow, useAuth } from '@rhino-dev/rhino-react';

export const AppOwnerProvider = ({ children }) => {
  const { isAuthenticated, setOrganization } = useAuth();
  const [resolving, setResolving] = useState(true);

  const { isSuccess, isInitialLoading, resource: account } = useModelShow('account', null, { queryOptions: { enabled: !!isAuthenticated } });

  useEffect(() => {
    if (!isAuthenticated) {
      setOrganization(null);
      setResolving(false);
      return;
    }
    if (isInitialLoading) return;
    if (!isSuccess || !account) {
      setResolving(false);
      return;
    }
    const roles = account.user_roles ?? account.users_roles ?? [];
    const org = roles[0]?.organization ?? null;
    
    // In v4, we use setOrganization to set the slug in storage
    if (org && org.id) {
      setOrganization(org.id.toString());
    } else {
      setOrganization(null);
    }
    setResolving(false);
  }, [isAuthenticated, isSuccess, isInitialLoading, account, setOrganization]);

  if (!isAuthenticated) return <>{children}</>;
  if (resolving) return null;

  return <>{children}</>;
};
