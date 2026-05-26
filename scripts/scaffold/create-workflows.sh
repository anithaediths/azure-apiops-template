#!/bin/bash

# create-workflows.sh - Create GitHub Actions workflow files

set -e

echo "Creating GitHub Actions workflows..."
echo ""

mkdir -p .github/workflows

# Create validation workflow
cat > .github/workflows/validate.yml << 'EOF'
name: Validate and Test

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.10'
      
      - name: Cache dependencies
        uses: actions/cache@v3
        with:
          path: ~/.cache/pip
          key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements.txt') }}
      
      - name: Install dependencies
        run: pip install -r requirements.txt
      
      - name: Format check
        run: bash scripts/format.sh --check || true
      
      - name: Lint
        run: bash scripts/lint.sh || true
      
      - name: Type check
        run: bash scripts/type-check.sh || true
      
      - name: Run tests
        run: bash scripts/run-tests.sh
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        if: always()
EOF

echo -e "\033[0;32m✓\033[0m Created validate workflow"

# Create deploy workflow
cat > .github/workflows/deploy.yml << 'EOF'
name: Deploy to Azure

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.10'
      
      - name: Install dependencies
        run: pip install -r requirements.txt
      
      - name: Run tests
        run: bash scripts/run-tests.sh
      
      - name: Azure Login
        uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}
      
      - name: Deploy
        run: bash scripts/deploy.sh
        env:
          AZURE_SUBSCRIPTION_ID: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
          AZURE_TENANT_ID: ${{ secrets.AZURE_TENANT_ID }}
EOF

echo -e "\033[0;32m✓\033[0m Created deploy workflow"

echo ""
