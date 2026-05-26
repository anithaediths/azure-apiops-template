#!/bin/bash

# init-project.sh - Initialize a new API Operations project
# Comprehensive setup script for setting up everything at once

set -e

echo ""
echo "================================================"
echo "Azure API Operations - Project Initialization"
echo "================================================"
echo ""

# Check if this is a new project or existing
if [ -d ".git" ]; then
    echo "Git repository detected."
else
    echo "Initializing Git repository..."
    git init
    echo ""
fi

# Run scaffold
echo "Generating project scaffold..."
bash scripts/scaffold.sh "$@"

echo ""
echo "Project initialization complete!"
echo ""
