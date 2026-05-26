#!/bin/bash

# validate-scaffold.sh - Validate that all generated files are in place

set -e

echo "Validating generated project structure..."
echo ""

ERRORS=0
WARNINGS=0

# Check if scaffold was run
if [ ! -d "projects" ]; then
    echo -e "\033[0;31m✗ Error: projects/ directory not found\033[0m"
    echo "  Run: bash scripts/scaffold.sh --project-name <name> --org-name <org>"
    ERRORS=$((ERRORS + 1))
else
    echo -e "\033[0;32m✓\033[0m projects/ directory found"
fi

# Check source code
if [ ! -d "src" ] || [ -z "$(ls -A src/)" ]; then
    echo -e "\033[1;33m⚠ Warning: src/ directory empty or missing\033[0m"
    WARNINGS=$((WARNINGS + 1))
else
    echo -e "\033[0;32m✓\033[0m src/ directory structure created"
fi

# Check documentation
if [ ! -d "docs" ] || [ -z "$(ls -A docs/)" ]; then
    echo -e "\033[1;33m⚠ Warning: docs/ directory empty or missing\033[0m"
    WARNINGS=$((WARNINGS + 1))
else
    echo -e "\033[0;32m✓\033[0m docs/ directory structure created"
fi

# Check .env.example
if [ ! -f ".env.example" ]; then
    echo -e "\033[0;31m✗ Error: .env.example not found\033[0m"
    ERRORS=$((ERRORS + 1))
else
    echo -e "\033[0;32m✓\033[0m .env.example created"
fi

# Check GitHub workflows
if [ ! -d ".github/workflows" ] || [ -z "$(ls -A .github/workflows/)" ]; then
    echo -e "\033[1;33m⚠ Warning: GitHub workflows not created\033[0m"
    WARNINGS=$((WARNINGS + 1))
else
    WORKFLOW_COUNT=$(ls .github/workflows/*.yml 2>/dev/null | wc -l)
    echo -e "\033[0;32m✓\033[0m GitHub workflows created ($WORKFLOW_COUNT files)"
fi

echo ""
echo "Summary:"
echo "  Errors: $ERRORS"
echo "  Warnings: $WARNINGS"
echo ""

if [ $ERRORS -gt 0 ]; then
    echo -e "\033[0;31mValidation failed!\033[0m"
    exit 1
else
    echo -e "\033[0;32mValidation passed!\033[0m"
    exit 0
fi
