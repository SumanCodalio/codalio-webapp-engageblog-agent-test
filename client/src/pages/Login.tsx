// @ts-nocheck
// @ts-nocheck
import React from 'react';
import { useAuth } from '@rhino-dev/rhino-react';
import LoginVendored from './Login.vendored';
import { useNavigate } from 'react-router-dom';

export default function Login() {
  const { login } = useAuth();
  const navigate = useNavigate();

  const handleLogin = async (email, password) => {
    try {
      const result = await login(email, password);
      if (!result.success) {
        throw new Error(result.error || 'Login failed');
      }
    } catch (e) {
      console.error('Login failed', e);
      throw e;
    }
  };

  return <LoginVendored onLogin={handleLogin} />;
}
