// @ts-nocheck
import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.tsx'

try {
  createRoot(document.getElementById('root')!).render(
    <StrictMode>
      <App />
    </StrictMode>,
  )
} catch (error) {
  document.getElementById('root')!.innerHTML = `
    <div style="padding: 20px; font-family: sans-serif; color: red;">
      <h2>Application Failed to Start</h2>
      <pre>${error.stack || error.message}</pre>
    </div>
  `;
}
