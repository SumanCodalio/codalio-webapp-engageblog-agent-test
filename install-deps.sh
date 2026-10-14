#!/bin/bash
cd client
# Read deps from prototype
PROTOTYPE_DEPS=$(cat ../.codalio/ui-prototype/package.json | grep -E '"[^"]+":' | awk '{print $1}' | tr -d '"' | grep -v 'react$' | grep -v 'react-dom$' | grep -v 'react-router-dom$' | tr '\n' ' ')
npm install --legacy-peer-deps --no-audit --no-fund $PROTOTYPE_DEPS
# Install Tailwind v4
npm install --legacy-peer-deps --no-audit --no-fund tailwindcss @tailwindcss/vite
