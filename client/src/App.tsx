// @ts-nocheck
import React from 'react';
import { BrowserRouter, Routes } from 'react-router-dom';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { AuthProvider, configureApi } from '@rhino-dev/rhino-react';
import { customRoutes } from './routes/custom';
import './index.css';

// Configure Rhino API
configureApi({
  baseURL: import.meta.env.VITE_API_URL || '/api',
  tenancy: 'path'
});

const queryClient = new QueryClient();

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <AuthProvider tenancy="path">
        <BrowserRouter>
          <Routes>
            {customRoutes()}
          </Routes>
        </BrowserRouter>
      </AuthProvider>
    </QueryClientProvider>
  );
}

export default App;
